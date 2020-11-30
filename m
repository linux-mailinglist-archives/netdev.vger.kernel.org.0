Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38DF2C8F22
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgK3U1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgK3U1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:27:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EC8C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:26:29 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b2so5915676edy.13
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VZ91AD9a8KB2t44DjmgIujBvV7lH7SAq0CPsyQ5BDYE=;
        b=Y08zZ0o58RFPH/ushSxdUAwglT5skL7ETEJ1fzUauELeVPVsFQDBmY/bHmaM8tyjd5
         e3GPKM4dOKeGTe/camRwLDzsffnXHxtzcvjaKQKmR6mxQMJnJ1A3nbk6gKtowjKOaJZQ
         LsxPZ/gcZc69qHPaDG7RQB3fk2JfSgvNYE87DvVgpa//wHu6kSsqQfvE+JUT8X7cZWfG
         Sr95s3ZYwnTEugTLJx9Db3BqwOQcG5tbhBK1Uesp+zhv+w5CnfsX3t5qgxuS1+1mol03
         ly9lSQgEFhCarw4hZfCeHk3jajKjg1LmhGLDZGMcN9/xoLL2C9vJNgK02+Jl2kMdlYEz
         Imbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VZ91AD9a8KB2t44DjmgIujBvV7lH7SAq0CPsyQ5BDYE=;
        b=O03ONWfVyy97uE06RAR5YQdjzMZ54SL0gRwXRrxTQ4RrBHltKLoOU/nibpoiAXjJd8
         58vIYlkNAAnVfyVTiFuJ/ovwBv+FmZTBHlJhlyGKw4Pd+EJys6BWhRrFKSz0REykcYaQ
         insOGGmN2/xtByGXloPTKwCT+2iNff9febiNVl0OWc4i9eqTYvsggAfcp+S16tyj7wND
         b5Ge2ZGvEwgMh2exFeScm1zyLYDgIYZn6BZI5VnpQL07eDmX8TFKfqTpJXmuAx44+7Aj
         zEJeNwKZX/vQs5aAnFXRAzPASz0Zq72MD9HYWEwOgLJdXRyHm5/vUkJMHZF7X1XqK6rV
         9XNg==
X-Gm-Message-State: AOAM530dcdmzjBlcycrBF9Cyr3YvR4iP06AFE0cNfiIKtbeukqacG7ZI
        z4WaMg7vmQxDbRm46kpN0G4MgvBeOzg=
X-Google-Smtp-Source: ABdhPJxPH2kwfST5LxZ30DMK7tSXn1fs5pi5BbUS1944CllDWAy6BdiAy/HEc5/Zqb8EMV2pfrc13w==
X-Received: by 2002:aa7:ca41:: with SMTP id j1mr24631600edt.295.1606767987935;
        Mon, 30 Nov 2020 12:26:27 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id n22sm9437016edo.43.2020.11.30.12.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 12:26:27 -0800 (PST)
Date:   Mon, 30 Nov 2020 22:26:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130202626.cnwzvzc6yhd745si@skbuf>
References: <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf>
 <20201130122129.21f9a910@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130122129.21f9a910@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 12:21:29PM -0800, Stephen Hemminger wrote:
> if device is in a private list (in bond device), the way to handle
> this is to use dev_hold() to keep a ref count.

Correct, dev_hold is a tool that can also be used. But it is a tool that
does not solve the general problem - only particular ones. See the other
interesting callers of dev_get_stats in parisc, appldata, net_failover.
We can't ignore that RTNL is used for write-side locking forever.

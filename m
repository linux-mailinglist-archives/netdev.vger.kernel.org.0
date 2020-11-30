Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1343F2C8E59
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgK3TrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgK3TrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:47:00 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438A0C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:46:20 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bo9so24061065ejb.13
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NXYIwsReBqOJuhieVm9/vzrHk5zfKbXNmL3BWjOjnGw=;
        b=djbvznHcm5TU9WXvR0yWB+RzFILkOKVH/O1VlMWp5I+W+AznRWPbxR2VDIZiaf2yqf
         EfWpEgIfdhuGDBEFsu6nyrZfdNl4AZyuR7B8EF0bLAD/ixJcYkbg5OsNlYw2SZd/QTBB
         ktddFL/uR/eL+w5v3bgZt5E8p5K16WWMvJCwXj9O9o5Ca5Vt1cXTRWHHWS3u6Dx8Z5ay
         gu9ZUNKJZtwyp+u6tew0f49+K+oBGqyj6lrTTf2tk1Gyn/gZLPShAQEjLV9abauwVvj5
         bBhStgF7wrV28ZripsGiGf3/oKQXK7P7L3M+KR0JiVORrwaHoORJl1VDd65T34iS/H7p
         imuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NXYIwsReBqOJuhieVm9/vzrHk5zfKbXNmL3BWjOjnGw=;
        b=p1zAMG/IbcOPkDa12GVwUhPpnKq1w0lv0OZgWoZsjRaiodRSeh2IhfHXQVVhwLSqIw
         mnsu7tKxuA/vIY8m0AUm/1mOLMnrqh6kDIu0i9fVI4pXPAu/IfexxrK3w21oeLGErBPM
         Z4QH6ZAgzCgkA/o/bzA0iIU+s2gTnjMQ6hyqhpJ9nGIkWQc1h9VNy6eEwtSkj8dvvBVn
         2UgIzPTfKziqLnlXX7RizGjApbd2cSMLzVPtyE1EjX0ow/xDRXmnzZpm5Gvvw/eo5plY
         lHSyGD85cMc4kB7ORrIXQXO78LS9wnCxZI3wCHOaQ02BmlntN1oxKzqZCQCoEiNBj6TJ
         P49Q==
X-Gm-Message-State: AOAM532X4lugXiy+N49fS/1BXEpH/CIeIkuDCJJCZ3nbrHpTCytflw27
        RzzDTfbRhGItUXWVNXRmzHM=
X-Google-Smtp-Source: ABdhPJzbYNOu22Vj03+l7xl03LNyLyQKCkckdZaBDfqf2AgocS4VzcxwLM9ib2I05CBHHKNEHiHyOA==
X-Received: by 2002:a17:906:1f8e:: with SMTP id t14mr2709179ejr.350.1606765578876;
        Mon, 30 Nov 2020 11:46:18 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id a12sm9402561edu.89.2020.11.30.11.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:46:18 -0800 (PST)
Date:   Mon, 30 Nov 2020 21:46:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130194617.kzfltaqccbbfq6jr@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 08:22:01PM +0100, Eric Dumazet wrote:
> And ?
>
> A bonding device can absolutely maintain a private list, ready for
> bonding ndo_get_stats() use, regardless
> of register/unregister logic.
>
> bond_for_each_slave() is simply a macro, you can replace it by something else.

Also, coming to take the comment at face value.
Can it really? How? Freeing a net_device at unregister time happens
after an RCU grace period. So whatever the bonding driver does to keep a
private list of slave devices, those pointers need to be under RCU
protection. And that doesn't help with the sleepable context that we're
looking for.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE595273341
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgIUT4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgIUT4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:56:12 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD57C0613D4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 12:56:11 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g4so14086948edk.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 12:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ePfeVlm/80CWVkmghscu2gSwV4r2AgMZxEiau81s7ns=;
        b=L4iRpAsYqHN5tf9X4BhaFATQIhzzsEeeRm+YaP0AQN4ergC/SiuPPGNxDbA88Wh3j1
         6iTxaflFhzDg9sVMztuWX4Jfjps5VnpS3KLi1lSxigjeSn7ik24urE5cf+aFUA5V39XG
         8FhXRMyFkCqX9ixRdr80wf2PV9kIiZTxvY/vSYbi2GSYi5j508pxEa6ZZO1h/kqY972K
         1MV1vx3Chx3FaytYBI6p4IGl1i8NI2fdRY6QvSkvLIq8SBTyJ+2RCpsBmZQdgz2b8a8B
         TllfGTIvD9burT2tXQJIk8LWqE1gOCSdfB8osl1UgcyoPE28P7rOGxsVy/KE4e+gJ66T
         qKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ePfeVlm/80CWVkmghscu2gSwV4r2AgMZxEiau81s7ns=;
        b=kXPpR9XAYBLaNg+ui1syFZWg5Kjo2YRpFVgKLDrx4/CeIXgK7KSWDIb9NvVM+8u219
         Ket7iHdN+Ppewi5TG54uKj4ZhRYV9GymHVC2CW6sBB2yNFPet9zGSX1bRp5NhO8DNy1o
         q/f4f0Hugb2Zgu6tH3KWBK7DYJh3x/7PqpF27TaTwBJjYh9ZDsckgcP1Ksyd5gqgjn6m
         SYz640Y+c4RxiXyFFNlA/54sOynUHLYkflCfpvsJ0YhS4dG16N3+zol/xIZmbwwgFNrW
         yaDSSTAe9J9ssp/OZceXy8KlLNXnyVaGfqs4lyYksZIIXb4mAVASW2ywhftwjgThwC+H
         C2SA==
X-Gm-Message-State: AOAM530p3botB9ER+jUMbZpZd5gOLEUj0YxLF41waxV8OT5Mr4KGREjh
        5fnOHsUhYUhgqQ5vSQUHtxM=
X-Google-Smtp-Source: ABdhPJx4C1U0bwPlvMRDAnxg86S3L6b6onK42TcMm/b4TMoC8gzOSVvCAtIik4VgbfQLLXVCMEwerg==
X-Received: by 2002:aa7:cf0e:: with SMTP id a14mr553148edy.81.1600718170079;
        Mon, 21 Sep 2020 12:56:10 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id p12sm9668135ejb.42.2020.09.21.12.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 12:56:09 -0700 (PDT)
Date:   Mon, 21 Sep 2020 22:56:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Message-ID: <20200921195607.hb47f6lpk4wzpys4@skbuf>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
 <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
 <315a6f2a1cec945eb35e69c6fdeaf3c2ab3cb25d.camel@nvidia.com>
 <cc20face-ec67-d444-1cf8-f4257dbe1e1c@gmail.com>
 <a322976c-6d47-aae8-32eb-3593f8e3cc10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a322976c-6d47-aae8-32eb-3593f8e3cc10@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 12:44:43PM -0700, Florian Fainelli wrote:
> Vladimir, let me know if you have a patch for DSA and I can give it a
> try quickly. Thanks!

Let me clean it up a little and send it, I need to export a wrapper over
br_get_pvid() for external use, called under rcu_read_lock().

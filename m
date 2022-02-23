Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FA4C1950
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243200AbiBWRF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiBWRFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:36 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040D653B5A
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:05:07 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id q11so9472274pln.11
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/b6WfMnsXYZ00s2c/GvQAhaeUOqRUYQX35Lr5N92Ce0=;
        b=Y9TC5Np6UhOrthaLw72Tmbkmac9ZcnyLYjKjHlfYKYivlqCn60jU6F2GWrzRbTO8M5
         ZlGZUp6KkqzhOWY4U0T+I7nDsvwM018T8tLK+yCiXaUS72m9Mx2vqumZ2ePYDvJ0qhFT
         12JSUAjtl91GU6mJotfNZfezDKxOquWCjOHVarCed6PYMlAlwckhtlSg0gZeWz3XPVgE
         x4SzYOeMzwxIOXF1bW+VVvZjDNxipzxf/c//G78yPwq+ZZ6giviBZ5uCYh7v1qrafwX9
         slhReHlGyY8niuVlLJmYP8z7TfTonDx+N+HLvYf8DPL/aSojJAlcECvf9pYNSa1qtbfS
         JrWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/b6WfMnsXYZ00s2c/GvQAhaeUOqRUYQX35Lr5N92Ce0=;
        b=5YJdbEtsoQqf0OeFQ8TDBnW+zYoYy6SRw+AP63GhbyI7HdfSSgLuZ9Mcqi3xyvqith
         +b8YTPZJFbdrFlkqGpQd/3EbgaR7rKc7zPy2MQB2ZbNUlUTpcy4DaK9QXE4HFjhi3Xp7
         lj33qQ1v4OGmYEXZtgxlQ5IXLqXFYsYab7sV5IURA0NJI0EA4jVo+zyU7BIv8YuGhDwE
         wq672e9fJFEY4xV/XXtm0xWMSH+zQQYIEheLqNj1tnmuLGNaySE5DFqhkVsKM0WcWJYB
         7+mutQ89t5Y8Ej87P995ssY3m9+cQL9iUpiwxvM9ia4wJmlvZmOH2aLup9fBu90uGml/
         DZbQ==
X-Gm-Message-State: AOAM532ucAdNcggoUGdTvgr8MhXlMqjUG1Ba1MIVa56epQPcvEk9us+W
        cjxwPcW6lgc+k6JXYs1NdbRCIOcZcYGH5ex2
X-Google-Smtp-Source: ABdhPJwwxZtT1+nHRCZoasgxAPStg4KmhlveczsZWUYFIlMICmGoKNCPw5uO8UbrayXG43nYtLt3hg==
X-Received: by 2002:a17:902:ce05:b0:14f:8cfa:1ace with SMTP id k5-20020a170902ce0500b0014f8cfa1acemr469038plg.149.1645635906521;
        Wed, 23 Feb 2022 09:05:06 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u11sm62507pfi.71.2022.02.23.09.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:05:05 -0800 (PST)
Date:   Wed, 23 Feb 2022 09:05:02 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
Message-ID: <20220223090502.29e5f87a@hermes.local>
In-Reply-To: <20220223080342.5cdd597c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
        <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
        <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
        <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
        <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
        <20220222103733.GA3203@debian.home>
        <20220222152815.1056ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220223112618.GA19531@debian.home>
        <20220223080342.5cdd597c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 08:03:42 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 23 Feb 2022 12:26:18 +0100 Guillaume Nault wrote:
> > Do you mean something like:
> > 
> >   ip link set dev eth0 vlan-mtu-policy <policy-name>
> > 
> > that'd affect all existing (and future) vlans of eth0?  
> 
> I meant
> 
>   ip link set dev vlan0 mtu-policy blah
> 
> but also
> 
>   ip link set dev bond0 mtu-policy blah
> 
> and
> 
>   ip link set dev macsec0 mtu-policy blah2
>   ip link set dev vxlan0 mtu-policy blah2

Sorry, putting this in ip link is not the right place.
It belongs in sysctl (if at all); not convinced this is worth doing.

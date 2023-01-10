Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0435D663C1A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbjAJJB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbjAJJAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:00:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949F91C4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673341180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=878QB1Y1L7BtDs0wJx0EmntPfY/TZQVcO92t8BAgSwc=;
        b=Botsm76MUruhePdP8sgLD69qvfF0hrMTB8qOvdCR1HzQQu6KzUiRYflfL233y1Mn/U+mKH
        uS6v4QzaJk+NrNvKgQf65l/5FkvDpE+/3gjO77x02YVe6AaZuD32x1077NX4O8whfGfYFz
        son5chea1OQyhdUi6mO8p3rbzNaJOwY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-920-u99_MG-HCFv0fLx-HA-1; Tue, 10 Jan 2023 03:59:39 -0500
X-MC-Unique: 920-u99_MG-HCFv0fLx-HA-1
Received: by mail-qv1-f72.google.com with SMTP id ob12-20020a0562142f8c00b004c6c72bf1d0so6522680qvb.9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:59:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=878QB1Y1L7BtDs0wJx0EmntPfY/TZQVcO92t8BAgSwc=;
        b=IsAcXqVtic3tUQNX2U3jUlrQZiAhAaENcWYAss5SUD/NvMiNWfxHA1kfCcv9JIufp2
         k2UxPLLs3EhOzyVztSGKXYKaxa2rEJa0F4VgSHoQw7uwhhnFwfhsZEvNHdCdtQg93M0y
         QatXr+fRWV8ujU1IsFokkSihVLAn3z8UpZLXz2ivy3829iXP42hcV6fAVzKIO5UocfUr
         F4lbMzpnoshbiG1OX7z9GEtBJHyPeDDfQFpGkdGoGuenA6P+lLb2sDyttbyDJ5mBJ5dH
         x3QbkQ4XPUwJLkJoySUAXmEezfimcebO/A+01qmEobitc949T1frnVJ/ZkgHjNGflj4o
         7Q8A==
X-Gm-Message-State: AFqh2kpsJdjJCJ0PdbvY5O/ThPXHoh88zFyoCS6vY4KdatEnXt0uF7wu
        tBW+RdNf338qHDZt2WrjWUMG4zx3tBMpsNoPSWc31LEkpHDNayardFAJywpgQiugCvSrjikOBai
        ayjiNhPfYKykNjamQ
X-Received: by 2002:ac8:7354:0:b0:3a6:a699:3cd8 with SMTP id q20-20020ac87354000000b003a6a6993cd8mr89152470qtp.57.1673341178928;
        Tue, 10 Jan 2023 00:59:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvwkeSpvqLXoiRXbi5MvvcA9n2LXehWtx6qM7BjdYLzkSAlx9My/Jp8xs2MVNsvKeaDjUmJ0w==
X-Received: by 2002:ac8:7354:0:b0:3a6:a699:3cd8 with SMTP id q20-20020ac87354000000b003a6a6993cd8mr89152453qtp.57.1673341178659;
        Tue, 10 Jan 2023 00:59:38 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id t7-20020a05620a034700b007054a238bf2sm6765326qkm.126.2023.01.10.00.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 00:59:38 -0800 (PST)
Message-ID: <93dbc4b776a74561e85d346987266a5372aff908.camel@redhat.com>
Subject: Re: [PATCH net] ipv6: prevent only DAD and RS sending for
 IFF_NO_ADDRCONF
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>, David Ahern <dsahern@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, LiLiang <liali@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jianghaoran <jianghaoran@kylinos.cn>,
        Jay Vosburgh <fubar@us.ibm.com>
Date:   Tue, 10 Jan 2023 09:59:34 +0100
In-Reply-To: <CADvbK_eCRoH2JqKV=8J2Yuj_yC3ueFz4je8VhXOgerQ_rhtB2A@mail.gmail.com>
References: <ab8f8ce5b99b658483214f3a9887c0c32efcca80.1673023907.git.lucien.xin@gmail.com>
         <7ab910df-c864-7f11-0c1a-acb863dd1539@kernel.org>
         <CADvbK_eCRoH2JqKV=8J2Yuj_yC3ueFz4je8VhXOgerQ_rhtB2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-01-08 at 11:58 -0500, Xin Long wrote:
> On Sat, Jan 7, 2023 at 9:04 PM David Ahern <dsahern@kernel.org> wrote:
> > 
> > On 1/6/23 9:51 AM, Xin Long wrote:
> > > Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
> > > slave ports of team, bonding and failover devices and it means no ipv6
> > > packets can be sent out through these slave ports. However, for team
> > > device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
> > > link will be marked failure.
> > > 
> > > The orginal issue fixed by IFF_NO_ADDRCONF was caused by DAD and RS
> > > packets sent by slave ports in commit c2edacf80e15 ("bonding / ipv6: no
> > > addrconf for slaves separately from master") where it's using IFF_SLAVE
> > > and later changed to IFF_NO_ADDRCONF in commit 8a321cf7becc ("net: add
> > > IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf").
> > 
> > That patch is less than a month old, and you are making changes again.
> Hi, David,
> 
> That patch will not change anything, and it's an improvement. the
> problem is the commit:
> 
> 0aa64df30b38 ("net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf")
> 
> So it affects the team driver only, and I should've done more team driver tests.
> Sorry for having to touch the IPv6 code for this problem in the team driver.
> 
> > 
> > I think you should add some test cases that cover the permutations you
> > want along with any possible alternative / negative use cases.
> IFF_NO_ADDRCONF are used by team/bonding/failover, I will try to add
> a kselftest for this with team/bonding.

Please include such test in the next iteration, thanks!

Paolo


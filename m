Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4015A0C29
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbiHYJBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbiHYJBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:01:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1598A13E82
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661418049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UlzEVD+vtRt8rRVBuejT+bm/g+uBvJMUPzkHEd2WwY=;
        b=enlrhkZjQmCtpLCxUhBEMv7wi6BF+z1Xs8YXwK1UXzYt4MgR4oBsIPSCaxqMnrp/6RcvHb
        c0TcHvXmHAuuvemQB1tdoPfoShTogtaqUNoDVdB6ffZSj/U/z/3iK2goJKt5nKtZdbq6PC
        38aT1tExeedV0ve/ZVXs3L5dYV8B7JY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-0K5EA2D9Ma-Rm4_rRKU0qA-1; Thu, 25 Aug 2022 05:00:48 -0400
X-MC-Unique: 0K5EA2D9Ma-Rm4_rRKU0qA-1
Received: by mail-wm1-f70.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso2189825wmq.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=6UlzEVD+vtRt8rRVBuejT+bm/g+uBvJMUPzkHEd2WwY=;
        b=jnxyojoFYVYo0YbuyAcK2GkkKpZ0i1Zco/zqPXsftTYr4r5FDf1HIu2JepBuyjnP9w
         sN6iOkrLwe2p7Ct3n1daatFZGrCWEy2mfvUNgKTcwj0IhDLQ1kRwCCpxabW0PxI3jKZy
         Yep8DQd46/bAY3ZPRf5CxAz74gvD3ViUBsQ4C8b6xNNKeUc5H3tk7EFgdjM+ZcVNHu3s
         pFpnKUHL2o90LOWlxS60gSP3QEo9mURR7hXpHferjCqn90Y0254snvyiLcaigUFtvqQJ
         BoklcPM9LTBPDl/x7CqbhIflkIHsGuJQUxCTBi07KcIXiXWPCqB1mbqHXXsHteyUd0wC
         PtTg==
X-Gm-Message-State: ACgBeo2b03EVTvwyAe0b+9vY4djTQeJERHJf///ZCc+heXaOwG+iaaDQ
        PcnAc7tBh1S/9dhRDQzxuY+JlAETJ9T1zVrNrEC0SiPh4Fy22cqZXmhjzOCRofOMaTf/KhYs4iG
        oxLutrVry3LO+VFSJ
X-Received: by 2002:adf:e401:0:b0:225:2124:183d with SMTP id g1-20020adfe401000000b002252124183dmr1516196wrm.146.1661418046946;
        Thu, 25 Aug 2022 02:00:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR625h0QxcxKDQ/2A4jYOJ4BCdCxuQVco1DKoqxCc4e3gw/+hZKDdmPjR6VzQMTC8UUDnYuYIQ==
X-Received: by 2002:adf:e401:0:b0:225:2124:183d with SMTP id g1-20020adfe401000000b002252124183dmr1516171wrm.146.1661418046701;
        Thu, 25 Aug 2022 02:00:46 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id i6-20020a5d4386000000b0022159d92004sm13034356wrq.82.2022.08.25.02.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 02:00:46 -0700 (PDT)
Message-ID: <a359692096f20b2abc5e53cb796c892f97acec1b.camel@redhat.com>
Subject: Re: [PATCH net-next v3 00/17] net: dsa: microchip: add error
 handling and register access validation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 25 Aug 2022 11:00:44 +0200
In-Reply-To: <20220823080231.2466017-1-o.rempel@pengutronix.de>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-23 at 10:02 +0200, Oleksij Rempel wrote:
> changes v3:
> - fix build error in the middle of the patch stack.

The series looks reasonable to me, let's see the comments from the DSA
crew;)

The next time please additionally add the change informations in the
individual patch, after the '---' separator: that will made reviewers
life more easier.

It's hard to track what changed exactly since v2 from the above line.

Thanks!

Paolo



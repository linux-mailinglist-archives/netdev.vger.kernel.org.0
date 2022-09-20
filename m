Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC62F5BE1DA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiITJZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiITJZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:25:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFDB3D5B8
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663665905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+W3uMuXb8mRiplJwHfdBTKhx2EgpXn+wgSS0JSazn4=;
        b=TnIFhfnY3tXNtwG6BuGawea0axGOvYu1uXZyFzUFfgxNQgfucSDwP2COWoMHd/oCz1Fjmh
        AAkaplTRYE4I/qMuQ/kFEKp7AwN0Zdrty9gDGkwDJ8HVGVn61ozWP5K6Ou3jIyM1dAFaUh
        QooGOn3lyvTPfBT/7+Ava+UHES7rdLo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-113-cbquWZ1IO_uFAcK2sdfEAA-1; Tue, 20 Sep 2022 05:25:04 -0400
X-MC-Unique: cbquWZ1IO_uFAcK2sdfEAA-1
Received: by mail-qv1-f69.google.com with SMTP id y16-20020a0cec10000000b004a5df9e16c6so1579871qvo.1
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=t+W3uMuXb8mRiplJwHfdBTKhx2EgpXn+wgSS0JSazn4=;
        b=XH49+y/ewAk2TLd8gUAU8uKdZ6Ou/p6OMPeWgAFaYdpJfQXDvQjiUVMuN/GJTmwgQK
         P+AJzIeQ9ip+t6zd7bpJGtbBrWp3BLXZs7cjlK1MzHtq+wdF6h1pOuCY9TPADE26ts5u
         gUGttfA6t2HoNz2eGYqigABxrJD1EzoRZi9sO6KG5VEv7mgwOTITeh8CBCsCnf0pc5mU
         NVCNEXmHLHTeIW4WqkP6CWaUr7TfuF2oATL5SRzhoWhlYGKIOiSKe/W46gBCxMNjR442
         CY6SScqJG9gIhncoK5lAXIzcKbx77PtfxaoCOqVUzY5Z6Vti6VV/JfLtfU0yPEuu/KfR
         MieQ==
X-Gm-Message-State: ACrzQf0zJTpnXRKFFtncyPL/IDpXZfpAEDiHv8rzfmNavyt8s9qL0dfQ
        aq3rRkjGFLMG5WPRU4iRz9tUL2eTFZ9fgW5PqQRLLEnjlsZtNRwOvXp8FDXZpN3678r940bjM+D
        WP7RP1p0/4GOzRqSB
X-Received: by 2002:ac8:5dd4:0:b0:35c:e24b:c185 with SMTP id e20-20020ac85dd4000000b0035ce24bc185mr9702335qtx.562.1663665903899;
        Tue, 20 Sep 2022 02:25:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6hvUHNTsLXtc9B2gNYUtMI2bswyu8hKIf3NW6dNzDyNQPSyd0tNg/+X/6m1Juj1yKw1gk7qg==
X-Received: by 2002:ac8:5dd4:0:b0:35c:e24b:c185 with SMTP id e20-20020ac85dd4000000b0035ce24bc185mr9702312qtx.562.1663665903648;
        Tue, 20 Sep 2022 02:25:03 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-90.dyn.eolo.it. [146.241.114.90])
        by smtp.gmail.com with ESMTPSA id c25-20020a05620a269900b006bb83c2be40sm720319qkp.59.2022.09.20.02.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 02:25:03 -0700 (PDT)
Message-ID: <5fb488a102d0738ab153bf133439dd64f09d096e.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 03/10] net: dsa: allow the DSA master to be
 seen and changed through rtnetlink
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?UTF-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Date:   Tue, 20 Sep 2022 11:24:57 +0200
In-Reply-To: <20220911143554.tq4lf5eqs4novhtn@skbuf>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
         <20220911010706.2137967-4-vladimir.oltean@nxp.com>
         <20220911143554.tq4lf5eqs4novhtn@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-09-11 at 14:35 +0000, Vladimir Oltean wrote:
> On Sun, Sep 11, 2022 at 04:06:59AM +0300, Vladimir Oltean wrote:
> > +struct rtnl_link_ops dsa_link_ops __read_mostly = {
> > +	.kind			= "dsa",
> > +	.priv_size		= sizeof(struct dsa_port),
> > +	.maxtype		= IFLA_DSA_MAX,
> > +	.policy			= dsa_policy,
> > +	.changelink		= dsa_changelink,
> > +	.get_size		= dsa_get_size,
> > +	.fill_info		= dsa_fill_info,
> > +};
> 
> I forgot to apply Jakub's suggestion to set netns_refund = true.
> On the other hand, I think the patches are otherwise fine, and I
> wouldn't resend them, especially without any feedback. If there is no
> other feedback, can I fix this up through an incremental patch?

Since the delta should be minimal, we have a significant backlog, and
this LGTM, I'm going to apply the series as-is.

Please follow-up with the incremental fix, thanks,

Paolo


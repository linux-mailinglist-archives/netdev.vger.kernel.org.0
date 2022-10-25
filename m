Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6240260CBFA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 14:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiJYMg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 08:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiJYMgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 08:36:54 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAE9188A95;
        Tue, 25 Oct 2022 05:36:49 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r12so5441773lfp.1;
        Tue, 25 Oct 2022 05:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aN0HUd/KgdtdxIcVM/vKgUbuOtmAYYeHHt78w+aGgt8=;
        b=aBIuiwmv8MKm72HVyQhGu5WmoBtAmK3XF/1PTz0bzUU25A25s8Y5i0ItMqk6lRYdVH
         YV5y+EijhyMyuMew0RWl/OmZQnFfkvGCldxDFIjWJ7qSvti/EbuHtHUHOPbd627uWer4
         LuYPIphGZM38WcXgaCsRv4okvvyEEd2dWEIIPg8sZU8Rw46hMovTJSa1nB2tPRc4gqr1
         824l0BE4MehGzfSLqLoiwpK4h+jyz9Gm1J8ven5v03tBbHJpMjwmg0nbqFdahyicksVy
         ImlgpQvBcnThc91pdWbWQ0POZGO6hNk4GhKkeRj0HVtk3t2cGkkuyyV6ioRdp6S0bTWa
         90vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aN0HUd/KgdtdxIcVM/vKgUbuOtmAYYeHHt78w+aGgt8=;
        b=O15ZBmApGkvN4WdgXEg7F+6LaUc4dpzwrqZo/IybkWEdCM5j4Udj3T5NP7OGMT3CT8
         +J5g3Y1SOL5W/V/5V8YtXXrZ/+Cz1lsl1uExHI0XQgRMZv0tBbMOzl1cuzARFlBJabsO
         dYIvHYo7Lz61VJyp1l1D5FBUnuZqEQD9grINI8L9EEwrwxc5kVqUqbzxsemoJKyf118w
         +XR8CLF/3D8/R75qUg4WVyTYH7qSs1ls1yWoY/6UYnfFbAuHB0D5TGw9z7B5Y+nXJxve
         R9ibBaXAEEpTOtWI+N1Kt5pFRMxqH1LfvScDW47XpeE/QAnDFFBDLyjQxEkkfTCN5Phm
         fERw==
X-Gm-Message-State: ACrzQf1DXqAhMO+G4dr1tm6kDr6Mzpmz2peuPETTNGVdifC8eE7HMf39
        p482n4KjZITxJ1iXrVP53sMAhAF5XPHTFw==
X-Google-Smtp-Source: AMsMyM7h0NPWCWOmu+/lzjO76zWSA+WPzlrK1l1KOvhtU9YeqQqpJXOhYDnbXvle5a0Lk+y1HMyhiQ==
X-Received: by 2002:a05:6512:3dac:b0:4a4:8044:9c3 with SMTP id k44-20020a0565123dac00b004a4804409c3mr13225634lfv.145.1666701407419;
        Tue, 25 Oct 2022 05:36:47 -0700 (PDT)
Received: from smtpclient.apple (188-177-109-202-dynamic.dk.customer.tdc.net. [188.177.109.202])
        by smtp.gmail.com with ESMTPSA id r2-20020a19da02000000b0049f9799d349sm395131lfg.187.2022.10.25.05.36.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Oct 2022 05:36:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
From:   Michael Lilja <michael.lilja@gmail.com>
In-Reply-To: <Y1fC5K0EalIYuB7Y@salvia>
Date:   Tue, 25 Oct 2022 14:36:35 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

No problem. Here is a snippet of the rulesets in play. I simplified it =
because there are a lot of devices and a lot of schedules per device. =
The =E2=80=98mark=E2=80=99 is set by userspace so not all flow types are =
offloaded, that is controlled by userspace:

- - - - snip start - - - -=20
table inet fw4 {
	flowtable ft {
	hook ingress priority filter
	devices =3D { lan1, lan2, wan }
	flags offload
}

 chain mangle_forward {
	type filter hook forward priority mangle; policy
	meta mark set ct mark
	meta mark 0x00000000/16 queue flags bypass to 0
 }


chain my_devices_rules {
	ether saddr 96:68:97:a7:e8:a7 jump fw_p0_dev0 comment =E2=80=9CDev=
ice match=E2=80=9D
}

chain fw_p0_dev0 {
	meta time >=3D "2022-10-09 18:46:50" meta time < "2022-10-09 =
19:16:50" counter packets 0 bytes 0 drop comment "!Schedule OFFLINE =
override"
	meta day =E2=80=9CTuesday" meta hour >=3D "06:00" meta hour < =
"07:00" drop
}

chain forward {
	 type filter hook forward priority filter; policy accept;
	jump my_devices_rules
}

chain my_forward_offload {
	type filter hook forward priority filter + 1; policy accept;
	meta mark !=3D 0x00000000/16 meta l4proto { tcp, udp } flow add =
@ft
}

chain mangle_postrouting {
	type filter hook postrouting priority mangle; policy accept;
	ct mark set meta mark
}
- - - - snip end - - - -

The use case is that I have schedules per device to control when they =
are allowed access to the internet and if the flows are offloaded they =
will not get dropped once the schedule kicks in.

Thanks

> On 25 Oct 2022, at 13.05, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>=20
> Hi,
>=20
> On Sun, Oct 23, 2022 at 07:16:58PM +0200, Michael Lilja wrote:
>> When a flow is added to a flow table for offload SW/HW-offload
>> the user has no means of controlling the flow once it has
>> been offloaded. If a number of firewall rules has been made using
>> time schedules then these rules doesn't apply for the already
>> offloaded flows. Adding new firewall rules also doesn't affect
>> already offloaded flows.
>>=20
>> This patch handle flow table retirement giving the user the option
>> to at least periodically get the flow back into control of the
>> firewall rules so already offloaded flows can be dropped or be
>> pushed back to flow offload tables.
>>=20
>> The flow retirement is disabled by default and can be set in seconds
>> using sysctl -w net.netfilter.nf_flowtable_retire
>=20
> How does your ruleset look like? Could you detail your usecase?
>=20
> Thanks.



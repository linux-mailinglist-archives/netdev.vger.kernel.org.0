Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03E682D30
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjAaNBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjAaNBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:01:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AEC4C0DD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675170062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5LAlV4rwXGaZAkBT5gd6JtG7tn12Ct026ebSvrWPbW4=;
        b=WqdS2E/up5LGb/B3E8OSmonI/DzYqEURR00wYz24dKM2nC76rldnyP/yFWazwippx9WNLO
        pyEa0iQ/JU0V3VjNF5pNwgfSwXtzv3yrGNH59/l9KX4a4TCx8t/f5hEJ3Q+17Jqdykaunz
        jFFjdqp47UNnGtRwnUeG0prbB1w1o+A=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-woKstKgLM9GmShRRSaGWkA-1; Tue, 31 Jan 2023 08:01:00 -0500
X-MC-Unique: woKstKgLM9GmShRRSaGWkA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-16385ab40f2so3701423fac.20
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5LAlV4rwXGaZAkBT5gd6JtG7tn12Ct026ebSvrWPbW4=;
        b=bEjh5R2phSL8jkciQVtyrV2RCjAt+iBCQsvwMZXzdNLYYKYEGZg2JedUmwXWQRq+cJ
         0uQIrzxUVboY8oLUGOMelIZKCSa5dQ7rsX6ZubZK16qr1uaGqPzxFybLjWNZw/h4JSO4
         nMVqXd6dbATrN7qGFha/pBx2jX38csH4lINkGaNDh8yCI4oK95i5U/bjlDD1sa0s+3sQ
         DIujpZE7SqO5Dsm5wB0qW2Fm7Q/ja3LL2aTZexwjWNHmEMiC0spnd6aUIPLgMGtP825o
         hVHvzJjKdtkG3jibVl1ulkt5LD12JryhRNo4Fou1wVZOoSixauNiKZK7EuA89inoaCcC
         iUEw==
X-Gm-Message-State: AO0yUKVkYhnSKkBBEefXAtNvdSCoeKkEaK/dGD01PHO56W5DrzIjVo5Z
        055C4fqABgkwTn8+tms8bbLOdHo5sKWuTE/M7hvIBOAcecd+2MuI8MSWcsOhxffDYAyGbjsaPdJ
        N9e/HA4GQTuyq84St
X-Received: by 2002:a05:6870:ebc3:b0:163:758d:a6b7 with SMTP id cr3-20020a056870ebc300b00163758da6b7mr2880301oab.1.1675170048988;
        Tue, 31 Jan 2023 05:00:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/3EcOyUfREamMpigitPUuOxl0q6+e2Sf3auXXnXQriycKTacCv8kCcq1zOOtoetgGsmXZm4Q==
X-Received: by 2002:a05:6870:ebc3:b0:163:758d:a6b7 with SMTP id cr3-20020a056870ebc300b00163758da6b7mr2880278oab.1.1675170048723;
        Tue, 31 Jan 2023 05:00:48 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id dy31-20020a05620a60df00b0070531c5d655sm9925169qkb.90.2023.01.31.05.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 05:00:48 -0800 (PST)
Message-ID: <f753ad2b0c19e085867698f7bbbe37f6d172772e.camel@redhat.com>
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: disable hardware DSA
 untagging for second MAC
From:   Paolo Abeni <pabeni@redhat.com>
To:     arinc9.unal@gmail.com, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
Date:   Tue, 31 Jan 2023 14:00:43 +0100
In-Reply-To: <20230128094232.2451947-1-arinc.unal@arinc9.com>
References: <20230128094232.2451947-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-28 at 12:42 +0300, arinc9.unal@gmail.com wrote:
> From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>=20
> According to my tests on MT7621AT and MT7623NI SoCs, hardware DSA untaggi=
ng
> won't work on the second MAC. Therefore, disable this feature when the
> second MAC of the MT7621 and MT7623 SoCs is being used.
>=20
> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA unt=
agging")
> Link: https://lore.kernel.org/netdev/6249fc14-b38a-c770-36b4-5af6d41c21d3=
@arinc9.com/
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>=20
> Final send which should end up on the list. I tested this with Felix's
> upcoming patch series. This fix is still needed on top of it.
>=20
> https://lore.kernel.org/netdev/20221230073145.53386-1-nbd@nbd.name/
>=20
> The MTK_GMAC1_TRGMII capability is only on the MT7621 and MT7623 SoCs whi=
ch
> I see this problem on. I'm new to coding so I took an educated guess from
> the use of MTK_NETSYS_V2 to disable this feature altogether for MT7986 So=
C.

Keeping this one a little more on pw. It would be great is someone else
could validate the above on the relevant H/W.

Thanks,

Paolo


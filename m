Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85D6EF697
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241463AbjDZOjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241453AbjDZOju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:39:50 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E5359FB;
        Wed, 26 Apr 2023 07:39:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94f3df30043so1155880866b.2;
        Wed, 26 Apr 2023 07:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682519988; x=1685111988;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U3fMS6vGtNlmEZteMKVTwMOKhjb7WLirh4B0WOh1xiU=;
        b=QaFZNT6fNhNXKLHPDrFxEtroaaMbguLx43qCTMCyoUuNX2Ag1/Y92xZJp60AzURdk0
         dxIvq0SjOBv97cdPwEHj5HPEtjE+doViBSeQpUIUJfXtiTet7PoNCHbF4/Bxl+KRHUvx
         lV9lcl5lLTJuA0JaEITMtM1JVc5JF4oQTFpaTgB6MI4AJcR4RmkN+4Sae74M1c9J+vYv
         Q8Hk2Cy60n0SpC7qfJWQt0QxAkhdQ+op2RcyIYqHLCU55iobl0ZthHflxPRdAU0oiEwL
         lDCN0KToZa569MY6col+EPk0zJ3fs51uLh34iiD2xI9Cnh/kvF0cE6nJqing/uEwurKR
         N1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682519988; x=1685111988;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3fMS6vGtNlmEZteMKVTwMOKhjb7WLirh4B0WOh1xiU=;
        b=QJp3h7LOJuIhBRVO/A0fRCWNSexGVOhNVmTfwuk3mNtEf4q7q8bbQsc2QeuSajD0gS
         tXwEywnmXrTz7dLc7yhjcOZIcdXmMjjN7C0+aquv3Y3aY7NrEByE10fMJqKCQygKH19G
         eNDYsGo/d2FR3TJ+vMtX+HY654vTlAA8/uqHeXlP03tinTaK9i1dTm3AfwX6/Y4zE5L3
         wi5XFVm3CkcjHOJWYFW3K9UGpHFajaX5W0QeH4PQVgJlqIr8KTQxzhod4t+eSW8JlWsk
         1I+6L4p2+TNyK6Yvh40AChuIzbm9zsNq6WEHDs9pQT17HgrFWL1vkdqpU9nI9ejlt1ON
         o8UA==
X-Gm-Message-State: AAQBX9cjEFF41V0+ZxoLhCVgehvvXgpxVcz7pIPAUA7syK31X00/hx4/
        CSizLAepxpvVNHZG3GnzxE8=
X-Google-Smtp-Source: AKy350ZO3Dl/D/t3V1YrnB4ch7JxvOvlsOl56w/4tw57jx6R8bv580ZQXGKSR3kO9256Hh1y6aicIg==
X-Received: by 2002:a17:907:8b87:b0:94f:21f3:b5f8 with SMTP id tb7-20020a1709078b8700b0094f21f3b5f8mr17218081ejc.21.1682519987596;
        Wed, 26 Apr 2023 07:39:47 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qt2-20020a170906ece200b0094e1344ddfdsm8232330ejb.34.2023.04.26.07.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:39:47 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:39:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 04/24] net: dsa: mt7530: properly support
 MT7531AE and MT7531BE
Message-ID: <20230426143944.s5vmhloepa3yodrj@skbuf>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
 <20230425082933.84654-5-arinc.unal@arinc9.com>
 <ZEfsCit0XX8zqUIJ@makrotopia.org>
 <ce681fac-5f00-f0fc-b2cf-89907c50ee7c@arinc9.com>
 <ZEkiIQZsspBlDyEn@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEkiIQZsspBlDyEn@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 02:07:45PM +0100, Daniel Golle wrote:
> On Wed, Apr 26, 2023 at 11:12:09AM +0300, Arınç ÜNAL wrote:
> > On 25.04.2023 18:04, Daniel Golle wrote:
> > > On Tue, Apr 25, 2023 at 11:29:13AM +0300, arinc9.unal@gmail.com wrote:
> > > > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > > 
> > > > Introduce the p5_sgmii pointer to store the information for whether port 5
> > > > has got SGMII or not.
> > > 
> > > The p5_sgmii your are introducing to struct mt7530_priv is a boolean
> > > variable, and not a pointer.
> > 
> > I must've meant to say field.
> 
> Being just a single boolean variable also 'field' would not be the right
> word here. We use 'field' as in 'bitfield', ie. usually disguised integer
> types in which each bit has an assigned meaning.

"field" is a perfectly legal name for a member of a C structure.
https://en.wikipedia.org/wiki/Struct_(C_programming_language)
Not to be confused with bitfield.

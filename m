Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84965D7E3
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbjADQH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbjADQHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:07:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E072818E20;
        Wed,  4 Jan 2023 08:07:52 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id kw15so83620183ejc.10;
        Wed, 04 Jan 2023 08:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2ejNWmUVKzv6qd8rLkoL3Pzd4W2kPQ/FppYN+juVc8Q=;
        b=J/Rj73/PMMXzGDA1AflmrcliuQUFXdrSsVsCzOeGfL4B0v7eO8LTGTZCNnr6lfNrSZ
         LtJi4U+zhiGXTC868O0SZO2EgLuHOCNXKKzuypUikmB1RuLq6hpRpo7LVWVjuOumvh0Z
         AGFEXBq7mZYK8vxYJH0d/1T73DVbWeuCSh+dzMYmFjWRoKAvbGxFFBIHFp3Xlr8uXRgV
         P23FJV7QxaSQkXE45EhTsAl5qvEkojIZBNSbV1dMoYflNuyKwo2BlIsf+4ZD9efJvjKJ
         TMtk/gu/zXDWJe49/KQVx+nL3ByIGr3T+3QWNJqqO3A7noqxylSsCtn2NF9Bgt2nwoPj
         +f8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ejNWmUVKzv6qd8rLkoL3Pzd4W2kPQ/FppYN+juVc8Q=;
        b=o/EGvYG67VB+lZt0ILpOkCV7M8J4n4HNOjZXTR1UQA7pZrIU30TiMnyCrbBWdvkI8C
         yH+j28beKTytEQEhzZya8Yz2UIqlqoqs3we5LQLTjKyG70kiwqcyNb0cfJH4jt1Up46r
         odQG6DjwS8OQS8+kBdppkxiCWvnV0cDxSxdWm3F/DJ/U7hJwqWmUkcta5dzrRfgN2vnD
         cu8Sp6Bp4ewaf3NE1qaznEVSVi5+EWnHvya13H+e9bLZzr5A7DFX0bxchBCpMgPmkyzv
         38E7GW/UU885U8NAzZ04d5+DegWxMPK2s3qt0hHlxu0mB+8zvg96A5YBkqzujk7jA0ML
         Fihw==
X-Gm-Message-State: AFqh2kr5NAelW7w0kn/xEA7OmS4NP1WHjE5GeL4aAL2uzrxgi4PkQelr
        vQpgzAcZjH8iYIRPDzTLWdS+tzF+/FJhV6Dc10o=
X-Google-Smtp-Source: AMrXdXuQRmCSfRaOEdJCZIrCcUOnz+Xb8K4QYSu4moaSSdC2g9go8yZV9lt4/XJDzHYAz7yGF5eUJncC4Oz8wY6aS9w=
X-Received: by 2002:a17:906:26d2:b0:7c1:36:8ffe with SMTP id
 u18-20020a17090626d200b007c100368ffemr3304851ejc.725.1672848471417; Wed, 04
 Jan 2023 08:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com> <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
 <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com> <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
 <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com> <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
In-Reply-To: <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 4 Jan 2023 17:07:40 +0100
Message-ID: <CAFBinCC9sNvQJcu-SOSrFmo4sCx29K6KwXnc-O6MX9TJEHtXYg@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
To:     David Laight <David.Laight@aculab.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 4, 2023 at 4:53 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Martin Blumenstingl
> > Sent: 04 January 2023 15:30
> >
> > Hi Ping-Ke, Hi David,
> >
> > On Sun, Jan 1, 2023 at 2:09 PM Ping-Ke Shih <pkshih@realtek.com> wrote:
> > [...]
> > > Yes, it should not use bit filed. Instead, use a __le16 for all fields, such as
> > I think this can be done in a separate patch.
> > My v2 of this patch has reduced these changes to a minimum, see [0]
> >
> > [...]
> > > struct rtw8821ce_efuse {
> > >    ...
> > >    u8 data1;       // offset 0x100
> > >    __le16 data2;   // offset 0x101-0x102
> > >    ...
> > > } __packed;
> > >
> > > Without __packed, compiler could has pad between data1 and data2,
> > > and then get wrong result.
> > My understanding is that this is the reason why we need __packed.
>
> True, but does it really have to look like that?
> I can't find that version (I don't have a net_next tree).
My understanding is that there's one actual and one potential use-case.
Let's start with the actual one in
drivers/net/wireless/realtek/rtw88/rtw8821c.h:
  struct rtw8821c_efuse {
      __le16 rtl_id;
      u8 res0[0x0e];
      ...

The second one is a potential one, also in
drivers/net/wireless/realtek/rtw88/rtw8821c.h if we replace the
bitfields by an __le16 (which is my understanding how the data is
modeled in the eFuse):
  struct rtw8821ce_efuse {
      ...
      u8 serial_number[8];
      __le16 cap_data; /* 0xf4 */
      ...
(I'm not sure about the "cap_data" name, but I think you get the point)

> Possibly it should be 'u8 data2[2];'
So you're saying we should replace the __le16 with u8 some_name[2];
instead, then we don't need the __packed attribute.

> What you may want to do is add compile-time asserts for the
> sizes of the structures.
Do I get you right that something like:
  BUILD_BUG_ON(sizeof(rtw8821c_efuse) != 256);
is what you have in mind?



Best regards,
Martin

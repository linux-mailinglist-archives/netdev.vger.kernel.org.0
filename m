Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29669585BC1
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 21:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiG3TbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 15:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiG3TbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 15:31:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E8B15FFD
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 12:31:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gk3so1684690ejb.8
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 12:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=IyGAUs/XewcJpkze6PPx60tftl/vExnGSdxM5ltgvok=;
        b=DH9Egj9rvw3hIeuoTU4OD/zsK0GWATY3lkJ/19ic0aKtozTPHay6G7n4o5PILIEWwj
         97bjmqu+FL/MsMbXzyIyxfhIKgpKmMiuTwsHV5lVVw0jzyLJDRoOpv9EFeAl7pC8xDoR
         WOSpvJ/qoUQyUpfbtuR7dK4gHu/4hlzjX+Qsw2toPAKREbXtX8/EtHS9x5xzR1gy6C0Q
         1YDFhTo7h+4ShF8+UjARjEUIonRSwCqJA087SnFOn9547AFNbkQm9pJFqcjLj25/Zm0C
         41GW2Sp6hh6ORlwbrsx39ZD6tvM8qq0g8w5g2+efJdxFatxcRwB+d+3VbT4UEhJG9VVy
         TsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=IyGAUs/XewcJpkze6PPx60tftl/vExnGSdxM5ltgvok=;
        b=lzxMB/ZB0AM1hnjPxT5QQtPnY0DqwQDsm0/JK0aDCqujA3w0BXGnDPmnUvJRcRJacM
         yhow6EIIP+q+PcjXU+hgiPU4i2wH54OuXHXwygnDvILYVD6VIHNaUled002OncM0U3fy
         ZSTkclFPC7FEZ2Mm9GHZIXcsbPOkh8mepezmN/a4TJSW211hu8pwMJa7+ctzsIS6G3kl
         idbdIaauKqfqTvhqtGcIUAI5vlmf9pEM+Xa2DAG7C3U/CRFFedqOM/T+4XX/ykx/v/10
         ehA8iv497BR5eiTtZMrOn+33dA2hFVdjEowEw9/jr9nDN8fXtuLvpRtpvVU4qzsoirT6
         eklQ==
X-Gm-Message-State: AJIora+YzXLyQqQ9jw6LQTDeKicUvPHcz4TCgwsiYXO3Yy17qqgh7rTz
        Vt0QYT6hIViz9pHGODbylyeeruGdcKg=
X-Google-Smtp-Source: AGRyM1t0HFkPzzWwYa/FYFGFkF9xd/BHdmhgs56/HijKFuMQ1e98bCVZP4ooKQJAg1sv8dqYqYBjrQ==
X-Received: by 2002:a17:907:7b92:b0:72b:67fb:8985 with SMTP id ne18-20020a1709077b9200b0072b67fb8985mr6756364ejc.569.1659209473708;
        Sat, 30 Jul 2022 12:31:13 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9c0:f700:d5b:898b:b7ca:1bf3? (dynamic-2a01-0c23-b9c0-f700-0d5b-898b-b7ca-1bf3.c23.pool.telefonica.de. [2a01:c23:b9c0:f700:d5b:898b:b7ca:1bf3])
        by smtp.googlemail.com with ESMTPSA id f15-20020a17090631cf00b006feba31171bsm3255474ejf.11.2022.07.30.12.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jul 2022 12:31:13 -0700 (PDT)
Message-ID: <88d6ef05-f77a-57a2-f34a-e3998a8d70d4@gmail.com>
Date:   Sat, 30 Jul 2022 21:31:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Meson GXL and Rockchip PHY based on same IP?
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
References: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
 <CAFBinCCMinq1U2Pqn2LPjC9c+HqfHjvW81b1ENMxdoGmB6byEw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <CAFBinCCMinq1U2Pqn2LPjC9c+HqfHjvW81b1ENMxdoGmB6byEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.07.2022 19:06, Martin Blumenstingl wrote:
> Hi Heiner,
> 
> On Sat, Jul 30, 2022 at 5:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Meson GXL and Rockchip ethernet PHY drivers have quite something in common.
>> They share a number of non-standard registers, using the same bits
>> and same bank handling. This makes me think they they may be using
>> the same IP. However they have different quirk handling. But this
>> doesn't rule out that actually they would need the same quirk handling.
> You made me curious and I found the following public Microchip
> LAN83C185 datasheet: [0]
> Page 27 has a "SMI REGISTER MAPPING" which matches the definitions in
> meson-gxl.c.
> Also on page 33 the interrupt source bits are a 100% match with the
> INTSRC_* marcos in meson-gxl.c
> 
Great, thanks for investigating!

> Whether this means that:
> - Amlogic SoCs embed a LAN83C185
> - LAN83C185 is based on the same IP core (possibly not even designed
> by Amlogic or SMSC)
> - the SMI interface design is something that one hardware engineer
> brought from one company to another
> - ...something else
> is something I can't tell
> 
> 
> Best regards,
> Martin
> 
> 
> [0] https://ww1.microchip.com/downloads/en/DeviceDoc/LAN83C185-Data-Sheet-DS00002808A.pdf


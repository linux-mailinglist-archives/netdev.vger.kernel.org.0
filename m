Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFE63C721
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbiK2SZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiK2SZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:25:47 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58885F85E;
        Tue, 29 Nov 2022 10:25:45 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2ATIOwuG005450;
        Tue, 29 Nov 2022 12:24:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1669746299;
        bh=ofMM1FHrj8VajyNy27mGe2ShSZNNvZ2bILHbYWk3VJQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=djwnf6jE3TwlGYj1RIbw9GX7+4f3x78hY1Mvzg0UKLTW5+V970/q5OXrbSd6AIhL9
         yAI3A2MbEZsEb+L4GX4j6yomYq3CMSQmEJ2mxJKWpZkgwo//KGkfEXhWzZ6g7+/xiq
         4nT/8oIbh4X/qE+phQyt4Fuub84oK1EHybTAJaMM=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2ATIOwkr018566
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Nov 2022 12:24:58 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 29
 Nov 2022 12:24:58 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 29 Nov 2022 12:24:58 -0600
Received: from [10.250.38.44] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2ATIOvbE020258;
        Tue, 29 Nov 2022 12:24:57 -0600
Message-ID: <922413d0-c566-7765-f374-6f64d94f39aa@ti.com>
Date:   Tue, 29 Nov 2022 12:24:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 01/18] block/rnbd: fix mixed module-builtin object
Content-Language: en-US
To:     Masahiro Yamada <masahiroy@kernel.org>
CC:     Alexander Lobakin <alobakin@pm.me>, <linux-kbuild@vger.kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        "Boris Brezillon" <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-2-alobakin@pm.me>
 <68ceddec-7af9-983d-c8be-7e0dc109df88@ti.com>
 <CAK7LNAT_PuL0vuYaPxKZ3AfrojBC2tEXUA7Gqs2VuVuoTVoXmQ@mail.gmail.com>
From:   Andrew Davis <afd@ti.com>
In-Reply-To: <CAK7LNAT_PuL0vuYaPxKZ3AfrojBC2tEXUA7Gqs2VuVuoTVoXmQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 11:59 PM, Masahiro Yamada wrote:
> On Tue, Nov 22, 2022 at 6:18 AM Andrew Davis <afd@ti.com> wrote:
>>
>> On 11/19/22 5:04 PM, Alexander Lobakin wrote:
>>> From: Masahiro Yamada <masahiroy@kernel.org>
>>>
>>> With CONFIG_BLK_DEV_RNBD_CLIENT=m and CONFIG_BLK_DEV_RNBD_SERVER=y
>>> (or vice versa), rnbd-common.o is linked to a module and also to
>>> vmlinux even though CFLAGS are different between builtins and modules.
>>>
>>> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
>>> Fixing mixed module-builtin objects").
>>>
>>> Turn rnbd_access_mode_str() into an inline function.
>>>
>>
>> Why inline? All you should need is "static" to keep these internal to
>> each compilation unit. Inline also bloats the object files when the
>> function is called from multiple places. Let the compiler decide when
>> to inline.
>>
>> Andrew
> 
> 
> Since it is a header file.
> 
> 
> In header files, "static inline" should be always used.
> Never "static".
> 

My comment was more "why"?

> 
> If a header is included from a C file and there is a function
> that is not used from that C file,
> "static" would emit -Wunused-function warning
> (-Wunused-function is enabled by -Wall, which is the case
> for the kernel build).
> 
> 

Inline still hints to the compiler to inline, causing unneeded
object size bloat. Using "inline" to signal something else (that
the function may be unused) when we already have a flag for that
(__maybe_unused) feels wrong.

Seems this was already debated way back in 2006.. So maybe not
worth revisiting today, but still a cleanup that could be good
to think more about later.

Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B9E62D0E8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiKQCBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiKQCBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:01:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B540266CBF
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 18:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E8C4B81E2F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1905CC433D6;
        Thu, 17 Nov 2022 02:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668650503;
        bh=7Z90CmzkDCLepayY4tTzwsAAmDKpAwnvEZ9jcCsdtVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jQc0xebTB4bHW1eKSp41tMnA0QL5waf3d55EPRPWMw7I+8jJKpRPgt9WjX3Rzdt8f
         StVa27yXxpfzuDtDSTLdTS47t1I57+7L2E4aFIzh5tO0DH54jfGSDEoTMZRD80GJZk
         wyxJiBKg0Buyg0ghc/DEA6oQR29cJh3vIXOX4V1pDiqGr8w63RWJe54vs5UcDANigM
         KDuNusAiJp1tt89C3LYVTH4Xg6W7Dqi6cPgGy4Xj/lIUuIf8EC83PgVxS+kjWslPQ9
         Qb0f4M4xFIHUnzRqso/2NUfLIEAQO1b5jb+5A0B++j6lvqdsp+PNEokVFT8i1itFbB
         +CLXGsJjWSktA==
Date:   Wed, 16 Nov 2022 18:01:41 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Thompson <davthompson@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <Y3WWBcCwif7bADY4@x130.lan>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-4-davthompson@nvidia.com>
 <Y2z9u4qCsLmx507g@lunn.ch>
 <20221111213418.6ad3b8e7@kernel.org>
 <Y29s74Qt6z56lcLB@x130.lan>
 <20221114165046.43d4afbf@kernel.org>
 <Y3LmC7r4YP++q8fa@lunn.ch>
 <20221114171305.6af508be@kernel.org>
 <20221116083056.016e3107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221116083056.016e3107@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Nov 08:30, Jakub Kicinski wrote:
>On Mon, 14 Nov 2022 17:13:05 -0800 Jakub Kicinski wrote:
>> On Tue, 15 Nov 2022 02:06:19 +0100 Andrew Lunn wrote:
>> > > I don't feel particularly strongly but seems like something worth
>> > > exploring. A minor advantage is that once the init is done the tables
>> > > can be discarded from memory.
>> >
>> > I wondered about that, but i'm not sure initdata works for modules,
>> > and for hot pluggable devices like PCIe, you never know when another
>> > one might appear and you need the tables.
>>
>> Right, I meant that the request_firmware() version can discard
>> the tables. I shouldn't have said tables :)
>
>Saeed, David, are you looking into this? The problem come up again
>in a Realtek USB conversation.
>
>The task is so small and well defined I'm pretty sure I can get some
>aspiring kernel developer at Meta to knock it off in a few days.
>

Give me a couple of days and will let you know what's the verdict.
I sent David and Asmaa the links to read up on Request Firmware. Still
waiting for a response.

>FWIW the structure of a file I had in mind would be something like this:
>
># Section 0 - strings (must be section 0)
> # header
> u32 type:   1   # string section
> u32 length: n   # length excluding header and pads
> u32 name:   0   # offset to the name in str section
> u32 pad:    0   # align to 8B
> # data
> .str\0table_abc\0table_def\0some_other_string\0
> # pad, align to 8B
> \0\0\0\0\0\0\0
>
># Section 1 - table_abc
> # header
> u32 type:   2   # 32b/32b table
> u32 length: 64  # length excluding header and pads
> u32 name:   5   # offset to the name in str section
> u32 pad:    0
> # data
> [ 0x210, 0xc00ff ]
> [ 0x214, 0xffeee ]
> [ 0x218, 0xdeaddd ]
> [ 0x21c, 0xc4ee5e ]
> [ 0x220, 0xc00ff ]
> [ 0x224, 0xffeee ]
> [ 0x228, 0xdeaddd ]
> [ 0x22c, 0xc4ee5e ]
>
>etc.
>
>Use:
>	struct fw_table32 *abc, *def;
>
>	fw = request_firmware("whatever_name.ftb");
>	
>	abc = fw_table_get(fw, "table_abc");
>	/* use abc */
>

abc is just a byte buffer ? right ?

>	def = fw_table_get(fw, "table_def");
>	/* use def */
>

And what goes here? any constraints on how the driver must interpret
and handle abc/def blobs ? 

>	release_firmware(fw)

What if the same abc blob structure/table format is used to setup dynamic link
properties, say via ethtool -s ? Then the whole request firmware will be
redundant since "struct abc {};" must be defined in the driver src code.

I like the idea, i am just trying to figure how we are going to define it
and how developers will differentiate between when to use this or when to
use standard APIs to setup their devices.



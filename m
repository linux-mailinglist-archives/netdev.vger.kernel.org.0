Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801F9603298
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJRSe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiJRSe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:34:28 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B1C63B9;
        Tue, 18 Oct 2022 11:34:23 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29IIXu8C060046;
        Tue, 18 Oct 2022 13:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1666118036;
        bh=fMb1VL9YtHPCpt27Fqs9iLpWccGutRkx4U5ZfaG+UgE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=NsH8pjMS1DC7+oCBrtvz6ztBaGVEAm7jlqgIu/d2ACIR0tgZr8qtHTVUfZwR4bZlh
         Ppb1IJCFILS/Hc+VZrHP1nQjX6WZTyyprds1Tn07F2dID8sh1nfVpWQtAMF4WTCf/D
         qwjKvljceqfbjMoit790BjX6LkQxHWFay9GutUN4=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29IIXuIi052387
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Oct 2022 13:33:56 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 18
 Oct 2022 13:33:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 18 Oct 2022 13:33:56 -0500
Received: from [10.250.33.68] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29IIXtQE118408;
        Tue, 18 Oct 2022 13:33:56 -0500
Message-ID: <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com>
Date:   Tue, 18 Oct 2022 13:33:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
To:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch> <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
Content-Language: en-US
From:   Andrew Davis <afd@ti.com>
In-Reply-To: <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
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

On 10/18/22 12:37 PM, Sean Anderson wrote:
> Hi Andrew,
> 
> On 10/18/22 1:22 PM, Andrew Lunn wrote:
>> On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
>>> For whatever reason, the address of the MAC is exposed to userspace in
>>> several places. We need to use the physical address for this purpose to
>>> avoid leaking information about the kernel's memory layout, and to keep
>>> backwards compatibility.
>>
>> How does this keep backwards compatibility? Whatever is in user space
>> using this virtual address expects a virtual address. If it now gets a
>> physical address it will probably do the wrong thing. Unless there is
>> a one to one mapping, and you are exposing virtual addresses anyway.
>>
>> If you are going to break backwards compatibility Maybe it would be
>> better to return 0xdeadbeef? Or 0?
>>
>>         Andrew
>>
> 
> The fixed commit was added in v6.1-rc1 and switched from physical to
> virtual. So this is effectively a partial revert to the previous
> behavior (but keeping the other changes). See [1] for discussion.
> 
> --Sean
> 
> [1] https://lore.kernel.org/netdev/20220902215737.981341-1-sean.anderson@seco.com/T/#md5c6b66bc229c09062d205352a7d127c02b8d262

I see it asked in that thread, but not answered. Why are you exposing
"physical" addresses to userspace? There should be no reason for that.

Andrew

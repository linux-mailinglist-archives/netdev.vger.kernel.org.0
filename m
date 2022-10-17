Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3F6012CD
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJQPfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiJQPfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:35:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20089.outbound.protection.outlook.com [40.107.2.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018D9186E6;
        Mon, 17 Oct 2022 08:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEkwd2MtIBl5rCbDYslmhyWX0+8qbYyBKcfNqC1fVxrAdHDoqk+7x65IUOSAjfzl6TOoNHa8PAaEttRG5+h4c57vmxING4r3N2BHWdX55/LYAe0vA1T49h7/ShipEPrabhg7/9nmONKLtbbslPE1rjJEbZUkIA+mkxxLGTesAoHtgcbgiwn53OyZbeA2GvzmPu9UH1LNABJTRy76lbAwiBpuEJKPLxzktUmlLvV1+miaUNsyuOssTMHT5rvS8igM7wJRvAFr15lmtNJuQK8e3x4QGh8EEzdUYaYGiEo2+KallKyg0YDf4zMk3I3hQnFKmebVsbQfIQKhYvUl6Rg+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oB+kx1OPzZxKIQwwkg6hIkYyhMPiN1IpgiZB16yNWbo=;
 b=C9oaNaXiKpHKHPRej13PEmc13KIMfDKY91pQvnbD9kIhg/wTHh4GEZOlxjJqyoI0dvBTI61m8xUN+CLXDLZbq9J/ZmvzGqZvddAUn76XtzXMFHvTnsabpGM5m/BA185ztvWRsXS4d+nCMxRGyLk6Rk138Tuv7xzbt1BR5AbWIXv+r44r18OlsGsOSh2KfEVqNZGEj4l8UCpYoIDEacm69qZM48gVGWLnfjxlsBfPDcgEssnwe/NRoQeY9Hbd/hFdwOIYRqzvb2LNStyU34vYcmPlxeMnqdK1qJLnHqYFj7ldAUGYxZU0DNtGoJ4HhdA8rFyEFFX3AG7IlKLe/5Ck/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oB+kx1OPzZxKIQwwkg6hIkYyhMPiN1IpgiZB16yNWbo=;
 b=AZltl162BmBJAgqkkw8HdsTqDnwBjvQpEa6dSPWCecFqRK2QALpQxXMjLX71rhtW9UOGpuSRrOKU6aBhDCT3s9s4/UPlkJag/Bz48+XdXZKTx84FaUysJ1hG6kzteS5mpGJgBYs2Uox53BPL2NvVp1NBHjiTtymSGJeWD5rV3bi/RVCzZp/87XtnTbdXxkHUO+aQ0UGen/owKz/NgJYQPu+BP0uMR/tfw1O9zDvMk7u16Di5b/tgJq1iimloRbZWC/fm0DrNTS7xtPt+ooMBHu65udGbqa0jDc+EkfQaCn7TxyIBw+PvLryryAjBYlNKQqJvHBBgM1hRlH6h1+BiKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7999.eurprd03.prod.outlook.com (2603:10a6:102:21e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.28; Mon, 17 Oct
 2022 15:34:56 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 15:34:55 +0000
Subject: Re: [PATCH net-next v5 05/14] net: fman: Map the base address once
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
References: <20220902215737.981341-1-sean.anderson@seco.com>
 <20220902215737.981341-6-sean.anderson@seco.com>
 <CAMuHMdWqTtjuOvDo9qxgDVpm+RBGm7BEgpdqVRH1n_dLGoYLTA@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <086a6f02-4495-510e-9fc5-64f95e7d55f6@seco.com>
Date:   Mon, 17 Oct 2022 11:34:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAMuHMdWqTtjuOvDo9qxgDVpm+RBGm7BEgpdqVRH1n_dLGoYLTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0076.namprd02.prod.outlook.com
 (2603:10b6:208:51::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cfb7a7a-d584-4d51-3eaa-08dab0552457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: urh6ONtA/A8UeFSCZ02DNrzPC8GN3lvHwfLPvgoup9JQ3/ID0Plhpd++JCwIgyEfnjIzk4X+v5GUN4wd/4d0bEVV12UwBVnP3KAcMqe213d/g1TtrJLjXDA6nim5FiR1ehGV03UIRVq+fF/jbufXFDpZwsmUhNGwzQ6IwCQywVn+rNyF41Ba7HYxB2gWuRkPOerT8IqnF3EWgSqEeEoo9bN6qMlNwrv7FNNwb7oleCibE9sBO+gmZ3anzokHAb/uZqbmNzkCDUnZsbSPsYcClcv9WaRgZZW8GRxCUR5vvjRfd0yFZFIM9Mu1w95uqzofvziTBZCrULmsLrZyKr9gHrirSkNXFAJfZM6ijZ2Dfi8bKgIyfAjp8swtFtdsOsOkV3HSXm4FbBwML5Nj+FK42sRatNxDNRyOnYnkdkoAEhRVRXSUA9WJuMI24TUWSTreMxmr4Bh2wXaQv2O80kA8QzD0Ui0aiZmzZjf2Lgv9ZhCjXCj/1uKN8JW4i0JXNpOhtbqY56xjIQnmoW7FCyGKMGl4pg1C3nUVGLpslFbYUCNrBTqVpaVpmy9M/WVJI8ur7Z/PR0xaFGfC2HsXYSY2pwvh9KgierEi0rs9eq5jgNHzW4AplWbUxlovHiczfCrPEf4WW6JQAn4a+0BjiBTG8sl2ActwayTHaZo7bu2QOlt/ana/WYkm9Y/qtS3UiYXnmVCU3yfCpwqpehezyNOlIKexSEYQ8Zjh+m4pyJXRb7A0VM0lQPozHIZQ5P/tDTJ3jfgFVcY+2Bdo7BzZZ4ZpVkYwB+lGUu8K6KeuFOeejYE0JB72OUX13OuKkawCw13rHpVMRJO37k1xR7dqieEivQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39850400004)(346002)(136003)(366004)(451199015)(36756003)(31686004)(53546011)(86362001)(31696002)(7416002)(38100700002)(5660300002)(44832011)(2906002)(38350700002)(2616005)(186003)(83380400001)(52116002)(6506007)(316002)(478600001)(26005)(6512007)(6486002)(54906003)(6916009)(66946007)(66476007)(66556008)(41300700001)(4326008)(8936002)(6666004)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlRhUnY1MDlPSkpyTUlEaW1mTjM5ZWkxMm9JTzhqTGJVNllPVFdRZGVKVTh1?=
 =?utf-8?B?b0h1Tk1Vd29lVVRQRWozeHpPYlJBYW5KWkxPREJrUURjc0FDdDNWZXBlaU1R?=
 =?utf-8?B?UTlpQ2hETmlpcFNodDNncjM0Wm5mTEd5Z0VOZnh5SWxDQ2RXeW9IUnJzREZ5?=
 =?utf-8?B?cEhXbEJNTTgrTnFEbE15YWl5RzNkMnh5NVA1OFVMUkVkYXlwN0MyZjZRVTZM?=
 =?utf-8?B?RDRUNldiMmhENWx0Zkl2dHVpTVM4N01VWXFIMmlZMFVnRStmU0FmekdmTVcz?=
 =?utf-8?B?RGxhMDZXZDNGQzNaTEE3b0NOWWh3K1FidUpHRVBUMTRXN1VUcjZpL2FFaUZj?=
 =?utf-8?B?MHBtQzhBVkRRZ09DdUdpMFpQSVhHMFlkRUJIbkNyM0ZtTG9zOHJsWW84TE03?=
 =?utf-8?B?UEtLbXgxWVFnOThtb25sVUFiMWdSYzgrVCtVVEwyNXNLai93TnQ4TzAraFVh?=
 =?utf-8?B?a005cHlKUjZNWDg1ekY0ZGhSZFV6NnM2TTVaVks0cnVBby81c3hBTGdDZVIr?=
 =?utf-8?B?NEMxZXpYYTI3Q1diWFIzNjNVM2cvaXhyNVJCanI4YXowM0hLT0J4RTlYa0o0?=
 =?utf-8?B?MkZmL005bTVMcnhIUlJMTHFMM0JUVm5DRHV1Szc1eVE5K1pkdTRidHp4TWxu?=
 =?utf-8?B?eXlMQmxVaTBzN2Q4RDlqdzhsYnpxaHIxalBLdnZjUnB2V0FzTXFCeTBlV3Bm?=
 =?utf-8?B?YVFhV3FHbVNIUmZYZkoxbzUxN0VEbHVGRWNXa1RiR1BtdWVTV1JmbzBNT0pS?=
 =?utf-8?B?VW50TldiMURNU0haTHN6ODJzRGV3T3pmdFJYeXpHeDU5aUJmeEE0QytwamVL?=
 =?utf-8?B?N3E1NWQ0MXVDNTByTmNQeCthUC9QMnhTeGl0S1RGN296czFjVE02R0t4TXBP?=
 =?utf-8?B?VTNWKzZHa05Hd3MrN1dkZkd1a0dRTzVJYUpYRWpjaGJFeXB3WnFPaW13dHBu?=
 =?utf-8?B?WGh4QkJRYkl6YTFwOGN0K0JrOWFiMEs0dWVacDJoaG5nUVoxOWkxOWc3MzIw?=
 =?utf-8?B?bGpNL0RhNXM2dmVWYnJBMHRUNHBGTFg4emJzSWp2YTFOZHBBRTBKYldnTjdx?=
 =?utf-8?B?OFY2SHM2YzgxR29LaXdVbTR6UEdhOVcreUhybkV0VWgwalU1Sm1yVklvVVVs?=
 =?utf-8?B?MVlPNFV0RXl5b2JjcWprVisxYkVRRTl6cDRkckFJdjl2LzhBN0dZOVJMWkVk?=
 =?utf-8?B?cWRDOXY2dmZCS09aUWZEQ0lITVJlOE91a2xKOGsrZnZIUThxeG9VbWd6MHFy?=
 =?utf-8?B?VmRnaXJDRHRZTFVPOTIwRlRUREI3ZitxaitUb0xYR0t0NDliK0hCYW16YnND?=
 =?utf-8?B?enFRT0lTY2JGbDJkTEdJc2RsUE9xTEIrbS9uVjB2N3k5Q2VEL0E5N2VFNjdI?=
 =?utf-8?B?R0o3OFJ6K2F2TmVueFgwK2Ryd2FocTdYWXhhL2k0YnVsNjZiUDF1d3o1KzNx?=
 =?utf-8?B?dHV0MlB5WXJrYU1CbW9IOXBRVCtJMU9rdWVubFBXMDRsRkgwbk9OeHdTdkk3?=
 =?utf-8?B?RVVMSTFwTHFFOGh0dGNIa2ordWgvMmgwUDlESnNCOFdHTHgvT083NVZnZ3g3?=
 =?utf-8?B?VTJndmhyNmUrZ2pUb1JXclJjbnJmNndOcTJuMUw1a0RwcUFObmdBRFNHQTlh?=
 =?utf-8?B?clBKUTd0ZXNGWUZIRzkyZE5vQmY4MVpoWXBJbDlYTmJyakdIUjZpbWxub3k3?=
 =?utf-8?B?dXhkN2s0MlFYbFVFbTdUU21aL29uSVoydVpIVXVua0FOamlNNXJLaVBORzh2?=
 =?utf-8?B?Um43NXhIbTllOEpxV2FZMmI4bWl2V2VDbThFaFlGRGlYZVdyNjBTYnNEcHZB?=
 =?utf-8?B?VTk4ZkxKRE4yY0ZHQ2FiNlZVUDU4WW5SWTZWd0ZGYXNzZm1NdUJtYzE2c3dJ?=
 =?utf-8?B?VUdiM2pLUDdLemJTWTErMnJWWlBmK01vdUU0bDlBbEhkdldPYzlFOW5NN0do?=
 =?utf-8?B?SVhBVkt5ZnZEVFpnckFScHRxZ3FPck9nc2hoT3JFemw5cysrQU1SeUdNcGV4?=
 =?utf-8?B?akVqRmQ2bk1KRk0zTi9xL0xGc0dIZkVPOGdDL1FkNlRGcHFWNjJKeVVOSG9h?=
 =?utf-8?B?OUJnbGhwQUFnQ21yRE80TVE0Rkg5eG14QXRNK2tpVi9QZDJRSUJOK1ZpbndO?=
 =?utf-8?B?OU12aFVCa2lsZjdXZ0xiNlFrR09PbDBOMkJid2JEWEpnT2hxVnJkNjZ3UXVt?=
 =?utf-8?B?dFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfb7a7a-d584-4d51-3eaa-08dab0552457
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 15:34:55.8033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuAarAyGJBiA/jVd9UarW9m6/GMrAV6/GMVotVQaF7xBwYUFkqpRsXMpvDz6lWthc5H3rZ9aPvFTdf9KPRdxPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7999
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/22 11:15 AM, Geert Uytterhoeven wrote:
> Hi Sean,
> 
> On Sat, Sep 3, 2022 at 12:00 AM Sean Anderson <sean.anderson@seco.com> wrote:
>> We don't need to remap the base address from the resource twice (once in
>> mac_probe() and again in set_fman_mac_params()). We still need the
>> resource to get the end address, but we can use a single function call
>> to get both at once.
>>
>> While we're at it, use platform_get_mem_or_io and devm_request_resource
>> to map the resource. I think this is the more "correct" way to do things
>> here, since we use the pdev resource, instead of creating a new one.
>> It's still a bit tricky, since we need to ensure that the resource is a
>> child of the fman region when it gets requested.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> Acked-by: Camelia Groza <camelia.groza@nxp.com>
> 
> Thanks for your patch, which is now commit 262f2b782e255b79
> ("net: fman: Map the base address once") in v6.1-rc1.
> 
>> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
>> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
>> @@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
>>
>>         if (mac_dev)
>>                 return sprintf(buf, "%llx",
>> -                               (unsigned long long)mac_dev->res->start);
>> +                               (unsigned long long)mac_dev->vaddr);
> 
> On 32-bit:
> 
>     warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
> 
> Obviously you should cast to "uintptr_t" or "unsigned long" instead,
> and change the "%llx" to "%p" or "%lx"...

Isn't there a %px for this purpose?

> However, taking a closer look:
>   1. The old code exposed a physical address to user space, the new
>      code exposes the mapped virtual address.
>      Is that change intentional?

No, this is not intentional. So to make this backwards-compatible, I
suppose I need a virt_to_phys?

>   2. Virtual addresses are useless in user space.
>      Moreover, addresses printed by "%p" are obfuscated, as this is
>      considered a security issue. Likewise for working around this by
>      casting to an integer.

Yes, you're right that this probably shouldn't be exposed to userspace.

> What's the real purpose of dpaa_eth_show_addr()?

I have no idea. This is a question for Madalin.

> Perhaps it should be removed?

That would be reasonable IMO.

--Sean

>>         else
>>                 return sprintf(buf, "none");
>>  }
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

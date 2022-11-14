Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0734362838A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiKNPIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiKNPIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:08:48 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069D7273F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:08:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lN53NqHJKd41T04ho98dyiRrhSto5peo9IRw5rrfWcq/QOg1Ou2up4nrGpdU2zmG46MjY3CPpvDijcZmhbumEW5R0QQUAbKZITYGbCqsz9sr9eGZj/dIpJgyCdV5z+Q5W1WValP/IKcMLVyALBA+rl/QP9McXVdG3jeOqK4vbHED4g8bbpnf63G9ZdLf1yZ2en09+CBH8VLmWIuK9k62eTkyXMjJxvW/+SOGckIXuGx6u88OOW6DBwE1uCdxA7eWMWFbPZnfBdjx+8yqtzgGrSs7l4z+wC3k8z7cey0Mnff/8eXm4/edTOdrdb5oCU5eX6AOV2boIX7p+OsR3T1eGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W32hLbw7pCZHfAomJVjFwb2rhODGFQ7zJDRq6SDawi4=;
 b=HdSNenv65EAKYAnrmadujOE3mv/p7YhGX2Iyx6M1MIaKqN2FBm0MAGb25Ey2aB+l2nldJQPA8Po2oo4R//1jwG5KkVCvaJ0c8lRIvdnb0pG3/QQ2u3aqmRM7GMHQeT3Hp/yqg363WzM9O46j7NwwQ5g6AkNXShHHqb9CswTCgbzE7ozy3DnUUm8avX9/VLE4Xzj3ZdehpG2pfkGk2FEE3BeprJkD2XoUGozSxKduqt2YigduDXI96BoWI9mFnQb/LgNRXrqvzPRSmitwLrg+Y6doA+rVxoUvL4sOUJKkt9wUbWuYlTar6YwIM4QNmZlUBCRoMIE3QG48M40VPUz87g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W32hLbw7pCZHfAomJVjFwb2rhODGFQ7zJDRq6SDawi4=;
 b=vU9xhCe1rsBlKkrs/qMXWYlw7QOOUz5VqHUN3sA4CeRoj4sM1zkmdvnD2YUDAUTNxhpYrU7Koy+uB1Jo9PzZMfpE5pr2jW93IHVHGE4jBR9fL2qaNMcHqRxR9q6fsb7Zj9E113rzhFHsYuHUeHut46vZz7wsKYp1gY4kxbV7a2Mlzg5+R4raHwJLPSQA3c9MRKLd1PxXGpFmdhMp5FtExKQqcXhJ4GbQB/KOQoO93MPDlEqJC2Bb0+RPepWnnbHk7MwEii6kTjkVGf44O/+ntfDh5Ut4UdGtycA6O+Bn3vr5QBEqwrBb0QPxwJyMtXvAEYQ6o4Y/98LG/ZmjIdR9nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB9PR03MB8423.eurprd03.prod.outlook.com (2603:10a6:10:39a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 15:08:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:08:41 +0000
Message-ID: <e9cc651f-4855-0081-0e62-bd8eae2a15d9@seco.com>
Date:   Mon, 14 Nov 2022 10:08:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
 <20221112004827.oy62fd7aah6alay2@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221112004827.oy62fd7aah6alay2@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0264.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB9PR03MB8423:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b1d248f-83f9-4687-a71a-08dac6521dbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+Rs1q99gePg65BZts5UxTOCU+9WzgJNTpaOe8IijUhBktbdclyXdw71oDObz9HBdvt4+cGPDqn2bhPYF9OnYOk7mHqdpUP9ynV02n0jd58JgysXlHtNXHV6VOE+k1bpBXfqWvngnmas2D1zm5FsiFNnd1hF1BJd5e7/71wtV27HeKzp7GQ41aGOjhIDApjyUscpgsTXknfaNvvEO60Wl9r7Rziyy6FKknpv/pVzIh2rFSxhvOc3LoU0posj5VS9gmjbZtd7DabZ+hnZ2yqHH47aeacgAlQoqezA0PRfRkrcnSC+R4uS1VJSbWUIHsxyoG4AmF5kw8NhibvxbxiHFJq/Gsj7qAetw9dDTDbSdsDIPdsTYCMYWBNrAAQY5epC/gQ9YsG4XTZtm16Yaxgrj3jw56EFrbUiVPdUgA/rOlOOisFHyuzo95qsUFFokdPoO2dWd7Kxbe4BQzp1gh0k66PERG4Q2M5uce7I1MY/ZluBoEZh9/0eE58DIiALDf8GAnK3U2HcWugPwGM45JKEhY8XYWFBZxUcsG2BeKXxno2W/NETYoNNLWOpc5Psl54R0gTdLgJVbbGPezaTONXRAV7OoGZ+fCGV4it7i36ZZUi5Ym5n0FXNFjcqOm4pys5r6dk6OY8W6RevGGkf/8chyiSUFAsrDEa3BNInYeXCcaB4erecz6zcSHZm17oGtBMmKPw3zq8uOnjDXJsmiJZxZVE8XRcVegF/sCesI1AyBUJU3Zk3X+4ARbpVIi5g80CwInT/8TwJzuH8KldaMx36ZyZUp3V6YyKfRFZeSp+TEBwWHMciwjvDl0tqyZDIFLv2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(136003)(39850400004)(451199015)(36756003)(86362001)(31696002)(44832011)(8936002)(2616005)(41300700001)(186003)(5660300002)(53546011)(52116002)(38100700002)(478600001)(26005)(6512007)(6666004)(6506007)(6486002)(38350700002)(4326008)(8676002)(66556008)(66476007)(66946007)(316002)(3480700007)(54906003)(6916009)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0Q3L0V1U2lHOWdBMFpWYXJub0NNR0Fnck12SFhRZ1czZ0RqdDh1VVJaODRW?=
 =?utf-8?B?UGZaZVV6dXNHU3VxQ0pHcDU1eHFxU2NySy9WU3IxZjN2TnFlQWdlQTAwWHhr?=
 =?utf-8?B?Zi9Kc0JldTAwRWNoeW03eDJyZklWem4wbzNvVnArWHBwTjZJWmxiUHBvVFpK?=
 =?utf-8?B?MnY2T1hieCtWczVLazlkMHlKZkNJd3hYNE9QUVdzSllsb2F1WkNiR3Z0d0Ur?=
 =?utf-8?B?ZWZ4bTlxOE1BWTM4VGNla0FnY25HQjJYVTJKdGhrVEY4THE1ZmtkbDdaL0Nm?=
 =?utf-8?B?cHBmSFhXNWFtV1VBc0NibDhOZ1dxSmgxUXhsVGphUHI1ajJZaEM4REhxcktH?=
 =?utf-8?B?QzRVUUFVL3NTa1ZkWlNqUmlnbVBScHBxU0NXdVJVUTlFRFhqR05jZkVwMFdK?=
 =?utf-8?B?SzVlaEZUZm10WlRCWEFpTVZKclZCNUxjeE96Y1o5TXQzQjVjVlNFbmREenJH?=
 =?utf-8?B?RmlObEdXRGlCUzRiajUybVdmbm9rUTlZOXRCL2kwaTRRcGFTNHVsU0FzZndC?=
 =?utf-8?B?OE5rZExUL2w1K08zUlR1MlNGei9Rall5Nk5EWW5RaU5UZldUWmROQ0ZXdHMz?=
 =?utf-8?B?VXlwTHhFblFVcnFqYkpGQmx0SDkzbjRyanc2N251M3F5cHl6bGYveVVqYjBi?=
 =?utf-8?B?Y0x6S1ZJUzYvdHZHalRhTVdEMWQrSTVZZnBIaGdDTXlsOFZpNDU3N1pBYkZH?=
 =?utf-8?B?QW13NllhL0xqV1ZlUnpPOVpHSk01ZmZpdHUrN2xMUHgzZFhmU2lEdmhocTdu?=
 =?utf-8?B?Mm5KOXp4UG8yUWdqVmdlV1RUNWJMRGEzRlVFSE5TdzRDTGt3NUFtV1p3R0Iw?=
 =?utf-8?B?SnNYbzlLY1VTS3FMem5RNFBvTlFhNWFoMytyY0p0dEJsRlpsMEIxS2p5cU1w?=
 =?utf-8?B?eDBndWNiRUprUzhCSzB3azQ0V2p6N3JGU0ZDNUZzalloL2xaTnRER2k1M0Jv?=
 =?utf-8?B?YnoyQ3RJNEJ4Nlorcm0wTElBSUZtdThNVzFaYkplSXVKaGkrU283VmFhUlJq?=
 =?utf-8?B?WFRwT2dNWFVqdnQva3BCUUJTWEV1eXhUVERjekgxZlNxZmgzeEd1bUE0V1V5?=
 =?utf-8?B?dGpQZEhkMThyRlZsZ3ZLbW5YL1lKSmZ3MGJVYk1vT29iVXptQzErMk0xMkFa?=
 =?utf-8?B?RVBVUnVyd3ZaQTl1OVdMYlZxZDh0NUR4bUUzN1o4ZUx0NGpSeUpHNXdFcGh5?=
 =?utf-8?B?Z0lURExqamNVVlFrOVd3dFRXWlZSNldCZ1FFYmE5TXBxRzZyU1FMWjVvZXVP?=
 =?utf-8?B?WDQxbFkyQUJVNUYwVTk0YXQrdWRBV2ZzajZWODhIV1pBcU5tekNZQmt2Qkxy?=
 =?utf-8?B?QksvaG1nQW1aOHZYbGRYbEJDRkZNSU5iYmFlWjhkWmYzY2VpdHhDaWp6Nm1y?=
 =?utf-8?B?OGZhVGJ3T09JUnhmWWo5bTgvRTNXNUZ1QzNnN0x4TlVtbkpEYjZQWkVocG5i?=
 =?utf-8?B?RGEwZ25BWDJuTmdtRmFzTmNMREM5NERZNGpCSDA3akx3Vi9va1I2RzU0ZWw0?=
 =?utf-8?B?NlpJUzZIWTkrSzdGN1gxQVhObElVbUlKb1htdEU4Q2I5TFVkejlFbG8zV29q?=
 =?utf-8?B?VXVnd2w1Nkk4NjZhSUQwUVJHQXNqQjR0QTRGYmJSaTVWeHlPek12NGdGZWF5?=
 =?utf-8?B?MlpGbi81V2ZoMFJiMWJLMTV3TG1hUDBGS0FocHd1eEVabUFBTW5iWW5QbjVi?=
 =?utf-8?B?RUg1b29YOVcxVmgrdEtzVkdXekZNb1YzRHBvOFpyV2VsaXhkdWM4bVpQWFZT?=
 =?utf-8?B?aW5qTFViUGlONlBVY3duaitBV2JaTFJvaTRsbEF1QVdZa3UyR3NXSHZFOG1j?=
 =?utf-8?B?TytndlhiVGFoWFlUVHVsRm9vVGNMK1Z2d0FLeWpod3RSMlA5UzJiOUhPOGRk?=
 =?utf-8?B?MWtqWGh0N0tuY3UyRUJOK2JDYW5OL3RqaTczZDdaVitXQUdsL0hKMjVwWEtE?=
 =?utf-8?B?SFZYRHhnWXBTVDR3dWRLaVJNL2NYOG1sQmV4LzVzT0Evc2Q5K1o1WHV5ZnBL?=
 =?utf-8?B?b1N0WXV1dFBJQkh6NnpjZFJCTWVEdnR2QWRETnNxS2pXNkFNUG5WWkJEejVZ?=
 =?utf-8?B?dG0rdnpycnhrYmNPNE45Ry9TQlFkQXJEM0ttRmwvNmEwTXJ0cy9xdk80Rkxl?=
 =?utf-8?Q?HYtdPQJIZtOBfKuXV7gW1I5/8?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1d248f-83f9-4687-a71a-08dac6521dbe
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 15:08:41.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86RNPDR3OdG0QPdhwecgVGIHKS6sdrG55SusWKILaGhEIfDyz7tCDC+s0GzU6bTScjKY7R9IYeo/IifRYu25MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB8423
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 19:48, Vladimir Oltean wrote:
> On Fri, Nov 11, 2022 at 05:38:12PM -0500, Sean Anderson wrote:
>> > Something interesting is that when I configured the xmdio node with an
>> > interrupt I ended up in a mode where 5g,2.5g and 1g all worked for at
>> > least 1 test. There was something wrong with my interrupt
>> > configuration (i'm not clear if the AQR113C's interrupt should be
>> > IRQ_TYPE_LEVEL_LOW, IRQ_TYPE_EDGE_FALLING or something different).
>> 
>> NXP use IRQ_TYPE_LEVEL_HIGH on the LS1046ARDB.
> 
> Partly true, but mostly false. What is described in fsl-ls1046a-rdb.dts as:
> 
> 	interrupts = <0 131 4>;
> 
> should really have been described as:
> 
> 	interrupts-extended = <&extirq 0 IRQ_TYPE_LEVEL_LOW>;
> 
> There's a polarity inverter which inverts the signal by default,
> changing what the GIC sees. The first description bypasses it.

Ah. I missed that they described it as going straight to the GIC, skipping
the extirq. Thanks for pointing that out.

--Sean

> So that's not what the problem is in Tim's case.
> 
> As to LEVEL_LOW vs EDGE_FALLING, I suppose the only real difference is
> if the interrupt line is shared with other peripherals?


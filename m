Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F15458E35C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiHIWlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiHIWle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:41:34 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20044.outbound.protection.outlook.com [40.107.2.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04AE6564F;
        Tue,  9 Aug 2022 15:41:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N06YEAUzeL6bVHKVTkJQ5TPBXfhg2mN/sV/WwVgkqe8HcC2PsUDGjpgibUFgswTwznydyXeCvS6PpSF/CbIXl+KZRE+Ar6GymX3SaX+1TUrBMTXgqqR4Pt20FC9FFAY7Mw/qe9QFDwKhzrkuzcQU9Z7WQWDDOYH9rSmtf3+5/85VKuTmsGflci2sP2ti+FLjkg6U3cl9YM94OlaywwYYs1BVCKD+PcRQN5TO0/AQCZSQQlbBv8x7D2R0FUaKEWBvJQDb11/b5AZoISPOHy4FsYCZery8v7kwpYe2AoXmCFF7z1Y25KqDTbCa/r7nVuTiDBwDasMP5Ej6pgTGAZgJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upMtdCKpSfrsR52412dJwMJBfATAwPjQmZvNqYQbH2w=;
 b=dfqMEoFKgt8NMBN3FxcfVoEIrpMCoeDEkasIWFWlzLkk4Y1xwGr03Q8+tn6R5vthhJ5+RLjOekDPgR/ZkDN74EufhZF7TMMPGzV3PLrr4G7KPLz46N71hfQQ6CBvwFxvnU3JFIgggK82Z3u3sy5u3uVnbEyG93+P5UyWEZXxDM3esfOaR1Vz20Wh9UeSNlE0jzMJvza2gtpjayiyOrwR81kkwPcDq2JZ9FSLyNzl7K7KlKqPWxfzt6dANyro1cwbEhbFvlrKgTg/+AMxgbKSeK0Genv/zuGBapCG+0pi3IMEnrmF92w8G12PtnSzj7kG3Q+DU4qulfIPCQndiGFU8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upMtdCKpSfrsR52412dJwMJBfATAwPjQmZvNqYQbH2w=;
 b=zJXMdKx478NZmCcH5HwdgD4IpNUZURu0BCQEJei+mS4z/QPqQkZ3iqFb2EgUJ1KHZbWm53pcNflqTiTKWA4LxsD9q1usAjsHzSqT4PVisxAEK4PdvR4jv1Ph6qg+J7K9Y22TdlMcZfE7LhhMbZ3bzAjpnqNl5eJkEKMdbBIKRvxaiQiCXhS927vGyIkaly5o4UKi+k6pel6BTlTxrH6Ni0LGIdCMyANJlZDzqU948hlQUKbNP+CCgV+lXarLWD2RXXGMRXdCvt9osM7mYU9i9AiYBM5kV2oLIfvNrXRSoevvxxlkSyuW5vvqybv6VCFT1etahKgrdQ41tpJhfU0nHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR0302MB3206.eurprd03.prod.outlook.com (2603:10a6:209:1f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 9 Aug
 2022 22:41:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Tue, 9 Aug 2022
 22:41:29 +0000
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
Date:   Tue, 9 Aug 2022 18:41:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220809214207.bd4o7yzloi4npzf7@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:208:329::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0dc219c-d407-477b-b327-08da7a584d22
X-MS-TrafficTypeDiagnostic: AM6PR0302MB3206:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFQqb3J6f1TjlVKoSH/8PO1iA8SRav+zKBI+Zd1xu3YXXspg9TQR7yRQ+b5w+0nnBVt49qJCHNyKdwla9C3qbiJlo9zAAl80wTqO0r/utxBW7yX4v6pRVUC7oubkb8eG8RxirEGpQQnBcR6cRI3wpJNnMhJRQNF04TsTUmNnqqpdq3/tiK6V9qhg528adjR0AHC1LCGz7jZ6KyVFSujbymhXfT8MaACnqngAqYqAxm5T0T6MLjivp0RmVcccVvCRh0nn56kLGMcbWVN8IBlWY54glnDAdyGprN9h/dZ0bYhWG9x05AtDZLixqXKoEmQPqAaqJciKApmZCHDi+IR9oockScP54uUkOT70p5kgpKeES8WSwBFyKYPLEwpWtaazmnaVEVXPYTH50DVqxakFEzD6aKpMa848UlqKAx12liHxBJyDTk4oSLsvah5ykjKvOioXkdAupbkC5vIn1e5tEb7rgrj3stPqiBFDnUx3CPTFN6uwbopzcRjeTf7DYMHTS+ko3PzpVz46ZGnPbYjZ79Z6wMSOloCkWjVycPsrWL6aOcGm09eRUSlKdjnikv5/GyLZO3D9NOSJ1eIVGXSJJMmqXQJeCe/om8nc4xqP4xwnTt1tk9oTTKDzDCnWuW382ayLKzGxBd8HPCHBEwGS34c+mT8jg/dPIBs1h2VJDisHn94+Sbth0NqEqUJ9sNOqgx9UrZOiBweqyTjUeX325gXRH1WStqAAxTJ+uFQi3SlWLBkaTUXBjnWSuvAp/8pa6d7x4Wb2tVYmGLA8k+fnLZZqJmKsmmZcnqYcm9/MvWGo1WX2iZNzRGaVve0w+uisCEG3rVjQsPGJHLbOYbh7OvcW+CmRV9w8Bl12VppI8FAWFXN9VyPOboL4WvwAxXPOoGu9n6O0wpVoN99r6AL2hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(136003)(376002)(39850400004)(31696002)(26005)(6512007)(86362001)(41300700001)(52116002)(6666004)(2616005)(6506007)(38100700002)(38350700002)(53546011)(4326008)(83380400001)(66574015)(186003)(8676002)(66476007)(66556008)(36756003)(44832011)(66946007)(2906002)(5660300002)(54906003)(31686004)(8936002)(6486002)(966005)(478600001)(6916009)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zk9PK1VONjkxRDYwbnVzTmgrRVIrOVlTbHc0THc5Wklkck9KM1VlY1VwUE9s?=
 =?utf-8?B?ZHVFTFRFaVl6VDc0aWJtR3ZxUDU4dnVlNWg5cjhqWGNJQVNzcmNtcXU1bHFK?=
 =?utf-8?B?M0tmNTBNNk5NS1YxWmxKYnhSUFFDV1E2YTVtTkNSMFVycjVoL3VaS1kxclZM?=
 =?utf-8?B?eVJGK3l5dlZWUUJLOUd6dDlXd3dzcE5uMUNyaUovOS9hNjR4RFJmOUI5elhw?=
 =?utf-8?B?TDhOb2phMGZ6VUFjdE43M2I3ajhkaFJtb3l6YlpNbURheVV6b1hiYk1PUGph?=
 =?utf-8?B?aUhUVjk1dXA1Zm5GZ1RMN0dxdEo1eHpxKzEzOGlsNWpUTWcvNm00ZXZHYmQz?=
 =?utf-8?B?WVl0Y09iMkFOdlFhNUR0ZThZYWVHZnFPanN6ZHduT1h2VlZpZHVqM0VKcEZL?=
 =?utf-8?B?RkxobzR2U3UxV3Mxdyt5U2EreGpVM2k1cmkwSzVSVSt2d0p6TWNhV3c2VW43?=
 =?utf-8?B?Q3lZcjRpOHhBdm9jSm9CazBPMXdvOStDRERIT0oxWXFDWlhNcDFwbWFPYTZ6?=
 =?utf-8?B?bDloQnlKbTdZNlRSQzNRSitiUUE5VFNyaTJnMU5GcS9kaS85YUdOMEFSSTJK?=
 =?utf-8?B?SGlUQ0xudjAvZmNxaUxVaERLR3dRRlZMNHVPellsZEJSc1NTUHJHTXdiTTFq?=
 =?utf-8?B?L2J6ZldVRmF3WmVDZ1VaNUlRZkd3UHN5KzFCZlhGcU5UZkhhTkRyUFVRREQ4?=
 =?utf-8?B?QnptQW93cWM0UDdMSVZOdFhpWUNha0ZVS1k5R09ZRGZqRWNlcys1TGJZRUov?=
 =?utf-8?B?eEMyelVGZExFSUlXZHpaaXpzVjI2RlNheUE2VklQNVd2cllnMENHTms0SVR2?=
 =?utf-8?B?RnAxSVR4ZHNJRzlFRGY3bC9NdURWTVZ2RkNFWk9RNW55dDRDVGY5QTlEZ0tE?=
 =?utf-8?B?MkJTT0hMR0VGVG9PbGVYYVdEbGx4Q2YyTnE5aTdqc2kwWkV0V2h6U29JaXZu?=
 =?utf-8?B?WHhWM2dLZ1ZyTGJIUW9NRHFPcXQ3S2p4anJ1aVduUUVOMEcwSUU5SXd3VExz?=
 =?utf-8?B?NXBodzI1NkxaTFVJOHVlZXlPQXpwbWEzOXJlQVcxTVdPRytSaGtTeWtNVUV4?=
 =?utf-8?B?N1JmanFoQ3U0bHNwSlc0dkpFQUdoaTU0b25UdEpSNUE2eERmZkRKR2s5UG54?=
 =?utf-8?B?bmorRXpvdnB1RlkzOENBb0F5L2hBVjBvTWZlRGJneHY0clJ6cUQxbzhWRkJt?=
 =?utf-8?B?bmgxUGNSTmdmU3dGZms2NWFCdDlYRDFVWlRtUkNhdVFyeXVhMm1ML2kyb05S?=
 =?utf-8?B?NGxjaUxJYnlvdW95QU1aVWhvOExiNzExRVE0YXlreDBmTllSZG5WWjF5RmR3?=
 =?utf-8?B?S3ZVWkMzbGpXMDlXbU9zN0hrSjRCSjBaZVNWa3ZKUjhpOFIyR25hUklKWFI1?=
 =?utf-8?B?dFl1UlB0VGpxSnpOT2NSN2pGdUVBRUt2eFZQd2w4SXZWV01nRlFYcVo3OGxw?=
 =?utf-8?B?V1UrVE1sOVlBaHFaOGpmb1RyTGdBUWxkVmxCb0tlV2dVeWFpVjM1QWNxejBN?=
 =?utf-8?B?M3ZDdjBLbVRrRFpWVTJ3Q3hZSFM1S3YvdHliMkdNQk9tS2Q1WkFnKzgrT3lu?=
 =?utf-8?B?bzkxQms2cHJPczR3MGExS3hJNDRseVh6RDlpODhraTNBODkwUGRibnBjbHhz?=
 =?utf-8?B?anIxYkh4NzNUZ1BkVE0xaWZ1UWxQSzJTeXRTeFc4TEdqcm1PVVh6a1YxbnJR?=
 =?utf-8?B?NGZsOTBiUDJLNENyNFJjUEZCTVVjNE9mRyt4Y2JKV3h1bHd1T1NwUXRyTW5r?=
 =?utf-8?B?MUxoaVUyTkphcUFxM2J0amRRbGRVaE5XRktUMmY3S1VDbDhPUCtjUDE4OGdk?=
 =?utf-8?B?TjNvcDhTdGVsUFJmWStTS0xyMTVia3FLb1MrU01SUmhSd1c3UEhHNXJBNGhZ?=
 =?utf-8?B?RExjNmZOeXo4UG11NnVPVEFDT2FJV3FsbnIyM1k0N0RrTi83YVVYdTIzbmlo?=
 =?utf-8?B?WGJqS1lVejVZTUtRcHhXU2VtRVJxdmlTcnhNVXRubUt0TGZBOGtjTUhzNjZa?=
 =?utf-8?B?Q2xMN3RsYkdJRnZKZmk3ZDJqMXdBT1k1UTIzU2dtUjVQQXpaVStJdWhqZEZX?=
 =?utf-8?B?VG1Vc3JoeXVFcjdBYyt5OVl1TE9SMmM2cUljcVRwTE1sR3VNQVpuOXhNNVAy?=
 =?utf-8?B?RytoL0FaemNBZkRYS1ZDUUJCUUNaRGdIT3BjNzUvOW5pakI2NS9HS3BnL0hH?=
 =?utf-8?B?QXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0dc219c-d407-477b-b327-08da7a584d22
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 22:41:29.7739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7g/+Gm/zUmxzyOZbWc6s1rPjlbfaOGYdF2LDWfr6lbwv6EBSSojPbj2cFhtLse28zSIF4YgPFbmeNeAOtE3Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3206
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/22 5:42 PM, Pali Rohár wrote:
> On Tuesday 09 August 2022 17:36:52 Sean Anderson wrote:
>> On 8/9/22 5:31 PM, Pali Rohár wrote:
>> > On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
>> >> On 8/8/22 5:45 PM, Michal Suchánek wrote:
>> >> > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
>> >> >> On Mon, 8 Aug 2022 23:09:45 +0200
>> >> >> Michal Suchánek <msuchanek@suse.de> wrote:
>> >> >> 
>> >> >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
>> >> >> > > Hi Tim,
>> >> >> > > 
>> >> >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:  
>> >> >> > > > Greetings,
>> >> >> > > > 
>> >> >> > > > I'm trying to understand if there is any implication of 'ethernet<n>'
>> >> >> > > > aliases in Linux such as:
>> >> >> > > >         aliases {
>> >> >> > > >                 ethernet0 = &eqos;
>> >> >> > > >                 ethernet1 = &fec;
>> >> >> > > >                 ethernet2 = &lan1;
>> >> >> > > >                 ethernet3 = &lan2;
>> >> >> > > >                 ethernet4 = &lan3;
>> >> >> > > >                 ethernet5 = &lan4;
>> >> >> > > >                 ethernet6 = &lan5;
>> >> >> > > >         };
>> >> >> > > > 
>> >> >> > > > I know U-Boot boards that use device-tree will use these aliases to
>> >> >> > > > name the devices in U-Boot such that the device with alias 'ethernet0'
>> >> >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
>> >> >> > > > appears that the naming of network devices that are embedded (ie SoC)
>> >> >> > > > vs enumerated (ie pci/usb) are always based on device registration
>> >> >> > > > order which for static drivers depends on Makefile linking order and
>> >> >> > > > has nothing to do with device-tree.
>> >> >> > > > 
>> >> >> > > > Is there currently any way to control network device naming in Linux
>> >> >> > > > other than udev?  
>> >> >> > > 
>> >> >> > > You can also use systemd-networkd et al. (but that is the same kind of mechanism)
>> >> >> > >   
>> >> >> > > > Does Linux use the ethernet<n> aliases for anything at all?  
>> >> >> > > 
>> >> >> > > No :l  
>> >> >> > 
>> >> >> > Maybe it's a great opportunity for porting biosdevname to DT based
>> >> >> > platforms ;-)
>> >> >> 
>> >> >> Sorry, biosdevname was wrong way to do things.
>> >> >> Did you look at the internals, it was dumpster diving as root into BIOS.
>> >> > 
>> >> > When it's BIOS what defines the names then you have to read them from
>> >> > the BIOS. Recently it was updated to use some sysfs file or whatver.
>> >> > It's not like you would use any of that code with DT, anyway.
>> >> > 
>> >> >> Systemd-networkd does things in much more supportable manner using existing
>> >> >> sysfs API's.
>> >> > 
>> >> > Which is a dumpster of systemd code, no thanks.
>> >> > 
>> >> > I want my device naming independent of the init system, especially if
>> >> > it's systemd.
>> >> 
>> >> Well, there's always nameif...
>> >> 
>> >> That said, I have made [1] for people using systemd-networkd.
>> >> 
>> >> --Sean
>> >> 
>> >> [1] https://github.com/systemd/systemd/pull/24265
>> > 
>> > Hello!
>> > 
>> > In some cases "label" DT property can be used also as interface name.
>> > For example this property is already used by DSA kernel driver.
>> > 
>> > I created very simple script which renames all interfaces in system to
>> > their "label" DT property (if there is any defined).
>> > 
>> > #!/bin/sh
>> > for iface in `ls /sys/class/net/`; do
>> > 	for of_node in of_node device/of_node; do
>> > 		if test -e /sys/class/net/$iface/$of_node/; then
>> > 			label=`cat /sys/class/net/$iface/$of_node/label 2>/dev/null`
>> > 			if test -n "$label" && test "$label" != "$iface"; then
>> > 				echo "Renaming net interface $iface to $label..."
>> > 				up=$((`cat /sys/class/net/$iface/flags 2>/dev/null || echo 1` & 0x1))
>> > 				if test "$up" != "0"; then
>> > 					ip link set dev $iface down
>> > 				fi
>> > 				ip link set dev $iface name "$label" && iface=$label
>> > 				if test "$up" != "0"; then
>> > 					ip link set dev $iface up
>> > 				fi
>> > 			fi
>> > 			break
>> > 		fi
>> > 	done
>> > done
>> > 
>> > Maybe it would be better first to use "label" and then use ethernet alias?
>> > 
>> 
>> It looks like there is already precedent for using ID_NET_LABEL_ONBOARD for
>> this purpose (on SMBios boards). It should be a fairly simple extension to
>> add that as well. However, I didn't find any uses of this in Linux or U-Boot
>> (although I did find plenty of ethernet LEDs). Do you have an example you
>> could point me to?
>> 
>> --Sean
> 
> In linux:
> $ git grep '"label"' net/dsa/dsa2.c
> net/dsa/dsa2.c: const char *name = of_get_property(dn, "label", NULL);
> 

Hm, if Linux is using the label, then do we need to rename things in userspace?

--Sean

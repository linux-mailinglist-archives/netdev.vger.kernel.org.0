Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626DD569BFD
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiGGHos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbiGGHoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:44:46 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2213205B;
        Thu,  7 Jul 2022 00:44:43 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2675qXXE003325;
        Thu, 7 Jul 2022 09:44:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=wrazCnjBeTpwWirSZQRmWZdTO1DWvaddAjwCeCht0XY=;
 b=m2QpU59nwKrFkqW+Nu5iKM812GDqFulYKfQPOZapv/bbfZwq8sPqwVFg1N4I4d1sXBaP
 FJONmpp8ldAzByXihLECaKSR/UKjNO3edWB+ziVx8V4Jg4KHXdspZ3/PHjCFECAf/CrO
 rT399xg8P7tvDFHJPsTvUe8NbSs7uvjlWtv+S2cDq2jww9c105t7Eenyz1+rgijEXryz
 DH0h53mKcR4zHRdJC2G0q8MWGCPnqvKov/FWmzA0I+EQ8p7cuA5IiZMXMeXaHISEoRJh
 mKZMvXtKFiVfgHPnwCL6IcVxutUrcsKeN6Ipi0tk4Jo1T2g8Vu3rD9CjBTOPA2gNgTQW 8A== 
Received: from mail.beijerelectronics.com ([195.67.87.132])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h4ubysm54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 09:44:12 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX02GLOBAL.beijerelectronics.com (10.101.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 7 Jul 2022 09:44:11 +0200
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (104.47.12.52) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Thu, 7 Jul 2022 09:44:11 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITkHxOlwpjvRSb0xgAr9UOyrV7hXzQWoGI645hIlqMPtjL5tEBC7JxYQcb0wW7DSKirtgKZMPZSeKOIIqpPBsh8e681put+/KVU7U4NbUh3znAUi+RnZvGxZFYEyPkf5tSaoHgEduZqBs606/vIwl0GDZx31vY73ooKAImjIYmv4lKT3bMvQyiVHVCb5NamQoSsMbzxgnqLF1hhMwtvJU0eM9tmuH1W1gEwdHh0oIHn6+oAVbcTDnPwViQ0VrQXJDYsT3vqFJboa5FTcZ1o3TfC2K+j8P07zRhZZm7o/Yiih8hXioB3qD3EgPZNRVZDTY2qD8IPYP6Nnl1NDTLhErg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrazCnjBeTpwWirSZQRmWZdTO1DWvaddAjwCeCht0XY=;
 b=g1oIkYIrHASm1uA9o0xax6nuzOLunlowzHK0UYpLyUjp4/eC1F4wPtS1BsTHA453+SzeEY80emBt8kcToPjW2YAofrz9/m9+bMRbeI4zz1uXADOzx2vlooTmb6sE5x6ETcLfoLyvXx8KyUTab4YHFY/v3/tjVe4FSewp+7itVs1qOrsKDPFCa1XUgF/Whs21Q+wlj9XdU4eWjJ3zXiV9RHbH9a1LA51O8lh3usLU4qKycsn9GiitW1ZZ4vwP2nXmuA4WuI7LkWYmLv6X9MXpTEUBY8VYB3ET30qLFJOz+2uOfQN9vFSqGsWjrQKYQNZJ12WePK37U6c5ZAsDqTmSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrazCnjBeTpwWirSZQRmWZdTO1DWvaddAjwCeCht0XY=;
 b=Zw1eLrwI2yOhssp2IYi/w9lyaRl2sRkkBEX4JofzswoUqyq3WPlvMxSC48PB3M6igRKW6lF7OCcoa1+vVeQeo1DRNDSZMG6wX7iaXLF0s1rl64ygM2WOR3edIlL6HFAHPoLn/7mgHYtFsq6VdhN8gQ429Q+f++rqsBMsr8quP/8=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by AM0P192MB0484.EURP192.PROD.OUTLOOK.COM (2603:10a6:208:45::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Thu, 7 Jul
 2022 07:44:10 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%6]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 07:44:10 +0000
Message-ID: <45a19551-6004-2453-2f16-a7af5d5c0a59@westermo.com>
Date:   Thu, 7 Jul 2022 09:44:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>
References: <20220706160021.10710-1-matthias.may@westermo.com>
 <CAHsH6GsN=kykC32efTWhHKSPqi8Qn3HYgRursSSY2JiFf2hijw@mail.gmail.com>
From:   Matthias May <matthias.may@westermo.com>
Autocrypt: addr=matthias.may@westermo.com; keydata=
 xjMEX4AtKhYJKwYBBAHaRw8BAQdA2IyjGBS2NbuL0F3NsiMsHp16B5GiXHP9BfSgRcI4rgLN
 KE1hdHRoaWFzIE1heSA8bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT7ClgQTFggAPhYhBHfj
 Ao2HgnGv7h0n/d92tgRTPA2+BQJfgC0qAhsDBQkJZgGABQsJCAcCBhUKCQgLAgQWAgMBAh4B
 AheAAAoJEN92tgRTPA2+J/YBANR7Q1w436MVMDaIOmnxP9FimzEpsHorYNQfe8fp4cjPAP9v
 Ccg5Qd3odmd0orodCB6qXqLwOHexh+N60F8I0TuTBc44BF+ALSoSCisGAQQBl1UBBQEBB0CU
 u0gESJr6GFA6GopcHFxtL/WH7nalrP2NoCGTFWdXWgMBCAfCfgQYFggAJhYhBHfjAo2HgnGv
 7h0n/d92tgRTPA2+BQJfgC0qAhsMBQkJZgGAAAoJEN92tgRTPA2+IQoA/2Vg2VE+hB5i4MOI
 PWGsf80E9zA0Cv/489ps7HaHFuSzAQCm8MVuy6EsMIBXQ84nTb0anpfLHCQMsRNMuW/GkELh CA==
Subject: Re: [PATCH net-next v2] ip_tunnel: allow to inherit from VLAN
 encapsulated IP frames
In-Reply-To: <CAHsH6GsN=kykC32efTWhHKSPqi8Qn3HYgRursSSY2JiFf2hijw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------07XW4SVKDtMY90NgGQfttqae"
X-ClientProxiedBy: GV3P280CA0112.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::23) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78678dd0-ba02-4888-acfc-08da5fec7a8a
X-MS-TrafficTypeDiagnostic: AM0P192MB0484:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdLgvYZIVYzJBtFrdHxxCI5q5j0cXVMkpYhv8FwHw5YSlf1d7iabPWRuZXGjrpUfhckj2uonGkuXXBvpXfmnMuT2+sbZuTmJJK3C14iODKZ/JV9ZaEBvy4LhBPKxtFTtNKpOSBFaPMVE9G7D1oAWzk2rigV9wQpkiqmffDW8R3WkmVeTsLhdvIryKKJZQgZbiLyLoan5vaobqmlRiRGhcP6YtCo+Se9J2nIFms4f8Zh0EB189kFShrbUZbsK+AfrEGJ+MhFHjHlB7RZgrnB5Y04B0uPG3rJBUPtzMD0boohL9VkDmhC4lG4IT2U7behagUyu3gUlJcOKRT9jr8tUIcky0Sj28Nt2jgNLPnXynk7gmWC+I0tT0fR11k+piVSgxXRsx6WtOwvHzl7JKQ7in9PvyhjDKF4okHxQ/yb1ruM/sC3egayoYezHoAvZrbPQDOEKP5GR35pXF7KszVdDTSXvAtxvh1SNxtFpgnoMP/hZRO69vlD/asRXC5uoE6PVMMQ38fpvBM0r8bVBmmP1c6RxDNlnamgLmmoWEbMnye7BXkBo0yIFhZZvLp9Yj2Q6ZMDKGY071KB78JPJALR8Zb3axHwXxy0Anwyz4jzmh0LLBVLmUbTGoh/q2jBHIRw4rTO7E011HrLX0zKldbvFNsiQDoFPMM4cPADSVfesKTWzO1WjEvFWTQUn8/OMbmDOkDc77XxL8aLQZLS0UxN+H1Z9In1E2EWLQjT+Ki7e9PRJPeL5BU0PyCy2ygCY8FvnzS/bstxXmbIeczQUUK4qtnBSmDlwmqUG0bASmpO5PB4v9eri/loOU4EwOMPu4dHlkZsNg3Genc5IpGXRG+ueWn934EzUXKZseg9/MV92uhaRrWW8VwPLITiPFjc0rAnw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39850400004)(346002)(376002)(136003)(366004)(83380400001)(38100700002)(38350700002)(6666004)(316002)(41300700001)(31686004)(4326008)(36756003)(2906002)(66556008)(21480400003)(186003)(6512007)(5660300002)(235185007)(8676002)(44832011)(86362001)(33964004)(53546011)(52116002)(2616005)(8936002)(6916009)(66946007)(478600001)(66476007)(26005)(6486002)(31696002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmNrUk1kR2x1WmlGZnZHNmxmdmJSVERmK2NYKzNDUjB2TkVnaHRoM21SRmhU?=
 =?utf-8?B?ZEtYTndaeEkrQWRmakhScWwyem4wL1lBRUtqUkdQNGJJQk50RUdtTnNBRllt?=
 =?utf-8?B?SElmK1pNTTdNdnRFUWg1NVh4eHVJUG54Z0krcTRidktxYlpCNGRZM1pGU3RO?=
 =?utf-8?B?ZzdYWlBEaUx4T1YvaWx5K3h6eXdlUWdLL2J1TE1sRHBRV3E3NWxVbzNiV1lU?=
 =?utf-8?B?ZzY0SUNGS3JFQmoxeUZzKzRaUWFWUVlnR3hONDBlM1FzR2FvQUVBRVR2Zy9z?=
 =?utf-8?B?QlZjZkx1YzEvUUZOSkVqREViQjB3WExWa01oaWZlOHZCdnF1akhCanNDU1hQ?=
 =?utf-8?B?MnhNSTVCNENZS0hjWFJLUE43dVBUVU9sRUozTkNMZkNCVWZxd2ZBaC9SeUpO?=
 =?utf-8?B?dmFhYmRWTFNuWC9Dc1Bsd3gyVTVzVHlIbnRLbFR5OTA1azhtMVlPTnowMFFJ?=
 =?utf-8?B?anBVa0hmVDN4YzJ2RldKLzd3YitWcWJjQUpmRnliSXY4bmR2ZkN6L2J0Tkg3?=
 =?utf-8?B?c0hCand1MjFVS3hvSGVYOTE5S3VMeUVJQkJUYVBpalNsUzAvSW4yYytGSUpi?=
 =?utf-8?B?c1BUWXR6NXI5R2trdytFeXJnRVBHbkljUzB2ZlZNQVJQVlZlWEltUzZzVHFh?=
 =?utf-8?B?Qko4L3UvQmNDQWdPaHMxVSs3UzZRZUZFU3k3WE5PcjNRMmhXM2YwblZUT0tX?=
 =?utf-8?B?eDhoNXAwR0RmckFmdWFwQ0JZaDU3dGZQU1R3MW4yZHdDbDRaQ2JRTU5zVkhP?=
 =?utf-8?B?K244YzU2eENRVHVwVitQa1JMbUE3MTUrNlo1ZzJjVlc4OXB6a2NRNVBGalNQ?=
 =?utf-8?B?ZWxFL3N1Qjc5RFVzZ0VYaytjSHNYRE9pYlhUak12SFV3WFZxRHBCTG9tb1NT?=
 =?utf-8?B?UDJwSHJ5OG5XOEkrTU9wMkIvVVJqRUlONlYyM2hETCt4QXE0WUxxZ3J6N1VS?=
 =?utf-8?B?UDIxK1lObk1iNkVPaEwwMFNzY0tXbHg3TDFxZXBXdmN4L0RpcEhiT3VvMEEw?=
 =?utf-8?B?RWFvSWxqdnNMUE1vZXRacVZiMk12czN0NFJCb2FUeUxaZ0FtaCtYd2RXbHFP?=
 =?utf-8?B?c3pSU0NaSzhxUG42LzhYZFhtaHpJZ0NZa0pNQ05OVkNWUDFZdHpVZUJybUtO?=
 =?utf-8?B?ejQ5NzdJUEZYRGUwTGMxZHBFblFLMUQ3Nm5RUVFDNmhSR2h2S0ZRaEsvd1pP?=
 =?utf-8?B?M0RCekRWclRPMTdOYlBrcGRNMFVSQkI5b055ZG1qSkc5cDB6L2FxWW9jUEZR?=
 =?utf-8?B?NzBSancwZ3NNM2ZsN0YrcHhpdDNuZS80MjVWai9rZTZDMzhUOFNUazlkM2xp?=
 =?utf-8?B?aDcvOFhZeHRuMHhtYklkMWlJTG9WN2U5L3ZwR2lERkQ5ekx6ajhDQVk5b3Na?=
 =?utf-8?B?RUNaS2FQdCtXYzZOekZQL2JTOEpiTmFidG5TaGFKNTN3VHBQa3hPRHZCeVc1?=
 =?utf-8?B?YjUxUFpiRW9RMVFFeDgzMDdFS2FiT2JiMC9pUk8wVUo2TnloakZOZHRLdFRr?=
 =?utf-8?B?VG1TdUxwVU82TmhBTnFHNVdFMlZVdzl1ZkNRU3lPb0EwUVYyZGxHc1pDZ0RL?=
 =?utf-8?B?ZWRqa21Rdk5PT2tVSjBpNUtRWENCRTFnbWRWQzVKQS91OW15Vms1S2lTSFI4?=
 =?utf-8?B?RmtpdUdqbDhaaGczR3dUckd6UjVGdUQ3TnhQZjloSk5mWWJsand0Z0YzUHM0?=
 =?utf-8?B?bks5TU83SGcrUytnMC9vZXpGUytmRVZ3V2NVNDZySXl5VklGUVkyRzFmOElm?=
 =?utf-8?B?ek5jUXBsRWhXdlA0OGsvb1l5aEdjV1Z1bit4UnVRUEZ2VjR5Wk9mVkRyTHpu?=
 =?utf-8?B?MlRSNVBxbzlheDBXbzNJZUJibkFIWWV5T1Jjd0VUMG1KandyMWFWN3hGQ2RH?=
 =?utf-8?B?S3BjN1BlZEVXcUs5eC9nUHZFN2VKMEY3TEJIY3VLWE0zM0NXQngxNTFJTUgr?=
 =?utf-8?B?Tlo1R2NMQ0Fma3NMMENpZStobHIrenp0RmVSWU50QzZBbXhGOERnQUtFSXZT?=
 =?utf-8?B?WEJ3azVDOGluSkhQRTN6bmJVSUh3RVFiM2RVMGxTay9YTTlEYlpaTDI5Tlh5?=
 =?utf-8?B?cVZSVDhMakIyTkRQRU9RNjBQMXdvNHZhY2h2eW9IOEFMbm1NNVdrVmtDYUph?=
 =?utf-8?Q?BgvpI3D4Y2RC/O/M1AGszMRTd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78678dd0-ba02-4888-acfc-08da5fec7a8a
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 07:44:10.1362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udcOQNWpC7TtpC6Qzmo5JTXI+ih9733l6g390DcxokKFjn1rkeXOtCuaIp8FGFawq4Z4ja4F9B7p7gu7wFGtbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P192MB0484
X-OrganizationHeadersPreserved: AM0P192MB0484.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-GUID: wI5HJVlaN3wg-xm4n1w8QMDQ8q6PuIar
X-Proofpoint-ORIG-GUID: wI5HJVlaN3wg-xm4n1w8QMDQ8q6PuIar
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------07XW4SVKDtMY90NgGQfttqae
Content-Type: multipart/mixed; boundary="------------ZBu6N9ZPMc9F9UjsimLQVZ7D";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Eyal Birger <eyal.birger@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org
Message-ID: <45a19551-6004-2453-2f16-a7af5d5c0a59@westermo.com>
Subject: Re: [PATCH net-next v2] ip_tunnel: allow to inherit from VLAN
 encapsulated IP frames
References: <20220706160021.10710-1-matthias.may@westermo.com>
 <CAHsH6GsN=kykC32efTWhHKSPqi8Qn3HYgRursSSY2JiFf2hijw@mail.gmail.com>
In-Reply-To: <CAHsH6GsN=kykC32efTWhHKSPqi8Qn3HYgRursSSY2JiFf2hijw@mail.gmail.com>

--------------ZBu6N9ZPMc9F9UjsimLQVZ7D
Content-Type: multipart/mixed; boundary="------------uEkCUPIM8gGWBAi6OYdeE2Ky"

--------------uEkCUPIM8gGWBAi6OYdeE2Ky
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy82LzIyIDE5OjI0LCBFeWFsIEJpcmdlciB3cm90ZToNCj4gDQo+IEhpLA0KPiANCj4g
T24gV2VkLCBKdWwgNiwgMjAyMiBhdCA3OjU0IFBNIE1hdHRoaWFzIE1heSA8bWF0dGhpYXMu
bWF5QHdlc3Rlcm1vLmNvbSA8bWFpbHRvOm1hdHRoaWFzLm1heUB3ZXN0ZXJtby5jb20+PiB3
cm90ZToNCj4gDQo+ICAgICBUaGUgY3VycmVudCBjb2RlIGFsbG93cyB0byBpbmhlcml0IHRo
ZSBUT1MsIFRUTCwgREYgZnJvbSB0aGUgcGF5bG9hZA0KPiAgICAgd2hlbiBza2ItPnByb3Rv
Y29sIGlzIEVUSF9QX0lQIG9yIEVUSF9QX0lQVjYuDQo+ICAgICBIb3dldmVyIHdoZW4gdGhl
IHBheWxvYWQgaXMgVkxBTiBlbmNhcHN1bGF0ZWQgKGUuZyBiZWNhdXNlIHRoZSB0dW5uZWwN
Cj4gICAgIGlzIG9mIHR5cGUgR1JFVEFQKSwgdGhlbiB0aGlzIGluaGVyaXRpbmcgZG9lcyBu
b3Qgd29yaywgYmVjYXVzZSB0aGUNCj4gICAgIHZpc2libGUgc2tiLT5wcm90b2NvbCBpcyBv
ZiB0eXBlIEVUSF9QXzgwMjFRLg0KPiANCj4gICAgIEFkZCBhIGNoZWNrIG9uIEVUSF9QXzgw
MjFRIGFuZCBzdWJzZXF1ZW50bHkgY2hlY2sgdGhlIHBheWxvYWQgcHJvdG9jb2wuDQo+IA0K
PiAgICAgU2lnbmVkLW9mZi1ieTogTWF0dGhpYXMgTWF5IDxtYXR0aGlhcy5tYXlAd2VzdGVy
bW8uY29tIDxtYWlsdG86bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT4+DQo+ICAgICAtLS0N
Cj4gICAgIHYxIC0+IHYyOg0KPiAgICAgIMKgLSBBZGQgc3VwcG9ydCBmb3IgRVRIX1BfODAy
MUFEIGFzIHN1Z2dlc3RlZCBieSBKYWt1YiBLaWNpbnNraS4NCj4gICAgIC0tLQ0KPiAgICAg
IMKgbmV0L2lwdjQvaXBfdHVubmVsLmMgfCAyMiArKysrKysrKysrKysrKy0tLS0tLS0tDQo+
ICAgICAgwqAxIGZpbGUgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMo
LSkNCj4gDQo+ICAgICBkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvaXBfdHVubmVsLmMgYi9uZXQv
aXB2NC9pcF90dW5uZWwuYw0KPiAgICAgaW5kZXggOTQwMTdhOGMzOTk0Li5iZGNjMGYxZTgz
YzggMTAwNjQ0DQo+ICAgICAtLS0gYS9uZXQvaXB2NC9pcF90dW5uZWwuYw0KPiAgICAgKysr
IGIvbmV0L2lwdjQvaXBfdHVubmVsLmMNCj4gICAgIEBAIC02NDgsNiArNjQ4LDEzIEBAIHZv
aWQgaXBfdHVubmVsX3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZp
Y2UgKmRldiwNCj4gICAgICDCoCDCoCDCoCDCoCB1OCB0b3MsIHR0bDsNCj4gICAgICDCoCDC
oCDCoCDCoCBfX2JlMzIgZHN0Ow0KPiAgICAgIMKgIMKgIMKgIMKgIF9fYmUxNiBkZjsNCj4g
ICAgICvCoCDCoCDCoCDCoF9fYmUxNiAqcGF5bG9hZF9wcm90b2NvbDsNCj4gICAgICsNCj4g
ICAgICvCoCDCoCDCoCDCoGlmIChza2ItPnByb3RvY29sID09IGh0b25zKEVUSF9QXzgwMjFR
KSB8fA0KPiAgICAgK8KgIMKgIMKgIMKgIMKgIMKgc2tiLT5wcm90b2NvbCA9PSBodG9ucyhF
VEhfUF84MDIxQUQpKQ0KPiAgICAgK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcGF5bG9hZF9w
cm90b2NvbCA9IChfX2JlMTYgKikoc2tiLT5oZWFkICsgc2tiLT5uZXR3b3JrX2hlYWRlciAt
IDIpOw0KPiAgICAgK8KgIMKgIMKgIMKgZWxzZQ0KPiAgICAgK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgcGF5bG9hZF9wcm90b2NvbCA9ICZza2ItPnByb3RvY29sOw0KPiANCj4gDQo+IE1h
eWJlIGl0J3MgYmV0dGVyIHRvIHVzZSBza2JfcHJvdG9jb2woc2tiLCB0cnVlKSBoZXJlIGlu
c3RlYWQgb2Ygb3Blbg0KPiBjb2RpbmcgdGhlIHZsYW4gcGFyc2luZz8NCj4gDQo+IEV5YWwN
Cg0KSGkgRXlhbA0KSSd2ZSBsb29rZWQgaW50byB1c2luZyBza2JfcHJvdG9jb2woc2tiLCB0
cnVlKS4NCklmIHNraXBfdmxhbiBpcyBzZXQgdG8gdHJ1ZSwgd291bGRuJ3QgaXQgbWFrZSBz
ZW5zZSB0byB1c2Ugdmxhbl9nZXRfcHJvdG9jb2woc2tiKSBkaXJlY3RseT8NCg0KQlINCk1h
dHRoaWFzDQo=
--------------uEkCUPIM8gGWBAi6OYdeE2Ky
Content-Type: application/pgp-keys; name="OpenPGP_0xDF76B604533C0DBE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xDF76B604533C0DBE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEX4AtKhYJKwYBBAHaRw8BAQdA2IyjGBS2NbuL0F3NsiMsHp16B5GiXHP9BfSg
RcI4rgLNKE1hdHRoaWFzIE1heSA8bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT7C
lgQTFggAPhYhBHfjAo2HgnGv7h0n/d92tgRTPA2+BQJfgC0qAhsDBQkJZgGABQsJ
CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEN92tgRTPA2+J/YBANR7Q1w436MVMDaI
OmnxP9FimzEpsHorYNQfe8fp4cjPAP9vCcg5Qd3odmd0orodCB6qXqLwOHexh+N6
0F8I0TuTBc44BF+ALSoSCisGAQQBl1UBBQEBB0CUu0gESJr6GFA6GopcHFxtL/WH
7nalrP2NoCGTFWdXWgMBCAfCfgQYFggAJhYhBHfjAo2HgnGv7h0n/d92tgRTPA2+
BQJfgC0qAhsMBQkJZgGAAAoJEN92tgRTPA2+IQoA/2Vg2VE+hB5i4MOIPWGsf80E
9zA0Cv/489ps7HaHFuSzAQCm8MVuy6EsMIBXQ84nTb0anpfLHCQMsRNMuW/GkELh
CA=3D=3D
=3DtbX5
-----END PGP PUBLIC KEY BLOCK-----

--------------uEkCUPIM8gGWBAi6OYdeE2Ky--

--------------ZBu6N9ZPMc9F9UjsimLQVZ7D--

--------------07XW4SVKDtMY90NgGQfttqae
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYsaOxgUDAAAAAAAKCRDfdrYEUzwNvinj
AP9MZ58vuwNXXclKOXmTRrxajC6nF0fOOcBX81sXvyGhdgD/XeCzTdt9WT68aXTDAMOW4xTtmTXX
bJIjvymgStsZ/gA=
=TwSh
-----END PGP SIGNATURE-----

--------------07XW4SVKDtMY90NgGQfttqae--

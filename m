Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D149256A1B1
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 14:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiGGMAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 08:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbiGGL7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:59:49 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1AC564CA
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:57:34 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2675YKa2030764;
        Thu, 7 Jul 2022 13:57:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=eaXMj6Nm9MUEk3j1oSYn5cJuxism//XkbAWtEohGVPM=;
 b=dAUQKBsuUlpvo7qi6D4kc3K5IN5aCJCds6+K8Q/8jUskPpgQnhjdqre+FGqamtb4XTMR
 nY4NDGm3LSD7A6uZ5PA7n1SGpQqsFs+sbWWdk1biOvUnAySFG+rzk5rYoqEpnwDT4XXN
 8wGVpx3lVBE1+r8GNhkzMKuwA4vZuM/X/2jGO8rZl3n+gGx3BBG3/sx3LQGp43Gcogsr
 cU7h+2Pk96anaarV+3rWwEb5jgBaNhZmDLkdk5zixTLHLijTpOuDTJY5RLF7h2ifMfK3
 2NihMphRCD6xYbMu5PMMOBQfdF9YGJccXrGwWiClnn81+/UKtIX8qdPePTR+m5l77qCd gg== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h4ubysuk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:15 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 7 Jul 2022 13:57:14 +0200
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (104.47.5.50) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Thu, 7 Jul 2022 13:57:14 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bchp43FFxLpjFPi9rLCqYy82jPsUAGfeR3lPZFCXg+aHLrpNFXAU1lanf9Y9h9/CRuciT6E5gp71gwOaItLJdGLRwu/SH06ZQwDNWWZnuHJlyem44AtbvZupvzoqcygj7GWZoMSZsje4n1Pq5oLYb1RhUETU1UmJmRAzFMn9B9Q1ScWMFvFWS9vYTRGKzHFBMr88Bcmkod80z8zuMA4OIX+UIUhrEEhKPtaPNByuLb2ReFx4w5ghdx62iMYSg216U1kufcSf8C0p9uY6KlKKp5o9bAwsFCwaM+cEJTpM58y3FQkbLJHtFDVAvI2A57brulwq1pOelM2MTvaXnO507w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaXMj6Nm9MUEk3j1oSYn5cJuxism//XkbAWtEohGVPM=;
 b=i8wYGlc1Q5r0+eROxwO9I14Qu9NKyjOrhSGZLHN519kSdQWCxtnCjhr4Xv9+7tfajRdWXHdDP1ZkXUqUksxUjFdsIIkS0DWvW/Ut10PfSbIHGvu/KHucoibtLXYgqqDBuNA/yWOyuI3PfdBFvOlg9ZGlZ42aW5eruS5pNZmO+64iMRO8ABg3PcMVbSRIj29ZfUwUqjQ1c6whGKbmEAI1fkoBrnU9YZpxxR5hGC7YmOFIATKLWFisQasLVIoHFZVTnWHcaZvjR/ShRWjMICWZIxY3v0AlGjM7O1x4OvJEQJgwSmGHxS2pANdBWR2ni5oHRw1NeR/EwGs/udUffFZB6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaXMj6Nm9MUEk3j1oSYn5cJuxism//XkbAWtEohGVPM=;
 b=fsa6ug7VK3b9B6+USAtUAda5sb8sXdJbeQZVFcdUnkzZGQ1859nx86hm7NQnXKIEw5av44eXlvdOtm6jx7sLdjvAQKmQEvonnN4IIGtk4AOzONKqVI7rJe+hHNp3FDzAUp1EPbOIO7+aaWqQJZhg2b3MBzg36EgSGJraoJpWjC8=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by AM9P192MB0917.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1cc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 11:57:13 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%6]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 11:57:13 +0000
Message-ID: <8d767cb6-e2ed-670e-3afc-48e5190623d4@westermo.com>
Date:   Thu, 7 Jul 2022 13:57:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
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
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
In-Reply-To: <20220706131735.4d9f4562@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iltQbMlJYVGlRz0BTZ9K8rOJ"
X-ClientProxiedBy: GV3P280CA0060.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::30) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab8ba88b-a17c-4e91-e072-08da600fd49f
X-MS-TrafficTypeDiagnostic: AM9P192MB0917:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RYwIO9gnOhCjVAvvkcLcLS8xgUT42ug34p65E7IvCuHVsdAPwBZcsrLVIqidNaOjGTZNY+WyfFvG9A3MclEvTldstENMg/5S9+qds6w3sKhmreubJd52y69psqc3yBaGaIDMcNaT1K2tPwiCZDNj21pHvN0zJBycGcLerkcaj+/SLGi5CJOabxOYCPKVRNM4kgw92OkpqZx5P8IJvx9eyodRZRE4rGr5dnTL73jGn2UIGzF00Oeveaf0msFgcxMPdppeUezpj/JQQVQJXD5cNiclTFhjEFsR6d58ApUE+2Zyiu4k3HmFsO5V3ZbYFdg9P2fV03HGISypvA/UFbJyONH+rTyDMOGpWpdt1Q2K//AYJsIVQdAW5w8zRQRl/3s6qvMXLOrMN03JDnhH7kUla41Q2cDs6KponsKZchn5/xo4r8TGC4c+WZWgXCm4UANxWk6rexux0Fv9YbcQ+lfEKo+UipbnJApGuilnmYvitrL5k7YS6Gv6T+YOEXweRc2lbuJ96/bXBx1WZjBhNH1Fj2eV3naEokwkPhDOVYBnrGIr1u8slHusQPyWQMT0Rp8cXykYL45C81n4/dw5/CDD2ubf4uyGsIntiW3IH6KejpkXPaGm6cdOmzOuKauLfiHFoJHDutu91JKSJPUuSxmtS01rnj6n57LAp7Ahbt6rvFbyRKHIB1IRlx4bi59VF2zBNxXOX4pbDofEOduar0QyBUO6E7xNJAGAJEHI5N2MDcOJV/brl1mDrUCqrZp56CHSRpAkjM+EQchhwhMjSIMj7LwHNrfYdRRns6pVgYvrTpYOUYnFS/woZb6OyiCdEnCTCkVdGmyHOPj0TXMXS5Wrc0l0G6eeoGZCAzGFPe3oFvqKA7dU0CHSGpKxO9DzTTgW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39850400004)(366004)(136003)(396003)(376002)(346002)(235185007)(21480400003)(83380400001)(5660300002)(8936002)(4326008)(41300700001)(66556008)(6916009)(66946007)(66476007)(86362001)(33964004)(6486002)(2616005)(6512007)(6506007)(316002)(31696002)(26005)(31686004)(2906002)(36756003)(186003)(8676002)(44832011)(38100700002)(53546011)(52116002)(478600001)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zi9zQmdVTVN4VGtsSmpMYUtLb1pNQVV4aVVDcU1ZRGVuQS9CRGd1OTFJMFBw?=
 =?utf-8?B?cFY0SlN6UDFjNEFPK1JUak5nQlk2b2ZzN2xSalJDNHRBVlRneWZENk0rYnRG?=
 =?utf-8?B?aDRhaCtYOFFCYmdrNW9jSE1kNWpzbFAzVUFJTDB1d2xVZ3V1aEZwZXlvTG1F?=
 =?utf-8?B?cTFvakw2c2tRUnZhSXRFb2w0dkc2bXEwRXJ3NmYxcTBJRWhtR0pRa0hmckZ6?=
 =?utf-8?B?alJSY2hJRmpYTEdSQitibUowUWFTTHdSYzNIUEZPdjJwTFhKMjN1WlNCRTJt?=
 =?utf-8?B?V1N1UTBta2FWUlI0cnZRb1BtT010Ky9uMEZnVHE5bE0xelpYaUlaQ0Q2dys0?=
 =?utf-8?B?K0c1d2VmejNTNEhkSWRGdWlxb2dTM0MyTUlaRkRweElNZm4xNnV2eVB6YjdX?=
 =?utf-8?B?K1FsTldIOVZQdVJJNk00OXdQLy9KQnJ4MmM1VGthdzBQOWdEdnp4WWp1MUpS?=
 =?utf-8?B?NytjYmkzWjhNb2k0Y3J6alhiaGtQZ0pjK0hVNDVreitEd2lJTVFjYkthdE9J?=
 =?utf-8?B?anBPeWtWMjl6ekMzV1BqTFFIWGdjb3RuTDg4Q2t2dUZSSWFhRnlFZjRSbTdh?=
 =?utf-8?B?V0lKK3lGWjJQU1NzV3dJUFFRM0JmL0d2QzNpa3k1Y0RjVjV5WjlnZDJacVg0?=
 =?utf-8?B?Ykd3bjRaaGVlOFN2V1J5RXVGb0dGL2NhNVV6Y1RMR1hXMjhQNVJ0RDU1aW1y?=
 =?utf-8?B?RGJGTE10eExmRllKV04xUU1wRVU1QTJqR0Q1ZFk2VjJiRXMxMG9pVHlVYkRY?=
 =?utf-8?B?QUdKeVpwQjBPZTA5cVRrS0NoMHViQVcxcmJPS1RYOUs1ZHhQc2F5eHhXT2dl?=
 =?utf-8?B?aktQeFJ5bVJ0REdZNVprRWNTUWZCSW0wUk5NMDBCcWZ1RmJZMGRwanF3UzdX?=
 =?utf-8?B?cXlRYWdFWUJQaGtmUFlpY2JPRzVGRU5qdlRvQmwxSFZ1R21NSGdaRjFvSWxr?=
 =?utf-8?B?R0JjcjZVenlOdlBoYkh4dkhDRVgweGlSL2xsSnlIenhOa0JYQ2RlY0xzbWxa?=
 =?utf-8?B?WWRUWHZockhhTWw5VkI3RTJWR0d3RG1mMm1BZzRsT25POXhEazFrNmdtZ1JQ?=
 =?utf-8?B?UmEyRFUrWkhSaUZ3Q2M3ZmdLTnZLT3EzaVZJTy81NS83VSs3MU1qdGRHZVBh?=
 =?utf-8?B?VnZORTFWWVA4aVkwTHd5T2ZwcExIUnA2di94RmxteTdxTTROajNDMHZSN3M1?=
 =?utf-8?B?Q2pJWVNhNElaai9rZGN6Yld1eXNXL3JFNE9VTiswUFhLTjVvSE13aFlscms4?=
 =?utf-8?B?dElXYUVDUnFDTllESUswSG5aakdYVFlEYy9QRWlsTEh1SHR6eTYyUENzV1hD?=
 =?utf-8?B?bDZBM0VHVEMwU24xZVhYdXhSQ3hrbGdMUmNFMjE3eWxSRFRNeU92YU9EQVcz?=
 =?utf-8?B?RThMR3JWZkJMdjFEeUQ0ck9majd1Mm1rT0x1eWdTajB6OEhzVkMyWTVYZlZD?=
 =?utf-8?B?eXJXcjJlbmhadmwyckNyM3hpbFliaEdmOE01VmNDaWswOENNVEN0b1pPK1FG?=
 =?utf-8?B?SVArNUNVOE5wVVRyTE1RYTJqMTRUM2tuUkgyOGxoaTdkSTB4azVXZ1E2WVpq?=
 =?utf-8?B?b2pGalJ0Tm8xdFVTRUhJbjMyU1k3Mkw1MXdkZGJ3U28wQzUrUjhTV2o2bjN0?=
 =?utf-8?B?RDhCTDhETnFOL3ozK2hubFJaSndlM280c2kvaE5YRlA5YUJkakdXVUN5WmhJ?=
 =?utf-8?B?VnFmdEJrdWJaU2E2Nk4zWWM2M1lLVXNqTjJDT3ZXVnBIaTcwNWI1VW5iTVkr?=
 =?utf-8?B?TXJNajBYS1JnRDZKOGtZLzJKTGNHZGMvMW82cmpXalBoN0t6akRUdHBZcHdm?=
 =?utf-8?B?S1NtWm5HZmRjYkJvS3oxQjVoRFpFL1RnMmNBZnlwYXF5NG1MUTlSYWk0SWMz?=
 =?utf-8?B?TmJpZjlqUjFTMTNSL3BVbXZ6clZOcXJBSFFOQnJoMEdXQURyc1JITzFzdkw1?=
 =?utf-8?B?Ui9aREx3bzBzbXlZZ3dMUEpTdmE1Mk1oeDdwbE5zdnh0VmduNVcvQjRQMVB5?=
 =?utf-8?B?NTFUN3gyMTdEMUpURmp4eUx6M1cwYStYWFhEWDRyZWhTMXBCTUozOE0zZW5j?=
 =?utf-8?B?c0FqQ1lnRjZPbWsySTRmK3l1c2FTamhlQ0dNZ2JETUpWbWVIZW5NdUM4WGRs?=
 =?utf-8?Q?3eo93f1ANGlmUf5FO+YFFULkH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8ba88b-a17c-4e91-e072-08da600fd49f
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 11:57:13.6088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nCUtVCCYNmAEC7M/Jpx2A0aU/92fol8ANZQPkhDgYON+ck8kuE4vOpA/cZB/RvEd9UGOurpsP9P5pilh4XCSJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P192MB0917
X-OrganizationHeadersPreserved: AM9P192MB0917.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-GUID: 7DuKIwdglRwZTMk-MEqEYLoZePlZcJXD
X-Proofpoint-ORIG-GUID: 7DuKIwdglRwZTMk-MEqEYLoZePlZcJXD
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------iltQbMlJYVGlRz0BTZ9K8rOJ
Content-Type: multipart/mixed; boundary="------------FTy3O8ewzd2RYh4IDu5wyNcg";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com
Message-ID: <8d767cb6-e2ed-670e-3afc-48e5190623d4@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
In-Reply-To: <20220706131735.4d9f4562@kernel.org>

--------------FTy3O8ewzd2RYh4IDu5wyNcg
Content-Type: multipart/mixed; boundary="------------6TuMzP5OVDlW3Dlx4umCwWeP"

--------------6TuMzP5OVDlW3Dlx4umCwWeP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy82LzIyIDIyOjE3LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gV2VkLCA2IEp1
bCAyMDIyIDA5OjA3OjM2ICswMjAwIE1hdHRoaWFzIE1heSB3cm90ZToNCj4+Pj4gVGhlIGN1
cnJlbnQgY29kZSBhbGxvd3MgdG8gaW5oZXJpdCB0aGUgVE9TLCBUVEwsIERGIGZyb20gdGhl
IHBheWxvYWQNCj4+Pj4gd2hlbiBza2ItPnByb3RvY29sIGlzIEVUSF9QX0lQIG9yIEVUSF9Q
X0lQVjYuDQo+Pj4+IEhvd2V2ZXIgd2hlbiB0aGUgcGF5bG9hZCBpcyBWTEFOIGVuY2Fwc3Vs
YXRlZCAoZS5nIGJlY2F1c2UgdGhlIHR1bm5lbA0KPj4+PiBpcyBvZiB0eXBlIEdSRVRBUCks
IHRoZW4gdGhpcyBpbmhlcml0aW5nIGRvZXMgbm90IHdvcmssIGJlY2F1c2UgdGhlDQo+Pj4+
IHZpc2libGUgc2tiLT5wcm90b2NvbCBpcyBvZiB0eXBlIEVUSF9QXzgwMjFRLg0KPj4+Pg0K
Pj4+PiBBZGQgYSBjaGVjayBvbiBFVEhfUF84MDIxUSBhbmQgc3Vic2VxdWVudGx5IGNoZWNr
IHRoZSBwYXlsb2FkIHByb3RvY29sLg0KPj4+DQo+Pj4gRG8gd2UgbmVlZCB0byBjaGVjayBm
b3IgODAyMUFEIGFzIHdlbGw/DQo+Pg0KPj4gWWVhaCB0aGF0IHdvdWxkIG1ha2Ugc2Vuc2Uu
DQo+PiBJIGNhbiBhZGQgdGhlIGNoZWNrIGZvciBFVEhfUF84MDIxQUQgaW4gdjIuDQo+PiBX
aWxsIGhhdmUgdG8gZmluZCBzb21lIGhhcmR3YXJlIHRoYXQgaXMgQUQgY2FwYWJsZSB0byB0
ZXN0Lg0KPiANCj4gV2h5IEhXLCB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gdGVzdCB3aXRoIHR3
byBMaW51eCBlbmRwb2ludHMsIG5vPw0KPiANCg0KWWVzIHN1cmUsIHRoYXQgaXMgaG93IGkg
ZGlkIHRoZSBpbml0aWFsIHZlcnNpb24gb2YgdGhlIHBhdGNoDQooYW5kIHllcywgaG93IGkg
dmVyaWZpZWQgdGhhdCBBRCB3b3JrcyBmb3IgdjIpLg0KTXkgY29uY2VybiBpcywgdGhhdCBp
ZiBpIHVzZSAyIGRldmljZXMgdGhhdCBhcmUgcGF0Y2hlZCBpZGVudGljYWxseSwNCnRoYXQg
aSBtYXkgd29yayB3aXRoIGEgYnVnIHByZXNlbnQgb24gYm90aCBzaWRlcywgYnV0IGRvZXNu
J3Qgd29yaw0KdG9nZXRoZXIgd2l0aCBhIDNyZCBwYXJ0eSBpbXBsZW1lbnRhdGlvbi4NCg0K
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGlhcyBNYXkgPG1hdHRoaWFzLm1heUB3ZXN0ZXJt
by5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgICBuZXQvaXB2NC9pcF90dW5uZWwuYyB8IDIxICsr
KysrKysrKysrKystLS0tLS0tLQ0KPj4+DQo+Pj4gRG9lcyBpcHY2IG5lZWQgdGhlIHNhbWUg
dHJlYXRtZW50Pw0KPj4NCj4+IEkgZG9uJ3QgdGhpbmsgaSBjaGFuZ2VkIGFueXRoaW5nIHJl
Z2FyZGluZyB0aGUgYmVoYXZpb3VyIGZvciBpcHY2DQo+PiBieSBhbGxvd2luZyB0byBza2lw
IGZyb20gdGhlIG91dGVyIHByb3RvY29sIHRvIHRoZSBwYXlsb2FkIHByb3RvY29sLg0KPiAN
Cj4gU29ycnksIHRvIGJlIGNsZWFyIHdoYXQgSSBtZWFudCAtIHdlIHRyeSB0byBlbmZvcmNl
IGZlYXR1cmUgcGFyaXR5IGZvcg0KPiBJUHY2IHRoZXNlIGRheXMgaW4gTGludXguIFNvIEkg
d2FzIGFza2luZyBpZiBpcHY2IG5lZWRzIGNoYW5nZXMgdG8gYmUNCj4gYWJsZSB0byBkZWFs
IHdpdGggVkxBTnMuIEkgdGhpbmsgeW91IGdvdCB0aGF0IGJ1dCBqdXN0IGluIGNhc2UuDQo+
IA0KPj4gVGhlIHByZXZpb3VzIGNvZGUgYWxyZWFkeQ0KPj4gKiBnb3QgdGhlIFRPUyB2aWEg
aXB2Nl9nZXRfZHNmaWVsZCwNCj4+ICogdGhlIFRUTCB3YXMgZGVyaXZlZCBmcm9tIHRoZSBo
b3BfbGltaXQsDQo+PiAqIGFuZCBERiBkb2VzIG5vdCBleGlzdCBmb3IgaXB2NiBzbyBpdCBk
b2Vzbid0IGNoZWNrIGZvciBFVEhfUF9JUFY2Lg0KPiANCj4gUHVyZWx5IGJ5IGxvb2tpbmcg
YXQgdGhlIGNvZGUgSSB0aG91Z2h0IHRoYXQgVkxBTi1lbmFibGVkIEdSRVRBUCBmcmFtZXMN
Cj4gd291bGQgZmFsbCBpbnRvIGlwNmdyZV94bWl0X290aGVyKCkgd2hpY2ggcGFzc2VzIGRz
ZmllbGQ9MCBpbnRvDQo+IF9fZ3JlNl94bWl0KCkuIGtleS0+dG9zIG9ubHkgb3ZlcnJpZGVz
IHRoZSBmaWVsZCBmb3IgImV4dGVybmFsIiB0dW5uZWxzLA0KPiBub3Qgbm9ybWFsIHR1bm5l
bHMgd2l0aCBhIGRlZGljYXRlZCBuZXRkZXYgcGVyIHR1bm5lbC4NCj4gDQoNCkFoIHlvdSBt
ZWFuIHdpdGggSVB2NiBhcyB0cmFuc3BvcnQgZm9yIHRoZSB0dW5uZWwuDQpJIGhhdmVuJ3Qg
cmVhbGx5IGxvb2tlZCBpbnRvIHRoYXQsIHNpbmNlIGkgaGF2ZSBJUHY2IGRpc2FibGVkIGlu
IG15IGVudi4NCkkgd2lsbCB0cnkgY29tZSB1cCB3aXRoIGEgcGF0Y2guDQoNClNpbmNlIHRo
aXMgZG9lcyBub3QgdG91Y2ggdGhlIHNhbWUgY29kZSwgc2hvdWxkIGkgc2VuZCBpdCBhcyBh
IHNlcGFyYXRlDQpwYXRjaCwgb3IgaW50ZWdyYXRlIGl0IGludG8gdGhpcz8NCg0KPiBBIHNl
bGZ0ZXN0IHRvIGNoZWNrIGJvdGggaXB2NCBhbmQgaXB2NiB3b3VsZCBiZSB0aGUgdWx0aW1h
dGUgd2luIHRoZXJlLg0KDQpJJ20gbm90IHJlYWxseSBmYW1pbGlhciB3aXRoIHNlbGZ0ZXN0
cy4NCkkndmUgdGFrZW4gYSBsb29rIGF0IHNvbWUgb2YgdGhlIGZpbGVzIGluIHRlc3Rpbmcv
c2VsZnRlc3RzL25ldC8gd2hpY2gNCnNlZW1zIHRvIGJlIGp1c3QgYSBidW5jaCBvZiBzaGVs
bC4NCkknbGwgc2VlIGlmIGkgY2FuIHdyaXRlIHN1Y2ggYSBzY3JpcHQgdGhhdCB2ZXJpZmll
cyB0aGlzIGZ1bmN0aW9uYWxpdHkuDQoNCkFnYWluIGFzIHdpdGggdGhlIGFib3ZlIGFib3V0
IElQdjYuDQpUaGlzIHNlZW1zIHRvIGJlIGtpbmQgb2Ygc3RhbmRhbG9uZS4gU2hvdWxkIGkg
aW50ZWdyYXRlIGl0IGludG8gdGhpcw0KcGF0Y2gsIG9yIHNlbmQgYXMgYSBzZXBhcmF0ZT8N
Cg0KQlINCk1hdHRoaWFzDQo=
--------------6TuMzP5OVDlW3Dlx4umCwWeP
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

--------------6TuMzP5OVDlW3Dlx4umCwWeP--

--------------FTy3O8ewzd2RYh4IDu5wyNcg--

--------------iltQbMlJYVGlRz0BTZ9K8rOJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYsbKFwUDAAAAAAAKCRDfdrYEUzwNvrfo
AP4htQ4yCmaHf3AAHh8N94Hu2wK5H6HkzInA7ha3kumTKQD+LD9UcT4kEAIOgXlhIb1/OBN/E8Eq
eh/MwRDSx7/MDAw=
=LH4h
-----END PGP SIGNATURE-----

--------------iltQbMlJYVGlRz0BTZ9K8rOJ--

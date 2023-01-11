Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1BF665FE2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjAKQBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjAKQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:01:37 -0500
X-Greylist: delayed 1797 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 Jan 2023 08:01:35 PST
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E5B37;
        Wed, 11 Jan 2023 08:01:35 -0800 (PST)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BDGIW5028732;
        Wed, 11 Jan 2023 16:22:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=tLK6Rp03ddsHrxNw7sH4GtkfsxmUPeyCbUOarV6/puw=;
 b=gGPpnsyZAhDWmQaFYVZmtQ5BKgPXmRqn0cJjd+JVVd8skSly3RPPfnDy3ECFUuu6ji83
 b3CZavNpdU/4O07WzlWVONPQVRy/kiL+2UQ0nncRmyU7EuLuwh8MAoWvRM9MXkqtCzv2
 GtzY2Q7u+r9OtgNiliuvgJ1CToXDR+Aipk2BwDLagpDR3GUoYHBJbhLy+gVuBxSag8+E
 SnjCZ0QbRJTS1nGG4Xw6QKbPda8oF5xp/eRf0bFQl7yqFKg+sgA05vwPx3xuB26lGS2i
 65ecyx4+nqZbd5nB/QX/RbV3RJBepdHgmHtcXIC8VjwcfJrHgqtPBeo92obz4JZJYubZ 0Q== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3n1k4v8kph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 16:22:06 +0100
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Wed, 11 Jan 2023 16:22:06 +0100
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (104.47.11.237)
 by EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Wed, 11 Jan 2023 16:22:06 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8KFon1aZH1tujAp7PLYR22Xz60kVhSRPVqfLrm6OzinvVS13QJ6bFksAtbYGZ/CE5/VqoKteMqCm6Nj8a+JvoTYoPnxMIjqTNhaYO/VrhPHYRrWs4niJzo81dWr+bcG3iDwxqLUbCZzYN3rpGFw7mHi8ytR87hw5hjV+5cj3w4mddIKmYk21tLoEdOAN7esWwmr771ifhwEGej45Xq4aZvRl4UqsN8Y7jcoPXE6O5T6TwCsgEibm+00PZ1WVGydWG+6tP+q9tyct8W/aO/S9jS/q5SBYVjgBX1Cm5PhDHw6cYGWPFtOLPOrfWTK11r3zIz888thb9+esTkI4P66vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLK6Rp03ddsHrxNw7sH4GtkfsxmUPeyCbUOarV6/puw=;
 b=lVtLseZYUrJaVDPe6wuyTuYB+v7sE0XaDP47uf8UNDa9dJmpLFCB5QwyuTCJBAQjkdzHhL0tgR3Ti62EsL6vY+pbFRamR4eaTTp+QQMdj0sI1OGuNBo7sLTmdMPhoqunT5PY1rJLdaFoaqpgfMiao/JwoTnpfuIKQgQdiz2VohzBau5sjGVWSi4xt5NNzn8/FwbZ/8B/V1YvyZW81RoxwoxXAd63aK66oS9gPoyJY9/qejLiHVdjWfocOFTAo5IXHjc37seGU2wkCDwPfWYz89v9VVfMb3asmefeNyS3tOXo1sHaZkJXh+2mQe3ABg6dTYiD9zmvBVW5mvMcvnk61Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLK6Rp03ddsHrxNw7sH4GtkfsxmUPeyCbUOarV6/puw=;
 b=LUoKWUf+k6+mSJNqJ96eKgt8WzLg9AY46n2NugtLReCXNBS108rSzwH8C0s1pKxDEJwRIZI+H4q4qd5pF51Igxjg6SIWu+fvNFHTNpB59/bj7QHTwDxqAYrhcT2pEjn/ojxkrloUSJPaMqbL37GBQ6llfYlUMCveVVsmr4kkLh4=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DU0P192MB1570.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Wed, 11 Jan
 2023 15:22:04 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::31:63fd:e1a9:d9f8]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::31:63fd:e1a9:d9f8%3]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 15:22:04 +0000
Message-ID: <8f6cc42b-c320-45dc-0e45-2377a2fbe215@westermo.com>
Date:   Wed, 11 Jan 2023 16:22:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
CC:     <linux-kselftest@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian> <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian>
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
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs when
 selftest restarted
In-Reply-To: <Y7lpO9IHtSIyHVej@debian>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------JoXwdeoPf89RcPICgF3xHres"
X-ClientProxiedBy: ZR0P278CA0198.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::12) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P192MB1388:EE_|DU0P192MB1570:EE_
X-MS-Office365-Filtering-Correlation-Id: 286ec8ee-928e-4e70-9259-08daf3e7985e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 35cdMaMO09WYAsPMoozg5BcJJJasQQZ35bf/JM11lab65WQinWNgrm+XQMtWrOtLjUR3etOTchoG8ela/E2t56HBcbc4kRMy8JPQFD40oxVymPd/U8k9YI4TjnbpQvf42jvCA0ZYxKyp45Cz6CdO3+6b51ybD1pSct+FpkNMeizGQz7Q7iX/Hu2qXzqdk2yyqlt8gbogUC0kMCaOEqVvUYP4k5pWmRItqnidF8vHc1S8Pms/Gu7Yt9BYlluDINV7BHRpz9vFuH2uuQqo8Fk9hDB5D9q1yQkw9D1BHJx4UsPKgaP+YPmrhVsduNusDhwXCcsoBqFXKIMT3ySW1z6vYn6bJlDLgQzUaynULnTFh6GOxxwQM8lPOrqo5nGYgwuO2vyGk2Bm3VVcswGNm3LZ49QuxpPN823T2AXRfb70DRbkFdZD05F2YKqVEcNdwoZ7LcNGpLcRfRaubtG+sVhw9lkshZno39RMFSG7kWINlZ8GncmWWWRpypFThNJG96L8OUBO6C829MoDL1Mm6JHhhJseyZ/TOVPPyj/O3T8MztBAVUAUDEssh4syL9st2KJA81DoI+zjDMBcarExDQ9tOKv2LqzPv8ft4cU1rlmN5AbAuthatFfnINI08r4+E329Ricv06mfueO9w26G5bisMhxzKnYZmuGoiHwlCNkOSv8DvmJWWFfGQYkGuOuizfH63e9JcKW5LmkFyM65PnBeLHSpWg8Xf12X/AfS+R/RclRa5AsfSnAIZlfr2OX8ecJP3HU+9uGvaTiNkIDtNaZsLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(451199015)(2906002)(66476007)(31686004)(66946007)(4326008)(8676002)(6916009)(235185007)(5660300002)(7416002)(38100700002)(38350700002)(26005)(41300700001)(66556008)(316002)(44832011)(8936002)(36756003)(31696002)(186003)(54906003)(478600001)(6486002)(6506007)(33964004)(53546011)(6512007)(52116002)(2616005)(21480400003)(83380400001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tkg0aEFsZlIrT0czMENtTEtSM1dEQ0Jqa3VHaEFOYkVqU1lyQ2cwL3dsWGVX?=
 =?utf-8?B?SjBBVTlYMmxRZWNnLzE2b3dVZTkxV3BVU040UGhnNjdTSXJjM0cxaGtYVW8w?=
 =?utf-8?B?R214ZCtqYTl2UGNDMnE3MmxPYlZHM3FRSkMycTJxTkd6Q1VQa0dwOWRFaEln?=
 =?utf-8?B?dUdtRXo3R0VMQXJVQjU2dHpkdXFCTXBSTWZKRnNTVnN3dk83Sm9UYUZkaGxD?=
 =?utf-8?B?RkxHRjZoUlZ4ZHBmRUVuOUZuVU1haUl2NUhJamcwZE8rdnNLSVhleEhSdCty?=
 =?utf-8?B?RFVqbndwNFcwRjVpeGIvOW5SWDk2VnpkUE5WS0psamJWeUwrVi9sc04wdmc4?=
 =?utf-8?B?L0dnMzVmM3VFRm93RDR1MEdZTGtsS1ZacmRVV1NmYitmZnMrdXM1SWNWYkR2?=
 =?utf-8?B?MjdQWmdKczIwSTYrYVl2Y0ovRmVLK1hCaE1UcUZjQUY4TTh0b2VzY1l0S1lE?=
 =?utf-8?B?bmx1NUVJOXVkaFNEWUlYbTNsRm05QXZsNTRFeVd4YStwZ2M3UE9NdjloRUpp?=
 =?utf-8?B?MlNwdmZFVFJOa0lQNjA1RU8vdjEzVlVqRGdFTGYwYUIrMWluVVBubWg1MjVM?=
 =?utf-8?B?SWN4eGxMN2MwdS8xQVhqL254YzBxTTBjOVkvcUl1RHpWeG9iYmtBSkRJZjZY?=
 =?utf-8?B?b29aMVU3amVYZmtXWkgvWEFVYTZFa20yMlNTQ2ZUUmJuL0t2ZTlwWTFPMVZ1?=
 =?utf-8?B?TnZNSGt5bjlWUkRsY3JZdGM5TTBCTUtSZkluMGVxaXk1aVhqRlErMkRMMFIy?=
 =?utf-8?B?d0Nkbm9sMUdLMXhTNUZtSmtqNnU3VVpqWFBYTmhQUU1TZ0Z2b1hVZWd0OGtn?=
 =?utf-8?B?cHB4WUROQ0w5RHNyV1R1RHhQVkUvVFdNcFk5UGJOdlpPb20rZmJPenVIR0tz?=
 =?utf-8?B?eVloMWZEekR1akhlVjBzcWpTK25iS3l6blFkb2pLZmVPNlNGaUV5cjZzQnBu?=
 =?utf-8?B?OVFGYUVHdVluWm9ZbjZURXhvSWdrU3Fua2lBK0RRMW1LQkJNVHpFbTJyOFM4?=
 =?utf-8?B?S1Z4VnFiazRSdlBYVGFTUS9GVW1Zc1BuSDlDQVpxSm5Vc1o4S0pZclFzdmpx?=
 =?utf-8?B?WDNSajNhdHhuZDkvYmNibm1BWldGR2VKSTNPNGdqQjFEdWpYeEVSNVl4KzB3?=
 =?utf-8?B?M1RRcU1LT005OUdhaDJ2UHBXVUVwWjkzMWRjRHl0WXFtZThMYTQ5YjBFd2Mx?=
 =?utf-8?B?M2JyWTREVFg3RHRwOUN2MzQwVnhzeXRPWHM1c0kxTDY0MVQ0ZWNrd0xyZWd1?=
 =?utf-8?B?S09ZZEtoMU9Ddm03Zjk3QTlLVkJidUJSeUNoa2NCMUdFYVYySk1rei9xN0tr?=
 =?utf-8?B?blczaXVpZFJWM29heGNaRW9TUGdmVGFrR3piVW1tNEU4TXorK01SOXpXRHpx?=
 =?utf-8?B?Uk9uQ1NCdEdMUVMvaFBLcm9WdmlJT3pUaDJCZlFLcmQ1a3d1cUR1MVk3MnRP?=
 =?utf-8?B?c1pDdE9VTUlRYkRFTGNUUm0zd0o3UlJ1cnRDZTNJMnp6QkYvUUZLT3I0aGI1?=
 =?utf-8?B?WEZEd1VxTXNIUjkvOVM5czJkb2pnR0xIakpRU1VvQ3VPbHV6c2VBckRYNWc5?=
 =?utf-8?B?RzZadmloMXNHTzRNREd5Nk95R20raFBEWlo3WlNZVGJOYjdjN2ZISytYU1g0?=
 =?utf-8?B?Z0YrQk1MUW9ySEpEWEZ6dnBtY3B2MWg0SmxoMHJudXQzUnVsY1JESm1jNmhv?=
 =?utf-8?B?VERYWTdLM1hOZjRFc2RTNC9XRkRKV2MydHRkNitsZTk1L05XQTFMNzhoY1RU?=
 =?utf-8?B?R0xnRFBpVHI3akViMTB6U3Y3OGsvSEM2VWVFdCtoUm54T24rVzZFS1lGeTYw?=
 =?utf-8?B?NjUxVDAvVkYzSW1NRDBVd3BDYWhnU1NsRUNDWC9Zd2k4TmVlY1FPYmNKR0dB?=
 =?utf-8?B?dG44bHlWT3pnTC9lSld5TmxHVHRBWDB3eVJBOHVnRFVGR2NKSVNFZzBmY3JE?=
 =?utf-8?B?OXZyeThtMkJOdlc5UEJsdkcvVnZUaHRaeUZxMDhhSTQxVXhjY0dTbHJnQVJ1?=
 =?utf-8?B?aHhlZWJDR1grMjM1NTFLdWpqT2tYYW1HRndLZ2tsOEk1cGNWV2phUzZxN3U1?=
 =?utf-8?B?RVQ4aXBWQ3RQZTFnYWZoZEwrazM0YmlUMSs3QjFFeGRhbnVZSVhRUnoydG4y?=
 =?utf-8?Q?p8u872PB/BA4kdRxAA3xdMIE8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 286ec8ee-928e-4e70-9259-08daf3e7985e
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:22:04.7394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YreA+JyHUvR2mP4pQ1KowN3sKtrD2D4bAznbrcOFNKMVaSnuq8JQwKgzrLVtpTaa3WKcIZDt4oQ6Mk+vJ/JRsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P192MB1570
X-OrganizationHeadersPreserved: DU0P192MB1570.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-ORIG-GUID: AAQT2kddaGFrqIlprP-Ifut-k7LnRtlO
X-Proofpoint-GUID: AAQT2kddaGFrqIlprP-Ifut-k7LnRtlO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------JoXwdeoPf89RcPICgF3xHres
Content-Type: multipart/mixed; boundary="------------nmUr7CFpDinqhCGfOsR13lIA";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Message-ID: <8f6cc42b-c320-45dc-0e45-2377a2fbe215@westermo.com>
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs when
 selftest restarted
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian> <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian>
In-Reply-To: <Y7lpO9IHtSIyHVej@debian>

--------------nmUr7CFpDinqhCGfOsR13lIA
Content-Type: multipart/mixed; boundary="------------lyKep0HQQFeCzI7puU0d4Mzy"

--------------lyKep0HQQFeCzI7puU0d4Mzy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDEuMjMgMTM6NDQsIEd1aWxsYXVtZSBOYXVsdCB3cm90ZToNCj4gW0NjOiBNYXR0
aGlhcyBzaW5jZSBoZSdzIHRoZSBvcmlnaW5hbCBhdXRob3Igb2YgdGhlIHNjcmlwdF0NCj4g
DQo+ICpzbmlwcGVkKg0KSGkgR3VpbGxhdW1lDQoNClRoYW5rcyBmb3IgdGhlIGNsZWFudXAg
cGF0Y2guDQpZb3UgZml4IHNvbWUgb2YgdGhlIHRoaW5ncyB0aGF0IGNhbWUgdG8gbXkgbWlu
ZA0KKDIgTlNzIGluc3RlYWQgb2YgbWFpbiBhbmQgdGVzdGluZywgYW5kIHByb3BlciBjbGVh
bnVwIG9uIGV4aXQpIGFmdGVyDQp0aGUgdGVzdCB3YXMgc3VibWl0dGVkL3J1bm5pbmcsIGJ1
dCB0aGVuIGxpZmUgZ290IGludG8gdGhlIHdheSBhbmQgaQ0KbmV2ZXIgY2FtZSBhcm91bmQg
dG8gZml4IGl0Li4uDQoNCkxvb2tzIGdvb2QgdG8gbWUuDQpBY2tlZC1ieTogTWF0dGhpYXMg
TWF5IDxtYXR0aGlhcy5tYXlAd2VzdGVybW8uY29tPg0KDQpCUg0KTWF0dGhpYXMNCg==
--------------lyKep0HQQFeCzI7puU0d4Mzy
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

--------------lyKep0HQQFeCzI7puU0d4Mzy--

--------------nmUr7CFpDinqhCGfOsR13lIA--

--------------JoXwdeoPf89RcPICgF3xHres
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCY77UGgUDAAAAAAAKCRDfdrYEUzwNvkdC
AQDHMR3suP6ZsOzb3lEHmAX1ojeInFUt+BMKLFOxvBQYswD/cxMGLO/gtnfILWcXg4G3wwH76H33
5u78CyXwysMF4AU=
=tem9
-----END PGP SIGNATURE-----

--------------JoXwdeoPf89RcPICgF3xHres--

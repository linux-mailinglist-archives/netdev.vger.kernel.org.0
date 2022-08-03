Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7366588C58
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbiHCMog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 08:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiHCMoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 08:44:34 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305CB2873B;
        Wed,  3 Aug 2022 05:44:31 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273B1u0l010737;
        Wed, 3 Aug 2022 14:40:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 mime-version; s=12052020; bh=+H4HWiDhRR12823TSFO8QNTcgCwPUwhIvczD0g/VySw=;
 b=m7MQCA3DeIGD+9eqOqJK9U2YXur/mgKv5XDEeAQyNpGh9t1JEb9S24E7eRYU2jZbIDJz
 WhxD25Jwcx2iwkvAa0bqmWebzm2+psY3ctcgVFxhJSS/aEB+zZH2hGh1TcKVDRzJiq78
 p21QCIWkfhr9WC8ylcIS+twd466F/Q68dEBigbtVvvos5HDLXRf22iMLVEL1aCMUU8WH
 q2hGP3g83gDE3bINmcp+RjIryfbJJHGARiLfK0bp6fUX4uoYHTH8fCDiRCpj0SMZX8eP
 KvQD9v6NUNTUPFZbgO21RnHlOaE+ujkwsZCLMFHQpgM7so5WXJ2yQD/xVZR1JlKLrwnl Rw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hmrn43vt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:40:48 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Wed, 3 Aug 2022 14:40:48 +0200
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (104.47.9.56) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Wed, 3 Aug 2022 14:40:48 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJX5Bz0c0r0Dm445lqAd2b+Q3gQwAN/4EB0dgQOXC1OJYn6loRR4A+UGlSCwsKfpD2PHDTi3Ijm0qUvaMDuzYtW51cBjxQdgP34Qhzz/129tqSjvAQfMPtFayM0FRGywt4C9im7SagCsyXZ+xW+oDUfVPp2Z4gu82ZBcWgcgFO0p0ROb7l/+TbtUoOGvqEj9XOaix5xWY/z7ixp2azIVmG/jKrfWFhcH5eEH2O+vWMUr0bDoPZWPFZ9U+Ou1Ami/eyvPJKLeY3hJSzXwfJ6gqptiEZH+5SU6g+bW/oM/YI1IRnm08TEcPizKAmqie6zgQaF0u09tpzPVteDA03WQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+H4HWiDhRR12823TSFO8QNTcgCwPUwhIvczD0g/VySw=;
 b=A3+cUYDJjvab8LfBEqO/f6XJHe5CkRcp1HlkNNcIeswp6aO6q67+qmdKyaeeYK9LgrTbdRY2ZCN0km3rb58Tb/2GQ0aKwTxDT1UQvJspjkI5puTPqtbgXMqNuq/80A6gGYwoAaz/XuG5Edq1kGUCdYf5oB3ALZkJSnW3YTWoO/lHrnt4byaUCbza2ruO8z0Ost55kjXjSqwk9QPFLeCwU/RXXpr7RIpY65pG+qLHN8ibWPFgcWbCsbiwS3jz7QID3DCrdS3dwD/iGUUe/FMVGpoJAhPOj92XGH6tm3uIR9bV2zSKQuTTTyZu+bRTJt5sC4MYGEACQ+VRwBw3nWaIwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H4HWiDhRR12823TSFO8QNTcgCwPUwhIvczD0g/VySw=;
 b=P7+TRBZYPniG8AZFPEu7QAfH535MXEDYIvUDQMRhB+UvCs1kde8kJf0yb3iqGwGHDFrKl1WStJvlwBwE5nfoQse24Mn67QBMDD+qdRsB6Cu1gt8NnuEGIkxg2bLIxUhHHb+OiDFp6pxWnIYcoTiqzfLBMXEnbE3a/hLnaMn05AU=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by AS1P192MB1469.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:4ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 12:40:46 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::582f:a473:b276:fa7f]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::582f:a473:b276:fa7f%4]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 12:40:46 +0000
Message-ID: <19ac9568-682b-3e21-1d5b-ccca870910d5@westermo.com>
Date:   Wed, 3 Aug 2022 14:40:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 net 1/4] geneve: do not use RT_TOS for IPv6 flowlabel
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <roopa@nvidia.com>, <eng.alaamohamedsoliman.am@gmail.com>,
        <bigeasy@linutronix.de>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <roid@nvidia.com>, <maord@nvidia.com>, <lariel@nvidia.com>,
        <vladbu@nvidia.com>, <cmi@nvidia.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <nicolas.dichtel@6wind.com>, <eyal.birger@gmail.com>,
        <jesse@nicira.com>, <linville@tuxdriver.com>,
        <daniel@iogearbox.net>, <hadarh@mellanox.com>,
        <ogerlitz@mellanox.com>, <willemb@google.com>,
        <martin.varghese@nokia.com>
References: <20220802120935.1363001-1-matthias.may@westermo.com>
 <20220802120935.1363001-2-matthias.may@westermo.com>
 <20220803113041.GC29408@pc-4.home>
From:   Matthias May <matthias.may@westermo.com>
In-Reply-To: <20220803113041.GC29408@pc-4.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------MzXFsfKpzOmzykMyAmooPwxj"
X-ClientProxiedBy: GV3P280CA0094.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:8::7)
 To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1f9fca5-b49a-4cc8-e65c-08da754d631a
X-MS-TrafficTypeDiagnostic: AS1P192MB1469:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bug8v8OX73WeNvU9qUP1GlSWHGdWBx5+43s5MLGyMndzw6wo2ICphYs8u7mReG/RQ1UoPzcKa73OMBUrM6d17T1FKKISWv8Mrii513+MnbLJA1ZyTwmK2v+mQN+vR+NEH+8ySt1lFJ/n1bXLC0rPGRKIF5hWBnubV9NnzIxSvz30Nr4gdodNF/wJQuwGgi4djuQLP6/hOp8VtkFkPxHfhBcnatvKls1C6ispgXNLnl1CY+oLi28u+uzM6MFPTDrI03uoDR9hmPhTC31INxGcPYbTUiAExk8VsLrfO4KgviPXWAM/6jt4Z+0f+uR2oprq2tIft0nbzNj1O3zXZyMkf/+924GeZ2e16FbKoF3dR3RfE4SCevjVdVdkgjM549hzyhZIXNiJdpG8/PibGFSZx7HWMOVanThci6DNBXjyAZ5L7Pgo0y8UB64K1n0V4RRSqXZo2Zx5elE8xA/MBg7SfcLp1vvKauLZOkf1PELMQ4G3Dzg8xDf6PwODG0DvOZa0JBgEhNGQyCniLiI5xE8wZvWiDv7Ve3APJ2kVY5gwIV/LLFo9ZPL9HIqW1H5uD9YfrfurBg9tUR4JMhWrnzJolPw3F7BUirfsGOk8FCLkVaHuHY71xHTu49wZtSj0aQFZENfKnUgPqya/1q+0Sak0q75GGvc+hWAbfiId8MjyTNv1TfjAQolrorK79mseocSf8Y0gkCgdOi7m3y0BcvERVG65c09DYzoR8UB+1pB1jbOjcI7QEn4RZbQ8UeY4VtUmXq0oQw8BT8oDviYjozz/oC4awZt7VGcBdU/IvQ44zk/o5ErCOZIBU2OQYXUhTrwq1GeF/P71kQSgYrpji+wE/I7SS3HQgkc3iKu5/Yb0X3yZfr06+xJ0XwGGiY7Jlt3e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(39850400004)(376002)(396003)(83380400001)(186003)(26005)(2616005)(6512007)(4326008)(66556008)(66946007)(2906002)(7416002)(66476007)(36756003)(8676002)(7406005)(31686004)(44832011)(5660300002)(235185007)(8936002)(86362001)(31696002)(6916009)(52116002)(41300700001)(33964004)(6506007)(6666004)(53546011)(316002)(6486002)(478600001)(21480400003)(38350700002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTZ2UnMrS29rdDl4ZDlZN3BiUEVQMGFCbUpvZ2VRZ3RGaVhBRTUrM09DOS9m?=
 =?utf-8?B?aFhBTEdwcGtGd3QwU1ZTTlhRM3FMWWwrY0RTZVFFUGszV2RseVA4dkFQTjR0?=
 =?utf-8?B?aDJpQm85QVJ3RHdWLzBqbGFOb0JzZy9RSmVRWWdLdzV0L09FMmJERGhlWmdK?=
 =?utf-8?B?cTdBbW9NaUtCQUhmcDdtS1hJSDRab3cyM2tZTzlsM05oS24wWnlhaDA1bVRj?=
 =?utf-8?B?OFJpVmwzbERqZ05lMkJOUmNGT2lOYzhUYjR5OTRYblRIbis2SnlOaE9BUXRw?=
 =?utf-8?B?VzI4MGxyR1pZMDVubUJaK0VBSkIvVnRLVXdUem1nTk1VajRtQW5RUGhKMFhQ?=
 =?utf-8?B?RDlYbzRSWHIzSldoTGVhbGV4M0lYRFJIdkhUb1MxN0czRXhQWDg4UkFLb1Fk?=
 =?utf-8?B?L0ROK0hOVlViTzJaNUxPR29tWTU0Y1ZkYitER1EvVzlkc0RJNUdIYTcwYWdP?=
 =?utf-8?B?MWowa3o2KzNLUlFpZVpEU0VtdDhaUWRaNlEvWFhvYjA4RGR2bGFUMHVXK0Nz?=
 =?utf-8?B?c0hUU2g0MWZQMDlQb2gybmY1ZytMSGJzS2tqT0RQQ0dwNjdDZjRqc01jNUtL?=
 =?utf-8?B?c2h4MGVmcG5xN200Z1VyQUcvU09TaklNTVBGVHF6dlJMdTBhSTZpalc3SGlr?=
 =?utf-8?B?Nkp6ZjR1QURIckFNTkcrQVV0RmU0VUpDcnFBc0Q2d2VQWWRWSWNjQ0xBakkr?=
 =?utf-8?B?M1VsUmhNTXpSL2xFUldFemh6RTRHU1kydFpYSjA2Q1FLWDJRS2lTbElrcE5t?=
 =?utf-8?B?VldnTm9zTGNIbExZNVA2bFBabE5FZTgyUE1mRzh6ci9zWmpqM3A5Sk1OWGdC?=
 =?utf-8?B?c0h3b0NFVXc3Q3o4RmYybWIxem8rZit1aCt3UkFtMEUwZkZqeUFhWG9VMm94?=
 =?utf-8?B?a0grd2xPZC9RWXpVODVEYWNXMUxjMjhCN2FNenFyMjlhOFpkVkFUZVZDY3Zl?=
 =?utf-8?B?bEVDUFNyOXZjeVZqRXRkU3RKaW1vWVRtVC9ZL1pmRHFoOTNGOFZtZlQrTXpB?=
 =?utf-8?B?V2hUQ1ZRaTVqbDhvSTBGVXdXazV0MXFGN3E2ckttOEZTNzhrSUFLeDFDbDRE?=
 =?utf-8?B?YlV1eHdhWUFFS2hGRDREVXlEMXI0ZUFKUlEyYXRocTJOMmFoWWJRT0ZQNGs4?=
 =?utf-8?B?NEYxaEs2Zkg2amE0bGZsUjBSZndSUEVuTFd3NTUvOWxud29ZeUNjOGtUUHBU?=
 =?utf-8?B?MjJVS0twdTBiQURCZUdyN2dnUGtCMjNSMWlFYXlXUzVPajVhSnlZSEJYK2Ri?=
 =?utf-8?B?dXZlSFdUZG9ja0VaL2FwV1g4cEZLKzdKenFNN25vTENkdHoyL04ycmNkSElt?=
 =?utf-8?B?SC9ycDVkQjBCdXpmV2drN2hFK3lnZHo0Wm02aUtoRjd5TnFRM2ttYTZaakxD?=
 =?utf-8?B?cVlTVUhMUjFURXdiY1cyY01sZjVIMFhwNDh6Sjh4RW5rQVFzQVl1cHd3T3d0?=
 =?utf-8?B?enI4S1ozbzV6YlAvekFhL0VQQjlxS05MS2VqZTZlU0c0cG14aWU4RmpRUVJ1?=
 =?utf-8?B?blhQcnR4Q2N0Q0tHNTUxQlMwbFlqM0o2bENHbGNwRDhQYS81cnp4Z0xzR215?=
 =?utf-8?B?Ly9ldDdEYldnZFRXeDFEUHZSVEJTbWRQV2luci9ZM2NZNlp6Wm1uOFZiMjdo?=
 =?utf-8?B?ekhER2dlSmpjTkM5UlplL0VBeVpPQ3UyR1Y2V0FxNlZvTGN3TEoyNlh1V1Va?=
 =?utf-8?B?eDQ2ZUxJOThRck5qeDhXdjhtUzlXMHJkQXIvZGY1RktVUy9SbXVEc0lBNkd5?=
 =?utf-8?B?ZjBMY3lNWEorOFJJQlFSOVJSZ2RWU241L2hYQlBHVlBpZk90QnRucFN0NDla?=
 =?utf-8?B?VWxYQ0pEWHRUWklZNEpCdHJXTG1vRGxUUXNTS0MzOHdyV2pITTg1U25VSVdT?=
 =?utf-8?B?K1JYY3dGNlVxNUlaVmREYjNlbjRqeTZJL0NySWNORVQvYXFYeHZtUnVJZks5?=
 =?utf-8?B?a3M0ai8valBUK3c3R0syZmdaV1NNN2V5SWp5ekhsZUtXWGJyak5ycmFPQUw1?=
 =?utf-8?B?T3loRHVpTWl2K3I3Qzk1SUNRYlBSb1E0OWc0eC9aZG5ROWRLUE9KRjNDSlQr?=
 =?utf-8?B?dVlsTFBWUDh3Y3R1b2E4NnlTN0F2MkE2bWdDSXFORG5veTdCNFFOM0pXcjA1?=
 =?utf-8?Q?pdpAoB7GTowgVCSPSuTGtRI2B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f9fca5-b49a-4cc8-e65c-08da754d631a
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 12:40:46.3547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VpRQvvYasBrjh8P1YqT/mHLdAWxcHUU86BUcq8W5u4aIwaQuz6YyykzO3EPbh7QPJEhlpiUeck8wO3xXrcdbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1P192MB1469
X-OrganizationHeadersPreserved: AS1P192MB1469.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-GUID: wVam-pPZnJuV_bboyRdROrx7LCKqx2s-
X-Proofpoint-ORIG-GUID: wVam-pPZnJuV_bboyRdROrx7LCKqx2s-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------MzXFsfKpzOmzykMyAmooPwxj
Content-Type: multipart/mixed; boundary="------------DE6Ztshkf9T9ZU1S4S8NkvkK";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, roopa@nvidia.com,
 eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
 saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com, maord@nvidia.com,
 lariel@nvidia.com, vladbu@nvidia.com, cmi@nvidia.com,
 yoshfuji@linux-ipv6.org, dsahern@kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, nicolas.dichtel@6wind.com,
 eyal.birger@gmail.com, jesse@nicira.com, linville@tuxdriver.com,
 daniel@iogearbox.net, hadarh@mellanox.com, ogerlitz@mellanox.com,
 willemb@google.com, martin.varghese@nokia.com
Message-ID: <19ac9568-682b-3e21-1d5b-ccca870910d5@westermo.com>
Subject: Re: [PATCH v2 net 1/4] geneve: do not use RT_TOS for IPv6 flowlabel
References: <20220802120935.1363001-1-matthias.may@westermo.com>
 <20220802120935.1363001-2-matthias.may@westermo.com>
 <20220803113041.GC29408@pc-4.home>
In-Reply-To: <20220803113041.GC29408@pc-4.home>

--------------DE6Ztshkf9T9ZU1S4S8NkvkK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpPbiAwMy8wOC8yMDIyIDEzOjMwLCBHdWlsbGF1bWUgTmF1bHQgd3JvdGU6DQo+IE9uIFR1
ZSwgQXVnIDAyLCAyMDIyIGF0IDAyOjA5OjMyUE0gKzAyMDAsIE1hdHRoaWFzIE1heSB3cm90
ZToNCj4+IEFjY29yZGluZyB0byBHdWlsbGF1bWUgTmF1bHQgUlRfVE9TIHNob3VsZCBuZXZl
ciBiZSB1c2VkIGZvciBJUHY2Lg0KPj4NCj4+IEZpeGVzOiAzYTU2Zjg2ZjFiZTZhICgiZ2Vu
ZXZlOiBoYW5kbGUgaXB2NiBwcmlvcml0eSBsaWtlIGlwdjQgdG9zIikNCj4gDQo+IFdoaWxl
IEknbSBhdCBpdCwgdGhlIFNIQTEgaXMgbm9ybWFsbHkgdHJ1bmNhdGVkIHRvIDEyIGNoYXJh
dGVycywgbm90IDEzLg0KPiANCg0KSGkgR3VpbGxhdW1lDQpVcHMsIG1pc3NlZCB0byByZW1v
dmUgdGhlIGFkZGl0aW9uYWwgY2hhcmFjdGVyIGluIHRoaXMgcGF0Y2guDQpGb3Igc29tZSBy
ZWFzb24gZ2l0IGJsYW1lIHNob3dzIHRoZSBTSEExIHdpdGggMTMgY2hhcmFjdGVycywgbm90
IHN1cmUgd2h5Lg0KDQpCUg0KTWF0dGhpYXMNCg==

--------------DE6Ztshkf9T9ZU1S4S8NkvkK--

--------------MzXFsfKpzOmzykMyAmooPwxj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYupsyQUDAAAAAAAKCRDfdrYEUzwNvhFz
AP0TsoZdVoS4Rx9UrNBTb/3AvAO8/qtRTW95UI8fJw1QBAEA+Es0Xor6s0v9XK9nMo4iij00KfH1
oQWeMmn63uNd4wo=
=lH8H
-----END PGP SIGNATURE-----

--------------MzXFsfKpzOmzykMyAmooPwxj--

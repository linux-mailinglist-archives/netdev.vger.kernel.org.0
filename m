Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCBC571376
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 09:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiGLHv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 03:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiGLHv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 03:51:58 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7E39B57F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:51:55 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C7QL5E020068;
        Tue, 12 Jul 2022 09:51:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 mime-version; s=12052020; bh=qcoOsn3MOlSQiozB/dpm4xuLMaABTeTXVROy0f3fyGE=;
 b=neXbhBOuEeBL03Tl+HSuBLqxhBLXtuwC6GGwW9Pg4ifhJSwQi236zsHkcgTwthDf68Ee
 P0mFUizNb9wETDsW2oP0/1XBr/LtqXdoDa0zBRAp1+jKuuQLc6rUqr2S9iLtT6sfbt9L
 1W9tea4Tayls5e4YqwNIcrgC3+qs2GkiQrPs3tk2BVUAJLINnE6Bkl8U/yovTEeg74TO
 tLKBfgD/GtTBbHXNuj3WX9q+Cu184paFls4R45X9JfaNWTs7fnNhJ5uGxwZ35+iJL9h3
 2pLdRF+Nmz6yEda//G+U4RFlUR8UMx1FLAhaJq955aYJikOe4a9Ukf2zxw7/SEhTXzw4 0A== 
Received: from mail.beijerelectronics.com ([195.67.87.132])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6wp62v78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:51:25 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX02GLOBAL.beijerelectronics.com (10.101.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 12 Jul 2022 09:51:24 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (104.47.18.106)
 by EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:51:24 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHSeVK1VROU2EVzcJv5+i1TL65bAdRIOvbs2hF7eiCWTIWw4K7VGOAnze56+p32iYXao60p3SpyNLtMWSrtYkFcf5UpV/iY4iTDjh6jPVg3t6fiDQdu4ZNOqrOXlTwbvr27Ci9pLIy2z/ZNhYksHkT4gCGEPCezf3KblFXFMLSdA3KTfDnMGtnS6+ZMruwoA4O3GaK+z8AFIBUBUKIA3U7i9cYvIeomHeGb698sEEyAMLuB1Xc8Csu4aAxeYLAxdh5RcaVONazS8fAFHqAPpaw3KkyUJZwt2Ps+Yb36/p0PBhiXiI3rFUZWSwIXbxhoJIvG5vVJ/jCuBY9D+ztoJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcoOsn3MOlSQiozB/dpm4xuLMaABTeTXVROy0f3fyGE=;
 b=QYWwVkKX1+WsgLKiWy120j3iyIQZEP1CTHjPYr/2u5rD6LbzZn0i8XmxG9+2CEtTnaCufUi4wm7xavf85P/AIWaLHVWZkVzpu1hFr10PncRaObDqO9vOEG4P7KNYZ6rewSMu+9pjk2RGzmVj8UnQ1KmqvvzxmoplvlXRwFYAPCYwgdZhbujx2ixW2KIltE4KQb1TSYF9id6V8SusOs6ZkPpvAqYEy6RlEypf2Rr46q/uzmNsj0N/FkDP8C1ikFBi9uGiZMWgdBpOQy79aa0nHvwBxgBatSfqnjXmS+L4mDKY/c0k3BiTkiC4JO8pPO4n6atHXZs1qG7mYA7e6ZUtNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcoOsn3MOlSQiozB/dpm4xuLMaABTeTXVROy0f3fyGE=;
 b=tTavm8iqmkOzIMe6qKu1JYxwUk8tzf7ZpDrLGTexZuw4TBDjNbWkHjPjH94FukQoMLA4K6G6pDqv8rjrn+82uHKNdUXIm70S/qmhhZYEScYOQ79N7rbYLAxnw24V5MV7FHIcTyzJDb0Q79OMtTOl2OapRqaGuBBy9NirNB4HqN0=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by AM8P192MB0929.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1cb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Tue, 12 Jul
 2022 07:51:23 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 07:51:22 +0000
Message-ID: <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
Date:   Tue, 12 Jul 2022 09:51:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
Content-Language: en-US
To:     <nicolas.dichtel@6wind.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
 <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
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
In-Reply-To: <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------o6JjcesC3EaT8UoUuch7dfJ3"
X-ClientProxiedBy: GV3P280CA0108.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::19) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e223a2e6-fc69-4740-2c9f-08da63db5057
X-MS-TrafficTypeDiagnostic: AM8P192MB0929:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A9TX+qIsH9qBtIG+MpzH4tBSXsq/H2qXTbZh6P6JRF+QmVxYoZwX8EIDgRCXXSap8PyrUNhswYu4rml9Z156CtzYOKTzcUcy7Le3jhSa5DVN4ak05ERnTsZqGivwlS4PtsNEID+dkOuxwdND3SQ14o8o6yWVxl+H6YbomqTlzzcxVaJzg8RBSA8WUWDxDkmWylJkLT7rl7hEHL5woBjRokhmeAwhBTMqD84ZeyZJxvdFY/JlXUWjphN6T0C5qyF/qj0gNw4AcztXwUI1zUgIs/MP4vC/phG48b1Pvao+a9/OaAyRSx/mBsPeIVHpUMOOow5ta/yuZhZZuJHyu/nzOOHuhKKWqcMGpipgcdymRUtDV3Xzpd8ui1Z8Gcrq1yRIxCZq6nCPEA/GvcODDUf+8UyWLXFLXOHgZzlnK6zDdan9LsLSHbszfQSlNwsU+PPQEBw8V2+EPFJU8Ml+p1721+glkXEW3Ue3M5RxU1a8NmyFKeuIOPEU7tlWwkAadYKHE7/sQElURcUkVEs3n5yYwieDOz6bqh6QgN/GvJN5hAzkTQBnrxRcYsaMjzjzGkfCkDpmaMNJt1l60EmBymucLsdASWN0V99CvXf8qUPf0hp5/xPVy8TQHQ2TLrmFQRlw4FSu4rZJC03q0yAikPb1ZKAONe5TxhlYknCc08oMgLkn/+lT4wMuknImuDZgOz0YKgxiQKBvA2JbJa/+YPoCfmni6GTYrDj7unJynO/iPn/t6I/xDL1gaxEFwzILrHlpQ2SZ+MJIm9vVotfoBRqEtT1Q8+EpbCosLTSscKJxpzSvr89aVe0O4NdENn8fGgoup1RXMAYmM+ShDXJoN5LbLIIVOxwaxt3H1TALm+dNsONAEYAyN5JZ7y48PHi/Z+Hu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(38100700002)(186003)(38350700002)(83380400001)(21480400003)(44832011)(31686004)(5660300002)(66556008)(36756003)(4326008)(316002)(6916009)(66946007)(66476007)(8676002)(6512007)(86362001)(53546011)(6666004)(478600001)(8936002)(41300700001)(31696002)(2616005)(235185007)(6486002)(33964004)(26005)(52116002)(2906002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YndZM3o2UENsa2Rsa0I0bnVzYXFhb1RvMlFHSjdIa2dPWWdyeTZaeVB3N24x?=
 =?utf-8?B?cE51TWR6SXhBc3RienJPcFRxcXlCMy9GdjJPSkxsTzN0bExvbU9uRmRyQktL?=
 =?utf-8?B?bVJqTDVmY1NESG1HakUvMnhHRENjZUtCVEZLWW55d2tGL3JETC93eGdBMDFr?=
 =?utf-8?B?OHVBdzU3eW5SYmUrQUZUY2VKYi9kZnpOTWFMTWdKMFBTeW1FOE9yMDVFTkNL?=
 =?utf-8?B?VUU0T2MyWWtuSXhOdTlsUWlzeUxkaGhZSnVZZ2IyRHpPbldiQUVFL0NPWTI3?=
 =?utf-8?B?cjlSdDNGTVRHaG5XUTZDMlcyRlZGUGZVVnRoYWNMS20zUVRLSEhTME40TkFD?=
 =?utf-8?B?a0ROUWFIUU5HVmIvTHYxM2NyM2lBUHBQTEVWUVJHdU9xQ2V5dy9CRk5rTFQy?=
 =?utf-8?B?TnNSTnJEQnZPRFNGNTkrWHVRZVV2S2dsdUdPNWozdnhwbGxvZUt4eEZpL245?=
 =?utf-8?B?bUtERGVvclVQUS9FZ0VTbUVOdDZGMlVmdnRRVmd5MmhRMTlVR3dLOXlJY29v?=
 =?utf-8?B?OVhIMnduY0NuVG5RK0dMandmQTIxTGZKUEkva0RRTlJQZTlhZm5TUWh4UGQ4?=
 =?utf-8?B?U3dJVTlmSXI3K3VDQ1Z5d1VINEdqakZRb1lRaUloUGNQUXJleEFrdHhCL3J0?=
 =?utf-8?B?L1dXMzRTZm9OVzF0UFJxSldvdDZDTThGaFQ1WEU5MGpZa1ExdndxM3pOMlYz?=
 =?utf-8?B?YzhoVklsN0pVeWhuTmF6SXFvbzBXdEV6VDIxMjhaL1g3aGJobkE2V1dJbHB1?=
 =?utf-8?B?L28yYS9JS0w3K1RDTTA2RXFoT0MwekNKSklTSFRsZnREdkVheHpSVjdJUG1I?=
 =?utf-8?B?RmNoV3g2QXB5Z3J0ZWs1ZzlJc3kxcCtrNjRnT0d2VEltVE9SZGVDOUFRR250?=
 =?utf-8?B?Mjh2cHJiY1RrRWtaM0VqRmdPbGNFeG5YeFRzSlhKd1NuM25uUzdzaXF3UENN?=
 =?utf-8?B?UURVVm5neGZ2RmdUMTdwNHdJdG0zWGpaa0pwQTlXdUU5azFEWk1QL3dFeUJC?=
 =?utf-8?B?SWFuaWxHZ1hVNjdZRVNkNy8xbGVscUpHc2FlM1pYcGVFUXhaN1hET0EwWDQ1?=
 =?utf-8?B?ZlI0dExaN0IrNmpreVIxYkVmSmRyN2VRQ1pMU1V0M0FzeEk3NmVNUTJWYzQv?=
 =?utf-8?B?ZDVCMG9YeEMybHpXNmFQMjAvdURIK3ppZk15TVFjczdCbzRvZStFWENvc203?=
 =?utf-8?B?dHZlS1Y5dndEUkNsN1MyeTBIUS8rME5OeTQrSEVua2IzQUEvc20yUnp4eDRm?=
 =?utf-8?B?L2lGT1VSU1NSUUZkRi9qdDZEY1hGVFlCT1Y4NGQwbmRYUUdvNFFCSUtha0xr?=
 =?utf-8?B?SjB2aDNldFhyMFc3Q0Z2cHNsNEFhMHFUTnYyS0lpTVpnYWtOaGhUSjQ3c05y?=
 =?utf-8?B?Zk94RWpjOUg3ZlBobkpHbTJId1QvWHZZTTBBdnZsekRGS2lzOWhDa3V2QkNO?=
 =?utf-8?B?ZDljMUZETTZiVkN1MHNMdWFzUC85Q0grdjZqZW5HYlRyMlVkOTl2L0tMM0NH?=
 =?utf-8?B?T0FjaGJxclNMQktOU1Vicy9oandUclkxM04xV3JqL3I5UXgzUENqRkVIaWR3?=
 =?utf-8?B?ZG9BRDRVbzJtZTV5STFVRHBOUUt3TzhpM3pTWTZQek5NYWpxTW9OcFBFTWhU?=
 =?utf-8?B?QVhYMDhjVE5vVWV3RmcrcEF4RUpmNEkweC9uMGFCSFp6allza3Y2TXk4U1R2?=
 =?utf-8?B?dmdzeTg1MEJJTXR1M1JGMUM3SjVOK3I2a0l2WEdwNktwd1kwZEJZTVlhV0pE?=
 =?utf-8?B?djlVQmYzbVFpaVdNUnZmOXVkSmlyeG0yVHp5TXVtNDl0ZE9VcFEyYWJLS01K?=
 =?utf-8?B?ZHJCNWgveUx6SkhMMVFrZXlZV3pGRGJkMW5XNDNHMnJiN2tkMTVYYjM0SVhK?=
 =?utf-8?B?V2Z0em90QThxd3AyY3lXOGpsd1dabENZVEFFVnZMVC83YzhYTWlCZjQrd0Vz?=
 =?utf-8?B?dWZsd0orWnNXeE9qTzg0TmR2TkpzY2M3VHFtaFRJWE11bkM0enF5dTA4YnA1?=
 =?utf-8?B?VlROa0lnRlNlYWhQMnE2ajdjUlN3b3E3UHFLYmIxMEtWdVNCczc5d0JHeTFN?=
 =?utf-8?B?S1NXWWloVFlUWnRUYzJCenBOWWNPZVhSdHlNTkRDKzlSc2Z1MUY0TDJMYmtm?=
 =?utf-8?Q?Wzn00Ryd/Zy7I93NLRK88/+/P?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e223a2e6-fc69-4740-2c9f-08da63db5057
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 07:51:22.9160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PQReiU0Aeh9VpmGAevn+LA8eTTOCAEPER/9oFXxfncNGrJP091tKT8mDJKjkb+sbBxAt1Z7M5/Bs5rU0QEIwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P192MB0929
X-OrganizationHeadersPreserved: AM8P192MB0929.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-ORIG-GUID: rUFbVpJTBYJ0BTx2q2pvgFmj_XZRnrxH
X-Proofpoint-GUID: rUFbVpJTBYJ0BTx2q2pvgFmj_XZRnrxH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------o6JjcesC3EaT8UoUuch7dfJ3
Content-Type: multipart/mixed; boundary="------------6LUXiO7OkmxFg6EXx0lKgDFP";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com,
 Jakub Kicinski <kuba@kernel.org>
Message-ID: <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
 <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
In-Reply-To: <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>

--------------6LUXiO7OkmxFg6EXx0lKgDFP
Content-Type: multipart/mixed; boundary="------------rVIXYdaQrATpJr00ynZ3mxBG"

--------------rVIXYdaQrATpJr00ynZ3mxBG
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8xMi8yMiAwOToxNywgTmljb2xhcyBEaWNodGVsIHdyb3RlOg0KPiBMZSAxMi8wNy8y
MDIyIMOgIDAwOjA2LCBNYXR0aGlhcyBNYXkgYSDDqWNyaXTCoDoNCj4gW3NuaXBdDQo+PiBP
bmUgdGhpbmcgdGhhdCBwdXp6bGVzIG1lIGEgYml0OiBJcyB0aGVyZSBhbnkgcmVhc29uIHdo
eSB0aGUgSVB2NiB2ZXJzaW9uIG9mIGlwDQo+PiB0dW5uZWxzIGlzIHNvLi4uIGRpc3RyaWJ1
dGVkPw0KPiBTb21lb25lIGRvZXMgdGhlIGZhY3Rvcml6YXRpb24gZm9yIGlwdjQsIGJ1dCBu
b2JvZHkgZm9yIGlwdjYgOy0pDQo+IA0KPj4gVGhlIElQdjQgdmVyc2lvbiBkb2VzIGV2ZXJ5
dGhpbmcgaW4gYSBzaW5nbGUgZnVuY3Rpb24gaW4gaXBfdHVubmVscywgd2hpbGUgdGhlDQo+
PiBJUHY2IGRlbGVnYXRlcyBzb21lPyBvZiB0aGUgcGFyc2luZyB0bw0KPj4gdGhlIHJlc3Bl
Y3RpdmUgdHVubmVsIHR5cGVzLCBidXQgdGhlbiBkb2VzIHNvbWUgb2YgdGhlIHBhcnNpbmcg
YWdhaW4gaW4NCj4+IGlwNl90dW5uZWwgKGUuZyB0aGUgdHRsIHBhcnNpbmcpLg0KPiBOb3Rl
IHRoYXQgZ2VuZXZlIGFuZCB2eGxhbiB1c2UgaXBfdHVubmVsX2dldF9kc2ZpZWxkKCkgLyBp
cF90dW5uZWxfZ2V0X3R0bCgpDQo+IHdoaWNoIGFsc28gbWlzcyB0aGUgdmxhbiBjYXNlLg0K
PiANCj4gUmVnYXJkcywNCj4gTmljb2xhcw0KDQpIaSBOaWNvbGFzDQoNClllYWggaSBmZWFy
ZWQgYXMgbXVjaC4NCk15IHBsYW4gaXMgdG8gZG8gdGhlIHNlbGZ0ZXN0IGZvciBncmV0YXAs
IHZ4bGFuIGFuZCBnZW5ldmUuDQpBcmUgdGhlcmUgYW55IG90aGVyIHR1bm5lbCB0eXBlcyB0
aGF0IGNhbiBjYXJyeSBMMiB0aGF0IGkgZG9uJ3Qga25vdyBhYm91dD8NCg0KQlINCk1hdHRo
aWFzDQo=
--------------rVIXYdaQrATpJr00ynZ3mxBG
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

--------------rVIXYdaQrATpJr00ynZ3mxBG--

--------------6LUXiO7OkmxFg6EXx0lKgDFP--

--------------o6JjcesC3EaT8UoUuch7dfJ3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYs0n9wUDAAAAAAAKCRDfdrYEUzwNvtkD
AQD3toyeBR9MfMOWwAKhtOA+mEdIVIi7eWh24QJAddWq4wD/b1YgG2ebcOJMzD0Mz6LWxOJAWitS
dzjWT5wnmV6nXgU=
=PZVW
-----END PGP SIGNATURE-----

--------------o6JjcesC3EaT8UoUuch7dfJ3--

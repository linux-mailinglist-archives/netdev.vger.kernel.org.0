Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A445750A6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiGNOWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiGNOV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:21:59 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2069.outbound.protection.outlook.com [40.107.95.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C91643CB
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:21:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGV8w3B/i8ACjYm5EqcVyTbhUV6sU+KGjgAac0rdKvOnMp/QcNQS16EsUV16H0MJNPuh81rMMuJyQgmmYTvUa31d8Rm+Sqtm6wUOrlygVDNARrf5ry5RrG6HOPGraaaP3gC+ZNky5FiKbUqqO/k9/etJstXTGTZyK/Y+ZkHhKDXW94N1QllVvHgE0CUflYdTFfdUfr7piEDo2WMFbB9YuuUvYyiEkV7BtX6OLmfvf3f/+b5CeUwTpjZ3QJOadsqZmTcTMP6GUXJeWK/ZunPH6Qtx3S0/XRBh85eWoOP+SjxEL16RHa+V4xj7+qw6gPl/nu1VdKpp16z44USnjMI9ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tccLClqUbmLPxZ1N4Z0gubDia+Oo9pgTDnU+S/TBiQ8=;
 b=Ok04WcKTA8w+dBcmrCX9VEOhRRevPsdekVqPFPmbDy9U88Zi/ty8u3/LQUFl0hqIh8ak7nmhKXAakgue6K4SUVjlnP/2R/IwypAivYGsHRjlQ71DaN2v/eH6fDVAVHv9FWJc0011IZ5Bd+gTaq34TuaHMgUbFAgIIYQJfoo5ebAR77VbcZtN0BU1tXqd+6fjS0em5QQwRNh4zprI1MfvSp0b8B4nVGQqWoDjR3J3/m4LfZBDF4n7DZUGJiBQXMeuw/QJn/E6Ian1fmYUfjTbmcCqXW0IfMUPfwFAbTIb4aCpOtH6Y7X/Q8rmOTiB5D4OeYghVIZWzVvnuNMcjvEvJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tccLClqUbmLPxZ1N4Z0gubDia+Oo9pgTDnU+S/TBiQ8=;
 b=BxiZcyqkJ0MCqceTE0t+VEOvbZRxrtRCbzZM94SAw8mdwVUS51/2YfVVxHNvz5kF4D3I38NziGRjQxzjSO1ZSQjzYAbqNMdFVY6wa3qlXfXxzTXNZpxjB/PdHusLG4hgwkI89bwqEu0cPHQyv1thO2TwZF8Fdz4uK640cRo7J9Q=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by CO1PR10MB4785.namprd10.prod.outlook.com (2603:10b6:303:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 14:21:56 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe%9]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 14:21:55 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: network driver takedown at reboof -f ?
Thread-Topic: network driver takedown at reboof -f ?
Thread-Index: AQHYl40Svy5jf8uV0UGBbesFglmmIw==
Date:   Thu, 14 Jul 2022 14:21:55 +0000
Message-ID: <997525652c8b256234741713c2117f5211b4b103.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95b4b22f-4ff3-473f-2d5b-08da65a4348c
x-ms-traffictypediagnostic: CO1PR10MB4785:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yxa5rqF72O9UWbUtJ8+vOfNPvF5fp0GEv3AytxHGwDzDvcMx3m+HVOMrADSaz43bVrMWtnCGaogGRYX7qxBypUiciNpzqx1o9JxO5QfFvOXEkcxSgTkMOPIT5fHkQUeR2TdgApohHHS9dgLMGWkXsNCNHaZGrxRevXzJTnPxsbq83NEQVjHFWu4EcvGFSuq0xv3BYwWI0F5GnkRRPZ/koYN/ME1xWEZAHaRGr0YdewSg6yR3zq6Jik7VuigDTCDvCU4Jx0qI9z/5ASai2ck9C3yFYYj9X1YmCbM3rFmufu7N6dFwlu08sNORf58WTNNr19/9wzMWxiJcYBmCFMKWcNQOQcGCXU1qJi1hr8j5xJ9Pq8106EyOOQQsu5e8A9CGiNnbL4o+MG8SFt8iR9prv/mxAtRS6791XN0dpVo6QzppFiyhY0ok2jUtEoJ/FU2JgHmrL/yahABQbFiDuriE7fSCYDxYiOLtjR91Wk8Az7RP2XLtiePYaEusCGiTJk0XfPHsbfim2FYrKYUTGDixV/rlIoDWV9wPa4mLR7pyu2ve09A/fRaj0bvZRfZallP7yHlCX7GCCLuLszdkPtRP6kp7GKOYt1vaNyJ1EpWzHoTL81VQwrJ3EhFMycaca3hf4vfK9mPxHpTpufy3Y2UHeb7o3Y7fm9quhggv0R9jpZCKUs3677cyjX+HzLlT/ucrMXnZSXbe34qe047ymJR8QPVND7rdxR1/RhlZJn8plt5m2vzjTmkLLVqxjQmjVVG88ka8bHASREwU7rlhW6kh5le4Tko3iZ0uuHAruZS3lZ9Tn4EDdfleMRpP/5nY40j+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(8676002)(66476007)(38070700005)(66556008)(66446008)(316002)(478600001)(38100700002)(36756003)(71200400001)(76116006)(83380400001)(8936002)(6512007)(26005)(86362001)(6506007)(6486002)(122000001)(2616005)(2906002)(558084003)(5660300002)(6916009)(91956017)(186003)(41300700001)(66946007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGFYWGlLbGI5VEVjVFd4OTBzOGVrWHBrdXFqaTltODNaaWtzZTdoNzJOSUg1?=
 =?utf-8?B?YitHZ0Jkc0VyMEl0Y1NVVzV2L3dsdi8xb0pJY2tFY2kyL2NZVVJKSFdQdS85?=
 =?utf-8?B?T01yTzRIbXlZbS9ON0lJNG9UT3RZa004b0lsVXhEdXQrMkhrNnA3THhvenRz?=
 =?utf-8?B?YmNCQmw2UTV4SzhRelRBUWRxcDJ3U0V5NDhqNDFlaFV4MlhBKzZOUktqTWpu?=
 =?utf-8?B?WVhhanhNbXV4MlA5elhMbjMvWTVGaTZxd09mWU5FYWVicHg1SUZ6cXluZDZ4?=
 =?utf-8?B?MkdUaC84MWlUbmVFT0lTKzdSVlR5d0ZQbTFLTURJVE9MWHVUczZpT3FIT2Rm?=
 =?utf-8?B?SDhhejVnaEErRVhtcVlqbGRlcG5seU1qK3JXZms0eWtZQWhQbnNyQUNickdG?=
 =?utf-8?B?bjJuSGpCUjBVTEVTOE5Way9OQ0NSUFlaZjJmR1gwd3BYSDArajRnMCtDbWRV?=
 =?utf-8?B?cmt3b3lXWEVBS3RCRWV3L1RHaHF0SXNaQytqeTF3ZUtMUldlZGwvY3RDL2tq?=
 =?utf-8?B?ZWx0T2tjd0JrSmxvSllhdmdwUnJFNGk1elhKUXFiOElqWEkrM2trOEE0SFIv?=
 =?utf-8?B?cDRXcHM0ZU1aSUJHVmxvazVlSGpEaWdRSHNjdXQ4WFJucStNTld3bDhxMjZz?=
 =?utf-8?B?bGFhR1lRLyt2THI3c0JoSWtkWWJhanJUaFJRSmxMOTFVUjRLaDR2ZHV4TGE1?=
 =?utf-8?B?WCtuNy9Ua2dSSldLejlCVWtTbkxjL3N5Tnd5Z1k1UjNDTWUwbzBRZXNnRTgv?=
 =?utf-8?B?d3BMSC9KNW42VXNyUU02UDFKZlNTRFVhbU9mZ1VtSzcxcVBuQ0lEK3pJUmJH?=
 =?utf-8?B?UzFvanpXWFErRzIyZVlpQ3AvUmdvWnRsNFFoc2V1dTQrcVBOSHFFdmw2bTIz?=
 =?utf-8?B?cGhyYUVkQnpPS1pqTnVXNmdTalQvK0lEQTlzS1dPQXFTcDh4Q2ZHQXVEMk5k?=
 =?utf-8?B?Y2FHS0VmTUtuVTFyaVBpTlcyYzIzSE1hSitDMkU2elVDSFdnUmJBeVRjMUpw?=
 =?utf-8?B?YU5XTVdCRjRFR2pSbVh2T3hoSHNSUmZtclpPZ1hVaHRlS0NjSm9pSnJIQ213?=
 =?utf-8?B?QURFeHhKM0R3aGkydWVvTlBsOWxvamV3T2M0MHB0TDFYaGc0ZExIU0t6bk51?=
 =?utf-8?B?RW5WdWRsYnhVUnJSaE0wQ0RCbE00WXFlU042T1oyVVdYejdXdWRJdjRxbTlG?=
 =?utf-8?B?a3RzN1YwWi8yQ2ZXbUM4V25lMUZkNEtoMGJvZWYycUkrWHJ3dStjQ2RwNGx1?=
 =?utf-8?B?WnVlbUdhcnpReTZ5R01qVW5lUnhMTFk0TWVqYm91bEZONzE1cG14dm00ZldF?=
 =?utf-8?B?dTdiRGtlTzB2QjhjSXNBZHRMYVp4Tm1GaCtPVHloQnVqM3djY0RRY0VJOWJq?=
 =?utf-8?B?dFIvVk5XNi9JMHNleXV6ZWk4SHNBWEJWbkRGWHFxT1JOeWZIVGVFUVgrc3dm?=
 =?utf-8?B?QmV6dGFHQVQ5NzJsWWpzMjZ5MmVreWx0WmNJQ21nVGMwK1laSXluMmZNWjJS?=
 =?utf-8?B?cmF4aDd0YnZDOVhKcXpvTDdMSitBcVVPZHExcTNYOEdNdVlacG50WDVRdGJv?=
 =?utf-8?B?Z0U2TkhaR1VCeEVraytoWkpiVnpNaHExRUJrUFFIODRFb1paSG0yNWt3OGVO?=
 =?utf-8?B?UUYzWVlxckhmUERyV1BNa1MwTmRoMFJLTUFoMjV0Mkd6VjVra1BCMDZpb3Np?=
 =?utf-8?B?YlZUd3lqa3VtdEVDQ1pGOS84dDNMYnUwcStZYTlBQnZYMXpkaVdBZGpnODZ4?=
 =?utf-8?B?Q0dDM2syNjRLTGJtR0JjMmY5M2NXWkZQL3NoNG5GZ0xSWFQ2eHdVOUVlTWlv?=
 =?utf-8?B?WkxzYmN0SVJ3dUVJc0hGOEFLTDZjcjZxZVRuVXlhWUY4RVEyY0xJNXlwR2xs?=
 =?utf-8?B?ZEZ3R0pzREFkNlBZWUFDWHcxWFIyN0lrRFVvYk90NlUzeE9CNTJXU0JOWHB1?=
 =?utf-8?B?cEM1YTZjQmIyUzJJL3g2NTE5NjF1M3VnSVlvMXVqSUwzOFVPN1lFcVdCakNy?=
 =?utf-8?B?UWhRMEw1MmZ0NWxaVHZRQjdnMll5TzJKNmxJRGFEaVlYM1ZjeTZCVlZGazcy?=
 =?utf-8?B?cVpjbXcwdktURTA5MDVEVEdMOHFGODRadkhTaVNMRUEzaksxMzlEMVZuUkwz?=
 =?utf-8?Q?eUryKP11yWlfSfYqXnakuSZoE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E05E63D76E97C74AB1DC6C7D4B151D1C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b4b22f-4ff3-473f-2d5b-08da65a4348c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 14:21:55.6677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xO9ug53FdE//VjfPyFgMQsVZVrsPLI+m8DBcwQSaBJ0LUbADH24Hya4zp/52kK5U6fgIJzIdvuvoO6fTNit3KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4785
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RG9pbmcgYSBmYXN0IHJlYm9vdCAtZiBJIG5vdGljZSB0aGF0IHRoZSBldGhlcm5ldCBJL0ZzIGFy
ZSBOT1Qgc2h1dGRvd24vc3RvcHBlZC4NCklzIHRoaXMgZXhwZWN0ZWQ/IEkgc29ydCBvZiBleHBl
Y3RlZCBrZXJuZWwgdG8gZG8gaWZjb25maWcgZG93biBhdXRvbWF0aWNhbGx5Lg0KDQpJcyB0aGVy
ZSBzb21lIGZ1bmN0aW9uIGluIG5ldGRldiBJIGNhbiBob29rIGludG8gdG8gbWFrZSByZWJvb3Qg
c2h1dGRvd24gbXkgZXRoIEkvRnM/DQoNCiBKb2NrZQ0K

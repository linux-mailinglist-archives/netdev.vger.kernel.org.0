Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681894E416E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiCVOgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbiCVOgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:36:48 -0400
Received: from mx07-005c9601.pphosted.com (mx07-005c9601.pphosted.com [205.220.184.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358AC6A060;
        Tue, 22 Mar 2022 07:35:20 -0700 (PDT)
Received: from pps.filterd (m0237839.ppops.net [127.0.0.1])
        by mx08-005c9601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22M3sJEZ022763;
        Tue, 22 Mar 2022 15:35:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wago.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=p012021;
 bh=5ckuhpaCDoOp0bAtnqahyl8NKOieudz+yH3vHpOxsdI=;
 b=fbn5TW12bLnH73dpTz/VileErYbHSaC7zrudt5RY9rdiuZPyawTN014z0VmhL9EPnKyg
 vV4SJRhRFVuwsLRi8rv1OEb4oMfurTLOmn4l10TDXD3nBNrpEBJocPSCRW57IQGSyKSU
 a+P/n8nsApcm99i3Rl2fodcsz++yLXH2kKCdmp47sDQ7D2lq3Reu7HpcqHdsB8yrrYz9
 1+yKYZk9quVYDBHiyB2PHt/LPbuyMHkhiRzkAuAW40hfCHPrTQBNBZa96dp5HeX+8neZ
 B7Mz21m2ksMfANx2sC3BpLTcaj0BvNVrn700KvK3Hq8YDtmh7lHOLJbrE4DSgEZdK4sa RA== 
Received: from mail.wago.com ([217.237.185.168])
        by mx08-005c9601.pphosted.com (PPS) with ESMTPS id 3ew6yxk304-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Mar 2022 15:35:06 +0100
Received: from SVEX01009.wago.local (10.1.103.227) by SVEX01011.wago.local
 (10.1.103.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 22 Mar
 2022 15:24:52 +0100
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (10.1.103.197) by
 outlook.wago.com (10.1.103.227) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21 via Frontend
 Transport; Tue, 22 Mar 2022 15:24:52 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJ0xUAWXBI6dG6HhdnodDdhBiM82UdG8WeUOiBsActOMTgcsp3FjV3unZwPTtTU3y2MCFcsteuxgOQcr4LWu7QFNVP++RO/S/rPSJ+1Dug1HvcpbdpbBGHBh4dGIFHswpUD/z0JMvRWFrCN64x2gjbs3mGJGznUDB6cKbhG1KnEgulFQvUsiPv5yzPI4q+2malm70TLq7SYHYY70Bd1J6B1harge90b2s+t6xob3IgPMUiMoEU4SCb5MONTrg2lcJJt1caJq0Z/fMBa68ApY0LWlex6MIOdY+uQaZ4QaN4Ab+B1PpdvNzDs7iocLWZcf/rRdcQLygHjgliMiug/a3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ckuhpaCDoOp0bAtnqahyl8NKOieudz+yH3vHpOxsdI=;
 b=VI0ogkN/GsVueewOIIZaa+Gyqr26YqqqGwuCBpOFxPAiguNs2Dg2DAelUVj1h8xvsJB3SU8cN7QP9tPiajBY2+PuPt1WKNK9xqr9YR+WNBxpdBL+l6nlbxpUKpxyAwmqiul5udKU8GqlKFCVZOeex9sCszOkZgB0nzwNm4GTvsLKcfW83kAxTrfUenmqM0UDIJKtp/XlsoyjUP/lHwD+c+qDbDZpF2j4RiEDXhYDYtDfSByGtuGoOfAsAgr9MyKgaJ2hVsP+AI8XMg36BOyRnVKbKKB+RBJGpFDsJbtII0+3zpVFMBPs7/AkZz9s8vzbaLHC9zhL4e/qVd+oGB/r1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wago.com; dmarc=pass action=none header.from=wago.com;
 dkim=pass header.d=wago.com; arc=none
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com (2603:10a6:10:38::15)
 by AM7PR08MB5496.eurprd08.prod.outlook.com (2603:10a6:20b:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 14:24:51 +0000
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb]) by DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb%6]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 14:24:50 +0000
From:   =?utf-8?B?U29uZGhhdcOfLCBKYW4=?= <Jan.Sondhauss@wago.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] drivers: ethernet: cpsw: fix panic when interrupt
 coaleceing is set via ethtool
Thread-Topic: [PATCH] drivers: ethernet: cpsw: fix panic when interrupt
 coaleceing is set via ethtool
Thread-Index: AQHYPbapsZNzoyO3w0eRMBgmDSKdY6zLNV+AgAAdtoCAABZagIAADFEA
Date:   Tue, 22 Mar 2022 14:24:50 +0000
Message-ID: <8b531790-d10e-416a-24a8-66346d8e5a0c@wago.com>
References: <20220322063221.28132-1-jan.sondhauss@wago.com>
 <d3fac0ae-6d5c-33d7-4e1e-da9058ef525f@ti.com>
 <dd897805-38a9-b1e7-b1cf-707aa3de1afb@wago.com>
 <d1fab209-b215-d254-d98b-4ad0ab26b1b0@ti.com>
In-Reply-To: <d1fab209-b215-d254-d98b-4ad0ab26b1b0@ti.com>
Accept-Language: en-DE, en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a8f4ce0-9d7b-41ca-2c34-08da0c0fb9e3
x-ms-traffictypediagnostic: AM7PR08MB5496:EE_
x-microsoft-antispam-prvs: <AM7PR08MB5496B6A6F0C5D2540ABA79938A179@AM7PR08MB5496.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KoZ9QaawKTIgG6D358i1DuVxLl7X0g5PqdvOC7F6V7mlK3PHzPZxmAAKueBbh2n3xc3HATfiLNrASsROAcMMg1cIH7O/tpYeshT2Gp9mcwK8kHdyEyvnQOBoFphyY5huR6UYUs9kuQMYnX0E37IZ6ZqeyvhjV+WfJkhYJ3//OrfuOx9epaU9nMvt8BGgqE2kiueYpgo3rbgvi7G7l9VGihDIaxVWdXQ8joydv5RH7Iix2Zkya2zz5hw7Vaa76k7rAecUrq9ogeGGuVqDCuVSONGDk50AmM9gDm7ofSkbcSwFSL5eEsQYTbyvhuWrD6a0mXTpzLI0sD8CcugbT39GIb4eDK5CWw/1E2PphbndMVAfRzsjvdOmlZrZZomWfzHy+nWmY05O8eMpMRR++mss090OarVjzvKnfSWeIkbS9vg5lEyxYB0gUMNAb9GAtfBHc/qvYt+dBgaqhI0qrI/YYl+7oIhNHPEFHB93DXSni4fg4ldc19o8MFlC+4+soUh2/EArW1v6LUbLseJk2Nf5vjawx55zNhsYSrihQyVhigMwE+e9tjSig6NCGO6J6gAzC2Cmj4zxcuM1+5uJNjwnNnhSZWZk/hv418GPdrfLBXQQgwufkrnxMDJTnKE1fDgVmHl71Le3424uvZIBThjDV4lci+n/68qQwY4e2pVgY7pmCyFOmFo+foScqrX0AWbFYBudw+N8YH2AsfcjLw6oLS69KFim3sjTQQy7GsJ8wKD15nYBwyvcb98J9rMAG/Ip
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5097.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(38100700002)(5660300002)(36756003)(4326008)(76116006)(54906003)(110136005)(66556008)(66946007)(66446008)(66476007)(64756008)(91956017)(8676002)(8936002)(2906002)(122000001)(85182001)(31686004)(31696002)(71200400001)(6486002)(38070700005)(186003)(6512007)(6506007)(53546011)(83380400001)(508600001)(86362001)(26005)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmMyR3JQWHQrSkdEOEdmZ0tmK0ZXZUNMS1plWE96NlA0cUlmSVhQNW5mRG9G?=
 =?utf-8?B?YndRejhYZkZBV0Yya0pNeG1EWTRTZGZnYVl4dlNralF1MjZwSHdJS20yTCtl?=
 =?utf-8?B?SHJZRlBaK2M0OHB3VU1FZnBvNG1HZnVlSVZ3WHppbW9rVWVOdGo5dDVPSU9w?=
 =?utf-8?B?T1VlODgzLzJiVGVMdE1RU0dHRks4MFhLaGNGb0dZSWU0R0kwTXFUZ0NMMFRR?=
 =?utf-8?B?OTVCUEF3TVRhN3lTb3RCU1RZQjk0NUZsY0lNbEl4WFZQa1pXZmttMlRqTE5L?=
 =?utf-8?B?VFREbEJNdkNKUC9qSXVYN3RncXBlMkJCdVFtN2dTNGt4dHZUSFlGMWluZHI4?=
 =?utf-8?B?YVBmMW1WL0tjMUgrb3Z2WU5keWxtUGFhRE90N1Y2N3huTnI5R3B6UnFCcVZD?=
 =?utf-8?B?S3dZM1NOK0g2NnpuVWxtay9nOEJ5TjBJOVJIbU1mb0NvTFNCSHUzOW51VDc1?=
 =?utf-8?B?LzlCODdRZTdjenp3bkpURi83WmNSK3BWNTBXSHFLZTRoR2E1UFFSM3BkanVu?=
 =?utf-8?B?WEtrcTY0OVV3bjl4K05sNFBaQ2w0QkZFU0psc3pFeFFNRGl0NjBYc2orNC95?=
 =?utf-8?B?WjQ0K1Vsa0xuWTgrQ2J0Zm5lZlFrNndXQ3N1R1JmeUJLRGRGMyt5dlJzTEI4?=
 =?utf-8?B?Wm9Ic09wZFhkd00xZ0o0VC85TXpRNTh2QmkzSTV0VGNNRzVnQjluUHFCYmJD?=
 =?utf-8?B?Y0JIZFhOcm5haEhXQjZGVGl0YkJGV0h3NFhHdDlCczNoUlhabnRCbnNLZTRB?=
 =?utf-8?B?Z3FibU82OGRrdGhnY1FIUWI5WGZsYjJzU1JMNVFPVzRoa1cwUG1lRHVMQ2Fz?=
 =?utf-8?B?RG5paUgyWjRmd2VBRkIvdGoxT1NzYVE4d2o5Z2dLdGRWYjBLMTNtZWpTRk04?=
 =?utf-8?B?STRzSitZN01CTEdjRjdXSGh2bG93MThneDhzeEVkcjcyckpJbU5kNXdVYm1l?=
 =?utf-8?B?MnA5a0paeWRlZStMRnowSW04ZkZ2aWZ5UXBOWWpkTmhGQXY3VU96WlFLcEtx?=
 =?utf-8?B?SFpDV0FzWldYQ0o5Vm9zK2hDVEhrK2ExZGViQXRCb25mZUhPMGJUY1hhaDRM?=
 =?utf-8?B?eFpuazc1ZDZjSGpoUkpYWjk0eGpMTFFDT08zVTNMZlkvNzNiQ09TRUY5ZUpL?=
 =?utf-8?B?V0JoLzVtSERTa1k2Rk9IVHh6UjVWNGwvUXBiQTZYNURVUWI0V1BMRG12dFZl?=
 =?utf-8?B?ZVFIOVNvR2d5MnovYk1uS0MwLzBneXhpNVpPTk5mNGhZZWdCSWYvODFpdDhp?=
 =?utf-8?B?bjFrcWloV1dCb2lUTThOU0hYZnVXa1pqTFU2TEdJdkhTdGJxZVY5eHIveDJt?=
 =?utf-8?B?R3RKVG42bncrOFZjN2swZC8wN2hvZy93NEdrN2ZEZVF6VGIvNmVueXdDc0JE?=
 =?utf-8?B?VGc4TmJma05LUDBQVUkxeHRLOS9XSjcyVFFBNCtYYTJjeTlrYmFrTWIzNmxv?=
 =?utf-8?B?UmFzd1pDZHljUWFkUUt2TEtwYXViSENRM3A1cW9VNGFvaDNhQTY5UVFGOFQx?=
 =?utf-8?B?cStYeGNYMytOdlpZLzh6R3NlNXdsTVQxVCtjc1FsQzIxbFAvS2x3ODZsckI3?=
 =?utf-8?B?bkVyUkdvek1xQWYwY2llRHV2dkRBUVhjT3hEV0I4cUJlTURnQ2lrUEFYSE5U?=
 =?utf-8?B?S1B4MTNoNGFhWkxFSTVRM1A3ckRLQU9aaElIL3Y4VXNiRGFWcks4Ym5DeWNm?=
 =?utf-8?B?Mm4zMllVRi92aGtYNzgycGhYNGQxVXd6RWVuRktWcURORlFNVFlGZTNYTHF4?=
 =?utf-8?B?amhqa1M3T1c0d29aQ1hsN05GUTJMSGtXS3pJazkzZ3FVTGFWVzlodEJRZnA2?=
 =?utf-8?B?TUVhUnZ4R1R5dlQ3T2RUa29xWkxpbXAxdWdKdUhuQ1ppYnpua1FvZ0tXRVIy?=
 =?utf-8?B?L0dXYUxncldoV3pFTFRSM25vOXcwVmFLR2ZIL0JhMnhxbXJ1dCtWeVpFS3Z1?=
 =?utf-8?B?cHdUQVhIWDQzc2g3WlJqcWhlTG1hdUNXcmsvVW1USThVOGF3Ymt6MEQ3WE9p?=
 =?utf-8?B?UzRKVlpkRG5RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AC87C62E004CE4A81CD60C5B03AE469@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5097.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8f4ce0-9d7b-41ca-2c34-08da0c0fb9e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 14:24:50.8437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e211c965-dd84-4c9f-bc3f-4215552a0857
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3oMN73PSVv+8r6XPRsU2PZuac0zTAKkSpeVWAHTxIJbZJrrYQaO/s+CVJAqDL/8ctl7qmkzIgpfnP4arHp+NIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5496
X-OriginatorOrg: wago.com
X-KSE-ServerInfo: SVEX01011.wago.local, 9
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 22.03.2022 10:04:00
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Proofpoint-GUID: 4hl0zxNqzkhL5own5D--MVRWeaE2dNwv
X-Proofpoint-ORIG-GUID: 4hl0zxNqzkhL5own5D--MVRWeaE2dNwv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_06,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=983 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220084
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIyLzAzLzIwMjIgMTQ6NDAsIFZpZ25lc2ggUmFnaGF2ZW5kcmEgd3JvdGU6DQo+IE9u
IDIyLzAzLzIyIDU6NTAgcG0sIFNvbmRoYXXDnywgSmFuIHdyb3RlOiA+IEhpID4gPiBPbiAyMi8w
My8yMDIyIDExOjM0LCANCj4gVmlnbmVzaCBSYWdoYXZlbmRyYSB3cm90ZTogPj4gSGksIEFkZGlu
ZyBuZXRkZXYgbGlzdCBhbmQgbWFpbnRhaW5lcnMgDQo+IFBsZWFzZSBjYyBuZXRkZXYgTUwgYW5k
IG5ldCA+PiBtYWludGFpbmVycyAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwgDQo+IC1mID4+
IFpqUWNtUVJZRnBmcHRCYW5uZXJTdGFydA0KPiBUaGlzIE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRl
cm5hbCBTZW5kZXINCj4gUGxlYXNlIHVzZSBjYXV0aW9uIHdoZW4gY2xpY2tpbmcgb24gbGlua3Mg
b3Igb3BlbmluZyBhdHRhY2htZW50cyENCj4gWmpRY21RUllGcGZwdEJhbm5lckVuZA0KPiANCj4g
T24gMjIvMDMvMjIgNTo1MCBwbSwgU29uZGhhdcOfLCBKYW4gd3JvdGU6DQo+PiBIaQ0KPj4gDQo+
PiBPbiAyMi8wMy8yMDIyIDExOjM0LCBWaWduZXNoIFJhZ2hhdmVuZHJhIHdyb3RlOg0KPj4+IEhp
LCBBZGRpbmcgbmV0ZGV2IGxpc3QgYW5kIG1haW50YWluZXJzIFBsZWFzZSBjYyBuZXRkZXYgTUwg
YW5kIG5ldCANCj4+PiBtYWludGFpbmVycyAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwgLWYg
DQo+Pj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMgT24gMjIvMDMvMjIg
MTI6MDIgcG0sIFNvbmRoYXXDnywgDQo+Pj4gSmFuIHdyb3RlOiA+IGNwc3dfZXRodG9vbCB1c2Vz
IHRoZSBwb3dlciBtYW5hZ2VtZW50IGluIHRoZSANCj4+PiBaalFjbVFSWUZwZnB0QmFubmVyU3Rh
cnQNCj4+PiBUaGlzIE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRlcm5hbCBTZW5kZXINCj4+PiBQbGVh
c2UgdXNlIGNhdXRpb24gd2hlbiBjbGlja2luZyBvbiBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1l
bnRzIQ0KPj4+IFpqUWNtUVJZRnBmcHRCYW5uZXJFbmQNCj4+Pg0KPj4+IEhpLA0KPj4+DQo+Pj4g
QWRkaW5nIG5ldGRldiBsaXN0IGFuZCBtYWludGFpbmVycw0KPj4+DQo+Pj4gUGxlYXNlIGNjIG5l
dGRldiBNTCBhbmQgbmV0IG1haW50YWluZXJzDQo+Pj4NCj4+PiAuL3NjcmlwdHMvZ2V0X21haW50
YWluZXIucGwgLWYgZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMNCj4+Pg0K
Pj4+IE9uIDIyLzAzLzIyIDEyOjAyIHBtLCBTb25kaGF1w58sIEphbiB3cm90ZToNCj4+Pj4gY3Bz
d19ldGh0b29sIHVzZXMgdGhlIHBvd2VyIG1hbmFnZW1lbnQgaW4gdGhlIGJlZ2luIGFuZCBjb21w
bGV0ZQ0KPj4+PiBmdW5jdGlvbnMgb2YgdGhlIGV0aHRvb2xfb3BzLiBUaGUgcmVzdWx0IG9mIHBt
X3J1bnRpbWVfZ2V0X3N5bmMgd2FzDQo+Pj4+IHJldHVybmVkIHVuY29uZGl0aW9uYWxseSwgd2hp
Y2ggcmVzdWx0cyBpbiBwcm9ibGVtcyBzaW5jZSB0aGUgZXRodG9vbC0NCj4+Pj4gaW50ZXJmYWNl
IHJlbGllcyBvbiAwIGZvciBzdWNjZXNzIGFuZCBuZWdhdGl2IHZhbHVlcyBmb3IgZXJyb3JzLg0K
Pj4+PiBkNDNjNjViMDViODQgKGV0aHRvb2w6IHJ1bnRpbWUtcmVzdW1lIG5ldGRldiBwYXJlbnQg
aW4gZXRobmxfb3BzX2JlZ2luKQ0KPj4+PiBpbnRyb2R1Y2VkIHBvd2VyIG1hbmFnZW1lbnQgdG8g
dGhlIG5ldGxpbmsgaW1wbGVtZW50YXRpb24gZm9yIHRoZQ0KPj4+PiBldGh0b29sIGludGVyZmFj
ZSBhbmQgZG9lcyBub3QgZXhwbGljaXRseSBjaGVjayBmb3IgbmVnYXRpdmUgcmV0dXJuDQo+Pj4+
IHZhbHVlcy4NCj4+Pj4NCj4+Pj4gQXMgYSByZXN1bHQgdGhlIHBtX3J1bnRpbWVfc3VzcGVuZCBm
dW5jdGlvbiBpcyBjYWxsZWQgb25lLXRvby1tYW55DQo+Pj4+IHRpbWVzIGluIGV0aG5sX29wc19i
ZWdpbiBhbmQgdGhhdCBsZWFkcyB0byBhbiBhY2Nlc3MgdmlvbGF0aW9uIHdoZW4NCj4+Pj4gdGhl
IGNwc3cgaGFyZHdhcmUgaXMgYWNjZXNzZWQgYWZ0ZXIgdXNpbmcNCj4+Pj4gJ2V0aHRvb2wgLUMg
ZXRoLW9mLWNwc3cgcngtdXNlY3MgMTIzNCcuIFRvIGZpeCB0aGlzIHRoZSBjYWxsIHRvDQo+Pj4+
IHBtX3J1bnRpbWVfZ2V0X3N5bmMgaW4gY3Bzd19ldGh0b29sX29wX2JlZ2luIGlzIHJlcGxhY2Vk
IHdpdGggYSBjYWxsDQo+Pj4+IHRvIHBtX3J1bnRpbWVfcmVzdW1lX2FuZF9nZXQgYXMgaXQgcHJv
dmlkZXMgYSByZXR1cm5hYmxlIGVycm9yLWNvZGUuDQo+Pj4+DQo+Pj4NCj4+PiBwbV9ydW50aW1l
X3Jlc3VtZV9hbmRfZ2V0KCkgaXMganVzdCB3cmFwcGVyIGFyb3VuZCBwbV9ydW50aW1lX2dldF9z
eW5jKCkNCj4+PiArIGVycm9yIGhhbmRsaW5nIChhcyBkb25lIGluIHRoZSBiZWxvdyBjb2RlKSBh
bmQgYm90aCByZXR1cm4gMCBvbg0KPj4+IHN1Y2Nlc3MgYW5kIC12ZSBlcnJvciBjb2RlIG9uIGZh
aWx1cmUNCj4+IA0KPj4gcG1fcnVudGltZV9nZXRfc3luYyByZXR1cm5zIC12ZSBlcnJvciBjb2Rl
IG9uIGZhaWx1cmUgYW5kIDAgb24gc3VjY2VzcyANCj4+IGFuZCBhbHNvIDEgaXMgcmV0dXJuZWQg
aWYgbm90aGluZyBoYXMgdG8gYmUgZG9uZSBiZXNpZGVzIGluY3JlbWVudCBvZiANCj4+IHRoZSB1
c2FnZSBjb3VudGVyLg0KPj4gU28gZm9yIGFjdGl2ZSBkZXZpY2VzIHRoYXQgZG9uJ3QgbmVlZCB0
byBiZSByZXN1bWVkIGEgMSBpcyByZXR1cm5lZC4NCj4+IHBtX3J1bnRpbWVfcmVzdW1lX2FuZF9n
ZXQgaXMgYSByZXR1cm4tZnJpZW5kbHkgd3JhcHBlciB0aGF0IHJldHVybnMgDQo+PiAtZXJyb3Ig
Y29kZSBvbiBmYWlsdXJlIGJ1dCByZXR1cm5zIDAgb24gYm90aCBvdGhlciBjYXNlcy4NCj4+IA0K
PiANCj4gSSB0aGluayB0aGlzIGlzIGEgYmV0dGVyIGV4cGxhbmF0aW9uIHRoYW4gdGhlIG9yaWdp
bmFsIGNvbW1pdCBtZXNzYWdlLA0KPiBidXQgc2VlIGJlbG93DQo+IA0KPj4+DQo+Pj4NCj4+Pj4g
U2lnbmVkLW9mZi1ieTogSmFuIFNvbmRoYXVzcyA8amFuLnNvbmRoYXVzc0B3YWdvLmNvbT4NCj4+
Pj4gLS0tDQo+Pj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC90aS9jcHN3X2V0aHRvb2wuYyB8IDIg
Ky0NCj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
Pj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzd19ldGh0
b29sLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC90aS9jcHN3X2V0aHRvb2wuYw0KPj4+PiBpbmRl
eCAxNThjOGQzNzkzZjQuLjVlZGEyMDAzOWNjMSAxMDA2NDQNCj4+Pj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMNCj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMNCj4+Pj4gQEAgLTM2NCw3ICszNjQsNyBAQCBpbnQgY3Bz
d19ldGh0b29sX29wX2JlZ2luKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPj4+PiAgCXN0cnVj
dCBjcHN3X2NvbW1vbiAqY3BzdyA9IHByaXYtPmNwc3c7DQo+Pj4+ICAJaW50IHJldDsNCj4+Pj4g
IA0KPj4+PiAtCXJldCA9IHBtX3J1bnRpbWVfZ2V0X3N5bmMoY3Bzdy0+ZGV2KTsNCj4+Pj4gKwly
ZXQgPSBwbV9ydW50aW1lX3Jlc3VtZV9hbmRfZ2V0KGNwc3ctPmRldik+ICAJaWYgKHJldCA8IDAp
IHsNCj4+Pj4gIAkJY3Bzd19lcnIocHJpdiwgZHJ2LCAiZXRodG9vbCBiZWdpbiBmYWlsZWQgJWRc
biIsIHJldCk7DQo+Pj4+ICAJCXBtX3J1bnRpbWVfcHV0X25vaWRsZShjcHN3LT5kZXYpOw0KPj4+
DQo+Pj4NCj4+PiBJbiBmYWN0IGNvZGUgbm93IGVuZHMgdXAgY2FsbGluZyBwbV9ydW50aW1lX3B1
dF9ub2lkbGUoKSB0d2ljZSBpbiBjYXNlDQo+Pj4gb2YgZmFpbHVyZSwgb25jZSBpbnNpZGUgcG1f
cnVudGltZV9yZXN1bWVfYW5kX2dldCgpIGFuZCBhZ2FpbiBoZXJlPw0KPj4+DQo+Pj4gU28gc29t
ZXRoaW5nIGxvb2tzIGZpc2h5Pw0KPj4gDQo+PiBTb3J0IG9mLiBUaGVyZSBpcyBubyBhY3R1YWwg
ZmFpbHVyZSBidXQgcG1fcnVudGltZV9wdXQgaXMgc3RpbGwgY2FsbGVkIA0KPj4gdHdpY2UuIFRo
YXQgaXMgZHVlIHRvDQo+PiAJMS4gY3Bzd19ldGh0b29sX29wX2JlZ2luIHJldHVybmluZyAxIHdo
ZW4gaXQgc2hvdWxkIHJldHVybiAwDQo+PiAJMi4gZXRobmxfb3BzX2JlZ2luIHRyZWF0aW5nIHZh
bHVlcyBub3QgZXF1YWwgdG8gMCBhcyBmYWlsdXJlDQo+PiAJMy4gY29hbGVzY2VfcHJlcGFyZV9k
YXRhIG9ubHkgdHJlYXRpbmcgbmVnYXRpdmUgdmFsdWVzIGFzIGZhaWx1cmUNCj4+IA0KPj4gVGhl
IHBhdGNoIGFkZHJlc3NlcyAxLg0KPj4gDQo+PiBJbiBuZXQvZXRodG9vbC9uZXRsaW5rLmM6MzMg
ZXRobmxfb3BzX2JlZ2luKCkgdGhlIGNwc3dfZXRodG9vbF9vcF9iZWdpbiANCj4+IGlzIGNhbGxl
ZCAocmV0dXJuaW5nIDEpIGFuZCBpbiB0aGUgZXJyb3IgcGF0aCBvZiBldGhubF9vcHNfYmVnaW4g
YSANCj4+IHBtX3J1bnRpbWVfcHV0IGlzIGNhbGxlZC4gVGhlIGZ1bmN0aW9uIGNhbGxpbmcgZXRo
bmxfb3BzX2JlZ2luIG9ubHkgDQo+PiBjaGVja3MgZm9yIG5lZ2F0aXZlIHZhbHVlczogbmV0L2V0
aHRvb2wvY29hbGVzY2UuYzo2MCANCj4+IGNvYWxlc2NlX3ByZXBhcmVfZGF0YSBhbmQgY29udGlu
dWVzIHRoZSBzdWNlc3MgcGF0aCBjYWxsaW5nIA0KPj4gZXRobmxfb3BzX2NvbXBsZXRlLiBldGhu
bF9vcHNfY29tcGxldGUgYWxzbyBjYWxscyBwbV9ydW50aW1lX3B1dC4gU28gdGhlIA0KPj4gc3Vj
Y2VzcyBwYXRoIG9mIGNvYWxlc2NlX3ByZXBhcmVfZGF0YSBhbmQgdGhlIGVycm9yIHBhdGggb2Yg
DQo+PiBldGhubF9vcHNfYmVnaW4gYm90aCBlbmQgdXAgY2FsbGluZyBwbV9ydW50aW1lX3B1dCB3
aGVuIG9ubHkgb25lIG9mIHRoZW0gDQo+PiBzaG91bGQuDQo+PiANCj4gDQo+IFRoYW5rcyBmb3Ig
dGhlIGV4cGxhbmF0aW9uIQ0KPiANCj4gU29ycnksIEJ1dCB3aGF0IGFib3V0IHRoZSBlcnJvciBj
YXNlIChpZSByZXQgPCAwKSBXaXRoIHRoaXMgcGF0Y2gsIGRvbid0DQo+IHdlIGVuZCB1cCBjYWxs
aW5nIHBtX3J1bnRpbWVfcHV0X25vaWRsZSgpIHR3aWNlIChvbmNlIGluc2lkZQ0KPiBwbV9ydW50
aW1lX3Jlc3VtZV9hbmRfZ2V0KCkgYW5kIGFnYWluIGluIGNwc3dfZXRodG9vbF9vcF9iZWdpbigp
KS4gSG93DQo+IGlzIHRoYXQgb2theT8NCg0KT2YgY291cnNlIGl0cyBub3Qgb2theS4gVGhhbmtz
LCB0b3RhbGx5IG1pc3NlZCB0aGF0IGNhc2UuLiBJIHdpbGwgYmUgDQpwcmVwYXJpbmcgYSBWMiB3
aGVyZSB0aGUgYWRkaXRpb25hbCBjYWxsIHRvIHBtX3J1bnRpbWVfcHV0X25vaWRsZSBpcyANCm9t
aXR0ZWQgaW4gY3Bzd19ldGh0b29sLiBBbHNvIEkgd2lsbCByZXdvcmsgdGhlIGNvbW1pdCBtZXNz
YWdlIGFzIHlvdSANCnN1Z2dlc3RlZC4NCg0KVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrIHNvIGZh
ciENCg0KLSBKYW4NCg0KPiANCj4gDQo+IFJlZ2FyZHMNCj4gVmlnbmVzaA0KPiA=

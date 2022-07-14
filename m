Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2183857405E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 02:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiGNAMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 20:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiGNAMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 20:12:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769DE6582;
        Wed, 13 Jul 2022 17:11:57 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DICiYi017630;
        Wed, 13 Jul 2022 17:11:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v5UNIvnA0bXP9kFSiDTNE8urwV4xU7O+B0721hOEqWQ=;
 b=hzrrkRxp7SCoMd2G91AVLy8rQkHY6hWJeHyJqaCLoQmTq+kXbtAOaCpnkLybsDX9m8Gc
 qFo52irxFbnn94bOeFMJFHS0FLlSfWvoY9v7nO1Z62POABA/km5SKtNFLftqejJbZrWe
 cqqd3kULGdJx9QrLmsIgoqVXV9K1X9z/xRc= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5hqvc6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 17:11:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5Hc0lnjAePS9OTwYKI1/b5FLwyx4o7+cQHtRxrO7ofo1IA9/bC8nBr/XDWb/wC5jWjd7Yf05ouBJS9ObCK27l+ufQa1/mf2mhATXo3P5uXawXbT7nd3W9b0iTbSPeDvpgh4J/nVN3RL4wGH3K4lNCX13Kvj3e0uThSmOgTV/hq5HlqqbDPbOB98+29jcz4ed4CAQidJmtYfK3lLKx9UAHnmniI//XupQkjvfBIqwKmfmAlrdzDXxbuZ3lCyFDRAKfbJRsMIuyH6Mggxn1f5sF86O86AKGYoNzrRHur92/ZnTvTbd/1ndOQ3kfDUOHOeMJMTFDy2msdh8MAeEPHXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5UNIvnA0bXP9kFSiDTNE8urwV4xU7O+B0721hOEqWQ=;
 b=eyCWyqK+aPhXtrZudbvsHU3ufsm37wtCOEg9QrzqLKrlZFO39Kra5yXdBSOsmOU/EDTLLWW4E/KnIk+ZaTQcQqWrfJNiAJq2MaJfIwjHAT20V3nfSfq38tqNzJmAR/putCS2GSAFsTpEufzQ3FD2bwjYS+ywnCIhjwQcC8hIoX5VnUVkU01smeAai30sPY9dfsyDfNs/Wo4eszhThle8VNBHm43iZYmCGGPK+QCmAQTm+f8NykTnesyPAIL9afeWOn1C72Qy2RtIpMywfjsbCkIzVr4dn6jkbNHkL8IK3VFMPLGig2TmrGOd+U5XL44wakrM0EMtRngbaggwHi/jGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MWHPR15MB1279.namprd15.prod.outlook.com (2603:10b6:320:27::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 00:11:54 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 00:11:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Thread-Topic: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Thread-Index: AQHYdriN/yOd0MaY7kCCLNeAHt/+qa19MFsAgAAO2fE=
Date:   Thu, 14 Jul 2022 00:11:53 +0000
Message-ID: <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-2-song@kernel.org>
 <20220713191846.18b05b43@gandalf.local.home>
In-Reply-To: <20220713191846.18b05b43@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e007781-cb47-4ef3-af8d-08da652d7527
x-ms-traffictypediagnostic: MWHPR15MB1279:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frIFmG4kWm6WYoMDkEhZx2lLWwr73uAt11UuiTppKZB02b0Kd8xU9s7vEcEQNKNKOFvQJAS0VMq3+gwEMeOO5cr1UhNbtSmzj5ybg/cQey9tpLhRk35b17rxGUPVMLw9G4hOpbaxSi0is6dmKRMfwfe6NsMm3kzOyY9AK47p4tAwDEAlHGesIAZPfPJ9xZ/81o3+B2TAN6x0jPNiEU807OR6aDPwhf4mmP9VSWhIA4uPPngfdLhY2HaPNIOHh0gA0cuXGGqoZIyqXhLBuJaSg2b8neFCcBwGaeZXDxb07asrciHB0c6sZuE3ZqwaEvUt8DcTdfjpRuPEWv2TsEfXpNm1q6IQBOMQlUVPl9znnC0x38kWrMewUehG6vvBni48RdVrklDIX3SWbOMOwAPch9b7wNXYtpWxPcAdXifANj+2VquOQQmIhnZJHlD96WoNmyA6ipV3OarVFtdliDtBxt+VY/92Ve6wSBZPmZdUGKpWcvTAjACV3t8YOu3iylzvuj0q2uCT4dRF+koqAP80q82zi4tAfGswnx2q+S5w765QCqk8c7uI76U4OIujZOCW1FspGhGsqNnHSAxEHjCgLoqye8vvK3JmTxx+VKqOS/QapVBcpXw38jlt2X79bfOIqHkAPmwODKSFc+1lCNbpvjH6/sO5uVHU3YuQdf/PZ8LCAgB2L3htJHjD67mVcskFZqDkTVRJkbFr/8Lp3WGkK2BCLM+a4k1kufUOA8oHA0uPNJSmAlXAZSYlGz+lypvBvM+5zGeJ9dJrfuANZZXzTsSMRh9m9DnslNEyPydXndLTtF5C6v7cbXVuUjXVCsBF9iaTOgQD2UskF9EEAXoeV+uu6e3JsDPUMfN8o1m5sZk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(64756008)(53546011)(6506007)(66946007)(6916009)(66476007)(6512007)(86362001)(41300700001)(76116006)(66446008)(5660300002)(66556008)(6486002)(478600001)(54906003)(91956017)(316002)(71200400001)(122000001)(38100700002)(36756003)(38070700005)(83380400001)(2616005)(8676002)(8936002)(33656002)(2906002)(186003)(7416002)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEJqN1drSFY2b1NXT3lRbjNtR3hWYlpmay9Jby9Wa0NGWG90dVFBU1RZd05M?=
 =?utf-8?B?NWJNMVNlYjQ0QTJPQllaYWJMcmtnK3o5dnJ3T2JaMWlhSmFVa1paZlBmNU9w?=
 =?utf-8?B?SzZPNU03UUFrNi9RUSs1NWJBQXE2dS9PRFFGb3k2Y2ZKbDU4eVh0b0s3WmxZ?=
 =?utf-8?B?NjFOVG1ydkJjb1QwYWV5UmJzdWJKL2xXVmJjbnFGM09PVmo0bnh4MHo2V0Vr?=
 =?utf-8?B?WmdnMUZldGVnZkdJaVNyQnlaSWFHNUdlMVVKL0xhcjk5YVF0QnhXbzhQTnU0?=
 =?utf-8?B?S0VZcExRTEc4K3dVc0NmM29iakE3YUhRTVlXV3g5NXJyd2I0QW45TDRBbG1H?=
 =?utf-8?B?U2I2ZFhMeWxhNk8yTzN2MEVDMFg5dVZGby9DQ2p1NGEySWdyZllxTDB0RGNm?=
 =?utf-8?B?VzB5MGtFTElWVlozd08zRFZORnpZQWVsVkFWSU4zZDNlSGN1Vkp5RHBWTlh4?=
 =?utf-8?B?M1JXSVMyb0JNTDdFRkZlSSsvbVlIaWhZR2VGcGd5Zkk1VitPdFA1bVJ1bWxN?=
 =?utf-8?B?RzhRVHZJQWw1d25lV0pRMnhENWt0dldmeVZDWXRvdFFMSEZta3BTV1VZRE5r?=
 =?utf-8?B?cDk3aG9GRnFLSVZ6ZjM0dDJ2UVp4QmNXYVhVU1dySHJ1bGNaQ1hoT3ZISXBD?=
 =?utf-8?B?VThhYUFCSmxSRm1pLzdPVzY1eDRwZi8zME5Rc2Ryb2RvaVVseUdXLzArWDk1?=
 =?utf-8?B?OElxRXNnUVpKendJZk9SaUNCcHA4em5WNkJGSkFLV05veFlRYVk4MmpjNFN0?=
 =?utf-8?B?ZTg1ZzNubGsrdXNhRjVVUEcveDF5R0t1VVVMYnFEY2h5Ny9YemJ4a0c0a3ZZ?=
 =?utf-8?B?VXVHMEVsNUJKMUJDbjJjNWd1cmppYkZTaEhldzM5NmFGUHM0Tk94dWRadmZy?=
 =?utf-8?B?SkRQQnlieXBiVVc1eUtqRENjUlNYc2JtWDI4N3oxY2RJRGlONEQ0bVFvSmJa?=
 =?utf-8?B?eUpEYjJVMHJSU3cyYnIyNWxHbStiVnFJUnRibjFEYzdsbTFsRnVNV2pPRmlX?=
 =?utf-8?B?cE1UaVlHOEZ0UmlqNzFndU5SSUVlcW1SN1oybGNKV2hQNGg0SWpxOC9BckhS?=
 =?utf-8?B?TUlQZ0EyUHJJemhBQ0pHaWdYNkVnZHBTWGhPNHV4cGd5R0R0SWVBRmVaN1h6?=
 =?utf-8?B?RGorUHNwZEhTejNzOWtQeUNZS3pNV25sM3VwRHFidFJHRDhyM1hzS25SSHdh?=
 =?utf-8?B?dVBpWWZPclNLckJEbkJobWJLT3h3eW9hbGI2SWZOSzNscFVyVEdSSkx0NzlS?=
 =?utf-8?B?Qm44cjJCREo0MzVYazkvamhXM2RzenE3aFRXbU0ySDZFTlJrbVBRQVk1b29r?=
 =?utf-8?B?c0lCVmZJK1JjN2tRTTU2a3BXNmE3VmtDRmtZaC9aT0VuTThid2RKMDBmSU9W?=
 =?utf-8?B?bVZ5N2d2Mi8vWU1MTHRiRi9vSVg4aExCakpENTVURG13ci9GVDI4QUJmVjlP?=
 =?utf-8?B?VW1DeHljeXhPcVBDaVJSNWNWdklVVDZJVEl5ZzlyZXNNMFpJWHl6R0QvbEl4?=
 =?utf-8?B?U1hLRFd1TU15L0ZwMmlUc3d3alltOHN2YWxxRFlCR2V5dk50V2NNREhzNXpC?=
 =?utf-8?B?aUhKczEwK2VjS2d1bmlkTkFpcVJrU29mc1dTU2ZNNE1UQmtydXlRUjJ0WFhY?=
 =?utf-8?B?TDI5SVNLVDBzSWJqV1RIcWQ5SWpWa0RyOG1wV3RWc2J2WjFDY1QvWTJuWFRV?=
 =?utf-8?B?K1JEZTFtVkdoRnpMMHBWZDZsQUhjejhhYmJhVEIrclUzdE5nWk1MUGkyZTkz?=
 =?utf-8?B?TFB0WVZoQStnUjA0TzVaWHVSWUJBdmFOaXZzSTA3eE5rMkpQMVU0ZlVLbUEx?=
 =?utf-8?B?MUFFMDF4NzhJZDNydEx6bFp5QlNFdXlwVXArbkFOSmNWY0thNjBuV2ErUXI4?=
 =?utf-8?B?UURldkxpUFM2V2lsN1ZpaWtZV0REWlpXaVBnTG43WVY1UHpFb3IvRE01NDdw?=
 =?utf-8?B?U2drdzJNUlhEY3VYSU9JZUNoTUtwaFhhWDc0Y2hoMDNrRi9zeWFFNkdubWds?=
 =?utf-8?B?dWVOZE1JUkdnNXBLc0FIU245bC9BY2poOXltZ2NvODhydERNUjY2MHlJRk0w?=
 =?utf-8?B?Mk5TdTRsWWJ5eTFYQjRWZ24xRFI3NXRITDdncWlFYW03ZjNqSThEaHBrQWFJ?=
 =?utf-8?B?QWIwWmkrc3lmdW41WkVSYjNDdzF5OVdKdTNCaXl6d3Z4dlkrcldYMCtNelMw?=
 =?utf-8?Q?m6lU1l3CbAi8wDK9yIhij+jLNDGcCsw2iQtWSRa5kR4u?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e007781-cb47-4ef3-af8d-08da652d7527
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 00:11:53.9346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tIgAMV26LePiBjJInNdzkUvkABZeFXjbxOsQNBdaQ37TdQzAPYK+ML/lzIjMP5OyVVNeVNkQEnMWigfYKS2KJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1279
X-Proofpoint-ORIG-GUID: qg0o5K149KWhqFX4l73s2dqpwWSrYEtd
X-Proofpoint-GUID: qg0o5K149KWhqFX4l73s2dqpwWSrYEtd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_13,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVsIDEzLCAyMDIyLCBhdCA0OjE4IFBNLCBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVk
dEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+IA0KPiDvu79PbiBUaHUsIDIgSnVuIDIwMjIgMTI6Mzc6
MDIgLTA3MDANCj4gU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPj4gVGhp
cyBlbmFibGVzIHVzZXJzIG9mIGZ0cmFjZV9kaXJlY3RfbXVsdGkgdG8gc3BlY2lmeSB0aGUgZmxh
Z3MgYmFzZWQgb24NCj4+IHRoZSBhY3R1YWwgdXNlIGNhc2UuIEZvciBleGFtcGxlLCBzb21lIHVz
ZXJzIG1heSBub3Qgc2V0IGZsYWcgSVBNT0RJRlkuDQo+IA0KPiBJZiB3ZSBhcHBseSB0aGlzIHBh
dGNoIHdpdGhvdXQgYW55IG9mIHRoZSBvdGhlcnMsIHRoZW4gd2UgYXJlIHJlbHlpbmcgb24NCj4g
dGhlIGNhbGxlciB0byBnZXQgaXQgcmlnaHQ/DQo+IA0KPiBUaGF0IGlzLCBjYW4gd2UgcmVnaXN0
ZXIgYSBkaXJlY3QgZnVuY3Rpb24gd2l0aCB0aGlzIGZ1bmN0aW9uIGFuZCBwaWNrIGENCj4gZnVu
Y3Rpb24gd2l0aCBJUE1PRElGWSBhbHJlYWR5IGF0dGFjaGVkPw0KDQpZZXMsIGlmIHRoZSBkaXJl
Y3QgZnVuY3Rpb24gZm9sbG93cyByZWdzLT5pcCwgaXQgd29ya3MuIA0KDQpGb3IgZXhhbXBsZSwg
QlBGIHRyYW1wb2xpbmUgd2l0aCBvbmx5IGZlbnRyeSBjYWxscyB3aWxsIGp1c3Qgd29yayB3aXRo
IG9ubHkgdGhpcyBwYXRjaC4NCg0KVGhhbmtzLA0KU29uZw0KDQo+IA0KPiAtLSBTdGV2ZQ0KPiAN
Cj4gDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+DQo+
PiAtLS0NCj4+IGtlcm5lbC90cmFjZS9mdHJhY2UuYyB8IDUgKystLS0NCj4+IDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQg
YS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4+IGluZGV4
IDJmY2QxNzg1N2ZmNi4uYWZlNzgyYWUyOGQzIDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL3RyYWNl
L2Z0cmFjZS5jDQo+PiArKysgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4+IEBAIC01NDU2LDgg
KzU0NTYsNyBAQCBpbnQgbW9kaWZ5X2Z0cmFjZV9kaXJlY3QodW5zaWduZWQgbG9uZyBpcCwNCj4+
IH0NCj4+IEVYUE9SVF9TWU1CT0xfR1BMKG1vZGlmeV9mdHJhY2VfZGlyZWN0KTsNCj4+IA0KPj4g
LSNkZWZpbmUgTVVMVElfRkxBR1MgKEZUUkFDRV9PUFNfRkxfSVBNT0RJRlkgfCBGVFJBQ0VfT1BT
X0ZMX0RJUkVDVCB8IFwNCj4+IC0gICAgICAgICAgICAgRlRSQUNFX09QU19GTF9TQVZFX1JFR1Mp
DQo+PiArI2RlZmluZSBNVUxUSV9GTEFHUyAoRlRSQUNFX09QU19GTF9ESVJFQ1QgfCBGVFJBQ0Vf
T1BTX0ZMX1NBVkVfUkVHUykNCj4+IA0KPj4gc3RhdGljIGludCBjaGVja19kaXJlY3RfbXVsdGko
c3RydWN0IGZ0cmFjZV9vcHMgKm9wcykNCj4+IHsNCj4+IEBAIC01NTQ3LDcgKzU1NDYsNyBAQCBp
bnQgcmVnaXN0ZXJfZnRyYWNlX2RpcmVjdF9tdWx0aShzdHJ1Y3QgZnRyYWNlX29wcyAqb3BzLCB1
bnNpZ25lZCBsb25nIGFkZHIpDQo+PiAgICB9DQo+PiANCj4+ICAgIG9wcy0+ZnVuYyA9IGNhbGxf
ZGlyZWN0X2Z1bmNzOw0KPj4gLSAgICBvcHMtPmZsYWdzID0gTVVMVElfRkxBR1M7DQo+PiArICAg
IG9wcy0+ZmxhZ3MgfD0gTVVMVElfRkxBR1M7DQo+PiAgICBvcHMtPnRyYW1wb2xpbmUgPSBGVFJB
Q0VfUkVHU19BRERSOw0KPj4gDQo+PiAgICBlcnIgPSByZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb24o
b3BzKTsNCj4gDQo=

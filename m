Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DDA449D38
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbhKHUry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:47:54 -0500
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:59328
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238666AbhKHUrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 15:47:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5IBeL48sAcv1DtZua1gwfl2PUHsywUK98y9GyHUV/z+amOqmTzHqZPmg9GxES/JPcNqW498hbgHwx6MWm6YYiapL7Qq1WN+6IP5lhKZdL5fbSe3WMFjbUc3iJzN1YtAtoR/41AGNw1LGkDHIclgGWucUDRjdd64NGdxlMU5sZzzPmFJKfWJ743w3iyST1ROZHILcpj3jfYWpLU4FjlgXlUkC91U2w4SRsLbNMbsisrWap8wXMpHRF1c0YmBPLSPPa3ghGGpFaFTMwNgYFff/YyLpdggmW8Vvh9ktqPjSc4d9nHL5NSo+Gpqn5vlmHg9UgIYMLE/s0jYNZaL6FYlZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bof0wziqj9/FSiw0gkUB7NHmzvqBjUXLkjJlO4sCuwo=;
 b=fSfEsEOXHZ4DPItfGI3mZKIWiZfWjAG/KvZDnNs/zR3OXdrjWn/CtZXqsUZH0J2C7f2c1q3nRuCKiSU/ikr/pRAVbSyKwveIg8eiZfIucPAqqW7EC4bf7epya/65xQem0V/nTlKbSBY6/YTnKYWE3fx36/M6vST6WgegK0ELkMqERfbjOcW9AxBEvuxAntUfBngMorPy/aqua1VNZE7xyx3RyT8RmUhHTQaN7wu26YWdduMDk4Tv3FU+5X4YJRN1/rb5EIvX+unH6QpyDL6bvioeOgLWumFNIpRcvR2glz8BwQi3uBsDisfUgj9j0jLh+bxem3rYRMTCbbRpNPcMhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bof0wziqj9/FSiw0gkUB7NHmzvqBjUXLkjJlO4sCuwo=;
 b=V87nzShp/vFuy+W5hfarlFMzPY/R3r4/IExrquoif+VTR40rKyo49B4fwDSbUhPcQJrCDDWnm+2U/AM/kpq/Irhi+61LnTNr2MSQ4IcZpn5LROZmwVGJNJhfZ0LllhgrQ8tR2YpTuc+JbD4vrqyg2u1i2hpQ96hk9xKJ9hYVCl8=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BYAPR05MB4133.namprd05.prod.outlook.com (2603:10b6:a02:83::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.8; Mon, 8 Nov
 2021 20:45:04 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d%9]) with mapi id 15.20.4690.010; Mon, 8 Nov 2021
 20:45:04 +0000
From:   Nadav Amit <namit@vmware.com>
To:     "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>
CC:     Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Zack Rusin <zackr@vmware.com>, Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Thread-Topic: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Thread-Index: AQHX1N78hdP2HY1w7EKJ7QP4MiAOaqv6GUMA
Date:   Mon, 8 Nov 2021 20:45:04 +0000
Message-ID: <6BC382F6-6CAE-4C20-AA2D-50905CC263BB@vmware.com>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
 <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
In-Reply-To: <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5c59bd4-98f1-44bc-7b1b-08d9a2f8a487
x-ms-traffictypediagnostic: BYAPR05MB4133:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR05MB4133FA7FE1AE95E07CD9A13FD0919@BYAPR05MB4133.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DSyCgmyfscjrriLwUIl7uK/G0rPlpSUl5Q4lbiNydX7bV2RUiwCFGObVlQsaLnM05gjV5oO/Ak0hVswEPCtFwhJ188AM/4rh3D0agNKv6kJ/VsqSTF60aXJGO8yxaOp5uRjtEVsqvE/DUetUCiXwGCfPcv10W/AHCVbfNTENLP4GytZSmI/yMxPXpa90vUDDXkwTN1OqpB1MCCm7wUjxQN8i3UnAZFF1vKxyL8x1kNruICekl4t06K40qRaxPEXoPwhn0pKYjlMr5AZIf9u2qnKTHuuG+SZ48hsM9oDFvxmF1x6ftKboERwN9+DYwaXSG+tKirGhzGxcJDfoKgn3hav5T9phs36zZ8mxA9Y2IuHdxZUb4ineDqXWjW3u/mz82bsGxcPYGHNPc2fmTC8lps4fT+9nrrWo0FEmtEnO8F0/vzBXFmswPvZZEBNMJ1JQXQrO5XQT+roDqu4mSYujSWt0FIzJgJSm7kKOnJeXU9JB0S1nBEf9ryvTpSe0/cjI/ejG+sLPG1by0jTmmXd6Gz0Os8qvE8n45WwHWhfiRWW2t3LtbKqCTMC9pBzZnSNuF0m1ui3kOfQHHQmWZP9C6N6JLcW7j3wOPYunH171AlLIY5M6SA+AZj/wenofpNjZ2E6+52Gj5BXSRxdzLwlrtB4/GWKZka7mXzeh6UzU7FGAMYrrwnifjwYdqT25WfjOq+gXtA60b3IhVRycAbk7HygYmxOpsBwYXX1ZeMbL1gYsXjJZUXE2npoS/+OixPHPHBX2jR/IDsWBVvRo17TQpe05b4vdIu/lTSydNOsgKcvqmqwxFMosqd7tlrxMYpRu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(64756008)(66556008)(6916009)(66476007)(66446008)(122000001)(38070700005)(316002)(38100700002)(83380400001)(33656002)(2906002)(66946007)(71200400001)(7416002)(6486002)(8676002)(53546011)(76116006)(6506007)(4326008)(2616005)(186003)(86362001)(4744005)(5660300002)(8936002)(6512007)(26005)(508600001)(36756003)(45980500001)(223123001)(130980200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUFMVmlXYlRFUytKT05NVXpqcTJWRVdXY3dZditWNlYxaHA3VW8rOWlrdzhy?=
 =?utf-8?B?OS8wRTl2alJNZFBEK2pLbDRVQVRrY0N1aEVwdzRFOWtMeU1UNGpiK0FUcTcz?=
 =?utf-8?B?dDVaRWoxV1JyVHMyd1c2ZHdJS2U4RXpwT3F0VDJudi84V2FxeWhkUjYwb0w1?=
 =?utf-8?B?R3hHQ1NpakljM3V1dm15TDQzSlhXUTVIMzhHeWo1TUZGbW9nUDhtQW5ld1FK?=
 =?utf-8?B?UUpxblBpQi9zWlZ4YzM1bjRBQ05ReklHNVFQb0czODRod09ZTWEydUxkdTQy?=
 =?utf-8?B?VTFjWnhIei92aU5tbWJHNGtnTFd3T0d5QndKaDYwOW04bkwyVkQ0Q0N3YzN1?=
 =?utf-8?B?eFdNdnRKMy9xSytaVEs1RWhGeUJ3cVlZRXVJL2JpMDJVNjVsK0FDbVJxNWRr?=
 =?utf-8?B?Q3lOZkdMZTFxUi8rNDVUclBzV0dmVzZKQU5aY0dQR29uak5vT2hobUhaWTc4?=
 =?utf-8?B?QUVhWHBFdE16dlFzalowYzR6dHZUajIyQVBWUDVocjNHY2ZJSUkrMyt6QVdO?=
 =?utf-8?B?UmFmbnVjUXQvdS9mdVczQUljVURlUFRCMGlGdzNtYUJkMXVYSHludEd6NUx1?=
 =?utf-8?B?N3dUbDdZeDQ1RnhGbUgrdElHYmRsSmZRaGNwdVd5eXQ1Zk9yVnJIeWRBWDY4?=
 =?utf-8?B?eGdWNlEvd0hxR2FENStHakZxZlJJWm8zVitoY1hZbVR0V0l0OWtsdDRkU3gx?=
 =?utf-8?B?WHNWei9yTngxZnV1U3JER2pkYUhyUDNpemk5Ym42T3ZnREt2VGJLL0dSb21u?=
 =?utf-8?B?UGVpR1o3VnV3WlFneDBTUTFIK29xU2J4UmlLSFZVRlhyMmhEd1RxOHk1MFky?=
 =?utf-8?B?b0NHQ1FvMVRFL3cwNFQxMVBIY2M4Q1NuTkhRK3NvVm1ybWl3alNiWXV4Y3Bv?=
 =?utf-8?B?QlY0dnZOeUhrNVV4c3dxTDFmVWhPczJtaG9vRFhPUzJKUUtKUFoxVlBhMDZJ?=
 =?utf-8?B?KzRMdGM5bjBIR3pKUnFHazBob0VieThKTU1TWE0vK2wxK1IwQ1UyVmlUYmkr?=
 =?utf-8?B?RHQxU0VQekJjNFZ3OXpQY1VDUzFzUnZPL294S2VKQmcyVk4xS1dkWTRkeW5s?=
 =?utf-8?B?MUErS3NEMnFyNExwQTcwcThpQ0p3ODNGNWNBYllwbEVGN3cxNWlDNjdIOE1D?=
 =?utf-8?B?K05nZXJqL0MvUThBeGkwUFdoellqVzY4b1Fha1N0SERWbTFLeHlqUFVlR2FN?=
 =?utf-8?B?SlhrckFjU3lyd0pwN0JRSEtZaVZnZGdZRkw4WExqRTVpMWh0ZEtMc24zeGlV?=
 =?utf-8?B?SWRXUjkwM2ZPOFN2TjFrMGtOcFIxT3lhT1E4VHlaZnJMUG5LQ1ZIM1Znczl5?=
 =?utf-8?B?ODA5OUpNcU5GdDNMM1hWY3VmaGdvcVoxWmYzYlFTZHhaYzNlUjYzQjkwNVMz?=
 =?utf-8?B?blg1dWl2bm45dS9vM0ZNSXNsZ20yWnUxU2RKdnFlaHFKbDhxcFFFMWJEUkdR?=
 =?utf-8?B?MXl4aVJtVmZXeDh1cDZYRzNrN2ZZeW52c1E2ZllOaVhBL0dZWjF6QUlvamtu?=
 =?utf-8?B?U2tRbUlSa2NCVTl6cyswdUhWa1RwSGlXZndCVVp4ZTVHcHRremRtM2x4eEZq?=
 =?utf-8?B?VVdvd1U3dmQvQkppUEJoR0M0L2FjcTJJYStSSGVyNHFrMjg0amRzK1A2RlBY?=
 =?utf-8?B?VmhlQ0pvYitDcW91OXhXMGcvekEva3hwM0tpd1NMVkRvb1FMN3BrSVQ1Y2Jt?=
 =?utf-8?B?ZmZuUnRTb3NZbU9ra3RhN1NGa2lXVi9xMTNlU3BWM0NaSFl3TmQ4U1l6NzNm?=
 =?utf-8?B?ZGxBeVpSRXdibkJQOE5ITGFHbnFNWU9Lc3Q3QWJtSGFnNFhGSmJTOUVXTmc4?=
 =?utf-8?B?ekpYajNIbkhOUGcybGE4YWJWOGNQMFU4dFNsV3hHdXhObkRTNkpUZnJaeElr?=
 =?utf-8?B?TE9XdGRxaU1Ebm1STHByYjhtcWk3VWtEcmwxandLMWYzdTAvSWtxci9yZGlw?=
 =?utf-8?B?U1JwdEY0a00vaFFYeEVsbE02dFVBZVZvOW9XOFIyZWV4SkxpejllNXlDQm1D?=
 =?utf-8?B?a1ZzcTJZRFNZdU1abjI1ZWRVTTl3NkM5Y2VkTXc0c0Z6VVBNT2JmSUdrTTl0?=
 =?utf-8?B?SzhvNnRkNnFMb0FyU3JIVVV1cDEyRC9CbEhpbGEvdlJZalRab1hVN25YQXhY?=
 =?utf-8?B?NVhGL243Mk1MRDAzNW8raFRnSHBGUVJuSTMyMnlhckNlV2laOWYwQ0hYWlRC?=
 =?utf-8?Q?n4VYqgaa0B75ZPzwFotH1l0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2061AF2DBE2C40449B11647852B51B1D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c59bd4-98f1-44bc-7b1b-08d9a2f8a487
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 20:45:04.3516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LbAvAPijp5mgc5VK5c669y4u0aYbFFQMQndRbezPaTsLPYd//7GruNY23u33v8jwF2bXyPD7MJNWqPF9fuE/nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDgsIDIwMjEsIGF0IDEyOjMwIFBNLCBTcml2YXRzYSBTLiBCaGF0IDxzcml2
YXRzYUBjc2FpbC5taXQuZWR1PiB3cm90ZToNCj4gDQo+IEZyb206IFNyaXZhdHNhIFMuIEJoYXQg
KFZNd2FyZSkgPHNyaXZhdHNhQGNzYWlsLm1pdC5lZHU+DQo+IA0KPiBWTXdhcmUgbWFpbGluZyBs
aXN0cyBpbiB0aGUgTUFJTlRBSU5FUlMgZmlsZSBhcmUgcHJpdmF0ZSBsaXN0cyBtZWFudA0KPiBm
b3IgVk13YXJlLWludGVybmFsIHJldmlldy9ub3RpZmljYXRpb24gZm9yIHBhdGNoZXMgdG8gdGhl
IHJlc3BlY3RpdmUNCj4gc3Vic3lzdGVtcy4gU28sIGluIGFuIGVhcmxpZXIgZGlzY3Vzc2lvbiBb
MV1bMl0sIGl0IHdhcyByZWNvbW1lbmRlZCB0bw0KPiBtYXJrIHRoZW0gYXMgc3VjaC4gVXBkYXRl
IGFsbCB0aGUgcmVtYWluaW5nIFZNd2FyZSBtYWlsaW5nIGxpc3QNCj4gcmVmZXJlbmNlcyB0byB1
c2UgdGhhdCBmb3JtYXQgLS0gIkw6IGxpc3RAYWRkcmVzcyAocHJpdmF0ZSnigJ0uDQoNCkFja2Vk
LWJ5OiBOYWRhdiBBbWl0IDxuYW1pdEB2bXdhcmUuY29tPg0KDQoNCg0K

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0813F4B62ED
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbiBOFgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:36:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiBOFf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:35:58 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A118B65D4;
        Mon, 14 Feb 2022 21:35:49 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ENIBOV002742;
        Mon, 14 Feb 2022 21:35:08 -0800
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e7rht3a82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 21:35:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4jejsZm7N2UIFJA62WkydrhakwqnZ3QVjJQOQURaaLbrkGS5cFB2+ysYA/5YmyjN0w4eNFfj9k0cH6IOkdv8p/qSkXyc0hLBj0PivNAqFhbfSIVoVTLxiPIdzRoA6cLEC2HuY3v3V8enxmAet5BUPB1Ooh4Mcn19/ZJtPsLp2lxySh1lFiwz5zGAR2+qBsBrbVsuXcbj/cMf9MpwIUbgHW/NrsY49JBYgCXdtHGtLMI0WlA+I1hmuTg+BzE7/CFxKRfwVBZrhu4NP5bNQVgQGs3CAOv8vGFnXM5GhR9vtMfNqyeGCGkcuUPfKRCLeNYfzWhHLUikMDS8Vam8uQepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlhrQ3sL9hiTg+e2CtcsqgMAmmPCNnrCnXX0Trd4mTo=;
 b=Y4MM+BeDyusve7eSowSITTqmopEhdeQiffG3UwK6EIQwlpWX+L6WOVJ0FWDvMXqbu1SFaUnPLhy8sfLFcNeW+EMJMT8EGozuY1+Tf7VoBNjKDH6LpYYbr9AEL7ybhxdAeQ4t22K16J0vb3AYinVJsEe6J8GlSL7eT4NS+6QoNRDuzXJ06bLA1JLfadmpDs2PJuZ+KppIJCdBQPYwWLjCFzgkcJMD3M9hnX3FaivKy1uPNPVBPZiwmo7cqlX2kLiezvjnJQKVENEHz/gMw0ruynlUy+0mFqjgr3DoX/7RV1qATXkRzsJ5HpZKdhW8WJBEO7UueHBZBhu+drbVpnZtXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlhrQ3sL9hiTg+e2CtcsqgMAmmPCNnrCnXX0Trd4mTo=;
 b=lfJtY7tFeR59Gr2BS0QNSUWmb7/1jNxg44GvdpPv9iDd6LoyDIgHUq1hTUUsgMEsEeWS3fAhSgjePEwW1HUGIZ7m+GKljGRdXA54+FyeJCqT2CxU17dy0Nnw0GGLAfQ2N6cy8tTaosp73QYmKrNtgQYNEpLemWPAi7RASmQpjcU=
Received: from DM5PR1801MB2057.namprd18.prod.outlook.com (10.164.253.144) by
 BL1PR18MB4230.namprd18.prod.outlook.com (13.101.93.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.14; Tue, 15 Feb 2022 05:35:06 +0000
Received: from DM5PR1801MB2057.namprd18.prod.outlook.com
 ([fe80::f065:50b8:97db:8e8c]) by DM5PR1801MB2057.namprd18.prod.outlook.com
 ([fe80::f065:50b8:97db:8e8c%4]) with mapi id 15.20.4975.015; Tue, 15 Feb 2022
 05:35:06 +0000
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     "yury.norov@gmail.com" <yury.norov@gmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mirq-linux@rere.qmqm.pl" <mirq-linux@rere.qmqm.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "David.Laight@aculab.com" <David.Laight@aculab.com>,
        "joe@perches.com" <joe@perches.com>,
        "dennis@kernel.org" <dennis@kernel.org>,
        "kernel@esmil.dk" <kernel@esmil.dk>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "matti.vaittinen@fi.rohmeurope.com" 
        <matti.vaittinen@fi.rohmeurope.com>,
        "aklimov@redhat.com" <aklimov@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alok Prasad <palok@marvell.com>
Subject: RE: [PATCH 11/49] qed: replace bitmap_weight with bitmap_empty in
 qed_roce_stop()
Thread-Topic: [PATCH 11/49] qed: replace bitmap_weight with bitmap_empty in
 qed_roce_stop()
Thread-Index: AdgiKoGorysVUQe3Tjqh8re0ND5Nzg==
Date:   Tue, 15 Feb 2022 05:35:06 +0000
Message-ID: <DM5PR1801MB205732C84AFB0449EC342B6DB2349@DM5PR1801MB2057.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 390a0f8b-3938-4ba1-6018-08d9f044ec81
x-ms-traffictypediagnostic: BL1PR18MB4230:EE_
x-microsoft-antispam-prvs: <BL1PR18MB423099BCF8F29D2C944CFC1FB2349@BL1PR18MB4230.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r5gG59X6B0Nh8oQ6ugj7g65hgM7VtqTvjXmjnRrJLYkZHnfs/9sQTsAgxfO7HwsurbChAeH0B6gmQ84EW6hqwmixdX7KPMBjek2rEMk8RMtybaIHHhehO6zD9PbroNWhB+9FW8fWIqt3CWxBXD3w8cSqwVlftYLjSeUQ3+CK5WGOE2vdX2YjfXfMZ52sXVi0o0A2QFQbs/MDmNmbolaaiyxJooIERIIdcPHSnu/mm0WxfX4CUYmUS8k27Bb7KdqAOGEkQT1tkIKanVyuOJmqqSqdN0xyaQ5xJMrvAzlybJlXtPZcoWs1DrlfWDhO+XNt9/iYgV2vXHGNOuQJihVz2HBSBUr2xFHx0pqcLXMIF6Nv4axtWU4+Ze6/1tc5GBHWypt0CcJdHZsN29WZc7ZdJNbkRLU5fMCZFn1R1U635D8QeYDvT1pim09hW14RchkpBmJq/epXkEp3Mi7wjOmX+wfcvocZFMjo87/9tJWLgUlLKI4vR8n5qoNavk6nKCf2NY7M8I+BVS4+DqBRoDGd1SC3NLBcazYgRWVoWtPGHW++neE2T118pLRL8T6yQrU2NC0m7bjv1xNvcsg8rOmsQ6ZH2SB4vl0EO+DI9zSWq8z6UO1uDqiq/kyY/DZ6ye7fHGRLuWsfSwJeZwA27FWxdspwNwlXASjXgvkvFsudtcpYBdgPyFErFqK3u1GA+bVaV2WgX5tdaFJEdOAhrQ96QOtC90VTjLcT0pQdSRbITrfA9+34sDbBoSsDCEE7a7gv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1801MB2057.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(8676002)(26005)(6636002)(316002)(66946007)(71200400001)(66556008)(5660300002)(508600001)(66476007)(76116006)(64756008)(186003)(921005)(66446008)(83380400001)(33656002)(2906002)(53546011)(52536014)(55016003)(9686003)(6506007)(7416002)(7696005)(38070700005)(86362001)(38100700002)(122000001)(8936002)(16393002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFNxRm1pajFtQ29QbmRwRERMS01GZ3k0OXQrOUFUSTZWZ0psaXMvdVJ0bXVa?=
 =?utf-8?B?TVdFaE1DWHV6bTRLRUR3NFNiNHBzTURvekFUK2YrbE5uc01mcGUzOGlRMWVv?=
 =?utf-8?B?SmFBMkowQ3p1bFVXNGUyR2g2MkhBTVcvK2JFYU8zT0xOTE9HdHMxQW5aZWs2?=
 =?utf-8?B?NEU5dFkzQnlVdURydCt5aHdzT09NeWpQMXh5YTZ0dmdsZHhLK3ArR3hkUGNy?=
 =?utf-8?B?V2ZPNWVVZklWbVFZUHZzV043c0ZqRjFsdWVLUTZ6UmI1YnlEV1VEUnRaRlBM?=
 =?utf-8?B?N3poN3ppK0tSY3ZOc2dKd04vVmRTbG5kU09tMW1CL1hlYmVqZ0V6ekcwVnBV?=
 =?utf-8?B?NGdWM2plU0l2NmdEeGlVMVlrZ1pKSnRPNEFWaGtXVWt3R2VtcThDekJ2MzEw?=
 =?utf-8?B?cXFwQzFyZUE5b0JUMW1nMDM3a0NIOFZzck1JRUUvdXhFcjNSNEVEd3gxQUlq?=
 =?utf-8?B?Vms4V1JMdFova1FYQzJTY1NTV2lkK3cvby9pcTJmWEtSeURCbFZWalhFemE1?=
 =?utf-8?B?U1dXekZSM2kySE1vdmEvVC9Qek5pUXN4VzZPQ2JyWnV6UjRQR0x4V1BlTmcr?=
 =?utf-8?B?Q21mdWN3S29yQkVsV0JOMERXMUFoSHUwZ1liam1HTUsrZEZLQi9zd2hwdjl6?=
 =?utf-8?B?dS9Kb0dRUjRTeTh2d2FTUnFSQWdpeS9STExUTHJpV2o2VWppK3BIM1JXZEVp?=
 =?utf-8?B?UEd5aFJSSnZURVczS0xuZEpzektnSlBJYUxZa0wycldBWXB3Nm9TdGV2TWZr?=
 =?utf-8?B?Z0J1Uzh6QXdrNHAyM1g1WnhiVU0vUURiTkJ5czl3Tm5Ub2c1YVhZL3hzVndN?=
 =?utf-8?B?Nm1kNjgwY05BSm5KQVR1L3I2WUwzWDU0bzZKdEVNaVo3YXV2YmZpQlJjTjY4?=
 =?utf-8?B?YWVvNmlwbnhWVXVpbXAycmthNnk3VjQzTjVVK2IxNk56NEN1MFEyc0ZMTU4y?=
 =?utf-8?B?SCtMNUV0eFZtMUcyNGlrT0R5enNDNFZvbU1PN2Mrb1JFdlhpdDMydGQ5UnFq?=
 =?utf-8?B?VlUwZEgwcERGWUxtdUxWOTJMQk9UM0tRb0Zma0VYTTVhY0ZLSFBkbGtSOXZS?=
 =?utf-8?B?R3lVcnI1b2V0YmYwVnZHSzdDWXREbFpsMVl2MHVMRytNaElBSUlWVWt0WTBU?=
 =?utf-8?B?VmNlT2p0MHM2eTNwNVZLTG4wVS9wRG9VVjk2ZSs3OHVhYlZYSldKTmVUK2Fa?=
 =?utf-8?B?MmR5d2FKb05pdVpJWXFXUW1yck9DOHhxVEFteE1UYU00c0NoeHh1elpHbVhE?=
 =?utf-8?B?Y3Y2TytIdVREMXVITHdYWDBvMDdIUm45Z3BXOHgrYVlHS0JZcXJCUHB6Slpz?=
 =?utf-8?B?bGpUbzlpSFVMcHNtNExLRm1sbkkwUTQrcVZGRXNMTUc4dkZpMWZiemNBWDQ4?=
 =?utf-8?B?bTNZbE9DdndxOElCNlE3d3ZMenVvSHlldWlSYnhaSUdsTDVQVlVtc0JQbnpJ?=
 =?utf-8?B?Ykp3ZzZRbEpDTEpLVVhsbTdLTzZnQjhTNmNSY051M2pIakJoOURQTjNEVWhW?=
 =?utf-8?B?eWwyRXQ2V2NuY21ZTERXdnUyTnQ2aG8vbWlxL0J1cTBWNHozTGp0Qi9rditL?=
 =?utf-8?B?NGlRWXg4VE15ejFEZVlyakk0Wi83OWVYZmF1MUU2SU5aT2t0ZWFZZldxSEc3?=
 =?utf-8?B?WEdLS2FiWTdWdURJNFhibnExMC9yRlNoY2w0MVFzNmt2OGZqZnJSNG5LcUZI?=
 =?utf-8?B?NlBhK3haYXl3a0ZEb0JQRXBySFRlTG85SUYzaXBYbjN3MVh0OHN0dTByVGU1?=
 =?utf-8?B?blRoWVptUk1RNEE4T1VRVlFaaWlKQVFHUkRaOWY3OTEyTFVKY3FqQ05XYkNM?=
 =?utf-8?B?aXNFSVRBTGFEbjFLZm1vWnlTS010YTlROG5FdTBCdnFyTzRBN1l3UUFXVldo?=
 =?utf-8?B?dXJBbityQ3Q4SEZIdENzV1NWWUs4bkNpZmZMa1ZPQlNFdG5VMXprWUhNWTdt?=
 =?utf-8?B?Y2R0MnJETXcrNEtuM1RjT0dndXlEUzRXNDlkZFJjSm81RGNXaG5qNTBiUVYv?=
 =?utf-8?B?U1ZNQnd4YVBJZ3FBMzVpL2FwSW5JdW1odXJEMFpVVWNOYzNzMVk0OUpkcHlo?=
 =?utf-8?B?cTZCdVVoZzNPdzVXMWZ3OCtiUGRJWDRoTXJ4bWtPTFlpb09ucGtQbDVDdE15?=
 =?utf-8?B?cG8wcUV6Q0MwRERVaWpXeGU2UW1NRUdHbkZqTkRaQmZqeUZXV2VVaWVFWVNI?=
 =?utf-8?Q?N5kMp9tVerxEJBYViR+Jtnc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1801MB2057.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390a0f8b-3938-4ba1-6018-08d9f044ec81
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 05:35:06.4417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xnqkrot5qzbp69PLfIrAiUwcaxD0UBzbSXvevLt+KBC8TqoKlDvFzuGCVxgLn5WXROmfaLmzqp0TnxgCU35s0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR18MB4230
X-Proofpoint-GUID: eS_AD4dx4jqmiuqznP_rW6HC4VqZOE1C
X-Proofpoint-ORIG-GUID: eS_AD4dx4jqmiuqznP_rW6HC4VqZOE1C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_02,2022-02-14_04,2021-12-02_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWXVyeSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQcmFiaGFr
YXIgS3VzaHdhaGEgPHBrdXNod2FoYUBtYXJ2ZWxsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgRmVi
cnVhcnkgMTUsIDIwMjIgMTA6NDEgQU0NCj4gVG86IFByYWJoYWthciBLdXNod2FoYSA8cGt1c2h3
YWhhQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggMTEvNDldIHFlZDogcmVwbGFjZSBi
aXRtYXBfd2VpZ2h0IHdpdGgNCj4gYml0bWFwX2VtcHR5IGluIHFlZF9yb2NlX3N0b3AoKQ0KPiAN
Cj4gU3ViamVjdDogIFtQQVRDSCAxMS80OV0gcWVkOiByZXBsYWNlIGJpdG1hcF93ZWlnaHQgd2l0
aCBiaXRtYXBfZW1wdHkgaW4NCj4gcWVkX3JvY2Vfc3RvcCgpDQo+IERhdGU6ICBUaHUsIDEwIEZl
YiAyMDIyIDE0OjQ4OjU1IC0wODAwDQo+IEZyb206ICBZdXJ5IE5vcm92IG1haWx0bzp5dXJ5Lm5v
cm92QGdtYWlsLmNvbQ0KPiBUbzogIFl1cnkgTm9yb3YgbWFpbHRvOnl1cnkubm9yb3ZAZ21haWwu
Y29tLCBBbmR5IFNoZXZjaGVua28NCj4gbWFpbHRvOmFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4Lmlu
dGVsLmNvbSwgUmFzbXVzIFZpbGxlbW9lcw0KPiBtYWlsdG86bGludXhAcmFzbXVzdmlsbGVtb2Vz
LmRrLCBBbmRyZXcgTW9ydG9uIG1haWx0bzpha3BtQGxpbnV4LQ0KPiBmb3VuZGF0aW9uLm9yZywg
TWljaGHFgiBNaXJvc8WCYXcgbWFpbHRvOm1pcnEtbGludXhAcmVyZS5xbXFtLnBsLCBHcmVnIEty
b2FoLQ0KPiBIYXJ0bWFuIG1haWx0bzpncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZywgUGV0ZXIg
WmlqbHN0cmENCj4gbWFpbHRvOnBldGVyekBpbmZyYWRlYWQub3JnLCBEYXZpZCBMYWlnaHQgbWFp
bHRvOkRhdmlkLkxhaWdodEBhY3VsYWIuY29tLA0KPiBKb2UgUGVyY2hlcyBtYWlsdG86am9lQHBl
cmNoZXMuY29tLCBEZW5uaXMgWmhvdSBtYWlsdG86ZGVubmlzQGtlcm5lbC5vcmcsDQo+IEVtaWwg
UmVubmVyIEJlcnRoaW5nIG1haWx0bzprZXJuZWxAZXNtaWwuZGssIE5pY2hvbGFzIFBpZ2dpbg0K
PiBtYWlsdG86bnBpZ2dpbkBnbWFpbC5jb20sIE1hdHRpIFZhaXR0aW5lbg0KPiBtYWlsdG86bWF0
dGkudmFpdHRpbmVuQGZpLnJvaG1ldXJvcGUuY29tLCBBbGV4ZXkgS2xpbW92DQo+IG1haWx0bzph
a2xpbW92QHJlZGhhdC5jb20sIG1haWx0bzpsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnLCBB
cmllbCBFbGlvcg0KPiBtYWlsdG86YWVsaW9yQG1hcnZlbGwuY29tLCBNYW5pc2ggQ2hvcHJhIG1h
aWx0bzptYW5pc2hjQG1hcnZlbGwuY29tLA0KPiBEYXZpZCBTLiBNaWxsZXIgbWFpbHRvOmRhdmVt
QGRhdmVtbG9mdC5uZXQsIEpha3ViIEtpY2luc2tpDQo+IG1haWx0bzprdWJhQGtlcm5lbC5vcmcs
IG1haWx0bzpuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IA0KPiANCj4gcWVkX3JvY2Vfc3RvcCgp
IGNhbGxzIGJpdG1hcF93ZWlnaHQoKSB0byBjaGVjayBpZiBhbnkgYml0IG9mIGEgZ2l2ZW4NCj4g
Yml0bWFwIGlzIHNldC4gV2UgY2FuIGRvIGl0IG1vcmUgZWZmaWNpZW50bHkgd2l0aCBiaXRtYXBf
ZW1wdHkoKSBiZWNhdXNlDQo+IGJpdG1hcF9lbXB0eSgpIHN0b3BzIHRyYXZlcnNpbmcgdGhlIGJp
dG1hcCBhcyBzb29uIGFzIGl0IGZpbmRzIGZpcnN0IHNldA0KPiBiaXQsIHdoaWxlIGJpdG1hcF93
ZWlnaHQoKSBjb3VudHMgYWxsIGJpdHMgdW5jb25kaXRpb25hbGx5Lg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogWXVyeSBOb3JvdiBtYWlsdG86eXVyeS5ub3JvdkBnbWFpbC5jb20NCj4gLS0tDQoNCkFj
a2VkLWJ5OiBQcmFiaGFrYXIgS3VzaHdhaGEgPHBrdXNod2FoYUBtYXJ2ZWxsLmNvbT4NCg0KDQo=

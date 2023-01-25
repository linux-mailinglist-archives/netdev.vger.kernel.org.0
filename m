Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29D67BE29
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbjAYVYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAYVYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:24:23 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413241B55
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:22 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PKAnJU007843
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=sQWNqom5yK3VXRc6QOXvtO/y3rtdvm6F2hJ2nj5od+Q=;
 b=WdUcXKVHBTwZOR0Q6qmXR7XW+HYI9DbJfuH9lHe8rL9jbkxI8I+CH/SK+TPmmHOVdBQ+
 A9V9rfWEF4ZquXwfpmnjOdC8K1wuYwoIZOXKIzq23ySeoEgz7eSgEga23eIUCE06encQ
 HyE3uX8Uj7OscL/f7CLXCFs5xGM03NMpXW17KsRCDrIjZmJIGl/398MhGwq/jbisTyO6
 dMyNkmiizSl+Tebkx5q/Q9WROYF65mj7bHoDetdIRWc5kOg66PGac53tpWPFMNaeFLpY
 2BiNPFP+mJaOLkbaJUFOoi7tUcxjpHjrAK9DSfRTu5A6XKX9u5EA5vtO3WdDVGtt4YXn oQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbb7yrevb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVVNPA2JnZkYmqDKo8qylE+CVddXq6/u1+GsnwBdhg8ckWm4o+78R2f/k+Ti0jidYF2EHeRdL+rwoXN1kDFPKDbJVpp+Cs7GbIxQ1zoJsY2gkGNS6fphMTZlTTzpyWVHyIdR4cxm73Se2uEYKaK1MBXVj93MXh3/ns09XxqVjxkuarb4WJ+dLGy68a++e9FX6Nqq6zpuyueDRNsdwTQ9/Bbpp0aSxV6garanP8ChioCzANai8iHoXEiROqWd510f8ezHu9fz01dE2GAEkxm4kU5q4VA5XZaE+XK0+Oh3RkWUvYz6F/vS2p86rtfThgFU5uoWqH3SGCcgHfHSxwUM/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQWNqom5yK3VXRc6QOXvtO/y3rtdvm6F2hJ2nj5od+Q=;
 b=YtQnEJNVn7Wg8jJ/i6bOwzA3z6mslSJt/r6n6RHzmpqdz4sO2Q54sQ6Q4VoKLrYpwF9Kp8goLifTYW7un6+ShwmDFUTGS6NPYQpW8Tk8K1FBt8ZlWjjtKr0R3nrbRbbgl+OAXGIgaNWnD+MWS/JL0HBZ4TDM+yKkgvnV4NGvLcyPBynYN0PePQjGFfoO/lcpyMgsYa9EJEAEJlxOghPtIg4qErWMOTLUSXu43GxV7Flsz2l2F8PSc7SJE6P8E0h9C4+1HIEbMkI6T+cdNkYCctlmckmfqwpVu8FdugHKai4TAudmTPr+zQIepn4xOn+DldgNUvCBWZGfiNXqz7+80Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by PH0PR15MB4783.namprd15.prod.outlook.com (2603:10b6:510:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 21:24:18 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%4]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 21:24:18 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Topic: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Index: AQHZLnza/MOTtBC6Vkmawt4udI7hbQ==
Date:   Wed, 25 Jan 2023 21:24:18 +0000
Message-ID: <fbffc35d-81d9-a4ab-6d0b-0ccb417914ea@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
 <c73fe66a-2d9a-d675-79bc-09d7f63caa53@meta.com>
 <46b57864-5a1a-7707-442c-b53e14d3a6b8@nvidia.com>
 <45d08ca1-e156-c482-777d-df2bc48dffed@meta.com> <Y9GSKrk95A4/Xo68@x130>
In-Reply-To: <Y9GSKrk95A4/Xo68@x130>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|PH0PR15MB4783:EE_
x-ms-office365-filtering-correlation-id: 09d573cb-5a3e-4cba-9763-08daff1a84af
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DuigH4+IdfcYyO1fhYo4QXVD+rSsN9gSJnH209WKbbUtMExu0GBe6gjCT89F7IIE9sz9AjdoopRneIYR85AEwKZeiALKQZzFw/DYYKbbnAzWoM/MwytVtACXqYz6wzd0ppzxkZ6VrTdODMZ6VRHeAIdl2wRAOhPD7QmyXPLVw5X/vohypiZtI/6t5fYkl7jN3QwnDEJqzx0rDV5NzwuIvlTJlZ2AvbaQhBX0oVFUrCrS8tfY39s/V3wcUOb1tmpyZSPV8VT8rHbWCD5pURb0g+xekchD0KZuCu6A3WnJU4khyZAfokKroR/0cMzfZpuiXAvIVIe1mgsClA3JLd2tgSM41FZzCVGW1nlANNZ/0fFN/ZVifBQxK/uHbv1Nv2gY2KrJVCRI61/7PvdLrp7+39fwdaE72mAy2BbBR08AHKFf16YLHUUwI6sgBUrKe83vxIRXDPUK9lUuRKuFL7kI/740XFm0ZHVUNxle+lfRm5LZbpWOFGcKo4s5AkFhJ10Ue6xhNR2zhDHhjNBTSwJSyf5DiJDP8R8nFkCQ/BkMh2KJEvfosJPORyNoNb7eGl1P9RAn0RFWPay5ywiecpmn6MtRl7zKjZ0wPrxzm1CkSA335MDPQ3wnkaZSq32yTp4I6hLzVzA2AJ9rh5+75/PPxlug1tIZ39g7RTeGn+SB4aj01pHaFEAk2mtfRxnkSgYMbGDIL0+LoYtTg8uwAKeyzSmDO9s/j1ayFF2yJ1xkka0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199018)(122000001)(38100700002)(31696002)(86362001)(36756003)(38070700005)(54906003)(2906002)(31686004)(66476007)(41300700001)(66556008)(66946007)(4326008)(8936002)(76116006)(6916009)(91956017)(8676002)(66446008)(64756008)(5660300002)(186003)(6512007)(26005)(53546011)(6506007)(2616005)(316002)(6486002)(83380400001)(478600001)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFcyTmNnYWwrTmVJRmRTdjZIa0IwMlNZd2FXODVmOFNhRjhjT1Nhc1BpVStP?=
 =?utf-8?B?dlMvQ0RUQmtobDMzMTBhL0I4bmFXd1ZWbGx3Wmt1WUJsMVpGTmtNazA4bGNN?=
 =?utf-8?B?amFzZWJxZkQyQkdzaHRnM3JMQXJ4aHluVjRycEV5bmpQVzk5YnVZS1FuSzFs?=
 =?utf-8?B?aW1JditJV2w2SFBzK1I3Zmp0MTliRCtvK3lPcFpOUGl6NkI2NTNFUis1cHl1?=
 =?utf-8?B?K3pMdWd6UFczMkFKNFgvRFZFYUFGUGY1SVhMeDBmU09ZN2lKWnpOdTBSeTlo?=
 =?utf-8?B?dEdRWldjZXEvUEQvSUNEOW0xc2ZpdjU1NFlhTG55MnpjRG03UzdXZldTemQv?=
 =?utf-8?B?N1R6MXZjQVFsSGNYKzJGQ2Jsb1NpZ082ajhQdnplYVh5OG00eTIzZElWUUxX?=
 =?utf-8?B?cEtGUng2T2xrOVk4SXdaa0FIWi9yQVdZQjZlOTcxT2NCYkdxWkRDd3NnSGVQ?=
 =?utf-8?B?R24wd1VROW03UVFtRU1lc3E3WktBaVorZHI3UWQzTTU4eHQ2Zkk2b25ydVoz?=
 =?utf-8?B?TExXSjgrbmdSMnJrZHBmL05wWlhVMWFGcjB0VzFTdlRnWGNYZk5lY0RKUGFs?=
 =?utf-8?B?M0FMTDVTdm5nNmNackRRNHNaREFmajgvbnNHRm1sZGxPNVBmMnNMa3NqSjlB?=
 =?utf-8?B?OHFLOGZ6VUNheFpDQUlLblllMHNNUW56akhuUkZ0cVJqKzBvMlRKRE5vQ09E?=
 =?utf-8?B?Y0RpY056N0g0NFdOdjB0MGdJS1VXQUJ5dDNHVTlqVUZGWG5JS1NKYUtiU0Zr?=
 =?utf-8?B?aG05RU92U3hXYTEyenUrMG0rV08weENtb0V5STJKWFlMZlhoSytFOFpvZklw?=
 =?utf-8?B?a0FJd0R5Qk9yNm1yRE5wQm9BbjZRaWgydmRZRWlRMzV5Zjl3Z2lqVzliUUl5?=
 =?utf-8?B?UjIxMS9sdEN5ZlFDUnQ0bjhEbTlBb3VOa0NBTFkvYm5KNHcwSWZ3ampBWmZn?=
 =?utf-8?B?cWhOSmREK1RvVG13N25BTXRYL09WTkRuNHFPQWxzbkZjY0NWa2R4cWp6bVoz?=
 =?utf-8?B?M2ZYSjZYd0gwM0VRU2dUSnNIcnJTNTIrZ01qSkVNNjE5V3ZhYnpnN1ROdXJN?=
 =?utf-8?B?TkZlQm9DOW9RZnc1RjZsd0cvMzJMMVdqSW1XYTRiTjY4L2s4TGlzWlF5RjFt?=
 =?utf-8?B?TWtiTTNzMTlSL3k1RGRIL3hEMTZoSXNyZ1FpNysvdndZeC9EZFVxWVZFMFhM?=
 =?utf-8?B?VzhPNmd0NU9ETEI4YjFablFJUVFyRm5HdXVMb0trKzlIMzlxbDR0QlRaZkEz?=
 =?utf-8?B?Mzd0YXNpandHemE4SlBNb1FQN20wcXNzRTlSaDNJeDlWRVNuazRQZFl4SDJP?=
 =?utf-8?B?bmYyOXNyUFpGM0NPcGlKZDVKWURYRnA1TGEweXBFb1BjdkljZ2U2c0tVNUhF?=
 =?utf-8?B?L2lWUGdKc3NRNlMyMVpaVVRDMkFwTXd2cEh2NDkzOWcrVEFUdFU1UW9pTzdY?=
 =?utf-8?B?VmJwMlJQVzlYWjMyUjM2M0NHOUxUeUhCYm83bksreG5oNE5LdVhEdi9SMU1s?=
 =?utf-8?B?Z1dhRzBHa0poUEx2OVpYeGxNU2hMemRCb0JIcGhlWHpaYml6S2w4K0NlUGxQ?=
 =?utf-8?B?bVZaV3J1M3RwL2VQRFpWOXJySTJRcGJEQU5DRElhQUQ4SmRyQUpVTE1FSXRD?=
 =?utf-8?B?QjJmRmhZTTl2eFJVdmJtZnA5YytKS2E4Rm53dXpQVnNUa1lnVmpyYkZhaTFt?=
 =?utf-8?B?R0FoY1BqZmsrblRBUG8weFlGaEU3NkJyMGtRa2VYOHVVZmVYNTlVMkdlZjBO?=
 =?utf-8?B?NTE5dDUxV2w0UTRKQ2JGZDNTNDA1cHQ1aVRyNk5tZGRPMzI2Z0tYajg2L3Rl?=
 =?utf-8?B?SzVTRFBYeVhadGhVcE5QUDgxdE5FWERHdUlBSWtUQlhBc2Y2RFF4aW1IZG5v?=
 =?utf-8?B?UTZaSGh0OXFIeGQvSStBMmZFM1FVVkVGSVBvR0NZY2lKZ255bHFTMDRxMXN0?=
 =?utf-8?B?N05QbEJYYk5PMHoxTTg1dDdndlpyYlFLalhkYXZVd2dqbnEvWWVBQm9aUFFk?=
 =?utf-8?B?V0tDb0JIazE0R3ltNUhZQWczdm9JYXRMRWRtS1B0bmVOdjJkWlAvSTIwVGJo?=
 =?utf-8?B?NGtWYVZCMU1FQit0U25kYzdVcFdlWXl1YlVtM3prOVJoVVVETmJnWEovWGRG?=
 =?utf-8?Q?Xf40=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB89D3D94F57C546BB049D651B901D91@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d573cb-5a3e-4cba-9763-08daff1a84af
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 21:24:18.6210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FsILLCoPw9rhSwnGNwYLiDZ2dYJgiI4gmjEcr3zgVJ7RuPMcdx4hIJVryf3jEckG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4783
X-Proofpoint-ORIG-GUID: xOWRnRS376bsvXc6Tn8HSzWtCNUQLqyC
X-Proofpoint-GUID: xOWRnRS376bsvXc6Tn8HSzWtCNUQLqyC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_13,2023-01-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUvMDEvMjAyMyAyMDozMywgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+IE9uIDI1IEphbiAx
NDo0MiwgVmFkaW0gRmVkb3JlbmtvIHdyb3RlOg0KPj4gT24gMjQvMDEvMjAyMyAxNDozOSwgR2Fs
IFByZXNzbWFuIHdyb3RlOg0KPj4+IEFueXdheSwgSSdkIGxpa2UgdG8gem9vbSBvdXQgZm9yIGEg
c2Vjb25kLCB0aGUgd2hvbGUgZmlmbyB3YXMgZGVzaWduZWQNCj4+PiB1bmRlciB0aGUgYXNzdW1w
dGlvbiB0aGF0IGNvbXBsZXRpb25zIGFyZSBpbi1vcmRlciAodGhpcyBpcyBhIGd1YXJhbnRlZQ0K
Pj4+IGZvciBhbGwgU1FzLCBub3QganVzdCBwdHAgb25lcyEpLCB0aGlzIGZpeCBzZWVtcyBtb3Jl
IG9mIGEgYmFuZGFnZSB0aGF0DQo+Pj4gcG90ZW50aWFsbHkgaGlkZXMgYSBtb3JlIHNldmVyZSBp
c3N1ZS4NCj4+Pg0KPj4+Pg0KPj4+PiBJdCByZWFsbHkgc2hvd3MgdGhhdCBDUUUgYXJlIGNvbWlu
ZyBPT08gc29tZXRpbWVzLg0KPj4+DQo+Pj4gQ2FuIHdlIHJlcHJvZHVjZSBpdCBzb21laG93Pw0K
Pj4+IENhbiB5b3UgcGxlYXNlIHRyeSB0byB1cGRhdGUgeW91ciBmaXJtd2FyZSB2ZXJzaW9uPyBJ
J20gcXVpdGUgY29uZmlkZW50DQo+Pj4gdGhhdCB0aGlzIGlzc3VlIGlzIGZpeGVkIGFscmVhZHku
DQo+Pj4NCj4gDQo+IEhpIFZhZGltLA0KDQpIaSBTYWVlZCwNClRoYW5rcyBmb3IgdGFraW5nIGEg
bG9vayBhdCB0aGUgaXNzdWUuDQoNCj4gQXMgR2FsIHBvaW50ZWQgb3V0IGFib3ZlLA0KPiB3ZSBz
aG91bGRuJ3QgYmUgc2VlaW5nIE9PTyBvbiBUWCBkYXRhIHBhdGgsIG90aGVyd2lzZSwgd2hhdCdz
IHRoZSBwb2ludA0KPiBvZiB0aGUgZmlmbyA/IEFsc28geW91IGNhbid0IGhhdmUgYSBwcm9wZXIg
cmVzZWxpZW5jeSBzaW5jZSBpdCBzZWVtcyB3aGVuDQo+IHRoaXMgT09PIGhhcHBlbiB0aGUgc2ti
X2NjLCB3aGljaCBpcyBkZXJpdmVkIGZyb20gdGhlIHdlX2NvdW50ZXIgc2VlbXMgdG8NCj4gZmFs
bCBvdXQgb2YgcmFuZ2Ugd2hpY2ggbWFrZXMgbWUgdGhpbmsgaXQgY2FuIGJlIGEgY29tcGxldGVs
eSByYW5kb20NCj4gdmFsdWUsIHNvIHdlIGNhbid0IHJlYWxseSBiZSBwcm90ZWN0ZWQgZnJvbSBh
bGwgT09PIHNjZW5hcmlvcy4NCj4NCg0KV2VsbCwgZnJvbSBteSBsb2cgSSBoYXZlbid0IHNlZW4g
YW55IHJhbmRvbSB2YWx1ZXMgYWN0dWFsbHksIGp1c3QgcmVhbCANCjEtMiBjcWUgb3V0IG9mIHRo
ZSBvcmRlciwgYW5kIHdpdGggbXkgcGF0Y2hlcyB0aGVzZSBDUUVzIGFyZSBzaW1wbHkgDQpkcm9w
cGVkIGFuZCBDUUUgdGltZXN0YW1wIGlzIHJldHVybmVkIGluc3RlYWQgb2YgcG9ydCB0aW1lc3Rh
bXAuIFdoaWNoIA0KaXMgZ29vZCBlbm91Z2guDQoNCj4gVGhpcyBpcyBjbGVhcmx5IGEgRlcgYnVn
IGFuZCB3ZSB3aWxsIGdldCB0byB0aGUgYm90dG9tIG9mDQo+IHRoaXMgaW50ZXJuYWxseSwgQ2Fu
IHlvdSBwbGVhc2UgY3JlYXRlIGEgYnVnIHJlcXVlc3QgPw0KPiANCg0KVGhhbmtzIGZvciBjb25m
aXJtaW5nIEZXIGJ1ZywgbGV0J3Mgd29yayBvbiBpdC4NCg0KPiBGb3IgdGhlIFNLQiBsZWFrLCBJ
IHdpbGwgdGFrZSB0aGUgMm5kIHBhdGNoIGFzIGlzIGFuZCBpbXByb3ZlIGl0IGFzDQo+IG5lY2Vz
c2FyeSBpZiB0aGF0J3Mgb2sgd2l0aCB5b3UuDQo+IA0KSSBoYXZlIGFscmVhZHkgcHJlcGFyZWQg
djMgd2l0aCB0aGUgY2hhbmdlcyB0aGF0IEpha3ViIHN1Z2dlc3RlZC4gSSdsbCANCnJlb3JkZXIg
cGF0Y2hlcyB0byBoYXZlIGZpeCBmb3IgaGFzX3Jvb20oKSBhbmQgU0tCIGxlYWsgZml4IGluIHRo
ZSBmaXJzdCANCihvciBldmVuIHNlcGFyYXRlKSBwYXRjaCBhbmQgT09PIGZpeGVzIGluIHRoZSBz
ZWNvbmQgb25lIGFuZCB3ZSBjYW4gDQpyZXZpZXcgdGhlbSBzZXBhcmF0ZWx5Lg0KDQpUaGFua3Ms
DQpWYWRpbQ0KDQo=

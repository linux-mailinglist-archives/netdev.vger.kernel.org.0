Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C574867C933
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbjAZKyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbjAZKyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:54:03 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9288A5A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:54:02 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q531oE010627
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:54:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=YGG4qVaD+VH9Hhov5Y6YxBhmsGj4AJ6AeTrCc6Lx+jo=;
 b=Ku+6fiYUe3THUMRN2Av+gVlrgNuzOGP+OODx3OcI0M/vb0lKshXvUMSwwzMmb5eVgSMG
 8wHPLvN8Ojffo77xbeHZ2UxpIhcekKm05Xnnu92+OgusWhrtgb5Cg8k4lgz6GIe4pp6U
 B41eaDox+c8PzGRArJZSTpeRSEjpUIIH26TthTXKGzQQlbAYDSH97+RVNJmmXnu/jjvz
 OqI0Kpgy7UN+CFJLu4D2Zrbw8DyFzZma1oO8B3LgUqf25/Bme7DeUJbyDTGw+8AyzDXp
 nsBl71iOVoJxwkQgjYahPQAS2yuDaEz9nwA8QHnauqAu3S7rmxWCXINBE1e1IHD5VQo4 0w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3naks042b3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:54:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7bbf6ZTNQMgl3X5j26YnO+ti97KG6DrcwZRTuYrF+PnxKa+8tbQ4Lf53xVbXtqlKOz6/KTuuMKiUNFyyC/U/Ss1JLv/13UN7/45T3BmNoPasCjrM5A3igTDLezs/AQrxyYTD9O1GpJtXXm9rO0TQYSXhgjFoQaqEKLFyR1HdDhJ9fQIUYDaZlBVlN777ZHpd1l6cOKJcogrGFDM87g4TogDMsKOYRRxVgSLkcazDRCueMcwQNGN1RSw8l+1vFk6bLAsKdxnLiIqUEGm1bnouv9epHuAmTzgEAtUPqt+xSQ4Y9WY0OEgakx2u9MfX8hOOJjFJAVbUISd5lKzDdRJVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGG4qVaD+VH9Hhov5Y6YxBhmsGj4AJ6AeTrCc6Lx+jo=;
 b=JwSjhYDimHJufsQfljdpw3gw3/6qKY7Ekc7ZIapCdh9RtniR3Hsp2trugp2JGZeIIJwqILLTo/tCNS5tAeDy34gaMhKI6IB3iMEMHkgX7i/HofYUIszTy+ZXKHGcHQrebdFsixu7ri76PreB2J8AXzLLWDyEssMAOUbb84wzU2FJs/uTP3Gqy6m88ALxHYfftDK59XPJ6EOrvWu27yHFB730Aa3OKzCb7YyTJkyKsC8kKCY9bCFK7fUYs061qM5IwAeNP+WnyBzanuZboj3TVXdC76hRyMCwwiGBPaePQ4jqLtSXkEuhttwfT9CUEt9pBvD3BLGzI07SbE7rjJZZDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by PH0PR15MB4687.namprd15.prod.outlook.com (2603:10b6:510:8c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 10:53:59 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%5]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 10:53:59 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
CC:     Vadim Fedorenko <vadfed@meta.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Thread-Topic: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Thread-Index: AQHZMSVZ/wKsjo3Hk0CNBqczd82RF66whrKA
Date:   Thu, 26 Jan 2023 10:53:59 +0000
Message-ID: <45e34b30-71df-d4b2-98a0-d94519723332@meta.com>
References: <20230126010206.13483-1-vfedorenko@novek.ru>
 <20230126010206.13483-3-vfedorenko@novek.ru> <87h6wejdat.fsf@nvidia.com>
In-Reply-To: <87h6wejdat.fsf@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|PH0PR15MB4687:EE_
x-ms-office365-filtering-correlation-id: 7f1dc342-a7b2-4682-99d1-08daff8ba13c
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tYoMtsZ701O8jdKVCemr01L3VNI6CGE0mbpb+LT3dhTRgr3NZtW4V75Qt3MdRYeBKV3omBbtcHDPWj3fZEB3GlDemJd1J02xLjBhkZYoApbjiwMpDv3jqUNeWw4SRoTpSNG6/c/6Kuf8ifs0XzrWL2QulRFlOIFYokIAmWNB0xCFGJHssmQJ9chso2cL9h+e4Z0NghM7lo/UFxW/PYg1+Ey7c3fJoP2wyrG3y+O7vIaGzJ9L5q1wljfI1UDMluMC/4iQgaXw9zLb/H4vtZndboqaqy0MKw9NbreaXM8CLm2phz7hZEnTPO0O/XV8J8TGTXB3K1f5jNs7JYkgWByV4Y/8NiAD/Bn6/yARNCj2AHp60D46V5zhED0b+5Quhy5kUBU32RxyXwzqAiU1Lc1i2OGbUpxQEqco+2LwnMmEKo0XLUO+oLC9tvqUqHH1OYcB0QKd8AsPC+MVNlWmHfw9AT2+sO7B1hMaHvb7zZZPQL8Re2Kk7BsSCEtpKu4tgDbGLFfhB9C77U8N89nznuHApLu74BNE8KH5FmAyw4cOgDK41jA4vMZ2L6Hmxe3RQCJbnCEPzAoXZmQjyMhNHyfIMR+64cJuaWcDT0SACq6gOmkN8epgPYC4cqMGg3wRDaW+t7awuHVjKWBmlmPTz5wTuTfJeWscU9ijsWXXLwmWEy4BCE+s0FxINnlv1dEctNwmV2+FGRRsWljW9bndzQsCUsYhycUD3gzE4sFOL1Xnmv0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199018)(2616005)(71200400001)(4326008)(8676002)(66476007)(91956017)(6512007)(26005)(66556008)(478600001)(76116006)(6916009)(31686004)(122000001)(86362001)(38100700002)(31696002)(38070700005)(316002)(36756003)(54906003)(8936002)(64756008)(66446008)(6506007)(53546011)(66946007)(6486002)(186003)(5660300002)(41300700001)(83380400001)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDZvQ2Z0TFZDM1JuNm43bURnbWxSRm1rNFRNZGdpMm93TW9JQ0I3VWlFdEJq?=
 =?utf-8?B?UTYvSzV1V0lxcjJ4ZzZNWTgxZHNHLy96MnZyT2tBcHNRTTdVcnQ1SG10WjlI?=
 =?utf-8?B?OSsxaUkrdjVDZytmbCtsYVJTRVljUzZKR0tXSG16ZWdMQlR4QmVnUURENnA4?=
 =?utf-8?B?dDNDOGR4eUxrQldVdmozaFRycUlLazZtSDE5cXJ3R25vcVg5ak5uZ1hxY0lL?=
 =?utf-8?B?QkxKR1JKUk1RTHJmS0JDOXcwS2NYYkNMM0t6ZklnRVBRcTNkMGhPM0xlK0V1?=
 =?utf-8?B?V0R5eTVoZVpsaFBmOWNIVjVOMFJhZ1dvM3BDOGZkWHhxa2hqL2ZmWUJnZTUr?=
 =?utf-8?B?bkVEVmd2WmM1MUhHU0VPZ29XRWl2aVg1eVdYVEd3d3M2ZnRERGRYdlUrbXRH?=
 =?utf-8?B?RzRKRTVsTnYrWW9zTStUM1dEZS9UZHpCU01nT2hYZm8rMis4TVBGWi9heGJB?=
 =?utf-8?B?YUJCM3BNdDBVOXVVSldXdzRwMXRidTZsc1hLU0hxVEJ2eXBGUTJPbnowck9q?=
 =?utf-8?B?U3ZTdEJhT1REYS9yWTkvWnNlN1hUZGEvbVpmRlJINGY2VHhQakx1UnZBYWIr?=
 =?utf-8?B?TnA3cm9hT1FMclhheXJub3RGMkZDcmtoZjRQSXBrRHZGZjV2WGRwaTd6djRn?=
 =?utf-8?B?SnlFK2FrTGEzYkFxNUwyTmJnWm05QWNraUxrTEJHcG50bFArU0lsR2ZobGNT?=
 =?utf-8?B?MS9aWkl0STNFektjY3RncUxCZ0pvcDV2QkZRYk1MVk5RblQ5cjM3bjdEeXpv?=
 =?utf-8?B?NUJQYUNzTmQ3NjgzOENEaG1LcG4zVEYxNEtQQlAvaHF2VVBFdGlXUlRsNjc2?=
 =?utf-8?B?YmZDWGQ1MGdPUlBVMHlKakNFM3NBLzQyQlk2NHRPT3JGQ2ZqdDFiQnR5TjJm?=
 =?utf-8?B?dEc5clBMaDQ1OWRSc0hmR2o4OGU3VTJoSnluMXBUcDRIMkV1eGhGbUZWVmJX?=
 =?utf-8?B?U080c2NvcHNwN3NJYlhoUXlFZ2Y2ZnNscmVBdWRyQndnMm1wNzlWS3F4bStU?=
 =?utf-8?B?c2RMb3ozb0ZWakY4MEorSlZjMFl1ZGJORmNxckJSTmo0MXNKUmxDOFNqdDZY?=
 =?utf-8?B?aGJza1QzajdsTFJHTTdzcWJ0YVZESWx2YXExVUdEaXhnM0UvdVdmYVNEQ01j?=
 =?utf-8?B?Y3A5Q1VGRVY1Yll2RnRjY0FXNzQ0OWgzajlNV21BMDRvUXQ4cVkvT1NQVUNP?=
 =?utf-8?B?cDJ3Q0E5RmVIV1BPNytwMDlxK1l2OUQrMlE3QXl3MnJjM2ppaEczdU1Gemgv?=
 =?utf-8?B?ZE84MVQ2VU9IdWZvNEQwVjR4a0QyaGtqR0QydVdXODVoRnlCSmovZkhycEht?=
 =?utf-8?B?UXZHZ3QxS0JhbUd6YmVEemJtb0N4R3gybGFvVFc0YXRGcGVVd0V0RXJyYVZw?=
 =?utf-8?B?OE1QSlViWXBIc09TU3BUMjg2dWZvVzVYbWNaOFFLR0M0bzFpVUFxclp3aUdy?=
 =?utf-8?B?RlJCWjJnSTJ0S3VkVlNMOGtkeFBKOU9mQ3c4SnB1aDJ0U2d5bm9xTmpkOS9Z?=
 =?utf-8?B?UEtyTytCelZuUW96cFBmempwTUhmaUl6SUtvcWxpdld2c2szV2JIWlBzYTZx?=
 =?utf-8?B?NGNFK1gzcElIUXhhZ2lURVNVcUFYWStxSStOZkxXSVQ0dnI1TVpaZkVBVEZ2?=
 =?utf-8?B?NVE2NEtadnJHVTh5RFlGVnFibWhXMVAwR0duTERNdzFvTUVVWkVnRVZ2NVIw?=
 =?utf-8?B?SVBMOHdhamZmVUhtandYd2hVQjcwNWRBcG9FbVptcjRUUXlXaVNObFRHNnE4?=
 =?utf-8?B?TzBTR0VkOUFvOTBYK24zM2c3VDRheXV6aGc1aWhqMTUxNjVIaU14WVI3SjYz?=
 =?utf-8?B?UGNwR2xXZnBtNnBsaWZrVmMwUmZPMUZOVWNGbnppdkJQT1duU0tFbFd0bCtU?=
 =?utf-8?B?eUJUQm4rNEZnTGJpYitQWStkWEJEZTBsdEh0UWw0UVRHc3M5YWlWTS8wT3lu?=
 =?utf-8?B?NVVJd1FpRmp6R0FxTks5R1hOSG5PcUZUZjlqVmpneEljdkhHa3dTQmgwMEF2?=
 =?utf-8?B?ZlRJazcxNHNXY21uRTBTbmVsdmgzL1VUeUlNRHZOTExVY3hueTFuOFpJVlZu?=
 =?utf-8?B?NFhHZ1FDS0xVbzU4YVgvQlpvU2lGV28xcGRFaTRGQzV4Sm1jd29BMXo4anFQ?=
 =?utf-8?Q?YP3k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <621C557A5890B24CA4F4300C2D6A5570@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1dc342-a7b2-4682-99d1-08daff8ba13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 10:53:59.6830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BkIp038wPjk2hkR/y9780b+rXfVCM4VAaJiI/WLK1qkN1b6Os1vDsr0XeOG8AwtR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4687
X-Proofpoint-GUID: Zw4x6WTx-2_37GbFIX9hSuFxsNu9G7ch
X-Proofpoint-ORIG-GUID: Zw4x6WTx-2_37GbFIX9hSuFxsNu9G7ch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_04,2023-01-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYvMDEvMjAyMyAwMToyNywgUmFodWwgUmFtZXNoYmFidSB3cm90ZToNCj4gT24gVGh1LCAy
NiBKYW4sIDIwMjMgMDQ6MDI6MDYgKzAzMDAgVmFkaW0gRmVkb3JlbmtvIDx2ZmVkb3JlbmtvQG5v
dmVrLnJ1PiB3cm90ZToNCj4+IEZyb206IFZhZGltIEZlZG9yZW5rbyA8dmFkZmVkQG1ldGEuY29t
Pg0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4vcHRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4vcHRwLmMNCj4+IGluZGV4IGI3MmRlMmI1MjBlYy4uNGFjNzQ4M2RjYmNjIDEwMDY0NA0KPj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3B0cC5jDQo+
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMN
Cj4+IEBAIC05NCwxNCArOTQsMjMgQEAgc3RhdGljIHZvaWQgbWx4NWVfcHRwX3NrYl9maWZvX3Rz
X2NxZV9yZXN5bmMoc3RydWN0IG1seDVlX3B0cHNxICpwdHBzcSwgdTE2IHNrYl8NCj4+ICAgDQo+
PiAgIAlwdHBzcS0+Y3Ffc3RhdHMtPnJlc3luY19ldmVudCsrOw0KPj4gICANCj4+IC0Jd2hpbGUg
KHNrYl9jYyAhPSBza2JfaWQpIHsNCj4+IC0JCXNrYiA9IG1seDVlX3NrYl9maWZvX3BvcCgmcHRw
c3EtPnNrYl9maWZvKTsNCj4+ICsJaWYgKHNrYl9jYyA+IHNrYl9pZCB8fCBQVFBfV1FFX0NUUjJJ
RFgocHRwc3EtPnNrYl9maWZvX3BjKSA8IHNrYl9pZCkNCj4+ICsJCXByX2Vycl9yYXRlbGltaXRl
ZCgibWx4NWU6IG91dC1vZi1vcmRlciBwdHAgY3FlXG4iKTsNCj4gDQo+IExldHMgdXNlIG1seDVf
Y29yZV9lcnJfcmwocHRwc3EtPnR4cXNxLm1kZXYsICJvdXQtb2Ytb3JkZXIgcHRwIGNxZVxuIikg
aW5zdGVhZD8NCg0KU3VyZSwgdGhhbmtzIGZvciBzdWdnZXN0aW9uLg0KDQo+IA0KPj4gKwkJcmV0
dXJuIGZhbHNlOw0KPj4gKwl9DQo+PiArDQo+PiArCXdoaWxlIChza2JfY2MgIT0gc2tiX2lkICYm
IChza2IgPSBtbHg1ZV9za2JfZmlmb19wb3AoJnB0cHNxLT5za2JfZmlmbykpKSB7DQo+PiAgIAkJ
aHd0cy5od3RzdGFtcCA9IG1seDVlX3NrYl9jYl9nZXRfaHd0cyhza2IpLT5jcWVfaHd0c3RhbXA7
DQo+PiAgIAkJc2tiX3RzdGFtcF90eChza2IsICZod3RzKTsNCj4+ICAgCQlwdHBzcS0+Y3Ffc3Rh
dHMtPnJlc3luY19jcWUrKzsNCj4+ICAgCQluYXBpX2NvbnN1bWVfc2tiKHNrYiwgYnVkZ2V0KTsN
Cj4+ICAgCQlza2JfY2MgPSBQVFBfV1FFX0NUUjJJRFgocHRwc3EtPnNrYl9maWZvX2NjKTsNCj4+
ICAgCX0NCg0K

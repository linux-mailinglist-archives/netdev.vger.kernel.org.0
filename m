Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714844C0B66
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbiBWFJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiBWFJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:09:25 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0299059A53;
        Tue, 22 Feb 2022 21:08:56 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21N2ZF6w017173;
        Tue, 22 Feb 2022 21:08:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iwf6+YLbs4Bw0Ip6tn3c8fCl1njsG8Oa3xMrOeR7GoQ=;
 b=GLbcgDfFT8RYxRLnFMF0GTcKxOqYLEeMQlSTxtPq2+rRQbqBQipchC86xzNOZ7Usfo8j
 /9clz8gCsmRtCuI5nmiASTRKiRN+WAT9Baky2ieRZgOu76WbmhlwDYF4LedJ7chKY9vr
 NShXigbNcNFhp81fZrytXdP7P8zOodJKWmU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3edbfxguj3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Feb 2022 21:08:56 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 21:08:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLdWDqM9d5f4KH4XsoLoehM0+Y/Hgp2wri6xDxfLizsvCJzPsNjQ8w3Y3RyAn3wsNuCGPucR99fZ3GXbqWJvod25ewtsLJ02/eDLzbmpR0BaJHO0Ab9C7bYNc97Os5FbfZKsjg55Ari8v+DbXq+bddRGIJkhXIzf8KCkpEIlbb4Rj4LSg5b64W794RX+DgLG7LBfxIaJMJsr6IsGzbCFwZhxK/UY4+p1+An5E3Zxo+BCtZa6DWawjBB+z4HiKRJmxPyJkBcUo2i+5wWK8IYZ3Tn/YfDqswa7pbjRJHkpP+E8ed/833IykNTb43v/jSbb5UYS6xzGKndW2EB2iaU91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwf6+YLbs4Bw0Ip6tn3c8fCl1njsG8Oa3xMrOeR7GoQ=;
 b=eDlEOQSGzFjvVXvF40XNJARczTUhydjtuBvji9q+HHAHomBpgYkR7MUM4B9fgIwjJFN7LZmasBLbV5l3mr306dW6QHWhMQd4I12Gx97Eu81g3gtuvxRxNYgqXFX2kLFdw/eOHbIfQBHRnM3btnLsgCnz4XU486GXzpQPbnt125XVXqWiC3FctnxeZiOuKqs4AJk5ZkNNzS1OO2jeR2BENWRm5ONuG7Tm5zwAyEmfG3OraplKK1DHJ2ceNCSITX49aNQIY011YL+HIEzXqXFZOY2L9Q5NldSAVLjf1PBzneT2+LfdNNcQVIFdAjWInmf+0VDfJ8vdW0QbvZuOiMbW5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5000.namprd15.prod.outlook.com (2603:10b6:806:1db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Wed, 23 Feb
 2022 05:08:53 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%8]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 05:08:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
CC:     Connor O'Brien <connoro@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?TWljaGFsIFN1Y2jDoW5law==?= <msuchanek@suse.de>
Subject: Re: [PATCH bpf-next] bpf: add config to allow loading modules with
 BTF mismatches
Thread-Topic: [PATCH bpf-next] bpf: add config to allow loading modules with
 BTF mismatches
Thread-Index: AQHYKFTRvx/TaYH4IEiFVTU1LlXB1KygjJoAgAAJo4A=
Date:   Wed, 23 Feb 2022 05:08:53 +0000
Message-ID: <EE57D385-9144-407E-8DC5-0DFF76CC2200@fb.com>
References: <20220223012814.1898677-1-connoro@google.com>
 <YhW5UIQ5kf8Fr3kI@syu-laptop.lan>
In-Reply-To: <YhW5UIQ5kf8Fr3kI@syu-laptop.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a57c173f-1ea1-4bcf-51cf-08d9f68a965c
x-ms-traffictypediagnostic: SA1PR15MB5000:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5000453E07E05DB918CFB113B33C9@SA1PR15MB5000.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SsysahI1u/pEdHd1fRhcHwRKFmgIkqBYO01hVs6o5pCYEG4m0EmQxMB/+LQap988XJpA0y1t5RV0+ShgE/ckvTLbVkob8pNslrtEQuOR9dz/ddBSxcmcAQRsl/4a33ioA/lZ+ga2r7UzYwj27ywH3CO2Ru+BcVEWZytRIUafTiAiG3RZkiktPcZSyuEW1t2lSBYOuionlYlheqRUs7u2WLwW5ep3VfsDfB3VQ06ZxHLEZBAsxcj5cRwSOx9yPhdsKNlN4ONnAgRNET4khE3YoRDJwhWg80G6delnBHOIHN7vMXaYo9V00AXqddxybEm8pB5OGdJiCVikoaRvyjgmeQsQbAOI1OvV4iWrn2KR881yZHWy3K5mK/7GTW8S9BRkazhhBKsAxVHMqaJ+CHRo/zm4utjFHfVQhZT7Tbg6uIdypriFJQlyEWYi/DrWueC9wBfdn+MZXAMCi5J6t5PG8k/HxG+Sn7k+qYhEzHQN5LfdGxQCHhtnJuFLZgwLcIuuBppSGU0iETmrVIslVYV3cuNTUJlClzE/vmrnrrcMI7L778J6ajiZNML98Fb0cEYvSu2M9xfGV0lZtHM97BtxL0dPIuc2TbQ8lBAd+iX3uqaXeOLCy1sfvm4PbEOqQ+pZeXfFHcZa+locOISnARTToKlO3GbmCPyjHBfQC1ZhOGeANSCHXRlUHJpgqd2UBpJ1U2YYEt5v7oFfKHVTvpw5WHlo+sqN5Or+59x0HwNCkcgRrrRXexWe9ykF/Yzx1Ss917WteETV26/L9r4zarQBo3vCEvS//euvXblLlWxQbmhmhMnJ1+E/XvvTFDkCqkl+5g2refOR5CANBRrsFFnBgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(71200400001)(2616005)(5660300002)(6916009)(86362001)(36756003)(54906003)(7416002)(186003)(6512007)(66556008)(8676002)(33656002)(122000001)(66476007)(66446008)(64756008)(2906002)(91956017)(4744005)(508600001)(38070700005)(4326008)(76116006)(38100700002)(66946007)(966005)(6486002)(53546011)(8936002)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2lWN2FMSlMxcVNzckNNWHRkdmYxdERSRUFRMjB1MTY4YkpnMXFLYy9zRE40?=
 =?utf-8?B?cEZTRFM4bVIxS0ZIajZpajNNcUxvbXBrQ0lpYXBLSlBPdjRNUzBCWWdWZGFl?=
 =?utf-8?B?WlV4WnlMUll0L0gzMVRpNGVzc0FVSW9xY01lQUtKN1BGbVFPZm55OVJyS2NG?=
 =?utf-8?B?MkxHN3ZWRkxFWUhQR1B2Q296MThiSExzc0ZhcnpkZ0dBRzV3TjFXR2FzZHEz?=
 =?utf-8?B?SlRuVUFkMGo4bTEyUERhd3VqMzBTQ1hoNVZaclpFdkU4SmhNZzhES1RSY3hY?=
 =?utf-8?B?ZlBCbDVlUkdpUnAxeWZIeFBRcDVYR2NTbHZmL2pyTnN1VXFLZlJ3M0krOExP?=
 =?utf-8?B?VUt6azBPV2R5Y0JKVUh5SCtSRCtoT1ZDemRFQWRtU1B3VGQ4eGptWnJsS25u?=
 =?utf-8?B?SVVGSHl1UzNVd0llODNnc1d4U2lhaC9JZE95U0Jua2NlZVp2d1QrQjBUNDc3?=
 =?utf-8?B?MVlhaEwxV3JNWjJsbldPdll5TmZwd3A0d0xyZHYxUGt5SXBHcm9xQnFWY0Vj?=
 =?utf-8?B?REdnM1laTm9mT1RoaUs3OGEwRk5sdTZzM2E4UGVtODNWcGpJVFlUdHpxWWRT?=
 =?utf-8?B?M3FhYmlUMVRRT0RiZTcrN2pRQ0JpQ3VYU085YndmNTlJQy9ZeGpSd2NNd1lw?=
 =?utf-8?B?Ym9Wc0dOeGsydUdicVZ0aDZ5QWVVTjJCZUJzS1cydHNQOTFxNWt1SXNGaW5V?=
 =?utf-8?B?L3BocDlvTFIzL3grS0FEcTBWMUZYZCtCWWl3b2V1WU15UlFOL2RWT2V0SXpl?=
 =?utf-8?B?MnBkejNub1QrSVQxbHRCLzZPSjViWmR5UmN5c0UxaGlVK1h2ZjRRR3QxZzN0?=
 =?utf-8?B?QVZRMXR3WHRRaEhUenRPR2ZuOHZTbE5WR1NPR0xCK2lSN3pOQlFOQjJsaUth?=
 =?utf-8?B?emhaUFdZQ1lNcGlveGQ5UVdrbDdNMVEyemRUSGtWY3VGZzdRYWZUUlcyYzRM?=
 =?utf-8?B?MTFqcnRaNjhUTzVWUVlxVjBUajBmTjFWS2tYWmRLNFNBR2RhdmVpelNaTG8r?=
 =?utf-8?B?NVM5bmFPYW9MTHFyZ1cxTnBCQnIwZTNmUGJ6OVpqdzFROTNvT3lzakFpZ3VS?=
 =?utf-8?B?ODZkOW9ZNzN1clRmOTl5UmFPVWVXMVBYaDRPazJtQ2t5c1hIK3dBczVIUGV2?=
 =?utf-8?B?aUg1QWVFb2tWRGVXaGJBNnVJNlpyZUMvT2lPalVGUkVHKzl6UE5GY2Y5Rnlq?=
 =?utf-8?B?RjJUNkRnY2JtMHFrcmhXQVJiYitOUUFQREJ3ZktjekFIdGlBSzJmcnNPK3pw?=
 =?utf-8?B?TVhiRG9JbStENHFFZnprZ2hEVHlOZUFJRnFPOXl4dzlkNHJiNk9Ta0QwdmJH?=
 =?utf-8?B?ZEFnWG1OTzNMcXkwbnN4Zkk3S0dTcGp3SmlyM1h0RkRKWkZ3c0dmTy8vamdU?=
 =?utf-8?B?dFRJS2tLendHV0lIUW5BaEsrMGhoaHlJdEZ2QU53SmMvd29mOW00UXV0M2lV?=
 =?utf-8?B?dXF0VVRzcFpKRTdzNzBSRi9aTCtrbnV1ZjA3YVp3L0lxU3VIK1c5SzJjaWZq?=
 =?utf-8?B?OWVSbEV2MkRjK25PVG9ld3ErZU50dlIwRXQyOGdnUVdueklRMTdZaU9qU09r?=
 =?utf-8?B?M2l3bklvdkkwck50eTM0a1FKUkhWQ05GdXhUN0YxdWtsSGRIdUhzSmhXL0F6?=
 =?utf-8?B?YWpLYzZIOE5nMzdYdUF6ZEgyM1A0K2JkajBzV2ZVaVg1WlBaNGNmNmNvK2Rt?=
 =?utf-8?B?Sm92V25DTzV4TUJ3YldVcUdzM1ZyNEJUd2crcUNmdTEyaGlLb0dUWkxObHI2?=
 =?utf-8?B?L2Nia2RQZDVDMW1XUzRUTGFuS2djSUhwMWszR3UyZWRyL3lLeU94d0NSMStM?=
 =?utf-8?B?MG5mZGVsSEd6S3pVeGNxWVJEMlJ6ME1SWC9HYXB1RzJPSE5TMzlJbGlQRnlC?=
 =?utf-8?B?MlpzNFhuL2ZsaThJdStFaGhFc2k2M1VYMlV6aGNBeUJEYU9BbDc4dEtmbnhx?=
 =?utf-8?B?eWVaR0JxTGd6VUI4SVZsOGM2aGZOMHJXY2hIRDNZanJGcWRSWXNWSjd3a3pL?=
 =?utf-8?B?WXlVbkI4V2NGOUk1TzdFbkEvNlRINlJSVFkyYkdiRk14WnV1S2QxZUZLRy9h?=
 =?utf-8?B?MC9SdUg1L3V2a1VYdDE0ZEZ0MUJmSGkwUmhYY3h2bnhrRGR6SHNHUXRoM3JK?=
 =?utf-8?B?VWwxdCtNclFKM01LUmlMNHo1dTQ5cmZ3UUIvcGgwb0dlTml2VlM4eEFGSlo3?=
 =?utf-8?B?bzY4RWE4WUhzYStqbTFaZXBSOFZIYlRGaGxlZHVJQ1d6aWp1K1hoZFRLN1R0?=
 =?utf-8?B?ZUpiU1JWU0lXQ1EyTWJ0cVlIeGR3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7E386842B1A3348BB4F3F29DCEF0165@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57c173f-1ea1-4bcf-51cf-08d9f68a965c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 05:08:53.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+DZ3OXSulGhfABkhWbNlHwL88psxe4mJQ0C+xCJSxUv8w74P73uFAnh1yjghzBokmTemQaUpwU/+Z89EiBn4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5000
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: goQadSDC4ZslwwBnq6PpN6hdXIR59Um6
X-Proofpoint-GUID: goQadSDC4ZslwwBnq6PpN6hdXIR59Um6
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_01,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230026
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gRmViIDIyLCAyMDIyLCBhdCA4OjM0IFBNLCBTaHVuZy1Ic2kgWXUgPHNodW5nLWhz
aS55dUBzdXNlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIEZlYiAyMywgMjAyMiBhdCAwMToy
ODoxNEFNICswMDAwLCBDb25ub3IgTydCcmllbiB3cm90ZToNCj4+IEJURiBtaXNtYXRjaCBjYW4g
b2NjdXIgZm9yIGEgc2VwYXJhdGVseS1idWlsdCBtb2R1bGUgZXZlbiB3aGVuIHRoZSBBQkkNCj4+
IGlzIG90aGVyd2lzZSBjb21wYXRpYmxlIGFuZCBub3RoaW5nIGVsc2Ugd291bGQgcHJldmVudCBz
dWNjZXNzZnVsbHkNCj4+IGxvYWRpbmcuIEFkZCBhIG5ldyBjb25maWcgdG8gY29udHJvbCBob3cg
bWlzbWF0Y2hlcyBhcmUgaGFuZGxlZC4gQnkNCj4+IGRlZmF1bHQsIHByZXNlcnZlIHRoZSBjdXJy
ZW50IGJlaGF2aW9yIG9mIHJlZnVzaW5nIHRvIGxvYWQgdGhlDQo+PiBtb2R1bGUuIElmIE1PRFVM
RV9BTExPV19CVEZfTUlTTUFUQ0ggaXMgZW5hYmxlZCwgbG9hZCB0aGUgbW9kdWxlIGJ1dA0KPj4g
aWdub3JlIGl0cyBCVEYgaW5mb3JtYXRpb24uDQo+PiANCj4+IFN1Z2dlc3RlZC1ieTogWW9uZ2hv
bmcgU29uZyA8eWhzQGZiLmNvbT4NCj4+IFN1Z2dlc3RlZC1ieTogTWljaGFsIFN1Y2jDoW5layA8
bXN1Y2hhbmVrQHN1c2UuZGU+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDb25ub3IgTydCcmllbiA8Y29u
bm9yb0Bnb29nbGUuY29tPg0KPiANCj4gTWF5YmUgcmVmZXJlbmNlIHRoZSBkaXNjdXNzaW9uIHRo
cmVhZCBhcyB3ZWxsPw0KPiANCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmL0NB
QURuVlFKK09WUG5Cejh6M3ZOdThnS1hYNDJqQ1VxZnV2aFdBeUNRRHU4Tl95cXF3UUBtYWlsLmdt
YWlsLmNvbS8NCj4gDQo+IE90aGVyd2lzZQ0KPiANCj4gQWNrZWQtYnk6IFNodW5nLUhzaSBZdSA8
c2h1bmctaHNpLnl1QHN1c2UuY29tPg0KDQpBY2tlZC1ieTogU29uZyBMaXUgPHNvbmdsaXVicmF2
aW5nQGZiLmNvbT4NCg0K

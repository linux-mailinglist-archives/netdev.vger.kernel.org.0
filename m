Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3096066D6
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJTRPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJTRP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:15:29 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F08016D572
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 10:15:27 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29KCqjA4003924;
        Thu, 20 Oct 2022 10:14:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=Ai6wyScNpuy8C/pNY5Uuy68SgC/bJCwHem2g8kCdlVg=;
 b=j/ki9KaXf+VWpJkCdNbvbIe7gfPtCR6LNvs1DD+Trju2ysrYzdVKp+88wIVu0F5dVr3i
 Xlx3ov1KxPMJwCKSCA1f9ZS0A4qm4G+m+JPotJvGzWFXxWA9jILTXZ6zjxHMThiC0TPs
 3wyL8nUGljVOQuiqsnPx8bRPD9wjRzL/P8JthmGtl2Xyhix+CJp06c+bK83RrODkTv8k
 T8HS8WFxY/x3z4IDI5ElcjZwNoZSZTVpMSHOs9u8TNuGXtXFTtMj+TvuRz4vEHMfkH60
 2/t36vqem7opFE/x1bU+RFvDuDyOrZv2/gNSN6SLtuZJ+XTk90bYKJu2KTzGtJql+EXa Jg== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kavuu8rev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 10:14:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvsmhqGDR/btJxjndu8XqyOcS6/F5QvV1yMocu4JT5l437cW1pVmHdZwEI1/BlFVyTtp0qDNlTg1DyTFDeuY0/3PSUrMvKJnaC7U1Cl7QxdRVNBzcc3JKyt2/hTkPHShq5rXGmRt0/raaITrd82XjkQJG/E4iZyZyTZFMg+Wm7Y8yW5KKMHiYiJHrJukef+blXXcAx04+5gpAAAA514/tl0U/8WGfYR5uQ/J9cCC6xUKJYeuV4FZ6kwhSnszK5/bzj7WEXXGv+5u1Ka6VFy+xEyw7aPXMiz6nRoj3sCqRPr7FY/R3WiZ3s2HmN1AuhH9nPfsLPgvQW8yLk9QXFp3HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ai6wyScNpuy8C/pNY5Uuy68SgC/bJCwHem2g8kCdlVg=;
 b=HaAKoAtCDUVqnx5MA4IXmXh9HxHR7AfurYGLDMa8Gjar7ZtWKl/vmf0IMygH28bbFpwqyxjWNmPiGpZ//LBK1mK4lVgAZT8/5tIQYXe7QfKONJVi1vTin6rNTzjwP+RiiPvV1VJ0lntG7KrtSgiJMLOlBklNnOo3Vr5jI84T7Uhy5XXo8lbLZXt9YcEL1OsM7fzcPJJqNRGaA4Ar4nUrPkSifOQilJNfO9oiU12lhuD4iA8hq8VAEUNj1wq3uzzXzBjCG7LusFkHx6TeSL4UV/ENtpCOdC2EG0oJnCOzpttuLLUzX0rvRwmtcyKf4JUnyIAyKTdHKxj1mUQWZfTpyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CO1PR11MB4900.namprd11.prod.outlook.com (2603:10b6:303:9e::8)
 by IA1PR11MB6490.namprd11.prod.outlook.com (2603:10b6:208:3a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 17:14:42 +0000
Received: from CO1PR11MB4900.namprd11.prod.outlook.com
 ([fe80::dbb0:c503:a8bb:effb]) by CO1PR11MB4900.namprd11.prod.outlook.com
 ([fe80::dbb0:c503:a8bb:effb%6]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 17:14:42 +0000
From:   "Beckius, Mikael" <mikael.beckius@windriver.com>
To:     "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Regarding "xfrm: Add compat layer" when running arm/arm64
Thread-Topic: Regarding "xfrm: Add compat layer" when running arm/arm64
Thread-Index: AQHY47Al03x3zWG8tUy9fHmscZelUQ==
Date:   Thu, 20 Oct 2022 17:14:42 +0000
Message-ID: <CO1PR11MB49005592783CCBFA2395A968922A9@CO1PR11MB4900.namprd11.prod.outlook.com>
Accept-Language: sv-SE, en-US
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4900:EE_|IA1PR11MB6490:EE_
x-ms-office365-filtering-correlation-id: 765c3d3e-e09a-46ae-904b-08dab2be942a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1l8wqDuN9ref1kEMlm7wSWL66OkooB7EKwMhbFRoQ9iqXu6l8pg7+kRxobOQtobYjXOiQhlBqVKKNJSwGeq18VdScq1uGGvbwbEFtSgIXox1Ra+lJ9EK8EI+CbE1R7Um/5yxaBfLpfM08XRWGkCVAJ7cLeOUBlI0UwA3A0hZCTOYC4X/BANyxenw+ePX4tug/EkpSY90o6Ny42mFGLOR8afoSuDZb0PF8wSm5yB4acYIwCHiza7v6dHD6mNSnxY2GAPV9Q1Ei7UO2UVLI/BFt+qFhrlyadLSFehAdrxp837fGXj2cIMF9FDNC2RKvVS4D4PbKqAMvuKMB9MngMQxchjyvZDqTKOHHUE91NRmBeRFpdJXUrtvFYZO0BpHhn9foDI7CJbhWPcRVZAs3/7EYGH8+13TOLXbIxRUrhGqtVZKYZGOwoyMlO5CpM3DvNYEcsbjq4KI+QVHUh3Ki1nAvQEZ9DEoTG+bE6/s/KRKKmtFIBrXDdob1R7YyoQdfijy2OzEUyIM5sYIIUqfvcB+pf2Sl5hrLHn77tIndPp05s0Dp5Gtwi7+mMfGIxtHmJ4sWg4f9uzKvDcayIFa9tXtiSoe1NRRAO/76FhRw9pmsBgJeHpYyPJzYKTPvDIgnkZO1wc8joDYEdudjH05wTMrMs1dM3r8Ysx2lgQJAQfpNk+tqaFd7TT3shO++s98SnzUb3UFpun0xFg7oOY/7ZGhEE2emPZtRPYsOpcFvZlR/dcmeEbZ/t1l3ohG102pKvnEkZ09mc4rXa2iJmg1whPQcrqzSbfywQ3wnq+EdckKHI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4900.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(451199015)(33656002)(86362001)(122000001)(38070700005)(38100700002)(2906002)(7696005)(83380400001)(55016003)(26005)(5660300002)(6506007)(9686003)(53546011)(186003)(66476007)(41300700001)(316002)(478600001)(52536014)(64756008)(66556008)(6916009)(76116006)(66946007)(4326008)(8676002)(966005)(71200400001)(8936002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGgzQVpDZE5TRjkyU253ZmVtRlRESHVhTERtSCtwVzQ0MnZXVExNYTBFK0do?=
 =?utf-8?B?azI0MEZtRDhpelJRbUNjWVhRTzFUVVlLdWJVcFB6SEw1c3NWNFFNV0h5cEpO?=
 =?utf-8?B?ZVdvSzdFMXJmVEs4NDFMay9zeklHbFo0TlkyQVdVSGZqbkh5NkRsM3lrcUh2?=
 =?utf-8?B?SWZ0TFpOeW5VWGdnNk9OS3p6UWVrQmJjUnh6OGliUzB2amk3L25PTERqWVht?=
 =?utf-8?B?VW5EWk5md2x6RE8wamRiQ3BJMXhCY3Z0T1JvWkpNUmxjT3FQWmhsWnlqWVIw?=
 =?utf-8?B?dVpBZVF6bGtsdGdPaE5GS1ovREtyUitEZGZ1cU04bzJ0akw0eXZWd0FPc3RY?=
 =?utf-8?B?dU9qV0YzYm5NR1FrMkliNjR1Vi9UeVlJSjlxTkc1cTI2UERpNXFWTmlsNTdq?=
 =?utf-8?B?bEZTWU5FYkx4Nk0vbGhxdnVlMjN4R2NuYUFYYm1sMXhYVW13dE0yY1kzemtO?=
 =?utf-8?B?YkdjVkJ4QmxyZVMwc0dpVlJaRUY5Z2RaTGpydzV2VGtTTVo4dlcvNFkrQ3Qw?=
 =?utf-8?B?TGlUQ0tnTDAyS3NCY2cwd3IwWHJXa2dGbEJuOXI5aWJQQjhHWVhKYXBlZGYw?=
 =?utf-8?B?UElXYnd0VndJNWQ2Q1FMYzBUeDFCRjlCbEp2UG41WW0valhuK3VQdkRXbGhG?=
 =?utf-8?B?SEZkOVJMeXgzZVNGUzA5d1lncHJyQ3JTRm1EYWQ1TVZQZThNWUh0MndmNStT?=
 =?utf-8?B?ZTh2M3BNNWhzU1RQY1FKYS9mNmovUHRPVnVrNi9iVEJpOU51YjFGYWphSWQv?=
 =?utf-8?B?anFkbnBTOEl3amZGN3RwK1V1TjNnS01RZzVKYTloa1RwZWdCNzVXSllZSFV2?=
 =?utf-8?B?S25Zb2ZWdGpQY3ZQYzh2a3JtbU9KYk12RHZLazZjM0pleWM3b05qMlNYamcy?=
 =?utf-8?B?a2ZNTkM5ZDZhb1UyV2xZS1dQRzVXaTJoS3hlUXZVVmJLdVdYajNnNUZJbk5v?=
 =?utf-8?B?TUhSb29KM0c4WXVYK1RwNnM0eUNsOUsrZ3gvU3dzVjBraUl1RE0xS1E5UUk1?=
 =?utf-8?B?aHQ0ZlNSL0oyVFE0ZVo5bHBBai9RMDZ5NmZRRFRzeEhnUXVUaU03Y2NZdGVv?=
 =?utf-8?B?VGdJSWR5K2E3Z0dCcXVQZGdrR2ZDVFhjd0RrU05aMkprVmx6cDcxSm4vY0g1?=
 =?utf-8?B?TFBta1pDT1djSjdaZVRuOWVTQklYYzZGMW10Tmtwdm14bWlRazNJb1VqQ28r?=
 =?utf-8?B?c3p3WVdKTkhSMkEyVXBLdTdZTkVSWEJpT1FDKzBZcnh5Q0F0RFVxVHJQcnRm?=
 =?utf-8?B?c2RWS3RjU1BsQVVCV1ltcEtsUWpZZ3hndzVVNkNkclBIbHFnY2lYUDlLcFlO?=
 =?utf-8?B?WWlteWJzeVZjanRzSHJxK0xRYVd2UllzM01DNVV3SzNTVlVVdkhsRWVFQjU1?=
 =?utf-8?B?cnF4YTlLdkNZYlI5QnVmbGE4UmF6ZWJnUGRkb2JHcTJMMVU1QmlYZ09kQmpk?=
 =?utf-8?B?djVPTWZnSm5rZnZGQkNFZ3M3M2l4cmgvZnBxTy9uWmpvZk82RkhDNng4MjZW?=
 =?utf-8?B?c0NGWjd3R2RzODE5cWJBVlhpTk5FejNhM1k4b2UxVXdsbWZWUnVqYjExTEFv?=
 =?utf-8?B?QkVwQnJiWUpuL2o1RDhxUjVLWENWMm9NNVlTcVVTdkx3eTNLNWRFWHpSa0pr?=
 =?utf-8?B?V1hxbG9CZytya2RQZlVoWFlZN255MzNGN0FRR0RaZEVwUmZKdGhMUE9OTVUw?=
 =?utf-8?B?U2ZjY2xGQXZpQVBtVjBiVW4xTlhBemFyZDQrSWpmdjhMVVpFc3Z3ai9aeVFv?=
 =?utf-8?B?YlZnQU1XbkxiKzR3ZlRvaVhUMDRsNFliQVJqN05CZEFBZXc2NHFsVTYvV3FU?=
 =?utf-8?B?eDZkbGhSZ1JNTndCaFh4Qk50SlZBdEFhSmt4N2hYdEZlbXgyd0JBbTVocmls?=
 =?utf-8?B?UXBsTklDeGc1eWhoblE5NlRBWnZGek45OWsweEQwSmtUOVZvRzNKWXh2Nk9C?=
 =?utf-8?B?d0Q5WjhwcmVOUk9KRFVzS1VZVXFEcmw1ZFE1eFpOZTdWcyt4ekpRRzNtdlpt?=
 =?utf-8?B?dlY4NCt3Z2h1WGppcTc2Y0diNmlyTWdxTjlMTExMOEJWbnRZVlpVekhVZGd1?=
 =?utf-8?B?anR0eGxqSnpZL1E0S1dSV2ZtS1J6MDlPb21LS2tiZTRzajVyZjRGZ1VIRkdB?=
 =?utf-8?Q?irrANgqTTPXeuiZTTWDvSxrgg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4900.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765c3d3e-e09a-46ae-904b-08dab2be942a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 17:14:42.5538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: koKCqbbEmUw6PO/vn6uWJEJy+oNy+Y07yfGWwW+RlPpXdzpd3l/Ku/Et6ahLX276QpWJ4R84cK8xtL9NmqTVE51WY6GPmnlMeQbcGTEUM7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6490
X-Proofpoint-ORIG-GUID: z_Ck2v7TUUGD5baZkG97PxwqSBu-xwF_
X-Proofpoint-GUID: z_Ck2v7TUUGD5baZkG97PxwqSBu-xwF_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_08,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=785 clxscore=1015 mlxscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210200102
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVnYXJkaW5nwqAieGZybTogQWRkIGNvbXBhdCBsYXllciIgZGVzY3JpYmVkIGluOsKgaHR0cHM6
Ly9sd24ubmV0L0FydGljbGVzLzgzMjA4MS/CoEkgYW0gdHJ5aW5nIHRvIHVuZGVyc3RhbmQgaG93
IGl0IGlzIGludGVuZGVkIHRvIHdvcmsgd2hlbiBydW5uaW5nIGEgMzItYml0IGFybSB1c2VyIHNw
YWNlIG9uIHRvcCBvZiBhbiBhcm0gNjQtYml0IGtlcm5lbD8NCsKgDQpJbiB0aGUgYXJtIGNhc2Ug
aXQgYXBwZWFycyB0aGUgc3RydWN0dXJlcyBoYXZlIHRoZSBzYW1lIHNpemUsIGFuZCBpdCBhbHNv
IGFwcGVhcnMgdG8gYmUgd29ya2luZyBmaW5lwqB3aXRob3V0wqBDT05GSUdfWEZSTV9VU0VSX0NP
TVBBVCBpZiBhZGRpbmcgdGhlIHNtYWxsIG1vZGlmaWNhdGlvbiBzZWVuIGJlbG93LiBUaGUgcGF0
Y2ggaXRzZWxmIGlzIG5vdCBpbXBvcnQgYnV0IHJhdGhlciB0aGUgYWltIGlzIHNpbXBseSB0byBo
YXZlIHhmcm0gdXNlciB3b3JraW5nIG9uIGFybS9hcm02NCB3aXRob3V0IGN1c3RvbSBtb2RpZmlj
YXRpb25zLg0KwqANClRoYW5rcywNCk1pY2tlDQoNCkZyb20gMTVhZTAyYjQwZDBlMTQxM2FhYWU0
ZmNjM2NjZWFmZDliOTM1NjI0YyBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDEgDQpGcm9tOiBNaWth
ZWwgQmVja2l1cyA8bWlrYWVsLmJlY2tpdXNAd2luZHJpdmVyLmNvbT4NCkRhdGU6IFRodSwgMzEg
TWFyIDIwMjIgMDg6Mjk6MDAgKzAyMDANClN1YmplY3Q6IFtQQVRDSF0gQWxsb3cgQ09ORklHX1hG
Uk1fVVNFUiB0byBydW4gb24gYXJtL2FybTY0IGFzIGlzDQoNCk5vdCBzdXJlIGlmIHRoZXJlIGlz
IGFjdHVhbGx5IGEgbmVlZCBmb3IgYSBjb21wYXQgdHJhbnNsYXRvcg0Kb24gYXJtNjQuIFRoZSBY
RlJNIHN0cnVjdHMgaGF2ZSB0aGUgc2FtZSBzaXplIG9uIGFybSBhbmQNCmFybTY0IGJ1dCB0aGVy
ZSBtaWdodCBiZSBtb3JlIHRvIGl0IGV2ZW4gdGhvdWdoIGFsbCB0aGUNCnRlc3RzIHBhc3MuDQoN
ClNpZ25lZC1vZmYtYnk6IE1pa2FlbCBCZWNraXVzIDxtaWthZWwuYmVja2l1c0B3aW5kcml2ZXIu
Y29tPg0KLS0tDQrCoG5ldC94ZnJtL3hmcm1fc3RhdGUuYyB8IDIgKysNCsKgbmV0L3hmcm0veGZy
bV91c2VyLmMgwqB8IDIgKysNCsKgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCg0K
ZGlmZiAtLWdpdCBhL25ldC94ZnJtL3hmcm1fc3RhdGUuYyBiL25ldC94ZnJtL3hmcm1fc3RhdGUu
Yw0KaW5kZXggOTFjMzJhM2I2OTI0Li42Mjg0NTVmNmUxODAgMTAwNjQ0DQotLS0gYS9uZXQveGZy
bS94ZnJtX3N0YXRlLmMNCisrKyBiL25ldC94ZnJtL3hmcm1fc3RhdGUuYw0KQEAgLTI0NDIsNiAr
MjQ0Miw3IEBAIGludCB4ZnJtX3VzZXJfcG9saWN5KHN0cnVjdCBzb2NrICpzaywgaW50IG9wdG5h
bWUsIHNvY2twdHJfdCBvcHR2YWwsIGludCBvcHRsZW4pDQrCoOKAguKAguKAguKAguKAgmlmIChJ
U19FUlIoZGF0YSkpDQrCoOKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgnJldHVybiBQ
VFJfRVJSKGRhdGEpOw0KwqANCisjaWYgSVNfRU5BQkxFRChDT05GSUdfQ09NUEFUX0ZPUl9VNjRf
QUxJR05NRU5UKQ0KwqDigILigILigILigILigIJpZiAoaW5fY29tcGF0X3N5c2NhbGwoKSkgew0K
wqDigILigILigILigILigILigILigILigILigILigILigIJzdHJ1Y3QgeGZybV90cmFuc2xhdG9y
ICp4dHIgPSB4ZnJtX2dldF90cmFuc2xhdG9yKCk7DQrCoA0KQEAgLTI0NTcsNiArMjQ1OCw3IEBA
IGludCB4ZnJtX3VzZXJfcG9saWN5KHN0cnVjdCBzb2NrICpzaywgaW50IG9wdG5hbWUsIHNvY2tw
dHJfdCBvcHR2YWwsIGludCBvcHRsZW4pDQrCoOKAguKAguKAguKAguKAguKAguKAguKAguKAguKA
guKAguKAguKAguKAguKAguKAguKAgnJldHVybiBlcnI7DQrCoOKAguKAguKAguKAguKAguKAguKA
guKAguKAguKAguKAgn0NCsKg4oCC4oCC4oCC4oCC4oCCfQ0KKyNlbmRpZg0KwqANCsKg4oCC4oCC
4oCC4oCC4oCCZXJyID0gLUVJTlZBTDsNCsKg4oCC4oCC4oCC4oCC4oCCcmN1X3JlYWRfbG9jaygp
Ow0KZGlmZiAtLWdpdCBhL25ldC94ZnJtL3hmcm1fdXNlci5jIGIvbmV0L3hmcm0veGZybV91c2Vy
LmMNCmluZGV4IDJmZjAxNzExNzczMC4uNTg3YjkwMDE0ODFhIDEwMDY0NA0KLS0tIGEvbmV0L3hm
cm0veGZybV91c2VyLmMNCisrKyBiL25ldC94ZnJtL3hmcm1fdXNlci5jDQpAQCAtMjg3Nyw2ICsy
ODc3LDcgQEAgc3RhdGljIGludCB4ZnJtX3VzZXJfcmN2X21zZyhzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LCBzdHJ1Y3Qgbmxtc2doZHIgKm5saCwNCsKg4oCC4oCC4oCC4oCC4oCCaWYgKCFuZXRsaW5rX25l
dF9jYXBhYmxlKHNrYiwgQ0FQX05FVF9BRE1JTikpDQrCoOKAguKAguKAguKAguKAguKAguKAguKA
guKAguKAguKAgnJldHVybiAtRVBFUk07DQrCoA0KKyNpZiBJU19FTkFCTEVEKENPTkZJR19DT01Q
QVRfRk9SX1U2NF9BTElHTk1FTlQpDQrCoOKAguKAguKAguKAguKAgmlmIChpbl9jb21wYXRfc3lz
Y2FsbCgpKSB7DQrCoOKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgnN0cnVjdCB4ZnJt
X3RyYW5zbGF0b3IgKnh0ciA9IHhmcm1fZ2V0X3RyYW5zbGF0b3IoKTsNCsKgDQpAQCAtMjg5MSw2
ICsyODkyLDcgQEAgc3RhdGljIGludCB4ZnJtX3VzZXJfcmN2X21zZyhzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLCBzdHJ1Y3Qgbmxtc2doZHIgKm5saCwNCsKg4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC
4oCC4oCCaWYgKG5saDY0KQ0KwqDigILigILigILigILigILigILigILigILigILigILigILigILi
gILigILigILigILigIJubGggPSBubGg2NDsNCsKg4oCC4oCC4oCC4oCC4oCCfQ0KKyNlbmRpZg0K
wqANCsKg4oCC4oCC4oCC4oCC4oCCaWYgKCh0eXBlID09IChYRlJNX01TR19HRVRTQSAtIFhGUk1f
TVNHX0JBU0UpIHx8DQrCoOKAguKAguKAguKAguKAgiDCoCDCoCB0eXBlID09IChYRlJNX01TR19H
RVRQT0xJQ1kgLSBYRlJNX01TR19CQVNFKSkgJiYNCi0tIA0KMi4yOC4wDQo=

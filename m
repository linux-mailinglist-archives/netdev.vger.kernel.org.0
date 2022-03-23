Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAEA4E54D7
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242344AbiCWPG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 11:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiCWPG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 11:06:26 -0400
Received: from mx07-005c9601.pphosted.com (mx07-005c9601.pphosted.com [205.220.184.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230C92229B;
        Wed, 23 Mar 2022 08:04:55 -0700 (PDT)
Received: from pps.filterd (m0237839.ppops.net [127.0.0.1])
        by mx08-005c9601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N4rVU8002203;
        Wed, 23 Mar 2022 16:04:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wago.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=p012021;
 bh=S5Kg1N46AuYrArJxpQHWmZI8zmxIPOU2sqM4RwmWcmw=;
 b=fKqQ6vHqd00IsE+1Cl/y+Oq2FI8Nkixxx1dO59JGhjHgsKYNjr5XPQXyzu8fMsgyNV0z
 bJqCf7mu9UaFikNqlEbI5Y2Kvtf593SLOPEWUd4zXZuVpAOWyhA81DD5lCbGut4/UQhE
 KIBcCGeg+KJbt9jJna3Fr1HGmkETFql6Cr1CsQDkOCbDeWbQxL3K2jFxV3X22a3q7TCQ
 9kJnQphg3H1xBifOoGrD7AvlUT5qZwqjk2Wlxvuj1tRtKJ5XW/OgXiVdaYd98H5Lim3S
 K1m9OBbslsbeVCNNosskjXgVokYa5r5wCMp/VgDcgbPgun34PcVthsVPkQSBTjn0bCWn 9Q== 
Received: from mail.wago.com ([217.237.185.168])
        by mx08-005c9601.pphosted.com (PPS) with ESMTPS id 3ew6yxmfyd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Mar 2022 16:04:50 +0100
Received: from SVEX01012.wago.local (10.1.103.230) by SVEX01011.wago.local
 (10.1.103.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 23 Mar
 2022 16:03:51 +0100
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (10.1.103.197) by
 outlook.wago.com (10.1.103.230) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21 via Frontend
 Transport; Wed, 23 Mar 2022 16:03:51 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0jv8f7QGONW35rsWRu61WV85iYzYgLgEDIssNhv+HRfTB5NV3b0HgoYz/MAENMjuNY7mDF71y00FMi+4oImVGrBDYnlMbP0NwEEqudEVD2Jr0AXq1BEtbFbc1xcBk11JQ52IHhFcwB0IIf1grmnuBEFLQU/0tP/D0OUFREy2Ev4N8hanYvXdXkPr0kDL+aLCDDmawXmjkcBvFuo6AEDwdvbl8jWJza11JCO2fXIRE55eEyYxL/ZKyc3zFNDxRjT8NYXSxnHXQtJ8F0eywrLtwqQrjf33dlfY4IuQWZQ5yNvqIv0/jUllwTDcYxxugZARa/SD3ipqQMegQ94N1HlPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5Kg1N46AuYrArJxpQHWmZI8zmxIPOU2sqM4RwmWcmw=;
 b=P/GacyPXxsTIqy3gmU2WuDrbQUDo6XuGEGeHccknpBDIjpjxxpdg3A7mVNsahkUc7yUpLzh87Zv8eyvTGUu6LI2ZIgXAJLuYWhx9F5I+f0qe661rEeueyvNpqDHDXP6WWLUDIEnsketQ9qDBCeLZH7giSLwHQULpgDYEwjvT3Tam61Xs2n8x+armNsJZf6kRWMgNMfJO4Yd9FJ/ZYQm0yJ4d5MSW5Muwpp7RCzFnAwEJzbW5Exzw7H5zRC8r9fNt5zcgJgzKtrZ5opNKz/UmM/UtFsFAWUqghlFq9YBufullT80TjERItbjShnbt9eAKiL1cD47w6lh3+C9y6/kABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wago.com; dmarc=pass action=none header.from=wago.com;
 dkim=pass header.d=wago.com; arc=none
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com (2603:10a6:10:38::15)
 by DBBPR08MB6219.eurprd08.prod.outlook.com (2603:10a6:10:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 15:03:50 +0000
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb]) by DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb%6]) with mapi id 15.20.5081.023; Wed, 23 Mar 2022
 15:03:50 +0000
From:   =?utf-8?B?U29uZGhhdcOfLCBKYW4=?= <Jan.Sondhauss@wago.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: ethernet: cpsw: fix panic when intrrupt
 coaleceing is set via ethtool
Thread-Topic: [PATCH v2] drivers: ethernet: cpsw: fix panic when intrrupt
 coaleceing is set via ethtool
Thread-Index: AQHYPpKjIr8iUrchREGeM/mphxhjsKzM0BEAgABBMIA=
Date:   Wed, 23 Mar 2022 15:03:50 +0000
Message-ID: <e0a1e509-f488-0472-2574-b55f1e393ad1@wago.com>
References: <20220323084725.65864-1-jan.sondhauss@wago.com>
 <1ecdd60a-8e77-a517-aafd-6b7aacb5e0ea@ti.com>
In-Reply-To: <1ecdd60a-8e77-a517-aafd-6b7aacb5e0ea@ti.com>
Accept-Language: en-DE, en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee3f21f5-470c-44ab-61fd-08da0cde56da
x-ms-traffictypediagnostic: DBBPR08MB6219:EE_
x-microsoft-antispam-prvs: <DBBPR08MB62197765D1F396338B92F1C18A189@DBBPR08MB6219.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7uEcPHydTtUegn4tKKIB0WvNYXNm9LIorBt+HDsPy96SMYqF64Q71B5j/fPhbZRuhEEi3FpI2idbHLopIdVNYLRLdofluQl+0BV4HZHC4jh340bZyGWtaqwcXkUSQY6vNXpsW+tXzTdiu2JT6T+PzZvY14JxSppH2XOqvqro3CW6aRcruzZaGCkmtnvqtg1/+PdMfgyPL0tYzkgy3FSbE9yp//sSff/IvFhBFNDWH8f6UIjeXD0tuSyBNnz0jf4nV2+76gWBNuNIycarN4XSUbPPl7oqJl/hU78JU7tB1OA4i7SH8aPYIP6TnUJKwGKB5nB1Dpj5Fe47trXwx/dXILUSkBxLswPrsTIocGfMtW+FmpSUwtqOPmK33tD8n8sQcIi8Hg4jSHtFaHOQ/oQuthgBR0HFR2hioJ0IQdrMbqyVdoIGBZhVsEoIUrsFEjnf9cjHW4j8WLDHThtuCUr7HTIbpE9KWKDT5kwZTrMp43gtYP15K3Z32f2QNwLbwTAXtNFZkyv/S/iWS2I9ym6/3MzyWgU3bYofte/llW8VWwTdd/EslkKjdUeCjkTxc7n0PQQ/Ojj3sJeyzQzBm6tKGQ6nmKpIgRBT5cP9noUCreXxUuJsTccYwbtRgXLV0RJFN+jnsCObaZ5vM7Pm6s65TeJUmL4FVj2wV71J8gwAexgI9/fqEcBgVtKsJRjbssIuPRiq4ANkh7BHAp8GVBjQQnInrXA7VVAtHzeRQ+pG+KFZUm8tVNuZVZVhhijgauPf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5097.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2616005)(5660300002)(53546011)(31696002)(86362001)(508600001)(6512007)(8936002)(2906002)(6506007)(38100700002)(122000001)(26005)(186003)(83380400001)(38070700005)(31686004)(91956017)(110136005)(64756008)(71200400001)(316002)(54906003)(4326008)(66946007)(8676002)(36756003)(85182001)(76116006)(66476007)(66446008)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2I0SUx3Y0s4amNEZWpqZFhzWXFLcEViOVZreE1uUFFXZWxqQ1huOFQ0YS9F?=
 =?utf-8?B?cnlZQW12Tmhic1NyYlZQMGNJMW4wMERMYnNXUGlsZ1FEZEJvWEcwL0I5elNO?=
 =?utf-8?B?L1NkUlJKYWR4YWpnVUs0dkhhNytZVmM0TkV3VWZMck1raDhMTSt5Z1BTT0th?=
 =?utf-8?B?TnVZRDdwSTVHVnpjelBwaWVRdDlnOGRXbTZjaGl0V0lpdEtNTmdCd254dkxZ?=
 =?utf-8?B?cGJsZXJ6cXd5alhOcVJtWDRuVEVnbkV0eDY3M2REa2tnNDErOGRZc1J0bGQy?=
 =?utf-8?B?Q1VsVWJHdnY4T0VmeGZBcVM2R2VXSEt0TlQ1VzVkOGl4ekF5UkQzRHB1OWho?=
 =?utf-8?B?SzgrZG5uZStubnZKSHRnUWxiaTR6bkZUd0E2b0p2UG9jVTJGTjBEaXMxM2tP?=
 =?utf-8?B?R0xkWDhLT1UvRTllUmNJMndUWXhlM1J1ZDVJamdxSXE4Y2tJc012eGJ4ZGRF?=
 =?utf-8?B?R2Rpb29Mby9BeWYrOTBxT2doUVJXYkRQdy9ZZEZqcHRuVWR0RUxlN1lkQnVw?=
 =?utf-8?B?RGRpay9Cb1FrTnRVSE5kTFFEV2lUMEhuV1lpak52bXExdHhmdzc3dXZGVnRr?=
 =?utf-8?B?VkhoU21oc1dNNWhYVmhqWEVhWDhPNzhDL3hYZEtqaVNFRHp3cmxPR3p4NWdZ?=
 =?utf-8?B?d2xlQnBlZmV3WldyQUo3T1I3OTIzcG93UW5BaXpGSTcyRlRSQXo1Ylhwd2F6?=
 =?utf-8?B?cCt6TXFvZmZZUzlsdFl5NkVjdjhmM3U0eVZQbVZVYVhNWWMySVg1R1dWUVZH?=
 =?utf-8?B?cXZoV285WnB4NzgzN21GNG9xZHRjKy9TVWUyaGlwU3lhcXB4WVRPRmVoQjQz?=
 =?utf-8?B?dk5WVzFPVHU4Vjh1ZlRCQWNiTTNiQUZJSHlNdldSTHI0YnZqRXlnb1hrMnp6?=
 =?utf-8?B?ME1NTnFSU3I0ZFcxYzMxd2NtY29NNmlGbndWL00zYTNuREw4MVNpVzd1NjI3?=
 =?utf-8?B?NXFaWEsxWEFHOHAwWVYwbXNROGdkN2NqSFFFZS9oRnZWMWxLM2Q0dG1XUHY4?=
 =?utf-8?B?LzRtdGxxYlVnUzl1dTNNTjV1NXlpUlVPTmRZeE9UbGdGLyt2OWdlVUxCdGk5?=
 =?utf-8?B?TmxVTUhMZForT0JFT0NQeGljdG5mMlFhWUdHY29NMFNFOTFEbnV5MVNFVlVk?=
 =?utf-8?B?VUJWay9lZXRkd2hnN2xZN3RUcUhacHZIRjV1MXZMaHJGNHVVSk5jVXMrMVBB?=
 =?utf-8?B?L0lQSkdPWk41NXRhVnExaEhsZkozSncwKy9NcWNBNG95b1hqRjl1em5ORm9T?=
 =?utf-8?B?cnczcFA4YUFCZExJcVphSU1tRVBCaTBFNjQ0NWRocnppYjJyYjJ4Z2p1UDBZ?=
 =?utf-8?B?ZVU3NVJkYldXem5GUktuVUF3N21QU2h2VzE1WEpSY0JsOTJzSEZyeVVwOCtF?=
 =?utf-8?B?cnEvNW9MY0pGVjRnR2lzbksydXpkSjYzK0VQTVVITmJndndzY2NNVVhTNDUy?=
 =?utf-8?B?RkYwUEdzSVlDT3hBWk9ieEZpT1RvNkNndDNjZTQyVmdreVhtaFNGS1A3aTRU?=
 =?utf-8?B?b01XbVlZaTUxQXZlZUVqNmlwZ040WUJEbjFXcm9TTnpNN0JZV09qcXZOVVZR?=
 =?utf-8?B?eEgzVWFqMXZMYWtWSmFndGFaS3J2RlpVMlQyVTVXSy9FVjBWeDFCQTU2OGN2?=
 =?utf-8?B?c0NyYjFITzlURkhSejQxeXhrOGtQYmhmcWFLT0ZWQUoxa2Z4VFBZb3NZYWF4?=
 =?utf-8?B?L0U2VE1ncTB1Wm9pQjNHWW1pTEpwbDNsbkxVQUdvZ2ZpVEdJZDVxRnN3TFdj?=
 =?utf-8?B?dWU4eitMRW92ekVVVisvQ3BlQS83WlQvSTVLVHVRYmVwODQ2NTJTeHlHdTlR?=
 =?utf-8?B?KytBMFlnNjNTZzRNWmxOQnE5eXFuME5ENEgvck93OXFuSTdvZmJqZUZsc0JD?=
 =?utf-8?B?cHZkcEplUktONG1icGsyckNCMmF4Y1dIUHlwR3RuczdWUitybEg5bnJwNDFi?=
 =?utf-8?B?Mk1nMzJqeDMrL0E5R0VGOWlYeEhURXZ1NHR4VWRoa2lXRVkvL1JPc3dUK202?=
 =?utf-8?B?NWZMR0d0UnF3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE4F765F02D23941AE3A3E89E60F3E00@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5097.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee3f21f5-470c-44ab-61fd-08da0cde56da
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 15:03:50.3428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e211c965-dd84-4c9f-bc3f-4215552a0857
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLNB6x7A8D3qpzTSHLIadJw3kz4avoYPs/nJa1gaM+iwbrcnV8J1moueNugFMVwctpI2it2KZQeJaScw8yW+dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6219
X-OriginatorOrg: wago.com
X-KSE-ServerInfo: SVEX01011.wago.local, 9
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2022 14:27:00
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Proofpoint-GUID: H2GLwMnWlOMz_vglOqNqKmWxlzCKWtkQ
X-Proofpoint-ORIG-GUID: H2GLwMnWlOMz_vglOqNqKmWxlzCKWtkQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=902 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230083
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIzLzAzLzIwMjIgMTI6MTAsIFZpZ25lc2ggUmFnaGF2ZW5kcmEgd3JvdGU6DQo+IE9u
IDIzLzAzLzIyIDI6MTcgcG0sIFNvbmRoYXXDnywgSmFuIHdyb3RlOiA+IGNwc3dfZXRodG9vbF9i
ZWdpbiBkaXJlY3RseSANCj4gcmV0dXJucyB0aGUgcmVzdWx0IG9mIHBtX3J1bnRpbWVfZ2V0X3N5
bmMgPiB3aGVuIHN1Y2Nlc3NmdWwuID4gDQo+IHBtX3J1bnRpbWVfZ2V0X3N5bmMgcmV0dXJucyAt
ZXJyb3IgY29kZSBvbiBmYWlsdXJlIGFuZCAwIG9uIHN1Y2Nlc3NmdWwgPiANCj4gcmVzdW1lIGJ1
dCBhbHNvIDEgd2hlbiBaalFjbVFSWUZwZnB0QmFubmVyU3RhcnQNCj4gVGhpcyBNZXNzYWdlIElz
IEZyb20gYW4gRXh0ZXJuYWwgU2VuZGVyDQo+IFBsZWFzZSB1c2UgY2F1dGlvbiB3aGVuIGNsaWNr
aW5nIG9uIGxpbmtzIG9yIG9wZW5pbmcgYXR0YWNobWVudHMhDQo+IFpqUWNtUVJZRnBmcHRCYW5u
ZXJFbmQNCj4gDQo+IE9uIDIzLzAzLzIyIDI6MTcgcG0sIFNvbmRoYXXDnywgSmFuIHdyb3RlOg0K
Pj4gY3Bzd19ldGh0b29sX2JlZ2luIGRpcmVjdGx5IHJldHVybnMgdGhlIHJlc3VsdCBvZiBwbV9y
dW50aW1lX2dldF9zeW5jDQo+PiB3aGVuIHN1Y2Nlc3NmdWwuDQo+PiBwbV9ydW50aW1lX2dldF9z
eW5jIHJldHVybnMgLWVycm9yIGNvZGUgb24gZmFpbHVyZSBhbmQgMCBvbiBzdWNjZXNzZnVsDQo+
PiByZXN1bWUgYnV0IGFsc28gMSB3aGVuIHRoZSBkZXZpY2UgaXMgYWxyZWFkeSBhY3RpdmUuIFNv
IHRoZSBjb21tb24gY2FzZQ0KPj4gZm9yIGNwc3dfZXRodG9vbF9iZWdpbiBpcyB0byByZXR1cm4g
MS4gVGhhdCBsZWFkcyB0byBpbmNvbnNpc3RlbnQgY2FsbHMNCj4+IHRvIHBtX3J1bnRpbWVfcHV0
IGluIHRoZSBjYWxsLWNoYWluIHNvIHRoYXQgcG1fcnVudGltZV9wdXQgaXMgY2FsbGVkDQo+PiBv
bmUgdG9vIG1hbnkgdGltZXMgYW5kIGFzIHJlc3VsdCBsZWF2aW5nIHRoZSBjcHN3IGRldiBiZWhp
bmQgc3VzcGVuZGVkLg0KPj4gDQo+PiBUaGUgc3VzcGVuZGVkIGNwc3cgZGV2IGxlYWRzIHRvIGFu
IGFjY2VzcyB2aW9sYXRpb24gbGF0ZXIgb24gYnkNCj4+IGRpZmZlcmVudCBwYXJ0cyBvZiB0aGUg
Y3BzdyBkcml2ZXIuDQo+PiANCj4+IEZpeCB0aGlzIGJ5IGNhbGxpbmcgdGhlIHJldHVybi1mcmll
bmRseSBwbV9ydW50aW1lX3Jlc3VtZV9hbmRfZ2V0DQo+PiBmdW5jdGlvbi4NCj4+IA0KPj4gU2ln
bmVkLW9mZi1ieTogSmFuIFNvbmRoYXVzcyA8amFuLnNvbmRoYXVzc0B3YWdvLmNvbT4NCj4+IC0t
LQ0KPj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3RpL2Nwc3dfZXRodG9vbC5jIHwgNiArKy0tLS0N
Cj4+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4g
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzd19ldGh0b29sLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC90aS9jcHN3X2V0aHRvb2wuYw0KPj4gaW5kZXggMTU4Yzhk
Mzc5M2Y0Li5iNWJhZTYzMjQ5NzAgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC90aS9jcHN3X2V0aHRvb2wuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bz
d19ldGh0b29sLmMNCj4+IEBAIC0zNjQsMTEgKzM2NCw5IEBAIGludCBjcHN3X2V0aHRvb2xfb3Bf
YmVnaW4oc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+PiAgCXN0cnVjdCBjcHN3X2NvbW1vbiAq
Y3BzdyA9IHByaXYtPmNwc3c7DQo+PiAgCWludCByZXQ7DQo+PiAgDQo+PiAtCXJldCA9IHBtX3J1
bnRpbWVfZ2V0X3N5bmMoY3Bzdy0+ZGV2KTsNCj4+IC0JaWYgKHJldCA8IDApIHsNCj4+ICsJcmV0
ID0gcG1fcnVudGltZV9yZXN1bWVfYW5kX2dldChjcHN3LT5kZXYpOw0KPj4gKwlpZiAocmV0IDwg
MCkNCj4+ICAJCWNwc3dfZXJyKHByaXYsIGRydiwgImV0aHRvb2wgYmVnaW4gZmFpbGVkICVkXG4i
LCByZXQpOw0KPj4gLQkJcG1fcnVudGltZV9wdXRfbm9pZGxlKGNwc3ctPmRldik7DQo+PiAtCX0N
Cj4+ICANCj4+ICAJcmV0dXJuIHJldDsNCj4+ICB9DQo+IA0KPiBUaGFua3MgZm9yIHRoZSBmaXgh
DQo+IA0KPiBSZXZpZXdlZC1ieTogVmlnbmVzaCBSYWdoYXZlbmRyYSA8dmlnbmVzaHJAdGkuY29t
Pg0KPiANCj4gSSBhbSBndWVzc2luZyB0aGlzIGlzc3VlIHN0YXJ0ZWQgd2l0aCBkNDNjNjViMDVi
ODQgKGV0aHRvb2w6DQo+IHJ1bnRpbWUtcmVzdW1lIG5ldGRldiBwYXJlbnQgaW4gZXRobmxfb3Bz
X2JlZ2luKSA/IElmIHNvLCBjb3VsZCB5b3UgYWRkDQo+IGEgRml4ZXMgdGFnIHNvIHRoYXQgcGF0
Y2ggZ2V0cyBiYWNrcG9ydGVkIHRvIGFsbCBhZmZlY3RlZCBzdGFibGUga2VybmVscz8NCg0KWWVz
IGl0IHN0YXJ0ZWQgd2l0aCB0aGF0IGNvbW1pdC4NCg0KPiANCj4gUmVnYXJkcw0KPiBWaWduZXNo
DQo+IA==

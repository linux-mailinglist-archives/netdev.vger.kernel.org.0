Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D46348C8B8
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355355AbiALQqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:46:40 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:30846 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355356AbiALQqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:46:16 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6hRb020034;
        Wed, 12 Jan 2022 11:46:12 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg3st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 11:46:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnJkcmNuyBhm9ejgx7CT+yfnWgoyGhOhTpZhCG8MbCYOlx0td3ycp99KLtlctOOvWcinQMWSNUfuraaAqc/zT2eZ2ndeim7g30zKlqxaOMwu/E9Paa/FujGgwrnGXKTxeietWzaSqP8Y+D38x25/A8IyE4006jwoXDyUPTOu/neAGgMC7vL/dUwaOIRqtH1LD4QibWPd1K/NP21/gIBS36G/e3XKMAdYqSN+jyTD+zkTW/IILZ327Ae8btD3g6tjlc94JOqRZjUhL1WPFopW7wB1IRFogAGU1TyWPSgkuAEk0HYPJFYGzwQWIBLs9Vvo7oiaiC0hL0+qqoDv4Ru2AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOwPGgV3c2V+g9c1hydvFs+bjYHpt20k7uIq7AxQ0JM=;
 b=bZ/jGE555sycErJRWOyRciew/2u/NJE8i6bGKibbiZWz8z8VuGNQUpNCSr0f/uXDr2IjESknKmarDkWpCFysXCXnbuSInc34xe+5RCeAMuU7dY2FncyBeU9V3Wh3avtgWgPg57VIwIhOaOPzU6w7Y8F0UI44it1IZd1R+riV/g2Ye8hQDoSWclW/3LbipBKeoyoAhAyKO1YA42z254WOBWJOWwUNxtQIi52nV76uaY689IXh6dWnC6BFjD2IjYn8eudmIoe461tN166TeNcsbl47REGHT3nMuXb/Xgc8Q+c7+s1cKxnmjyAR46MUqYcb0v/28or35rIrrCfD+yC5IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOwPGgV3c2V+g9c1hydvFs+bjYHpt20k7uIq7AxQ0JM=;
 b=hK6jZtmaNUp0ufzEBkam5VpOj4OWKN3Trk+hq4yN8gILa6LA6Ei/YpH80f8P/tsxvwZl+N+k2fAPHvOtzMDTMGyM2bfqcVLKCImrZjE89Sv3RyZfZUUyJvhjRZPYiv8MyeBfL53ydGBKQINbMNGrS/g7eGDq8PHoSNoO//lxUlE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3654.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:43::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 16:46:10 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 16:46:10 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net 1/7] net: axienet: Reset core before accessing MAC and
 wait for core ready
Thread-Topic: [PATCH net 1/7] net: axienet: Reset core before accessing MAC
 and wait for core ready
Thread-Index: AQHYBzA3l79aNpCzkEq2jvYVBMWu/qxeiNYAgAAwpoCAAN/wgA==
Date:   Wed, 12 Jan 2022 16:46:10 +0000
Message-ID: <4b0981d08e558b8730ddde3cdee52797a4644e1d.camel@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
         <20220111211358.2699350-2-robert.hancock@calian.com>
         <b66ac3d0a3c544ca082eb5c8d25c72dc1ce8f451.camel@calian.com>
         <20220111192439.44fb795e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111192439.44fb795e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38d80c22-6c40-4d2a-bcf0-08d9d5eb0972
x-ms-traffictypediagnostic: YQXPR01MB3654:EE_
x-microsoft-antispam-prvs: <YQXPR01MB365423A077339BFAF779D24CEC529@YQXPR01MB3654.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V4yZTjrPdl4G2SMZqWY43K9wGlA06kG+xiV9/Pi3IWxcNf0ysTFhvv+PKQJs7AMVhlP4ODA5zV6QEXjxC760xTIVzfhkPMURsYW4887lE577jfr3d6xJd9BqFk6CHKhHR6jV0zVMysN5o1T0Xfa8OBVHakokl0HgheKpTu78N1KeLn7O0QIqqAq1HwrdITccwCQMJ4pGE3artulBEyJ49Ke97W7evyCzroL+lE0jj4h0jhzSLbpNSbB+u0ngtwJ9cTDPUJJ2TtOWf8M7h5F7VFIrp5JeibCyLC5z8f/DWWCKNpfd+aM+0Ma6K/I5aQi+PF7YC2hNDAQ13qavcrOFKjv4qDjT3KnHRhVDPo8hd3GPHeZvgY+IGNgd218P+RsoLDlbSItPbMwa5Yr+Kde93RpeYLOWewl4EmmcYrhk0VQbHulPfRZ84u32QM1+hFdAuPKHU9u7EDZ80vmyOv1qNCpY7N15jRimfU+N7mYyNwZ70YlNq5DD/XfMbNzJ0WFukPerSXjA5iLJn1CzuUx9JN78l/eTQmwq19CJYw39uZUIZbVqXc3f1NSIo+gpqmEZQhIeguF1Y6bqPkBJBWDkRFnm6C8MBsEHjJS9+fuoTjahqFURkmd9WKrw13UF/srbrQdSci+rPRMg1qn96sgef8y/qr94F+uKRflYSRQ+/TsclOjusuiyN0/FZ/NnI+fg7T5BrZfqzUO2Wkx+CCLoX60rAaVf2AWpmVNDIH/PojJGgn0nAtUKU6w0Or6XRZC6/mfuJ6lUVpGijS6gT+8oQv+8TGhhADIJZr9TTc32B3jTe+lFNxWfwbPU70rwm0ECt8S79h1Xg+ijWsbp5Cm2vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(83380400001)(2906002)(91956017)(76116006)(44832011)(6512007)(66946007)(36756003)(71200400001)(86362001)(8936002)(8676002)(4326008)(6916009)(508600001)(66556008)(6506007)(66446008)(64756008)(6486002)(38070700005)(26005)(186003)(122000001)(66476007)(38100700002)(54906003)(316002)(15974865002)(5660300002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUorRUprdDRYTXBPN0dVTW94aWZTV3VZaDB4LzFzYzR4U2owcHU5ZTBnM3Rz?=
 =?utf-8?B?SFRTNHFJc29MUW9NUDJoNkhIUWdTVWIxdzVoWm1FdXVUVnRaVFBuanN6d0dY?=
 =?utf-8?B?YWhYVEZ4YnpCR0s1S2ZncWs5Rm1tYUVMVmlZOC9yc0FpT1Avak40MEhPT25S?=
 =?utf-8?B?dXFMMVl6dENFanlweDh3d2Z3Vjdrd0FHQWZsbklIZExubnJLd3YvUUptay9Q?=
 =?utf-8?B?eExCa1J2Um1tYWM5QU4wTU9uOWo0VE5HSy9adkxpK0J4MGhCLzFJaXgxVTRI?=
 =?utf-8?B?em5QUmVraEVxR1JVRDhTZ2xJQTYxbVZ4TVhTM1Q5clNNblhmczBhaEczTS8r?=
 =?utf-8?B?L3hkWlhEQ3BLbnBsb1BjQ1lyUzQrQnpFb0Mwa2x5VitmU0NsbS9XSk9YRnBl?=
 =?utf-8?B?UjV6REdJQkRyUEJvQUppSWd2SURBVDAycEJveFBhYTM3cXZKbzZKSXZqR1pC?=
 =?utf-8?B?MURKS1JLSUI0dlZyRjUzMnZwdUxtS0JjQXBXZFZZOU5aK2FUUHBRWXlQUXBT?=
 =?utf-8?B?TDJhZTJUQVhOWGREQ3V0VTA4ZklEWmY4bHllZHFNYjdCbTZkQUxCRVFORGtF?=
 =?utf-8?B?eXdlU1RYa1ErcjM3TjdubTZoZ2ptbW1sbElITVVqQ1NYQ0pQb2pFc0JSeC9k?=
 =?utf-8?B?SEhENXVPYm40U29aenhBOW1RTUFPa0tIK2JEK1lxa3BKQTJlS2RrcU5id1ly?=
 =?utf-8?B?c2owaTVmaU1iUG9BY0N3ZWNGZThNYnkzOWxrNmhGN3FoN09UUmhSSnpnYkNv?=
 =?utf-8?B?SzlxY3ZCamQwcEoyQUtuWTlXRFc3MnUydHMzeWNJQkZFY21VUlF6cmNFWDcx?=
 =?utf-8?B?RlY3TktmZXZRdzNsYmxlM3JUL2hNbVFLaVlYcldVWDI0ZWo5Vnh1aUxCVEEx?=
 =?utf-8?B?ZjNiWEtqRFhuMW1LeHovZitESk52aTFLSm1YWTdjTTg1N09sMjRoQzBES2VT?=
 =?utf-8?B?c3REUlF5L1lNelFrOHJXRHhlaHBiMHVOOUlkRE5VT0hCZEZuY0lrNFhzVDl5?=
 =?utf-8?B?Rzdvekh5TktlSG9BWFErVVNSMy95ZVozRlMxamhWdFBDb3dOT3ZOL2cxUmNs?=
 =?utf-8?B?RHRTcDF1RWc3K1JqaWUySUJleUJwNGk5cERybkNzSW14aFFtNHp3YUl6NG9M?=
 =?utf-8?B?bUZPaWIvV214cFdESSs4STdFV3N0dld0M0FvOUNPVWVSSlJ0VjBoVjN4dWVB?=
 =?utf-8?B?eXZtV2U5RWU1THIvelc1THlONTVlZGw5UWZ4c2Q0M1cyL0dxNTZtN3I5SnJo?=
 =?utf-8?B?Vk0xM0p6Sm83OGMyWEZCZDB1Rks2WUZpcGdVOHp4SEhON0l2Y0pFcEVuR1k1?=
 =?utf-8?B?Mmc4QVlSR1JHMzZHdWhwdzBRbEVHTEdJb2p2Ny9sK3JWNXB1amFMR2tQdjAy?=
 =?utf-8?B?L2tKeS9VWXhKMzNSNmVobHhtZ1pWYUxRNmcydnlnMDZZU1dsNWJDd0I2SGhQ?=
 =?utf-8?B?cXRvVlpJNUorbjV6bTFDWXJQUDRocndtSDJsL01BbzFWcnBvakVyMU1FWkpq?=
 =?utf-8?B?d2tUSkRLSmFGRU5kd0QxSm13bnQrbnpUd0RZVzgrVXcybnlnYUE4RGc0WHc5?=
 =?utf-8?B?Rk5ZMi8ySWYxNWNhdUtOeXpBTUdNajhCWFpRVytyUDRrTG1UM0tUVkEyZ1U5?=
 =?utf-8?B?bXNkd3NoVmhpdTBwT0JtWUU5SVlWZktyekYvNnZ4UmpuV3RMaGNiY0gyY1I5?=
 =?utf-8?B?cUFQQUY4N2NPazUraTg2VUxkSG45QUVFNXkybEJOUlZkY1Y4dTM0ZUFaMGhN?=
 =?utf-8?B?L1ArYWlRMzVsTlk0NERMbUhiMEJTRTl2NUFFN0VhWmF6MlFoaFpVL09Cc2JC?=
 =?utf-8?B?TlVoY25MKzQyREtQcUJXRkdwakduWStLMjBXeTdyWnc1Rk4rWm9xbysrSGFl?=
 =?utf-8?B?aUgyd2dYaVc4c2VBMmQ4L0x6VkJvZ2NrL1MwVHRpcXRBbWptakZMU255MHFj?=
 =?utf-8?B?N0Y2c2JxYU1VMnFKK25yY1Q4UEVjNWYrczBJeXh5NkJPUmMxSDJ6UHpoQTg3?=
 =?utf-8?B?QXU3VGYxVFRZVGdnVzVPUElqUUJOeXU0ODZ1anBLcFp6cUtmb3ZrRmdhZG1t?=
 =?utf-8?B?ZGdUNWhlTWgycHZ6UGNSbFQ5RkszVlptblpGank3L0VUTkt1K2VGS2RqQzJF?=
 =?utf-8?B?RGlpZUNDM0c5VUhVenplR1hlOVloNlhNOHlscFYydEZtSm5RWWpCRmZMOVE3?=
 =?utf-8?B?MWpoNVAzYXhvOE1vazRpQlE4NFBRUVdRZVBTeU1PZ3M1aFVucFlOTlFyNWZ1?=
 =?utf-8?Q?AdbDII8Q9UXDeRczNVvVJ6HvXz6YVs9MDriq1ZiU0U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <927F1F912D6F3E45A4B4C20A1618EBEB@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d80c22-6c40-4d2a-bcf0-08d9d5eb0972
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 16:46:10.1400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NVDWPx+uKv6fF3W5UE5tv7IvCx8E3b78B9nLfKHd1WyKmsxOLOvJChO20EHMSFkGkXd2TuNKbGc9NvRLeQoceHILj7ENo/BfID/FvIg5vxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3654
X-Proofpoint-GUID: qJW8f94BcffVhFErkMbBbFMK5KW1zby4
X-Proofpoint-ORIG-GUID: qJW8f94BcffVhFErkMbBbFMK5KW1zby4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTExIGF0IDE5OjI0IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxMiBKYW4gMjAyMiAwMDozMDozMyArMDAwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBPbiBUdWUsIDIwMjItMDEtMTEgYXQgMTU6MTMgLTA2MDAsIFJvYmVydCBIYW5jb2Nr
IHdyb3RlOg0KPiA+ID4gSW4gc29tZSBjYXNlcyB3aGVyZSB0aGUgWGlsaW54IEV0aGVybmV0IGNv
cmUgd2FzIHVzZWQgaW4gMTAwMEJhc2UtWCBvcg0KPiA+ID4gU0dNSUkgbW9kZXMsIHdoaWNoIHVz
ZSB0aGUgaW50ZXJuYWwgUENTL1BNQSBQSFksIGFuZCB0aGUgTUdUDQo+ID4gPiB0cmFuc2NlaXZl
ciBjbG9jayBzb3VyY2UgZm9yIHRoZSBQQ1Mgd2FzIG5vdCBydW5uaW5nIGF0IHRoZSB0aW1lIHRo
ZQ0KPiA+ID4gRlBHQSBsb2dpYyB3YXMgbG9hZGVkLCB0aGUgY29yZSB3b3VsZCBjb21lIHVwIGlu
IGEgc3RhdGUgd2hlcmUgdGhlDQo+ID4gPiBQQ1MgY291bGQgbm90IGJlIGZvdW5kIG9uIHRoZSBN
RElPIGJ1cy4gVG8gZml4IHRoaXMsIHRoZSBFdGhlcm5ldCBjb3JlDQo+ID4gPiAoaW5jbHVkaW5n
IHRoZSBQQ1MpIHNob3VsZCBiZSByZXNldCBhZnRlciBlbmFibGluZyB0aGUgY2xvY2tzLCBwcmlv
ciB0bw0KPiA+ID4gYXR0ZW1wdGluZyB0byBhY2Nlc3MgdGhlIFBDUyB1c2luZyBvZl9tZGlvX2Zp
bmRfZGV2aWNlLg0KPiA+ID4gDQo+ID4gPiBBbHNvLCB3aGVuIHJlc2V0dGluZyB0aGUgZGV2aWNl
LCB3YWl0IGZvciB0aGUgUGh5UnN0Q21wbHQgYml0IHRvIGJlIHNldA0KPiA+ID4gaW4gdGhlIGlu
dGVycnVwdCBzdGF0dXMgcmVnaXN0ZXIgYmVmb3JlIGNvbnRpbnVpbmcgaW5pdGlhbGl6YXRpb24s
IHRvDQo+ID4gPiBlbnN1cmUgdGhhdCB0aGUgY29yZSBpcyBhY3R1YWxseSByZWFkeS4gVGhlIE1n
dFJkeSBiaXQgY291bGQgYWxzbyBiZQ0KPiA+ID4gd2FpdGVkIGZvciwgYnV0IHVuZm9ydHVuYXRl
bHkgd2hlbiB1c2luZyA3LXNlcmllcyBkZXZpY2VzLCB0aGUgYml0IGRvZXMNCj4gPiA+IG5vdCBh
cHBlYXIgdG8gd29yayBhcyBkb2N1bWVudGVkIChpdCBzZWVtcyB0byBiZWhhdmUgYXMgc29tZSBz
b3J0IG9mDQo+ID4gPiBsaW5rIHN0YXRlIGluZGljYXRpb24gYW5kIG5vdCBqdXN0IGFuIGluZGlj
YXRpb24gdGhlIHRyYW5zY2VpdmVyIGlzDQo+ID4gPiByZWFkeSkgc28gaXQgY2FuJ3QgcmVhbGx5
IGJlIHJlbGllZCBvbi4NCj4gDQo+IFNob3VsZG4ndCB0aGVzZSBiZSB0d28gc2VwYXJhdGUgZml4
ZXM/DQoNClllYWgsIHRoaXMgY291bGQgbGlrZWx5IGJlIGJyb2tlbiB1cCBpbnRvIDIgcGF0Y2hl
cyAob3IgcG9zc2libHkgMykuDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2Fy
ZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20N
Cg==

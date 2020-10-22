Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996CE29586B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503742AbgJVGbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 02:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438335AbgJVGbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 02:31:18 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AEAC0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 23:31:18 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09M6OkWR012202;
        Thu, 22 Oct 2020 07:31:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=JCghq5V8tOadmUeDRcPdPc0aX16HLDFitFzgk1hZYXQ=;
 b=CzljTv8XyLAV3Ij9Dk5L7wwUbr95ciNdkj6axOsuBRsvkjeDc2uiVPXBl7/11LrkHs+y
 glYk5Gq1+L4cac3sCFwMhBwkTu4wicLABC0E4isH5PvszgiNzzkpRM2qLn/i4u1/o+6t
 /w/6jihpXCZdokLR/kMk4XfJtn9tvJIwxwpf2LVeg8MbBMPuTMEMR62z2FVpdo4YoSOP
 7bQqv9zvgB+lcHp+RNW/wRj6uQdxNbB9moOroew2kM1wAJ75KgpgPoTxr2CS49ZL+KN1
 LV9tiHMoqxpX+JP/l70DNPvnFZzOV5ZKg0zC9fAKxTA+U/AWP1WqyE5UGGcdhMzQProi yw== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 347s1gpfck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 07:31:09 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09M6LIDe012881;
        Thu, 22 Oct 2020 02:31:08 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.113])
        by prod-mail-ppoint7.akamai.com with ESMTP id 347uxyfadu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 02:31:08 -0400
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com (172.27.165.121) by
 USTX2EX-DAG3MB1.msg.corp.akamai.com (172.27.165.125) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 22 Oct 2020 01:31:07 -0500
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com ([172.27.165.121]) by
 ustx2ex-dag1mb3.msg.corp.akamai.com ([172.27.165.121]) with mapi id
 15.00.1497.007; Thu, 22 Oct 2020 01:31:07 -0500
From:   "Li, Ke" <keli@akamai.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kli@udel.edu" <kli@udel.edu>, "Li, Ji" <jli@akamai.com>
Subject: Re: [PATCH net] net: Properly typecast int values to set
 sk_max_pacing_rate
Thread-Topic: [PATCH net] net: Properly typecast int values to set
 sk_max_pacing_rate
Thread-Index: AQHWpnhwjQ8QIX0uoEqJ+kUfbG0PxKmjVKMA//+2u4A=
Date:   Thu, 22 Oct 2020 06:31:06 +0000
Message-ID: <15C07001-BF04-4430-834F-E1973F866DC5@akamai.com>
References: <20201020003149.215357-1-keli@akamai.com>
 <20201021205320.57cb4c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021205320.57cb4c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.42.20101102
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.83.86]
Content-Type: text/plain; charset="utf-8"
Content-ID: <424B98CFD4B0074C97D55CA5372101A3@akamai.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_02:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220041
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_02:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220042
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.33)
 smtp.mailfrom=keli@akamai.com smtp.helo=prod-mail-ppoint7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciByZXZpZXcgYW5kIGNvbW1lbnQsIEpha3ViIQ0KUGxlYXNlIGNoZWNrIG15IHYy
IHBhdGNoLg0KDQpCZXN0LA0KLUtlDQoNCu+7v09uIDEwLzIxLzIwLCA4OjUzIFBNLCAiSmFrdWIg
S2ljaW5za2kiIDxrdWJhQGtlcm5lbC5vcmc+IHdyb3RlOg0KDQogICAgT24gTW9uLCAxOSBPY3Qg
MjAyMCAyMDozMTo0OSAtMDQwMCBLZSBMaSB3cm90ZToNCiAgICA+IEluIHNldHNvY2tvcHQoU09f
TUFYX1BBQ0lOR19SQVRFKSBvbiA2NGJpdCBzeXN0ZW1zLCBza19tYXhfcGFjaW5nX3JhdGUsDQog
ICAgPiBhZnRlciBleHRlbmRlZCBmcm9tICd1MzInIHRvICd1bnNpZ25lZCBsb25nJywgdGFrZXMg
dW5pbnRlbnRpb25hbGx5DQogICAgPiBoaWtlZCB2YWx1ZSB3aGVuZXZlciBhc3NpZ25lZCBmcm9t
IGFuICdpbnQnIHZhbHVlIHdpdGggTVNCPTEsIGR1ZSB0bw0KICAgID4gYmluYXJ5IHNpZ24gZXh0
ZW5zaW9uIGluIHByb21vdGluZyBzMzIgdG8gdTY0LCBlLmcuIDB4ODAwMDAwMDAgYmVjb21lcw0K
ICAgID4gMHhGRkZGRkZGRjgwMDAwMDAwLg0KICAgID4gDQogICAgPiBUaHVzIGluZmxhdGVkIHNr
X21heF9wYWNpbmdfcmF0ZSBjYXVzZXMgc3Vic2VxdWVudCBnZXRzb2Nrb3B0IHRvIHJldHVybg0K
ICAgID4gfjBVIHVuZXhwZWN0ZWRseS4gSXQgbWF5IGFsc28gcmVzdWx0IGluIGluY3JlYXNlZCBw
YWNpbmcgcmF0ZS4NCiAgICA+IA0KICAgID4gRml4IGJ5IGV4cGxpY2l0bHkgY2FzdGluZyB0aGUg
J2ludCcgdmFsdWUgdG8gJ3Vuc2lnbmVkIGludCcgYmVmb3JlDQogICAgPiBhc3NpZ25pbmcgaXQg
dG8gc2tfbWF4X3BhY2luZ19yYXRlLCBmb3IgemVybyBleHRlbnNpb24gdG8gaGFwcGVuLg0KICAg
ID4gDQogICAgPiBGaXhlczogNzZhOWViZTgxMWZiICgibmV0OiBleHRlbmQgc2tfcGFjaW5nX3Jh
dGUgdG8gdW5zaWduZWQgbG9uZyIpDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBKaSBMaSA8amxpQGFr
YW1haS5jb20+DQogICAgPiBTaWduZWQtb2ZmLWJ5OiBLZSBMaSA8a2VsaUBha2FtYWkuY29tPg0K
ICAgID4gQ2M6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCiAgICA+IC0tLQ0K
ICAgID4gIG5ldC9jb3JlL2ZpbHRlci5jIHwgMiArLQ0KICAgID4gIG5ldC9jb3JlL3NvY2suYyAg
IHwgMiArLQ0KICAgID4gIDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KICAgID4gDQogICAgPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZmlsdGVyLmMgYi9u
ZXQvY29yZS9maWx0ZXIuYw0KICAgID4gaW5kZXggYzVlMmExYzVmZDhkLi40M2YyMGMxNDg2NGMg
MTAwNjQ0DQogICAgPiAtLS0gYS9uZXQvY29yZS9maWx0ZXIuYw0KICAgID4gKysrIGIvbmV0L2Nv
cmUvZmlsdGVyLmMNCiAgICA+IEBAIC00NjkzLDcgKzQ2OTMsNyBAQCBzdGF0aWMgaW50IF9icGZf
c2V0c29ja29wdChzdHJ1Y3Qgc29jayAqc2ssIGludCBsZXZlbCwgaW50IG9wdG5hbWUsDQogICAg
PiAgCQkJCWNtcHhjaGcoJnNrLT5za19wYWNpbmdfc3RhdHVzLA0KICAgID4gIAkJCQkJU0tfUEFD
SU5HX05PTkUsDQogICAgPiAgCQkJCQlTS19QQUNJTkdfTkVFREVEKTsNCiAgICA+IC0JCQlzay0+
c2tfbWF4X3BhY2luZ19yYXRlID0gKHZhbCA9PSB+MFUpID8gfjBVTCA6IHZhbDsNCiAgICA+ICsJ
CQlzay0+c2tfbWF4X3BhY2luZ19yYXRlID0gKHZhbCA9PSB+MFUpID8gfjBVTCA6ICh1bnNpZ25l
ZCBpbnQpdmFsOw0KDQogICAgTG9va3MgZ29vZCwgYnV0IHBsZWFzZSB3cmFwIHRoaXMgdG8gODAg
Y2hhcnMuDQoNCiAgICA+ICAJCQlzay0+c2tfcGFjaW5nX3JhdGUgPSBtaW4oc2stPnNrX3BhY2lu
Z19yYXRlLA0KICAgID4gIAkJCQkJCSBzay0+c2tfbWF4X3BhY2luZ19yYXRlKTsNCiAgICA+ICAJ
CQlicmVhazsNCiAgICA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9zb2NrLmMgYi9uZXQvY29yZS9z
b2NrLmMNCiAgICA+IGluZGV4IDRlODcyOTM1NzEyMi4uNzI3ZWExY2M2MzNjIDEwMDY0NA0KICAg
ID4gLS0tIGEvbmV0L2NvcmUvc29jay5jDQogICAgPiArKysgYi9uZXQvY29yZS9zb2NrLmMNCiAg
ICA+IEBAIC0xMTYzLDcgKzExNjMsNyBAQCBpbnQgc29ja19zZXRzb2Nrb3B0KHN0cnVjdCBzb2Nr
ZXQgKnNvY2ssIGludCBsZXZlbCwgaW50IG9wdG5hbWUsDQogICAgPiAgDQogICAgPiAgCWNhc2Ug
U09fTUFYX1BBQ0lOR19SQVRFOg0KICAgID4gIAkJew0KICAgID4gLQkJdW5zaWduZWQgbG9uZyB1
bHZhbCA9ICh2YWwgPT0gfjBVKSA/IH4wVUwgOiB2YWw7DQogICAgPiArCQl1bnNpZ25lZCBsb25n
IHVsdmFsID0gKHZhbCA9PSB+MFUpID8gfjBVTCA6ICh1bnNpZ25lZCBpbnQpdmFsOw0KICAgID4g
IA0KICAgID4gIAkJaWYgKHNpemVvZih1bHZhbCkgIT0gc2l6ZW9mKHZhbCkgJiYNCiAgICA+ICAJ
CSAgICBvcHRsZW4gPj0gc2l6ZW9mKHVsdmFsKSAmJg0KICAgID4gDQogICAgPiBiYXNlLWNvbW1p
dDogMGU4YjhkNmEyZDg1MzQ0ZDgwZGRhNWJlYWRkOThmNWY4NmU4ZDNkMw0KDQoNCg==

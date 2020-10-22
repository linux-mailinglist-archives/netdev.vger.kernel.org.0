Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360129645A
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 20:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368668AbgJVSD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 14:03:59 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:51128 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368660AbgJVSD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 14:03:59 -0400
X-Greylist: delayed 1002 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Oct 2020 14:03:58 EDT
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MHgYaY032163;
        Thu, 22 Oct 2020 18:45:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=mIXGZHTbTkHUBpmh3O1qDan/s/wFrejm3zKdrzX1Zlk=;
 b=DKdT4+MprUhMlxMmXjiJOmvyi/qtXQpTc5Tv/r3TVMvOVf+Y4gbqzr4bLVpAk/nOuQqB
 5DU88OpronyyMH2x8XfGAAFcxy6hDo6HkpKsWBbfKl1Lx27EfoFMWSYzM2kWII4EVB/0
 2X+fdpBDNRNaLtN4NPZy/E3rSSGIzN7M9mmWEtvAgY3XqFf1UnZ3FblC8X4X9OQgccu2
 1cTxuSAO5PoVfxrCTbxYdpszLfSMGDmPGtjwV+NC+KTS/RbZibtxEF86gLQwp6HO6RoC
 cbfGAoDooV0u5GeHUx9si6PHykEIIROe1B+GWYJZ4IwDgqHjJJ1fj4dmtMPYyLjI7NFs GA== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 347rnt6wy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 18:45:10 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09MHZ5UK023376;
        Thu, 22 Oct 2020 13:45:09 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.113])
        by prod-mail-ppoint3.akamai.com with ESMTP id 347uxyky3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:45:09 -0400
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com (172.27.165.121) by
 USTX2EX-DAG3MB1.msg.corp.akamai.com (172.27.165.125) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 22 Oct 2020 12:45:08 -0500
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com ([172.27.165.121]) by
 ustx2ex-dag1mb3.msg.corp.akamai.com ([172.27.165.121]) with mapi id
 15.00.1497.007; Thu, 22 Oct 2020 12:45:09 -0500
From:   "Li, Ke" <keli@akamai.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, "kli@udel.edu" <kli@udel.edu>,
        "Li, Ji" <jli@akamai.com>
Subject: Re: [PATCH net v2] net: Properly typecast int values to set
 sk_max_pacing_rate
Thread-Topic: [PATCH net v2] net: Properly typecast int values to set
 sk_max_pacing_rate
Thread-Index: AQHWqD50DGuJQFuuLU2le0XT0i0pCamjkuEA//+aAoCAANMhgP//xCCA
Date:   Thu, 22 Oct 2020 17:45:08 +0000
Message-ID: <818BA4CC-AAA9-4D4F-9EF4-438405DA1020@akamai.com>
References: <20201022064146.79873-1-keli@akamai.com>
 <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
 <C781E7ED-D9E2-4FB4-87DA-88E6AFD35F0E@akamai.com>
 <CANn89iKL_+LkPqYzOMe0sTB0Y_vOaeq5Twd6q5v9exWMDXxZ2g@mail.gmail.com>
In-Reply-To: <CANn89iKL_+LkPqYzOMe0sTB0Y_vOaeq5Twd6q5v9exWMDXxZ2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.42.20101102
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.93.23]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C647DD1D356FD44806BEBECD643EB5B@akamai.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_12:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220113
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_12:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220114
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.31)
 smtp.mailfrom=keli@akamai.com smtp.helo=prod-mail-ppoint3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB0aGUgaW5mbywgRXJpYyENCg0KVGhhdCBleHBsYWlucyB3aHkgY2hlY2twYXRj
aC5wbCBoYWRuJ3QgY29tcGxhaW5lZCB3aXRoIHYxIHBhdGNoLg0KDQpCZXN0LA0KLUtlDQoNCu+7
v09uIDEwLzIyLzIwLCA3OjE5IEFNLCAiRXJpYyBEdW1hemV0IiA8ZWR1bWF6ZXRAZ29vZ2xlLmNv
bT4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIE9jdCAyMiwgMjAyMCBhdCAxMDo0MyBBTSBMaSwgS2Ug
PGtlbGlAYWthbWFpLmNvbT4gd3JvdGU6DQogICAgPg0KICAgID4gVGhhbmsgeW91LCBFcmljIQ0K
ICAgID4NCiAgICA+IE5pY2UgdG8ga25vdyB0aGUgcmVjZW50IGNoYW5nZSB0byB3cmFwLWF0LTEw
MC4gV2lsbCB0aGlzIGJlIHJlZmxlY3RlZCBzb21ld2hlcmUsIGxpa2UsIGluIERvY3VtZW50YXRp
b24vcHJvY2Vzcy9jb2Rpbmctc3R5bGUucnN0Pw0KICAgID4NCg0KICAgIGNvbW1pdCBiZGM0OGZh
MTFlNDZmODY3ZWE0ZDc1ZmE1OWVlODdhN2Y0OGJlMTQ0DQogICAgQXV0aG9yOiBKb2UgUGVyY2hl
cyA8am9lQHBlcmNoZXMuY29tPg0KICAgIERhdGU6ICAgRnJpIE1heSAyOSAxNjoxMjoyMSAyMDIw
IC0wNzAwDQoNCiAgICAgICAgY2hlY2twYXRjaC9jb2Rpbmctc3R5bGU6IGRlcHJlY2F0ZSA4MC1j
b2x1bW4gd2FybmluZw0KDQogICAgICAgIFllcywgc3RheWluZyB3aXRoaW5nIDgwIGNvbHVtbnMg
aXMgY2VydGFpbmx5IHN0aWxsIF9wcmVmZXJyZWRfLiAgQnV0DQogICAgICAgIGl0J3Mgbm90IHRo
ZSBoYXJkIGxpbWl0IHRoYXQgdGhlIGNoZWNrcGF0Y2ggd2FybmluZ3MgaW1wbHksIGFuZCBvdGhl
cg0KICAgICAgICBjb25jZXJucyBjYW4gbW9zdCBjZXJ0YWlubHkgZG9taW5hdGUuDQoNCiAgICAg
ICAgSW5jcmVhc2UgdGhlIGRlZmF1bHQgbGltaXQgdG8gMTAwIGNoYXJhY3RlcnMuICBOb3QgYmVj
YXVzZSAxMDANCiAgICAgICAgY2hhcmFjdGVycyBpcyBzb21lIGhhcmQgbGltaXQgZWl0aGVyLCBi
dXQgdGhhdCdzIGNlcnRhaW5seSBhICJ3aGF0IGFyZQ0KICAgICAgICB5b3UgZG9pbmciIGtpbmQg
b2YgdmFsdWUgYW5kIGxlc3MgbGlrZWx5IHRvIGJlIGFib3V0IHRoZSBvY2Nhc2lvbmFsDQogICAg
ICAgIHNsaWdodGx5IGxvbmdlciBsaW5lcy4NCg0KICAgICAgICBNaXNjZWxsYW5lYToNCg0KICAg
ICAgICAgLSB0byBhdm9pZCB1bm5lY2Vzc2FyeSB3aGl0ZXNwYWNlIGNoYW5nZXMgaW4gZmlsZXMs
IGNoZWNrcGF0Y2ggd2lsbCBubw0KICAgICAgICAgICBsb25nZXIgZW1pdCBhIHdhcm5pbmcgYWJv
dXQgbGluZSBsZW5ndGggd2hlbiBzY2FubmluZyBmaWxlcyB1bmxlc3MNCiAgICAgICAgICAgLS1z
dHJpY3QgaXMgYWxzbyB1c2VkDQoNCiAgICAgICAgIC0gQWRkIGEgYml0IHRvIGNvZGluZy1zdHls
ZSBhYm91dCBhbGlnbm1lbnQgdG8gb3BlbiBwYXJlbnRoZXNpcw0KDQogICAgICAgIFNpZ25lZC1v
ZmYtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5jb20+DQogICAgICAgIFNpZ25lZC1vZmYt
Ynk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4NCg0KDQoN
CiAgICA+IEJlc3QsDQogICAgPiAtS2UNCiAgICA+DQogICAgPiBPbiAxMC8yMi8yMCwgMTI6NDkg
QU0sICJFcmljIER1bWF6ZXQiIDxlZHVtYXpldEBnb29nbGUuY29tPiB3cm90ZToNCiAgICA+DQog
ICAgPiAgICAgT24gVGh1LCBPY3QgMjIsIDIwMjAgYXQgODo0MiBBTSBLZSBMaSA8a2VsaUBha2Ft
YWkuY29tPiB3cm90ZToNCiAgICA+ICAgICA+DQogICAgPiAgICAgPiBJbiBzZXRzb2Nrb3B0KFNP
X01BWF9QQUNJTkdfUkFURSkgb24gNjRiaXQgc3lzdGVtcywgc2tfbWF4X3BhY2luZ19yYXRlLA0K
ICAgID4gICAgID4gYWZ0ZXIgZXh0ZW5kZWQgZnJvbSAndTMyJyB0byAndW5zaWduZWQgbG9uZycs
IHRha2VzIHVuaW50ZW50aW9uYWxseQ0KICAgID4gICAgID4gaGlrZWQgdmFsdWUgd2hlbmV2ZXIg
YXNzaWduZWQgZnJvbSBhbiAnaW50JyB2YWx1ZSB3aXRoIE1TQj0xLCBkdWUgdG8NCiAgICA+ICAg
ICA+IGJpbmFyeSBzaWduIGV4dGVuc2lvbiBpbiBwcm9tb3RpbmcgczMyIHRvIHU2NCwgZS5nLiAw
eDgwMDAwMDAwIGJlY29tZXMNCiAgICA+ICAgICA+IDB4RkZGRkZGRkY4MDAwMDAwMC4NCiAgICA+
ICAgICA+DQogICAgPiAgICAgPiBUaHVzIGluZmxhdGVkIHNrX21heF9wYWNpbmdfcmF0ZSBjYXVz
ZXMgc3Vic2VxdWVudCBnZXRzb2Nrb3B0IHRvIHJldHVybg0KICAgID4gICAgID4gfjBVIHVuZXhw
ZWN0ZWRseS4gSXQgbWF5IGFsc28gcmVzdWx0IGluIGluY3JlYXNlZCBwYWNpbmcgcmF0ZS4NCiAg
ICA+ICAgICA+DQogICAgPiAgICAgPiBGaXggYnkgZXhwbGljaXRseSBjYXN0aW5nIHRoZSAnaW50
JyB2YWx1ZSB0byAndW5zaWduZWQgaW50JyBiZWZvcmUNCiAgICA+ICAgICA+IGFzc2lnbmluZyBp
dCB0byBza19tYXhfcGFjaW5nX3JhdGUsIGZvciB6ZXJvIGV4dGVuc2lvbiB0byBoYXBwZW4uDQog
ICAgPiAgICAgPg0KICAgID4gICAgID4gRml4ZXM6IDc2YTllYmU4MTFmYiAoIm5ldDogZXh0ZW5k
IHNrX3BhY2luZ19yYXRlIHRvIHVuc2lnbmVkIGxvbmciKQ0KICAgID4gICAgID4gU2lnbmVkLW9m
Zi1ieTogSmkgTGkgPGpsaUBha2FtYWkuY29tPg0KICAgID4gICAgID4gU2lnbmVkLW9mZi1ieTog
S2UgTGkgPGtlbGlAYWthbWFpLmNvbT4NCiAgICA+ICAgICA+IENjOiBFcmljIER1bWF6ZXQgPGVk
dW1hemV0QGdvb2dsZS5jb20+DQogICAgPiAgICAgPiAtLS0NCiAgICA+ICAgICA+IHYyOiB3cmFw
IHRoZSBsaW5lIGluIG5ldC9jb3JlL2ZpbHRlci5jIHRvIGxlc3MgdGhhbiA4MCBjaGFycy4NCiAg
ICA+DQogICAgPiAgICAgU0dUTSAodGhlIG90aGVyIHZlcnNpb24gd2FzIGFsc28gZmluZSwgdGhl
IDgwIGNoYXJzIHJ1bGUgaGFzIGJlZW4NCiAgICA+ICAgICByZWxheGVkL2NoYW5nZWQgdG8gMTAw
IHJlY2VudGx5KQ0KICAgID4NCiAgICA+ICAgICBSZXZpZXdlZC1ieTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KICAgID4NCg0K

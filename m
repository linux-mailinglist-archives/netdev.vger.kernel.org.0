Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963FB295AC4
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509602AbgJVIny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504901AbgJVIny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:43:54 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3FCC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 01:43:53 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09M8cn40003593;
        Thu, 22 Oct 2020 09:43:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=7+LRaRjUhWc05ypOFzV4t+9IkO1HMFiWWS9MC9JkXRo=;
 b=YCrWCqUIaU9E5h8yzD5k0o9615u+97LiMsZ4RdPEXT9CIQgSFuWz5jQzkECnl5FLsGMY
 qKkfQvs7LdKMlQGTq6iWQMSq6UB6ju1OgJH23nVFTd4GAK/Zqhu/ZWIgEoADDctuobyC
 Jtiq2TZN37c60uEmUnj+PjzWj+CfbqMyb1CiIrhYiEoRjWr5JcN0sq4IYmNxHfnmuCAB
 kcswrZugKgvIPXsit2CORgAlYSfQIzaZlkjGf80/t7lmW+VXeI9WYlU/1O+sRsE7cVX9
 4pShS98dyx7vhxoVY5BIsjq9nBZ8dw0enz1il2b1R8Ttk6R04liNm8R+1tDEJOpEna3s Aw== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 347s1gu4qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 09:43:48 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09M8ZJV1030769;
        Thu, 22 Oct 2020 04:43:47 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.116])
        by prod-mail-ppoint7.akamai.com with ESMTP id 347uxyg794-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 04:43:47 -0400
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com (172.27.165.121) by
 USTX2EX-DAG3MB6.msg.corp.akamai.com (172.27.165.130) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 22 Oct 2020 03:43:47 -0500
Received: from USTX2EX-DAG1MB3.msg.corp.akamai.com ([172.27.165.121]) by
 ustx2ex-dag1mb3.msg.corp.akamai.com ([172.27.165.121]) with mapi id
 15.00.1497.007; Thu, 22 Oct 2020 03:43:47 -0500
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
Thread-Index: AQHWqD50DGuJQFuuLU2le0XT0i0pCamjkuEA//+aAoA=
Date:   Thu, 22 Oct 2020 08:43:46 +0000
Message-ID: <C781E7ED-D9E2-4FB4-87DA-88E6AFD35F0E@akamai.com>
References: <20201022064146.79873-1-keli@akamai.com>
 <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
In-Reply-To: <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.42.20101102
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.83.86]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D16A0A012531D244A121E813A1D3CE53@akamai.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_02:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220057
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_02:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220058
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.33)
 smtp.mailfrom=keli@akamai.com smtp.helo=prod-mail-ppoint7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91LCBFcmljIQ0KDQpOaWNlIHRvIGtub3cgdGhlIHJlY2VudCBjaGFuZ2UgdG8gd3Jh
cC1hdC0xMDAuIFdpbGwgdGhpcyBiZSByZWZsZWN0ZWQgc29tZXdoZXJlLCBsaWtlLCBpbiBEb2N1
bWVudGF0aW9uL3Byb2Nlc3MvY29kaW5nLXN0eWxlLnJzdD8NCg0KQmVzdCwNCi1LZQ0KDQrvu79P
biAxMC8yMi8yMCwgMTI6NDkgQU0sICJFcmljIER1bWF6ZXQiIDxlZHVtYXpldEBnb29nbGUuY29t
PiB3cm90ZToNCg0KICAgIE9uIFRodSwgT2N0IDIyLCAyMDIwIGF0IDg6NDIgQU0gS2UgTGkgPGtl
bGlAYWthbWFpLmNvbT4gd3JvdGU6DQogICAgPg0KICAgID4gSW4gc2V0c29ja29wdChTT19NQVhf
UEFDSU5HX1JBVEUpIG9uIDY0Yml0IHN5c3RlbXMsIHNrX21heF9wYWNpbmdfcmF0ZSwNCiAgICA+
IGFmdGVyIGV4dGVuZGVkIGZyb20gJ3UzMicgdG8gJ3Vuc2lnbmVkIGxvbmcnLCB0YWtlcyB1bmlu
dGVudGlvbmFsbHkNCiAgICA+IGhpa2VkIHZhbHVlIHdoZW5ldmVyIGFzc2lnbmVkIGZyb20gYW4g
J2ludCcgdmFsdWUgd2l0aCBNU0I9MSwgZHVlIHRvDQogICAgPiBiaW5hcnkgc2lnbiBleHRlbnNp
b24gaW4gcHJvbW90aW5nIHMzMiB0byB1NjQsIGUuZy4gMHg4MDAwMDAwMCBiZWNvbWVzDQogICAg
PiAweEZGRkZGRkZGODAwMDAwMDAuDQogICAgPg0KICAgID4gVGh1cyBpbmZsYXRlZCBza19tYXhf
cGFjaW5nX3JhdGUgY2F1c2VzIHN1YnNlcXVlbnQgZ2V0c29ja29wdCB0byByZXR1cm4NCiAgICA+
IH4wVSB1bmV4cGVjdGVkbHkuIEl0IG1heSBhbHNvIHJlc3VsdCBpbiBpbmNyZWFzZWQgcGFjaW5n
IHJhdGUuDQogICAgPg0KICAgID4gRml4IGJ5IGV4cGxpY2l0bHkgY2FzdGluZyB0aGUgJ2ludCcg
dmFsdWUgdG8gJ3Vuc2lnbmVkIGludCcgYmVmb3JlDQogICAgPiBhc3NpZ25pbmcgaXQgdG8gc2tf
bWF4X3BhY2luZ19yYXRlLCBmb3IgemVybyBleHRlbnNpb24gdG8gaGFwcGVuLg0KICAgID4NCiAg
ICA+IEZpeGVzOiA3NmE5ZWJlODExZmIgKCJuZXQ6IGV4dGVuZCBza19wYWNpbmdfcmF0ZSB0byB1
bnNpZ25lZCBsb25nIikNCiAgICA+IFNpZ25lZC1vZmYtYnk6IEppIExpIDxqbGlAYWthbWFpLmNv
bT4NCiAgICA+IFNpZ25lZC1vZmYtYnk6IEtlIExpIDxrZWxpQGFrYW1haS5jb20+DQogICAgPiBD
YzogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0KICAgID4gLS0tDQogICAgPiB2
Mjogd3JhcCB0aGUgbGluZSBpbiBuZXQvY29yZS9maWx0ZXIuYyB0byBsZXNzIHRoYW4gODAgY2hh
cnMuDQoNCiAgICBTR1RNICh0aGUgb3RoZXIgdmVyc2lvbiB3YXMgYWxzbyBmaW5lLCB0aGUgODAg
Y2hhcnMgcnVsZSBoYXMgYmVlbg0KICAgIHJlbGF4ZWQvY2hhbmdlZCB0byAxMDAgcmVjZW50bHkp
DQoNCiAgICBSZXZpZXdlZC1ieTogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0K
DQo=

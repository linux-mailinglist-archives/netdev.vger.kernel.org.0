Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E391693F9B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBMI2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjBMI22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:28:28 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA149022;
        Mon, 13 Feb 2023 00:28:17 -0800 (PST)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8B9Fa017455;
        Mon, 13 Feb 2023 08:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=0fP5Zve1TkQ+xhcs43Crfwo1mV/wQUPyJ4Wqi7N4/JU=;
 b=S1mLpx9ULtToTmI7Os7yDSY/vMM5+fg8SWSqpL5zNpqOT9+/8ocK/q6koZIGIt+erGOF
 +tZQN3Bcj3Zjz+f9NKNqyD2I2q9Iu5wYi2Y9iwjanR6VMGc21LtYWLi/VGiPc5jwR+/O
 i51wCwD5HGv/DoUiyK7k2j61KZ8lRJ5eOQBvo7t3wBNJC97K+8fmQwqDbN7k89n5J29m
 oS4LxVzLnZdE1mLwhal6n7en9IUbWw/396s+uWt4alleNfRNAktwKx7NALnK+FuwfiuU
 OQBfxVP/LStDiWXAStwUKggyuDxBGR1RCs2Mm+jfNM0fQPyF8s0ILjlzX9ydcuVt9kxi Kw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3np0cw3uu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:27:59 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31D8RvKt003230
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:27:57 GMT
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nalasex01c.na.qualcomm.com (10.47.97.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 00:27:57 -0800
Received: from nalasex01b.na.qualcomm.com ([fe80::22fd:4ef9:dc45:1a47]) by
 nalasex01b.na.qualcomm.com ([fe80::22fd:4ef9:dc45:1a47%12]) with mapi id
 15.02.0986.036; Mon, 13 Feb 2023 00:27:57 -0800
From:   "Tim Jiang (QUIC)" <quic_tjiang@quicinc.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     Steev Klimaszewski <steev@kali.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Mark Pearson <markpearson@lenovo.com>
Subject: RE: [PATCH v4 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Thread-Topic: [PATCH v4 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Thread-Index: AQHZPCHQDIGeCQOJhkSL2tGUe91V0K7GTOXggAFeeICABODlAA==
Date:   Mon, 13 Feb 2023 08:27:57 +0000
Message-ID: <3b468450c72441efb1935ea27f79ff96@quicinc.com>
References: <CABBYNZLaOcYU-2HsSuJy4E6-OyfffmZdfK5mxWY=Wto4G84ySA@mail.gmail.com>
 <20230209005932.4351-1-steev@kali.org>
 <d9a93aae154243baac83b15c8f7ef0ee@quicinc.com>
 <CABBYNZLi7U21s0ZY8jPvpXs8wbnjrVHtJpdKv6fykoGRD0fjOA@mail.gmail.com>
In-Reply-To: <CABBYNZLi7U21s0ZY8jPvpXs8wbnjrVHtJpdKv6fykoGRD0fjOA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.253.79.68]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: pNDQeCNUpAhfBfLSbgGN8podlJwWFawd
X-Proofpoint-ORIG-GUID: pNDQeCNUpAhfBfLSbgGN8podlJwWFawd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 phishscore=0
 mlxlogscore=722 clxscore=1011 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVpeiBhbmQgYWxsOg0KICBJIGFtIFFDIGJ0IGhvc3QgZ3V5cywgIHRvZGF5IEkgc3luYyB1
cCB3aXRoIHFjIGJ0ZncgdGVhbSBhbmQgY29uY2x1ZGUgZm9sbG93aW5nIHJlc3VsdDoNCjE6IGFz
IEkgbWVudGlvbmVkIGJlZm9yZSwgcWNhMjA2NiBhbmQgd2NuNjg1NSBhcmUgdGhlIHNhbWUgY2hp
cCBmYW1pbHksIGFuZCB0aGV5IGNhbiBzaGFyZSB0aGUgc2FtZSBidGZ3IHBhdGNoLCBhbmQgZGlz
dGluZ3Vpc2ggYnkgdXNpbmcgZGlmZmVyZW50IG52bSBiYXNlZCBvbiBib2FyZCBpZC4NCjI6IEkg
dXBsb2FkIHRoZSBidGZ3IHByZXZpb3VzbHkgZm9yIHFjYTIwNjYgLCB5b3UgY2FuIHJlZmVyIHRv
IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Zpcm13YXJl
L2xpbnV4LWZpcm13YXJlLmdpdC9jb21taXQvP2lkPTJiYTFiZWFhZTBjNjQ5Y2U4YTUwYmFlY2M4
ZGY5ZTgxY2Q1MjRlNjUgLCBhbmQgYWxzbyB3Y242ODU1IGNhbiBzaGFyZSB0byB1c2UgYnRmdyBw
YXRjaCBhbmQgbnZtIHdpdGggcWNhMjA2Ni4NCg0KMzpzdGVldiBwYXRjaCBkb2VzIG5vdCBpbmNs
dWRlIHJlYWQgYm9hcmQgaWQgcGFydCBsb2dpY2FsICwgSSB0aGluayBpdCBpcyBiZXR0ZXIgY29t
YmluZSB0aGUgc3RlZXYgIHBhdGNoIGFuZCBteSBwYXRjaCBpbnRvIG9uZS4NCg0KUmVnYXJkcy4N
ClRpbQ0KIA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogTHVpeiBBdWd1c3Rv
IHZvbiBEZW50eiA8bHVpei5kZW50ekBnbWFpbC5jb20+IA0KU2VudDogRnJpZGF5LCBGZWJydWFy
eSAxMCwgMjAyMyA1OjM4IEFNDQpUbzogVGltIEppYW5nIChRVUlDKSA8cXVpY190amlhbmdAcXVp
Y2luYy5jb20+DQpDYzogU3RlZXYgS2xpbWFzemV3c2tpIDxzdGVldkBrYWxpLm9yZz4NClN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjQgMi80XSBCbHVldG9vdGg6IGhjaV9xY2E6IEFkZCBzdXBwb3J0IGZv
ciBRVEkgQmx1ZXRvb3RoIGNoaXAgd2NuNjg1NQ0KDQpIaSBUaW0sDQoNCk9uIFRodSwgRmViIDks
IDIwMjMgYXQgMTI6NDUgQU0gVGltIEppYW5nIChRVUlDKSA8cXVpY190amlhbmdAcXVpY2luYy5j
b20+IHdyb3RlOg0KPg0KPiBIaSBzdGVldjoNCj4NCj4gNjg1NSBhbmQgMjA2NiBhcmUgdGhlIHNh
bWUgY2hpcCwgdGhlIGRpZmZlcmVuY2UgaXMgNjg1NSB1c2UgMiBBTlQgYW5kIDIwNjYgdXNlIDMg
QU5UICwgYnV0IHdlIGhhdmUgbWFueSBudm0gY29uZmlncyBmb3IgMjA2NiBhbmQgNjg1NSAsIHRo
YXQgaXMgdGhlIHNhbWUgLCB5b3UgY2FuIHJlZmVyIHRvIEkgZXZlciBhZGQgc3VwcG9ydCBmb3Ig
Njg1NSB1c2IgLg0KDQpDb3VsZCB5b3UgcGxlYXNlIHJldmlldyBTdGVldiBjaGFuZ2VzLCBhbHNv
IGlmIHlvdSBjb3VsZCBwbGVhc2UgcmVmYWN0b3IgdGhlIGNvZGUgcmVnYXJkaW5nIHRoZSBzb2Nf
dHlwZSwgbWFraW5nIHRoZSBuZWNlc3NhcnkgZmllbGQgYXMgcGFydCBvZiB0aGUgZGF0YSBzdHJ1
Y3R1cmUgc2hvdWxkIG1ha2UgaXQgYSBsb3QgZWFzaWVyIHRvIGFkZCBzdXBwb3J0IGZvciBuZXcg
Y29uZmlndXJhdGlvbnMgd2l0aG91dCBoYXZpbmcgdG8gY2hhbmdlIHRoZSBjb2RlIGluIG11bHRp
cGxlIHBsYWNlcy4NCg0KPiBSZWdhcmRzLg0KPiBUaW0NCj4NCj4NCg0KDQotLQ0KTHVpeiBBdWd1
c3RvIHZvbiBEZW50eg0K

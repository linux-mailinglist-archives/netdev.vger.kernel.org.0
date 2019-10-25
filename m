Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14496E5624
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfJYVup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:50:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19620 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbfJYVuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:50:44 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9PLoOe5000928;
        Fri, 25 Oct 2019 14:50:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=O8jypHNH/8nvoQ7sSn022ipPkg5DhkRVk8Kzkq0ZdZw=;
 b=gLmZUzcpY/f2e4mLLK9YWop8a7E0VhKzoSCJaAW2twN4W1csx7+SQfUuUHpnZb0Hptmo
 tMcLR/yUlB1EdniC/5BvM47GkTCX8M0nqNXHhGDIFPVZ/zvn4KyPkzhAMHQAbr14Yc2m
 k+DgihW+M9m3C1WSlzyU/hzm7pr1ykw9Dq8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vv3dd9xq4-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 25 Oct 2019 14:50:28 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 25 Oct 2019 14:50:19 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 25 Oct 2019 14:50:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRGtNcnd+S2ZrlxWVRcFH21DINifcxEHyh3sve4rxYXGhQWeGzShmTscMq1OHMFffSAB0IGfdZDxSZmYKcb5ReIWdxBuzUN9vUosdwzOmUTc1jWYwrC5KO0UXh1ugvJ9CEPRTJOY/55aCpQ2WZjQPAZ0AsdRxiVJ0Yr8s/9jPQ0C6ZVVYukZ5OKalfNX28aDfZpm/habw7tjP1WUz/BJ6MDGi++BENNbgPtUCD1+xN/TI8jYyW4ThzATZbumgwQnZvtz4g3r8HKfMxuiKDKXYA/s5IyM9YxGAlmpKSvHKuJEBYu5P/j4++HnzxE+iXKIClwnBhVji/BI10KEzgm6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8jypHNH/8nvoQ7sSn022ipPkg5DhkRVk8Kzkq0ZdZw=;
 b=Xbg0jmmDdFq4QaxyR1S3uocnMzCauiDz96vRKoAFZ7GpE7sx5JPoQBD670+B3wLhRs396Tp8mpIeE4PV9O+EkoRt3PnA+rsXtr0y0DHsQZ98YNfvSLE1Dan6kBjrEWiv8VOcneiGPIXVWh+OPr1vAzXfaqKW3BpBA+HJ3rnvkdA8ULGQtajBhmScptR4KOfaV7YVkRspVjgSpBvEAsHiH/soxcYjSPop9aZcigAGUQWNU1yJD740xrmWXPT9stcmQmHLz1WN/QYSDh15fgqL70t0gIk+BZ4G9VUArP2DncnB2C4OBsasFr5zrvYO/nn50J1xK4fSOXzLxO9PVfUQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8jypHNH/8nvoQ7sSn022ipPkg5DhkRVk8Kzkq0ZdZw=;
 b=A2Y2kTp7E8IOFq1qW9foKfoYmxWY2/1413WPiRGnATfwzwg1qadW5dXRhNSh/P7YLFOrZKQIuJU/Ubxg/pwVjFZ+z4oc25bKH+gaMaeDmFsXr2RgudGH/ah47Inkat+l1/S2ajXmGWwXNY1gm/Qw+aenVDsHgz4E8wflaMoIJ54=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3367.namprd15.prod.outlook.com (20.179.56.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Fri, 25 Oct 2019 21:50:18 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 21:50:18 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
CC:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
Thread-Topic: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault
 with llc -march=bpf
Thread-Index: AQHVioSri4sk0mO0YEWOHQh6nT3c5adqEbOAgAALsgCAAcnnAA==
Date:   Fri, 25 Oct 2019 21:50:18 +0000
Message-ID: <62f8d90b-35e0-a97e-952e-7beb71ad29b7@fb.com>
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
 <C47F20A9-D34A-43C9-AAB5-6F125C73FA16@linux.ibm.com>
 <5d2cf6b8-a634-62ea-0b80-1d499aa3c693@fb.com>
 <85F5C807-EDAF-4A85-A5D4-D72FBFFD0A26@linux.ibm.com>
In-Reply-To: <85F5C807-EDAF-4A85-A5D4-D72FBFFD0A26@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0041.namprd02.prod.outlook.com
 (2603:10b6:301:73::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:3057]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36638806-ff93-4e26-2878-08d759955353
x-ms-traffictypediagnostic: BYAPR15MB3367:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <BYAPR15MB33673EA4B63D27832091C84DD3650@BYAPR15MB3367.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(346002)(39860400002)(376002)(189003)(199004)(53754006)(2616005)(11346002)(186003)(386003)(486006)(53546011)(6506007)(46003)(446003)(25786009)(6916009)(476003)(8676002)(4326008)(102836004)(8936002)(5660300002)(81166006)(36756003)(81156014)(6436002)(6486002)(54906003)(229853002)(14444005)(6246003)(6306002)(478600001)(316002)(99286004)(14454004)(966005)(256004)(66946007)(31696002)(71190400001)(71200400001)(305945005)(7736002)(86362001)(66476007)(2906002)(66556008)(66446008)(64756008)(52116002)(6116002)(6512007)(31686004)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3367;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OUtFVIJUXNXwHRyxjaP5LjKnLTz+BWUgUMeOdgbelh5DzmeP3wXcFmYjLFcGnDchlvhf0cXgNDNVPhFoWdp3ClWTmwAbh/pAVXYDkZ98/mYPtnbkv72bT/VfNFg+0OP9h5hdQZ3eLHoJ0UQupKT8iohj9nixlyNfa26piN4SXZIaPbOj+q+/iC6Kw+/oH0t04MubWCtZ4HYUmpDv6xyXC5thndm5GhkQFOATMTZqHC9d4sB3X363dQaGTnlmhdMXRIdFAtXvKanw4Ni5ZbrXuAwSxS9Xz//kOtJrDU0K5ZkEHmGDRG/+NkERY3DUxigFGSOap/97U8J3pq48v9Z4PStXQ3NsadZ20cpqE7Zo9zaHg297Xa9wV9lDZvWC+J3/QuGIODlOsnZZOEyknU2m5icRJEF+DhOSBP/pIJSBDJIVanexlz/FkRB7q61WYE9oIcNjNhEE2QRvNEbpjStVS/oerqyEUFLqDAQ1ZhcmhkY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFB78560852B0C43B87F539D886CE224@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 36638806-ff93-4e26-2878-08d759955353
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 21:50:18.1291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g0HGcIKXvHXBgsK962HTqG9N/m5oOtLyz2aUoUKAZLNiOXenxdJJx4CQjwFV3PV/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_10:2019-10-25,2019-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910250197
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzI0LzE5IDExOjMxIEFNLCBJbHlhIExlb3Noa2V2aWNoIHdyb3RlOg0KPj4gQW0g
MjQuMTAuMjAxOSB1bSAxOTo0OSBzY2hyaWViIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+Og0K
Pj4NCj4+DQo+Pg0KPj4gT24gMTAvMjQvMTkgOTowNCBBTSwgSWx5YSBMZW9zaGtldmljaCB3cm90
ZToNCj4+Pj4gQW0gMjMuMTAuMjAxOSB1bSAwMzozNSBzY2hyaWViIFByYWJoYWthciBLdXNod2Fo
YSA8cHJhYmhha2FyLnBraW5AZ21haWwuY29tPjoNCj4+Pj4NCj4+Pj4NCj4+Pj4gQWRkaW5nIG90
aGVyIG1haWxpbmcgbGlzdCwgZm9sa3MuLi4NCj4+Pj4NCj4+Pj4gSGkgQWxsLA0KPj4+Pg0KPj4+
PiBJIGFtIHRyeWluZyB0byBidWlsZCBrc2VsZnRlc3Qgb24gTGludXgtNS40IG9uIHVidW50dSAx
OC4wNC4gSSBpbnN0YWxsZWQNCj4+Pj4gTExWTS05LjAuMCBhbmQgQ2xhbmctOS4wLjAgZnJvbSBi
ZWxvdyBsaW5rcyBhZnRlciBmb2xsb3dpbmcgc3RlcHMgZnJvbQ0KPj4+PiBbMV0gYmVjYXVzZSBv
ZiBkaXNjdXNzaW9uIFsyXQ0KPj4+Pg0KPj4+PiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2lu
dC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX3JlbGVhc2VzLmxsdm0ub3JnXzkuMC4wX2xsdm0tMkQ5
LjAuMC5zcmMudGFyLnh6JmQ9RHdJRkFnJmM9NVZEMFJUdE5sVGgzeWNkNDFiM01VdyZyPURBOGUx
QjVyMDczdklxUnJGejdNUkEmbT1zZThwVjZPbERBZUYyZzVpRUF2U0IycWhMQkpHUGFIQUR2M05R
Vk5GeDZVJnM9SXpCeE5oQXZjSUxmQURfWGNTQjd0MHM2LUItd0ZZM1RCb1ZHSDZXaFJLOCZlPQ0K
Pj4+PiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0Ff
X3JlbGVhc2VzLmxsdm0ub3JnXzkuMC4wX2NsYW5nLTJEdG9vbHMtMkRleHRyYS0yRDkuMC4wLnNy
Yy50YXIueHomZD1Ed0lGQWcmYz01VkQwUlR0TmxUaDN5Y2Q0MWIzTVV3JnI9REE4ZTFCNXIwNzN2
SXFSckZ6N01SQSZtPXNlOHBWNk9sREFlRjJnNWlFQXZTQjJxaExCSkdQYUhBRHYzTlFWTkZ4NlUm
cz1La2pDaldtX3EyaU1mRmg1MHJUS3RGcVFFTWJSQlZoVDlPaDhLTWZnd1c0JmU9DQo+Pj4+IGh0
dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcmVsZWFz
ZXMubGx2bS5vcmdfOS4wLjBfY2ZlLTJEOS4wLjAuc3JjLnRhci54eiZkPUR3SUZBZyZjPTVWRDBS
VHRObFRoM3ljZDQxYjNNVXcmcj1EQThlMUI1cjA3M3ZJcVJyRno3TVJBJm09c2U4cFY2T2xEQWVG
Mmc1aUVBdlNCMnFoTEJKR1BhSEFEdjNOUVZORng2VSZzPVR2a045c2I1clNCNUJOeEpQMjdVbUNz
Zk5Ic1JRZGFWZUFuQmExVGt5ak0mZT0NCj4+Pj4NCj4+Pj4gTm93LCBpIGFtIHRyeWluZyB3aXRo
IGxsYyAtbWFyY2g9YnBmLCB3aXRoIHRoaXMgc2VnbWVudGF0aW9uIGZhdWx0IGlzDQo+Pj4+IGNv
bWluZyBhcyBiZWxvdzoNCj4+Pj4NCj4+Pj4gZ2NjIC1nIC1XYWxsIC1PMiAtSS4uLy4uLy4uL2lu
Y2x1ZGUvdWFwaSAtSS4uLy4uLy4uL2xpYg0KPj4+PiAtSS4uLy4uLy4uL2xpYi9icGYgLUkuLi8u
Li8uLi8uLi9pbmNsdWRlL2dlbmVyYXRlZCAtREhBVkVfR0VOSERSDQo+Pj4+IC1JLi4vLi4vLi4v
aW5jbHVkZSAtRGJwZl9wcm9nX2xvYWQ9YnBmX3Byb2dfdGVzdF9sb2FkDQo+Pj4+IC1EYnBmX2xv
YWRfcHJvZ3JhbT1icGZfdGVzdF9sb2FkX3Byb2dyYW0gICAgdGVzdF9mbG93X2Rpc3NlY3Rvci5j
DQo+Pj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Rlc3Rfc3R1Yi5vDQo+Pj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL2xpYmJwZi5hIC1sY2FwIC1sZWxmDQo+Pj4+IC1scnQgLWxwdGhyZWFkIC1v
DQo+Pj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Rlc3RfZmxvd19kaXNzZWN0b3INCj4+Pj4gZ2NjIC1nIC1XYWxsIC1PMiAtSS4uLy4uLy4uL2lu
Y2x1ZGUvdWFwaSAtSS4uLy4uLy4uL2xpYg0KPj4+PiAtSS4uLy4uLy4uL2xpYi9icGYgLUkuLi8u
Li8uLi8uLi9pbmNsdWRlL2dlbmVyYXRlZCAtREhBVkVfR0VOSERSDQo+Pj4+IC1JLi4vLi4vLi4v
aW5jbHVkZSAtRGJwZl9wcm9nX2xvYWQ9YnBmX3Byb2dfdGVzdF9sb2FkDQo+Pj4+IC1EYnBmX2xv
YWRfcHJvZ3JhbT1icGZfdGVzdF9sb2FkX3Byb2dyYW0NCj4+Pj4gdGVzdF90Y3BfY2hlY2tfc3lu
Y29va2llX3VzZXIuYw0KPj4+PiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi90ZXN0X3N0dWIubw0KPj4+PiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9saWJicGYuYSAtbGNhcCAtbGVsZg0KPj4+PiAtbHJ0
IC1scHRocmVhZCAtbw0KPj4+PiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi90ZXN0X3RjcF9jaGVja19zeW5jb29raWVfdXNlcg0KPj4+PiBnY2MgLWcg
LVdhbGwgLU8yIC1JLi4vLi4vLi4vaW5jbHVkZS91YXBpIC1JLi4vLi4vLi4vbGliDQo+Pj4+IC1J
Li4vLi4vLi4vbGliL2JwZiAtSS4uLy4uLy4uLy4uL2luY2x1ZGUvZ2VuZXJhdGVkIC1ESEFWRV9H
RU5IRFINCj4+Pj4gLUkuLi8uLi8uLi9pbmNsdWRlIC1EYnBmX3Byb2dfbG9hZD1icGZfcHJvZ190
ZXN0X2xvYWQNCj4+Pj4gLURicGZfbG9hZF9wcm9ncmFtPWJwZl90ZXN0X2xvYWRfcHJvZ3JhbSAg
ICB0ZXN0X2xpcmNfbW9kZTJfdXNlci5jDQo+Pj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rfc3R1Yi5vDQo+Pj4+IC91c3Ivc3JjL3RvdmFy
ZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2xpYmJwZi5hIC1sY2FwIC1sZWxm
DQo+Pj4+IC1scnQgLWxwdGhyZWFkIC1vDQo+Pj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfbGlyY19tb2RlMl91c2VyDQo+Pj4+IChjbGFu
ZyAtSS4gLUkuL2luY2x1ZGUvdWFwaSAtSS4uLy4uLy4uL2luY2x1ZGUvdWFwaQ0KPj4+PiAtSS91
c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmLy4uL3Vzci9p
bmNsdWRlDQo+Pj4+IC1EX19UQVJHRVRfQVJDSF9hcm02NCAtZyAtaWRpcmFmdGVyIC91c3IvbG9j
YWwvaW5jbHVkZSAtaWRpcmFmdGVyDQo+Pj4+IC91c3IvbG9jYWwvbGliL2NsYW5nLzkuMC4wL2lu
Y2x1ZGUgLWlkaXJhZnRlcg0KPj4+PiAvdXNyL2luY2x1ZGUvYWFyY2g2NC1saW51eC1nbnUgLWlk
aXJhZnRlciAvdXNyL2luY2x1ZGUNCj4+Pj4gLVduby1jb21wYXJlLWRpc3RpbmN0LXBvaW50ZXIt
dHlwZXMgLU8yIC10YXJnZXQgYnBmIC1lbWl0LWxsdm0gXA0KPj4+PiAtYyBwcm9ncy90ZXN0X2Nv
cmVfcmVsb2NfYXJyYXlzLmMgLW8gLSB8fCBlY2hvICJjbGFuZyBmYWlsZWQiKSB8IFwNCj4+Pj4g
bGxjIC1tYXJjaD1icGYgLW1jcHU9cHJvYmUgIC1maWxldHlwZT1vYmogLW8NCj4+Pj4gL3Vzci9z
cmMvdG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9jb3JlX3Jl
bG9jX2FycmF5cy5vDQo+Pj4+IFN0YWNrIGR1bXA6DQo+Pj4+IDAuIFByb2dyYW0gYXJndW1lbnRz
OiBsbGMgLW1hcmNoPWJwZiAtbWNwdT1wcm9iZSAtZmlsZXR5cGU9b2JqIC1vDQo+Pj4+IC91c3Iv
c3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfY29yZV9y
ZWxvY19hcnJheXMubw0KPj4+PiAxLiBSdW5uaW5nIHBhc3MgJ0Z1bmN0aW9uIFBhc3MgTWFuYWdl
cicgb24gbW9kdWxlICc8c3RkaW4+Jy4NCj4+Pj4gMi4gUnVubmluZyBwYXNzICdCUEYgQXNzZW1i
bHkgUHJpbnRlcicgb24gZnVuY3Rpb24gJ0B0ZXN0X2NvcmVfYXJyYXlzJw0KPj4+PiAjMCAweDAw
MDBhYWFhYzYxOGRiMDggbGx2bTo6c3lzOjpQcmludFN0YWNrVHJhY2UobGx2bTo6cmF3X29zdHJl
YW0mKQ0KPj4+PiAoL3Vzci9sb2NhbC9iaW4vbGxjKzB4MTUyZWIwOCkNCj4+Pj4gU2VnbWVudGF0
aW9uIGZhdWx0DQo+Pj4NCj4+PiBIaSwNCj4+Pg0KPj4+IEZXSVcgSSBjYW4gY29uZmlybSB0aGF0
IHRoaXMgaXMgaGFwcGVuaW5nIG9uIHMzOTAgdG9vIHdpdGggbGx2bS1wcm9qZWN0DQo+Pj4gY29t
bWl0IDk1MGI4MDBjNDUxZi4NCj4+Pg0KPj4+IEhlcmUgaXMgdGhlIHJlZHVjZWQgc2FtcGxlIHRo
YXQgdHJpZ2dlcnMgdGhpcyAod2l0aCAtbWFyY2g9YnBmDQo+Pj4gLW1hdHRyPSthbHUzMik6DQo+
Pj4NCj4+PiBzdHJ1Y3QgYiB7DQo+Pj4gICAgaW50IGU7DQo+Pj4gfSBjOw0KPj4+IGludCBmKCkg
ew0KPj4+ICAgIHJldHVybiBfX2J1aWx0aW5fcHJlc2VydmVfZmllbGRfaW5mbyhjLmUsIDApOw0K
Pj4+IH0NCj4+Pg0KPj4+IFRoaXMgaXMgY29tcGlsZWQgaW50bzoNCj4+Pg0KPj4+IDBCICAgICAg
YmIuMCAoJWlyLWJsb2NrLjApOg0KPj4+IDE2QiAgICAgICAlMDpncHIgPSBMRF9pbW02NCBAImI6
MDowJDA6MCINCj4+PiAzMkIgICAgICAgJHcwID0gQ09QWSAlMDpncHIsIGRlYnVnLWxvY2F0aW9u
ICExNzsgMS1FLmM6NTozDQo+Pj4gNDhCICAgICAgIFJFVCBpbXBsaWNpdCBraWxsZWQgJHcwLCBk
ZWJ1Zy1sb2NhdGlvbiAhMTc7IDEtRS5jOjU6Mw0KPj4+DQo+Pj4gYW5kIHRoZW4gQlBGSW5zdHJJ
bmZvOjpjb3B5UGh5c1JlZyBjaG9rZXMgb24gQ09QWSwgc2luY2UgJHcwIGFuZCAlMCBhcmUNCj4+
PiBpbiBkaWZmZXJlbnQgcmVnaXN0ZXIgY2xhc3Nlcy4NCj4+DQo+PiBJbHlhLA0KPj4NCj4+IFRo
YW5rcyBmb3IgcmVwb3J0aW5nLiBJIGNhbiByZXByb2R1Y2UgdGhlIGlzc3VlIHdpdGggbGF0ZXN0
IHRydW5rLg0KPj4gSSB3aWxsIGludmVzdGlnYXRlIGFuZCBmaXggdGhlIHByb2JsZW0gc29vbi4N
Cj4+DQo+PiBZb25naG9uZw0KPiANCj4gVGhhbmtzIGZvciB0YWtpbmcgY2FyZSBvZiB0aGlzISBK
dXN0IEZZSSwgYmlzZWN0IHBvaW50ZWQgdG8gMDVlNDY5NzlkMmY0DQo+ICgiW0JQRl0gZG8gY29t
cGlsZS1vbmNlIHJ1bi1ldmVyeXdoZXJlIHJlbG9jYXRpb24gZm9yIGJpdGZpZWxkcyIpLg0KPiAN
Cj4gQ291bGQgeW91IHBsZWFzZSBhZGQgbWUgdG8gUGhhYnJpY2F0b3IgcmV2aWV3PyBJJ20gY3Vy
aW91cyB3aGF0IHRoZQ0KDQpJIGRpZCBhZGQgeW91IGluIHRoZSBkaWZmIGh0dHBzOi8vcmV2aWV3
cy5sbHZtLm9yZy9ENjk0MzguDQoNCj4gcHJvcGVyIHNvbHV0aW9uIGlzIGdvaW5nIHRvIGJlLCBh
cyBJJ20gc3RpbGwgbm90IHN1cmUgd2hldGhlciBoYW5kbGluZw0KPiBhc3ltbWV0cmljIGNvcGll
cyBpcyB0aGUgcmlnaHQgYXBwcm9hY2gsIG9yIHdoZXRoZXIgdGhleSBzaG91bGQgcmF0aGVyDQo+
IGJlIHByZXZlbnRlZCBmcm9tIG9jY3VyaW5nIGluIHRoZSBmaXJzdCBwbGFjZS4NCg0KVGhlIGNo
YW5nZSBoYXMgYmVlbiBwdXNoZWQgaW50byB0aGUgdHJ1bmsuDQpXZSBpbmRlZWQgdXNlZCBhc3lt
bWV0cmljIGNvcHkuIFBsZWFzZSBkbyBsZXQgbWUga25vdyBpZiB5b3UgdGhpbmsNCnRoZXJlIGlz
IGEgYmV0dGVyIHdheSB0byBkbyB0aGF0LiBUaGFua3MhDQoNCj4gDQo+IEJlc3QgcmVnYXJkcywN
Cj4gSWx5YQ0KPiANCg==

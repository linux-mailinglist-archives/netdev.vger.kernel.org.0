Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C829177AB5
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbfG0RLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:11:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40684 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387665AbfG0RLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:11:44 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RH91FN001722;
        Sat, 27 Jul 2019 10:11:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XbJgiJySARGR6gg8Sucm+3v/aiQE8xbVfI3YzTQzd1I=;
 b=U7I/gVIcGleyAscrKWTCsElUf7XLyw5aTnC0JBeDMGDFPGt3/zJyj6yHCfrBMhjEEpXP
 i8dlQoE7DJfgMzYI4GxYBZ0CvJ/vQ3PP0yUuC6o/b8yNu2PeEGN2T0K+3zuez3c1GCMK
 Kwdb4umzSMjUPPiqBlIaBPRi6P/+4rPebxk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0hwm988f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 10:11:20 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 10:11:19 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 10:11:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtzLPy81qd5nUo/rgv4qX93cD5nl18+yvgaaIYNVyn5Qvea+9DA3ubKEwHTomaJzbPIxiJpkQ0xfFYGzhjyOI7QQZqoColXxMtA8VQp1VbKkoLZniD2WVOWF+83nO9S8IwzYTm5GbZ7W0z0awZ16yFGeQ/fz79qRZ0a1KdB+kaGyjhIygLQZ4o98SpEEZQQw5r99Vntj3Wrhb8ax2+AN0jR4uXy4lRUuyBkDUChPNKZ51EbYZQZQ9n3p06DwiowsgbCI3tgaprg3UWcCZy3DyPt61DsYOwU6w8PEBRHY3le6KLoTadGYhXblF9RIySOWgOo1xi9QwqEJa90hhZfhQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbJgiJySARGR6gg8Sucm+3v/aiQE8xbVfI3YzTQzd1I=;
 b=Fa7rkdQ7WmBBhzqcTy4z82sG42li9KMuY+VGGaCzRsz4o4dhCrWLe7bxjjqmUW05eHZfqkGIiMPi61a2sm75VTx6pj+VgU90AB2zFBW4hOQ8ErS1cJvHqFPlCKmzFD7V0TmTVT4wwCScOa+jyER4/CnxL3thWusBRnTGYXfwCPeXVULsS+C9lCNq7fP+hVfhsFMxaaNJhAqpWS67EGp2YsMDeSlC+jb8f06UzjddvxndoGXoObH2lnJfo37jnB4AQoIyF1+S0SsrYziaJaqCZ22iW8lyIzaNq3r+cGGNcq6woYp+kgFZYW4lQ5iAGgqEs32Rf9iJcTxA5SOe0BqYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbJgiJySARGR6gg8Sucm+3v/aiQE8xbVfI3YzTQzd1I=;
 b=MTXvHVEbOvYRDiovCNxb9pFvpQrwSrPgyanU/5i2inkoF3Zp3IxGQ7zphDIRPGXgH8DxRB4UMvhfbu+CNnaEBjzOOZZnl3DhAHzycFPWdQTaba+UHQ0O6SBfv/jSkOmay1a3wWPPdoNKczUt7awsHr1tRtHX3CPZ+CkdVrIBATg=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2278.namprd15.prod.outlook.com (52.135.197.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Sat, 27 Jul 2019 17:11:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 17:11:00 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Topic: next-20190723: bpf/seccomp - systemd/journald issue?
Thread-Index: AQHVQ4xS9PP3XA7/nkqulb+RBeHJq6bcleMAgADHHgCAAAbMgP//jN8AgAEkTwyAAAsRgIAAlVuA
Date:   Sat, 27 Jul 2019 17:11:00 +0000
Message-ID: <57169960-35c2-d9d3-94e4-3b5a43d5aca7@fb.com>
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com>
 <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com>
 <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
 <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
 <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
 <CA+icZUWVf6AK3bxfWBZ7iM1QTyk_G-4+1_LyK0jkoBDkDzvx4Q@mail.gmail.com>
In-Reply-To: <CA+icZUWVf6AK3bxfWBZ7iM1QTyk_G-4+1_LyK0jkoBDkDzvx4Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0043.namprd21.prod.outlook.com
 (2603:10b6:300:129::29) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:16cd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 671d14e5-a896-4a13-6902-08d712b565a5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2278;
x-ms-traffictypediagnostic: BYAPR15MB2278:
x-microsoft-antispam-prvs: <BYAPR15MB2278F52C2719FE879F0FF004D3C30@BYAPR15MB2278.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(376002)(346002)(39860400002)(45914002)(189003)(31014005)(199004)(40764003)(11346002)(316002)(76176011)(386003)(2906002)(6246003)(486006)(7416002)(102836004)(2501003)(68736007)(8936002)(46003)(476003)(446003)(6506007)(53546011)(36756003)(71200400001)(86362001)(31696002)(81156014)(5660300002)(81166006)(8676002)(14454004)(256004)(66946007)(66476007)(64756008)(66556008)(66446008)(6486002)(229853002)(6436002)(14444005)(6512007)(110136005)(478600001)(25786009)(186003)(4326008)(99286004)(7736002)(31686004)(2616005)(71190400001)(52116002)(53936002)(305945005)(54906003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2278;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TpDyj4QiToJBf8Df892InJqmC9JhVx/E6NxKLfueYtEfd9xnOF3OQMfts5+XOuzaAY5w+FH2sJpggtJw9J+SELjTEfKKPix4nwmJrB3xF2FxUpwEry+CUMCDTbfsNMVLBqR/1u4m6qWSWCYEBwff4bK1/VuZAEVwhwxuj1a5WG8GV02X2RLUkXCh0rm9/1fYzQSOpCr+Sal0X3mrZ2J8OKzNLFg7uMYZ206yrwZgfTVuDEL4jq9Pj7Sua91JrsKr8/R4b7FS+Z3RfnghwXN4bR2GoUeOf77zHktm4vERNibz9TfJfrs7W/4qHhTv+sBTpwN0ENiM1vrodnzHdiye6qoAaSbXd5t7DIsGKmMV24It/UuYsT5suD2m+DynxUm/JKZmZLyX8MwhDRcf3edmk2CoOO79vgpqFqlUyNEf3As=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FD579B668FC6A41A7DC1FA6A4E5E21E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 671d14e5-a896-4a13-6902-08d712b565a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 17:11:00.2402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2278
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjcvMTkgMToxNiBBTSwgU2VkYXQgRGlsZWsgd3JvdGU6DQo+IE9uIFNhdCwgSnVs
IDI3LCAyMDE5IGF0IDk6MzYgQU0gU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4g
d3JvdGU6DQo+Pg0KPj4gT24gU2F0LCBKdWwgMjcsIDIwMTkgYXQgNDoyNCBBTSBBbGV4ZWkgU3Rh
cm92b2l0b3YNCj4+IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPiB3cm90ZToNCj4+Pg0K
Pj4+IE9uIEZyaSwgSnVsIDI2LCAyMDE5IGF0IDI6MTkgUE0gU2VkYXQgRGlsZWsgPHNlZGF0LmRp
bGVrQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4+DQo+Pj4+IE9uIEZyaSwgSnVsIDI2LCAyMDE5IGF0
IDExOjEwIFBNIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdyb3RlOg0KPj4+Pj4NCj4+Pj4+
DQo+Pj4+Pg0KPj4+Pj4gT24gNy8yNi8xOSAyOjAyIFBNLCBTZWRhdCBEaWxlayB3cm90ZToNCj4+
Pj4+PiBPbiBGcmksIEp1bCAyNiwgMjAxOSBhdCAxMDozOCBQTSBTZWRhdCBEaWxlayA8c2VkYXQu
ZGlsZWtAZ21haWwuY29tPiB3cm90ZToNCj4+Pj4+Pj4NCj4+Pj4+Pj4gSGkgWW9uZ2hvbmcgU29u
ZywNCj4+Pj4+Pj4NCj4+Pj4+Pj4gT24gRnJpLCBKdWwgMjYsIDIwMTkgYXQgNTo0NSBQTSBZb25n
aG9uZyBTb25nIDx5aHNAZmIuY29tPiB3cm90ZToNCj4+Pj4+Pj4+DQo+Pj4+Pj4+Pg0KPj4+Pj4+
Pj4NCj4+Pj4+Pj4+IE9uIDcvMjYvMTkgMToyNiBBTSwgU2VkYXQgRGlsZWsgd3JvdGU6DQo+Pj4+
Pj4+Pj4gSGksDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBJIGhhdmUgb3BlbmVkIGEgbmV3IGlzc3Vl
IGluIHRoZSBDbGFuZ0J1aWx0TGludXggaXNzdWUgdHJhY2tlci4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+
PiBHbGFkIHRvIGtub3cgY2xhbmcgOSBoYXMgYXNtIGdvdG8gc3VwcG9ydCBhbmQgbm93IEl0IGNh
biBjb21waWxlDQo+Pj4+Pj4+PiBrZXJuZWwgYWdhaW4uDQo+Pj4+Pj4+Pg0KPj4+Pj4+Pg0KPj4+
Pj4+PiBZdXBwLg0KPj4+Pj4+Pg0KPj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4gSSBhbSBzZWVpbmcgYSBw
cm9ibGVtIGluIHRoZSBhcmVhIGJwZi9zZWNjb21wIGNhdXNpbmcNCj4+Pj4+Pj4+PiBzeXN0ZW1k
L2pvdXJuYWxkL3VkZXZkIHNlcnZpY2VzIHRvIGZhaWwuDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBb
RnJpIEp1bCAyNiAwODowODo0MyAyMDE5XSBzeXN0ZW1kWzQ1M106IHN5c3RlbWQtdWRldmQuc2Vy
dmljZTogRmFpbGVkDQo+Pj4+Pj4+Pj4gdG8gY29ubmVjdCBzdGRvdXQgdG8gdGhlIGpvdXJuYWwg
c29ja2V0LCBpZ25vcmluZzogQ29ubmVjdGlvbiByZWZ1c2VkDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+
PiBUaGlzIGhhcHBlbnMgd2hlbiBJIHVzZSB0aGUgKExMVk0pIExMRCBsZC5sbGQtOSBsaW5rZXIg
YnV0IG5vdCB3aXRoDQo+Pj4+Pj4+Pj4gQkZEIGxpbmtlciBsZC5iZmQgb24gRGViaWFuL2J1c3Rl
ciBBTUQ2NC4NCj4+Pj4+Pj4+PiBJbiBib3RoIGNhc2VzIEkgdXNlIGNsYW5nLTkgKHByZXJlbGVh
c2UpLg0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IExvb2tzIGxpa2UgaXQgaXMgYSBsbGQgYnVnLg0KPj4+
Pj4+Pj4NCj4+Pj4+Pj4+IEkgc2VlIHRoZSBzdGFjayB0cmFjZSBoYXMgX19icGZfcHJvZ19ydW4z
MigpIHdoaWNoIGlzIHVzZWQgYnkNCj4+Pj4+Pj4+IGtlcm5lbCBicGYgaW50ZXJwcmV0ZXIuIENv
dWxkIHlvdSB0cnkgdG8gZW5hYmxlIGJwZiBqaXQNCj4+Pj4+Pj4+ICAgICAgc3lzY3RsIG5ldC5j
b3JlLmJwZl9qaXRfZW5hYmxlID0gMQ0KPj4+Pj4+Pj4gSWYgdGhpcyBwYXNzZWQsIGl0IHdpbGwg
cHJvdmUgaXQgaXMgaW50ZXJwcmV0ZXIgcmVsYXRlZC4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+DQo+Pj4+
Pj4+IEFmdGVyLi4uDQo+Pj4+Pj4+DQo+Pj4+Pj4+IHN5c2N0bCAtdyBuZXQuY29yZS5icGZfaml0
X2VuYWJsZT0xDQo+Pj4+Pj4+DQo+Pj4+Pj4+IEkgY2FuIHN0YXJ0IGFsbCBmYWlsZWQgc3lzdGVt
ZCBzZXJ2aWNlcy4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gc3lzdGVtZC1qb3VybmFsZC5zZXJ2aWNlDQo+
Pj4+Pj4+IHN5c3RlbWQtdWRldmQuc2VydmljZQ0KPj4+Pj4+PiBoYXZlZ2VkLnNlcnZpY2UNCj4+
Pj4+Pj4NCj4+Pj4+Pj4gVGhpcyBpcyBpbiBtYWludGVuYW5jZSBtb2RlLg0KPj4+Pj4+Pg0KPj4+
Pj4+PiBXaGF0IGlzIG5leHQ6IERvIHNldCBhIHBlcm1hbmVudCBzeXNjdGwgc2V0dGluZyBmb3Ig
bmV0LmNvcmUuYnBmX2ppdF9lbmFibGU/DQo+Pj4+Pj4+DQo+Pj4+Pj4NCj4+Pj4+PiBUaGlzIGlz
IHdoYXQgSSBkaWQ6DQo+Pj4+Pg0KPj4+Pj4gSSBwcm9iYWJseSB3b24ndCBoYXZlIGN5Y2xlcyB0
byBkZWJ1ZyB0aGlzIHBvdGVudGlhbCBsbGQgaXNzdWUuDQo+Pj4+PiBNYXliZSB5b3UgYWxyZWFk
eSBkaWQsIEkgc3VnZ2VzdCB5b3UgcHV0IGVub3VnaCByZXByb2R1Y2libGUNCj4+Pj4+IGRldGFp
bHMgaW4gdGhlIGJ1ZyB5b3UgZmlsZWQgYWdhaW5zdCBsbGQgc28gdGhleSBjYW4gdGFrZSBhIGxv
b2suDQo+Pj4+Pg0KPj4+Pg0KPj4+PiBJIHVuZGVyc3RhbmQgYW5kIHdpbGwgcHV0IHRoZSBqb3Vy
bmFsY3RsLWxvZyBpbnRvIHRoZSBDQkwgaXNzdWUNCj4+Pj4gdHJhY2tlciBhbmQgdXBkYXRlIGlu
Zm9ybWF0aW9ucy4NCj4+Pj4NCj4+Pj4gVGhhbmtzIGZvciB5b3VyIGhlbHAgdW5kZXJzdGFuZGlu
ZyB0aGUgQlBGIGNvcnJlbGF0aW9ucy4NCj4+Pj4NCj4+Pj4gSXMgc2V0dGluZyAnbmV0LmNvcmUu
YnBmX2ppdF9lbmFibGUgPSAyJyBoZWxwZnVsIGhlcmU/DQo+Pj4NCj4+PiBqaXRfZW5hYmxlPTEg
aXMgZW5vdWdoLg0KPj4+IE9yIHVzZSBDT05GSUdfQlBGX0pJVF9BTFdBWVNfT04gdG8gd29ya2Fy
b3VuZC4NCj4+Pg0KPj4+IEl0IHNvdW5kcyBsaWtlIGNsYW5nIG1pc2NvbXBpbGVzIGludGVycHJl
dGVyLg0KPiANCj4gSnVzdCB0byBjbGFyaWZ5Og0KPiBUaGlzIGRvZXMgbm90IGhhcHBlbiB3aXRo
IGNsYW5nLTkgKyBsZC5iZmQgKEdOVS9sZCBsaW5rZXIpLg0KPiANCj4+PiBtb2Rwcm9iZSB0ZXN0
X2JwZg0KPj4+IHNob3VsZCBiZSBhYmxlIHRvIHBvaW50IG91dCB3aGljaCBwYXJ0IG9mIGludGVy
cHJldGVyIGlzIGJyb2tlbi4NCj4+DQo+PiBNYXliZSB3ZSBuZWVkIHNvbWV0aGluZyBsaWtlLi4u
DQo+Pg0KPj4gImJwZjogRGlzYWJsZSBHQ0MgLWZnY3NlIG9wdGltaXphdGlvbiBmb3IgX19fYnBm
X3Byb2dfcnVuKCkiDQo+Pg0KPj4gLi4uZm9yIGNsYW5nPw0KPj4NCj4gDQo+IE5vdCBzdXJlIGlm
IHNvbWV0aGluZyBsaWtlIEdDQydzLi4uDQo+IA0KPiAtZmdjc2UNCj4gDQo+IFBlcmZvcm0gYSBn
bG9iYWwgY29tbW9uIHN1YmV4cHJlc3Npb24gZWxpbWluYXRpb24gcGFzcy4gVGhpcyBwYXNzIGFs
c28NCj4gcGVyZm9ybXMgZ2xvYmFsIGNvbnN0YW50IGFuZCBjb3B5IHByb3BhZ2F0aW9uLg0KPiAN
Cj4gTm90ZTogV2hlbiBjb21waWxpbmcgYSBwcm9ncmFtIHVzaW5nIGNvbXB1dGVkIGdvdG9zLCBh
IEdDQyBleHRlbnNpb24sDQo+IHlvdSBtYXkgZ2V0IGJldHRlciBydW4tdGltZSBwZXJmb3JtYW5j
ZSBpZiB5b3UgZGlzYWJsZSB0aGUgZ2xvYmFsDQo+IGNvbW1vbiBzdWJleHByZXNzaW9uIGVsaW1p
bmF0aW9uIHBhc3MgYnkgYWRkaW5nIC1mbm8tZ2NzZSB0byB0aGUNCj4gY29tbWFuZCBsaW5lLg0K
PiANCj4gRW5hYmxlZCBhdCBsZXZlbHMgLU8yLCAtTzMsIC1Pcy4NCj4gDQo+IC4uLmlzIGF2YWls
YWJsZSBmb3IgY2xhbmcuDQo+IA0KPiBJIHRyaWVkIHdpdGggaG9wcGluZyB0byB0dXJuIG9mZiAi
Z2xvYmFsIGNvbW1vbiBzdWJleHByZXNzaW9uIGVsaW1pbmF0aW9uIjoNCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9uZXQvTWFrZWZpbGUgYi9hcmNoL3g4Ni9uZXQvTWFrZWZpbGUNCj4gaW5k
ZXggMzgzYzg3MzAwYjBkLi45MmY5MzRhMWU5ZmYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L25l
dC9NYWtlZmlsZQ0KPiArKysgYi9hcmNoL3g4Ni9uZXQvTWFrZWZpbGUNCj4gQEAgLTMsNiArMyw4
IEBADQo+ICAgIyBBcmNoLXNwZWNpZmljIG5ldHdvcmsgbW9kdWxlcw0KPiAgICMNCj4gDQo+ICtL
QlVJTERfQ0ZMQUdTICs9IC1PMA0KDQpUaGlzIHdvbid0IHdvcmsuIEZpcnN0LCB5b3UgYWRkZWQg
dG8gdGhlIHdyb25nIGZpbGUuIFRoZSBpbnRlcnByZXRlcg0KaXMgYXQga2VybmVsL2JwZi9jb3Jl
LmMuDQoNClNlY29uZCwga2VybmVsIG1heSBoYXZlIGNvbXBpbGF0aW9uIGlzc3VlcyB3aXRoIC1P
MC4NCg0KPiArDQo+ICAgaWZlcSAoJChDT05GSUdfWDg2XzMyKSx5KQ0KPiAgICAgICAgICAgb2Jq
LSQoQ09ORklHX0JQRl9KSVQpICs9IGJwZl9qaXRfY29tcDMyLm8NCj4gICBlbHNlDQo+IA0KPiBT
dGlsbCBzZWUuLi4NCj4gQlJPS0VOOiB0ZXN0X2JwZjogIzI5NCBCUEZfTUFYSU5TTlM6IEp1bXAs
IGdhcCwganVtcCwgLi4uIGppdGVkOjANCj4gDQo+IC0gU2VkYXQgLQ0KPiANCg==

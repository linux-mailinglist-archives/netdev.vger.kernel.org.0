Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78ABF86948
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390335AbfHHTDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:03:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48626 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390203AbfHHTDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:03:19 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78IxIGZ011177;
        Thu, 8 Aug 2019 12:03:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=I/Przh46c03xV6VZMV9H/IQoSx3QAVfULtJVLhEjwPw=;
 b=j6sNhniDOLTebO58IcJxW30848pVT+pNsvg6yT+myCVcMh/au2l458KiA+klzk1w/TEP
 zBnxx2MaPGH4ckHHafH0UfXIBuXfQoAEPShdcihzUEtt80VbhrLrG5scUk71g2P3k7cv
 rmqhxeSMEWf+jRVvk1dupdeEJ5XpFPzu6uw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u8p5hgumx-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 12:03:00 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 12:02:56 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 12:02:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLePU30qoW252dBy+gkj4GDnqYsPJfUNjSTjVmBaUZlnBqN9QMg7TcBzMc5USm0w/jboMarbaR+f8AZ6T4iYsDFmfFW+jbQKWSvuQrnZE08whXH7Mg5Uu1AES51XsC9KD1RDRgeb/MOxe9FJauQWfUYWOWufTtPRHwTKKqunGCeoUEdFbva2WDgdl/SW2+FTjaKfRj5pMXUP/kSzjA/rX5QGu7qP97E8MOpFjelKhtBMwcTkIV3uMagoosMEMyEESCeTaBOO9jQnV8leObJRRxy86aOBx3nnxG3K2tGN5CvOoGZAQ2P/eYueuKL8RCyjuCLKMD0B/z3WSXNmq8H2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/Przh46c03xV6VZMV9H/IQoSx3QAVfULtJVLhEjwPw=;
 b=VHxb4KFmpl214XUXZalTH7Qz0T0J/nCsCgpNgk4z9z93Sw65+M1QgtWpqAtTSOymBz4UgjaF8c9AxsPLv7xadQwFhO4eNnxMiBOH25WdqD3AwQvDriYEzzzPuKcWRRHpplCZ/hxf1twUFO0KDTvjlhs9sW1BOn2k0v4HB3Hamtx9MykSSNGUMaFie4FPfe//FTWzLVt2Q6AENuUpZNxeXIDSMP0z2AMUqgUY2OkkaPiwQRLed1zjBZHCR/96RYUTyT3iN82SCjZwHyZa9hj3Mrm/6MsWIV7Wtq3J1NjSH9hJFZa6Tv3MW+pEgZBt1Q3ZHvIfrTFgfyOqlmsGT4zdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/Przh46c03xV6VZMV9H/IQoSx3QAVfULtJVLhEjwPw=;
 b=EZsNLk03AzLO1kwbkMXdnSku6MvipRm4yVOOpN6htnkxFgjwzZ6FCFM7qwMVxYng2ebsLrMVtsWy7yCzRuV6PZSwkpSAZ4YkNLtYMVtIDTZpRKn1MfXjYP/WGodqMNK6RVOCO85NNcYd5zybCjp3V7951QlHCntcaQn6teOLe50=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1791.namprd15.prod.outlook.com (10.174.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 19:02:54 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 19:02:54 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Topic: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Index: AQHVTLYXvEPb5D4KhEGV/bPPR833MKbwAYEAgAAEloCAADQnAIABB7CAgABcZwA=
Date:   Thu, 8 Aug 2019 19:02:54 +0000
Message-ID: <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
In-Reply-To: <20190808133209.GB32706@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:300:115::16) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:919d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12c68498-c21f-4184-31d4-08d71c3304b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1791;
x-ms-traffictypediagnostic: MWHPR15MB1791:
x-microsoft-antispam-prvs: <MWHPR15MB17914E2C3BAF70C9C268F64FB2D70@MWHPR15MB1791.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(396003)(39860400002)(136003)(199004)(189003)(446003)(8676002)(58126008)(486006)(11346002)(6246003)(64126003)(4326008)(316002)(31686004)(53936002)(65956001)(476003)(52116002)(2616005)(54906003)(229853002)(186003)(14454004)(81166006)(102836004)(2906002)(6512007)(81156014)(6506007)(6436002)(386003)(65806001)(53546011)(65826007)(31696002)(66946007)(76176011)(25786009)(99286004)(5660300002)(71190400001)(64756008)(66556008)(66476007)(66446008)(6916009)(7736002)(36756003)(14444005)(305945005)(46003)(71200400001)(86362001)(8936002)(6486002)(256004)(6116002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1791;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vPArJZOEvC6r6nznEa7wGtUEqqhgYDBvFxHYQPVq5bXR/ZsqDwqN3IUwoUuzkT4XdukQailM0DwAqzz+dIQAKZQ+nuZl7dUxRrKzYU89BJ5X6dpiPgLGgdrrdX/9KBoj/hmr3zLyzH4EjNdGpzCTc9QJkOaGlzIt+J1cpql/0zBr8PH4rDcBOWYSgUf+klz+QbqWn0stG+rRljTCh4bj7DKLua3kiXZfrtSefzd6vmceiGurm6bsXD6a8SY6/dsHU2LNv+IjZKayM3U5+Du0ga9Adfx6dg238dC8u0QHMcGLjiv3xBjQKJl6E6S2OzKjTM2gSPoHITEmyWH7p5XYa9RQ95eABGNixkhI2DcPou+zXD6i1hPA7upBAsAzxoQma2+V/D5X6JWKFJ5duFkGkKhLNZEsTy6Gq3BcmdimQAM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <39D5E219252AA445ABFAF136782B7840@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c68498-c21f-4184-31d4-08d71c3304b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 19:02:54.5950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WTk3lWrDFO8UZb7xVavRC8GI6DJHR+Ai4UDl5rxIlt3bWijaxZVmjsOKafjYKzAy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1791
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiA4LzgvMTkgNjozMiBBTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+PiBM
ZXQgbWUgcHJlcGFyZSBwYXRjaCB2MiB1c2luZyBkZXZpY2UgdHJlZS4gSSdtIG5vdCBzdXJlIGlm
IHN0YW5kYXJkDQo+PiAibWFjLWFkZHJlc3MiIGZpdHMgdGhpcyBzaXR1YXRpb24gYmVjYXVzZSBh
bGwgd2UgbmVlZCBpcyBhbiBvZmZzZXQNCj4+IChpbnRlZ2VyKSBhbmQgQk1DIE1BQyBpcyBjYWxj
dWxhdGVkIGJ5IGFkZGluZyB0aGUgb2Zmc2V0IHRvIE5JQydzDQo+PiBNQUMgYWRkcmVzcy4gQW55
d2F5cywgbGV0IG1lIHdvcmsgb3V0IHYyIHBhdGNoIHdlIGNhbiBkaXNjdXNzIG1vcmUNCj4+IHRo
ZW4uDQo+IA0KPiBIaSBUYW8NCj4gDQo+IEkgZG9uJ3Qga25vdyBCTUMgdGVybWlub2xvZ3kuIEJ5
IE5JQ3MgTUFDIGFkZHJlc3MsIHlvdSBhcmUgcmVmZXJyaW5nDQo+IHRvIHRoZSBob3N0cyBNQUMg
YWRkcmVzcz8gVGhlIE1BQyBhZGRyZXNzIHRoZSBiaWcgQ1BVIGlzIHVzaW5nIGZvciBpdHMNCj4g
aW50ZXJmYWNlPyAgV2hlcmUgZG9lcyB0aGlzIE5JQyBnZXQgaXRzIE1BQyBhZGRyZXNzIGZyb20/
IElmIHRoZSBCTUNzDQo+IGJvb3Rsb2FkZXIgaGFzIGFjY2VzcyB0byBpdCwgaXQgY2FuIHNldCB0
aGUgbWFjLWFkZHJlc3MgcHJvcGVydHkgaW4NCj4gdGhlIGRldmljZSB0cmVlLg0KDQpTb3JyeSBm
b3IgdGhlIGNvbmZ1c2lvbiBhbmQgbGV0IG1lIGNsYXJpZnkgbW9yZToNCg0KVGhlIE5JQyBoZXJl
IHJlZmVycyB0byB0aGUgTmV0d29yayBjb250cm9sbGVyIHdoaWNoIHByb3ZpZGUgbmV0d29yayBj
b25uZWN0aXZpdHkgZm9yIGJvdGggQk1DICh2aWEgTkMtU0kpIGFuZCBIb3N0IChmb3IgZXhhbXBs
ZSwgdmlhIFBDSWUpLg0KDQpPbiBGYWNlYm9vayBZYW1wIEJNQywgQk1DIHNlbmRzIE5DU0lfT0VN
X0dFVF9NQUMgY29tbWFuZCAoYXMgYW4gZXRoZXJuZXQgcGFja2V0KSB0byB0aGUgTmV0d29yayBD
b250cm9sbGVyIHdoaWxlIGJyaW5naW5nIHVwIGV0aDAsIGFuZCB0aGUgKEJyb2FkY29tKSBOZXR3
b3JrIENvbnRyb2xsZXIgcmVwbGllcyB3aXRoIHRoZSBCYXNlIE1BQyBBZGRyZXNzIHJlc2VydmVk
IGZvciB0aGUgcGxhdGZvcm0uIEFzIGZvciBZYW1wLCBCYXNlLU1BQyBhbmQgQmFzZS1NQUMrMSBh
cmUgdXNlZCBieSBIb3N0IChiaWcgQ1BVKSBhbmQgQmFzZS1NQUMrMiBhcmUgYXNzaWduZWQgdG8g
Qk1DLiBJbiBteSBvcGluaW9uLCBCYXNlIE1BQyBhbmQgTUFDIGFkZHJlc3MgYXNzaWdubWVudHMg
YXJlIGNvbnRyb2xsZWQgYnkgTmV0d29yayBDb250cm9sbGVyLCB3aGljaCBpcyB0cmFuc3BhcmVu
dCB0byBib3RoIEJNQyBhbmQgSG9zdC4NCg0KSSdtIG5vdCBzdXJlIGlmIEkgdW5kZXJzdGFuZCB5
b3VyIHN1Z2dlc3Rpb24gY29ycmVjdGx5OiBkbyB5b3UgbWVhbiB3ZSBzaG91bGQgbW92ZSB0aGUg
bG9naWMgKEdFVF9NQUMgZnJvbSBOZXR3b3JrIENvbnRyb2xsZXIsIGFkZGluZyBvZmZzZXQgYW5k
IGNvbmZpZ3VyaW5nIEJNQyBNQUMpIGZyb20ga2VybmVsIHRvIGJvb3QgbG9hZGVyPw0KDQpTYW0g
cG9zdGVkIHNldmVyYWwgbmNzaSBwYXRjaGVzIGZvciB1LWJvb3QgcmVjZW50bHkuIFNhbSwgZG8g
d2Ugc3VwcG9ydCB0aGUgd29yayAoaW1wbGVtZW50ZWQgaW4gdGhpcyBwYXRjaCkgaW4gdWJvb3Q/
IE9yIGFyZSB3ZSBwbGFubmluZyB0byBkbyBzbz8NCg0KDQpUaGFua3MsDQoNClRhbw0K

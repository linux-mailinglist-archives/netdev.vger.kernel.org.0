Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E238AE42BF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 07:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392684AbfJYFBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 01:01:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53880 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390186AbfJYFBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 01:01:36 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9OJdaVv030297;
        Thu, 24 Oct 2019 22:01:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/45J4LXuLvErP4BfqBQxDqDMLK76j23/j+7aSrBkYFY=;
 b=OHIHBFG9Wqdz8nSw2Y3TX1IvYbk+ll4MQvZkh8tETYes6UvwkdhGyCWp+FcN4shFRHwC
 JLUda/G7fITY8N4HYUGb9ZR08O/PsVID6Q64LVCGo4X12gjcYTYaOByxHUBSljS3Kv/p
 mPJvBNrFz+WV9kJqvx4flo2dmPzyiEArHcs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vuja7swg2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Oct 2019 22:01:21 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 24 Oct 2019 22:01:20 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Oct 2019 22:01:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDG//6QhU1VWtft5R3uaI0k9UTDVjN7GfojqtRM8Tg91Y3Uw4UnLBtOR7l64JCDxqXOhFUqnkz5i9w0Ls4lBMAKTSQ15MjcX8k8A19qDTrUaQYND+dYlxmnKmKQa2f5nUO6p1/saWarK7OaCzYINEDQOkkT5ZkWkG0qZKLuG3BfP2MurL2/hSATP+L8/KGzz7mKvJyusutlvmBL7gqa0QPtxVzOfPsuWylUV8ZlchD1nCJ2QvEwD7UzfOv/d5uI2NRXxzQvk2Fgv7K9/O2Y5530d04Z9LtkmubiJYr2C53mnn4HzBqgMswIHCu+FpocPytTrn2bHZxaen97j3TAL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/45J4LXuLvErP4BfqBQxDqDMLK76j23/j+7aSrBkYFY=;
 b=alHD2Lx5+N8QEvUf5QIaNKYrV/u9ZrpuansbT1PleGD4FJyuS0qoBtSifhhzLZNStwk4l5QCjzmc2yHOctHNxmBvqXdXM2XlX6/YeAcA/XT/VF9kf1DthL4FyRcWgTsqFuCSoPESUDiYEhc935Aw95oZzrOj5LNKbS1B3EBGAkc7JMJEYRTwuhOgmidA7IMfKT7LSlgRPyryGv0DM7A/42lgyJI9RYUT9HxsKuoUSMp/X9bgAsjdBvB/Y+yh8BEhlw5JAajOKRQYmMr3sTLQumGYuYT6L2nCRkJKnVEJAg/FNNlbF3G+s5Hc2FGLhlJ6MiL+HBg1friy8kdEi9nZZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/45J4LXuLvErP4BfqBQxDqDMLK76j23/j+7aSrBkYFY=;
 b=YyideKEAgolmkJIs67xu+P+0lIsW4xjOMIxK3ACEf05KcS4K4Y11GFdjAOuDUUqEg4outwg3/zl3lKgycVm2yZzGDkxFFo+5LU+8sdL4kG6sXJEobJtcmmqlI1xrz9HquOkfDYvb30InXKofF85bJenhE88jU5zX9GYPpoVPiUA=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1400.namprd15.prod.outlook.com (10.172.158.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 05:01:18 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2347.030; Fri, 25 Oct 2019
 05:01:18 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv2] bpftool: Try to read btf as raw data if elf read fails
Thread-Topic: [PATCHv2] bpftool: Try to read btf as raw data if elf read fails
Thread-Index: AQHVim5Sin1PQXP09kyWla2iBWE3jqdqEzsAgAC6XYA=
Date:   Fri, 25 Oct 2019 05:01:17 +0000
Message-ID: <aeb566cd-42a7-9b3a-d495-c71cdca08b86@fb.com>
References: <20191024132341.8943-1-jolsa@kernel.org>
 <20191024105414.65f7e323@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191024105414.65f7e323@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0006.namprd22.prod.outlook.com
 (2603:10b6:300:ef::16) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f95b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f47f4fc-1bd2-4da7-92e0-08d759085e89
x-ms-traffictypediagnostic: CY4PR15MB1400:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1400C938F532AB4C02FDD210C6650@CY4PR15MB1400.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(51914003)(199004)(189003)(14454004)(31686004)(478600001)(476003)(5660300002)(446003)(2616005)(31696002)(66446008)(66946007)(86362001)(66476007)(11346002)(14444005)(66556008)(6116002)(64756008)(6506007)(53546011)(386003)(46003)(229853002)(71200400001)(71190400001)(2906002)(110136005)(99286004)(58126008)(81156014)(316002)(4326008)(76176011)(305945005)(54906003)(6246003)(52116002)(256004)(6512007)(486006)(7736002)(8676002)(6436002)(6486002)(186003)(25786009)(65956001)(81166006)(65806001)(36756003)(8936002)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1400;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rJVAfRVvNIf6AszTRB+VmvL1ZRTWMZdji8aH/asIf40+hAjVTnRrp2JFmCbyUThLYYNBQkv5DHg9qVqpI4IcIdvwLLiXUve+Q9O5dQArmCBOYFczSOHJg+JHWCneyrWDSQhWUm6q73MG66NPDOXn3eOGaeZxshAdRILHw/kOExgKsrTEjoo9TtkWJ88+qtmm/63W9QqX1l7Pc74OF/Ig0hAuyak+yNzHFHQwo6PRyGbo29jyFlItMoYtSLw/o2UuSqqVMN2SWxoPMeoJutPeyYZwJ9MeX4bDSM8GXBX4eGMlGP+FYuKz4gDE1ZA0bzGUMUjU2/4qsSlNVU+F3G7PRkyQKHaZSuhQmJ8zFOyBHTVO0A8o1qZTbe5yQcBxETXHxyRcmQqv9vAGCtlfi8sUgQiDXGmW8R6oQxbnA2eUCIaP3aRphx4s0U7XFcDxZxSL
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1CE1C6746C8C74F876EF0BC961D2C42@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f47f4fc-1bd2-4da7-92e0-08d759085e89
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 05:01:17.9228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9o1Vy35+tyQ2f2o0fvjFLQnsebhPX3MGhBCDFYU05tU5u2rc3hnaRfYG6ZGXhFrH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1400
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-24_11:2019-10-23,2019-10-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910240184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMjQvMTkgMTA6NTQgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBUaHUsIDI0
IE9jdCAyMDE5IDE1OjIzOjQxICswMjAwLCBKaXJpIE9sc2Egd3JvdGU6DQo+PiBUaGUgYnBmdG9v
bCBpbnRlcmZhY2Ugc3RheXMgdGhlIHNhbWUsIGJ1dCBub3cgaXQncyBwb3NzaWJsZQ0KPj4gdG8g
cnVuIGl0IG92ZXIgQlRGIHJhdyBkYXRhLCBsaWtlOg0KPj4NCj4+ICAgICQgYnBmdG9vbCBidGYg
ZHVtcCBmaWxlIC9zeXMva2VybmVsL2J0Zi92bWxpbnV4DQo+PiAgICBbMV0gSU5UICcoYW5vbikn
IHNpemU9NCBiaXRzX29mZnNldD0wIG5yX2JpdHM9MzIgZW5jb2Rpbmc9KG5vbmUpDQo+PiAgICBb
Ml0gSU5UICdsb25nIHVuc2lnbmVkIGludCcgc2l6ZT04IGJpdHNfb2Zmc2V0PTAgbnJfYml0cz02
NCBlbmNvZGluZz0obm9uZSkNCj4+ICAgIFszXSBDT05TVCAnKGFub24pJyB0eXBlX2lkPTINCj4g
DQo+IE15IGtuZWUgamVyayByZWFjdGlvbiB3b3VsZCBiZSB0byBpbXBsZW1lbnQgYSBuZXcga2V5
d29yZCwgbGlrZToNCj4gDQo+ICQgYnBmdG9vbCBidGYgZHVtcCByYXdmaWxlIC9zeXMva2VybmVs
L2J0Zi92bWxpbnV4DQo+IA0KPiBPciBzdWNoLiBCdXQgcGVyaGFwcyB0aGUgYXV0by1kZXRlY3Rp
b24gaXMgdGhlIHN0YW5kYXJkIHdheSBvZiBkZWFsaW5nDQo+IHdpdGggZGlmZmVyZW50IGZvcm1h
dHMgaW4gdGhlIGNvbXBpbGVyIHdvcmxkLiBSZWdhcmRsZXNzIGlmIGFueW9uZSBoYXMNCj4gYW4g
b3BpbmlvbiBvbmUgd2F5IG9yIHRoZSBvdGhlciBwbGVhc2Ugc2hhcmUhIQ0KDQpJIHRoaW5rIGF1
dG8tZGV0ZWN0aW9uIGluIHRoaXMgY2FzZSBpcyBlYXN5IGFuZCByZWxpYWJsZSwgdGhlcmUgaXMg
bm8gDQp3YXkgdG8gYWNjaWRlbnRhbHkgbWlzdGFrZSBFTEYgZm9yIHJhdyBCVEYgZHVlIHRvIGRp
ZmZlcmVudCBtYWdpY3MuIA0KQmVzaWRlcyB0aGF0LCBpdCdzIHNvIG11Y2ggYmV0dGVyIHVzYWJp
bGl0eSBmb3IgdXNlcnMgdG8gbm90IGhhdmUgdG8gDQpjYXJlLiBQbHVzLCBubyBuZWVkIHRvIGV4
dGVuZCBzaGVsbCBhdXRvLWNvbXBsZXRpb24gc2NyaXB0IDotUA0KDQo+IA0KPj4gU2lnbmVkLW9m
Zi1ieTogSmlyaSBPbHNhIDxqb2xzYUBrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiB2MiBjaGFuZ2Vz
Og0KPj4gICAtIGFkZGVkIGlzX2J0Zl9yYXcgdG8gZmluZCBvdXQgd2hpY2ggYnRmX19wYXJzZV8q
IGZ1bmN0aW9uIHRvIGNhbGwNCj4+ICAgLSBjaGFuZ2VkIGxhYmVscyBhbmQgZXJyb3IgcHJvcGFn
YXRpb24gaW4gYnRmX19wYXJzZV9yYXcNCj4+ICAgLSBkcm9wIHRoZSBlcnIgaW5pdGlhbGl6YXRp
b24sIHdoaWNoIGlzIG5vdCBuZWVkZWQgdW5kZXIgdGhpcyBjaGFuZ2UNCj4gDQo+IFRoZSBjb2Rl
IGxvb2tzIGdvb2QsIHRoYW5rcyBmb3IgdGhlIGNoYW5nZXMhIE9uZSBxdWVzdGlvbiBiZWxvdy4u
DQo+IA0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2JwZi9icGZ0b29sL2J0Zi5jIGIvdG9vbHMvYnBm
L2JwZnRvb2wvYnRmLmMNCj4+IGluZGV4IDlhOTM3NmQxZDNkZi4uYTdiOGJmMjMzY2Y1IDEwMDY0
NA0KPj4gLS0tIGEvdG9vbHMvYnBmL2JwZnRvb2wvYnRmLmMNCj4+ICsrKyBiL3Rvb2xzL2JwZi9i
cGZ0b29sL2J0Zi5jDQo+IA0KPj4gK3N0YXRpYyBib29sIGlzX2J0Zl9yYXcoY29uc3QgY2hhciAq
ZmlsZSkNCj4+ICt7DQo+PiArCV9fdTE2IG1hZ2ljID0gMDsNCj4+ICsJaW50IGZkOw0KPj4gKw0K
Pj4gKwlmZCA9IG9wZW4oZmlsZSwgT19SRE9OTFkpOw0KPj4gKwlpZiAoZmQgPCAwKQ0KPj4gKwkJ
cmV0dXJuIGZhbHNlOw0KPj4gKw0KPj4gKwlyZWFkKGZkLCAmbWFnaWMsIHNpemVvZihtYWdpYykp
Ow0KPj4gKwljbG9zZShmZCk7DQo+PiArCXJldHVybiBtYWdpYyA9PSBCVEZfTUFHSUM7DQo+IA0K
PiBJc24ndCBpdCBzdXNwaWNpb3VzIHRvIHJlYWQoKSAyIGJ5dGVzIGludG8gYW4gdTE2IGFuZCBj
b21wYXJlIHRvIGENCj4gY29uc3RhbnQgbGlrZSBlbmRpYW5uZXNzIGRvZXNuJ3QgbWF0dGVyPyBR
dWljayBncmVwIGRvZXNuJ3QgcmV2ZWFsDQo+IEJURl9NQUdJQyBiZWluZyBlbmRpYW4tYXdhcmUu
Lg0KDQpSaWdodCBub3cgd2Ugc3VwcG9ydCBvbmx5IGxvYWRpbmcgQlRGIGluIG5hdGl2ZSBlbmRp
YW5uZXNzLCBzbyBJIHRoaW5rIA0KdGhpcyBzaG91bGQgZG8uIElmIHdlIGV2ZXIgYWRkIGFiaWxp
dHkgdG8gbG9hZCBub24tbmF0aXZlIGVuZGlhbm5lc3MsIA0KdGhlbiB3ZSdsbCBoYXZlIHRvIGFk
anVzdCB0aGlzLg0KDQo+IA0KPj4gK30NCj4+ICsNCj4+ICAgc3RhdGljIGludCBkb19kdW1wKGlu
dCBhcmdjLCBjaGFyICoqYXJndikNCj4+ICAgew0KPj4gICAJc3RydWN0IGJ0ZiAqYnRmID0gTlVM
TDsNCj4+IEBAIC00NjUsNyArNTE2LDExIEBAIHN0YXRpYyBpbnQgZG9fZHVtcChpbnQgYXJnYywg
Y2hhciAqKmFyZ3YpDQo+PiAgIAkJfQ0KPj4gICAJCU5FWFRfQVJHKCk7DQo+PiAgIAl9IGVsc2Ug
aWYgKGlzX3ByZWZpeChzcmMsICJmaWxlIikpIHsNCj4+IC0JCWJ0ZiA9IGJ0Zl9fcGFyc2VfZWxm
KCphcmd2LCBOVUxMKTsNCj4+ICsJCWlmIChpc19idGZfcmF3KCphcmd2KSkNCj4+ICsJCQlidGYg
PSBidGZfX3BhcnNlX3JhdygqYXJndik7DQo+PiArCQllbHNlDQo+PiArCQkJYnRmID0gYnRmX19w
YXJzZV9lbGYoKmFyZ3YsIE5VTEwpOw0KPj4gICAJCWlmIChJU19FUlIoYnRmKSkgew0KPj4gICAJ
CQllcnIgPSBQVFJfRVJSKGJ0Zik7DQo+PiAgIAkJCWJ0ZiA9IE5VTEw7DQo+IA0KDQo=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469AB16AD50
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgBXR0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:26:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47202 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbgBXR0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:26:18 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OHOvRU019878;
        Mon, 24 Feb 2020 09:25:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CSDZ1BIy+nXx8LYD3pZvEKtx3AOycVhjH2nuMtaAUMY=;
 b=QUXPn/ZI35kUgbWrX0bxkGvlRG1O9t3gGBoidG9wcjQ6E5pVx84SddA8lXTsn+uEjRaL
 z2zrbC1O0khKA5/qiygILeo4A8TXq6CFRWDPAMDVSaLQT28V+tb+LqMSC5p/v7+ziyoD
 dPogMo1I9jnhphoZLGYQzIUCUeLY6Vporfs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ybnyjnxe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Feb 2020 09:25:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 24 Feb 2020 09:25:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFhcL7goWDLI2VUXAdewA/eaz+UtHDKh7AJjk2VNT0GoX7x3PtWvA/s2CaDsNvhgy7BiNFiV3BhZYiRiHKPPgc3hgjenA4/f8kaWqIkfwjtCo9GtRVf8BsZHCekreqm+fnIQTi/AQZoqQXDUSW67h2vCwuTbCHEGjAW7Mk4avb0su/hQLIQsqQ3jDV7sqTXtBvPb0TK09uSOqtKqrTXJGk4bQKuFgYhySLupxEX6Jik+9rE5SiyJEtWXtpLTCmcwNGjgi1n31onWxacCf0ylHYeyVXHI7MT50vV4mGULkvcMQpqlQVXbUthX9DJpqpU/AGgaSNVaS9SUmLItvJ7adg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSDZ1BIy+nXx8LYD3pZvEKtx3AOycVhjH2nuMtaAUMY=;
 b=Kdel6E6UE/YqS6/y7Q711ax+4MfgILNzoOHio01gTbKFmXHiNbg1CFk0C96rChNM9le/5poox2w16/EcTl+kxOqS34BdgceDYJJ+ihqtswjzf6yyghj3CJ80rVFM4587QYhkqMvdaYzWFTELfzQ5DLStrzSR3swebVI0jptip1urYcCXWzyAwb7boorz7pSSEwJDa8joUlgBs6grNAackss1qmAjaUh2/eljVBn9VYxApY9fZiSMyExnodhMZ5DdB/89OOkodkmTBg6SLqz3wtAsMuKmsZbTAfVyCDVL1Gq3DRmmg3295I+JJ6yM/1h5EH029JqiKaBzz1irARig6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSDZ1BIy+nXx8LYD3pZvEKtx3AOycVhjH2nuMtaAUMY=;
 b=dvG05ko+rap6MbiswD138iv2Qx1L0FbyyNimm5SXqo/mvd0cQGhAvGkPop/A+Brg43ymuHJ2ddCCIICPdUORFZEW3ClosyLvmVG1XyFzpNXdtxCahu2xQbwVarX/NDcsF3mb8kk5jz16FSXaS2EOom7cbzCd+uzD05S2I5DXo2w=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2060.namprd15.prod.outlook.com
 (2603:10b6:302:c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22; Mon, 24 Feb
 2020 17:25:33 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2729.033; Mon, 24 Feb 2020
 17:25:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re:   [PATCH][next] netronome: Replace zero-length array with
 flexible-array member
Thread-Topic: [PATCH][next] netronome: Replace zero-length array with
 flexible-array member
Thread-Index: AQHV6zdqnfPUSLbtxUGp3lWXBMx2Lw==
Date:   Mon, 24 Feb 2020 17:25:32 +0000
Message-ID: <D473BD67-78F8-4BDF-91A5-DF90418CAA4C@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.194.140.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f6db1a5-e7ef-43cd-dd49-08d7b94e8d8e
x-ms-traffictypediagnostic: MW2PR1501MB2060:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB206068A7BBF3F36643E970BFB3EC0@MW2PR1501MB2060.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(66476007)(66446008)(64756008)(66556008)(36756003)(76116006)(91956017)(66946007)(4326008)(54906003)(2616005)(316002)(966005)(6486002)(478600001)(6512007)(33656002)(81156014)(86362001)(8936002)(6506007)(81166006)(26005)(186003)(2906002)(6916009)(5660300002)(53546011)(71200400001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2060;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sHJ0BzorCPg/z6fZhBwPFZuGpDSeY0qmAim4/NGCQ7FVvSKxSBSl30IdidkeWY79HgMjaBPW6O54lwogSdm9Vq1GmnAq3DOdBDkEAxaS2TP8cOhyOzCMBPiKzIPdzIPo52RUIb/dIj+zISbP9/5mjCaFCsPNNDzRHSwogScG2QxwgbAuFrsCW28YEX7c8BreqxJovtAoXzORMDEQEZqs6ws2jf18XTHTJLAuWyKmDSh/vrfw7YRoo/ryjx+wqul0hOiaskLjVoEylaYsDioWquXO3VsjZNg8YpnyD0zSUSd/jEZpJm7nRN4vvNnjgGu9vCRCVO1Qr9i7636dQUQr+Nnx7PL9aBiz3QJcfrpvNbNpE2UT+7BA2rClPf+GJvqJ1NuaUBJGbHbDz6teklvUkWQnBErqT40vd+lXeIDOq7MUnd01CvugbdK88PcRF9BN44/kOWBdiUcadBaR/G3zqtaJ7QC+L6acxMR9mvZikmbQs0NDYpQjYDEle6x66n+1XB2VsK+IGZmmo3Nvv5geCA==
x-ms-exchange-antispam-messagedata: ZtQ8tVBwj9PmNFjeeDJQqM6tkLK1gHSunrQ2Bof5qUJ1kZsj4CoIQlQNJBDl3TDfpnmEXhtI8xXhh1VXPToN6Jhi2kM1a/WknMbbvX4eIloHtra65K/SufNohazsqmVUd6Ect3SRJDK+PO9pHKBp1g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C69C6367EFFFB4DB4BD0733EDB6F0CC@fb.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6db1a5-e7ef-43cd-dd49-08d7b94e8d8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 17:25:32.8792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SVIoZTEsLvNqGbJIEntMhVKV6RRziQFUTGcIQA9azJJVN4bwxZ4iI6dRSYCjS2CafHQmXLt6WB1L+1VZKucFtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2060
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_07:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=495 phishscore=0 adultscore=0 spamscore=0 clxscore=1011
 mlxscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEZlYiAyNCwgMjAyMCwgYXQgODozNCBBTSwgR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3Vz
dGF2b0BlbWJlZGRlZG9yLmNvbT4gd3JvdGU6DQo+IA0KPiDvu79UaGUgY3VycmVudCBjb2RlYmFz
ZSBtYWtlcyB1c2Ugb2YgdGhlIHplcm8tbGVuZ3RoIGFycmF5IGxhbmd1YWdlDQo+IGV4dGVuc2lv
biB0byB0aGUgQzkwIHN0YW5kYXJkLCBidXQgdGhlIHByZWZlcnJlZCBtZWNoYW5pc20gdG8gZGVj
bGFyZQ0KPiB2YXJpYWJsZS1sZW5ndGggdHlwZXMgc3VjaCBhcyB0aGVzZSBvbmVzIGlzIGEgZmxl
eGlibGUgYXJyYXkgbWVtYmVyWzFdWzJdLA0KPiBpbnRyb2R1Y2VkIGluIEM5OToNCj4gDQo+IHN0
cnVjdCBmb28gew0KPiAgICAgIGludCBzdHVmZjsNCj4gICAgICBzdHJ1Y3QgYm9vIGFycmF5W107
DQo+IH07DQo+IA0KPiBCeSBtYWtpbmcgdXNlIG9mIHRoZSBtZWNoYW5pc20gYWJvdmUsIHdlIHdp
bGwgZ2V0IGEgY29tcGlsZXIgd2FybmluZw0KPiBpbiBjYXNlIHRoZSBmbGV4aWJsZSBhcnJheSBk
b2VzIG5vdCBvY2N1ciBsYXN0IGluIHRoZSBzdHJ1Y3R1cmUsIHdoaWNoDQo+IHdpbGwgaGVscCB1
cyBwcmV2ZW50IHNvbWUga2luZCBvZiB1bmRlZmluZWQgYmVoYXZpb3IgYnVncyBmcm9tIGJlaW5n
DQo+IGluYWR2ZXJ0ZW50bHkgaW50cm9kdWNlZFszXSB0byB0aGUgY29kZWJhc2UgZnJvbSBub3cg
b24uDQo+IA0KPiBBbHNvLCBub3RpY2UgdGhhdCwgZHluYW1pYyBtZW1vcnkgYWxsb2NhdGlvbnMg
d29uJ3QgYmUgYWZmZWN0ZWQgYnkNCj4gdGhpcyBjaGFuZ2U6DQo+IA0KPiAiRmxleGlibGUgYXJy
YXkgbWVtYmVycyBoYXZlIGluY29tcGxldGUgdHlwZSwgYW5kIHNvIHRoZSBzaXplb2Ygb3BlcmF0
b3INCj4gbWF5IG5vdCBiZSBhcHBsaWVkLiBBcyBhIHF1aXJrIG9mIHRoZSBvcmlnaW5hbCBpbXBs
ZW1lbnRhdGlvbiBvZg0KPiB6ZXJvLWxlbmd0aCBhcnJheXMsIHNpemVvZiBldmFsdWF0ZXMgdG8g
emVyby4iWzFdDQo+IA0KPiBUaGlzIGlzc3VlIHdhcyBmb3VuZCB3aXRoIHRoZSBoZWxwIG9mIENv
Y2NpbmVsbGUuDQo+IA0KPiBbMV0gaHR0cHM6Ly9nY2MuZ251Lm9yZy9vbmxpbmVkb2NzL2djYy9a
ZXJvLUxlbmd0aC5odG1sDQo+IFsyXSBodHRwczovL2dpdGh1Yi5jb20vS1NQUC9saW51eC9pc3N1
ZXMvMjENCj4gWzNdIGNvbW1pdCA3NjQ5NzczMjkzMmYgKCJjeGdiMy9sMnQ6IEZpeCB1bmRlZmlu
ZWQgYmVoYXZpb3VyIikNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEg
PGd1c3Rhdm9AZW1iZWRkZWRvci5jb20+DQoNCkFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJy
YXZpbmdAZmIuY29tPg==

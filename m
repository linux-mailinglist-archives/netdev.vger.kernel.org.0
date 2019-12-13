Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CEB11E96D
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfLMRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:48:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47522 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728012AbfLMRsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:48:19 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBDHhEB6013236;
        Fri, 13 Dec 2019 09:46:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=N12139AAVkcNfuEh7N0gfRjTH1Ng9rQdFtnoCG2BjL8=;
 b=a8wGRjt19pKTEVhKBVERWU6kBwuRq6qPTDLT/6Jf7XsPfG3N2VhmKK15PKGpl1lIB0hl
 +zXLVzGkVQmbfZJ5o9exk/rmb3R1CIra1iFtfbjzvo5prlRXkR1uf/DvjL4dyrzKhEzh
 LJJxekxyOk72W/wGkYOwIkUa0EzicBlzQa8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wvcb7guuy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 09:46:04 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 09:46:03 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 09:46:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE+OdVrxkznmrEHaGjlrs0tJYSCK47XTdPeOFDZ7I6R9lsUY8QhQyWgE+j2KyerO9oHh/xWacuMyZuS2m8UDZwwxBuzGPaa37NwX0J8DCUI2u/pre5O0gs7GLARNqowHzHxHp/1ZpcKUHmo6JCsrPPUpOtkOjwXptc0klws7eBzqUy/DgmhuHcO/nxyU6NvHsLlyT6szGAhBfPdBt6BbemNJQiOovxw3oVbY607H+3trf8NI1nWUa4ruEbQLa4QMkITaEDu/6A6V/2iVPlqY+ALc0PLVcXZl9hR50PaSQ1WbGmdbiOwpOs6XwgpbXp1sm5kjSn8rAK/AWfYcw2irFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N12139AAVkcNfuEh7N0gfRjTH1Ng9rQdFtnoCG2BjL8=;
 b=SvAaiZYU2HYoqY2kFbH8EygdVwqpxTJoY7VDPInU3FE1rK1rl1Y0LrBocQTXzTaSj4b3BR8uf5LS7C+dK61E6xerc+igLFKMaJvSvsYLFN2hX+kxJAnzaTvtEuigHt2ZuzyvWtQ1XFOwIVvYjfO8pV/evZ5ZUx6FzQKMsFND8IuoKIGbzw0zPPvpUnZkthZq6Y32TTMWRp95DdpIadkx6VkhGtOfAiPV5qA4YxJ/QD+9Ve4VsQ/GOI1yJeTG5rgJw0TFBy2U5AJfMqb9tV9RG2dgOQcZ15YNSHA5rprquX70wkvcRICiZWZSRccmuix0LMdnXN/68+/PqBHANhNrlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N12139AAVkcNfuEh7N0gfRjTH1Ng9rQdFtnoCG2BjL8=;
 b=cATtOOhmO3uoaSrC09+64XAZj65Z3t4/G4bS7Gop8p5u5PGcq3BUsH5kRZiES4YEDYigDibwnEhqSKguEBdcHsxgrmEpo/nRefqDBcEysjccFKC7yFWMK+IBG5In9kEBPrSRuSm1XXOajxkQnvxg7akE4snf1INBW/rm5g325u0=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1420.namprd15.prod.outlook.com (10.173.223.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Fri, 13 Dec 2019 17:46:02 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 17:46:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 05/11] bpf: add generic_batch_ops to lpm_trie
 map
Thread-Topic: [PATCH v3 bpf-next 05/11] bpf: add generic_batch_ops to lpm_trie
 map
Thread-Index: AQHVsHMrZ7Y4XT6x5E2BfmAUzba9k6e4WXWA
Date:   Fri, 13 Dec 2019 17:46:01 +0000
Message-ID: <ba15746b-2cd8-5a04-08fa-3c85b94db15b@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-6-brianvv@google.com>
In-Reply-To: <20191211223344.165549-6-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0072.namprd15.prod.outlook.com
 (2603:10b6:301:4c::34) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e6c4b4a-63b7-4a12-878d-08d77ff451e5
x-ms-traffictypediagnostic: DM5PR15MB1420:
x-microsoft-antispam-prvs: <DM5PR15MB1420B27C4273F1F3A881C3EBD3540@DM5PR15MB1420.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(39860400002)(366004)(396003)(189003)(199004)(478600001)(31696002)(8676002)(71200400001)(186003)(86362001)(2906002)(8936002)(36756003)(66446008)(66556008)(66946007)(66476007)(64756008)(54906003)(53546011)(2616005)(52116002)(6506007)(4326008)(31686004)(81156014)(5660300002)(6512007)(7416002)(81166006)(6486002)(316002)(110136005)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1420;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5YmZsfGtrPRoAiHAjriPCMvj7aMTQdd25eD3k0Tx7NTLm5TQXlx9wE+2xgo25lIF4iK/jUOzRCpW3l8y/W8r/y8RIyCl3R4C57vLcaPevMtw6ncd4/S1RR7fNN5thcsdTNgkFpWGc32RBegerSqLWKu1dUjpbknr7alYalCyZTw/frpcwohpwX+h9apmPrBbvZAl9gnA9faoAzaJzbkUFkV+vvo+n56lWeoJp2jcQt7LK3oMwHzpA8f6Akt2CQa4AhrPkYwqYOLStK39w1qoT2rGiWKTPCJeXW6cwUrp9U/v5DRUDpl+MpuTdDJcJIu+zqVJExswLTUm8FR7IQJqfWrC1E8a58Tq/LMPeE+0RFT+JF0uHuV7F+AwmFebIL4+Ut9lKehJw2v+TYNXGIpuvt7pKND3ktYd6Qk8Im5pfNnwtlPTlsKzcTRivJLf2nnZvTjptPmi1ca0YusA1+1XMBydTqgf4c6Erq4UDQI6OwOEENbItQD5bZDclmBVWXg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <91C02498C374F940B44C063FC5254F2E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e6c4b4a-63b7-4a12-878d-08d77ff451e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 17:46:01.9848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CHjHVnR3B+PAi0Ij9dgvclOuxI9IdG4XJvUI/bFPV6zVNr2ruClyWlkMA8V/ddRp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1420
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=883
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoaXMgYWRk
cyB0aGUgZ2VuZXJpYyBiYXRjaCBvcHMgZnVuY3Rpb25hbGl0eSB0byBicGYgbHBtX3RyaWUuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBCcmlhbiBWYXpxdWV6IDxicmlhbnZ2QGdvb2dsZS5jb20+DQo+
IC0tLQ0KPiAgIGtlcm5lbC9icGYvbHBtX3RyaWUuYyB8IDQgKysrKw0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL2xwbV90
cmllLmMgYi9rZXJuZWwvYnBmL2xwbV90cmllLmMNCj4gaW5kZXggNTZlNmM3NWQzNTRkOS4uOTJj
NDdiNGYwMzMzNyAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9scG1fdHJpZS5jDQo+ICsrKyBi
L2tlcm5lbC9icGYvbHBtX3RyaWUuYw0KPiBAQCAtNzQzLDQgKzc0Myw4IEBAIGNvbnN0IHN0cnVj
dCBicGZfbWFwX29wcyB0cmllX21hcF9vcHMgPSB7DQo+ICAgCS5tYXBfdXBkYXRlX2VsZW0gPSB0
cmllX3VwZGF0ZV9lbGVtLA0KPiAgIAkubWFwX2RlbGV0ZV9lbGVtID0gdHJpZV9kZWxldGVfZWxl
bSwNCj4gICAJLm1hcF9jaGVja19idGYgPSB0cmllX2NoZWNrX2J0ZiwNCj4gKwkubWFwX2xvb2t1
cF9iYXRjaCA9IGdlbmVyaWNfbWFwX2xvb2t1cF9iYXRjaCwNCj4gKwkubWFwX2xvb2t1cF9hbmRf
ZGVsZXRlX2JhdGNoID0gZ2VuZXJpY19tYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2gsDQoNCk5v
dCAxMDAlIHN1cmUgd2hldGhlciB0cmllIHNob3VsZCB1c2UgZ2VuZXJpYyBtYXANCmxvb2t1cC9s
b29rdXBfYW5kX2RlbGV0ZSBvciBub3QuIElmIHRoZSBrZXkgaXMgbm90IGF2YWlsYWJsZSwNCnRo
ZSBnZXRfbmV4dF9rZXkgd2lsbCByZXR1cm4gdGhlICdsZWZ0bW9zdCcgbm9kZSB3aGljaCByb3Vn
aGx5DQpjb3JyZXNwb25kaW5nIHRvIHRoZSBmaXJzdCBub2RlIGluIHRoZSBoYXNoIHRhYmxlLg0K
DQo+ICsJLm1hcF9kZWxldGVfYmF0Y2ggPSBnZW5lcmljX21hcF9kZWxldGVfYmF0Y2gsDQo+ICsJ
Lm1hcF91cGRhdGVfYmF0Y2ggPSBnZW5lcmljX21hcF91cGRhdGVfYmF0Y2gsDQo+ICAgfTsNCj4g
DQo=

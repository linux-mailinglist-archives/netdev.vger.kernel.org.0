Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBC111E8EA
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfLMRIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:08:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4442 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbfLMRIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:08:13 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDGq2wP031828;
        Fri, 13 Dec 2019 09:05:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bGaVhpeNmlmE2I/NW4tIswpKYQaPIvPVvWs35Jyu87A=;
 b=S16kDIsgwPlf0+UhR+LThHAsTFQCIkoRjYP8SdUvy5Hfi+8g+XR8p/WiJpiRTskjKDEO
 TqpRUijUrUPlcHFFXh9GFx0KU/yWQ4bEquumOaChtAefy5DO09ZzowiTvV2TtAUuGaBe
 iKZCENv/N3F/50zA5LkL6wWmbnCB30Ewp0w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvd4v8fhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 09:05:54 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Dec 2019 09:05:53 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 09:05:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hU0FL3Zi4jNfpzgyBTGtNfg3PWiV7qFTgINhMwgHIiJHxtRuN7yTinVoCQ0GEav+kdAbG2ualVXVUiBJz3x6qAVKNSM4P6esDjNNZL5rvUK2G3fk1fuATR6BJdxiD7fYpnGGIePVOIy0pTWRDxZqIpoUqSlVJahaExnJ2vqwwsCq172t9H5RxVu2r0DMINUciwb1Qc/3rWVup6VCWMTV1fCoRIaP8q2TU2FVJMZG6e87Xf4OLFzkg6jCJ0YtMxwwUsJa3jnIcNK3oo+WFppsduqeZyS6WF3QEh2RCebktXRRgOMA/jFWj80HHcRcz6iWfzjNMNDnyUeCS+mknAi7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGaVhpeNmlmE2I/NW4tIswpKYQaPIvPVvWs35Jyu87A=;
 b=QmAz2KJYDLSQt5s5YMW+WywwQcHA+7/ODsh5ML8tdHq9PIJ6ZzvERry4F3oISJ8O3RwpaxAaV72q/BPPULO2ONSgvioTQxphcXW4ZtobwTpzwmz0dUHE+fL1gmwmYzb49bGZPLO8xd3gm/YrwCxuIhmKdl+JyJ+xL5qGpRiUZ9sBbbGkAlZZxnE4dwOEPLhKxrIxK+R3ggexETcMIAmvWzSnDC8JqGXXTcrDdGX5+dVFTFqkb/JH5OKxBi3lvK2sqSgpDtHpuSxrbVxWnCLGiVHCbwqc9LnnDpktmAfDw98LGwNSB+aYucGIJzJo+mxfPHVtO7fCG0uO70zVePz8nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGaVhpeNmlmE2I/NW4tIswpKYQaPIvPVvWs35Jyu87A=;
 b=O2eh6tkDmO0XZJJa2+eyUjuT+RvMails1uNpFZrij1pCRytkqUNTE/Zy5vBXq+j6ZfMq6PkEU/4+KnT62FegAu8En6UNIglAZCJktS8qVZH2tAhOz5J9dXdTLcOY2XX4kGtkXjNMIOXhpLZBVpnwLpayM/gZonZ1tmZm3bBJSzc=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1754.namprd15.prod.outlook.com (10.174.247.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Fri, 13 Dec 2019 17:05:52 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 17:05:52 +0000
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
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>
Subject: Re: [PATCH v3 bpf-next 01/11] bpf: add
 bpf_map_{value_size,update_value,map_copy_value} functions
Thread-Topic: [PATCH v3 bpf-next 01/11] bpf: add
 bpf_map_{value_size,update_value,map_copy_value} functions
Thread-Index: AQHVsHMjCFoMtOSbMkaVnUm0i4y+8Ke4TjEA
Date:   Fri, 13 Dec 2019 17:05:52 +0000
Message-ID: <748d96dd-6583-6d29-d04a-6e3e7086b45b@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-2-brianvv@google.com>
In-Reply-To: <20191211223344.165549-2-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0007.namprd14.prod.outlook.com
 (2603:10b6:301:4b::17) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 616ed234-f371-47a9-1156-08d77feeb57d
x-ms-traffictypediagnostic: DM5PR15MB1754:
x-microsoft-antispam-prvs: <DM5PR15MB17540737F47F086E24A1495ED3540@DM5PR15MB1754.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:211;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(396003)(39860400002)(346002)(199004)(189003)(54906003)(52116002)(6506007)(186003)(110136005)(53546011)(5660300002)(64756008)(66476007)(4326008)(2616005)(66946007)(66556008)(7416002)(81156014)(31686004)(8936002)(2906002)(71200400001)(31696002)(66446008)(4744005)(36756003)(86362001)(316002)(6486002)(8676002)(6512007)(81166006)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1754;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IwTlVw3PoF/lbf0PnWUcxVTWcCP4GBknSVWSGUyehkPFvdV8LKBamQZaccvyp7RZyfzHtvvMAv+UzTya2FJIpTOprfIkdqgmW6GvrJNcERQ9eOVaIGXbcA0xPE01UAhqeCnEJBQvMuLYAEP30LvC4qCDWGc8rpbe4sF8gy3YqL5h+tdQBnQpT298eOASTj8h2yZ6O9X1cIC1MPHd6jTpTzm1zgTOIhu/CnBmPedUpCqhErvpgPW6uQnIWfG7Nfxp5V0s8CKC5ELVRMLWEuRLH1wdcHCyCx18MRa0aTs/pnjPw/kDxW3tanlCxvSIaje6O/050fI9ZfAFHdYIjG/3EXmaWvcA6sGhC/++sKlOtkCWCw+G9aag3QLUHoghKEaZACiYZ8E1YYLWtSchI9UjQWlgr6Su6OIcHBwgfTAxdDDK8kGpEHoVH1L3sksPWmeQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4405E55934AD84EBC7A89B9D7B89CFA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 616ed234-f371-47a9-1156-08d77feeb57d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 17:05:52.2090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MygcwKrmnlSEhL1qfilHKJWh23TF3mofskp8FqumkmPVXK8rBO0XJ2nhSS2nUJ9l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1754
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=600
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoaXMgY29t
bWl0IG1vdmVzIHJldXNhYmxlIGNvZGUgZnJvbSBtYXBfbG9va3VwX2VsZW0gYW5kIG1hcF91cGRh
dGVfZWxlbQ0KPiB0byBhdm9pZCBjb2RlIGR1cGxpY2F0aW9uIGluIGtlcm5lbC9icGYvc3lzY2Fs
bC5jLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQnJpYW4gVmF6cXVleiA8YnJpYW52dkBnb29nbGUu
Y29tPg0KPiBBY2tlZC1ieTogSm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNv
bT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+ICAg
a2VybmVsL2JwZi9zeXNjYWxsLmMgfCAyNzUgKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxNTEgaW5zZXJ0aW9ucygrKSwgMTI0
IGRlbGV0aW9ucygtKQ0KPiANCg==

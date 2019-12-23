Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32AED129283
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 08:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfLWHtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 02:49:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8358 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbfLWHtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 02:49:39 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBN7imcZ023678;
        Sun, 22 Dec 2019 23:49:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cpfIx4vwS1Teplu9Wha/NDHAgYpxJNvC/KQS/DDc6pg=;
 b=Qoz/RJkaXVWenDbW2KQSbj+1QzQvKbXzbdl8kGaeDKM3mEbWoVcrlSy23nAC8HEfGb1A
 nQVQ5Q2w/JyWbgRVvHHfVQai/NEjlP7mwS9i9yiupMcZ+l1k1Nadz50ABwaXzsaV5nF5
 aVZ7js1rn7IoL4KA+iycDAHUiKaVqHt46rA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x1j3qe1mv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Dec 2019 23:49:24 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 22 Dec 2019 23:49:23 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 22 Dec 2019 23:49:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQMZ/8ACH6mSK0MGMYveDp+HXdSfKb7D5UBA7urDfuo7Svbjzw5xTI759mZqhlFpF98kqnt4fS03R1ctAV0G1JzazwjlK8caWwqNItkmoEMn7i/4vfR7xGMgKRKNqQ+CocHIxGgpBUog6OjDewHnGUnPPxpqeIcH2j4EIHJPWDDVqFNnDzipx7cEyXl3T1Kn0ID4ztZyGh6Prpt8pbQ2ITQ93BP5MV7z80mc347TVMz46BVBGoDG6ZlIROWWKx7iQcq4lFjFqspoqUj1Kvm1fKLkdF2AJ76Rs0K3Niycf8ZLNYUP6WjUyfnayEGNl0dImf6LQm1h8Lw622wUmZDGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpfIx4vwS1Teplu9Wha/NDHAgYpxJNvC/KQS/DDc6pg=;
 b=XbjJNYSE1PDyb5KfhlSvo9sLN6LM9hX5HetNTlPbE5beAukKnUimJyzEdnuQnAJ6yBFDBwYe8c7H5lL/5Kvf7kHLBH+eURE3iVZ6TMMhkZbXz2QEt559u9xo1NPv+wwlS7PXjuusuRaifFq73znqf5xkjAhJseXYCVu/fs8gCc+/1VRZJpWLimb0RrLu+ZVTNEP89Y+PfqfGLPVfV4lDjxOG0VxD7rb4CM20LysXftZXUYJKdCn6lcCSr2ciGugPIZY2hZOUDFIDgYNMkE4icns2kyKfiMLwitlcNpRUqCT9OkmH87q06JDC2YrwxYViPSFOA9yTjPassRxUKXlNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpfIx4vwS1Teplu9Wha/NDHAgYpxJNvC/KQS/DDc6pg=;
 b=asMPRgAKzGKG7KqcOGqcg+UPm8tKxlMCD2yWQAQqiYWoaEo726lP2cimoLnZgqMsZxH9J7Y1IAKS7KRjfpZ7u0rKYwRTvmfUbLR6rMuuBGxXuDApkL1ho3ihWXHWm3Yp9WJMasjzkzzuRL0IEmniXZH2hWxpMaZwNIa6/q9urtE=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1547.namprd15.prod.outlook.com (10.173.221.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 07:49:08 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 07:49:08 +0000
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:180::62a8) by CO1PR15CA0073.namprd15.prod.outlook.com (2603:10b6:101:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 07:49:07 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 04/11] bpf: Support bitfield read access in
 btf_struct_access
Thread-Topic: [PATCH bpf-next v2 04/11] bpf: Support bitfield read access in
 btf_struct_access
Thread-Index: AQHVt8eMPrh8mmnRe0KFFgYnEVuYFqfHW1aA
Date:   Mon, 23 Dec 2019 07:49:08 +0000
Message-ID: <0d256d3a-ba40-3bdb-0779-016ae4f3f514@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062604.1182843-1-kafai@fb.com>
In-Reply-To: <20191221062604.1182843-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0073.namprd15.prod.outlook.com
 (2603:10b6:101:20::17) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::62a8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7af667ee-d03c-4f8b-3ceb-08d7877c9757
x-ms-traffictypediagnostic: DM5PR15MB1547:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB15475ED0D68C6F379F2F4573D32E0@DM5PR15MB1547.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:345;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(54906003)(6512007)(86362001)(110136005)(316002)(52116002)(31686004)(2906002)(5660300002)(6486002)(31696002)(66476007)(66556008)(66446008)(64756008)(66946007)(186003)(16526019)(8676002)(81156014)(81166006)(6506007)(53546011)(71200400001)(558084003)(2616005)(478600001)(8936002)(36756003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1547;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2LQ056AT6L9nPzimFfwBp+ZIZUN7pjum6dN4ivNMlMxtiOmITXT7AMTK+yccKh6l3yDzD2ZVzEdlnxWVE3kasX6Q3Ye+ZZebE1uhcuJmJmHhKsEX02QaCmGR88gkSH5TXRWm5M5y4iPOC8dlXL7QQskR0pefbGuSawquqfLg91Qho6bzDvg6OSnhs4DmItXWvW+NfhdnPJPT4/fsI5CZwibjcKxd4nEcAXDLp/K6jtRwqk9ncgyi3viuxE9SuWCRyxCdxHaNYtanoSfuD5k+hYmEr36nFQWMsrr/VzaeWkdZ554CHLMAbhag9aaXUAaDLHK2tBKWFkpE0D1T2t43qHrI8zxLxevjJa1ldabD+Hc/PZTYwNNcFfKhu13nFyqNpa26dl+48gRSDYBAdGw7m4O8MRDO6QBJZija7EY3r97uXxFDGQsXD39SzZX4Y6Uo
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3FF0ED38F74D245A4331EC355CBD3A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af667ee-d03c-4f8b-3ceb-08d7877c9757
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 07:49:08.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XzCpOI4kQFzPzL3vbW5HWI7x/HvfebhHiQyeMQ+7+fPle2HWETP7AxVBgEiNCZqD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1547
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_03:2019-12-17,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0
 mlxlogscore=741 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzIwLzE5IDEwOjI2IFBNLCBNYXJ0aW4gS2FGYWkgTGF1IHdyb3RlOg0KPiBUaGlz
IHBhdGNoIGFsbG93cyBiaXRmaWVsZCBhY2Nlc3MgYXMgYSBzY2FsYXIuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQoNCkFja2VkLWJ5OiBZb25n
aG9uZyBTb25nIDx5aHNAZmIuY29tPg0K

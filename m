Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA8C2AA07F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgKFWoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:44:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7390 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728408AbgKFWoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:44:21 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6MOZvT030520;
        Fri, 6 Nov 2020 14:44:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lCkSd5E3MruV+zRD/HAkgBsb8rHfS3+XT99yozB1wZ8=;
 b=mVjJOVwwvxFfMB/J9/HG+Mvb0NUXSKioACm3jTbGCUlTRSYT/Gfz1T+VUqIOlwmm8y74
 dodlD7Pukq3uLbah6odIBn3aqqgzQ3LkesiG2ahlLh65HW65hN7CDmK2NQPdlbiLzu6u
 Dfyz5lcGYzVQKlmEmRjmTaS/4pZGNWnl/aI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34mw5bn8dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 14:44:06 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 14:44:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meZles7WUkRq2ISZKegtJ8+w6qhfpINZJCf/TrDHdFpFrKLZYHq+KlcmX6dn5YiizL2fGKC+v/LhscTO+tbrrwtGDz6ga6lllwCSWVdcUem1lgWOoZMsdW+yoYMdMk5n3Cd7ggNUf+CuaZDURUmNn8zu8gO5Obj8ncUcGsJtwbE+1+0vrNyWXnheoxLioN9DITI88Ca0t07YnREzwYBnUI8pJz2+gX7jDKtDK7UVOfl5SfOYw8UEy45QbNxOQrB0d+Tl4IKsT5eftV60E6NG1jkm1WqCq8P0kY7247Fg1Ex9GBqvFB9Rr6js5at9S/K0fSJ0UQibZMHd+vqTk9TnTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCkSd5E3MruV+zRD/HAkgBsb8rHfS3+XT99yozB1wZ8=;
 b=CAM5gGN/UHs9/l0Sfb9p88AOUyZQTCet3hkG7x9bw93QMzhPWwqasucSOFU2WsjLsgOR1/G3eD1tfVXBWbw/5SYTo8VOcbXB7WsecaTRzWipYPeNErH3H0HCjSBFrm3h8FbMsdU+cbgNEBwg3yX8sfZypbffWgeh9QcgC6wvrZgIrd6Eup18hj8lD4pA3kP4DnpUqNaT+qJsBRgBBt0rSHMdE3biTi0pzyClYbaSPPBxC0iqlAoEC1EqZoZXsz+Wsu8ks1czcAQEUjFQDfYLWhaSUmlenZ4gu0S9U68TGKqvnOd7TswPS6E6GbfrlsJBM+PjGpMeMwnDc9NTg4xiCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCkSd5E3MruV+zRD/HAkgBsb8rHfS3+XT99yozB1wZ8=;
 b=FIBNF/TE4G5TwNz52v29YgAoYzWj8OcffLGWahXrJRDCaNXzRmf5lLK4zsipBvQIf4Z8ZgD2x5d0fAFSp6/W4nCMcF4W4FPYOq+zVqKdhM5Z2cRIsJpOCruJGcCXgnicMDJZ+9F6Ak+xGMOwnqPnxgi78uO+Uu/dSmI78FlU8NA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4117.namprd15.prod.outlook.com (2603:10b6:a02:c1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 22:44:02 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Fri, 6 Nov 2020
 22:44:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: Folding omem_charge() into
 sk_storage_charge()
Thread-Topic: [PATCH bpf-next 1/3] bpf: Folding omem_charge() into
 sk_storage_charge()
Thread-Index: AQHWtIlMrRiN25jT/Ei2d9oCHod9Vam7s5GA
Date:   Fri, 6 Nov 2020 22:44:02 +0000
Message-ID: <74113224-27C9-4FAB-8C9C-68890BB118E3@fb.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220757.3950302-1-kafai@fb.com>
In-Reply-To: <20201106220757.3950302-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:ca49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a952186-fb28-4529-4485-08d882a575c0
x-ms-traffictypediagnostic: BYAPR15MB4117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB4117F1EBA771868A3F77BCC0B3ED0@BYAPR15MB4117.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V91B7qL0JOrd00vULW5FRVEka6mcGIj22c+lrEmlJZjY6Oktypkopeo2VajspHG/uqXHK6B1BJ0ETTHhSaDefiQ73zR3o08FX/GoCygs3OA3P6Q+nUJtaM/LlxAm0lu4kYB9+ScJzEt67cR9+ByV7DWXj2hC9T/8XwVqozffzwm49iid+5F3LTgKw3TJCQ9y1zkACdRgGFMeCVy4ogZa0RFsuRIUb5fC10KTSiXG8JV5Xw98ZTubh/wcqx1kmm4bhx4z2S2/RGkSnJQnBAiwDlzJ61mCPkIPIICZQrqpJcFQqqLOTa/6O6NXSoVGN7V1PTdgRDSkSgI4znOuw0fAXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39860400002)(346002)(83380400001)(4326008)(6486002)(86362001)(2906002)(6506007)(71200400001)(36756003)(186003)(91956017)(5660300002)(6636002)(66446008)(478600001)(37006003)(33656002)(54906003)(66476007)(6862004)(8676002)(2616005)(66946007)(8936002)(76116006)(66556008)(316002)(6512007)(64756008)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TV0SAa/e6QH7t0G/mheFA6frqXLv7axbvR5Hmjeytju7Tx6yHZ0mqDflkEj4TsJm5ApeSWIh/g2LekrrdjvZeACl5Uk4Wuizsfylk1+6QUwbSYN89t9oHlfLlLl+1Gp/62vaIZra3zi+E7kag1urNso+cEEL111tIBLVb/MBN7b6wNekliO96HuxSZY3YISIstEBLqRxji88+/v/JnjFBNbctzVJZwNN98AFIDs5XqVXGGx8uOWNkct6AfDEsqs+kLf+95HEl/i7ohIQtq5baX3Zdna2Q3mNQYr4HzIo3TPYoMaDd8vSlk9HWMO9WBmUX3ymZUE0gLDgV0UEhq+Sc4BJ9tnDzzisL7yYhv5cL+81TyX4vTwWRxhuX8X96hZk72SQy9zw202Ns8I66RDhZ4gQ/tDBidlWclurRpwm+xBweIKq0y7cqNXlR562XdGXqUT+hvpX8A7f9/Zm76a6Kegk8A5orEy1NYmcFNnSsHkHUUP1+viPe2CGLSPjIbZhqwuoXTQLlIvEm4Ktij/CK2R6vpzGn9uo/IOaejPTzfEM5AMLoKHUB//D4K+WjCDWepxSGUUQ7AOXVDug72zFp8vtVYsNkAZkxqPFBHu5EDJMhR/4edjcuB7ybnt6GxsMUV89sjMc6cUvXo0p3RRW61upf9c7JSP7IQojQzXl4yWlrMfpWF5kdfIh51yycmx3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9664F0B922A9F34C9EEA1DCA40A14E4F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a952186-fb28-4529-4485-08d882a575c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 22:44:02.8215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NHmLNWvyrspu2jHhbTrXT6ifhDUHU6gI44iqwIhIG4k+UJPDlQtIdupfkB0detAi4Prmk7pirYBor7YNaG0qlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4117
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2020, at 2:07 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> sk_storage_charge() is the only user of omem_charge().
> This patch simplifies it by folding omem_charge() into
> sk_storage_charge().
>=20
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> net/core/bpf_sk_storage.c | 23 ++++++++++-------------
> 1 file changed, 10 insertions(+), 13 deletions(-)
>=20
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index c907f0dc7f87..001eac65e40f 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -15,18 +15,6 @@
>=20
> DEFINE_BPF_STORAGE_CACHE(sk_cache);
>=20
> -static int omem_charge(struct sock *sk, unsigned int size)
> -{
> -	/* same check as in sock_kmalloc() */
> -	if (size <=3D sysctl_optmem_max &&
> -	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
> -		atomic_add(size, &sk->sk_omem_alloc);
> -		return 0;
> -	}
> -
> -	return -ENOMEM;
> -}
> -
> static struct bpf_local_storage_data *
> sk_storage_lookup(struct sock *sk, struct bpf_map *map, bool cacheit_lock=
it)
> {
> @@ -316,7 +304,16 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, =
map, struct sock *, sk)
> static int sk_storage_charge(struct bpf_local_storage_map *smap,
> 			     void *owner, u32 size)
> {
> -	return omem_charge(owner, size);
> +	struct sock *sk =3D (struct sock *)owner;
> +
> +	/* same check as in sock_kmalloc() */
> +	if (size <=3D sysctl_optmem_max &&
> +	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
> +		atomic_add(size, &sk->sk_omem_alloc);
> +		return 0;
> +	}
> +
> +	return -ENOMEM;
> }
>=20
> static void sk_storage_uncharge(struct bpf_local_storage_map *smap,
> --=20
> 2.24.1
>=20


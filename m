Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 980C7147906
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgAXHeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:34:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58444 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbgAXHeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 02:34:18 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00O7SuGQ026701;
        Thu, 23 Jan 2020 23:34:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RqPXrTHenZwcV2+LyQlohj4wnKV4euCDfwTlli6nWRc=;
 b=Bs+XuIjfqWvzi9vO51eH+yxVNZdXLLdxBvpSsGKeOKQjOIIeC48SAlABLeTCcODiRmjw
 6OGWjkR4rSowdSEJcgifRUcvpJfAZbpk/mqhW7Q3hD+2C2IKND0t8rt3X6m5kCurKGxe
 5BEjuyY2+3uRJumCmCxK69aPSiI7EuP6yk8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xqq258x6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 23:34:01 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 23:34:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dw3a0qfqCNBc2g8hGzl2P6K6+3f7k/0x9b2a8UNLQUWb5dur3FD8ni0JTnWDiWOTitmR2PnoyRKBqCZgY2lgLozz6f+US8CRcB1q7SrJAXKeOfKD1aMMj4uQTYmSvEGh9jLt8nQ4WV5Vq2aVWt/b0GUH//bypkTPXqXBV/3sv3+zjwyH/+h+d0GkXPDTvA6QhKx/F5M+egiEWXKJHb5BF/6Oi6gYoTRr5xKYo0Asxld2OIkyuWITDdW8I1oCGvtTwCwy86n+KcFriHKRErzLT+7nhrsY1ZYP3pDHqfCLmnSZ8iTWVXxOexVLYn/W81XhWs/W3mTVMN5jR04QvPKwLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqPXrTHenZwcV2+LyQlohj4wnKV4euCDfwTlli6nWRc=;
 b=jDVk5ITu9zVH6uTuBrkQnKN5ktS6l6wZE/SPyE2zors1//0lcnWRJD+5AMTmvf9SCPZbnPt7JIXlK/Oa+weHWXVCKf46IDt4CYW0V9LDrdKj7HqQmEyrVVQMzsQYhjFVBqavAQzbK8ZgQdkiMXRNJeV71Z89on2h+gwt/IQSlf24SxxO/wezPPRto/9IHJGQIy041QZYFtlUusnGhxfj389pil71c9lxuQ90vI4wAIUVmltPFBmC0o2NY/sIUmhrSeje/xDioFcEhIkFmteAskZC52z5kXDxvCSh0Z06r7rbXmM6f93jYGuCk29fbM6eq+Lx2cUhBA3JCHn6zYuscg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqPXrTHenZwcV2+LyQlohj4wnKV4euCDfwTlli6nWRc=;
 b=cy6ejPScQ4UTCrwi2rbyeslalhwvFzPJvN0aWWK4wfOxpsBCb3t5CN7Mrbze3bSAxutmWM3ax79Xml2u4cyWK7nXeWiFnudRv/Z6IQmPjQARj37MO8dk4XzoLLt2MyBmV7hdETp3EBHw/ZheeIuQuUvymXVWeq9LAw8/1rkeLTY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3695.namprd15.prod.outlook.com (52.132.174.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.25; Fri, 24 Jan 2020 07:33:45 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 07:33:45 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::d6ea) by MWHPR19CA0049.namprd19.prod.outlook.com (2603:10b6:300:94::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 07:33:43 +0000
From:   Martin Lau <kafai@fb.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "prashantbhole.linux@gmail.com" <prashantbhole.linux@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jbrouer@redhat.com" <jbrouer@redhat.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 02/12] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
Thread-Topic: [PATCH bpf-next 02/12] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
Thread-Index: AQHV0Y5dMJtIvJ6afkylU4bcoUktvKf5bhUA
Date:   Fri, 24 Jan 2020 07:33:45 +0000
Message-ID: <20200124073340.eengcp54bz7flw2o@kafai-mbp.dhcp.thefacebook.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-3-dsahern@kernel.org>
In-Reply-To: <20200123014210.38412-3-dsahern@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0049.namprd19.prod.outlook.com
 (2603:10b6:300:94::11) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d6ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e39a750-7d17-440e-f305-08d7a09fbe88
x-ms-traffictypediagnostic: MN2PR15MB3695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3695F70AA0A1392793A7E2D0D50E0@MN2PR15MB3695.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(39860400002)(346002)(366004)(199004)(189003)(6506007)(7416002)(16526019)(2906002)(186003)(1076003)(52116002)(7696005)(4326008)(66446008)(66476007)(66556008)(478600001)(81156014)(64756008)(8676002)(71200400001)(8936002)(55016002)(5660300002)(86362001)(81166006)(6916009)(66946007)(9686003)(316002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3695;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2bI8aZtDJEYSCYh5uMKXKPO8Re7fRAhCdvdRAB8zuD2o+mRocQQrsElY4ErAsxZPQfF34KoDI3OGy0jToAes+N2P1Exi5JxUWbmnY0edWphycJ2eQaNrAgmTtJUyGOC8TggyuOLr45qil0/vMnexh96XxuEqjEVFuXTRuXKntMVF06pznVH2QVRjWEUAwuXqoNEnx4uSowqU/J/IrZhW3we/meE2ZqBICGF+gvvC5DJJu806WiauwRhIWEXI4FHfqNgDAAKesS4KT3SdbsY8IXoYxsff99xcT2mt67fflstlu36f0ESrw1oK6Ae1b8uM+KBMjW2vZjz6jUFcweKnzj2lE8vX0AQxLYHrnEbGW7W4osLM6uEbFFyW1Ik3lhFRtEDyAiKu00FPqhwGCZT9lBYnPIFVisOck+jsHp20Fa7BawKDzlQrbogrICZhlitq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E562B31279EB948A1E48CA6F63F717A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e39a750-7d17-440e-f305-08d7a09fbe88
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 07:33:45.5073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MIFcONFcsYMkkydH+pje3pzGtm/OZhd3yJ6TrFze16Lzrb/zZcuQ3WW8sMI5cMy4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 adultscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240061
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 06:42:00PM -0700, David Ahern wrote:
> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>=20
> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
> at the XDP layer, but the egress path.
>=20
> Since egress path does not have rx_queue_index and ingress_ifindex set,
> update xdp_is_valid_access to block access to these entries in the xdp
> context when a program is attached to egress path.
>=20
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/uapi/linux/bpf.h       | 1 +
>  net/core/filter.c              | 8 ++++++++
>  tools/include/uapi/linux/bpf.h | 1 +
>  3 files changed, 10 insertions(+)
>=20
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 033d90a2282d..72f2a9a4621e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -209,6 +209,7 @@ enum bpf_attach_type {
>  	BPF_TRACE_RAW_TP,
>  	BPF_TRACE_FENTRY,
>  	BPF_TRACE_FEXIT,
> +	BPF_XDP_EGRESS,
>  	__MAX_BPF_ATTACH_TYPE
>  };
> =20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 17de6747d9e3..a903f3a15d74 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6803,6 +6803,14 @@ static bool xdp_is_valid_access(int off, int size,
>  		return false;
>  	}
> =20
> +	if (prog->expected_attach_type =3D=3D BPF_XDP_EGRESS) {
For BPF_PROG_TYPE_XDP, the expected_attach_type is currently not
enforced to be 0 in bpf_prog_load_check_attach().  Not sure if it
is ok to test it here and also return false in some of the
following switch cases.

> +		switch (off) {
> +		case offsetof(struct xdp_md, rx_queue_index):
> +		case offsetof(struct xdp_md, ingress_ifindex):
> +			return false;
> +		}
> +	}
> +
>  	switch (off) {
>  	case offsetof(struct xdp_md, data):
>  		info->reg_type =3D PTR_TO_PACKET;

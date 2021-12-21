Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2CC47C74E
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbhLUTQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:16:44 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.140.77]:38327 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhLUTQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:16:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1640114204; x=1640719004;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d359jE5LBn1hCJVkhAYFzM3RHjh0ODq3WvOpGaGsAOk=;
  b=jzYvWV0e6Qm7hl+cR263kSjg0bNV5aaglUtfIPniCxgl2exIlmUdwb33
   WY3XKd+ngEwjQqS7Si7vvII7xojrpfmhiu8pR8a7lax7HB+Lfiz4g8vHf
   W8iizSDmFBqkl603mEn4jz0BlgqHOLvlaQiQ2sHSz0K7c33ELIQpFpNJY
   8=;
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 19:16:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHowcnUTYkmVPJWFrHIPUDzTbjbiM8NSD8L6es78JTx9uu1AFTjO2QZNT3Mrc3x22b+GslH3S7e0mEQLtS2hFVGu3Z1NT9XuZHnKhfaMxhtz/hkEz2owe7ARpjtgpSKlacWQRPgSnBy/gaUi68fJAolwrGJsU2+Mxi6F20PZSS2qjZN7YWAJL4f9OhU3tBDSMv7iNgvLH5zWiObDZQjPMEObGA82/dkS7FOi94QK4ySshyP4FwIabjwcTwUD0BNSBM/U00ydB9kPdTmSirD9XOKtAaDKuOCFlYYQGD15FAVJcm8ttf4EZ+fyqSh7GCsO8cTjzNCv08iyQb9pW9fGmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d359jE5LBn1hCJVkhAYFzM3RHjh0ODq3WvOpGaGsAOk=;
 b=kswvE151EdrggUCOOOUnllm9ZMqRSHM+WRt5drS3Nq62tX7aCERmButECsKuPC73V85RNmX5IaW5YYqlrDPrq8AVNp99OFCDEVhqc/REU2TzoxBoU+j9VSsvWn0fUeVAyEd3IQkDa6IsfcM0oP3A71sgegPcpJIpOnH3Z8j2LeTA+0HR0PguAJ5frgGiRzjCL9HjUWbCdyvwUQjZe6Q2+M8UxcaQtnJXKjAI7H+H+PZuIFWA/JFTSnPmjuB0imGJpMg6qkVY3mDMWgILjDZ+yrIAznb+S5tHbZwnZioldNZBMMIvzzu7IxUJVLf5MJSDh1m93jbHTcNxDUVLlX3omA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by BY5PR02MB6914.namprd02.prod.outlook.com (2603:10b6:a03:239::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Tue, 21 Dec
 2021 19:16:42 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 19:16:41 +0000
From:   "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
CC:     Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
Subject: RE: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Thread-Topic: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Thread-Index: AQHX9eHoIVi91SZqTE+0za9xEhnh/6w8RyUAgAAxxwCAANfuIA==
Date:   Tue, 21 Dec 2021 19:16:41 +0000
Message-ID: <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
 <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81668574-d86d-46c5-4af4-08d9c4b66bb6
x-ms-traffictypediagnostic: BY5PR02MB6914:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR02MB69141FB0925D9B2F5D9CD557FB7C9@BY5PR02MB6914.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JlECR7RYQu6dZH/j0Xl+BO9+9CvCGMGmN7T8Ko6uK0BVielWnIZflpCQVos0Hns0qIEmAC9DIDbyTSuvP0yNlvyYtAo6LIuF+hfFuIm0jUIvnQcDLJuTSRAhf9dFz4PaCzBZxdkAAtXvixCLPSzA/Le08857X+YwNXugoRH7Cv1qkFkuDgR5fJLQLUiFj+OWbnPVz+9y6Uyniaw2NGWoRqmuBup8F+tZPQdBEF18O/nNrlZi4AMea7wmzBeMgf2V+wRjpZ9ZXTFMNA/n3wqefsI9P2Qa1VUb0z5RcG7FCKJkwC5m0nwf43PXF9jY4Kxap62w1HXQdVI3XofxrMsBSEsRctLHxQHRnQNpPxPl3f0wbW2RG4NQhfDWzGh3jkCFY5LTTcIopc/XRSyMZdYocmI6UkjAd52uBhxGLSAnSEUZI3p6qyYWiKm9gwBAPIO4RfIKp/GZz9HsN2LTuT1kCgFsD5EijbHjKsW+/QQzwGpd+TKkOipQ7eJZOKBH89bZ4g6nZkiEkG0MQkrXhoFMVMrKB99emHLAtqI2yjrAkN3a2TRBB/MCTrmXRqDhCxVpVLmbUcZ1OTpjjvmSdJmr80JoNWFgxMn1z/WRPNHWcf7Rc0yVPImGlcMSeMxJRLheLyLngcP+HdMjief5feZPBHYwkq6nSH4twI5zPOohye9/G6VyX58fGAecH4KiD8X0XmYfM8djiBc5Mtg83Um6HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(122000001)(316002)(4326008)(38070700005)(66556008)(66446008)(66476007)(64756008)(52536014)(53546011)(110136005)(66946007)(86362001)(54906003)(33656002)(8936002)(508600001)(6506007)(2906002)(9686003)(7696005)(71200400001)(186003)(26005)(5660300002)(55016003)(76116006)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fu4qAhYQ/twZwGXColYEdcpJxjZ0A3nd112VTiS6WS0p4GlyCYdyAJVlJhMi?=
 =?us-ascii?Q?DrGf/aHW4xuhWXa5Bnkb2XJSMi5txkm0r8eb7U6U81iQqBtclWu0pD2UnCWH?=
 =?us-ascii?Q?9v0QuK0ahMLA6Oz+zmQGKvwrGU2Jl+fhhyFXcIBHUWLv/axt/WOjJg0ftCeT?=
 =?us-ascii?Q?XBKPhtPTgwl/MrcrEJoTns/z0xKd4MvYk0PTuskx31kxOAGoSaF8PRjG+y/2?=
 =?us-ascii?Q?6C3DTCG8xIZ/nrWJxOl2mE00bLVPv1fRAb7QLW2usG3BB3wPgm6OXoCPsRkg?=
 =?us-ascii?Q?dUYluk7/gii37IUZzFAN1q10qiesm+Mq5Cikq9QK4OG0eO5aR8wq4FzggAF9?=
 =?us-ascii?Q?JObv+xcb4GGl6WWHVP9STAmNYsWKq06b45xW8HzLSfdgJmgwAC/ZqpZJ0InC?=
 =?us-ascii?Q?omjXnzYLCFeyvEqOUu7v0s3y/tG/OBQlRXysQwZsLq7wMyBZ0RNAbdLvDMg0?=
 =?us-ascii?Q?xClHU28xbxKs6VQOpvLOnldsQKWTb0PD/sxSTVp7DPXOubF8Alc5KpWzB27m?=
 =?us-ascii?Q?3klQKiIfW0F0gOcTtaKOjgKXDzWgq5IbdQeXCHcv5uzWgqgHMdvqWTsimu84?=
 =?us-ascii?Q?rw9EuRs5xS1FHeZq+ZnPjw1p2ZmityEm5HV0sQdCtCwUREY2A8AuI+LzfFch?=
 =?us-ascii?Q?/aWD8wuBKx2AqblUa7UdFFe9+07IYfGLo+7NYZN6tk4j4L6Wt5dWIKU5BgoC?=
 =?us-ascii?Q?oGNHOJmsgfQZORQIxa6jye5YHbpmmVlg4D6j/L+98YkGb2CIZc4uNHRN1ngk?=
 =?us-ascii?Q?LB2h9IGputP8jU/I9iuVA9tK+MpiliFrtD2W20QXQUm3i0tkKI2gIWnfI302?=
 =?us-ascii?Q?vfwAKxLfNUjIpTU0LEDIDlw9W33u9WWd4AqC/HCBd+fHcHUbENUFo4+n2ggc?=
 =?us-ascii?Q?VCQWcT9EyNocNC+OoggdbNWvxW1/H0e+GLc/idVtJNKd9IOvKGJ6MOcaAwbv?=
 =?us-ascii?Q?1RzrGhqS8/lLBc2bG9r2nZsqlf8yAntT+Syp1azQe/w1z+w9ezH+HAV+FuHM?=
 =?us-ascii?Q?fFqFrbCazs8Oc6agANMiMjk3bceNxLdRm/29UIVfzPenOGZNDW9xCs/nPcQG?=
 =?us-ascii?Q?emvG+pf86xnd723/QpLHs8td/W55R51Xfo3ZHrFWbGNbfQPSZhS5lBtrTzV8?=
 =?us-ascii?Q?99O1wCO8llkxS9gIzgpK7VugVA63GOO835zSG3T0ncKemPwYBFvZUG9pq168?=
 =?us-ascii?Q?RCPUGrmagqFkm2G2ztgxP5fOgr9bmgXWLUGhRxbYOD8cf7b3bna2rhO084tL?=
 =?us-ascii?Q?KUqT/Jlknet74/RHGSVpDtT0VE0U6o9k78w2HRd431hMwZyxx8Mttf/Vips7?=
 =?us-ascii?Q?ZA7VhoK1L/XRq59515buJQipnKWgALZh7ecc7Y2zVTnHi16LwQMwTBum/cRx?=
 =?us-ascii?Q?zE8VTZXZbwpTYncV1iHIrwC2Xmy7gXWa4+vPIoBbU0pXKz3eHSo3ieu+9b6i?=
 =?us-ascii?Q?PxJ1Z3JtYKrOI4SENMb/hiISxwDO2gGEzCbXNAKvQqlAhkqeUXNghc3pLXvB?=
 =?us-ascii?Q?Iy+T1O9xuRnwN4Csk/tO1d/pgn4VB4gVY5e000gj3GaA2js8l0u9IUU117M6?=
 =?us-ascii?Q?ts2K8Qg8vgiKfKARURGk4L+bMk78PpyPwxMV5qHgQi42nKu5i131froXzEbJ?=
 =?us-ascii?Q?vg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81668574-d86d-46c5-4af4-08d9c4b66bb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 19:16:41.8899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ngal7uSL8/Jvc63YuLihjfsOkBA7j3dF1GcjIBf47yQZujg2/LarbT8pUStJ4Dlo1tMd0k2tJk8Jb+vHKZbnfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6914
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Dec 20, 2021 at 07:18:42PM -0800, Yonghong Song wrote:
> >
> >
> > On 12/20/21 12:40 PM, Tyler Wear wrote:
> > > New bpf helper function BPF_FUNC_skb_change_dsfield "int=20
> > > bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)".
> > > BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can be=20
> > > attached to the ingress and egress path. The helper is needed=20
> > > because this type of bpf_prog cannot modify the skb directly.
> > >
> > > Used by a bpf_prog to specify DS field values on egress or ingress.
> >
> > Maybe you can expand a little bit here for your use case?
> > I know DS field might help but a description of your actual use case=20
> > will make adding this helper more compelling.
> +1.  More details on the use case is needed.
> Also, having an individual helper for each particular header field is too=
 specific.
>
> For egress, there is bpf_setsockopt() for IP_TOS and IPV6_TCLASS and it c=
an be called in other cgroup hooks. e.g.
> BPF_PROG_TYPE_SOCK_OPS during tcp ESTABLISHED event.
> There is an example in tools/testing/selftests/bpf/progs/test_tcpbpf_kern=
.c.
> Is it enough for egress?

Using bpf_setsockopt() has 2 issues: 1) it changes the userspace visible st=
ate 2) won't work with udp sendmsg cmsg

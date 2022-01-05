Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB465484BB2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbiAEA1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:27:45 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.140.77]:27673 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiAEA1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 19:27:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1641342464; x=1641947264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t76Uz+DNFUK0Ay0BPig3EbRU2pnbmK9Knd0Am9zTqMs=;
  b=YJhrkinUcgukmGAUGv1hafuNFMjPvOCAGBnm4yr5e8PSdWYixcrpRkgm
   J3XjOTrKLrHuNaSXID0Zei7lXbV0MtOHaplCqTizQ36sePqetaUKwsg8a
   /4/27h49gCDGLjVNGW62jZSzmGzis1LoAWE+xMJ+19pfWWi+M059qdTb6
   o=;
Received: from mail-bn8nam08lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 00:27:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sy/wl6NoY8Kz/hF3qSFgACpdOVutgtaOmG1EPV86CcgYf7S2OI01jBzIvqwlgfPNKkKmauvJVB/uA++VyqT/awZU+njgWgdA8qpJNT5/KiQPyzSZJPQNV8GATD4jz8IHwtCg0DszVexG+nfITr7BqIzPHdqga25o7sRX4ZAUQfCvXgO9GAQX+xw6zQ9kzBNyrNkO0ARd/o3xn6gBrC9IL3dhEiHuZ787/AY1WBaC/J7ciNcI1pXCkRgsFJh+4nO2ds7376WkV1KTn864Kx6RrteO5Zy5oBWpRmrHapew4l41dGXvi4oGt8wvgNkTFf+DMloEIRiIWQrTVnwCOuJN3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t76Uz+DNFUK0Ay0BPig3EbRU2pnbmK9Knd0Am9zTqMs=;
 b=NcdvqQhMaurCjIsWgCkyxGNf/QCMOooYOnk/j/+XhlTc226ckMOC2ChdMAMMbrGaDUmByXELAcd5solUvtRok6UJpU73kLXedtpGdOJBSUqFkbI8x6rLVpvNXN7RikyJHppbht/mLXUKWbDoamibDGCRHFfWy9a4YgGv4EwvBut7bC8FzpjBRNq9JEZOnICkOsggOfDhmNuxWeNRFgJehI2v6RI1q1o2c8RdDIDHETLEjMR0+tgKK0lNZoq0tLeS/JW9KubLWIM6ncUgGP/ZS0MiXGPJW+tT7D+TlDjimk//1ttSem48vR2mnulP5SYfGW9NeOAaBYzFNtJBpUMkHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by BYAPR02MB4213.namprd02.prod.outlook.com (2603:10b6:a02:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 00:27:40 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%6]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 00:27:40 +0000
From:   "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Yonghong Song <yhs@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
Subject: RE: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHX9tuyjzikyJjagEKGz1loPsx8d6w93owAgAE+o3CAABKSgIAKpfOwgAAsSoCACaSBEA==
Date:   Wed, 5 Jan 2022 00:27:40 +0000
Message-ID: <BYAPR02MB52388A3420C7FBC0B79894CFAA4B9@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211229210549.ocscvmftojxcqq3x@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211229210549.ocscvmftojxcqq3x@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f906421-a68a-473c-3287-08d9cfe22ef3
x-ms-traffictypediagnostic: BYAPR02MB4213:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR02MB421330E7361D89862F427A7AFB4B9@BYAPR02MB4213.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mQtlMK5NbKqV85usbUL12g6TWkXr//bSHxwv7e7K88Iy5RoovZEuLnudSR8k37lFEmVXeOEXKSdNocaKeBmLNJOkLcEl9bCRjfHRPwdb2zWBrf6MhxeKB9ylwgQIHYFgq+IUE9OHhqyEA5kGsFedgog4n4DznhrQdSUAUbw/PKgERyrF1ewCNmjXtYlpc177Iz+TJutOx4l2zYePL3mtV/ZiYFnk4GcAYTTECVSSbE1DVmqagEn2rJUUgEaVMBsQbspsDYW4WlnxLA3QRsuQGQXv6PP13r7sv9h8poz1TwW9DMA7xVPKEAEmKgN8aVPAgWXFifRO+Jr1LrUwtTCiQATnAXu/lCw//GLyLvz1iUV8qo21v/HhhWPC30uY///ahZ2OqT+gY+gzfomKzfzGvoKRxaslJlc66qoTfwwD/kApslw+AwcukFvAZInEcJjZEHg9D6ReP0GC7Sk/4CgXxj1+1xFZZyyR8oskLbwn1jguHplk6B5Jizxg1FHeNmpLftW8ryk0WCNE/klEOM6g7iRwuhlbpNR9831/xqnQ3wDMxVdwyYmVhTLdR89LgzNm9W1FpfY2dg/8vyyzslW1rHttrg/gJ3JnbO5ZgMwjUTIABDdZ7zBwc6Jof/Zcm1S2JamvUo1xqB7wVvg1Q97ByP1K+XEEUnEVVWGs8wPcGtNbiqPOnBkpGSxdchdqarAh+gViI7f7dXRSueCBcIZh3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(9686003)(6916009)(8936002)(54906003)(316002)(508600001)(83380400001)(122000001)(2906002)(38100700002)(26005)(66946007)(8676002)(33656002)(38070700005)(86362001)(7696005)(66446008)(66476007)(64756008)(6506007)(55016003)(4326008)(76116006)(53546011)(71200400001)(5660300002)(52536014)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PbrHoN8vpkk9HsOFTFEkD5UKoYuQzJcE15+iF7FGa9zVTCIToolnM3+VlePr?=
 =?us-ascii?Q?a/qteq9LcIdJpXSltEtMhfhsLy+dNiClONV4ehSRIbJ4f5y7fiOUNQsiS1kf?=
 =?us-ascii?Q?9oqaIoIGkTgoELre8+1At+uTzjTSsuCNnlB+DCpIS3svxCxuZBDKsaueL2OE?=
 =?us-ascii?Q?U2e/E2XCf3thbjt1tYLu4+LZNFAC/lZ8NgXw65F2LFUY5GMrYLi/eUZI3REv?=
 =?us-ascii?Q?urRvUYmoJAsUhoRM+yNYoV9mzCCdADQ58OD+kfxoik8fHkUlzLzvkBBEHss7?=
 =?us-ascii?Q?TgSeqsA7bOvl2UgSnxgZQ57AkZQLtBB/xg9b5URIt0yZgHicIxHMGm+tg9s2?=
 =?us-ascii?Q?JqdvawlhXXCIBlsjx1g0SgZSW9tuelXmg2+1rBglJ0pBV9/qPpHUVHjTdbQi?=
 =?us-ascii?Q?i3UQuUp/3kXcpZVfgnR7RhnExA8IOdqWiK6aBcbtY9lQu+SMdkYuLLbwQyoQ?=
 =?us-ascii?Q?CZ3m8OnXWgquTgbiav9qbyZIPu3z+LD9mTrigKhjnzV3/SHlitK/RSUBrZNS?=
 =?us-ascii?Q?9t7zZqbUchsVaEJTQs+KR7gB0GkWpP1fVLSgaxfSdPXa4mq/+BKafgrsMHgD?=
 =?us-ascii?Q?JI4x71WCdNlBSvBwfDTT8n/dJbIsKZBh8rLv+VVZbrv7z0mwO5nEv02rZGx1?=
 =?us-ascii?Q?rYCM8+c5zEpgMmIyNbqJG0n85Z4KiFlG+j8cHqRLEWf30m1/VdV08UAbv5ZH?=
 =?us-ascii?Q?BJ2Hnm/IrymewgU6uzgZinvE0TOBF4sO8ToGZ4usMrz2yUl+9bQ4Nldi499y?=
 =?us-ascii?Q?bdY5SFMJ0khE8NK/W66IDQQiniADM3F5xu4Rq+0suUfzSDY7ju1puuFC7r2q?=
 =?us-ascii?Q?JtsaI1LG9TFJFa+7Lkddbw3aOkwQQ2ONqH7t+NcCvLTlObGweWcI6XFCB5MA?=
 =?us-ascii?Q?5hAD0dHsdK0I/0/1N4zOk4H8brNqgMrkSKzzKfBaCgrF+q7LJhBXiex6teAt?=
 =?us-ascii?Q?gtGMqdbOS0vJRwP60jIN8XM1mPds+Epf0dGm/m3/pS804eGDOX3GPUZ/ZPKa?=
 =?us-ascii?Q?SjeSgLgXxEbzbR0LFygKMjeNtIh1vkK1MHklGtKtU6A+ekAki/WntJN6xevl?=
 =?us-ascii?Q?5poMYG8WiSYmzfbIn18uwXa+mTmCBhu67u7IGd3YcUslHMOpX7RODhlNew9J?=
 =?us-ascii?Q?ijAYgWzQo2cINP5E3Sn0gyqGHK6o/CjSUcD3kZnz5DAvN1ZbxyFOF00tv4ae?=
 =?us-ascii?Q?Hd3Ie5asEVLGelMRm2k6hwByeXAY4g7og4RBvCWT29Et+y59A8q+IJTjbMyW?=
 =?us-ascii?Q?EShP2ziilDRCGutNR9wUpTi6woZuDK3SwcPfsNn8yT4N8OMWK1xJOB8449BY?=
 =?us-ascii?Q?09VnWT6nVsy8my4FNI0dGvn7dR3LQSOHbhs/Qx3TAbnt9uxHnIkP6a6NKBbg?=
 =?us-ascii?Q?0ukw9+ifElgyPudCf9yuiZGtv3lpHAUltuGw+0CSam+zYeMIvPkk0TTUCAUk?=
 =?us-ascii?Q?MzVWfvANHnX1jS3fvNLATOzEkMln1LHoNICXsGXvZV39aPD4zCwmU/3nQCbM?=
 =?us-ascii?Q?ONBZwlW4/RYgVFrQ1sCTRPYc4OBUk9coTZsjz9+Gbo82PiyBYBoZxgA4CsWi?=
 =?us-ascii?Q?c/b2b9paBDyvUBZoaKg9VXkhxZDTrWFtNXB6Vs6Vm8YG+gfU08zfsT/I+ryQ?=
 =?us-ascii?Q?Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f906421-a68a-473c-3287-08d9cfe22ef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 00:27:40.5790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qE2wIKXsuFxxi1zOxQHVSeg7Es25n8xWIBq6fKz4CxX5MXqZSV2+30E8OtAoNF92bzUmqwXMSofibkMnioA1GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4213
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin KaFai Lau <kafai@fb.com>
> Sent: Wednesday, December 29, 2021 1:06 PM
> To: Tyler Wear <twear@quicinc.com>
> Cc: Yonghong Song <yhs@fb.com>; Tyler Wear (QUIC) <quic_twear@quicinc.com=
>; netdev@vger.kernel.org; bpf@vger.kernel.org;
> maze@google.com
> Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
>=20
> WARNING: This email originated from outside of Qualcomm. Please be wary o=
f any links or attachments, and do not enable macros.
>=20
> On Wed, Dec 29, 2021 at 06:29:05PM +0000, Tyler Wear wrote:
> > Unable to run any bpf tests do to errors below. These occur with and wi=
thout the new patch. Is this a known issue?
> > Is the new test case required since bpf_skb_store_bytes() is already a =
tested function for other prog types?
> >
> > libbpf: failed to find BTF for extern 'bpf_testmod_invalid_mod_kfunc'
> > [18] section: -2
> > Error: failed to open BPF object file: No such file or directory
> > libbpf: failed to find BTF info for global/extern symbol 'my_tid'
> > Error: failed to link
> > '/local/mnt/workspace/linux-stable/tools/testing/selftests/bpf/linked_
> > funcs1.o': Unknown error -2 (-2)
> > libbpf: failed to find BTF for extern 'bpf_kfunc_call_test1' [27]
> > section: -2
> tools/testing/selftests/bpf/README.rst has details on these.
>=20
> Ensure the llvm and pahole are up to date.
> Also take a look at the "Testing patches" and "LLVM" section in Documenta=
tion/bpf/bpf_devel_QA.rst.

This will also require adding the l3/l4_ csum_replace() api's then. Adding =
the csum_replace() to a cgroup test case results in the below error during =
bpf program validation:
"BPF_LD_[ABS|IND] instructions not allowed for this program type"

Is there something else that needs to be added? Or would it be better to cr=
eate the function just for ds_field?

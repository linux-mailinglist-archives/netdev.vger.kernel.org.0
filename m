Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7277748160C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhL2S3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:29:11 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.140.77]:8611 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhL2S3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 13:29:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1640802550; x=1641407350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Nd7by/gTgXlMKmVlcUIHi8+H0hLOo2Qjb0ZVlufdAY=;
  b=PpPrrZ6wxUh7U52RFRUeNtLi9OHn1IaV5u5T1LmVCYRBeF3dqT26Uohl
   t3M2ZyKkpDNTvf05FZ8f8gJl3BgCIbCcP3xUWRcEUhN+wkfVjvh0yRLis
   WGpYIFTyKkJpEYp3qs3X8uQtbOVjkuoP5ihByJ99bnbnEeCsl4svAiB+7
   U=;
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 18:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REv7G/ynkSF3OhVkFCJKYQ8mMARyKrxLJaHIgSLOarq2pYe67WJxEtOtnFeROV6q3rfdaNImsvxGsM1g+3ENvZw13Dzg/NAnxKjKSLpCZvWnBej1tHEIPVuS/vo/JKXYc+8R4toU35HpgWwDCCEWQZvNz9tg6ERkU6rYGNHKKg1i9TvAYaoLRpTX4sOJ6BGbY7rrv7Ic69meQELOVaKM1RIPg6+dMteK3HZL4KXOkj40jvj3JpHHzwFevg+MpVtpBPaAHvY3kfuyy3WRoyBqbmmm52/hc/n2aHAG/l/HL6dQaCQM1fJ/c5gJQBcIutZEgiGqEWOBmVO9U2QUYXaJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Nd7by/gTgXlMKmVlcUIHi8+H0hLOo2Qjb0ZVlufdAY=;
 b=fBWfDuqYSPwm1bXrM8vyeX3c7HOR9n7naKfdPNBzRD9+PiWd09gQx8QyV1oTtsFue1Fe1dazJrpre6yW22SxPqPriQgngtei1efOAJIPWczIbx7tlXAVmKvv0l6ueBvK7p8iPthaidy1ITN4bo4QW4PWf2ebORbMJjK7z/tchOtdenoRhGi0JXJl1hqwh+Q026XDScpJtng6ZSNiTNpM6zBsgqBEw7pEKd5sPyawadhWtGkS8gYJgqOJCUCHaNt3+ykpphVscSCSBAKdlgXuVlddtkdy65mdGZa9poyCXXfucOl1zyPHQ+laIs4KnaVuUDgaq7ubXzAN/v6EHFxyvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by BYAPR02MB4629.namprd02.prod.outlook.com (2603:10b6:a03:14::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Wed, 29 Dec
 2021 18:29:05 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%6]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 18:29:05 +0000
From:   Tyler Wear <twear@quicinc.com>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Yonghong Song <yhs@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
Subject: RE: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHX9tuyjzikyJjagEKGz1loPsx8d6w93owAgAE+o3CAABKSgIAKpfOw
Date:   Wed, 29 Dec 2021 18:29:05 +0000
Message-ID: <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed5bf6fc-d09b-4d27-d168-08d9caf91841
x-ms-traffictypediagnostic: BYAPR02MB4629:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR02MB462967D8EA9CAA96D1540151AA449@BYAPR02MB4629.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b/90IiStoIo4BdBwFpL9z5Uubs+y+LiSII4ZwVaz2isGWdxuWOa2W9Z0wT23pQRU66IXXA/3JdpoH1gmpRy7PLRJwoDsdX2VL0L2DBoSlesdWssHKu/JcQ9kFT/qwTF5+A5rQdz2zTeVHywJ94Fk3bfFh8BSx4nyTZrQC/grK3YySPKbGyZtnm5PsXd6MqYB20WsPdTDgK8PI9RIy+a/UV6eeN77LckWdTjXRFeZOxxwU9vfBzveS0Du/g3+H7F4CMWm3Eq37uL1wFA28RbbbDnK8lh58D9sRSrwbMZ6aWrB+X01fC7Gt1UHxLEaBOx9ZSZlConLeT6PhUUlLngsLoXGREseD+Nv936Z5+D8ZDTFgyNW1nAk0UZY+uM9fBSNJksqdQzHzK1yOgQSEM1A/cV01bEmR3F/WJHt+74k/dLtDqZRyWcziyWF0xpDpRkiDAX5dC5C6wmym3iArbML4xrJ6EUtNtG9NnKf38zdt6+tVgiuPCTRdivZ/dLOinIPBx1cg3G9b/MIYYk63xqhhrikwkMNX0Q1KOhswlWPwPKjUxFX/x5tMHvvzYct31wI3pxC0fPGOAWsy/wL2MAU60oOlCuzyAX0myviqUC6FDXl7e/vBsZhwUTion4H3RqkbwuwoX6SQgrA+bJ1givKqxBHEBtasSm6o5AY4N58ITk1yho/Ik6Vxt5Rxb1UMgTpJ1yMqY9Q7nkQ2Ez96A5prA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(83380400001)(66556008)(66476007)(186003)(508600001)(7696005)(8936002)(316002)(5660300002)(6916009)(66446008)(76116006)(9686003)(8676002)(66946007)(71200400001)(52536014)(4326008)(2906002)(6506007)(86362001)(38100700002)(53546011)(33656002)(38070700005)(26005)(55016003)(54906003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AHTcDr0qZCt3oJtHsO5RsJxlgqNxk6Y216Fqyp10Y8XoUtY1oeXiCtAwVHAf?=
 =?us-ascii?Q?hizozremZpV8Rgt7TnLAi3n22ZL9FO4ZaOCL0DRrDae/LIahdZbZ8dZ2RX5Z?=
 =?us-ascii?Q?8a+X9/g87oVDGKaY/KFd/P88sa3Jci0yULgpb4Zzux0HPdaM2PpzbAgU4VJV?=
 =?us-ascii?Q?+XxE7PfVV8xzAHIU/vV1JDWzlXa0SpdP0w1HdoScgYV5eiZU43EftAGcyeeL?=
 =?us-ascii?Q?pwl5TvJCNq0/dE+audo7gdKSa253UG+Y2C2kW7gvW5yVt7IUglCEfFZNZyOG?=
 =?us-ascii?Q?bP+Iv+kan3u5EXB89ZCrYWo+KPkXRw0/Oecw+XBp5IX0yi75aTALplnbNB3w?=
 =?us-ascii?Q?4ReqzaOxfdWZIiEbCbu+IFXcyVtEEL2AHaC+mEHBj+07P7RS068q1qmi3Ka5?=
 =?us-ascii?Q?WmeLLvMxT4x2Y1UgYt7/BpA0l0SKEoV+jDLmsTVjQwvQWzl7RM+QTdEBbvPI?=
 =?us-ascii?Q?Em/jIiOGT+CnjhBb+XKpFCkyMFcQNlhB0OKos9bET/lGqIWUMfJ+eBfXzeSd?=
 =?us-ascii?Q?7uIbtjBCUk7Cls0XrYVwGdK33o5S8v5uTPhjyOsZaU+/TqO0IXmE+GLD8ZrA?=
 =?us-ascii?Q?KsZt8R4FQNs5vDu18o2WGRAea6ogkVYujxr8uE0iaNzrSWdDeFJbL/V+Y22V?=
 =?us-ascii?Q?jNfYt5QdIjkE0iKDzzs51zm1LJsxwFxIG1Gxt95ZhpFzC2vRJT7VUGjbq5+Z?=
 =?us-ascii?Q?IXz4fQWb7wpLkGKoska+Rso1EMTB7Anogvf/Ak20EbQE1OvFpw/MTLWYGCVT?=
 =?us-ascii?Q?HuzDYtCktk/OtL3Jr93lG/OhWYJ6IGgwCgadM7qKJHUAiu7jh+K4vWEbzGkE?=
 =?us-ascii?Q?P66QYXw9Dk/AVrfgKJ/jFOIJtKaIDhr/SQ8NgInKtRT8AqHRDym/j01VpIKi?=
 =?us-ascii?Q?fZMF5RH9QbqBYd/X05YTs7BvNRn8FGgVSkLMiYs2NYez2+BJQFCWAiQlj68f?=
 =?us-ascii?Q?UOXXr756Vm/K+yRsy/mstb6vz7WG3bPKOBfk1Tbqr4cYbHzM9lmLLAMyrkQV?=
 =?us-ascii?Q?8DHRV2Zoaw8sLm6sHdsnthRvVtH/6yhmZXxsXHJciCb9Rm9TiRoQAgv8yZvE?=
 =?us-ascii?Q?eEecaG199NmQkR5XuCTvG8bhmhKMtTktgsK70G8GntGvXW7j7TcWyPSlfPYB?=
 =?us-ascii?Q?zgrcygNEghmVxiE2EHehXujstT+bzBPzs1vhbXkGMvRVWHGgATA7jbhGvLtg?=
 =?us-ascii?Q?nHmFY6k7MrNQHxs8tHCg1St/T9mxufZsSpCCw3qZD3ja7m36sc3uFR+JaaLb?=
 =?us-ascii?Q?lnlR8gk7vjnu1JgeECf6UJR67Gm66MR8saHDN2bj98gIJlZOVCnxF4mhHuH1?=
 =?us-ascii?Q?fdac6kMECmZB0UTQeB8DW+5XF5sMTbCa2RaFHJEx/ihIFbRouVUrz44u3V2p?=
 =?us-ascii?Q?B43Q6c8D9pKF0DSsg0j7jMio6Hyk4QZ58GXEBge3kRuBC2r22csCGz7zi7tU?=
 =?us-ascii?Q?Jp8giMjnXquGUVcJd33EIxRgzufe3yH+hlwfuZjJXv/X5gjyxHyAExgGrRi6?=
 =?us-ascii?Q?xgsRsfRTmhDsx3j41nORlk4fIQhKQCYX/czHkIkh+991s9ogDDkPQ1l4+23N?=
 =?us-ascii?Q?S+GEed1f9SPKTmPKVK2uo+ywvUk6LFoQbBKvFD5nVPOaNudWMUniqa4bB290?=
 =?us-ascii?Q?60dsH54FEZ+FiH2SKtgn204=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5bf6fc-d09b-4d27-d168-08d9caf91841
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2021 18:29:05.1176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+MpP/z4ex87uEO7BY6cffKrXMRMeTwHF0dzf+6zOH1iH4mw3eehT+IF0huQMUVQBZPgVGYpfY1xzNHuyloxmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4629
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin KaFai Lau <kafai@fb.com>
> Sent: Wednesday, December 22, 2021 3:51 PM
> To: Tyler Wear <twear@quicinc.com>
> Cc: Yonghong Song <yhs@fb.com>; Tyler Wear (QUIC) <quic_twear@quicinc.com=
>; netdev@vger.kernel.org; bpf@vger.kernel.org;
> maze@google.com
> Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
>=20
> WARNING: This email originated from outside of Qualcomm. Please be wary o=
f any links or attachments, and do not enable macros.
>=20
> On Wed, Dec 22, 2021 at 10:49:45PM +0000, Tyler Wear wrote:
> > > On 12/21/21 6:27 PM, Tyler Wear wrote:
> > > > Need to modify the ds field to support upcoming Wifi QoS Alliance
> > > > spec. Instead of adding generic function for just modifying the ds
> > > > field, add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB. This
> > > > allows other fields in the network and transport header to be
> > > > modified in the future.
> > >
> > > Could change tag from "[PATCH]" to "[PATCH bpf-next]"?
> > > Please also indicate the version of the patch, so in this case, it sh=
ould be "[PATCH bpf-next v2]".
> > >
> > > I think you can add more contents in the commit message about why
> > > existing bpf_setsockopt() won't work and why CGROUP_UDP[4|6]_SENDMSG =
is not preferred.
> > > These have been discussed in v1 of this patch and they are valuable f=
or people to understand full context and reasoning.
> > >
> > > >
> > > > Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> > > > ---
> > > >   net/core/filter.c | 2 ++
> > > >   1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/net/core/filter.c b/net/core/filter.c index
> > > > 6102f093d59a..0c25aa2212a2 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -7289,6 +7289,8 @@ static const struct bpf_func_proto *
> > > >   cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog=
 *prog)
> > > >   {
> > > >       switch (func_id) {
> > > > +     case BPF_FUNC_skb_store_bytes:
> > > > +             return &bpf_skb_store_bytes_proto;
> > >
> > > Typically different 'case's are added in chronological order to
> > > people can guess what is added earlier and what is added later. Maybe=
 add the new helper after BPF_FUNC_perf_event_output?
> > >
> > > >       case BPF_FUNC_get_local_storage:
> > > >               return &bpf_get_local_storage_proto;
> > > >       case BPF_FUNC_sk_fullsock:
> > >
> > > Please add a test case to exercise the new usage of
> > > bpf_skb_store_bytes() helper. You may piggy back on some existing cg_=
skb progs if it is easier to do.
> >
> > Would it be sufficient to change the dscp value in
> > tools/testing/selftests/bpf/progs/test_sock_fields.c via
> > bpf_skb_store_bytes()
> test_sock_fields focus on sk instead of skb, so it will not be a good fit=
.
>=20
> load_bytes_relative.c may be a better fit.
> The minimal is to write the dscp value by bpf_skb_store_bytes() and be ab=
le to read it back at the receiver side (e.g.
> by making a TCP connection like load_bytes_relative).

Unable to run any bpf tests do to errors below. These occur with and withou=
t the new patch. Is this a known issue?
Is the new test case required since bpf_skb_store_bytes() is already a test=
ed function for other prog types?

libbpf: failed to find BTF for extern 'bpf_testmod_invalid_mod_kfunc' [18] =
section: -2
Error: failed to open BPF object file: No such file or directory
libbpf: failed to find BTF info for global/extern symbol 'my_tid'
Error: failed to link '/local/mnt/workspace/linux-stable/tools/testing/self=
tests/bpf/linked_funcs1.o': Unknown error -2 (-2)
libbpf: failed to find BTF for extern 'bpf_kfunc_call_test1' [27] section: =
-2
Error: failed to open BPF object file: No such file or directory
make: *** [Makefile:484: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/test_ksyms_module.skel.h] Error 255
make: *** Deleting file '/local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/test_ksyms_module.skel.h'
make: *** Waiting for unfinished jobs....
make: *** [Makefile:484: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/kfunc_call_test_subprog.skel.h] Error 255
make: *** Deleting file '/local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/kfunc_call_test_subprog.skel.h'
make: *** [Makefile:482: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/linked_funcs.skel.h] Error 254
libbpf: failed to find BTF info for global/extern symbol 'input_rodata_weak=
'
Error: failed to link '/local/mnt/workspace/linux-stable/tools/testing/self=
tests/bpf/linked_vars1.o': Unknown error -2 (-2)
make: *** [Makefile:482: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/linked_vars.skel.h] Error 254
libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2
Error: failed to open BPF object file: No such file or directory
make: *** [Makefile:486: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/bpf_cubic.skel.h] Error 255
make: *** Deleting file '/local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/bpf_cubic.skel.h'
libbpf: failed to find BTF for extern 'bpf_kfunc_call_test1' [28] section: =
-2
Error: failed to open BPF object file: No such file or directory
make: *** [Makefile:486: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/kfunc_call_test.lskel.h] Error 255
make: *** Deleting file '/local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/kfunc_call_test.lskel.h'
libbpf: failed to find BTF for extern 'tcp_reno_cong_avoid' [38] section: -=
2
Error: failed to open BPF object file: No such file or directory
libbpf: failed to find BTF for extern 'bpf_testmod_invalid_mod_kfunc' [18] =
section: -2
Error: failed to open BPF object file: No such file or directory
make: *** [Makefile:486: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/bpf_dctcp.skel.h] Error 255
make: *** Deleting file '/local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/bpf_dctcp.skel.h'
make: *** [Makefile:486: /local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/test_ksyms_module.lskel.h] Error 255
make: *** Deleting file '/local/mnt/workspace/linux-stable/tools/testing/se=
lftests/bpf/test_ksyms_module.lskel.h'

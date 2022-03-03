Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070714CB5E4
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 05:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiCCE2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 23:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiCCE22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 23:28:28 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF5F34660
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 20:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646281659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZtUSoxTi0crFMW0+QaOUT3mrQOtFkR0ne8hc6bsH0g=;
        b=ByblsuzLQTSS6UAfITE5CXFNrabKr8HONii5QP5N1OOxdaDtMPGn9Vn6+Z0LuuTLYn1u/U
        mHsfdPEHSeseJRZbJS96XhmTyppaTcBjnHyhtO8tLREvaR0qlE3KFI8EFPFpDDPtMnFzCM
        Io5iWj9ij4IpRrHt7unbMw3uRlWsUp8=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-ZYRMiEH1PZ2ua0g3p7iYXw-1; Thu, 03 Mar 2022 05:27:37 +0100
X-MC-Unique: ZYRMiEH1PZ2ua0g3p7iYXw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsUChXBbWjdsThihCnN2uex5RbzVW5FrPu/HtEXjMjPR9ulj5smSz+Q7NuD7mLDUQ1T4AaDZvTLZueVtFRxr/4Vg3gzhgXj1Jcmh4t5wJl4KbXuJC/CK4YLwAM3WKv69yDNR/ZcLKJ1KlxkIEP+ieGkf7sq84FTpN6ZMyi96hEIeAeORQxVPtilicwQ806vQIrjpRTkLBXD3y9ks8VXxq918nW0H/jgEi56qXUpBLKf+An5Vr9hN1J31rBilyAmGGpyH4SAadGuY3ix/i+Jtlbh+pWYe0ZGPm8tRItsMAAb0arn/mMURgBWrBVtgLzld2tx8vjnaqTufWb4HxcWvzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7g2lz3ysCucAKbt9CyneAEjGdGn99PmSLwhhh6odPE=;
 b=NZEBkM36LXEBj9ckpxDC7h6MEF0smT4g9gnPSuQpAjQDlwHneN601HluafyCaV8OV8Co8B/Kj6PLiLoprdC1Jalap/E390fm4GlUGjirJd4blJJhJb4iy+uhNPLO6fyTBX2Cqsa8UqH5eP0ULZHQcjKZRAaI5K+Yz2NTR5bczfsz+BG5+gm+tShaIjHrlFLpRJLiTLS07j1/0tlWlWVE11KbocpSHzosqrKkTWESiGkZ4pJImE3jSeCzOjzmBqTDOmx7bDfKRjb+OwASwFp9r7lr7qT1vNx2SVMPAWpIdT+t622CbgKiN2g9V4uX8UxoIOXq2YVySgHDyW3kSlodSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by AM6PR04MB4552.eurprd04.prod.outlook.com (2603:10a6:20b:1b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Thu, 3 Mar
 2022 04:27:36 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::5d4:d76f:ecea:e459]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::5d4:d76f:ecea:e459%9]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 04:27:35 +0000
Date:   Thu, 3 Mar 2022 12:27:25 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
CC:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
Message-ID: <YiBDra2tDY3+OAh1@syu-laptop.lan>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
 <YgdIWvNsc0254yiv@syu-laptop.lan>
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com>
 <YgwBN8WeJvZ597/j@syu-laptop>
 <20220302174645.GS3113@kunlun.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220302174645.GS3113@kunlun.suse.cz>
X-ClientProxiedBy: HK2PR02CA0206.apcprd02.prod.outlook.com
 (2603:1096:201:20::18) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3dfdb5c-2e95-4ad4-efd1-08d9fcce243e
X-MS-TrafficTypeDiagnostic: AM6PR04MB4552:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB45528AFD96ECC7546DE2F9DDBF049@AM6PR04MB4552.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmgWhSVmjIL7u7DOjD1qOacpJg9XlhCBY80JPRdi1mOCqnb4nfcplYLc2TfQKA4oF/+5GqlHiqUybyA55/mUoiyL8EZiwfUpwBDKbs7firMKsxUkuHFHzBk/vYPEqAv9+jeRWIbxBclVsj2FM9m4JDggGitCCJbwwstC0mBVNGVpu4PU3M11HQd8LmH77uzJbMXIIP5dYCuLnclx/4nwvGnged5AZnYWh7Bl+cp/g7BCxCcvdatHAxPcPb93EyfTNVxKY7Op3D+l/cD2gvN6aTLHP8uZcxea7cGjwkpwEIxJTQukXqtCM8NeAl6HpBd8njZhyiRnNUk2QdbzFbND3SM18Uv+hgLTZZP6gC8ZoWorUqZ+b/+nnnWMyI1YvKZoInCj1i1MEAcFqDheniKq19enrf3zpgjIjDX8zZmsh3g4Epm9h4XdSpP49/pa0UBezbqqmP51WW7ifkvijX5aihrthKpCwP0OhvFdwEd8Y2TxxGKtdpJAOyURK/vg+Wj2NOw1rxQ5EzZgdQAh4V4BVisi9AwPBYrik1SpRHI2kNpT+ReoWJ/AKP68O3JYY+3Q3ixg39MXR31afkfUQgxZY1pN20ObpolMf+OWFX/1csITCXBoqYqmAz+S3x9xZBikNr97c6YnVJ6s+LAO3/aILzAFy9jN296VgB75SwdPBbw4/QzRaydnNYpbEfqI2GYd7hnvs9T7Y94lcrHumWin3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(508600001)(6486002)(8936002)(5660300002)(66556008)(66476007)(8676002)(4326008)(66946007)(54906003)(6916009)(316002)(83380400001)(66574015)(6666004)(6512007)(9686003)(53546011)(38100700002)(6506007)(186003)(26005)(2906002)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bT8L+TUBrFMTr3MSGe1sN82O6U7ww0Jx5VFdIG+S2HG1QEBM9NMfyA8Horyb?=
 =?us-ascii?Q?b5w4jt1ButNIXKp87MDzxEjfR4FJVS/KczCGOuJgetvxfX1Ty6qE/5aBhM3E?=
 =?us-ascii?Q?lWtFoPS/U11ym8WJmnywUo+l3/FaAFaz3Dd0R/QthWxPfw/Chop/vwmRv6Yg?=
 =?us-ascii?Q?eyc6HiwcqhqenkvPFP6ebR0ydik81J/RLRs6I11Ml+X7EyPWRN1hK9vfGkkO?=
 =?us-ascii?Q?1zhSvQ46eMfmHgz4jO4vEZyg7GzzRagzedLRn+JhpgMn+7oSyneS2OGI1dgS?=
 =?us-ascii?Q?Jts1TZYUEXix7wq5fdl91OugzhZSMHxSpV/DCI1tKB3NiItbd0NGcaoBc7EF?=
 =?us-ascii?Q?m3Nn6ARb6I9V0LGl6nNaxp0apsYeW0gAqqH4g8YVW2iSdInSx9ANru49VXQC?=
 =?us-ascii?Q?RzkaWEy4tcbiXo/uEC1bcVOBIdBmPAoQt9lcWxKeNxdCL2Q5hFIk3V8vJYtH?=
 =?us-ascii?Q?qsKJWX63FenMdckx9xmiXYTcpC9EeTAIXQAJHWZ6izMRlrXWqgKGxrRvs/bA?=
 =?us-ascii?Q?ZEENmFLiJTtXHYc8SNT4KIyg1vcE+AhBzXLjg+aVl+Fp2fnKAvX0VYXOvC75?=
 =?us-ascii?Q?sW2IHMFN21iyihnNBTXMwQ+41pH0bW9I1axqGoTfGUKgCrApAN/DUc74rQ6N?=
 =?us-ascii?Q?tCy3YR6NFkSO4o2wkEdOanDXo/4Vf6XsUQU5cxNtUrcluw2Gl0RCzg8KHu02?=
 =?us-ascii?Q?TyE0J39hC4TUdwYMRMYlzd0Buu1A5Z2jI2phQZkdBmH/ZwcF5Jem4kNH1E4x?=
 =?us-ascii?Q?e9ZLCTc6v8YSt0lq8P58wZVkHTS/C/jIwmlU/yumur9BqrCcxwfXK+QjQCXM?=
 =?us-ascii?Q?a6eFV9mPQQzCvSxTeZswd0st8OBPWefoMAIohGJXQSLIKyxVN9+G8wUpaGif?=
 =?us-ascii?Q?E/6+EGCEYnMQ4pm9tGVlg0yBShxUHpqsP5gu6P74pNB0iKrV/dXmSLcdx/iT?=
 =?us-ascii?Q?Mks5VGEDSVarUQDlj58korXET7/rmWNMeka5YcxkvCuH5DztU2rgK47ixHrA?=
 =?us-ascii?Q?vs7Kya20106FqtxtFTfhlNFFr1tuWdDRPleEf+e+uWJvDbSuRAuG7HBF3W+N?=
 =?us-ascii?Q?Su9gZr526JE0s7S39zRkK/TlEdcY+X0FQJMO8hM2fVl/pgnbp9wKWLJahlHt?=
 =?us-ascii?Q?IDqxt2VS5LpZ+p8Hxf2hSu4fLx/MYMmIlWaYyTh7sW+lrCKoSjLU1RHvIta2?=
 =?us-ascii?Q?etkDeWOTAXGEtY9CFf72EVC1Ek0FRKqB7W0Pv0MbzIOYCB0ZymFcaQP7X42r?=
 =?us-ascii?Q?9BaW5u0/HOGd/r1f6n+taMS9rIETcCuKFaLZfHzDTulzHp1lyYL7bS0bueHj?=
 =?us-ascii?Q?SRGDA+WyQ8pkGGMjpsAdjh6mRkca051aQTX8/9n9/euOQ39wINbpCwh7XeQo?=
 =?us-ascii?Q?LAhpI6CArkfA6mNNlxOP+TaSTAP8IqymnIBMNhpudvKok21UAya/GR8AQn5J?=
 =?us-ascii?Q?/8aw4kcdZj+y+h0OpEPzmpV6mEGdeRU6EchbwXpNXlHaihpcK9Nk3YvAUCZd?=
 =?us-ascii?Q?jceyKSlre99g9ZBGxQX0sruBpLwgAbRFYpUAex+dDKWSKAjKQf29DSgwz2Ge?=
 =?us-ascii?Q?ujyCRXde05ZQmc8mNkhEdixTKo/xr0V0kHSBVfnK6xWlHByHea5HKjp5Au0y?=
 =?us-ascii?Q?1/VXe0bsFGtmS0ZUd+EehOI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3dfdb5c-2e95-4ad4-efd1-08d9fcce243e
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 04:27:35.5732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DKBq5oNkgwHzY14m08jaV36cStx0vSPT+b/vWzkILnhGvsgn5jGeF0+BBkS6S8o4KyZfF3vMMPHJS8HqLtFnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4552
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 06:46:45PM +0100, Michal Such=C3=A1nek wrote:
> On Wed, Feb 16, 2022 at 03:38:31AM +0800, Shung-Hsi Yu wrote:
> > On Fri, Feb 11, 2022 at 10:36:28PM -0800, Yonghong Song wrote:
> > > On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
> > > > On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
> > > > > On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
> > > > > > On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wro=
te:
> > > > > > > On 2/10/22 2:01 AM, Michal Such=C3=A1nek wrote:
> > > > > > > > On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wro=
te:
> > > > > > > > > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> > > > > > > > > > Hi,
> > > > > > > > > >=20
> > > > > > > > > > We recently run into module load failure related to spl=
it BTF on openSUSE
> > > > > > > > > > Tumbleweed[1], which I believe is something that may al=
so happen on other
> > > > > > > > > > rolling distros.
> > > > > > > > > >=20
> > > > > > > > > > The error looks like the follow (though failure is not =
limited to ipheth)
> > > > > > > > > >=20
> > > > > > > > > >         BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF=
: BPF:Invalid name BPF:
> > > > > > > > > >=20
> > > > > > > > > >         failed to validate module [ipheth] BTF: -22
> > > > > > > > > >=20
> > > > > > > > > > The error comes down to trying to load BTF of *kernel m=
odules from a
> > > > > > > > > > different build* than the runtime kernel (but the sourc=
e is the same), where
> > > > > > > > > > the base BTF of the two build is different.
> > > > > > > > > >=20
> > > > > > > > > > While it may be too far stretched to call this a bug, s=
olving this might
> > > > > > > > > > make BTF adoption easier. I'd natively think that we co=
uld further split
> > > > > > > > > > base BTF into two part to avoid this issue, where .BTF =
only contain exported
> > > > > > > > > > types, and the other (still residing in vmlinux) holds =
the unexported types.
> > > > > > > > >=20
> > > > > > > > > What is the exported types? The types used by export symb=
ols?
> > > > > > > > > This for sure will increase btf handling complexity.
> > > > > > > >=20
> > > > > > > > And it will not actually help.
> > > > > > > >=20
> > > > > > > > We have modversion ABI which checks the checksum of the sym=
bols that the
> > > > > > > > module imports and fails the load if the checksum for these=
 symbols does
> > > > > > > > not match. It's not concerned with symbols not exported, it=
's not
> > > > > > > > concerned with symbols not used by the module. This is some=
thing that is
> > > > > > > > sustainable across kernel rebuilds with minor fixes/feature=
s and what
> > > > > > > > distributions watch for.
> > > > > > > >=20
> > > > > > > > Now with BTF the situation is vastly different. There are a=
t least three
> > > > > > > > bugs:
> > > > > > > >=20
> > > > > > > >     - The BTF check is global for all symbols, not for the =
symbols the
> > > > > > > >       module uses. This is not sustainable. Given the BTF i=
s supposed to
> > > > > > > >       allow linking BPF programs that were built in complet=
ely different
> > > > > > > >       environment with the kernel it is completely within t=
he scope of BTF
> > > > > > > >       to solve this problem, it's just neglected.
> > > > > > > >     - It is possible to load modules with no BTF but not mo=
dules with
> > > > > > > >       non-matching BTF. Surely the non-matching BTF could b=
e discarded.
> > > > > > > >     - BTF is part of vermagic. This is completely pointless=
 since modules
> > > > > > > >       without BTF can be loaded on BTF kernel. Surely it wo=
uld not be too
> > > > > > > >       difficult to do the reverse as well. Given BTF must p=
ass extra check
> > > > > > > >       to be used having it in vermagic is just useless mois=
e.
> > > > > > > >=20
> > > > > > > > > > Does that sound like something reasonable to work on?
> > > > > > > > > >=20
> > > > > > > > > >=20
> > > > > > > > > > ## Root case (in case anyone is interested in a verbose=
 version)
> > > > > > > > > >=20
> > > > > > > > > > On openSUSE Tumbleweed there can be several builds of t=
he same source. Since
> > > > > > > > > > the source is the same, the binaries are simply replace=
d when a package with
> > > > > > > > > > a larger build number is installed during upgrade.
> > > > > > > > > >=20
> > > > > > > > > > In our case, a rebuild is triggered[2], and resulted in=
 changes in base BTF.
> > > > > > > > > > More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus=
_check_pec(u8 cpec,
> > > > > > > > > > struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct i=
net_hashinfo *h,
> > > > > > > > > > struct sock *sk) was added to the base BTF of 5.15.12-1=
.3. Those functions
> > > > > > > > > > are previously missing in base BTF of 5.15.12-1.1.
> > > > > > > > >=20
> > > > > > > > > As stated in [2] below, I think we should understand why =
rebuild is
> > > > > > > > > triggered. If the rebuild for vmlinux is triggered, why t=
he modules cannot
> > > > > > > > > be rebuild at the same time?
> > > > > > > >=20
> > > > > > > > They do get rebuilt. However, if you are running the kernel=
 and install
> > > > > > > > the update you get the new modules with the old kernel. If =
the install
> > > > > > > > script fails to copy the kernel to your EFI partition based=
 on the fact
> > > > > > > > a kernel with the same filename is alreasy there you get th=
e same.
> > > > > > > >=20
> > > > > > > > If you have 'stable' distribution adding new symbols is nor=
mal and it
> > > > > > > > does not break module loading without BTF but it breaks BTF=
.
> > > > > > >=20
> > > > > > > Okay, I see. One possible solution is that if kernel module b=
tf
> > > > > > > does not match vmlinux btf, the kernel module btf will be ign=
ored
> > > > > > > with a dmesg warning but kernel module load will proceed as n=
ormal.
> > > > > > > I think this might be also useful for bpf lskel kernel module=
s as
> > > > > > > well which tries to be portable (with CO-RE) for different ke=
rnels.
> > > > > >=20
> > > > > > That sounds like #2 that Michal is proposing:
> > > > > > "It is possible to load modules with no BTF but not modules wit=
h
> > > > > >    non-matching BTF. Surely the non-matching BTF could be disca=
rded."
> > > >=20
> > > > Since we're talking about matching check, I'd like bring up another=
 issue.
> > > >=20
> > > > AFAICT with current form of BTF, checking whether BTF on kernel mod=
ule
> > > > matches cannot be made entirely robust without a new version of btf=
_header
> > > > that contain info about the base BTF.
> > >=20
> > > The base BTF is always the one associated with running kernel and typ=
ically
> > > the BTF is under /sys/kernel/btf/vmlinux. Did I miss
> > > anything here?
> > >=20
> > > > As effective as the checks are in this case, by detecting a type na=
me being
> > > > an empty string and thus conclude it's non-matching, with some (bad=
) luck a
> > > > non-matching BTF could pass these checks a gets loaded.
> > >=20
> > > Could you be a little bit more specific about the 'bad luck' a
> > > non-matching BTF could get loaded? An example will be great.
> >=20
> > Let me try take a jab at it. Say here's a hypothetical BTF for a kernel
> > module which only type information for `struct something *`:
> >=20
> >   [5] PTR '(anon)' type_id=3D4
> >=20
> > Which is built upon the follow base BTF:
> >=20
> >   [1] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=
=3D(none)
> >   [2] PTR '(anon)' type_id=3D3
> >   [3] STRUCT 'list_head' size=3D16 vlen=3D2
> >         'next' type_id=3D2 bits_offset=3D0
> >         'prev' type_id=3D2 bits_offset=3D64
> >   [4] STRUCT 'something' size=3D2 vlen=3D2
> >         'locked' type_id=3D1 bits_offset=3D0
> >         'pending' type_id=3D1 bits_offset=3D8
> >=20
> > Due to the situation mentioned in the beginning of the thread, the *run=
time*
> > kernel have a different base BTF, in this case type IDs are offset by 1=
 due
> > to an additional typedef entry:
> >=20
> >   [1] TYPEDEF 'u8' type_id=3D1
> >   [2] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=
=3D(none)
> >   [3] PTR '(anon)' type_id=3D3
> >   [4] STRUCT 'list_head' size=3D16 vlen=3D2
> >         'next' type_id=3D2 bits_offset=3D0
> >         'prev' type_id=3D2 bits_offset=3D64
> >   [5] STRUCT 'something' size=3D2 vlen=3D2
> >         'locked' type_id=3D1 bits_offset=3D0
> >         'pending' type_id=3D1 bits_offset=3D8
> >=20
> > Then when loading the BTF on kernel module on the runtime, the kernel w=
ill
> > mistakenly interprets "PTR '(anon)' type_id=3D4" as `struct list_head *=
`
> > rather than `struct something *`.
> >=20
> > Does this should possible? (at least theoretically)
>=20
> At least not this way because you have different number of entries which
> was the original issue.

Indeed the number of type entries differs, but type entry number of base BT=
F
isn't part of the check (and it can't be checked, again, because kernel
module doesn't store details of it's base BTF).

So this made-up kernel module BTF _can_ be loaded into the kernel if the
type names in string section are resolved correctly as well. It is the type
name check is that catches the original issue (i.e. the "Invalid name" erro=
r
we see), not the difference in the number of type entries.=20

AFAIK type name check verifies that all types that are anonymous (e.g. PTR)=
,
have struct btf_type.name_off of 0 and that types that can't be anonymous
(e.g. INT) has name_off that points to a valid string that isn't an empty
one.

> So is this possible at least theoretically, and how likely will that
> happen in practice?
>=20
> What else other than the number of entries has to match?

To the best of my knowledge only the type name check needs to pass in this
case.


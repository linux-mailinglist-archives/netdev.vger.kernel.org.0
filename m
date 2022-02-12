Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226044B339E
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 08:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbiBLHhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 02:37:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiBLHhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 02:37:45 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15A826AE5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 23:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644651460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k3a3AtJ+edoDwHiOazXWkFbXPNpe9j8dBz/CquTc8KU=;
        b=PGbESGJMDN2fqFSxwmIa3R5ASIqmROWY2pFofCeRQdpbBlU/n2ak6luBw5qYYxCYNfJa1K
        /T/BCVhYLGSEmNBTvR37tRTOg4Jh/FDutAqSQRrS3h0dXlTlpZHn6JPU7kQgmO9vca+at/
        zkHPV5d0BR64nmotJa+MsFxXBhQ9ZvA=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2055.outbound.protection.outlook.com [104.47.0.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-31--tWGtRXZMCiNdN1q6fZcFw-2; Sat, 12 Feb 2022 08:37:38 +0100
X-MC-Unique: -tWGtRXZMCiNdN1q6fZcFw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrJvCmWQRyleC5R7k4OYlhh6poqa8TI9rOfYVTytbAQhry2BDsJJf+tZ1nD0nc0rlK1iFPK7ihReHtlH4Qh2YgyDQS3V6yaT183GRfmdTgUO2SsmiSjfNnOdI+0GBINLQkNecjOarVJoGJqiVxTFdunaR3FQrAX2ChhPSLPkSdWFy+MjEWNX0d0LF9QT7MX4/sZaxyVXCdlf10bTt8CHd2XYYsYoKaG7yGtxnyGwIT6tMerk1B2tYb4dwzCKSjOJr5Gy/WwLVUantKg8pm4bWRT1frQwZUG/nOtdMNxv57ybvbzx7WaQ7jtXutjfHCyCYaGN/BvWmsqBu15Pj22++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqL+WxlKbWH7pqwbOHyEPil1ld2JUcZwi+49VIPP6r8=;
 b=JZMsFZBh4LY8uEJFyJXrjAXgALU7WF10iuxHoiqu7YNzJdBZDRQCcD9kdSArRxsNrAZzg9izKEAtCKRmq5dyfKoMLOeE3yDWAaD0lhEHY0X1CvHqpFErcAbB+m5GM+5L4Dk6yoY+3rTj7zejQjNjpR+uDeQuwqWxqxPBeleJ2svli6EXVYu5jFrEoXiOtd3y4P/8pCgdv2R5BCss/YOJNHWY3aJ9rBcioEFWEQ7qCYoTmpMUBRnE1NiZeKDADCUapSlGjP3JqiTS2nBJP8idlUfCdZRLOlgqqf2/b/ytEFGIxtihnkZFqkv6905rVgj+GUaQ8fWPPenxagUNfiM9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by AM9PR04MB8354.eurprd04.prod.outlook.com (2603:10a6:20b:3b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Sat, 12 Feb
 2022 07:37:36 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f%8]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 07:37:36 +0000
Date:   Sat, 12 Feb 2022 15:37:27 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
Message-ID: <Ygdjt0Qbki0tHG4k@syu-laptop.lan>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <CAEf4BzZ6CrNGWt3DENvCBXpUKrvNiZwoK87rR75izP=CDf8YoQ@mail.gmail.com>
 <87a6ex8gm8.fsf@toke.dk>
 <CAEf4BzYJCHB-oYqFqJTfHU4D795ewgkndQtR1Po5H521fH0oMg@mail.gmail.com>
 <87v8xl6jlw.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87v8xl6jlw.fsf@toke.dk>
X-ClientProxiedBy: HK2PR0302CA0021.apcprd03.prod.outlook.com
 (2603:1096:202::31) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a308aa6-6125-42ff-50b6-08d9edfa89dc
X-MS-TrafficTypeDiagnostic: AM9PR04MB8354:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB83545F48AF995143330F2D66BF319@AM9PR04MB8354.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcOyySQlMvxQS8zMoZYLlELCpuHSjJtIYr7Uw9V9nVx0b7dVlIwin2sYkq9yaR72fjZffzq0cS2iJOLxbe8IafyX6AOoXj4GtCEKUV4WpTsUBTXQh1RTmv8s8PBT+RfBH/sQqYIctpt3cocr0J0dYUTqVsvOj2ndCCYN16VfN/jzFuZnlgmljBbNHxdzSiuufLadxEpL8tuZgEFTRTNRivw5MMCtpITyJBcjR5vB22px2UVHjbPuLuvupuwT0Oem21IbppPQOtrq4spbyuEi+EBvj8nVAdAidM3OA8AKCJpXhwD1BCG9FMWXEAyI5YdWJXZnCmqvDFZG0uftjskRCBegCoVaQR2cbDkUpfHrWAyxyACzO5qZM/stY1r4wGoeLFSLeW77Cq/ttCDk/02I6p8L1f4bJ4T5xX2EG+IeprSuXcTweimp0+MovaUd8aaVLBipwiJOfOk6Tb8u9waIl/wDUxmdZRSTiluUQoicXWZk/npABIBcpNXSt6WkNOsKoxlVcNVFh7gIqTpVgK7GrBfO81xgKsG/khXY3TO2IwRubkdbKh6PuXXtrC71VMdtZUvbEAM2jdel5ViTAbn7Eti001Vwzd17s0hJNp7mOw3HvsFeFYD058oJMyCiBVu8Ytp3CmGC0kKMeX5AlQBiCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(83380400001)(6512007)(8936002)(66574015)(186003)(9686003)(26005)(6916009)(8676002)(316002)(6666004)(508600001)(53546011)(6486002)(86362001)(54906003)(5660300002)(6506007)(2906002)(4326008)(66556008)(66946007)(38100700002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqVaApk0BDErW8pmPLI/sqftrXolRKJDFKdHQbaNOwBtlWoTuWDruz/A2Lph?=
 =?us-ascii?Q?56YJqlM0TKgJiG1ObI1uL1WYFPUfDhYONV3mTtfcMsS4LphO0rCT9YI5VcEX?=
 =?us-ascii?Q?ZDOrajL9cAlWWv/GuQc8zg2ZehBBFQfEbejcnB+mwb1E0oT1LJRV5sUolGSX?=
 =?us-ascii?Q?njaBpIhmDNWlU/FivN6PI/tNcvvLh8Kg+Sws9ea/ew8JXaNLvu/XU6wEW9R1?=
 =?us-ascii?Q?wi+AoftpYrgaTErMxLLuRoEZZJrHMu/00mtko7NTDec9kgrtFNccCX3ggc+a?=
 =?us-ascii?Q?7+Q46wyoepFppdUp72yKzGBTcSB3NsqRoCpi6Z5Ze0GFkk8v4TFU/r2hcWvO?=
 =?us-ascii?Q?eClrrfsSyHPx92ub3kqoXjUapjTsN4ziPjWrM53I/C4vissHt/wowloap6x+?=
 =?us-ascii?Q?yJCozBihcHFtnKCZWaWTOY0qI49EVPlNwhOAdsZBusSL8s5oLIEMcaqE893W?=
 =?us-ascii?Q?8Z/lLlj+rqLXEtR1W+piIrBLhrhp2m+knMun6rFPPijo1gO6Q2DmgaIKre0L?=
 =?us-ascii?Q?UIe+/gWSS3O4pW88JzYtCsURUjKqUI5UCg8fgCOKs2mISMIV5znGl/yw05xk?=
 =?us-ascii?Q?V9K49d6nzmO6oMNzwA7YVr5QLfegR2B1d3lfMs1K7DgwpTWddwyZoxKYQBhT?=
 =?us-ascii?Q?YkH0OZPNgOd1/dREZqpfuV/vQn60lKNKk2DcSi/a3haiGSSblz6DZmxDZD5b?=
 =?us-ascii?Q?JSrvU9Nz9L7CdALFmjscJRHNeMOWUdcA7HGddjj1IFlUgvX9DUu0d5+HUY90?=
 =?us-ascii?Q?yVPrqBLWsSm6QQ0+4e4NVRYFcQ5BNSJmQyMcDNHoZzBSJjdHeN7cpxUzmToR?=
 =?us-ascii?Q?0hNzq9m28htHbhDb4zz5+nlRIaKXRp8DOUxbVRx20TxO9Cfj+W6MtEK1sCrH?=
 =?us-ascii?Q?DbdID1qT7ZTHnOc/lZovNUFNqyOw5V1w3IfXGyH5HE3YaqDUuLfk679xljmR?=
 =?us-ascii?Q?6EtcmYfPwrH81sRyDgGLWZf9DjK8+glBOI4KlVU8bqs4bN7HHrOhAwvF9KRE?=
 =?us-ascii?Q?W8Aa/SwkW/Ud49Bqf7nIg012sroGJ1fH/uyQMS91bnsDfuIpTSYhkfS33gTw?=
 =?us-ascii?Q?fmWnDjUaU4fHj1w/iDOnWDOBi3Sjri2iRzvHD9nYaFFfuYh6bFOQmDk7ZAfO?=
 =?us-ascii?Q?wsh1pBNtN/jssaBJW6MQOACtd09h3xAXu0YrU3lF6BAGAzB2XZ5yM/nGZikr?=
 =?us-ascii?Q?Onijvch3R6O7B4YetWJDrT2+vRXQcdgJYRJ9IKO6/dHFRS7z07u1zHaN2pBQ?=
 =?us-ascii?Q?l5tTcuCmE4JrAm8GUD9X/8BH+si7TLPTO2jmVXQPTlYm7afEUHiEWBDwmBS5?=
 =?us-ascii?Q?XWMMkINvoluMIpeNT5vOQ2Z7sCMReojS/RSk4mAkYgieq7EBopHlEy8SFBSI?=
 =?us-ascii?Q?QPGZyF0V5SM3R4JcbVAAYP0ZYhgnsLi5s50pS76dwO5Xkv15iNpQw9IDNImm?=
 =?us-ascii?Q?oYlx7xcIyx/Muhry7lGTKm9KyHUkM5z0a7DIx4iW8aGSr86W6Xru4y6y2ZUt?=
 =?us-ascii?Q?pCCUlp3OwKWh3P+zatKZP5fCCrO/x1g1kJCDQsUCi3/3B7RUr/66Bw126PI0?=
 =?us-ascii?Q?SYkWGWRyVyPMXWsn0lZjxiPn2PFiLbAXEbPmX6kPq99NL+uQdhmooWWyibe6?=
 =?us-ascii?Q?Mrl9ssHnwnon1NgLwwd2KCY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a308aa6-6125-42ff-50b6-08d9edfa89dc
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 07:37:36.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PPaKW74x6tuvkvrm5RlP3k7AC//+GgCpF9U3WP7msf/QeutyiEVB/3DcVQQyhLBgbAnPOKq9lC2xqPTvo8iPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8354
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 12, 2022 at 12:58:51AM +0100, Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>=20
> > On Fri, Feb 11, 2022 at 9:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Thu, Feb 10, 2022 at 2:01 AM Michal Such=C3=A1nek <msuchanek@suse=
.de> wrote:
> >> >>
> >> >> Hello,
> >> >>
> >> >> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> >> >> >
> >> >> >
> >> >> > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> >> >> > > Hi,
> >> >> > >
> >> >> > > We recently run into module load failure related to split BTF o=
n openSUSE
> >> >> > > Tumbleweed[1], which I believe is something that may also happe=
n on other
> >> >> > > rolling distros.
> >> >> > >
> >> >> > > The error looks like the follow (though failure is not limited =
to ipheth)
> >> >> > >
> >> >> > >      BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Inval=
id name BPF:
> >> >> > >
> >> >> > >      failed to validate module [ipheth] BTF: -22
> >> >> > >
> >> >> > > The error comes down to trying to load BTF of *kernel modules f=
rom a
> >> >> > > different build* than the runtime kernel (but the source is the=
 same), where
> >> >> > > the base BTF of the two build is different.
> >> >> > >
> >> >> > > While it may be too far stretched to call this a bug, solving t=
his might
> >> >> > > make BTF adoption easier. I'd natively think that we could furt=
her split
> >> >> > > base BTF into two part to avoid this issue, where .BTF only con=
tain exported
> >> >> > > types, and the other (still residing in vmlinux) holds the unex=
ported types.
> >> >> >
> >> >> > What is the exported types? The types used by export symbols?
> >> >> > This for sure will increase btf handling complexity.
> >> >>
> >> >> And it will not actually help.
> >> >>
> >> >> We have modversion ABI which checks the checksum of the symbols tha=
t the
> >> >> module imports and fails the load if the checksum for these symbols=
 does
> >> >> not match. It's not concerned with symbols not exported, it's not
> >> >> concerned with symbols not used by the module. This is something th=
at is
> >> >> sustainable across kernel rebuilds with minor fixes/features and wh=
at
> >> >> distributions watch for.
> >> >>
> >> >> Now with BTF the situation is vastly different. There are at least =
three
> >> >> bugs:
> >> >>
> >> >>  - The BTF check is global for all symbols, not for the symbols the
> >> >>    module uses. This is not sustainable. Given the BTF is supposed =
to
> >> >>    allow linking BPF programs that were built in completely differe=
nt
> >> >>    environment with the kernel it is completely within the scope of=
 BTF
> >> >>    to solve this problem, it's just neglected.
> >> >
> >> > You refer to BTF use in CO-RE with the latter. It's just one
> >> > application of BTF and it doesn't follow that you can do the same wi=
th
> >> > module BTF. It's not a neglect, it's a very big technical difficulty=
.
> >> >
> >> > Each module's BTFs are designed as logical extensions of vmlinux BTF=
.
> >> > And each module BTF is independent and isolated from other modules
> >> > extension of the same vmlinux BTF. The way that BTF format is
> >> > designed, any tiny difference in vmlinux BTF effectively invalidates
> >> > all modules' BTFs and they have to be rebuilt.
> >> >
> >> > Imagine that only one BTF type is added to vmlinux BTF. Last BTF typ=
e
> >> > ID in vmlinux BTF is shifted from, say, 1000 to 1001. While previous=
ly
> >> > every module's BTF type ID started with 1001, now they all have to
> >> > start with 1002 and be shifted by 1.
> >> >
> >> > Now let's say that the order of two BTF types in vmlinux BTF is
> >> > changed, say type 10 becomes type 20 and type 20 becomes type 10 (ju=
st
> >> > because of slight difference in DWARF, for instance). Any type
> >> > reference to 10 or 20 in any module BTF has to be renumbered now.
> >> >
> >> > Another one, let's say we add a new string to vmlinux BTF string
> >> > section somewhere at the beginning, say "abc" at offset 100. Any
> >> > string offset after 100 now has to be shifted *both* in vmlinux BTF
> >> > and all module BTFs. And also any string reference in module BTFs ha=
ve
> >> > to be adjusted as well because now each module's BTF's logical strin=
g
> >> > offset is starting at 4 logical bytes higher (due to "abc\0" being
> >> > added and shifting everything right).
> >> >
> >> > As you can see, any tiny change in vmlinux BTF, no matter where,
> >> > beginning, middle, or end, causes massive changes in type IDs and
> >> > offsets everywhere. It's impractical to do any local adjustments, it=
's
> >> > much simpler and more reliable to completely regenerate BTF
> >> > completely.
> >>
> >> This seems incredibly brittle, though? IIUC this means that if you wan=
t
> >> BTF in your modules you *must* have not only the kernel headers of the
> >> kernel it's going to run on, but the full BTF information for the exac=
t
> >
> > From BTF perspective, only vmlinux BTF. Having exact kernel headers
> > would minimize type information duplication.
>=20
> Right, I meant you'd need the kernel headers to compile the module, and
> the vmlinux BTF to build the module BTF info.
>=20
> >> kernel image you're going to load that module on? How is that supposed
> >> to work for any kind of environment where everything is not built
> >> together? Third-party modules for distribution kernels is the obvious
> >> example that comes to mind here, but as this thread shows, they don't
> >> necessarily even have to be third party...
> >>
> >> How would you go about "completely regenerating BTF" in practice for a
> >> third-party module, say?
> >
> > Great questions. I was kind of hoping you'll have some suggestions as
> > well, though. Not just complaints.
>=20
> Well, I kinda took your "not really a bug either" comment to mean you
> weren't really open to changing the current behaviour. But if that was a
> misunderstanding on my part, I do have one thought:
>=20
> The "partial BTF" thing in the modules is done to save space, right?
> I.e., in principle there would be nothing preventing a module from
> including a full (self-contained) set of BTF in its .ko when it is
> compiled? Because if so, we could allow that as an optional mode that
> can be enabled if you don't mind taking the size hit (any idea how large
> that usually is, BTW?).

This seems quite nice IMO as no change need to be made on the generation
side of existing BTF tooling. I test it out on openSUSE Tumbleweed 5.16.5
kernel modules, and for the sake of completeness, includes both the case
where BTF is stripped and using a pre-trained zstd dictionary as well.

Uncompressed, no BTF                             362MiB -27%
Uncompressed, parital BTF                        499MiB +0%
Uncompressed, self-contained BTF                1026MiB +105%

Zstd compressed, no BTF                           95MiB -35%
Zstd compressed, partial BTF                     147MiB +0%
Zstd compressed, self-contained BTF              361MiB +145%
Zstd compressed (trained), self-contained BTF    299MiB +103%

So we'd expect quite a bit of hit as the size of kernel module would double=
.

For servers and workstation environment an additional ~200MiB of disk space
seems like tolerable trade-off if it can get third-party kernel module to
work. But I cannot speak for other kind of use cases.

> And then we could teach 'modprobe' to do a fresh deduplication of this
> full BTF set against the vmlinux BTF before loading such a module into th=
e
> kernel.
>=20
> Or am I missing some reason why that wouldn't work?

One minor problem would be this is essentially introducing a new kernel
module BTF format that uses exactly the same header.

Ever since the introduction of split BTF, we're reusing btf_header but
acting as if there's an extra hidden flag indicating whether the BTF is
self-contained or partial. So far we could implicitly guess the value of th=
e
flag since BTF in vmlinux is always self-contained and BTF in kernel module
is always partial; but if self-contained BTF on kernel module is introduced
this will no longer be the case.

Not sure if it'd be a issue in practice though, as we could go through the
type info and see whether there's any type ID that is too large and cannot
be found.


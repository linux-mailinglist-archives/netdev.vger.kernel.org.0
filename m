Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2C14B6B54
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbiBOLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:43:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbiBOLnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:43:10 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DC0193EC
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 03:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644925375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWSMSpThMMsnc5CKRdNKLsT95ScEXii0mOIJViy6EfI=;
        b=dU+Ca1JKpUVHhxzWfttEmqt4YGqkqQm/EmaVFJHzQglXMRf+gDg1ivSnbFUcUpWcS6AZTr
        bFd6g8p76tw3IrPiTNaHx4cGq+dgpOcSwlnNIiL3ZTuTlTEDQ+0Fw0x2IS4Yn3f/lWSaK1
        xa359BKgHetPPLfIRGO6EwVZwJAUzdM=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2050.outbound.protection.outlook.com [104.47.2.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-8-cgnYSVxQPFG5ulX7lYCLzw-1; Tue, 15 Feb 2022 12:42:55 +0100
X-MC-Unique: cgnYSVxQPFG5ulX7lYCLzw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apljvutYTGZItu3HTyOuzGzLVDBmyNG7Wnu2MRrAE3PDZMSDGGmOsB2fFVw4FEjxysW0FCWcfb9fON+/acBRUuIgrVYJv1IS+QafvcPtwybDYtiGU5+2jTduQpZEnbcA/hy+OVMK1UC2za41DdfE5l7073QS8uDYIk+VFlKA4O6H3ockmrqrTCvvqFdmM2Ocmidwjf+exgrgmK7fG17DYw136KeGyhyLqtS7Jy2paLyYvKe7612q6SeHpb/IPGJTpwTSKr4Ru0FxA7jLi/DtxT5cxxQEeJjOuCHVSVmpQ4wkdg2yZNo6ewSX12CNY+fBwzRhFtPOvAKCYjARN+s5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vb58MvneEAgEWyFzzDb6S8nSEbrG9vUy+SnWjPSwb2o=;
 b=fENvYa+f8OAdkN6A/0IbCqdcgvAV56YFa16mnYyFaY/fAPmijK8WkYYIAphJJQkYdz9PC9jLo95TpArPtozDdn6dBY4Pv7ZbuJ6tU9q5q+99raAa2CorhKLH5gy3f+41dJUUiNrTkMQpHd09cSGxpQ6BwxpdAciGDdQWBDBXVOxlcOmVYKSJpt1mEL22Tv4YpcuL0fLRgLFlxv3oTpx5DXHG0+jTB+r9c+g0FivULD7kQqEtV1Vf8/HfchLe9bvzn2c1eYjClRpXPe8ZYFdaSLwxjHuWGheOybzdg6W6qoBXBp5GZzu+txiND/7ggEKuqzOmSfCU4HzmRDBBRd17YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by DB7PR04MB5193.eurprd04.prod.outlook.com (2603:10a6:10:15::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 11:42:53 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f%7]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 11:42:53 +0000
Date:   Wed, 16 Feb 2022 03:38:31 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>,
        Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BTF compatibility issue across builds
Message-ID: <YgwBN8WeJvZ597/j@syu-laptop>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
 <YgdIWvNsc0254yiv@syu-laptop.lan>
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com>
X-ClientProxiedBy: AM6PR08CA0010.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::22) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23cf3fa5-953c-4c2a-641d-08d9f0784ca7
X-MS-TrafficTypeDiagnostic: DB7PR04MB5193:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB51930018299D5966B994607CBF349@DB7PR04MB5193.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aDP2ZgFzO1XchWLyhLpo9Y/Sw7CqjEMVeXc0ag/167VCP0HR6/+LantMp3mjsieAjJt4JBefxB7PLKKNJKye09yIHVj92AlbK4iuQR0lII2kSRq9GiYrcf9c2jjKFiBPmtCRL7fKd2brEI36GqtD/2wxt41NuHe6Gx98yXKrkjy0eGdnuJ6Y4x9/spOfFf1WSHrRLh8WPGy6wJDy9sSF4j3tuI71LQ+5Dq0zgRxEhCtePisliYkcVgZFE9YuIMy0kfS25+DmLXUD/mBH/R4iMTMghiwuxAHDG5sURdUNSE1QBw5Lij8loD9k6PmKeJZwBXGifR6ekOnUcUf7E1yPYRBHOQUs6MrV5cR3F9wKxtJgg4eaKZ9lpPMGdDKtv2FrTEIWBBVC2gVS73HdEKcfwArGipJS8y4Y4zt13dSFDSpc+3Z0VUhHRBWoe8RrRrc2ljaZ0/STHjAWyrN7hORNOplFZ2pK1/78jjnHOgRPKszRWMkAmtFq2VM2FrwzeDpxTnwQiCUfV3qBQS4MhydNpZwE98JdJa1AnHv88IXYfZuQz7qVbywXQkVPvbKXfore5T3iy8FZy9mi1a3rMa8n8D4qTiWmy827LVNRtx+igI8IuJ4Em8cxtDUBtwtwd3UNdtjngckNjRRXhXMGL+hs+0hOIKLkhJRkjygOUqCUp7mcVFPeW247II94CI4eCs82AwFwuvMj3Im/ntyriCqsL+xIGlWwaz7KF7qCgsx1280=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(54906003)(8676002)(6916009)(6506007)(9686003)(6512007)(6666004)(53546011)(8936002)(5660300002)(966005)(6486002)(4326008)(508600001)(26005)(66946007)(186003)(33716001)(83380400001)(66574015)(66476007)(316002)(86362001)(66556008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UEobK52QEk/ABu2v+bvG0Lr75VKXwXHS52zpA3CeRtaaLtDiLrVoM63pYjoE?=
 =?us-ascii?Q?tZ9FrZf+kB7IoIulTxkxYedxQu6EjaVcc0uVj5JDRzhiU83IRvc4G6URsd4n?=
 =?us-ascii?Q?QSyw4m76N+MqTjeF2f4HLkUhOf0I9z7oqj+Jihzd843e5WL4fCQUOidIKwDO?=
 =?us-ascii?Q?UdI9ysz3SR8cwtkoJiREppI8DG74u8B0RvffzrbTK5VG9aB+7qj/1Enl3VNL?=
 =?us-ascii?Q?vUEPN6y4Vg0rDB5zSNgJhLUFPIyhEdW0/9t4+3oZE3ncLfA/EsJSViVpEWCq?=
 =?us-ascii?Q?GCMdosCxJhsB2NshQkv4F2umBra8lIn8e5w+u8jVC27uVapg9QvVyp19t/3C?=
 =?us-ascii?Q?KLZsO38UWwBh1ib6y3Jx4RJRjE6n+D0+HCzgCIRxVEQnvnf2UgGjqPCfJnLA?=
 =?us-ascii?Q?JauRYpYccdZSOBfhVen8W6T4lhwLeCqj1GctCZwSWlX01KdE4KW/xaukvwaw?=
 =?us-ascii?Q?3gkzIv9vfnbt6QF9AKStbGHrXSDMSWD0MR43oPJNpxA71KUm27hfFMtnGyOk?=
 =?us-ascii?Q?JncexmJErAuyFIHwlWqGne2UuzfHnLqwZT6Gh4Exd80eIMfzvnjCUP6vumeO?=
 =?us-ascii?Q?WndkD0J4JRTh7bocgT2UjpK4PiUxSH8Q2nK8Gfqz4cjBOYZuphFC9TUrQ6Pw?=
 =?us-ascii?Q?GKAPKh4iWS71t2PoINoCGWV2lf4J+5ETDcTLIS3IskGAV4UNwrTP9SNVlyj4?=
 =?us-ascii?Q?RPuRN5LXdyzbHlFwmVsooMAogH74NXKYXmgulDmd1kqVEqJ/tiFOSeGhNkuJ?=
 =?us-ascii?Q?gp3oOtHwWD45Z8barZuBsPxT4OBnhEi6Q3Jc/vmHqnTcjqy5AaU0dIgnWyhp?=
 =?us-ascii?Q?E6YXaA6iy2FN/v0p1g9HmIjOCsug9HUoJ7TA902nxNmvoiWCTVNc4kqNBh6Z?=
 =?us-ascii?Q?opDbncz6fB0qzBKhytFLwMBLxUfASw0aF/aLPsNJx8UDrCfFGrlqULeB2wae?=
 =?us-ascii?Q?N6h8U5Anje1hMhvXCm8YZJ4BDns29iNv7w6e22RFKpNIovYycVdkLjAerhlf?=
 =?us-ascii?Q?dowom8mqdTIszuLw+v7PgsBKVfVm3ANRtDx4sryDQVriOsXbhfO/+jWB0ouj?=
 =?us-ascii?Q?8i2jLdZI21zQzTYUI/On9zwxSh6Kf+8v5YSUqeohEXfIyyxJNBBAyz1wsdvO?=
 =?us-ascii?Q?zp95hoMeVkocjxxZi0/Nci36fH/QaV4x/rYSLekBvm68IExoPJpsZF6PC8db?=
 =?us-ascii?Q?JT8q4iRmMDkA4zTFC+snSp8kgVuM7D1PwRIQWie+a+gzeNYgNVoai8tBcuMV?=
 =?us-ascii?Q?EXpKrROKTWvfgTeMjz4dQRJ/+Lxn3SQPqDsZSWos4kUxXzBxnkTu/rXzgYp/?=
 =?us-ascii?Q?21C7pB3pSu6FENZDmyX0WJFjNbUyPG5C2nl2dpd6KrqKvdLTYpkafqitmleC?=
 =?us-ascii?Q?6wmzln6jN7e2OqJreKcx/9BSAoTFjmclF/xIXJF3qfrL7Dczt1sV0Pgx9ixK?=
 =?us-ascii?Q?fJBD2IDfnuUX3xbRqUfLTCa53hhP5PiDY/BhQCV/cUH8lUWVAqqw2Z1MftXB?=
 =?us-ascii?Q?pvgfKJ6e2CrpelNOFHs5DofLhGL8q5MLyvAtRQXjnJU7Fo9yZx2f0B26Dqjo?=
 =?us-ascii?Q?8EDVAHV49RrLGwlUEHFKjgYInApMBOvVgzEKqtjoPvFrWzCNzSat9GoPYBHC?=
 =?us-ascii?Q?QSfyM2Vek5ldJIEzL6cJPDI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cf3fa5-953c-4c2a-641d-08d9f0784ca7
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 11:42:53.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmvNledCuJe9uyIsAoSsTgLUGWGikBr2+vsa2x+oxxKt14QvVGSLrWtc/tLDsnaQIjMLMvzqOygA0xbXQofl1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5193
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 10:36:28PM -0800, Yonghong Song wrote:
> On 2/11/22 9:40 PM, Shung-Hsi Yu wrote:
> > On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
> > > On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
> > > > On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > On 2/10/22 2:01 AM, Michal Such=C3=A1nek wrote:
> > > > > > On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> > > > > > > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> > > > > > > > Hi,
> > > > > > > >=20
> > > > > > > > We recently run into module load failure related to split B=
TF on openSUSE
> > > > > > > > Tumbleweed[1], which I believe is something that may also h=
appen on other
> > > > > > > > rolling distros.
> > > > > > > >=20
> > > > > > > > The error looks like the follow (though failure is not limi=
ted to ipheth)
> > > > > > > >=20
> > > > > > > >         BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BP=
F:Invalid name BPF:
> > > > > > > >=20
> > > > > > > >         failed to validate module [ipheth] BTF: -22
> > > > > > > >=20
> > > > > > > > The error comes down to trying to load BTF of *kernel modul=
es from a
> > > > > > > > different build* than the runtime kernel (but the source is=
 the same), where
> > > > > > > > the base BTF of the two build is different.
> > > > > > > >=20
> > > > > > > > While it may be too far stretched to call this a bug, solvi=
ng this might
> > > > > > > > make BTF adoption easier. I'd natively think that we could =
further split
> > > > > > > > base BTF into two part to avoid this issue, where .BTF only=
 contain exported
> > > > > > > > types, and the other (still residing in vmlinux) holds the =
unexported types.
> > > > > > >=20
> > > > > > > What is the exported types? The types used by export symbols?
> > > > > > > This for sure will increase btf handling complexity.
> > > > > >=20
> > > > > > And it will not actually help.
> > > > > >=20
> > > > > > We have modversion ABI which checks the checksum of the symbols=
 that the
> > > > > > module imports and fails the load if the checksum for these sym=
bols does
> > > > > > not match. It's not concerned with symbols not exported, it's n=
ot
> > > > > > concerned with symbols not used by the module. This is somethin=
g that is
> > > > > > sustainable across kernel rebuilds with minor fixes/features an=
d what
> > > > > > distributions watch for.
> > > > > >=20
> > > > > > Now with BTF the situation is vastly different. There are at le=
ast three
> > > > > > bugs:
> > > > > >=20
> > > > > >     - The BTF check is global for all symbols, not for the symb=
ols the
> > > > > >       module uses. This is not sustainable. Given the BTF is su=
pposed to
> > > > > >       allow linking BPF programs that were built in completely =
different
> > > > > >       environment with the kernel it is completely within the s=
cope of BTF
> > > > > >       to solve this problem, it's just neglected.
> > > > > >     - It is possible to load modules with no BTF but not module=
s with
> > > > > >       non-matching BTF. Surely the non-matching BTF could be di=
scarded.
> > > > > >     - BTF is part of vermagic. This is completely pointless sin=
ce modules
> > > > > >       without BTF can be loaded on BTF kernel. Surely it would =
not be too
> > > > > >       difficult to do the reverse as well. Given BTF must pass =
extra check
> > > > > >       to be used having it in vermagic is just useless moise.
> > > > > >=20
> > > > > > > > Does that sound like something reasonable to work on?
> > > > > > > >=20
> > > > > > > >=20
> > > > > > > > ## Root case (in case anyone is interested in a verbose ver=
sion)
> > > > > > > >=20
> > > > > > > > On openSUSE Tumbleweed there can be several builds of the s=
ame source. Since
> > > > > > > > the source is the same, the binaries are simply replaced wh=
en a package with
> > > > > > > > a larger build number is installed during upgrade.
> > > > > > > >=20
> > > > > > > > In our case, a rebuild is triggered[2], and resulted in cha=
nges in base BTF.
> > > > > > > > More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_che=
ck_pec(u8 cpec,
> > > > > > > > struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_=
hashinfo *h,
> > > > > > > > struct sock *sk) was added to the base BTF of 5.15.12-1.3. =
Those functions
> > > > > > > > are previously missing in base BTF of 5.15.12-1.1.
> > > > > > >=20
> > > > > > > As stated in [2] below, I think we should understand why rebu=
ild is
> > > > > > > triggered. If the rebuild for vmlinux is triggered, why the m=
odules cannot
> > > > > > > be rebuild at the same time?
> > > > > >=20
> > > > > > They do get rebuilt. However, if you are running the kernel and=
 install
> > > > > > the update you get the new modules with the old kernel. If the =
install
> > > > > > script fails to copy the kernel to your EFI partition based on =
the fact
> > > > > > a kernel with the same filename is alreasy there you get the sa=
me.
> > > > > >=20
> > > > > > If you have 'stable' distribution adding new symbols is normal =
and it
> > > > > > does not break module loading without BTF but it breaks BTF.
> > > > >=20
> > > > > Okay, I see. One possible solution is that if kernel module btf
> > > > > does not match vmlinux btf, the kernel module btf will be ignored
> > > > > with a dmesg warning but kernel module load will proceed as norma=
l.
> > > > > I think this might be also useful for bpf lskel kernel modules as
> > > > > well which tries to be portable (with CO-RE) for different kernel=
s.
> > > >=20
> > > > That sounds like #2 that Michal is proposing:
> > > > "It is possible to load modules with no BTF but not modules with
> > > >    non-matching BTF. Surely the non-matching BTF could be discarded=
."
> >=20
> > Since we're talking about matching check, I'd like bring up another iss=
ue.
> >=20
> > AFAICT with current form of BTF, checking whether BTF on kernel module
> > matches cannot be made entirely robust without a new version of btf_hea=
der
> > that contain info about the base BTF.
>=20
> The base BTF is always the one associated with running kernel and typical=
ly
> the BTF is under /sys/kernel/btf/vmlinux. Did I miss
> anything here?
>=20
> > As effective as the checks are in this case, by detecting a type name b=
eing
> > an empty string and thus conclude it's non-matching, with some (bad) lu=
ck a
> > non-matching BTF could pass these checks a gets loaded.
>=20
> Could you be a little bit more specific about the 'bad luck' a
> non-matching BTF could get loaded? An example will be great.

Let me try take a jab at it. Say here's a hypothetical BTF for a kernel
module which only type information for `struct something *`:

  [5] PTR '(anon)' type_id=3D4

Which is built upon the follow base BTF:

  [1] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=3D(=
none)
  [2] PTR '(anon)' type_id=3D3
  [3] STRUCT 'list_head' size=3D16 vlen=3D2
        'next' type_id=3D2 bits_offset=3D0
        'prev' type_id=3D2 bits_offset=3D64
  [4] STRUCT 'something' size=3D2 vlen=3D2
        'locked' type_id=3D1 bits_offset=3D0
        'pending' type_id=3D1 bits_offset=3D8

Due to the situation mentioned in the beginning of the thread, the *runtime=
*
kernel have a different base BTF, in this case type IDs are offset by 1 due
to an additional typedef entry:

  [1] TYPEDEF 'u8' type_id=3D1
  [2] INT 'unsigned char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=3D(=
none)
  [3] PTR '(anon)' type_id=3D3
  [4] STRUCT 'list_head' size=3D16 vlen=3D2
        'next' type_id=3D2 bits_offset=3D0
        'prev' type_id=3D2 bits_offset=3D64
  [5] STRUCT 'something' size=3D2 vlen=3D2
        'locked' type_id=3D1 bits_offset=3D0
        'pending' type_id=3D1 bits_offset=3D8

Then when loading the BTF on kernel module on the runtime, the kernel will
mistakenly interprets "PTR '(anon)' type_id=3D4" as `struct list_head *`
rather than `struct something *`.

Does this should possible? (at least theoretically)

> > > > That's probably the simplest way forward.
> > > >=20
> > > > The patch
> > > > https://patchwork.kernel.org/project/netdevbpf/patch/20220209052141=
.140063-1-connoro@google.com/
> > > > shouldn't be necessary too.
> > >=20
> > > Right the patch tried to address this issue and if we allow
> > > non-matching BTF is ignored and then treaking DEBUG_INFO_BTF_MODULES
> > > is not necessary.
> >=20
> > Not being able to load kernel module with non-matching BTF and the abse=
nce
> > of robust matching check are the two reasons that lead us to the same p=
ath
> > of disabling DEBUG_INFO_BTF_MODULES a while back.
> >=20
> > Ignoring non-matching BTF will solve the former, but not the latter, so=
 I'd
> > hope that the above patch get's taken (though I'm obviously biased).


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1A64B333F
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 06:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiBLFlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 00:41:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiBLFlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 00:41:10 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F51628E22
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 21:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644644462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vchQE0Ycyv2YHSNOD3dYdbW2cOuI/gR+igNk6+PfJN0=;
        b=lPWSq7mhFmxI5xXN1NdU1mcfBR/uon1Ftf/pKE/wAdKaCRq8HeM/OblR/YIRaItOsr2LYi
        JzpPcR3Ru5WXdLn1ZUZEOSt3gxINFVW+X9WFix8f/ZY2UQJeygNklMGywNUacjPBe1cjvv
        EqgFvEW6sd3n/jxq57xSyzL2E9iyY9Q=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-19-3zI_HqDaP7SdIVM-jky1fg-1; Sat, 12 Feb 2022 06:41:01 +0100
X-MC-Unique: 3zI_HqDaP7SdIVM-jky1fg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QH9ZhKs560agcNv0iJenOuufCJ855I7/GUBSfeXL+AHcf1LOFnzZVX64BRriySdg5ToV8MGKVxLd8WTL5Go2Ud/NzNtRe8wlzZ+aiFGvrXhlq0GvLPP19xGWpX1V4NM/ZQvh5DZdI92lhPvqJM2yuCN+DUWJJyfIkO80XdOOZmD62fs0TKhYKvXiu4XdJGxmklHYiY8V/ZKs4vVaQoHqgOmPWzS/qKRxIXpDYJwTdQD81lQ4eW0GtWOOSsDjwhw9nEb+e8GzIOZSMDv8QOHT3JxaKeWcUdFh/1MjnyrNkZFFNRlRX8kEZs5yFj/4pZQVE1CCJRHqYqhe9hTK0zS7JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M77suZZy9RzXLd6qvBRtY1G56iFjrpp2cytMdop8ycE=;
 b=L2ieyArjJfDyHBM8G1GdfUxQAyLbp3xB9w793qzQ2uN/negYH0+6UWG0QBqp9KAUFsEXazlsWWJBHwZLSG/z6luCPYbtWpfGBKqB/KgTdwvlsbsn/THKzsWbawOdzDMltncQNZs19n40mKRTXHMsOgFfbLU7mUjXxvKnyeigDwaq1LnQzCep/ERhADNXmpUnGllTMdcQ2O5NgxxzwokkK3PdzAwTsC/WM/RXb67BReSeKbOhSRLWKXYgD++epvti+KKGI/kEHwlJja448iSOj8gcsAsOE0pPSS4WSMKPCxn0gbPXMQzGePEUKM/mT7AMv8TTYMcFEC7UjAkTl4ycDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by DBAPR04MB7367.eurprd04.prod.outlook.com (2603:10a6:10:1aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sat, 12 Feb
 2022 05:40:58 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f%8]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 05:40:58 +0000
Date:   Sat, 12 Feb 2022 13:40:42 +0800
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
Message-ID: <YgdIWvNsc0254yiv@syu-laptop.lan>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
X-ClientProxiedBy: HK0PR01CA0050.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::14) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dff7fcb8-f826-4c3a-5eb8-08d9edea3ea4
X-MS-TrafficTypeDiagnostic: DBAPR04MB7367:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB7367A5EB4F882A1A56805538BF319@DBAPR04MB7367.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KFNrcMPOU9dKCNa+KuppM9nkls+ndOZYTrEnHZ2QkpaH6rD7OSZUnhkavp2IiUXzJykud5Tadw5ymZpOwHsIGi+uevLrNoWzPbrVS4n6BYD9MWKwKmUdRhPs2swFM//+9+2phq7MyGDSzgVMvVRfX6VMaenS5bmDkoOLnOSqojdyLKxmAqj6gtWCchcCI6QoZRh7tRA2zE+JYGavXUll8EuCX1FcJbIpQh//31TpEzk+wTzyMLndSBMNDlYNEIXX02S74/K+X+uV9tJYjFg9+J9VHI2PDL3A09x1d3ZmUaF/X0ilkog3xDcsjVNi5+QVMjcFkVt6goYRhADS9FvvAdAX4DaIhhX72fG4T8pPIRxmL7PpOPZ535ZlZgTTD55pqzo+9HTIuz+InWlJIys0FQOelFwhT6SfZyzOZazxcxO68Pii49Ttlx/dmwggfvkhmqoFvd3it6IfhCvsShfCrfvBf59ninCpo+ktV7mS0B/xEZNg385RY47b6ukvX4vR5dLzUm1joGns1cLeM2vgTb1VpK0O3Agq+7MunEMT7k8YrlqMMjQCTSx9rhYAgBCUcgIOzlWdaa6U4T6B9C2Nol0yLyYd9uYV3144ZSN+lvBnAe5cte/w2Y2ONWe19sQW2vrVOzDxEbt9BWRsNasvNXx1ob/+TdnVx8HQMwX/Zpk+EIS83hUjVi9EWIYNpTYfdw7ptswhdrJt4wy/TMZYbd7RlxPRLA1rvPFV3WUKPQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(6512007)(83380400001)(186003)(26005)(66574015)(2906002)(5660300002)(66946007)(6486002)(8676002)(4326008)(508600001)(86362001)(966005)(66476007)(66556008)(316002)(54906003)(6916009)(6506007)(53546011)(8936002)(6666004)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qe1JRwrk7ozXmMDbe8RS0TUMmxXEo7wWQScqhrfouuB0YdgdMONnmzKiCuYp?=
 =?us-ascii?Q?Kk3IaWO8laCINT76WzHAQ/XvwfEdkYyBNxCeWly0PYAfJ668W1RVhnawsyQ6?=
 =?us-ascii?Q?jrlyDGd0qoTpJjZpeF8JKjG8y1jMsVTAceWI0dAjuvIXXra8otzmokR61vPe?=
 =?us-ascii?Q?O/8GFPtnHGTCoREDK/pSpjDw0ayFkqFB1I2GmaE7No1zi2ZnecC+ku89rlnN?=
 =?us-ascii?Q?pff+j1x61eTkGGfORmfiC69Girq1rGllTjE1gr2lf48cMLYHBaOmPEiVWuja?=
 =?us-ascii?Q?WK8qimHrFfYVmj/vuYg6uOnrUt/3o+erAz4fT4Rx6iSRtYl8VNjit4136FYv?=
 =?us-ascii?Q?Hs0K4B6Z77lITcNS+v0fLXl5BNTkMXyiV9Zh4FHUn9k6YO4+NmkdcIiylHTD?=
 =?us-ascii?Q?3U0GjAiXs/NelALJxMFU8Gryy3El7FT2GhCiR1FeMfGtTjcQIDKxn6pN+9+t?=
 =?us-ascii?Q?peYBzuoBqEMOBRBUrq8O3GtcMZVfnaXyui8+zwnB2ZojzoW3UmKfRQT0QXtx?=
 =?us-ascii?Q?i9IFT2B+NV2mT/mPH43LhPAIeTGs88BOt6L9gYYKSywfQGvTyRp9YpwbeFEw?=
 =?us-ascii?Q?n8B+zTJ+xvqeHZPBJ5BnsoM3Y1v8HuoG+8Nyjag8Z3mftA5VBvy0Hci8ZL0V?=
 =?us-ascii?Q?W7yU6b62JDH1/VvPdXHHNyp2pYqkR0EBaG/RUQGqFIVjttzhbtUkjpIUvsE8?=
 =?us-ascii?Q?1NQURliyxrnCDU8oHHoUQgCAHRX9ez/StPtW0b0MVWHY/9IiQ2y71s1DtGGY?=
 =?us-ascii?Q?jHfme6W8iB8mWvgtQFyxCzaMC9mV9Vbuv/lnBxcb9Sda9x1qS4NE6CEozC59?=
 =?us-ascii?Q?SKKtiElsfzUn6Q+8EGiDD29qxjtaWyehDRzHMz6BAG4QkZ2FZOqCAyFyM3UL?=
 =?us-ascii?Q?vVaXcm2coFqf56YIdJ7bKQJYUoD8U5YoWjLGq28AqqHOmd3JNXMMpkf/N/ua?=
 =?us-ascii?Q?ptrRqoEYMkclKpVvC/aeFTwzZUkfuRaWijCNhhRCp8LrCkoRWEop/bs9QeV3?=
 =?us-ascii?Q?HIbakLv/DUXy06sa//TSZXwlljZQh4EEAmjYbIF452lf3VlmoKLoV2OG/R8X?=
 =?us-ascii?Q?cUYhsL1N4b43E/wtNVzFSvmk1mu9Z4JBw5PsUbGWyTt8OB85y3NyzUaSzxVy?=
 =?us-ascii?Q?JPniPu0srjyzGaRXoM/sgMDC9x9AdOeEmckLd+CzvCifG9vFKIVB5XIsC0hP?=
 =?us-ascii?Q?yBOZfpS8fRJGu5+GH7S+1TiujHIx1I/vNKmWTRVPo0VqqbZwD6489/fyHyr3?=
 =?us-ascii?Q?P8/gW1TBU3wp6GVvcHx2kd1cWatM2eK8k2PNyBBgRZRKap4ClWVDgKxz6a6B?=
 =?us-ascii?Q?0jibY9gHkmGiyw2nFZLBxBr+mHqnERZIrgx76N16O51LX3VawGE+IqWdWe03?=
 =?us-ascii?Q?A+eS22fu7QYpGhgCBQ14c+PUoKtmbhGEqGjnVISsCVbIUHl1Wtz6y3PlbiWY?=
 =?us-ascii?Q?+oyqgvy2IIRFvPfiLgfeOWFcMNJtpJQvxEDe4LNKU2l7OhbJ/TJXCKpSrKfA?=
 =?us-ascii?Q?2WQ98N31+okAg5v6ym8KYIOsnKkQ4Ma6nfELxu3xGBXyj92SUhJbc46Ex93G?=
 =?us-ascii?Q?9tZqKhB+OQ88rFl/Sh5ZkJzDw55/sjkU806FpAdCCZXgsu0VjWpBcaL/8m3v?=
 =?us-ascii?Q?ZEMC6mi1tfWOmchuY1BDFkc=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff7fcb8-f826-4c3a-5eb8-08d9edea3ea4
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 05:40:58.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 413ejXwQQXzcr4Z9H9lt267gQkVvOOCwLEC2i4LZhwDN+D4ceorwJh7lTv8c1uuNqav4dGl6U2WCLuRiMfCdrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7367
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 02:59:03PM -0800, Yonghong Song wrote:
> On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
> > On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
> > > On 2/10/22 2:01 AM, Michal Such=C3=A1nek wrote:
> > > > Hello,
> > > >=20
> > > > On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
> > > > >=20
> > > > >=20
> > > > > On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> > > > > > Hi,
> > > > > >=20
> > > > > > We recently run into module load failure related to split BTF o=
n openSUSE
> > > > > > Tumbleweed[1], which I believe is something that may also happe=
n on other
> > > > > > rolling distros.
> > > > > >=20
> > > > > > The error looks like the follow (though failure is not limited =
to ipheth)
> > > > > >=20
> > > > > >        BPF:[103111] STRUCT BPF:size=3D152 vlen=3D2 BPF: BPF:Inv=
alid name BPF:
> > > > > >=20
> > > > > >        failed to validate module [ipheth] BTF: -22
> > > > > >=20
> > > > > > The error comes down to trying to load BTF of *kernel modules f=
rom a
> > > > > > different build* than the runtime kernel (but the source is the=
 same), where
> > > > > > the base BTF of the two build is different.
> > > > > >=20
> > > > > > While it may be too far stretched to call this a bug, solving t=
his might
> > > > > > make BTF adoption easier. I'd natively think that we could furt=
her split
> > > > > > base BTF into two part to avoid this issue, where .BTF only con=
tain exported
> > > > > > types, and the other (still residing in vmlinux) holds the unex=
ported types.
> > > > >=20
> > > > > What is the exported types? The types used by export symbols?
> > > > > This for sure will increase btf handling complexity.
> > > >=20
> > > > And it will not actually help.
> > > >=20
> > > > We have modversion ABI which checks the checksum of the symbols tha=
t the
> > > > module imports and fails the load if the checksum for these symbols=
 does
> > > > not match. It's not concerned with symbols not exported, it's not
> > > > concerned with symbols not used by the module. This is something th=
at is
> > > > sustainable across kernel rebuilds with minor fixes/features and wh=
at
> > > > distributions watch for.
> > > >=20
> > > > Now with BTF the situation is vastly different. There are at least =
three
> > > > bugs:
> > > >=20
> > > >    - The BTF check is global for all symbols, not for the symbols t=
he
> > > >      module uses. This is not sustainable. Given the BTF is suppose=
d to
> > > >      allow linking BPF programs that were built in completely diffe=
rent
> > > >      environment with the kernel it is completely within the scope =
of BTF
> > > >      to solve this problem, it's just neglected.
> > > >    - It is possible to load modules with no BTF but not modules wit=
h
> > > >      non-matching BTF. Surely the non-matching BTF could be discard=
ed.
> > > >    - BTF is part of vermagic. This is completely pointless since mo=
dules
> > > >      without BTF can be loaded on BTF kernel. Surely it would not b=
e too
> > > >      difficult to do the reverse as well. Given BTF must pass extra=
 check
> > > >      to be used having it in vermagic is just useless moise.
> > > >=20
> > > > > > Does that sound like something reasonable to work on?
> > > > > >=20
> > > > > >=20
> > > > > > ## Root case (in case anyone is interested in a verbose version=
)
> > > > > >=20
> > > > > > On openSUSE Tumbleweed there can be several builds of the same =
source. Since
> > > > > > the source is the same, the binaries are simply replaced when a=
 package with
> > > > > > a larger build number is installed during upgrade.
> > > > > >=20
> > > > > > In our case, a rebuild is triggered[2], and resulted in changes=
 in base BTF.
> > > > > > More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_p=
ec(u8 cpec,
> > > > > > struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hash=
info *h,
> > > > > > struct sock *sk) was added to the base BTF of 5.15.12-1.3. Thos=
e functions
> > > > > > are previously missing in base BTF of 5.15.12-1.1.
> > > > >=20
> > > > > As stated in [2] below, I think we should understand why rebuild =
is
> > > > > triggered. If the rebuild for vmlinux is triggered, why the modul=
es cannot
> > > > > be rebuild at the same time?
> > > >=20
> > > > They do get rebuilt. However, if you are running the kernel and ins=
tall
> > > > the update you get the new modules with the old kernel. If the inst=
all
> > > > script fails to copy the kernel to your EFI partition based on the =
fact
> > > > a kernel with the same filename is alreasy there you get the same.
> > > >=20
> > > > If you have 'stable' distribution adding new symbols is normal and =
it
> > > > does not break module loading without BTF but it breaks BTF.
> > >=20
> > > Okay, I see. One possible solution is that if kernel module btf
> > > does not match vmlinux btf, the kernel module btf will be ignored
> > > with a dmesg warning but kernel module load will proceed as normal.
> > > I think this might be also useful for bpf lskel kernel modules as
> > > well which tries to be portable (with CO-RE) for different kernels.
> >=20
> > That sounds like #2 that Michal is proposing:
> > "It is possible to load modules with no BTF but not modules with
> >   non-matching BTF. Surely the non-matching BTF could be discarded."

Since we're talking about matching check, I'd like bring up another issue.

AFAICT with current form of BTF, checking whether BTF on kernel module
matches cannot be made entirely robust without a new version of btf_header
that contain info about the base BTF.

As effective as the checks are in this case, by detecting a type name being
an empty string and thus conclude it's non-matching, with some (bad) luck a
non-matching BTF could pass these checks a gets loaded.

> > That's probably the simplest way forward.
> >=20
> > The patch
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220209052141.140=
063-1-connoro@google.com/
> > shouldn't be necessary too.
>=20
> Right the patch tried to address this issue and if we allow
> non-matching BTF is ignored and then treaking DEBUG_INFO_BTF_MODULES
> is not necessary.

Not being able to load kernel module with non-matching BTF and the absence
of robust matching check are the two reasons that lead us to the same path
of disabling DEBUG_INFO_BTF_MODULES a while back.

Ignoring non-matching BTF will solve the former, but not the latter, so I'd
hope that the above patch get's taken (though I'm obviously biased).


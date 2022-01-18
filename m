Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4D44930C7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349968AbiARWbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349966AbiARWbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:31:34 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724DFC061574;
        Tue, 18 Jan 2022 14:31:34 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id f13so334723plg.0;
        Tue, 18 Jan 2022 14:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LPZczM+c8hz21Ds4jQd5qcTfxmSj3ZOe2cuwWPUBMMA=;
        b=KaNP4or8BCGe6kiX0PdoxkYmCksO4bl10XTCn6Pdy9kleuyOc+8Gh+fmM60JJMSf+a
         WhQz0ktVMbdTJdC3fgFobFIfqQNr/MPo48bhUm0rOvWuYzWTL3+arSQEVRXAwyjrB8Vy
         i10SQCeug2aUYzaRP6vGmKyouT6UtUKgGJiU87DBxxx9k/3fMgr/bdOhReWr1OaVt+e6
         NqML5cHZEjLR5k0hWznFYRPfd8/gfjermyKOUKvMIJHpeBRxBsDgSoiVwSGmgTflbWJw
         xKTZ2b5s0Zch0EX1HTtUEnxDlY+lbJQNo16VfOsXD5kzEz1zzX/WqiDVzQbZj7yCCyOQ
         GRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LPZczM+c8hz21Ds4jQd5qcTfxmSj3ZOe2cuwWPUBMMA=;
        b=MGXLo2oPwXobmWnwCgqFJ+5f8cQuBM7Sj0rp6yYmj0limUB+awsQr1NVIO3CCWP8kU
         dqYPYmzignBIb+qnERg63DtXjhPlOhvUd7NNw63qM4+oku0Hb7LdRY1yqaNcrA5qvYnu
         KgAjUbVQRLOBStrLHTxLxMylLaPEJYYYM/+qzHpSxEHfzLOpkhW+GhRhoXq/juKAUauz
         hRTLzfM2hmue4idI9heWScBT6ElsP3fXLCPA+KeP+w7Q6LsCQYfeHBhW9+fEC5xHU7Ke
         LaPI6zD0+++PZemCUyRB0qVtZdyoEGf1GzghLGFUfgBmRWCC+8SsAwqSDd4ZPuMEsVdR
         +1AQ==
X-Gm-Message-State: AOAM531/SAmjVLPechOR9siQDwja/xwCjiTalJ9WPBOpscQnP9Q1FzBM
        x0B1GcfA2eqyGmWu6veo6YEnjyZJ4a4HH3RH5dc=
X-Google-Smtp-Source: ABdhPJzpSmIVlGbPf61xC/QN0FuHMq9c8kK3MIWd2YeWcqJ1IfqVspZUlvnHGyvYMO0j9Nr1Fpugtwd69E37cH9nuGU=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr28558580plk.126.1642545093945; Tue, 18
 Jan 2022 14:31:33 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
 <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
 <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CAADnVQJc=qgz47S1OuUBmX5Rb_opZUCADKqzqGnBruxtJONO7Q@mail.gmail.com>
 <CANP3RGfJ2G8P40hN2F=PGDYUc3pm84=SNppHp_J0V+YiDkLM_A@mail.gmail.com>
 <CAADnVQ+5YbkVOHqVGgusGYYYc0sB0uLKNJC+JKZu5Hs07=dgvw@mail.gmail.com> <BYAPR02MB523881040F40526ED9795993AA589@BYAPR02MB5238.namprd02.prod.outlook.com>
In-Reply-To: <BYAPR02MB523881040F40526ED9795993AA589@BYAPR02MB5238.namprd02.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jan 2022 14:31:22 -0800
Message-ID: <CAADnVQKHacT7gb1CMW8z_+SR-a8ZoS8ze=L-u9bh5-QZzXju7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     Tyler Wear <twear@quicinc.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 2:23 PM Tyler Wear <twear@quicinc.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Sent: Tuesday, January 18, 2022 12:38 PM
> > To: Maciej =C5=BBenczykowski <maze@google.com>
> > Cc: Tyler Wear (QUIC) <quic_twear@quicinc.com>; Network Development
> > <netdev@vger.kernel.org>; bpf <bpf@vger.kernel.org>; Yonghong Song
> > <yhs@fb.com>; Martin KaFai Lau <kafai@fb.com>; Toke H=C3=B8iland-J=C3=
=B8rgensen
> > <toke@redhat.com>; Daniel Borkmann <daniel@iogearbox.net>; Song Liu
> > <song@kernel.org>
> > Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for
> > BPF_PROG_TYPE_CGROUP_SKB
> >
> > WARNING: This email originated from outside of Qualcomm. Please be wary
> > of any links or attachments, and do not enable macros.
> >
> > On Fri, Jan 14, 2022 at 1:18 PM Maciej =C5=BBenczykowski <maze@google.c=
om>
> > wrote:
> > >
> > > > > > > This is wrong.
> > > > > > > CGROUP_INET_EGRESS bpf prog cannot arbitrary change packet
> > data.
> > >
> > > I agree with this sentiment, which is why the original proposal was
> > > simply to add a helper which is only capable of modifying the
> > > tos/tclass/dscp field, and not any arbitrary bytes.  (note: there
> > > already is such a helper to set the ECN congestion notification bits,
> > > so there's somewhat of a precedent)
> >
> > True. bpf_skb_ecn_set_ce() is available to cg_skb progs.
> > An arbitrary tos rewriting helper would screw it up.
>
> Patch 1 was for a ds_field helper to modify the top 6 bits of TOS, not an=
 arbitrary rewriting.
> This should suffice since it doesn't interfere with CE.

I still don't hear the answer why tc bpf is not sufficient.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B1F37AD34
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhEKRka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhEKRk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:40:29 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE0CC061574;
        Tue, 11 May 2021 10:39:18 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id l129so19563752qke.8;
        Tue, 11 May 2021 10:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBzI0fFJVl7rkeGxSkI1T6aieyqCHfIsXgSNZWy3sII=;
        b=ZMmEprcMtj68TGu/kofxqBTpQBBblASy5MxIJyZAe1O/39gvjjNl0Uvcz756irQIVR
         o2TiCjkkMaPqakbvJUAACNYKL/mU7Ycxo68reRSzMvDy1DznH+4F+RM31nUGKN6cLfR3
         Q6h4PnFhwMyDMcHLRtZz/M4MRU6XkOWwxFgM8ArOFf9AM23Br86g1Pg3xe0pd+mrfcuz
         gOifHqO2nHPBFc+6Tm2hUT/Ttv4JxCxTQLqF8ehf1rDOwO6yEEU8Iburin7o7zxtUG5K
         6Aj04Vwp1R81o+L5ullSyt4tXo0wppL+7hiYNiwCUI/VEX4IQNXOniEmUViVnO+aRhJo
         78fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBzI0fFJVl7rkeGxSkI1T6aieyqCHfIsXgSNZWy3sII=;
        b=JMyRdrmZZ+m/WHZkzBQ5HW17DS+AnV6xp9F7nqT8UH16iigUpqy+4ibKPySJKN7/QU
         WI42gT7C440QCGUCfoKXWkEUHbHekPl+wiWKZWjWiFYqhW9QBgrLIxNF/5V3a7mSMG0A
         NCbp/6rbeWCbyjTKo3bIGNFAjXui4WRwXKVL1foZjbjVVKu6XKcTn0R3WhKl68eA4LoY
         Qf1x8P079xWTg6XMFMkwFKkGt0GdbxKPfCeqB48oeeXA7qgSdLMBNMDFxR4qY7sApPvW
         dqRLuV2Ywn0piEqyK710HWl0ndor+P+Mf8KWW6sRcvBPUs1Bu9HVeGpTc5IUGb6VsP0x
         VmQA==
X-Gm-Message-State: AOAM532/FLJJDTLsxasP4v5BjQUJt1+FUXeTntkdoEQOAQxLckhaohXv
        ZPLHCCvJV0487AaEAU6QkOJXTTFoLyPEXlWr8A8=
X-Google-Smtp-Source: ABdhPJzb78m/Bx93OXl1S3XKrRFKVVrRBm8yG+xUh1UMHLfr+s9GXBuPKZBqHAEbxD/rxFj6Q+nS3YIfB1xS7riiesM=
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr26777380qkk.127.1620754757565;
 Tue, 11 May 2021 10:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com> <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com> <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
 <001801d742db$68ab8060$3a028120$@samsung.com> <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
 <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com> <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
 <007001d7431a$96281960$c2784c20$@samsung.com> <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
 <00c901d74543$57fa3620$07eea260$@samsung.com> <CA+FuTSepShKoXUJo7ELMMJ4La11J6CsZggJWsQ5MB2_uhAi+OQ@mail.gmail.com>
 <CA+FuTSeyuUvKC==Mo7L+u3PS0BQyea+EdLLYjhGFrP7FQZsbEQ@mail.gmail.com> <015101d74602$86442210$92cc6630$@samsung.com>
In-Reply-To: <015101d74602$86442210$92cc6630$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 11 May 2021 13:38:41 -0400
Message-ID: <CAF=yD-+ncxKY28h8ch8kcJmSXfqdnBrBELKFBPmfP7RzNsWoTg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 9:11 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> On Mon, May 10, 2021 at 09:46:25AM -0400, Willem de Bruijn wrote:
> > On Mon, May 10, 2021 at 9:19 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > > > That generates TCP packets with different MSS within the same stream.
> > > > >
> > > > > My suggestion remains to just not change MSS at all. But this has to
> > > > > be a new flag to avoid changing established behavior.
> > > >
> > > > I don't understand why the mss size should be kept in GSO step. Will
> > > > there be any issue with different mss?
> > >
> > > This issue has come up before and that has been the feedback from
> > > TCP experts at one point.
> > >
> > > > In general, upgrading mss make sense when 6 to 4. The new flag would be
> > > > set by user to not change mss. What happened if user does not set the
> > > > flag? I still think we should fix the issue with a general approach. Or
> > > > can we remove the skb_increase_gso_size line?
> > >
> > > Admins that insert such BPF packets should be aware of these issues.
> > > And likely be using clamping. This is a known issue.
> > >
> > > We arrived that the flag approach in bpf_skb_net_shrink. Extending
> > > that  to bpf_skb_change_proto would be consistent.
> >
> > As for more generic approach: does downgrading to non-TSO by clearing
> > gso_size work for this edge case?
>
> It can hit __skb_linearize in validate_xmit_skb and frags will be
> copied to a linear part. The linear part size can exceed the MTU of
> skb->dev unexpectedly.

When does skb_needs_linearize return true here (besides lack of
scatter-gather support, which would also preclude TSO)?

> I will make another patch with the flag approach.
>

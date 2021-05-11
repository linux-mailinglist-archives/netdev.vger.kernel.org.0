Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA19379BDE
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 03:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhEKBMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 21:12:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45860 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhEKBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 21:12:23 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210511011115epoutp033c534b800e6377688832278e78adff23~93fLL0nst2689126891epoutp03p
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:11:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210511011115epoutp033c534b800e6377688832278e78adff23~93fLL0nst2689126891epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620695475;
        bh=bmT12ajT3SxMk3jsFNMDG7Lwsl9HXMJCB/98nt4Swaw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=UfHk2Y7qJ8LlkSqnhO7w6pasEEsB50ED3Nqej5ks49Fyz8blzyRRBOqsaZhREO3wT
         fbgi7kTNVgFH3jROTh4dsZ0jaXikLWfbzB0b9qtlzQKds5L2B57CQ+MCEvc5jLdFeo
         rQwVvgN3R+m8ugpD6F9tWv0B4cK0wJCEXLW1Vh58=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210511011112epcas2p2006594f5bf977f42c51b7a88e2b91590~93fHvjbA60159301593epcas2p2T;
        Tue, 11 May 2021 01:11:12 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FfKcZ1kBRz4x9QD; Tue, 11 May
        2021 01:11:10 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.26.09433.EA9D9906; Tue, 11 May 2021 10:11:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210511011108epcas2p3167993dce9eec96ff7b922515e951274~93fEwkUKz0080200802epcas2p3U;
        Tue, 11 May 2021 01:11:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210511011108epsmtrp1a966360aa899810c24cfdb8c8f410785~93fEvsVr_2198221982epsmtrp1g;
        Tue, 11 May 2021 01:11:08 +0000 (GMT)
X-AuditID: b6c32a47-f4bff700000024d9-63-6099d9ae1e82
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.9A.08637.CA9D9906; Tue, 11 May 2021 10:11:08 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210511011108epsmtip27246b142ac884ada51c95fd9a95a186c~93fEg5PnL2280122801epsmtip2E;
        Tue, 11 May 2021 01:11:08 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'bpf'" <bpf@vger.kernel.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+FuTSeyuUvKC==Mo7L+u3PS0BQyea+EdLLYjhGFrP7FQZsbEQ@mail.gmail.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Tue, 11 May 2021 10:11:08 +0900
Message-ID: <015101d74602$86442210$92cc6630$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYAiru3ucBq8RF2QKY6vTDAm6kVlUBadK04AMaqQ3GARiLayQDE+caWwJJGwtFAeZKb9QDLW923Kgfn/Vg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmhe66mzMTDL7+4bD4/ns2s8WXn7fZ
        LT4fOc5msXjhN2aLOedbWCyadqxgsnjx4QmjxfN9vUwWF7b1sVpc3jWHzaLhLZfFsQViFj8P
        n2G2WPxzA1DVkhmMDvweW1beZPKY2PyO3WPnrLvsHi1H3rJ6dN24xOyxaVUnm8fnTXIB7FE5
        NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAZysplCXm
        lAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEqE3Iy
        zh7fwVzwnbvixe1J7A2Mizi7GDk5JARMJGZsusrcxcjFISSwg1Fiy4HfUM4nRom9S8+xQTjf
        GCXa3t5nh2l58moBO0RiL6PE/UetrBDOC0aJ1WfmMoFUsQloSbyZ1c4KYosIWEn8n30CrINZ
        4DSLxJZre1hAEpwCgRLzTy5hA7GFBYIlnk5qAmtmEVCV2H3+HVicV8BSYsmHP6wQtqDEyZlP
        wHqZBeQltr+dwwxxkoLEz6fLwK4QEZjGKLHy6hpGiCIRidmdbWAfSQg84ZBoOd/BBNHhIvFo
        +xwWCFtY4tXxLVDPSUm87G8DsjmA7HqJ1u4YiN4eRokr+55A1RtLzHrWzghSwyygKbF+lz5E
        ubLEkVtQt/FJdBz+CzWFV6KjTQjCVJKY+CUeYoaExIuTk1kmMCrNQvLYLCSPzUJy/yyEVQsY
        WVYxiqUWFOempxYbFRgjx/YmRnCa1nLfwTjj7Qe9Q4xMHIyHGCU4mJVEeEU7piUI8aYkVlal
        FuXHF5XmpBYfYjQFBvVEZinR5HxgpsgriTc0NTIzM7A0tTA1M7JQEuf9mVqXICSQnliSmp2a
        WpBaBNPHxMEp1cCkeS6twviW1FejpCc/fj7ce+3CXv+Qg+rs7Jsrs9XbtZMZZq2o1J1bMpv3
        QdGqrSv9PvnvvHtw1ro3P08u2uskPFvMR3zl28BZ+7s5+I44Hbx84/UCNabq9+frVqjd1i25
        KuZ+6nXhnlMhQk4fCmxWaX1Ml7QLUpE1VV0R43Rhz7PEzfrTJZZsfF7Df+KCz9HQbDcfn0d1
        BTMnKPy4JzjD05jjSWdFWegXUduPQfnPtdaeY/JwrKvXYzFf4BOlmW6ze3/GDK6Hsh1GNQav
        +DztGYrO8r1V2nz2rxM316Ezs9lM/yhcvOf6UtVH13vB27tKbm9FFyx0Osnmd2d/t+YT/ine
        t3i/npE5nvSxUUFfiaU4I9FQi7moOBEAbN383FwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSvO6amzMTDFY+NbD4/ns2s8WXn7fZ
        LT4fOc5msXjhN2aLOedbWCyadqxgsnjx4QmjxfN9vUwWF7b1sVpc3jWHzaLhLZfFsQViFj8P
        n2G2WPxzA1DVkhmMDvweW1beZPKY2PyO3WPnrLvsHi1H3rJ6dN24xOyxaVUnm8fnTXIB7FFc
        NimpOZllqUX6dglcGWeP72Au+M5d8eL2JPYGxkWcXYycHBICJhJPXi1g72Lk4hAS2M0ocfns
        G7YuRg6ghITErs2uEDXCEvdbjrCC2EICzxgl5iwtA7HZBLQk3sxqB4uLCFhJ/J99AmwOs8BV
        Fomta95DDT3KLvGjcQ8TSBWnQKDE/JNL2EBsYSC7/98tRhCbRUBVYvf5d2BxXgFLiSUf/rBC
        2IISJ2c+YQGxmQW0JXoftjJC2PIS29/OYYa4TkHi59NlrCDLRASmMUqsvLoGqkhEYnZnG/ME
        RuFZSGbNQjJrFpJZs5C0LGBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERyxWpo7
        GLev+qB3iJGJg/EQowQHs5IIr2jHtAQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQn
        lqRmp6YWpBbBZJk4OKUamNxz/xjERcc+vPz47tw7hRfWBU1bG1WTKeD5ZZrBwsW/++7zq9SW
        858p5bm100NSrOrTtzWz5s9be1AoaFW3h1reqeSp/81Ffu4RuXZv8vO1b6uCfOWDV+17cqXs
        yO3zPB46Fpzbfxq5+ieKJgvV1cw6azbj6M+7/3IEbr7+MW2Duvd14xRuye8fY9afbdc5tjra
        8kWQy73p63xPMRV883zmvyHKIEGqZzJzhbSQWYjB+wfBd/c/z7b7Yis+P/GRKu+MaboNm4r4
        bu28fcR5yboey2vPmLcWev548F3dqnyp/fX4ZK3Q7Jl78oOdb5+6/2yaqu87OTOrrsgvU4wK
        0xin5xvcE3l55OXlO583Jv5WYinOSDTUYi4qTgQA0YV38EcDAAA=
X-CMS-MailID: 20210511011108epcas2p3167993dce9eec96ff7b922515e951274
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
        <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
        <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
        <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
        <02c801d7421f$65287a90$2f796fb0$@samsung.com>
        <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
        <001801d742db$68ab8060$3a028120$@samsung.com>
        <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
        <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
        <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
        <007001d7431a$96281960$c2784c20$@samsung.com>
        <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
        <00c901d74543$57fa3620$07eea260$@samsung.com>
        <CA+FuTSepShKoXUJo7ELMMJ4La11J6CsZggJWsQ5MB2_uhAi+OQ@mail.gmail.com>
        <CA+FuTSeyuUvKC==Mo7L+u3PS0BQyea+EdLLYjhGFrP7FQZsbEQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 09:46:25AM -0400, Willem de Bruijn wrote:
> On Mon, May 10, 2021 at 9:19 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > > That generates TCP packets with different MSS within the same stream.
> > > >
> > > > My suggestion remains to just not change MSS at all. But this has to
> > > > be a new flag to avoid changing established behavior.
> > >
> > > I don't understand why the mss size should be kept in GSO step. Will
> > > there be any issue with different mss?
> >
> > This issue has come up before and that has been the feedback from
> > TCP experts at one point.
> >
> > > In general, upgrading mss make sense when 6 to 4. The new flag would be
> > > set by user to not change mss. What happened if user does not set the
> > > flag? I still think we should fix the issue with a general approach. Or
> > > can we remove the skb_increase_gso_size line?
> >
> > Admins that insert such BPF packets should be aware of these issues.
> > And likely be using clamping. This is a known issue.
> >
> > We arrived that the flag approach in bpf_skb_net_shrink. Extending
> > that  to bpf_skb_change_proto would be consistent.
> 
> As for more generic approach: does downgrading to non-TSO by clearing
> gso_size work for this edge case?

It can hit __skb_linearize in validate_xmit_skb and frags will be
copied to a linear part. The linear part size can exceed the MTU of
skb->dev unexpectedly.

I will make another patch with the flag approach.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650FB445DD7
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhKECRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhKECRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 22:17:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273C9C061714;
        Thu,  4 Nov 2021 19:14:42 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p18so10108894plf.13;
        Thu, 04 Nov 2021 19:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfjvfmzLCvPsm0R6UT1quh9th5SL6kMwKAQQ1HqtYRg=;
        b=TQn6xlIs6646061EEEaEQerBh81y/r++Gjm8lH3v8bTk3r3Og3ac/W3dCEKdinfqyy
         HSuY+kaHyzuDkSvPO2F73cxUyx6M1fTQ1Ohd5vhlocwmGWMCuY8vrrxVR8qjBFU1AD/1
         HiWbNR0IT18jthP4HsCRVsLVkbvFgcWKkrtg1NJyY9+YrMAep4ySkKWmqx7X13MExRcc
         gcPfPG8w5DYlv/CE1qbh3+xnlCdINsJbfZOpH323n5ZTSCiE3WUfMo0S2wJqAlBYP4vx
         7rSlm/Xj+s+Hib4CHZbgmyZfBayUzoipQVKtwAYCCtXvP9QpqPFje4sZFdtep58uYCAR
         Jnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfjvfmzLCvPsm0R6UT1quh9th5SL6kMwKAQQ1HqtYRg=;
        b=MOt/V3thLT0B6QkPbXukLnpn64/Ajz6y+juFnX9zcUCgubhNIr9Rr2ywE6Vm/O5gix
         RoTTSDgkC/cA8FwA53W+gF0hNVZ0WERjLE/mQtcoq/9NQA6OWAcpORyxBJ6ApwYChmn+
         R2hr9GJdUUY+TupEhdUNIGOKgrDOh3PRKUJk4BVdfXqcRFOKZuba6uM+wo+sgRBYybd2
         RqDKZDKQIc8TZ/WEbEUM9RJQ87gERAOKlqEaDeseKDgijeGi8qOtLNKcVSKtyi5tVear
         KNpI+boHnbFM0olxGLd9iN/iRQEvYzQ6yo3jZYNoP6XEORe52bLFy0WcEJ2u+9Y9bui6
         yvEw==
X-Gm-Message-State: AOAM531zaB/d09rCE/0wlOQCgJ7BJFleZyqThRHY9lH6IOlLMIDxwwiB
        wgAXiOGHu+6lTdYDrMgz158NNlSUlkd0WNejIPA=
X-Google-Smtp-Source: ABdhPJwYds/lJiZzvk7ctqEBcDqmOriw1mkvJZ51UfLGfpHbqoLmnmL2V61Llu8CEs00kwAKGHgn6D9QZSgJxW9/pTQ=
X-Received: by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr30280136plh.3.1636078481613; Thu, 04 Nov
 2021 19:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
In-Reply-To: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 4 Nov 2021 19:14:30 -0700
Message-ID: <CAADnVQKtwcdqn1k3ep_h9Cz0mpo=j1fqWFhpPSoD-HG7Yum3nA@mail.gmail.com>
Subject: Re: 4-year old off-by-two bug in the BPF verifier's boundary checks?
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 8:12 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> Hi guys,
>
> I think I found cases where the BPF verifier mistakenly rejects valid
> BPF programs when doing pkt_end boundary checks, and the selftests for
> these cases test wrong things as well.
>
> Daniel's commit fb2a311a31d3 ("bpf: fix off by one for range markings
> with L{T, E} patterns") [1] attempts to fix an off-by-one bug in
> boundary checks, but I think it shifts the index by 1 in a wrong
> direction, so instead of fixing, the bug becomes off-by-two.
>
> A following commit b37242c773b2 ("bpf: add test cases to bpf selftests
> to cover all access tests") [2] adds unit tests to check the new
> behavior, but the tests look also wrong to me.
>
> Let me analyze these two tests:
>
> {
>          "XDP pkt read, pkt_data' > pkt_end, good access",
>          .insns = {
>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct
> xdp_md, data)),
>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>                      offsetof(struct xdp_md, data_end)),
>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>          BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>          BPF_MOV64_IMM(BPF_REG_0, 0),
>          BPF_EXIT_INSN(),
>          },
>          .result = ACCEPT,
>          .prog_type = BPF_PROG_TYPE_XDP,
>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
> },
>
> {
>          "XDP pkt read, pkt_data' >= pkt_end, bad access 1",
>          .insns = {
>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct
> xdp_md, data)),
>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>                      offsetof(struct xdp_md, data_end)),
>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>          BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>          BPF_MOV64_IMM(BPF_REG_0, 0),
>          BPF_EXIT_INSN(),
>          },
>          .errstr = "R1 offset is outside of the packet",
>          .result = REJECT,
>          .prog_type = BPF_PROG_TYPE_XDP,
>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
> },
>
> The first program looks good both to me and the verifier: if data + 8 >
> data_end, we bail out, otherwise, if data + 8 <= data_end, we read 8
> bytes: [data; data+7].
>
> The second program doesn't pass the verifier, and the test expects it to
> be rejected, but the program itself still looks fine to me: if data + 8
>  >= data_end, we bail out, otherwise, if data + 8 < data_end, we read 8
> bytes: [data; data+7], and this is fine, because data + 7 is for sure <
> data_end. The verifier considers data + 7 to be out of bounds, although
> both data + 7 and data + 8 are still valid offsets, hence the off-by-two
> bug.
>
> Are my considerations valid, or am I stupidly missing anything?
>
> I suggest to fix it like this:
>
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8492,7 +8492,7 @@ static void find_good_pkt_pointers(struct
> bpf_verifier_state *vstate,
>
>          new_range = dst_reg->off;
>          if (range_right_open)
> -               new_range--;
> +               new_range++;
>
>          /* Examples for register markings:
>           *
>
> I don't think this bug poses any security threat, since the checks are
> stricter than needed, but it's a huge functional issue.

Thanks for the analysis.
It looks correct to me.
Hopefully Daniel will take a look soon.

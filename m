Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE023B1EA
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHDAwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHDAww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:52:52 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78020C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 17:52:52 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z17so17666444ill.6
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 17:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/wYosU3xU95TKa0sCAssL8b2NieBaVvljqARBoYljc8=;
        b=HotbXmAcg0o2AIG2f3IM5m43mtOGxLPQ+1UGXbroEPzHOOeIPaUKESVilXlr2hw+vY
         WnSu7zeKU70SzdjuYouR/DLbAxIRWaW/d/bQcH7IdwHbYW5DE+NuZbzZ5rxgvGe8wVeB
         VBQxZCdY+wMeSA/G93Y03Tl5jad26XjIwE5a1ivnX5pCBqct2391RU+E20Jmx8K8CKKR
         4nkJwg510V1A+QOVLw3DjfQAQG1KZ5bU/5aRIO4E17V/+kCU53I2rwui9xrf0416azXd
         vRjiL/ea8HZ9UAexbCNyGfcAyvInQX146kPdnfyMH4UxYBG7iMNHXiOqgS59l090s3qa
         FM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/wYosU3xU95TKa0sCAssL8b2NieBaVvljqARBoYljc8=;
        b=eKP0SWi7mo/X/TQvion9xI1zXjjmBw3exN6EEK4l/G3uxeyykIrtY9KCPnNJ+vwlpM
         ztHUAvD6/sHCUV5u4yy7Z58nC86MA77wfEUc4CXT5gK0ZoIg0tAF38pzQXsLxjhE0YUC
         bvkSftJJXHyHy5oD7kkeEaa8Wp5iDXReoNn84+6X2eICdHbTPsmO0kRm43prlo7CdQ6/
         ZChknynnQBjr4z9hY6OXNSpWvQmiCVjWLkpLhRUefLNZERHMFtTd95I0EgWuH4c8r0wC
         B3wRTRqzyeXKdipddgR16FKuh/+HzRYU47cVxf6v8cPZVq99vkkHj75nEBc7ZajKU9Hk
         Sr6g==
X-Gm-Message-State: AOAM532DMxIRyPUb0UHVFCVTlvFhYJJROyDp1Dy59dTxosSqwBUHTxdi
        U8PKP1Y71qmycNFgNTeXYqxWLdGh2KYJATue+r0ezQ==
X-Google-Smtp-Source: ABdhPJyg21wxb+3np3+vDMzktvklW+oVso30o8lvBJEeqtbC1iXzFitDccgpBUW2TrK1vbbgmjfhoR8gIifmBKYggJA=
X-Received: by 2002:a92:c608:: with SMTP id p8mr2281097ilm.137.1596502371589;
 Mon, 03 Aug 2020 17:52:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200803231013.2681560-1-kafai@fb.com> <20200803231058.2683864-1-kafai@fb.com>
In-Reply-To: <20200803231058.2683864-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Aug 2020 17:52:40 -0700
Message-ID: <CANn89i+J1aOYfXuntQbiGSJowLh+59+0Fd76Y7iufFRYuqxLSA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 bpf-next 07/12] bpf: tcp: Add bpf_skops_hdr_opt_len()
 and bpf_skops_write_hdr_opt()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 4:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The bpf prog needs to parse the SYN header to learn what options have
> been sent by the peer's bpf-prog before writing its options into SYNACK.
> This patch adds a "syn_skb" arg to tcp_make_synack() and send_synack().
> This syn_skb will eventually be made available (as read-only) to the
> bpf prog.
>
> When writing options, the bpf prog will first be called to tell the
> kernel its required number of bytes.  It is done by the new
> bpf_skops_hdr_opt_len().  The bpf prog will only be called when the new
> BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG is set in tp->bpf_sock_ops_cb_flags.
> When the bpf prog returns, the kernel will know how many bytes are needed
> and then update the "*remaining" arg accordingly.  4 byte alignment will
> be included in the "*remaining" before this function returns.  The 4 byte
> aligned number of bytes will also be stored into the opts->bpf_opt_len.
> "bpf_opt_len" is a newly added member to the struct tcp_out_options.
>
> Then the new bpf_skops_write_hdr_opt() will call the bpf prog to write the
> header options.  The bpf prog is only called if it has reserved spaces
> before (opts->bpf_opt_len > 0).
>
> The bpf prog is the last one getting a chance to reserve header space
> and writing the header option.
>
> These two functions are half implemented to highlight the changes in
> TCP stack.  The actual codes preparing the bpf running context and
> invoking the bpf prog will be added in the later patch with other
> necessary bpf pieces.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E7923B1E6
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgHDAvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHDAvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:51:09 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25CDC061756
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 17:51:08 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p16so21974610ile.0
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 17:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FVYHTG9/w1sACeSgc1h5/Ki3DkFWvo5hFp+R1gPI7EI=;
        b=QnFoBuZw2lctRlF7jBapcgeWW7MifnN91E0aFgNXsQ5UHbglhQJK5VOiZgmR0F3oe5
         2fdrb0H5ZbZajP8EiVZCJaLpxfncSN38rayPHmXIYU71TMZkegHkvsmuPrgc7hIDGzQb
         6CMsURWtoUyZXeQTL93LxnvqHO6lWvC2qcXlEkE0u8Z92k8SxSjMPOl34KpDVxdn6vjp
         rJoDtBe8yIElIYvCVq70N7YcDc5pakmnamMuoO73jMLujBE8LZEorkcyWer7sQE+/SO4
         /rhcn7zk+FFBL5lSD1S/wqCXo+42vL4X4xrj0iNT8bQirU4Z3Qrvyx444kddrOfEcnGu
         c6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FVYHTG9/w1sACeSgc1h5/Ki3DkFWvo5hFp+R1gPI7EI=;
        b=MdHLjYhn7Yu3PZKZKnZ0ndv73+g+3esdNO5r7nvCQOUbekrhhEuFEEqaOf92f0MKch
         fgZEIV4LLPd2uxMQQuqtFir2kfZiacv6TSYysTPxVgo5GtYkackeueFUF0gOS+troYHP
         GoOjGyob5ZaWxG2fkxfE4PZoefofc2ajojVvXxafkZ1s5Ee9WyGiHe4Z4CFpR8TuJPHj
         gn5f3XOvFxauiqEQ3xh4H0qKldvVLryR6070tE1XAfDzeUmRNHKQKdqIyajSb9dCP59a
         ZsIHBAESu9KudRmx94cSkFGb+vMNLuPmmTumP+LRV+iTu02f3an53rm3pZmsmejxBvSv
         /+eQ==
X-Gm-Message-State: AOAM531GlhTODZhcQoIGlQjLcysIaUFyvJNV9VfVwuOEEV/Xx3WP3YbI
        oW//FBvi61svFZJEllTiKhNnUBvfiw8+j8ABbTOqdw==
X-Google-Smtp-Source: ABdhPJx8SqMNWIYmmj4SoVpcYDpD2gLZQlRPvWatIGPGFyczj08/U8IRBcG93CmFDsQ9mkzMdz1Z9lQYBJW5uKUTomg=
X-Received: by 2002:a92:d781:: with SMTP id d1mr1991499iln.68.1596502267851;
 Mon, 03 Aug 2020 17:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200803231013.2681560-1-kafai@fb.com> <20200803231051.2683561-1-kafai@fb.com>
In-Reply-To: <20200803231051.2683561-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Aug 2020 17:50:56 -0700
Message-ID: <CANn89iLipQWyGB9WVyK1ub48q31oEe9Pn=9RB_D21vTCs6r_vA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 bpf-next 06/12] bpf: tcp: Add bpf_skops_parse_hdr()
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

On Mon, Aug 3, 2020 at 4:10 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The patch adds a function bpf_skops_parse_hdr().
> It will call the bpf prog to parse the TCP header received at
> a tcp_sock that has at least reached the ESTABLISHED state.
>
> For the packets received during the 3WHS (SYN, SYNACK and ACK),
> the received skb will be available to the bpf prog during the callback
> in bpf_skops_established() introduced in the previous patch and
> in the bpf_skops_write_hdr_opt() that will be added in the
> next patch.
>
> Calling bpf prog to parse header is controlled by two new flags in
> tp->bpf_sock_ops_cb_flags:
> BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG and
> BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG.
>
> When BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG is set,
> the bpf prog will only be called when there is unknown
> option in the TCP header.
>
> When BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG is set,
> the bpf prog will be called on all received TCP header.
>
> This function is half implemented to highlight the changes in
> TCP stack.  The actual codes preparing the bpf running context and
> invoking the bpf prog will be added in the later patch with other
> necessary bpf pieces.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

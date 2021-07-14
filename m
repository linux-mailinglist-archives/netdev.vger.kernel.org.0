Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EAD3C7ABA
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 02:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhGNA7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 20:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhGNA7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 20:59:19 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5216FC0613DD;
        Tue, 13 Jul 2021 17:56:28 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b1so29605669ioz.8;
        Tue, 13 Jul 2021 17:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mF246P6m6XjTKWNvkuOHecXBVI1U9epeFYEmWnOHa1I=;
        b=PSv/DKzKyqsaTvpwAp5T3FpJ18BpACyB/q+fPN79Er5dJRUV4v5E0sKkmv+RZ+eWDP
         EeRhsVRBLwRjPiRvdMfTm2LOIg5LmJaulNuiUpqGe5M2r/jM2NJMcWo3GzPkFgDGcrap
         +ILFvWx3vwFXs16F57DU9XxX2MZXQYvmz557TztGS8AGYfrkV+3EnGpc8Tl4DUMBX7bh
         UVCT3yiJfhVtBW7IF4LRuiyvwIadUTGKpPs4fGRJW7v1sHQPkMHhbrXe8FoqqzeU80hW
         qQP1rAm5xGfUL1AxbkgJTuQOePV3h6icHwk3A8I7sMXveBR/bBVbYBZ+6DePqrXJ+VQT
         i9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mF246P6m6XjTKWNvkuOHecXBVI1U9epeFYEmWnOHa1I=;
        b=rZ6t7a0Sf8iA9db+DTD5BaMP1BXykfHjMT/htvi8jhHtN9yIbYKPYndKoH+3oIWLUN
         4vED/zrtkl4v8CbOiS+dktspbV/FZ0WSockV9nxfCpTWec/2YD9z/eMsPGbU4blR9O7s
         22OLGD9BPtlYb1DxgKjHeqAMAqXQ2RSDOPyAMZKTFxQ7IwpGPtWj4QHv66YozabxF/co
         lshAHXEscu1Tpb4C393vmUtfOk5vHaMBdQvVGJ5F5WJe6ayw/e/ma0j69oPpQEeQnY/0
         Li3q7sJu064RO3kXe4pCHrMQ85b0fBIHJGmRsxSrMDTYr08P4TzXu/iF8zR2r7HQSd+/
         ZkwQ==
X-Gm-Message-State: AOAM531VyZAo7iuqWg356T1JTtBa8dKuO51lGTk8Pz30Yu865wouV8Ft
        66h0tDfCIlOUigMbjpz9xOl1KH7wkE42i18q2xM=
X-Google-Smtp-Source: ABdhPJz+YqonV6ZmNaz/0k8W6GBFnxa5brVKql4eqcuXQBQSwJFG3bQVgGN0GoEbEQ84gTo1aWz/fumktLrJKut3N7U=
X-Received: by 2002:a05:6638:1204:: with SMTP id n4mr6433458jas.135.1626224187714;
 Tue, 13 Jul 2021 17:56:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210712195546.423990-1-john.fastabend@gmail.com> <20210712195546.423990-3-john.fastabend@gmail.com>
In-Reply-To: <20210712195546.423990-3-john.fastabend@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 13 Jul 2021 17:56:16 -0700
Message-ID: <CAM_iQpUvyzG8-UuJWyfRMGeFg-aMK4uHa-PKGNcdF-f-P+UrnA@mail.gmail.com>
Subject: Re: [PATCH bpf v4 2/2] bpf, sockmap: sk_prot needs inuse_idx set for
 proc stats
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 12:56 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
>
> To get the correct inuse_idx value move the core_initcall that initializes
> the tcp/udp proto handlers to late_initcall. This way it is initialized
> after TCP/UDP has the chance to assign the inuse_idx value from the
> register protocol handler.
>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

For IPv6, I think the module is always loaded before we can
trigger tcp_bpf_check_v6_needs_rebuild(). So,

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Thanks.

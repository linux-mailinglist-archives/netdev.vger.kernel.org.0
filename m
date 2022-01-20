Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87E494659
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358427AbiATER7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiATER6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 23:17:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4D4C061574;
        Wed, 19 Jan 2022 20:17:57 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v11-20020a17090a520b00b001b512482f36so1822149pjh.3;
        Wed, 19 Jan 2022 20:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5O9D7ASqdDFucJQiKUFfcDp4wBTBWg4Hgx0/kZPiSxU=;
        b=ejvL66BnCYzDxKqG+DD3FBrnNi3QE4YCQFR1pXSIb0BJSeJ8fKlwkKhNg9XNmfCjvF
         hd4vupjOjc4JmZnUUoGVbWYKz5jIunu41HFFQ0binTBWqMGQl5D3Rl5yzgMbp4rsxf4B
         jPT7KdJ+ispFIHWS19l6NI78PIoPQGpRaMczWKeJGZj8e0Z7Pn7T4GSUvxd3svEO+OZk
         6by35hcA1y2ACeA+ma6Weo5clinm5oAuX9cJRJ5pt6MXx9iOuTI1YAldaWf6el2SnF0x
         J9I/D8/YoCLj5qg539NCA3DJLZGh5Hl13+HCWguO60kwIWKVKVDtjRDd1xpuH+2cL0v3
         xzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5O9D7ASqdDFucJQiKUFfcDp4wBTBWg4Hgx0/kZPiSxU=;
        b=ijAi+MKNfZl6kGX2H0iNbrGPYVIEUJC94QYjpMEFOyYMUxJzp+2diW38/YAkksbARB
         38AjV3oJd14iSv+144JfA/gI5IjulYcq51nzGA9AydC3/VKImubUnugX1gZ1ZbU8LXBW
         r4dLsPjWn7Zwqlf8uH37VoWxOhuzzMwI+tqVbY+Ui5JiAeZKsOSUzfQOpW4Esdg/Ifo/
         93ROwMhnLMUj5gkeO1Q/6blOL6cgkUQrmrahMnCOX4IcuR+BXc8pGsT9fTTkzm+f2qHf
         cH2zgFxpOiBWKrzGduhGkf4HePOq1gwnyJQJCvQ/F6tttmmz739mAO58oxfAUKedlFs0
         rmYQ==
X-Gm-Message-State: AOAM530kzOt3YlZUM629zIXUgU4oslCx/IbZrMY+yq+ZNVV4gQFbqDTg
        xH84bYc4yvzzUTDUm6zWi74=
X-Google-Smtp-Source: ABdhPJx9zwdvvp0KfNPlOQVjgmdvo0MDzxswBTuv1FV7k+WzAaKWrHpor7GZcg+SVh+cFaSFDGuKQA==
X-Received: by 2002:a17:90a:2e09:: with SMTP id q9mr8409597pjd.2.1642652277409;
        Wed, 19 Jan 2022 20:17:57 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9dc9])
        by smtp.gmail.com with ESMTPSA id m21sm1111708pfk.185.2022.01.19.20.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 20:17:56 -0800 (PST)
Date:   Wed, 19 Jan 2022 20:17:54 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, flyingpeng@tencent.com,
        mungerjiang@tencent.com, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
Message-ID: <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 11:02:27AM +0800, Menglong Dong wrote:
> Hello!
> 
> On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> [...]
> >
> > Looks like
> >  __sk_buff->remote_port
> >  bpf_sock_ops->remote_port
> >  sk_msg_md->remote_port
> > are doing the right thing,
> > but bpf_sock->dst_port is not correct?
> >
> > I think it's better to fix it,
> > but probably need to consolidate it with
> > convert_ctx_accesses() that deals with narrow access.
> > I suspect reading u8 from three flavors of 'remote_port'
> > won't be correct.
> 
> What's the meaning of 'narrow access'? Do you mean to
> make 'remote_port' u16? Or 'remote_port' should be made
> accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
> won't work, as it only is accessible with u32.

u8 access to remote_port won't pass the verifier,
but u8 access to dst_port will.
Though it will return incorrect data.
See how convert_ctx_accesses() handles narrow loads.
I think we need to generalize it for different endian fields.

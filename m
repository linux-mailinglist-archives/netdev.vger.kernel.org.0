Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0AB687C83
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBBLnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBBLnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:43:41 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E67172E;
        Thu,  2 Feb 2023 03:43:40 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ml19so5305315ejb.0;
        Thu, 02 Feb 2023 03:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GeLiQK6PcBpUnJOmrpP/Zz2YKH3F98puIy1y5Mha49U=;
        b=alHCEPRSqkNk8nJZzRSVP6lTVYuoyGWtjBu1Xi+uRg8/9/QlBOlOPiCgmhu2ioASqo
         3YDOis8hSLzDvwDIn7sGa6zwuwTmYroVQSgzNVMKADafBsusCsgO1P60LzmhAdZAXIF+
         nAjQA+YeRPLk3il1gFLiM+cNvxNRgDUg55tWi9XjTmBBSRc0yalLI4iqsYToL7xQp0+m
         SK5EdBLS65TwwLBxqEsaqvh4eACWv74/CkTYJ97LnOcmVYQyeirZ7MMi82/tbsyJMk3V
         F02rneihH8br88ZSW9x+Et1FKSXvQmqJT2pjn4XWkXJfRTVwYBW1EzYJ+1y4M1gbLs/8
         Ihww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GeLiQK6PcBpUnJOmrpP/Zz2YKH3F98puIy1y5Mha49U=;
        b=FmbCYxUJ2cZD2swuVl2U+fIrnaBST6qr5bycO2wN2tAijSZEqh8qfhP1RB5MD7nj3a
         bf+JncE60TrKLL8PmfGOP+zy/vTr0t6vsohzwc4Obij6+5hS3vtJSrkSo3yHy5Q/JCf0
         DQjJ9iCbNt0B7wiz4qw52aAJiB2W6Ip3SF6vvBEsZKqQ67fqetBVgY8C4PonElAftvOx
         iRyLmO1mgM+kcx6UpZZItvnMuS54JEkMgWPn2jVXFXIAw9ZhXxIzAQuqC1q8FfFdZRzR
         lce7wi4SpkEFHPqkvUaoZx1jhJ+7lgnX8AHC53l1+CH6TPaZcRs8E3q+IatiY7iffGRk
         d+dA==
X-Gm-Message-State: AO0yUKWSDIrbsexd/ovYq9NlnO/A3hXRZasH+cxThfLH5ulqZ53B//c+
        MTH7dCxrdF7wgSthR5D+CRPebpwq1ldkAMhSt7M=
X-Google-Smtp-Source: AK7set8H6i7ZlL0/EGE1oK05ljvUoxmpTDERtN9G9awqMMUkKhMr6xH0VS7cKlEmLAONS1kslhequRgSULlSiFEt//Y=
X-Received: by 2002:a17:906:6d13:b0:878:786e:8c39 with SMTP id
 m19-20020a1709066d1300b00878786e8c39mr1888863ejr.105.1675338219069; Thu, 02
 Feb 2023 03:43:39 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev> <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
 <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com> <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com>
In-Reply-To: <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Feb 2023 03:43:27 -0800
Message-ID: <CAADnVQJ3CXKDJ_bZ3u2jOEPfuhALGvOi+p5cEUFxe2YgyhvB4Q@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Joanne Koong <joannelkoong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 1, 2023 at 5:21 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jan 31, 2023 at 4:40 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> > > >
> > > > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > > > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > > > No need for rdonly flag, but extra copy is there in case of cloned which
> > > > could have been avoided with extra rd_only flag.
> > >
> > > Yep, given we are designing bpf_dynptr_slice for performance, extra
> > > copy on reads is unfortunate. ro/rw flag or have separate
> > > bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?
> >
> > Either flag or two kfuncs sound good to me.
>
> Would it make sense to make bpf_dynptr_slice() as read-only variant,
> and bpf_dynptr_slice_rw() for read/write? I think the common case is
> read-only, right? And if users mistakenly use bpf_dynptr_slice() for
> r/w case, they will get a verifier error when trying to write into the
> returned pointer. While if we make bpf_dynptr_slice() as read-write,
> users won't realize they are paying a performance penalty for
> something that they don't actually need.

Makes sense and it matches skb_header_pointer() usage in the kernel
which is read-only. Since there is no verifier the read-only-ness
is not enforced, but we can do it.

Looks like we've converged on bpf_dynptr_slice() and bpf_dynptr_slice_rw().
The question remains what to do with bpf_dynptr_data() backed by skb/xdp.
Should we return EINVAL to discourage its usage?
Of course, we can come up with sensible behavior for bpf_dynptr_data(),
but it will have quirks that will be not easy to document.
Even with extensive docs the users might be surprised by the behavior.

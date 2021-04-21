Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D636758A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 01:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbhDUXJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 19:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbhDUXJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 19:09:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595D3C06174A;
        Wed, 21 Apr 2021 16:09:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z16so31402084pga.1;
        Wed, 21 Apr 2021 16:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D1Df6li7ru0gpHKRJXf71U4nilkzk+sp12aIC3uxctk=;
        b=u57s7Yta0quwlHMvziKz4L6PXEpOgLobDl0APKwz/TC+XxhnE2EQMLSohRtd3nzyUG
         nRn2QJ/ZjT3Fy4YsUuEsMESI/mFHFWoQkU4nD/FtqebFgBlGGPZAUeCEbpxGzf225Myb
         dBgIAEF020T7/PFZBXvJkj10mDySzEQce7LNklVaFaLXL/2LL/3pY/yT423GcY5OQtGu
         QUTpQnx207CZoeLACWnyghl9N+iKQ1eAqKrWalqzJej4d2R0wMmjeK67at9/eOZYCiRi
         440B53nsQnVsScwrOyhGJ/LqvyDC80699yKqH19Cp/ppVXXO2Wev7ajuzSuTuPakrrZD
         Sufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D1Df6li7ru0gpHKRJXf71U4nilkzk+sp12aIC3uxctk=;
        b=UeOzkf5DS2+E2/hqWrFPTdC9H9kI2uWcn5/9xPQFn/fDOYekV2Xlux7OT17auKVxBg
         s0IWS0LNsYvBaahOklrJQYqfAyrt41AH9tamawaZ/ku1OWhAMLQb1AK9f9bMfTU6/Fj1
         d9FXw3/pzuVgHcH0jgqIrymRUDYDoMGYcw4XhEIImmZvPrK/S12fkkfS/VS4mp0Q7hS3
         8aSEULKHkSt1p9qMsAiMVteYrljPLY5KuopU4dWXeJtJZkk3q19XnzdvjNlc79US6ftb
         5JEp0IL12QeUWMX3K48h12QAk8+S7X06tQdvwcBG4oVTYicukRmNWRGVicm+jp+ydKD0
         E/Tw==
X-Gm-Message-State: AOAM532t5ihQoMfj7myihhcu51B1bi2fVbiBCFLc0CdB9QX1A0PhUJ/t
        zZPB/b/X9G96Wr0MLAsG9NA=
X-Google-Smtp-Source: ABdhPJwawqBk7+a0cT7NbXrpPskuV508F9HyiLrW7PoLBkzOIEvl5tmutJyeOurOf8kr1Z5S4nz1Hg==
X-Received: by 2002:a63:d153:: with SMTP id c19mr468723pgj.311.1619046547738;
        Wed, 21 Apr 2021 16:09:07 -0700 (PDT)
Received: from localhost ([47.9.167.200])
        by smtp.gmail.com with ESMTPSA id d4sm2982185pjz.49.2021.04.21.16.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:09:07 -0700 (PDT)
Date:   Thu, 22 Apr 2021 04:38:58 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210421230858.ruwqw5jvsy7cjioy@apollo>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 04:29:28AM IST, Daniel Borkmann wrote:
> On 4/20/21 9:37 PM, Kumar Kartikeya Dwivedi wrote:
> [...]
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index bec4e6a6e31d..b4ed6a41ea70 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -16,6 +16,8 @@
> >   #include <stdbool.h>
> >   #include <sys/types.h>  // for size_t
> >   #include <linux/bpf.h>
> > +#include <linux/pkt_sched.h>
> > +#include <linux/tc_act/tc_bpf.h>
> >   #include "libbpf_common.h"
> > @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
> >   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> >   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> > +/* Convenience macros for the clsact attach hooks */
> > +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
> > +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>
> I would abstract those away into an enum, plus avoid having to pull in
> linux/pkt_sched.h and linux/tc_act/tc_bpf.h from main libbpf.h header.
>
> Just add a enum { BPF_TC_DIR_INGRESS, BPF_TC_DIR_EGRESS, } and then the
> concrete tc bits (TC_H_MAKE()) can be translated internally.
>

Ok, will do.

> > +struct bpf_tc_opts {
> > +	size_t sz;
>
> Is this set anywhere?
>

This is needed by the OPTS_* infrastructure.

> > +	__u32 handle;
> > +	__u32 class_id;
>
> I'd remove class_id from here as well given in direct-action a BPF prog can
> set it if needed.
>

Ok, makes sense.

> > +	__u16 priority;
> > +	bool replace;
> > +	size_t :0;
>
> What's the rationale for this padding?
>

dde7b3f5f2f4 ("libbpf: Add explicit padding to bpf_xdp_set_link_opts")

> > +};
> > +
> > +#define bpf_tc_opts__last_field replace
> > +
> > +/* Acts as a handle for an attached filter */
> > +struct bpf_tc_attach_id {
>
> nit: maybe bpf_tc_ctx
>

Noted.

> > +	__u32 handle;
> > +	__u16 priority;
> > +};
> > +
> > +struct bpf_tc_info {
> > +	struct bpf_tc_attach_id id;
> > +	__u16 protocol;
> > +	__u32 chain_index;
> > +	__u32 prog_id;
> > +	__u8 tag[BPF_TAG_SIZE];
> > +	__u32 class_id;
> > +	__u32 bpf_flags;
> > +	__u32 bpf_flags_gen;
>
> Given we do not yet have any setters e.g. for offload, etc, the one thing
> I'd see useful and crucial initially is prog_id.
>
> The protocol, chain_index, and I would also include tag should be dropped.

A future user of this API needs to know the tag, so I would like to keep that.
The rest we can drop, and probably document the default values explicitly.

> Similarly class_id given my earlier statement, and flags I would extend once
> this lib API would support offloading progs.
>
> > +};
> > +
> > +/* id is out parameter that will be written to, it must not be NULL */
> > +LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
> > +			     const struct bpf_tc_opts *opts,
> > +			     struct bpf_tc_attach_id *id);
> > +LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
> > +			     const struct bpf_tc_attach_id *id);
> > +LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
> > +			       const struct bpf_tc_attach_id *id,
> > +			       struct bpf_tc_info *info);
>
> As per above, for parent_id I'd replace with dir enum.
>
> > +
> >   #ifdef __cplusplus
> >   } /* extern "C" */
> >   #endif

--
Kartikeya

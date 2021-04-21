Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124723670E8
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244612AbhDURGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244596AbhDURGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 13:06:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECD1C06174A;
        Wed, 21 Apr 2021 10:06:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m11so29464101pfc.11;
        Wed, 21 Apr 2021 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kQwC25pP5XF12ZDNsMqTPcBBv53YE2qvthJIvMjDRHI=;
        b=SO4eP6ukaDV2+9PACSBPEceMOxS0Wgnx6GaKFduhzTxIfsk4tRbI+tKezEyBR73K36
         xZ1HBmNhbIlSl1EZ+AQrsf0F6BGKAyiWMofRbuo4GFPtR0KjLr1RWw8YpJRIADTVu2Ch
         a6gXDdK1BEq5+UlFzi0Ygt83HCbo/yiw1V4hCeRpuD0S8FnyKB1Cy/1ZEWHrf6KGy/t1
         yYtNHflhKsnXws1EmnVTxwKguL7DaezzcHRZnSQSORc9nH1OizOpEIzdne5EDYaV0zSv
         6kIGvdguM9WnPUJ7NFYYjh7Y3chIl4hM5bVCCa37Rp4PX71ZZmKw8Kvx26R6y9f1rez9
         ri3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kQwC25pP5XF12ZDNsMqTPcBBv53YE2qvthJIvMjDRHI=;
        b=XcDk0g8M/WejaUyaoNUntTjmc0IHR7PEMlYrKNnTQTcvHcIFgJn4M9phjeEbfJ8gXv
         zzGt9LQ+RaLB0Ye3g0zI1L9l/VtJwMb4cYSdYAvvjG5fRwFST6fA8AKBYr9O/Du5QOBn
         HbPhED61mNeDt3DjUX2rBl57jStN1hRO4yrTho4fiaaaOqfXVsGzv3QDUf/zwd2Oxyff
         HNsbhUxCp4P2/+I04KJdztGBIpC8GYyu2Su8nknhorDxvO8l7uwbTX1EhBtDl2iyRVGU
         MtYE1p1Qnj4/pbzS+HbIM2kM9bbFaxzd9b6E+Y1Z3jgkZxLrjZg5DcI8EzV1Ytp09Yz2
         JLRQ==
X-Gm-Message-State: AOAM533cCwKBr3nlGBV8KzQ26RXgSr5slUqa0ZGtKbLXd58pf2fFIzoY
        hGk0BhIFjtVsr1BPNOPTlO0=
X-Google-Smtp-Source: ABdhPJzLqKsctM3mk7pTnUOzId/Fa/lLSGxz2TiUyOf5tseeoEOLRgrzhdSpNJb98gLgTlYZ75Y76w==
X-Received: by 2002:a17:90a:f992:: with SMTP id cq18mr12312223pjb.7.1619024773912;
        Wed, 21 Apr 2021 10:06:13 -0700 (PDT)
Received: from localhost ([112.79.248.97])
        by smtp.gmail.com with ESMTPSA id b136sm2272704pfb.126.2021.04.21.10.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 10:06:13 -0700 (PDT)
Date:   Wed, 21 Apr 2021 22:36:10 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210421170610.52vxrdrr5lzvkc2b@apollo>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <27b90b27-ce90-7b2c-23be-24cbc0781fbe@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27b90b27-ce90-7b2c-23be-24cbc0781fbe@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 12:28:01PM IST, Yonghong Song wrote:
>
>
> On 4/20/21 12:37 PM, Kumar Kartikeya Dwivedi wrote:
> > This adds functions that wrap the netlink API used for adding,
> > manipulating, and removing traffic control filters. These functions
> > operate directly on the loaded prog's fd, and return a handle to the
> > filter using an out parameter named id.
> >
> > The basic featureset is covered to allow for attaching and removal of
> > filters. Some additional features like TCA_BPF_POLICE and TCA_RATE for
> > the API have been omitted. These can added on top later by extending the
>
> "later" => "layer"?
>

No, I meant that other options can be added on top of this series by someone
later. I'll reword it.

> > bpf_tc_opts struct.
> >
> > Support for binding actions directly to a classifier by passing them in
> > during filter creation has also been omitted for now. These actions have
> > an auto clean up property because their lifetime is bound to the filter
> > they are attached to. This can be added later, but was omitted for now
> > as direct action mode is a better alternative to it, which is enabled by
> > default.
> >
> > An API summary:
> >
> > bpf_tc_attach may be used to attach, and replace SCHED_CLS bpf
> > classifier. The protocol is always set as ETH_P_ALL. The replace option
> > in bpf_tc_opts is used to control replacement behavior.  Attachment
> > fails if filter with existing attributes already exists.
> >
> > bpf_tc_detach may be used to detach existing SCHED_CLS filter. The
> > bpf_tc_attach_id object filled in during attach must be passed in to the
> > detach functions for them to remove the filter and its attached
> > classififer correctly.
> >
> > bpf_tc_get_info is a helper that can be used to obtain attributes
> > for the filter and classififer.
> >
> > Examples:
> >
> > 	struct bpf_tc_attach_id id = {};
> > 	struct bpf_object *obj;
> > 	struct bpf_program *p;
> > 	int fd, r;
> >
> > 	obj = bpf_object_open("foo.o");
> > 	if (IS_ERR_OR_NULL(obj))
> > 		return PTR_ERR(obj);
> >
> > 	p = bpf_object__find_program_by_title(obj, "classifier");
>
> Please use bpf_object__find_program_by_name() API.
> bpf_object__find_program_by_title() is not recommended as now
> libbpf supports multiple programs within the same section.

Thanks, will do.

>
> > 	if (IS_ERR_OR_NULL(p))
> > 		return PTR_ERR(p);
> >
> > 	if (bpf_object__load(obj) < 0)
> > 		return -1;
> >
> > 	fd = bpf_program__fd(p);
> >
> > 	r = bpf_tc_attach(fd, if_nametoindex("lo"),
> > 			  BPF_TC_CLSACT_INGRESS,
> > 			  NULL, &id);
> > 	if (r < 0)
> > 		return r;
> >
> > ... which is roughly equivalent to:
> >    # tc qdisc add dev lo clsact
> >    # tc filter add dev lo ingress bpf obj foo.o sec classifier da
> >
> > ... as direct action mode is always enabled.
> >
> > To replace an existing filter:
> >
> > 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = id.handle,
> > 			    .priority = id.priority, .replace = true);
> > 	r = bpf_tc_attach(fd, if_nametoindex("lo"),
> > 			  BPF_TC_CLSACT_INGRESS,
> > 			  &opts, &id);
> > 	if (r < 0)
> > 		return r;
> >
> > To obtain info of a particular filter, the example above can be extended
> > as follows:
> >
> > 	struct bpf_tc_info info = {};
> >
> > 	r = bpf_tc_get_info(if_nametoindex("lo"),
> > 			    BPF_TC_CLSACT_INGRESS,
> > 			    &id, &info);
> > 	if (r < 0)
> > 		return r;
> >
> > ... where id corresponds to the bpf_tc_attach_id filled in during an
> > attach operation.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >   tools/lib/bpf/libbpf.h   |  44 ++++++
> >   tools/lib/bpf/libbpf.map |   3 +
> >   tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
> >   3 files changed, 360 insertions(+), 6 deletions(-)
> >
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
> > +
> > +struct bpf_tc_opts {
> > +	size_t sz;
> > +	__u32 handle;
> > +	__u32 class_id;
> > +	__u16 priority;
> > +	bool replace;
> > +	size_t :0;
>
> Did you see any error without "size_t :0"?
>

Not really, I just added this considering this recent change:
dde7b3f5f2f4 ("libbpf: Add explicit padding to bpf_xdp_set_link_opts")

> > +};
> > +
> > +#define bpf_tc_opts__last_field replace
> > +
> > +/* Acts as a handle for an attached filter */
> > +struct bpf_tc_attach_id {
> > +	__u32 handle;
> > +	__u16 priority;
> > +};
> > +
> [...]

--
Kartikeya

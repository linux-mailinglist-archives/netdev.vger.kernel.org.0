Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE12A3C30
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKCFtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbgKCFtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604382552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=88GnjAbJN24Xf9UM+hZ5NfODWXArvql4d3FN+KI/h9o=;
        b=O8SweIVbgw1Kw/JQzg0RjOB7+HeQrCfQo72Xez7wkny0mNB/QYP0/QudrxaBwHdpNWnCoj
        d14F49sVmHVNW3JwnuXLJTZ7zti1jEjqyKWDTYdiSpnuxLDNq00b5Rt10/UPPHSgYzZ+tO
        w75J7BSrhfbI0u6Sc9EXc+E6Iil2C+8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-6mUccGtdPXq-4VCooKwa_g-1; Tue, 03 Nov 2020 00:49:08 -0500
X-MC-Unique: 6mUccGtdPXq-4VCooKwa_g-1
Received: by mail-pg1-f200.google.com with SMTP id y7so10718638pgg.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 21:49:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=88GnjAbJN24Xf9UM+hZ5NfODWXArvql4d3FN+KI/h9o=;
        b=QpgDnA6r3PcjpPBiPipeoHkPrH0tb4omnyWN6KE7eVr6iRhMuGUR1vLjZb0jW7yFIH
         sYzoHXIg72RmacZ+3P8h8wDZQR1CmvaPTkUgyd9QfRi3wUF3wpxsn5s1/rJX1nU9nFor
         r3qzPsGtfglcPYqDIRIdwo2j9GVNIFRObj6YDR+U8THCUo1eKwcH15pLDTcueG2oU/Zl
         HmbnPN7mmBKKnLoxNOvPmu3sGtqO99zFiNgc6/+87gdtMTP99DGcEEYPMbrWdY9sD+hq
         yj+4S/g+FTHkY+t6VNHPBxA7aeFzPlDNp9D11/lzXkIJBecGRYEVVt/Ych4fx5Co0/Qr
         el8w==
X-Gm-Message-State: AOAM530nZWPw1g01uVebj9O/8GN01KTt3/fGuQLI0lfetNIkWXiMnD1F
        J/j3MjAUPovjGKQPJWC+rjrSkbJMF+thhh7cxD2wYu/M/tYXSbkwfUDviDW3KcgFVLIi0CEna15
        Xo0BCQ7iFI6hDAAA=
X-Received: by 2002:a63:4204:: with SMTP id p4mr16423098pga.219.1604382547084;
        Mon, 02 Nov 2020 21:49:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUfC25DkIUV/SWmDcXg742Bknc5/DGxCdRDPzEaasV2WWDYJzJ9X8XD4t5Noe0u24Tkxs0Wg==
X-Received: by 2002:a63:4204:: with SMTP id p4mr16423077pga.219.1604382546820;
        Mon, 02 Nov 2020 21:49:06 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x2sm14976588pfc.133.2020.11.02.21.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 21:49:06 -0800 (PST)
Date:   Tue, 3 Nov 2020 13:48:54 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
Message-ID: <20201103054854.GH2408@dhcp-12-153.nay.redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 08:41:09AM -0700, David Ahern wrote:
> 
> I would prefer to have these #ifdef .. #endif checks consolidated in the
> lib code. Create a bpf_compat file for these. e.g.,
> 
> int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
>                      size_t size_insns, const char *license, char *log,
>                      size_t size_log)
> {
> +#ifdef HAVE_LIBBPF
> +	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
> +				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
> +#else
>  	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
>  			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
> +#endif
> }
> 
> Similarly for bpf_program_attach.

> 
> I think even the includes can be done once in bpf_util.h with a single
> +#ifdef HAVE_LIBBPF
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#endif
> +
> 
> The iproute2_* functions added later in this patch can be in the compat
> file as well.

The iproute2_* functions need access static struct bpf_elf_ctx __ctx;
We need move the struct bpf_elf_ctx to another header file if add the
iproute2_* functions to compat file. Do you still want this?

Thanks
Hangbin


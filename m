Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073C3175820
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 11:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCBKRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 05:17:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49606 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727027AbgCBKRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 05:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583144219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eL8JZchEsbL/h889NRHRWnXYllBavo54+TIUWwqBg7g=;
        b=inqq9DwgnFti9GKx4RAatrQyGTRM02ISmZdf1EwuWN+MpaBgl94ZvdKejGD1O4w8+HCmYt
        3IOJIZQ8a5xQazoxtqZXiGmWcRIOw9Lc9JQ8DJ7hN/qdEo87OdwLHD43fiy2H+RfTtPtAb
        4h429/XJe3i3NbKKd/3qt8tIphcLf7M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-SHITZHFCPii6Qaa5ah2Tog-1; Mon, 02 Mar 2020 05:16:58 -0500
X-MC-Unique: SHITZHFCPii6Qaa5ah2Tog-1
Received: by mail-wr1-f71.google.com with SMTP id q18so146016wrw.5
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 02:16:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eL8JZchEsbL/h889NRHRWnXYllBavo54+TIUWwqBg7g=;
        b=UULZAXNozPnbaOa/NOpbxUU3DQqU+5p5lohE9W5VDGbIPZNCofS8qt8jJNli7GKWXL
         BMU/BDe4X3tikRxBWpsIUwWINeKK9vXDR3aAxwZmirYd/vAks9jX8OoEIDUoxS2tyFcR
         e5gKHONYlnfpW74ArIcyrFvluc4BXDiZFgT8zYiuIH6tf/le8dEAKE6+znrJGR6b2wiY
         q/wRNiltHcg+yWbAkYHYEdy0V5liF8cX40kDtjOQIG+MZiX+HnuvyJLTbORUWbcBjI6V
         Y6e0ALrcyHHraDXVROH1E4zCNXzJMOpVCoSnvpN4YyleS2EiA8jsI7jjnRnG++CrV8+Z
         xiOQ==
X-Gm-Message-State: APjAAAVMld8yABvwHzHnGCi2PbnhCnKKsf+6dKUkrOqf0w+8hwUitJVH
        z0bJO86ZZmp2Cvz000QFM6lceqpCbzQsmom+fbezRIhJievpBfIwYXQKMKOAUVhm9uV68mSXkIx
        K9HpCx7MZcfXPu8hX
X-Received: by 2002:a05:600c:290:: with SMTP id 16mr16005857wmk.64.1583144217133;
        Mon, 02 Mar 2020 02:16:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyg9J+eY8BzrDVkVSzM9wsxR4x6mmndvd/SotknY/ghOdArQtP/mHB+S4uF0zg21ddqXhrlFg==
X-Received: by 2002:a05:600c:290:: with SMTP id 16mr16005833wmk.64.1583144216916;
        Mon, 02 Mar 2020 02:16:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n3sm15624071wmc.27.2020.03.02.02.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:16:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E881D180362; Mon,  2 Mar 2020 11:16:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: add bpf_link pinning/unpinning
In-Reply-To: <20200228223948.360936-3-andriin@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <20200228223948.360936-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Mar 2020 11:16:55 +0100
Message-ID: <87h7z7t620.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> With bpf_link abstraction supported by kernel explicitly, add
> pinning/unpinning API for links. Also allow to create (open) bpf_link from BPF
> FS file.
>
> This API allows to have an "ephemeral" FD-based BPF links (like raw tracepoint
> or fexit/freplace attachments) surviving user process exit, by pinning them in
> a BPF FS, which is an important use case for long-running BPF programs.
>
> As part of this, expose underlying FD for bpf_link. While legacy bpf_link's
> might not have a FD associated with them (which will be expressed as
> a bpf_link with fd=-1), kernel's abstraction is based around FD-based usage,
> so match it closely. This, subsequently, allows to have a generic
> pinning/unpinning API for generalized bpf_link. For some types of bpf_links
> kernel might not support pinning, in which case bpf_link__pin() will return
> error.
>
> With FD being part of generic bpf_link, also get rid of bpf_link_fd in favor
> of using vanialla bpf_link.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 131 +++++++++++++++++++++++++++++++--------
>  tools/lib/bpf/libbpf.h   |   5 ++
>  tools/lib/bpf/libbpf.map |   5 ++
>  3 files changed, 114 insertions(+), 27 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 996162801f7a..f8c4042e5855 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6931,6 +6931,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
>  struct bpf_link {
>  	int (*detach)(struct bpf_link *link);
>  	int (*destroy)(struct bpf_link *link);
> +	char *pin_path;		/* NULL, if not pinned */
> +	int fd;			/* hook FD, -1 if not applicable */
>  	bool disconnected;
>  };
>  
> @@ -6960,26 +6962,109 @@ int bpf_link__destroy(struct bpf_link *link)
>  		err = link->detach(link);
>  	if (link->destroy)
>  		link->destroy(link);
> +	if (link->pin_path)
> +		free(link->pin_path);

This will still detach the link even if it's pinned, won't it? What's
the expectation, that the calling application just won't call
bpf_link__destroy() if it pins the link? But then it will leak memory?
Or is it just that __destroy() will close the fd, but if it's pinned the
kernel won't actually detach anything? In that case, it seems like the
function name becomes somewhat misleading?

-Toke


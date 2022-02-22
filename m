Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59434BF15B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiBVF2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:28:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiBVF2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:28:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE546322;
        Mon, 21 Feb 2022 21:28:14 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b8so17257165pjb.4;
        Mon, 21 Feb 2022 21:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7UhZLEQ2XwIqOLzkoLoLaWERjJej97HqulPmb+JFKyk=;
        b=KbI3gIv2Z+hOLzG4/L3p48NZnN2ubLvv1y1ICdglmma75nL96TBUSRZJdJS6qSneCI
         9O8jbQ7MboYgYIBSx+orRKzLdosMaejVR48Ypv+wMRnA4MM7jn32e/bMwYsFXDK+VZXV
         UTQ2ZKl41sQqNdrUwYnVfkF7esBtTdpkIG7rFOjQkrjka/UPiMhy0ME+/oU8WSMBFFf0
         HEstuVEGWw5PFr7Id+aMVV5aM/WpRmLX6KmWjlzF2YShum9GuCkmtruCWqlrgXs7IdoT
         9AIHLhOA3Ko5dvFr1dhCjupXtARQHr3LICCprGogoQ/+iNua3UAT4qNlWkp+TIM+sru2
         WGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UhZLEQ2XwIqOLzkoLoLaWERjJej97HqulPmb+JFKyk=;
        b=J8Fk7oZiwxZW9OZN+iGIHCC06d15Ihp/Z3n65Iz9d8AsmRSZ1bctBQERyet9AwZPIi
         36vR3g/WJ1zYBpn93v1aRRWCBVrmdY0C1IQc/KhoDIOCTm8i0ofjie0njkmrmI9mjvsf
         it9JCqz1VmhdY7NMTR7pjPUMop/qAknPJky/7py7v6XjwcGvMR0cGIUlDponEnag0Vr3
         4sm3TQWOr6zKhIgbWGYkCwgegD56+BhWUwd+5fhmhbMAitSQrdVA7TXX8zBSWhGscTan
         DP05Yg5RRLv/vYf5iVhJtosVe8LZyRTfqBQ+BKu71DYcNqFqUinHukJiDU/ms3V2DW4M
         vwzg==
X-Gm-Message-State: AOAM533QXBDB2yky0lWAAhMHqk46gql1eiWqFWAy5l6VH0v4K/s3MGzG
        DGTEv4eg+pjWR+hz2W7NfW8=
X-Google-Smtp-Source: ABdhPJweLiL3Ygk8pSxgE6seCLAzt6XCOv4VgXvHdRUCMO1jo1Iy0b0dqfl4NxvlH04uoY3ZoZb7yQ==
X-Received: by 2002:a17:90b:4f4b:b0:1b9:3798:85f8 with SMTP id pj11-20020a17090b4f4b00b001b9379885f8mr2417410pjb.139.1645507694191;
        Mon, 21 Feb 2022 21:28:14 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e2d6])
        by smtp.gmail.com with ESMTPSA id s5sm14253230pfd.66.2022.02.21.21.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 21:28:13 -0800 (PST)
Date:   Mon, 21 Feb 2022 21:28:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 01/15] bpf: Factor out fd returning from
 bpf_btf_find_by_name_kind
Message-ID: <20220222052811.4633snvrqrcy4riq@ast-mbp.dhcp.thefacebook.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-2-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 07:17:59PM +0530, Kumar Kartikeya Dwivedi wrote:
> In next few patches, we need a helper that searches all kernel BTFs
> (vmlinux and module BTFs), and finds the type denoted by 'name' and
> 'kind'. Turns out bpf_btf_find_by_name_kind already does the same thing,
> but it instead returns a BTF ID and optionally fd (if module BTF). This
> is used for relocating ksyms in BPF loader code (bpftool gen skel -L).
> 
> We extract the core code out into a new helper
> btf_find_by_name_kind_all, which returns the BTF ID and BTF pointer in
> an out parameter. The reference for the returned BTF pointer is only
> bumped if it is a module BTF, this needs to be kept in mind when using
> this helper.
> 
> Hence, the user must release the BTF reference iff btf_is_module is
> true, otherwise transfer the ownership to e.g. an fd.
> 
> In case of the helper, the fd is only allocated for module BTFs, so no
> extra handling for btf_vmlinux case is required.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  kernel/bpf/btf.c | 47 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 2c4c5dbe2abe..3645d8c14a18 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6545,16 +6545,10 @@ static struct btf *btf_get_module_btf(const struct module *module)
>  	return btf;
>  }
>  
> -BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
> +static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **btfp)

The name is getting too long.
How about bpf_find_btf_id() ?

>  {
>  	struct btf *btf;
> -	long ret;
> -
> -	if (flags)
> -		return -EINVAL;
> -
> -	if (name_sz <= 1 || name[name_sz - 1])
> -		return -EINVAL;
> +	s32 ret;
>  
>  	btf = bpf_get_btf_vmlinux();
>  	if (IS_ERR(btf))
> @@ -6580,19 +6574,40 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
>  			spin_unlock_bh(&btf_idr_lock);
>  			ret = btf_find_by_name_kind(mod_btf, name, kind);
>  			if (ret > 0) {
> -				int btf_obj_fd;
> -
> -				btf_obj_fd = __btf_new_fd(mod_btf);
> -				if (btf_obj_fd < 0) {
> -					btf_put(mod_btf);
> -					return btf_obj_fd;
> -				}
> -				return ret | (((u64)btf_obj_fd) << 32);
> +				*btfp = mod_btf;
> +				return ret;
>  			}
>  			spin_lock_bh(&btf_idr_lock);
>  			btf_put(mod_btf);
>  		}
>  		spin_unlock_bh(&btf_idr_lock);
> +	} else {
> +		*btfp = btf;
> +	}

Since we're refactoring let's drop the indent.
How about
  if (ret > 0) {
    *btfp = btf;
    return ret;
  }
  idr_for_each_entry().

and move the func right after btf_find_by_name_kind(),
so that later patch doesn't need to do:
static s32 bpf_find_btf_id();
Eventually this helper might become global with this name.

Also may be do btf_get() for vmlinux_btf too?
In case it reduces 'if (btf_is_module())' checks.

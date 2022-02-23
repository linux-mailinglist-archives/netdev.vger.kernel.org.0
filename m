Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA94C09E8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiBWDGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiBWDGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:06:06 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA75154BF1;
        Tue, 22 Feb 2022 19:05:39 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 139so18689356pge.1;
        Tue, 22 Feb 2022 19:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8JSB38JeUQuTvwiZGur2Tppkn4OGSmc1FfYjYIznx/8=;
        b=ZAg9mX3EMWkXCm4uAzS9Zzc55kNk372ub9C8S6QGte+fo910ARS9wwIUDMju2n5OHG
         i7lxUje73oJcQmNcYEyeiowr0YbAH5YoVVn+k+tC2MFXa4kkTOtUIRaOdMRQ4a4Hti1s
         m2JG7Q8/56gbRxCIZfpzbN9CDbbYkSx1q9ZoGwMJyLajpiqiiaasvULe4EPrrSTHgEwP
         zwX+HKV653rDEpfgl2aPzGw8C+opX/3XpUVLAShjDUUM3jyFhWwY7KXYBfkdkOfHQMq1
         eAZy5sxQnjQHceoBTF2ezy60QP73RvHy7ZKxpW2vej3GUnTaJGZ1BG55uakTi6Z9Dh5E
         H4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8JSB38JeUQuTvwiZGur2Tppkn4OGSmc1FfYjYIznx/8=;
        b=FXoGvGqzfwXoA6R/qMjyWWy50ORTxOfQYvkYsPDv5O6bcFsXAbu74D63fpmLcudeyW
         30FA/Za7gZAsNyAExEUUlfkwOyL4/kwZcefXL9TfhOel39PMfIjiLVBXHvm+eRmv4+Fg
         mQvDHK+xAdp6XgqWSC3VGL+Wnj1JOTA8MOHFe6xEVJJ9qAtK0nnQrZIEM/Bdopo4+2G5
         uvZRHLU7vEN3T0QIBEZtxAJfzIDvNo1nyCSMOy1gJ2qg3lsPKUOfmk5N7gSSeiyahyI7
         aOZET+nln+CCoGBrZ28YqLy6UioyM6+ED9rIgLbgDiGVWXKSFmOwdZCsS6K3EziT3T6M
         2NAQ==
X-Gm-Message-State: AOAM5303tYcw39P7G//nv0jalRfN3npUixiixZfwlWZCg7lnLPh/4l9m
        YkRoWLgHzG6u6ypUVO6F3HA=
X-Google-Smtp-Source: ABdhPJym4yqmCmLkwA0DODse+STZG7TlOkITdV8MzYj4mcr+wMjXBVd1lo+OAxzOHxlEuX3k+oZACA==
X-Received: by 2002:a05:6a00:1991:b0:4e1:a7dd:96e5 with SMTP id d17-20020a056a00199100b004e1a7dd96e5mr28223863pfl.2.1645585539128;
        Tue, 22 Feb 2022 19:05:39 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id x126sm17499811pfb.117.2022.02.22.19.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 19:05:38 -0800 (PST)
Date:   Wed, 23 Feb 2022 08:35:36 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 01/15] bpf: Factor out fd returning from
 bpf_btf_find_by_name_kind
Message-ID: <20220223030536.xc6qqe6mto3wsy4g@apollo.legion>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <20220220134813.3411982-2-memxor@gmail.com>
 <20220222052811.4633snvrqrcy4riq@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222052811.4633snvrqrcy4riq@ast-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:58:11AM IST, Alexei Starovoitov wrote:
> On Sun, Feb 20, 2022 at 07:17:59PM +0530, Kumar Kartikeya Dwivedi wrote:
> > In next few patches, we need a helper that searches all kernel BTFs
> > (vmlinux and module BTFs), and finds the type denoted by 'name' and
> > 'kind'. Turns out bpf_btf_find_by_name_kind already does the same thing,
> > but it instead returns a BTF ID and optionally fd (if module BTF). This
> > is used for relocating ksyms in BPF loader code (bpftool gen skel -L).
> >
> > We extract the core code out into a new helper
> > btf_find_by_name_kind_all, which returns the BTF ID and BTF pointer in
> > an out parameter. The reference for the returned BTF pointer is only
> > bumped if it is a module BTF, this needs to be kept in mind when using
> > this helper.
> >
> > Hence, the user must release the BTF reference iff btf_is_module is
> > true, otherwise transfer the ownership to e.g. an fd.
> >
> > In case of the helper, the fd is only allocated for module BTFs, so no
> > extra handling for btf_vmlinux case is required.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  kernel/bpf/btf.c | 47 +++++++++++++++++++++++++++++++----------------
> >  1 file changed, 31 insertions(+), 16 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 2c4c5dbe2abe..3645d8c14a18 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6545,16 +6545,10 @@ static struct btf *btf_get_module_btf(const struct module *module)
> >  	return btf;
> >  }
> >
> > -BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
> > +static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **btfp)
>
> The name is getting too long.
> How about bpf_find_btf_id() ?
>
> >  {
> >  	struct btf *btf;
> > -	long ret;
> > -
> > -	if (flags)
> > -		return -EINVAL;
> > -
> > -	if (name_sz <= 1 || name[name_sz - 1])
> > -		return -EINVAL;
> > +	s32 ret;
> >
> >  	btf = bpf_get_btf_vmlinux();
> >  	if (IS_ERR(btf))
> > @@ -6580,19 +6574,40 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
> >  			spin_unlock_bh(&btf_idr_lock);
> >  			ret = btf_find_by_name_kind(mod_btf, name, kind);
> >  			if (ret > 0) {
> > -				int btf_obj_fd;
> > -
> > -				btf_obj_fd = __btf_new_fd(mod_btf);
> > -				if (btf_obj_fd < 0) {
> > -					btf_put(mod_btf);
> > -					return btf_obj_fd;
> > -				}
> > -				return ret | (((u64)btf_obj_fd) << 32);
> > +				*btfp = mod_btf;
> > +				return ret;
> >  			}
> >  			spin_lock_bh(&btf_idr_lock);
> >  			btf_put(mod_btf);
> >  		}
> >  		spin_unlock_bh(&btf_idr_lock);
> > +	} else {
> > +		*btfp = btf;
> > +	}
>
> Since we're refactoring let's drop the indent.
> How about
>   if (ret > 0) {
>     *btfp = btf;
>     return ret;
>   }
>   idr_for_each_entry().
>
> and move the func right after btf_find_by_name_kind(),
> so that later patch doesn't need to do:
> static s32 bpf_find_btf_id();
> Eventually this helper might become global with this name.
>

Ok, will change.

> Also may be do btf_get() for vmlinux_btf too?
> In case it reduces 'if (btf_is_module())' checks.

Right, should also change this for btf_get_module_btf then, to make things
consistent.

--
Kartikeya

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA8746DF7C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbhLIAes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhLIAes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:34:48 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B62C061746;
        Wed,  8 Dec 2021 16:31:15 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id x10so4801020ioj.9;
        Wed, 08 Dec 2021 16:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=JsWYjBq5nTDhkhANVBgH4D3Tbd2QYmJXiBeLddZtISw=;
        b=nlFKnB0KayIG3zU8Jw0+Ux5TF0kqV/NqzRoglnyEvgMRHPZEeiC2bSQ69rTiFESkCH
         RWe3/yw32mGGa1ZOh5bZ8hbm1aY8kP1P/D/PDkHCcLyVL9qC5+4hZuBcDV9x5r2+dYOV
         5ZOfQM5VMFZiK8S0K3MY5CffiQlYD9dama94PJJPnoC/JuPxnuVjujXlBcl30ssNLm3g
         23bx0KZOqp0sG5RoZ1Iki/tGWqJMOTku8HebJ82z8QreEhkeJOe0c7B1lQfyIsHxaeUA
         kLmnn/QhkbjLDPVrWDK21F7ObraoS35WMHt4I6taNkSNURcOAbb4Iys68Fo7WGQUKWe4
         MGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=JsWYjBq5nTDhkhANVBgH4D3Tbd2QYmJXiBeLddZtISw=;
        b=ZyDhmCq44Btt2dDXR6/o8qASiNJke2wmjUiFbSpfHF+6FDew3e8CFRg6nH7Dm1tAe9
         AMYsWlftPc8wprR85sR2IAqFPKmSmevPCh/bLJ1UTZk4gYDvMf27xsT64gX7DrW0i6kp
         bLkukbD1BIQj0a2tGOTGBv97Eywjlh2npk+jx2y11WZIwGcux5eJ5nIFwUer76JS74mc
         vmO77fa/ev+m3iQhCif3Alf7Bj6AFhdgp+uGx2XBxBMllRShUAMpuA6D8gXdRtNytzEJ
         k6adWssWLsM4k8p+EMnh88z+7BJU8THU1/dsd3nPh8d9s4TZdtZZ3LtZCGw/xO7oJ+jm
         f8sQ==
X-Gm-Message-State: AOAM533ahqEHNi0S4Zc8MIfRTzlvO7aGOy27AnzZ6XCODOuWjqWPkflI
        Zz2yBEI14nULqvAkK4KW7ng=
X-Google-Smtp-Source: ABdhPJyD4NGpxGDHgvZoX3wYI7DY/5PGSU8PVemEoxv4Lw9FAiABazrUd+nWEYUNwwXwFBlyMFCtoA==
X-Received: by 2002:a05:6602:15c9:: with SMTP id f9mr11150303iow.184.1639009874908;
        Wed, 08 Dec 2021 16:31:14 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x18sm2915740iow.53.2021.12.08.16.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 16:31:14 -0800 (PST)
Date:   Wed, 08 Dec 2021 16:31:06 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <61b14e4ae483b_979572082c@john.notmuch>
In-Reply-To: <20211202000232.380824-6-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-6-toke@redhat.com>
Subject: RE: [PATCH bpf-next 5/8] xdp: add xdp_do_redirect_frame() for
 pre-computed xdp_frames
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Add an xdp_do_redirect_frame() variant which supports pre-computed
> xdp_frame structures. This will be used in bpf_prog_run() to avoid havi=
ng
> to write to the xdp_frame structure when the XDP program doesn't modify=
 the
> frame boundaries.
> =

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/filter.h |  4 ++++
>  net/core/filter.c      | 28 +++++++++++++++++++++-------
>  2 files changed, 25 insertions(+), 7 deletions(-)
> =

> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index b6a216eb217a..845452c83e0f 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1022,6 +1022,10 @@ int xdp_do_generic_redirect(struct net_device *d=
ev, struct sk_buff *skb,
>  int xdp_do_redirect(struct net_device *dev,
>  		    struct xdp_buff *xdp,
>  		    struct bpf_prog *prog);
> +int xdp_do_redirect_frame(struct net_device *dev,
> +			  struct xdp_buff *xdp,
> +			  struct xdp_frame *xdpf,
> +			  struct bpf_prog *prog);

I don't really like that we are passing both the xdp_buff ptr and
xdp_frame *xdpf around when one is always null it looks like?

>  void xdp_do_flush(void);
>  =

>  /* The xdp_do_flush_map() helper has been renamed to drop the _map suf=
fix, as
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1e86130a913a..d8fe74cc8b66 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3957,14 +3957,13 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
>  }
>  EXPORT_SYMBOL_GPL(xdp_master_redirect);
>  =

> -int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> -		    struct bpf_prog *xdp_prog)
> +static int __xdp_do_redirect(struct net_device *dev, struct xdp_buff *=
xdp,
> +			     struct xdp_frame *xdpf, struct bpf_prog *xdp_prog)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>  	enum bpf_map_type map_type =3D ri->map_type;
>  	void *fwd =3D ri->tgt_value;
>  	u32 map_id =3D ri->map_id;
> -	struct xdp_frame *xdpf;
>  	struct bpf_map *map;
>  	int err;
>  =

> @@ -3976,10 +3975,12 @@ int xdp_do_redirect(struct net_device *dev, str=
uct xdp_buff *xdp,
>  		goto out;
>  	}
>  =

> -	xdpf =3D xdp_convert_buff_to_frame(xdp);
> -	if (unlikely(!xdpf)) {
> -		err =3D -EOVERFLOW;
> -		goto err;
> +	if (!xdpf) {
> +		xdpf =3D xdp_convert_buff_to_frame(xdp);
> +		if (unlikely(!xdpf)) {
> +			err =3D -EOVERFLOW;
> +			goto err;
> +		}

This is a bit ugly imo. Can we just decide what gets handed to the functi=
on
rather than having this mid function conversion?

If we can't get consistency at least a xdpf_do_redirect() and then make
a xdp_do_redirect( return xdpf_do_redirect(xdp_convert_buff_to_frame(xdp)=
))
that just does the conversion and passes it through.

Or did I miss something?

>  	}
>  =

>  	switch (map_type) {
> @@ -4024,8 +4025,21 @@ int xdp_do_redirect(struct net_device *dev, stru=
ct xdp_buff *xdp,
>  	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri-=
>tgt_index, err);
>  	return err;
>  }
> +
> +int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> +		    struct bpf_prog *xdp_prog)
> +{
> +	return __xdp_do_redirect(dev, xdp, NULL, xdp_prog);

same here. Just do the conversion and call,

 __xdpf_do_redirect(dev, xdpf, xdp_prog)

skipping the null pointr?

> +}
>  EXPORT_SYMBOL_GPL(xdp_do_redirect);
>  =

> +int xdp_do_redirect_frame(struct net_device *dev, struct xdp_buff *xdp=
,
> +			  struct xdp_frame *xdpf, struct bpf_prog *xdp_prog)
> +{
> +	return __xdp_do_redirect(dev, xdp, xdpf, xdp_prog);
> +}
> +EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
> +
>  static int xdp_do_generic_redirect_map(struct net_device *dev,
>  				       struct sk_buff *skb,
>  				       struct xdp_buff *xdp,
> -- =

> 2.34.0
> =


Thanks,
John

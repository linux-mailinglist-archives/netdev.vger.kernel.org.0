Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93D845F4F9
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhKZTCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:02:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233299AbhKZTAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:00:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637953043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kJRu5pi2ZYGFjCg7uZ9/h1dqa3bPmwtHSnnnrguZUw=;
        b=cuXD5XtzBQdcWQlSjRwMkMIwndKm4rilPQvVRrhwgvPgybgQ4HeoRSmdUuNP0ZQ1y5E7kb
        GIzOScs+AeXoay5hH7eLggJLU7IUe3nyf2/FZhTeX+ud6TvRRxExaBUTF1a5PKOdRYRHbA
        Gzn9CKptEGrawky4lRKDaPNdeI5qg5Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-MwkQ_lNFM6qvgU1iuQQ4NA-1; Fri, 26 Nov 2021 13:57:22 -0500
X-MC-Unique: MwkQ_lNFM6qvgU1iuQQ4NA-1
Received: by mail-ed1-f69.google.com with SMTP id k7-20020aa7c387000000b003e7ed87fb31so8730306edq.3
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 10:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2kJRu5pi2ZYGFjCg7uZ9/h1dqa3bPmwtHSnnnrguZUw=;
        b=cHlhXCZi9Av4INu3nAzLf3kpSh8SpnKxWu8uGz/z8wd/pOVavTKqoYRNi9FKFRRLg/
         G5wjY/7wwwcvBnba25ofc7CvPEUP4eYosPCN5rUzbzJj8/RxZ9HjH2PppPxBF/N/K85v
         9eCzzNvTPsontPn/DC1ykO54Era9VqjeRfbDViEBqtU7k6jBVHuQwWtmr5hcgEPMNGHy
         /mH2hOtg6b199aeZfVuM2qH/ffaEgZL3EmIYTIWSA0Q1559r4NHNQu2e+dVkXT4msIpO
         3FHfUFPd4MkH81zdpu5EPm5TpQEWMKSLMwnG5wl+LbEjoTiE2Uh8CTMB4l7DQ0cgkPhs
         8IHA==
X-Gm-Message-State: AOAM532blTTkCI9pgeytPFtYnaIUvpT2G3jKzLAz4hC4rhbZotJx0k3c
        dYWYgr7/roDvZVodiGSGPwOw+xq44XOtn1TuOgOiH78tSqOip6PCGkwFzN9Df302JAx0Umm+pWA
        J9NuhuefBfyRihFxU
X-Received: by 2002:a17:906:c147:: with SMTP id dp7mr41448250ejc.173.1637953040932;
        Fri, 26 Nov 2021 10:57:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQUOHMd+MdSQiFQFsexVrhcvfY2Jn51agKD/aohQi34dFl0rsHMmUOtbDk8s6RqeGih26P8Q==
X-Received: by 2002:a17:906:c147:: with SMTP id dp7mr41448221ejc.173.1637953040708;
        Fri, 26 Nov 2021 10:57:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-234-118.dyn.eolo.it. [146.241.234.118])
        by smtp.gmail.com with ESMTPSA id yc24sm3401247ejb.104.2021.11.26.10.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 10:57:20 -0800 (PST)
Message-ID: <8f6f900b2b48aaedf031b20a7831ec193793768b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Fri, 26 Nov 2021 19:57:19 +0100
In-Reply-To: <20211126101941.029e1d7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1637924200.git.pabeni@redhat.com>
         <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
         <20211126101941.029e1d7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-11-26 at 10:19 -0800, Jakub Kicinski wrote:
> On Fri, 26 Nov 2021 12:19:11 +0100 Paolo Abeni wrote:
> > -void bpf_warn_invalid_xdp_action(u32 act)
> > +void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
> >  {
> >  	const u32 act_max = XDP_REDIRECT;
> >  
> > -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> > +	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
> >  		     act > act_max ? "Illegal" : "Driver unsupported",
> > -		     act);
> > +		     act, prog->aux->name, prog->aux->id, dev->name ? dev->name : "");
> >  }
> 
> Since we have to touch all the drivers each time the prototype of this
> function is changed - would it make sense to pass in rxq instead? It has
> more info which may become useful at some point.

I *think* for this specific scenario the device name provides all the
necessary info - the users need to know the driver causing the issue.

Others similar xdp helpers - e.g. trace_xdp_exception() - have the same
arguments list used here. If the rxq is useful I guess we will have to
change even them, and touch all the drivers anyway.

Cheers,

Paolo


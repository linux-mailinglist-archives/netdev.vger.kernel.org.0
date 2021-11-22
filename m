Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0B4595FE
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhKVUSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:18:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232880AbhKVUS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 15:18:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637612122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kTw3n+IHmboJdvs0HssW0Khr3n8pxHWIp5Cu6i57Ngk=;
        b=L+nKdRO8/rYe9mz5D7lmb4yctsjF7/OqBFo+SEvF4U7ifskZsgiSnfQ024S+zgoIsQ/LrP
        yw6CLRpCUyxkJ1/FlOoQGs067OPvbWhRHO0gEx6HH703pjUaOpz1/ATqgYLb62VX5Mh7jM
        XTr5dLCuAgAtsnlctffe6dRja5cVqhI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-Ax6unYcrM-uZq2PeI3Yhcg-1; Mon, 22 Nov 2021 15:15:20 -0500
X-MC-Unique: Ax6unYcrM-uZq2PeI3Yhcg-1
Received: by mail-ed1-f72.google.com with SMTP id k7-20020aa7c387000000b003e7ed87fb31so15978810edq.3
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 12:15:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kTw3n+IHmboJdvs0HssW0Khr3n8pxHWIp5Cu6i57Ngk=;
        b=1Vxu8oJwrcitMYewdXg9jtWA4zGPf6fVbaQCthKKUfTxCm1eQeEm8E0LjBesdNqg9t
         7vyv0M1OD5222I129uDjGpDq/jjFRW38uvhJ9tEa+aefykcVqFlDHQaK2WwCyqAZ0xsR
         hX9szrnIFuUcMy1KBhrGTLEswhFJCgWHVjF7r6ZKPt1W4BINp4e3DX1b0yut+Fia0sTw
         oL/3aOlrqlb+2qttHjG2OMUVoqgVr0s69XJq/VYqY1x+ajuzRV7wdpdOFBJhxs7+3d8E
         vUrcT5r7Mt84Z7Wm9ZWRFH8oG3vuc1POWj+mNDpxx6Ig1sZEv7DRXaiJsxUVd/cgqDkM
         310w==
X-Gm-Message-State: AOAM5324AiK3dkPejXYe7gA8lotpuwyaQbeOwx/xYFJLcOO40yLgQSg7
        CoNIgblZ4ExijPJUB1FiVSi1pv6IhL6KwhUL3d6DvVTwGblWmkqwbY+LJz5imwTg1uL2fCUmyiI
        xKkqo4MOSGHnoPYx+
X-Received: by 2002:a05:6402:11c7:: with SMTP id j7mr69810707edw.83.1637612119677;
        Mon, 22 Nov 2021 12:15:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6pT72/cqiAWbVlkfdsNxMHoc4XFQbWEhmyJY6jO4hRPTxpqknwHfvSLP8C1Hr5dAhTqfvWA==
X-Received: by 2002:a05:6402:11c7:: with SMTP id j7mr69810661edw.83.1637612119476;
        Mon, 22 Nov 2021 12:15:19 -0800 (PST)
Received: from krava ([83.240.60.218])
        by smtp.gmail.com with ESMTPSA id ig1sm4168971ejc.77.2021.11.22.12.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 12:15:18 -0800 (PST)
Date:   Mon, 22 Nov 2021 21:15:16 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 09/29] bpf: Add support to load multi func
 tracing program
Message-ID: <YZv6VLAuv+4gPy/4@krava>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-10-jolsa@kernel.org>
 <20211119041159.7rebb5lz2ybnygqr@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119041159.7rebb5lz2ybnygqr@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 08:11:59PM -0800, Alexei Starovoitov wrote:
> On Thu, Nov 18, 2021 at 12:24:35PM +0100, Jiri Olsa wrote:
> > +
> > +DEFINE_BPF_MULTI_FUNC(unsigned long a1, unsigned long a2,
> > +		      unsigned long a3, unsigned long a4,
> > +		      unsigned long a5, unsigned long a6)
> 
> This is probably a bit too x86 specific. May be make add all 12 args?
> Or other places would need to be tweaked?

I think si, I'll check

> 
> > +BTF_ID_LIST_SINGLE(bpf_multi_func_btf_id, func, bpf_multi_func)
> ...
> > -	prog->aux->attach_btf_id = attr->attach_btf_id;
> > +	prog->aux->attach_btf_id = multi_func ? bpf_multi_func_btf_id[0] : attr->attach_btf_id;
> 
> Just ignoring that was passed in uattr?
> Maybe instead of ignoring dopr BPF_F_MULTI_FUNC and make libbpf
> point to that btf_id instead?
> Then multi or not can be checked with if (attr->attach_btf_id == bpf_multi_func_btf_id[0]).
> 

nice idea, it might fit better than the flag

thanks,
jirka


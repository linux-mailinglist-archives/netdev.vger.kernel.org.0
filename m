Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8246298805
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771267AbgJZIKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:10:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1771254AbgJZIKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603699850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AJnXwmLIksLwIfYM1G6H+JTSIVXaTXvTLIO1g2gy9ew=;
        b=eBUnjqgDzkvvCjt/tHp0NhkCVyDw2BSVgq8JYodK+KrVQVM8sPnJ4yt1ndMOsUtY5qHFvf
        hYoiq/KoPA+ka+yaOnLN12S+ncKnix4WF0uecZQnmyjQQDlaosBaUKbNW2qjrF9I0QbFo4
        6HuEuiNITaUJjsSTp8fYWiTeAZX5TPo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-W1hpOKRDNg6zmp23iutR6w-1; Mon, 26 Oct 2020 04:10:48 -0400
X-MC-Unique: W1hpOKRDNg6zmp23iutR6w-1
Received: by mail-pf1-f197.google.com with SMTP id f15so5192264pfj.19
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 01:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AJnXwmLIksLwIfYM1G6H+JTSIVXaTXvTLIO1g2gy9ew=;
        b=PMoUn21E6lChVUdpTNJaV40DF4YxF3q1TQ6sIN4cEXDSJve8zqiLGbpa8vk3CLFReS
         WHz8+otTe7R16Ht4kGH4Lyn58U4mUeYvxYK40MFXjY0oNYu+YxLk9OpCaw3pfUmccQXa
         rS6FRws8ERYffv5ON9jlW6+ytWAfSvxMuILVd4HD/e6C4JTjbsiet6PBUMQMOomNX9hP
         +b19TuA7ZlNSJUJXc5n+errxEOSMi/v0J8xfCp13iWEq+ddle812KMZ8ilWUCifUev2k
         uMF4O2sSpxN08R2TvQjdPyRgxLTHDN1igE47uQgoMvOTM92g4Hdz8b+03XpsIdAsWdmf
         V3Og==
X-Gm-Message-State: AOAM531rUu+YlbIF4c1Yn4iG1USCPh55dkgrW1rFtrjR2jU/HxFNm7pE
        uzJYyg15k1dEznVcqSZ9NT/w7+EvymqEVT5FHmBMCXTNip2SSrq8sHa3mzICoGpFIajKkGqZoL3
        So+W9YEDto5APElw=
X-Received: by 2002:a62:30c2:0:b029:15c:77c7:4687 with SMTP id w185-20020a6230c20000b029015c77c74687mr12902356pfw.19.1603699847323;
        Mon, 26 Oct 2020 01:10:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlS+pWF9Mjtc8Sm9XigHDfYnODfGwSv55cE+RivEdR5IgUPym7g+odJVaH4FPxfitbeCWC0A==
X-Received: by 2002:a62:30c2:0:b029:15c:77c7:4687 with SMTP id w185-20020a6230c20000b029015c77c74687mr12902332pfw.19.1603699847014;
        Mon, 26 Oct 2020 01:10:47 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z21sm11091085pfr.43.2020.10.26.01.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 01:10:46 -0700 (PDT)
Date:   Mon, 26 Oct 2020 16:10:34 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
Message-ID: <20201026081034.GD2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
 <CAEf4BzbPW8itEQjR=DsjJbtoUFWjiC1WC7F=9x_u4ddSAkZPhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbPW8itEQjR=DsjJbtoUFWjiC1WC7F=9x_u4ddSAkZPhg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 05:21:20PM -0700, Andrii Nakryiko wrote:
> > +       obj = bpf_object__open_file(cfg->object, &open_opts);
> > +       if (IS_ERR_OR_NULL(obj))
> 
> libbpf defines libbpf_get_error() to check that the returned pointer
> is not encoding error, you shouldn't need to define your IS_ERR
> macros.

Thanks for this tip, I will fix it in next version.

Hangbin


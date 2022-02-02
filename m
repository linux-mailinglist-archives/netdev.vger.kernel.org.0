Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC384A76C5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346242AbiBBRYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:24:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238522AbiBBRYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643822656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3OAAhJ1yQ586G1GSfs1iva0fA7dOQbeoU53qGnYVps=;
        b=U6TIpxq+4usR7Gh+UpQnA9N/aodMJ82vXCKt7rXEub26n0j0mv/BVpwb+vHNSgq/F9LOU+
        jojTLXOMhl0e+VbAkrCUcnRmaykPfYGc0XSdemhroI6Lo3DdfudPiRYVCDG8bQfg1wHg07
        XIPrh0R/uwpXn6aLWgY30QPtoymY9CM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-_wR7mzh6MpitOy4aycpu5Q-1; Wed, 02 Feb 2022 12:24:15 -0500
X-MC-Unique: _wR7mzh6MpitOy4aycpu5Q-1
Received: by mail-wr1-f69.google.com with SMTP id c10-20020adfa30a000000b001d79c73b64bso2129wrb.1
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 09:24:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a3OAAhJ1yQ586G1GSfs1iva0fA7dOQbeoU53qGnYVps=;
        b=SD07h2fqVcJv53WD7MR1X45r668qmP91h4rl4gsbTQpGLYScHRiyuJ4wXCXjKZ72dW
         63OdGcA0JDhXfqjd6bRwFyzbP5MH+xWEsMgbuSZjvvyqFL71KWVpit5IUuzTM3zF75dr
         gT9LvKyXepuiJm8djpkbvXklgzBhk9DBBQLenXqCwFaiqvPyi9unYXk7Ejf1QjkLlH/K
         Xlzvy9goOhy61ft65BqbfD2Xr9bz4aPhsEriGZoNjve5HszamzPmEj4yYmkjL12JnKvQ
         KmPpBNeCe/Vv1QHhwK5hq3MKl2XqH8lnhL3YHZS5CnKUCMkFOnNVqHRdlX+zUA+VAi+9
         Mg7A==
X-Gm-Message-State: AOAM531OTBBZnnF1KPfjYbvjH4YnipBRaqwr9t0GipR3vSruYD2R2JgW
        m0KpxHxVE6WnYYBRKjP+KPA5/+476Av9f1v74YpSRkkwnZJmVeXyXHvIL08yegMrhV6akRvkQhb
        y0nVcI4wbNDMBCZAP
X-Received: by 2002:a05:600c:4801:: with SMTP id i1mr7027725wmo.180.1643822654680;
        Wed, 02 Feb 2022 09:24:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSSayZ7Fi8nDt3X2L7PRK4VumZHeWPrHmdIcrsIB/sUgpK7JI78M0RwK69qEVM5hPwZUtFxg==
X-Received: by 2002:a05:600c:4801:: with SMTP id i1mr7027702wmo.180.1643822654476;
        Wed, 02 Feb 2022 09:24:14 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id r2sm25729143wrz.99.2022.02.02.09.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 09:24:13 -0800 (PST)
Date:   Wed, 2 Feb 2022 18:24:12 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-ID: <Yfq+PJljylbwJ3Bf@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
 <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 09:09:53AM -0800, Alexei Starovoitov wrote:
> On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > hi,
> > this patchset adds new link type BPF_LINK_TYPE_FPROBE that attaches kprobe
> > program through fprobe API [1] instroduced by Masami.
> 
> No new prog type please.
> I thought I made my reasons clear earlier.
> It's a multi kprobe. Not a fprobe or any other name.
> The kernel internal names should not leak into uapi.
> 

well it's not new prog type, it's new link type that allows
to attach kprobe program to multiple functions

the original change used BPF_LINK_TYPE_RAW_KPROBE, which did not
seem to fit anymore, so I moved to FPROBE, because that's what
it is ;-)

but if you don't want new name in uapi we could make this more
obvious with link name:
  BPF_LINK_TYPE_MULTI_KPROBE

and bpf_attach_type:
  BPF_TRACE_MULTI_KPROBE

jirka


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1A446080B
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbhK1RaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 12:30:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231267AbhK1R2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 12:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638120290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2I2UUd/Y3ibOkvKx2aPdI/birA/k8JHGGbXx66nCrG4=;
        b=Cd9QsR9w57afm+UK6harx9yql6ylhng8pDrA/thoBkmURsEWG20qrOasD+ZIZ1raYVscKG
        sfHNwFIY7ZpYLbfDfGTXlLhnyuO+1GXGJrDUv7Jg4dCTexUEASLowZug/n0H25ufiCLp3G
        K+DMuJ7IJRncp1u9HcIu1nSt9D7rWt4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-6062QAlTOKqu-OiG0yKdbA-1; Sun, 28 Nov 2021 12:24:48 -0500
X-MC-Unique: 6062QAlTOKqu-OiG0yKdbA-1
Received: by mail-wr1-f72.google.com with SMTP id u4-20020a5d4684000000b0017c8c1de97dso2263960wrq.16
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 09:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2I2UUd/Y3ibOkvKx2aPdI/birA/k8JHGGbXx66nCrG4=;
        b=l8RgaIb7pJJK/p+xZ1ltXVlvpWcH/t2Rw4CfnqdYPLakv2dAZx9R6VHN7UOS8KdIF6
         ilrcuYX9heBJUmiL0ITpIsnBPLCwoFxT/2qb5wQKd2Zxs907fCLMuQxnRCnzIWfYdisj
         QsSdyl1f8dxqbtY0fT4zcrTGn0XXAooAhGHWJvgxSjEKbx8kZnjqQh3tZs6TEfzCDVch
         0qio5FPycHVwquXlFjgFKgULzfjCVNHqbLme//ZXjrwQ0cl63IoV6Et5JoKvy2rrtV0I
         pyoRZ4AP+O2yOXJdk/VEE00TImMD1JzPW+RWJmkeWud3ElT3tNX2vkwIWotYaZSxyq8+
         MyMw==
X-Gm-Message-State: AOAM531W+DUA9fuB5cZQ1tUKIG8LGkoAI0zzZIA/m/RJamJHmPcRylYx
        XB69F/MifjDIDSNATA1fo2+1qH8pZdIZpUAzwMkz7BUE1z3kaRXSi0SOdGiJDVIkJvZ0fpKkJQI
        sXYqWPOsfWK7hsSZT
X-Received: by 2002:a05:600c:1e8c:: with SMTP id be12mr31607831wmb.4.1638120287471;
        Sun, 28 Nov 2021 09:24:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOLjOGpE6bw3PNu3qXlEy1Mlm3200tLGAlZWOu64AOtlMwbqpNQLU0fzBoBTrngO5ptf/SBQ==
X-Received: by 2002:a05:600c:1e8c:: with SMTP id be12mr31607808wmb.4.1638120287275;
        Sun, 28 Nov 2021 09:24:47 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id x13sm11513672wrr.47.2021.11.28.09.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 09:24:46 -0800 (PST)
Date:   Sun, 28 Nov 2021 18:24:44 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 08/29] bpf: Keep active attached trampoline in
 bpf_prog
Message-ID: <YaO7XAwPBmwp3ulP@krava>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-9-jolsa@kernel.org>
 <CAEf4BzbZZLedE+Xbsu5VewtJThEzJZYiEn4WMQ-AjfiGeTAAAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZZLedE+Xbsu5VewtJThEzJZYiEn4WMQ-AjfiGeTAAAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 01:48:09PM -0800, Andrii Nakryiko wrote:
> On Thu, Nov 18, 2021 at 3:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Keeping active attached trampoline in bpf_prog so it can be used
> > in following changes to account for multiple functions attachments
> > in program.
> >
> > As EXT programs are not going to be supported in multiple functions
> > attachment for now, I'm keeping them stored in link.
> 
> can the same EXT program be attached twice? If not, why can't you just
> use the same prog->aux->trampoline instead of the if/else everywhere?

I recall that was my initial change, but it was clashing with
fentry/fexit programs because extensions are special

I'll re-check and try to make this generic

jirka

> 
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h  |  1 +
> >  kernel/bpf/syscall.c | 34 +++++++++++++++++++++++++++++-----
> >  2 files changed, 30 insertions(+), 5 deletions(-)
> >
> 


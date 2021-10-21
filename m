Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188A14357EF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhJUAwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJUAwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 20:52:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04510C06161C;
        Wed, 20 Oct 2021 17:50:26 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v20so17312196plo.7;
        Wed, 20 Oct 2021 17:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LBP5Fct0djt6mKAEsqcCGlc9cav1Q45SnSe6amQOB6w=;
        b=D8p1eYu7WKL5aIY3QZokqwN22izeZJ4rqn010YaHFupnD+2WIt/2bcobqw20XT4OVt
         lg7YFwFdiumPIYDF9Fvjh9eIDzU8QB4jPmoi/GsLYTPrQ60BA/t+3E5PIijAzfkupVOP
         TN+8EUcNpk7Kdjrx99Iydrw3At6KfgJ9OmK1hahJUl4uiTOu3ErDPqmLY+mtcocpQEPH
         ISbTjbozQuHMOa269P/uaBYYO3YjAZZc188CPfjJfpSFXi8aJJJQAb/eP57N+Qr8uK6Q
         9SHyLATS22oLm+yTdGgRygP8e8P4WkEmy2iaD/GrAGTRj+bOuw+zeLGFZe9aN9RDBNUT
         0pCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LBP5Fct0djt6mKAEsqcCGlc9cav1Q45SnSe6amQOB6w=;
        b=FJez0v6+RKAMLTeBpIhOv5c1LyFxOWy6KvNG6BHlPD50fTa8SyLWGlhHdKWaUJYoDT
         wcspnSSPa36TxMaVm30knFNhJnzhXEmZJ7cxzAzA5WKaXCvwInTDMhRdWgBfxNaBREuv
         ccFDgZYWq4K7+8qSF+Uh4s8cfPqtbLZXFC6woAACgWldQL6AlVv/Fyo4zIT82BYmIM0I
         X3ZNN1LBiLvPxESsekna2jDt2LRsps/CpVjW9HhXlKNNKrIJkxFYaHQjDF/0M1v1Q3/h
         7Qars0rCaRm+2BGVGo4l4/pAN+LeoYQLI24kJvJykievIWCW8os+juB46+U6zlrq0qld
         1EfA==
X-Gm-Message-State: AOAM533Pbn/TZgaexEtYtpwL1xKrR4AylrGDylU7vl772hsXqV6B+68Y
        5b0X6U+XllgmbccPUUNCww0=
X-Google-Smtp-Source: ABdhPJywHU/Hz8d43jjpz4uz6OCVKLTqiD/kJIw4bhZUxYU62fExEg+dK86/xdoRwVS3Dbv7PPaEvw==
X-Received: by 2002:a17:902:7783:b0:13d:fee6:8095 with SMTP id o3-20020a170902778300b0013dfee68095mr2293640pll.7.1634777424113;
        Wed, 20 Oct 2021 17:50:24 -0700 (PDT)
Received: from postoffice.intern (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id d137sm4001604pfd.72.2021.10.20.17.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 17:50:23 -0700 (PDT)
Date:   Thu, 21 Oct 2021 08:50:13 +0800
From:   David Yang <davidcomponentone@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] Fix application of sizeof to pointer
Message-ID: <YXC5RS1iziEqPlHK@postoffice.intern>
References: <20211012111649.983253-1-davidcomponentone@gmail.com>
 <CAEf4BzYTNZ=TNqMiGNg_Nj03K9fMM_xnoc=yaEYn8zbyE1rVjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYTNZ=TNqMiGNg_Nj03K9fMM_xnoc=yaEYn8zbyE1rVjg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK, Thanks.

On Wed, Oct 20, 2021 at 10:55:27AM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 12, 2021 at 4:17 AM <davidcomponentone@gmail.com> wrote:
> >
> > From: David Yang <davidcomponentone@gmail.com>
> >
> > The coccinelle check report:
> > "./samples/bpf/xdp_redirect_cpu_user.c:397:32-38:
> > ERROR: application of sizeof to pointer"
> > Using the "strlen" to fix it.
> >
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: David Yang <davidcomponentone@gmail.com>
> > ---
> 
> For future submissions, please use [PATCH bpf-next] subject prefix.
> For changes that are targeted against BPF samples, please use
> samples/bpf: prefix as well. So in this case the patch subject should
> have been something like:
> 
> [PATCH bpf-next] samples/bpf: Fix application of sizeof to pointer
> 
> I've fixed it up and applied to bpf-next, thanks.
> 
> >  samples/bpf/xdp_redirect_cpu_user.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
> > index 6e25fba64c72..d84e6949007c 100644
> > --- a/samples/bpf/xdp_redirect_cpu_user.c
> > +++ b/samples/bpf/xdp_redirect_cpu_user.c
> > @@ -325,7 +325,6 @@ int main(int argc, char **argv)
> >         int add_cpu = -1;
> >         int ifindex = -1;
> >         int *cpu, i, opt;
> > -       char *ifname;
> >         __u32 qsize;
> >         int n_cpus;
> >
> > @@ -393,9 +392,8 @@ int main(int argc, char **argv)
> >                                 fprintf(stderr, "-d/--dev name too long\n");
> >                                 goto end_cpu;
> >                         }
> > -                       ifname = (char *)&ifname_buf;
> > -                       safe_strncpy(ifname, optarg, sizeof(ifname));
> > -                       ifindex = if_nametoindex(ifname);
> > +                       safe_strncpy(ifname_buf, optarg, strlen(ifname_buf));
> > +                       ifindex = if_nametoindex(ifname_buf);
> >                         if (!ifindex)
> >                                 ifindex = strtoul(optarg, NULL, 0);
> >                         if (!ifindex) {
> > --
> > 2.30.2
> >

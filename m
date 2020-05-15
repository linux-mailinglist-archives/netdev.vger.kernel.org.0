Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B83F1D42F1
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgEOB1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgEOB1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:27:54 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32404C061A0C;
        Thu, 14 May 2020 18:27:54 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id v5so394807lfp.13;
        Thu, 14 May 2020 18:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F4Uz8MLGjPkPl0eZl3v170AzoH5MTMZtam5ThMY8fN8=;
        b=ZzoW7o8MgyAO3hdpybN3iAi9nZ49rK7v/S8067JSBaaWxrq4F12K5C5feap2fjwdig
         cHQdiiuiwCmp1Z/NKHakd2o/O1umMGlPPsppSVCGdxegd7RhrLORfluE2N8S40vIW2HP
         O3cb7PYAiL/73k9O2aJbMA934PIHZYtbtB9cx/8Fe+olPkOq9eoNZqQ2MEwMQcvYjeLC
         zgp2ttk4M8G6HyGoHMLcWPBsE/0uhmxQi15YcJw/xy5iQ0lPSXf7HAI+SfojQerIfMpF
         tCKFgiQWThK56g7Qg1wDy80aJsE3e6dUQyd+i19DmGCvF9txSJSCyIMTEI/SWEEhku3a
         ewXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F4Uz8MLGjPkPl0eZl3v170AzoH5MTMZtam5ThMY8fN8=;
        b=WKCEcnD2d0O3BM7QhX9gY5AJqkpbS9DTnTs3EhMKE6jhzrC5mDXp03OnSAb4PZwaRi
         ADI5ChEP3T/xejYkDdB/Vr+Eg+33qGd4Z7lxbso5rMZkge8YZstpkY4bexD85rS2I5nl
         4Efsiy+72Fe9KVdtaA+4ylnhfjxOEQOYVeWk6v3GsuhOjhLYKBv16nsUZAd6gXDuxXyX
         1uV5GJ4TbTOdf8Jh6Qdx42f9CPAkKWq1deJL05nalooTCtYEtMXUGAMwR0OlACO6PuYD
         WJa0ZXaxp4cIatiUKtxjg2c8YCkBwBr8wgUHnHvBbn6OoAWe6cRG05JuaLLf9gq3AjAP
         6+BA==
X-Gm-Message-State: AOAM531HXLMWB6Qep1FqxSvQv5HFG6czlbTMFH+cNYaGh7L+paUed/b8
        UhG2D7aTDBIfbB0az/u7uAfXcAyfSyT4S6gcB/wFDw==
X-Google-Smtp-Source: ABdhPJyEUUpxWSmZHpGf7E1IGLwfKwwg5hgcy/y+WxEt7sUYszeWO2XFh7w1+LQf5T4PvMnf8V3jRyKbz88RIkEjAoA=
X-Received: by 2002:a05:6512:6ce:: with SMTP id u14mr296630lff.157.1589506072610;
 Thu, 14 May 2020 18:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <374472755001c260158c4e4b22f193bdd3c56fb7.1589300442.git.lorenzo@kernel.org>
 <ae2f2aab-5099-0113-6ff1-fe759f8456b0@fb.com>
In-Reply-To: <ae2f2aab-5099-0113-6ff1-fe759f8456b0@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 18:27:41 -0700
Message-ID: <CAADnVQ+seDk1_xGHj9x=-H-pyxS5+f8s_fv6Oht-d+-1uJ3dAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] samples/bpf: xdp_redirect_cpu: set MAX_CPUS
 according to NR_CPUS
To:     Yonghong Song <yhs@fb.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        lorenzo.bianconi@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 10:03 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/12/20 9:30 AM, Lorenzo Bianconi wrote:
> > xdp_redirect_cpu is currently failing in bpf_prog_load_xattr()
> > allocating cpu_map map if CONFIG_NR_CPUS is less than 64 since
> > cpu_map_alloc() requires max_entries to be less than NR_CPUS.
> > Set cpu_map max_entries according to NR_CPUS in xdp_redirect_cpu_kern.c
> > and get currently running cpus in xdp_redirect_cpu_user.c
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7934224E9DE
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgHVUxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728328AbgHVUxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:53:17 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F76FC061575
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 13:53:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a65so1335373wme.5
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 13:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=clh+fL1VRaAXvS7YPj75sxOdd6h5p+Cc2IiViY3r6sw=;
        b=o9F59WuZdNDmx5QsBTy7KpMnsvdroC0zSVfzYTHIzall8m0Ei9+MIncUySVYglsOOw
         ZURRs+MstyOjREksAjD6v9W/KF2mgN+EXOVtrRP1GT4aqHo5z+YpQtzdnlHTZVDG5sIP
         qThvmWqpuPpMY3Czodue0yUYpbaIj52FVGaI/PRY4eKq9JJZv5zXHKP0mklc+R/cMakU
         iNLskVDEPxC6whnJb4CZ0wDh67aNsDSKbQhDbiNyzk+syvqX/TbL0WV/8mZKe1EbnB7A
         4UanKTPVZ//IjNn+K+8hxbwVuoPnOvk1n+dG+o3Jh0V8zm8yzkA/5D8cDn2mTMZTPkwq
         w5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=clh+fL1VRaAXvS7YPj75sxOdd6h5p+Cc2IiViY3r6sw=;
        b=RH6q9dzJJhOl7kICzJAZdLvKULSTvxDCBr1HA7NdMLMDbSEKh2FuJNcUq4up1jNcKL
         +9RScX5U7RcZqCmJwomoEah9f/a1WqO2Ep+yhz06O5J1YPMtTZ+ehFnb/AGNXov7aQsD
         qzJIv5bF1ZtSrPqLJtASsAJN238y53zkhFk7Z70rfks25E91p3r40kGSP1uHkhlKVaSt
         llCM1S6z3VCGvznLkrd6qRmquu7bzzDpI7dM+3W919FGHz6gLMkHdlGeRKqCD1vT+81R
         SCgZmKuKVc5/cx3bOlCULeY5LQdZ4SdmYvqXg5s4Pfp2k/F9XyXbgPDsiScDWn2U1tAV
         j5RA==
X-Gm-Message-State: AOAM530gkyeKJTFERahuh2YAf5G84X97SPsluCPAoYKB39PpZKHQSH/U
        s0FT0o+HvJYWohB7ve1zsp2N6AVNchuHjblUAYtRow==
X-Google-Smtp-Source: ABdhPJxGqq6utU8WqyfsZRBRrqDRcWC5FsWAIIX2J53U6LHls3YyZw7V8x8SbvK3eDFeVayMc9q9UJvF/bVFc5pN+so=
X-Received: by 2002:a7b:c308:: with SMTP id k8mr9402961wmj.90.1598129594749;
 Sat, 22 Aug 2020 13:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200815182344.7469-1-kalou@tfz.net> <20200822032827.6386-1-kalou@tfz.net>
 <20200822032827.6386-2-kalou@tfz.net> <20200822.123650.1479943925913245500.davem@davemloft.net>
 <CAGbU3_nRMbe8Syo3OHw6B4LXUheGiXXcLcaEQe0EAFTAB7xgng@mail.gmail.com> <CAGbU3_=ZywUOP1CKNQ6=P99SgX28_0iXSs81yP=vGFKv7JyMcQ@mail.gmail.com>
In-Reply-To: <CAGbU3_=ZywUOP1CKNQ6=P99SgX28_0iXSs81yP=vGFKv7JyMcQ@mail.gmail.com>
From:   Pascal Bouchareine <kalou@tfz.net>
Date:   Sat, 22 Aug 2020 13:53:03 -0700
Message-ID: <CAGbU3_krnjbeKnm6Zyn-tqYCHVZFBkB+oCP-UF_kVOGz=zkKFQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: socket: implement SO_DESCRIPTION
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 1:19 PM Pascal Bouchareine <kalou@tfz.net> wrote:
>
> On Sat, Aug 22, 2020 at 12:59 PM Pascal Bouchareine <kalou@tfz.net> wrote:
>
> > Would it make sense to also make UDIAG_SHOW_NAME use sk_description?
> > (And keep the existing change - setsockopt + show_fd_info via
> > /proc/.../fdinfo/..)
>
>
> Ah,very wrong example - to be more precise, I suppose that'd be adding
> a couple idiag_ext for sk_description and pid if possible instead

About the pid part -
On top of multiple pids to scan for a given socket, there's also the
security provided by /proc - I'm not sure what inet_diag does for that
So maybe users calling it will need to scan /proc for a long time anyway...

Or is that doable?

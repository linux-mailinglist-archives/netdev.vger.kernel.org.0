Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B18257FBC
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgHaRlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgHaRlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 13:41:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5E3C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 10:41:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so277621wmb.4
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 10:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UlVEKyf6s1sD8/xIJm0Ch/wiRF9CdjE2dCgC1vi2vU4=;
        b=buY9ra+hSxbweF9KIZH811XiLZXcxNPCPRWXLY/iBvEcHG3Mu1ykW2mEJ1ITXYIYOS
         qnphKB05IZV6PJLlhCVhEvxuJo713MZCKGZphS7zrgf7eYVSVYo6hDuDHEgygnfDW/6H
         yfiyPzk7otExE00xEprMnLBkVaErH78YGEOxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UlVEKyf6s1sD8/xIJm0Ch/wiRF9CdjE2dCgC1vi2vU4=;
        b=sUEiDtmBlFKVWiNQ5id+UoYfJlggAuUZ34tTUquzYf4oiL8aw2BuC4EwDhlF17WkZO
         2Omplb4qkmrzHFskWFbc0n8OiYjqe2Z2nSTiskgG1mHXEDxLbP1tk8Vn6aC8otAZuzjN
         Pxnx9RfxTHJ7L+O3DfablaMpu+mLLsXiP3qb2VLy7s8OtrFrquUuktK5/n/EafH1azey
         LKJBs5S/wJqkkxVLcEaZBIPz00hCqorGg6dPrk8P81sh5gFOfOLiVH1tgyQz81PY2nXF
         2wk5XWD3y6HDHmYGWs8vMWYKgAqCPuDWa/N/6qQ2dvf3cuCVxteZll/msQEeRpk5AQ4O
         HHxg==
X-Gm-Message-State: AOAM531AeU4HTDpPOL+HzBM/5A+kUffNfUIajrZmvfUVWjTp4WLmtuvx
        gzgvQumq4cf+/9V7WE65pvXInJIt/49P2aw30HJdzg==
X-Google-Smtp-Source: ABdhPJxfBhwsauqJFNXQqmv0KX8AOmTiS594hNLpiPjb2i+wEBU0qHgsdJxGpxE+AUKNSfwr5dw7jdTK6iRtksb/LGo=
X-Received: by 2002:a1c:ed15:: with SMTP id l21mr435541wmh.56.1598895666527;
 Mon, 31 Aug 2020 10:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200831163132.66521-1-alexei.starovoitov@gmail.com> <3669E0C5-8982-465C-8C33-87015F4D970D@fb.com>
In-Reply-To: <3669E0C5-8982-465C-8C33-87015F4D970D@fb.com>
From:   KP Singh <kpsingh@chromium.org>
Date:   Mon, 31 Aug 2020 19:40:56 +0200
Message-ID: <CACYkzJ7xRE_WMKXr=V7SjBOX0m+V5-csbaa+zzHRAhF2HtYmhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix build without BPF_LSM.
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 7:25 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 31, 2020, at 9:31 AM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > resolve_btfids doesn't like empty set. Add unused ID when BPF_LSM is of=
f.
> >
> > Reported-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Thanks for the fix!
>
> Tested-by: Song Liu <songliubraving@fb.com>

Thanks Bj=C3=B6rn for reporting and Alexei for fixing!

Acked-by: KP Singh <kpsingh@google.com>

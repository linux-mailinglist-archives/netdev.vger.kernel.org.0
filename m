Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B295124C731
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgHTV3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgHTV3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 17:29:50 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D360DC061385;
        Thu, 20 Aug 2020 14:29:49 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m22so3715231ljj.5;
        Thu, 20 Aug 2020 14:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vuN0s3Da0AnT6B0e2RQMk4b+CC+s05ufiDR5tqVHKDs=;
        b=Qv3aziob2eyBkZ7Vs2DlO8HuHuvTFW+OxE9dPfVMofHi4rNWaL4FfykYGLGQZ7pcfU
         mr8lISZcSgDxUkBGSrXKJXcWmvEu6Mc/TFY83dTQL7sv8IVa+7o6uRE6hUYTMhUt6Tth
         MBEVVvntHEyn1wy7HmDv88uWnmC15DaKK+DOrp/JsS2RXgw6fnU7lYe9vEjR4BKMnTKf
         fvlGyCjBdmt1LYqAKlPKYefdQ3WPPSi4Gew9gefNov3mQvdfGs2rf1Q7qJ7S1HwNtvXo
         5nhsiv6UTg2YTrCiQG0HlsvtiRu/I1BY6lKU+t9AWEakpDkvWPtbx+Njsct4YgVrE6ms
         A+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vuN0s3Da0AnT6B0e2RQMk4b+CC+s05ufiDR5tqVHKDs=;
        b=rpnSc47Gok6kVREGtXVVHwk4dA9a5KlaGXjTBfDZHew4qVQkfpKAXzy4qHEGGPVPlI
         3YJ8blIyW+b5TRk5/7Qs7WXObSLNCeWi3ARffYb4NGvLEPNF2kg196qRsNscrMttc27y
         Y/jWWuSeM6zL9dycC2yN/u+Ruk8JTj2d9rGw1zHkNNX/zHLEaNQiPDdRNYe8TL5noX0v
         ydCmXkmlnGxakgndsle7GS4xRGyDtY6kDfq7K8zs+h3j4/gNIY9Zjj1YvXRD0Lf/9IXG
         i2TGcZ1jKs7x44fMbavcUZ0ptm2V8gHZzHRw/Cliyig4oqPuuYr5mDHzl69RQdWxX4SC
         UtDg==
X-Gm-Message-State: AOAM533bmqQwct0I8O2OQWuCyBG4VQJx2BLMXQ2Cj2rN5C6+Tg+LCKk/
        QhMvPBIYw+IrIp/lVZDji2g+hcOPyodnKjmtsCc=
X-Google-Smtp-Source: ABdhPJyOI0oOuo+sqb7SBQLmD1ARwiT2qYKlBXehB15yqB4+rXJjJSkKrOVmga1B4TuBtDt/lr7Y6dXkk2SPrANU9aA=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr112049ljb.283.1597958988060;
 Thu, 20 Aug 2020 14:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200820052841.1559757-1-andriin@fb.com> <20200820082408.GE2282@lore-desk>
In-Reply-To: <20200820082408.GE2282@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Aug 2020 14:29:36 -0700
Message-ID: <CAADnVQKjsRQnFifsYP4qx0UxD67g3UD2oyGfSJa5mv7ny=P-Pg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: xdp: fix XDP mode when no mode flags specified
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 1:24 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device")
> > inadvertently changed which XDP mode is assumed when no mode flags are
> > specified explicitly. Previously, driver mode was preferred, if driver
> > supported it. If not, generic SKB mode was chosen. That commit changed default
> > to SKB mode always. This patch fixes the issue and restores the original
> > logic.
> >
> > Reported-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > Fixes: 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Hi Andrii,
>
> Regarding this patch:
>
> Tested-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied to bpf tree. Thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C888849C65C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbiAZJc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiAZJcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 04:32:42 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1570C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:32:41 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id t9so8772164lji.12
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VBMj6kNPnAsXT4KCcvojdleZo/R9epjnx+Luiy+QWUg=;
        b=hl41LzSXwl0/6IkzJZxlsZQdcl3YmA8fRtB0fi3frmniBg6ULOcv5q7+jnVyLmB4cx
         xSe7rKqHPq1+wTJuVLOWs8j6ACBsugSjdDkIQlfxcWULLnHqmNf6X5mGtk1CBuz4UZrT
         DaacmgNnwPdUh98kJeqQCEgkTQiFZrdV/jPxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VBMj6kNPnAsXT4KCcvojdleZo/R9epjnx+Luiy+QWUg=;
        b=N4zrDg0gWXVHByo9kmYwG9VMdeIYcjlDx+1cwZAz83fWeGrAUrKoLHdd7MkZ9yA5EE
         cCkWbVs+wzmRBgvNpmxided4kOD+0yjJV3319ov1E77tWrllCM9joc+zg2iQPGgVYagf
         tJBEv5h73CMUPIQ7s68jCAu2IjZUTI7eKtNvqlmLazmTB2rXqKbb2TDFrqedZXwwgNEQ
         ULjqRcmweIj0WJaZ712drInrLPUa3Pa3l4HRLBXpL0i10yEjpd14g44wRZ91k7p9KHqx
         Z7mWXF7hrS+XP1iuy3vYk5XtFh4qhQuws1EcGcIKY7RCly8R0abwcFWzZEHlxTJn8Po+
         Fu0A==
X-Gm-Message-State: AOAM531n+4D3SZKOu06fwwVjc7M19xlsU3/6mkvGP3dISpwo9bbEfreP
        m7gW70EPp4BIvHbwVwt7cbZ/frsd6cgzNFOpw7l0uehmUTBUEg==
X-Google-Smtp-Source: ABdhPJwT1x9vtPAArlZ9FqxFhIhYLwmDIZYJexf81w0hGGUxSd6t+RWrwjsXux21tYDQt4gr+ISCjveJNro1QFhOzXU=
X-Received: by 2002:a05:651c:11d0:: with SMTP id z16mr1015741ljo.111.1643189560247;
 Wed, 26 Jan 2022 01:32:40 -0800 (PST)
MIME-Version: 1.0
References: <20220125081717.1260849-1-liuhangbin@gmail.com> <20220125081717.1260849-6-liuhangbin@gmail.com>
In-Reply-To: <20220125081717.1260849-6-liuhangbin@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 26 Jan 2022 09:32:29 +0000
Message-ID: <CACAyw99e+TUxpXcxgrp6PN1G5b+SGxhUWXCKJW7B4QHoqLF+kw@mail.gmail.com>
Subject: Re: [PATCH bpf 5/7] selftests/bpf/test_tcp_check_syncookie: use temp
 netns for testing
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 at 08:18, Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Use temp netns instead of hard code name for testing in case the
> netns already exists.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

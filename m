Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775303ACA7C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhFRL5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhFRL5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:57:37 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3FDC061760
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:55:27 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bp38so16357932lfb.0
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fg1RaSfJDnm+oFtJenKoerkLiZFE4+FFve2MWRbIPq8=;
        b=bGQXWrnHAw1dakSzFzG5w7YPvMRPK9n8R/oUJRdledAo8ktrfduPjgMISVi3LoBaeG
         +EueV/nflnH1P+4IwWVq9+ujSipihpmCmo0KDG21JEepFJEnobIaM6mx6BFrpSdlO41l
         jxhrvk8kcf+9SZMZ8H6gLUdi8XZxJnZXs8ajg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fg1RaSfJDnm+oFtJenKoerkLiZFE4+FFve2MWRbIPq8=;
        b=Xo3Qs4aB/5ETHDsO7qdrtQisVIzgKlFk8+xC9NNjNjf+mhJVyNuSVu6pAg4Id8wbFa
         lky7yPPw+UL9tJKGOCUCKIDsncvKIkHPl/0lCQXsvQVz9RD+KMqqRRZ/DcRtwlr1LWcw
         cpvx2+swcIQ671DSqztGREK/ag9VMSrrL2EoRfwjdZ4p1QFOQlqESfxVFxQqgLRQsE5X
         DwOdG2Am3VODZuPRDN2qA2lUL5Sh2wBbOpshHSorlX6W9fXdqoHtVObmiZhd+FBUs/Ij
         QvhTZsz9AICejmCjzQRk+WL8ACbr5JASyBxYTg0w+JQGBKiOGLp0yahH5L2aTigWBQft
         RdOA==
X-Gm-Message-State: AOAM531bQu4KiasQ1ES4R6/o5zb0lWEshNjC26eRZlv+CiYaUzj03dcZ
        0XkWxNSwBflXbUmN6VF1wCiDbbb5eei2E8MQUIhBog==
X-Google-Smtp-Source: ABdhPJw4CWOVaHmFZ3AuD2s4gaNo5WYGPUvf+kj85rPKZB69FqZZP+Sals7L7eZVEX8geQssux/6sONgBJay+iD3YsM=
X-Received: by 2002:a05:6512:a84:: with SMTP id m4mr2849723lfu.451.1624017326050;
 Fri, 18 Jun 2021 04:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210618105526.265003-1-zenczykowski@gmail.com>
In-Reply-To: <20210618105526.265003-1-zenczykowski@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 18 Jun 2021 12:55:15 +0100
Message-ID: <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com>
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 at 11:55, Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> This reverts commit d37300ed182131f1757895a62e556332857417e5.
>
> This breaks Android userspace which expects to be able to
> fetch programs with just read permissions.

Sorry about this! I'll defer to the maintainers what to do here.
Reverting leaves us with a gaping hole for access control of pinned
programs.

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

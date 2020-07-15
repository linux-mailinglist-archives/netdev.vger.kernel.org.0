Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E103221704
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgGOVa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgGOVa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:30:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D0FC061755;
        Wed, 15 Jul 2020 14:30:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k18so3036714qtm.10;
        Wed, 15 Jul 2020 14:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjW60+gubcNBB6a7AJGYsePrz262R1yPto5TElIKl/Q=;
        b=ghpjkBMEPfSUaX4fAjzh/cXsigdEoAUUlpnUnFdNeC+71Cp5Zs3ITO6tlaULifzXCv
         j0sqxcsijAYAI5BlYs0E1l+1H84aoz1GuoazO4r5pDw6vq/b51S/d8DR0gzDhk1Jeo/M
         MoOxw/AbYjKwD3UyFI7ymvCswD53jtVi8sp5ejZjMVP5TXdKvUcye+GJhg6gpeo7/Xdm
         gVeH0B7fzxVlel0+B3OTQEr/zvTsayBSMZ/uAxW33OieH+niahFP513oul3Y+YvSvgOI
         4aeZ+hpiAYcZ9//nPm5Zb5cZa8rJG1UiGQtzwD3t63nbIs363GfEjfF8rKyU/jn2fJYk
         NaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjW60+gubcNBB6a7AJGYsePrz262R1yPto5TElIKl/Q=;
        b=SYPdy2ZryfyD+jo0vB7wn8uUTYGL4cNd/uYqpa3JxAveZC2BQRHoouC9P7Rjp5GWfr
         MYvI8my7QBNRLkPqJG9Iy+5Y3GpC0CVgt08Fe+J872usu4OLYTANi+MrIMiQ071i73zW
         J7Mas2CAWs/YGKFvABal2owu7hb0NQz0rl3GP1jj/4oQBtFVLZVe5/ex/eBGkWzPisHR
         HXtyJMEIYIQCYafA28c758oEx9NawZZk0wfvjzMmd8DjsGmOCznTP/52R0iuHvK8AR/u
         lYeMG2HDXjFJ5x0QEEiAX4lQW6/2cZgDll+q8QK0fcNhmMl6ouzV8fyz2p5srAhUVqDo
         A1Fg==
X-Gm-Message-State: AOAM533QM71TX6ijkZwiPKl2iGI4FCPgIt2K6LgYOC+9+KSPnNVN0owe
        juhLT3EKDGI7gbew/kCNVvluRM6RM501vfkMN11A2+9w
X-Google-Smtp-Source: ABdhPJwxVVYEmedyQlNdd6acBMdzkVGhcWaAIlUErSZct+uV5P8W/IbkzF7pXnUh8I58dLJvtocqm/ZzwbtbJxzfC/g=
X-Received: by 2002:ac8:345c:: with SMTP id v28mr1915711qtb.171.1594848657701;
 Wed, 15 Jul 2020 14:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-2-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-2-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 14:30:46 -0700
Message-ID: <CAEf4BzZAvt4umMU7S=CAriDsaRkWmYBtAkXAo36KsdqSdCA8dA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 01/16] bpf, netns: Handle multiple link attachments
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Extend the BPF netns link callbacks to rebuild (grow/shrink) or update the
> prog_array at given position when link gets attached/updated/released.
>
> This let's us lift the limit of having just one link attached for the new
> attach type introduced by subsequent patch.
>
> No functional changes intended.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

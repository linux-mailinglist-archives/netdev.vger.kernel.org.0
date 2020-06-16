Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E361FC21E
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgFPXG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:06:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176AAC061573;
        Tue, 16 Jun 2020 16:06:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i3so554503ljg.3;
        Tue, 16 Jun 2020 16:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IzfemeXqDlHUPbdmSdMr4WVPKT+jKIuV0Ha0JwgsTtI=;
        b=nAFRBsEvZ4wcrVqvHtFOErCOkqNUpQy9CRWkrGE+On184PFPYt+sAxdY7ysJZ0FnhA
         ewkS8mtB4N+66o9kxwV36FjGh84b+zB01srJdHeywTHypldgfsrv2xF/K4V1Pdek4lpS
         IbHK73GYDmuyKHjx66qwkhnKTSrTmNTIZrzdFvYzPp/t9X3bNRCMQZJnE296wrtZ1sO7
         FysdozTezi6bSIPsCQld8ToTMysaclnPuBrVXuUh+nsK5j6kFN6tWpvvCiADzNxxUtYB
         t7FKRJe0SXByRc6TAYK3Eym/7yB3hGOhs4l9p+oN0cNH7kgw3eZ+EZ+aa3ixkTHwGiUU
         8KIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IzfemeXqDlHUPbdmSdMr4WVPKT+jKIuV0Ha0JwgsTtI=;
        b=CD/gOHhMgaIdNglC9bv2YXYt3I+TjNr2PYNdDuFgrDDwueo8MT3rFjWO4u+nNVyUsB
         cDvvfZu86Yb6gh9O7eXBv418tjM6UriVg0YIRU7xdv3VGL72btTK81j7As0xq5JxzJKg
         KS/v0u7MiinJUHNxcnewEE/T15RaJL4cGIcmGJy3NkmoQ1Pw7qbPBogbAgfYDwL7WxZj
         yOVp8UFwC2DMTtYDW5UBMbQfSF+M/qlRtC1LcJWBgAl4MBErSHbgjmFWXAhqL/vkLhk+
         LeaappQoyZKS418oiKp3HY39iZfMNyaaUUtK8vIcg4chJ25lff/YaDtu3Io1zIbhgGdh
         IZ+Q==
X-Gm-Message-State: AOAM531sHZyldnRaCERjSFOdP1HmCGHpsdMqxR6OF9FdQGOi3OEBGgTD
        DHg66gBYJ3QbUhCS/km0vlv9thSrgZyerLD4EXN/Kg==
X-Google-Smtp-Source: ABdhPJx3lm9sBIkgzt9xn7HyblO3vX4xqdq5e2QghHemBeP5b03yh+C7PfzTlgRGcr0qE8XPLWoR6CGwDhOYKyilYlU=
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr2601052ljj.2.1592348782558;
 Tue, 16 Jun 2020 16:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200616225256.246769-1-sdf@google.com> <20200616225256.246769-2-sdf@google.com>
In-Reply-To: <20200616225256.246769-2-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jun 2020 16:06:10 -0700
Message-ID: <CAADnVQ+dnOzfY3GBqNFCeFapUP8npRzF9wumeTV+CC5han9pEA@mail.gmail.com>
Subject: Re: [PATCH bpf v4 2/2] selftests/bpf: make sure optvals > PAGE_SIZE
 are bypassed
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> +       if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
> +               if (optval > optval_end) {

same issue as before ?
see reply in v3.

> +                       /* For optval > PAGE_SIZE, the actual data
> +                        * is not provided.
> +                        */
> +                       return 0; /* EPERM, unexpected data size */
> +               }
> +               return 1;
> +       }
> +

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F61E4C42
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403881AbgE0RpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391538AbgE0RpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:45:17 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341DAC03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:45:17 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id w65so14237081vsw.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWSomY7wv64p/JXEgkVAKgEgM9pUufmtEajS9WeLigk=;
        b=BSOrTZPHnzA63lEcKPXFjmJdjVeQI9acycJ4ngCcIz1gVzWPM0GbnMKu9gIsQsKdWq
         XlFn/1oWq568STbkgWuuIw3c0j43kTe971NkX+sRaCzf3gedhr/tREgjdEJokQPHfBXe
         i50LSqpiisl5Yf4Dj/SO1vYhu2uaCAMfEw3NmRS0Fsk5uOWCWBuioiCphJZJMyID463e
         z3Jjhk6JILhfeT+Q4sAT7A34cKqKB6+jUBCCM5y1yuMRJIXshoTsokgcqWvwiRlXIsJa
         szimhZ/MWkzcVUPTiNbMDdsT/hF2mhIW2AHRY5OwhkzHWYwT479ATAdNost82niai1lX
         aA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWSomY7wv64p/JXEgkVAKgEgM9pUufmtEajS9WeLigk=;
        b=rFwr1SFWcyQHAolIkVOp8VqTc8zbCR7ACxqShHpS5cX4iOKNTl/SeuN4XO+OH9Xb4D
         qgyejuLiAqFaCJhaumPixFORQujI9jGgFJgCfeM67raytCLOle3KIzDPlaU8vIQzRRtA
         3rc6zULzgilp0p1SVK0K9rStx0qENCP1kzwAmnvnHPx+1tflA70aSXkx5yD/ZDnTZQjO
         lE2be3Hkr93auM+CamXq+yBy34gOd3UVrhhmyR/Id22EdNfON02Q/VJ9DozUxfxg1fd7
         ZRP/EaGpwwTxhdIqSHT6obclWXAM7jY4fO9Nd5162yZLCQZQYatLCAd9uq9yMGejbV43
         TLdw==
X-Gm-Message-State: AOAM5317wvATuUHNth0UbMzvYIxKDArP2bni2pwll2JJA26+ypJKj+6S
        LzKmrnohGgo6XqxDsZsf0HM9Aeq29Y24n/wk0q//rQ==
X-Google-Smtp-Source: ABdhPJz6BmfwZ6sYgedK4fVPkI/lm4+ikgEYMR8Esd7vFVFJ/zvREE2Tsi2IATX3ik12vwt+g5fRIUx71hi3C0/NRLQ=
X-Received: by 2002:a67:8b47:: with SMTP id n68mr5233373vsd.159.1590601515858;
 Wed, 27 May 2020 10:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200527024850.81404-1-edumazet@google.com> <20200527024850.81404-3-edumazet@google.com>
In-Reply-To: <20200527024850.81404-3-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 27 May 2020 13:44:59 -0400
Message-ID: <CADVnQykrbKT6z11JchcbqGPT1J3qQTWmVwC1Mghuzb2dnXFYvw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp: rename tcp_v4_err() skb parameter
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> This essentially reverts 4d1a2d9ec1c1 ("Revert Backoff [v3]:
> Rename skb to icmp_skb in tcp_v4_err()")
>
> Now we have tcp_ld_RTO_revert() helper, we can use the usual
> name for sk_buff parameter, so that tcp_v4_err() and
> tcp_v6_err() use similar names.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal

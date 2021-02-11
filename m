Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10831899A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhBKLf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbhBKLcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:32:50 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF89C061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 03:32:05 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id d3so7562675lfg.10
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 03:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rg/B6IlH4uz0fziNcdac9aMabbYoLWuxgrUxjDW7CXc=;
        b=HoiQ+o3gG4xt2StqeArENMI8UvHrEOCXVY4VU+7pb//R8cHf7dA/93KTqSFcS9V64o
         BAQ85ZYYPcbHw7hmfaiiI0ZQu3yjtvPp8jY/OZcnwDyDZsnR27AGV5dPRmToPS4QZiQE
         V60E+uhzBH39Hd4/86TKbzrIgz+9x/ZNA67OE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rg/B6IlH4uz0fziNcdac9aMabbYoLWuxgrUxjDW7CXc=;
        b=TNIOQA093qF4E4Ib1A8WIc0l6wv2zXVVwK6NgQHKofxYlnUrubYuZ7Rv2IPMHFM8eN
         vDmNWJSUpf8GhZAt7vCyQHF44lsE5eQs5z273e1hbmRLUhV5sdMv/m5S1UUiVuFBi/Nh
         uz5c6PAxj9wj8F3P0/CsmzpBW7xqg3seC+6eAqXJgVYjIkrpVfTcBaXQEzfi7wvrI5sH
         c2Ny/eqYpip3ctNXN0dMvfYHDa8Eag3+GSkv1h20ck1aitxo8QmTfW6Kb0OLl6/CEtW1
         TkxsGlWWX1kHvrJ32on8YgjSqjMCqcbajjhSqQ8M4NrCENg5hltdDtbkoSd+H9dSBtsb
         dhtQ==
X-Gm-Message-State: AOAM5320K08eWvno23iY8+edSHzcbhzvzgxYXtt1bDPGcZNgOm4WYMqP
        lMTH1igYBbD28+Q1MuQbYfOGaNU4ini7zD2yen+Tag==
X-Google-Smtp-Source: ABdhPJxPi/tKSij5xP/QefWq/ITd9TO+E8QTRbhjQL6ZzrmJW5P3vQkOlN5aGXNCG/e9Xyq/6vh/4ZUdr3fA4x/kcaU=
X-Received: by 2002:ac2:4c17:: with SMTP id t23mr4266367lfq.34.1613043123796;
 Thu, 11 Feb 2021 03:32:03 -0800 (PST)
MIME-Version: 1.0
References: <20210210144144.24284-1-eric.dumazet@gmail.com>
In-Reply-To: <20210210144144.24284-1-eric.dumazet@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 11 Feb 2021 11:31:52 +0000
Message-ID: <CACAyw9-y4kUKgvCvjLPf-JJjFBk_f348OX+Mr2LVdRXq05Kojw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: initialize net->net_cookie at netns setup
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 at 14:41, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> It is simpler to make net->net_cookie a plain u64
> written once in setup_net() instead of looping
> and using atomic64 helpers.
>
> Lorenz Bauer wants to add SO_NETNS_COOKIE socket option
> and this patch would makes his patch series simpler.

This is nice, thank you!

Tested-by: Lorenz Bauer <lmb@cloudflare.com>

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

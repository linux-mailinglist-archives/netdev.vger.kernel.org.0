Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F053F472B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbhHWJN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhHWJN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 05:13:26 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC5BC061575;
        Mon, 23 Aug 2021 02:12:44 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q11so25233619wrr.9;
        Mon, 23 Aug 2021 02:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MaBl3rDtXESKyw3c63bPJNo7dg2UCFCV5le4IG3pXWo=;
        b=GbfZDaKnoXqjjhUOEGzo6BXu3i1+1SjQifDJV8eWlIzQ9++SCfEWOYg6yN7DqLP1Of
         NNunFBtWyyeoeiu2RuJa4zJgKCSAi88wl4IdP11bPwrelZfDo9IDr6H6OZxvH75Z1/QY
         J+9hkFB6rwPKuP9iZcF+rNCzJdW4SOBHQkDA8AOam9zc+qX0L7FHmwOMyR5YVM+uE8/8
         rDPAt3dXUUs1b2CVohBhOfiaTlDTXq/3xX03BPeStge8+5rNKBIHXQzZHdMoDbqa5GC2
         WYWzbbeb6KeCFlSR9kTe3l12UpPO5uxuFpqLfzoIanrPs7y5pJLW5PpRRyFb6YzQBcUz
         nSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MaBl3rDtXESKyw3c63bPJNo7dg2UCFCV5le4IG3pXWo=;
        b=CFHjD31zmEyc4+aSwOrS1Z7QhxE8TQW/Dv9klVhNwHLjr/VXUjqfiN1TdoRQItQcvm
         WCKYdgiFmV1FJyvdhCRxKVWtkZoVi7TqIxlo+bwQEmdDd2ITpUZbuPKk5QMOoHR521iB
         cUnz9MNmu7ZjuMSgIjondf7siHd2PRcABcd0J7SBR6O1KWOfO4jdPhi0wFqHSY+C45wG
         IT7hHXBmfKg5dDivY8hy4F3QdosFDqdDVm++r3Qoh2ALxi/2yZdB4nA8jpK4hs91Yi1q
         5Wm14P7QtC01gFTrWuzObXqRZZZZfRk341IC4YntR/ICBqR9uDH7OPd1nlDBRcfCU0Gn
         jZZw==
X-Gm-Message-State: AOAM530nJnzu0O438KHHc3awN+wJuhOWKOo57VRABxhUhFgoC+OWywbY
        91sxxf+cEJ2Rq3c25MoVJhL8e06zU28B5ffypyA=
X-Google-Smtp-Source: ABdhPJx/j/DPoXGfrlksrZGOAEgqBhPiJRxaX+EvIkOoQpY8+YhkH/EjBvpnNtDixZC8PEKf4CReE3qWZbywjl3kH70=
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr12475463wrx.144.1629709962826;
 Mon, 23 Aug 2021 02:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210823061938.28240-1-l4stpr0gr4m@gmail.com> <13c1df91-be22-f4e0-cd61-7c99eb4e45f4@nvidia.com>
In-Reply-To: <13c1df91-be22-f4e0-cd61-7c99eb4e45f4@nvidia.com>
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
Date:   Mon, 23 Aug 2021 18:12:31 +0900
Message-ID: <CAKW4uUyPdQ9hXeyjnC+5VS7zDaw+3sxy53HwOv2AxEZ7tngT=Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bridge: replace __vlan_hwaccel_put_tag with skb_vlan_push
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021=EB=85=84 8=EC=9B=94 23=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 6:00, N=
ikolay Aleksandrov <nikolay@nvidia.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On 23/08/2021 09:19, Kangmin Park wrote:
>
> This changes behaviour though, I don't like changing code just for the sa=
ke of it.
> Perhaps the author had a reason to use hwaccel_put_tag instead. Before we=
 would
> just put hwaccel tag, now if there already is hwaccel tag we'll push it i=
nside
> the skb and then push the new tag in hwaccel. In fact I think you can eve=
n trigger
> the warning inside skb_vlan_push, so:
>
> Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
>
>

Thanks for the review. I got it.
Then, how about cleanup by changing return type of
br_handle_ingress_vlan_tunnel()?
This function is only referenced in br_handle_frame(), and goto drop
when it return
non-zero. But, the ingress function always return 0, there is no
meaning for now.
If you think the cleanup is worth it, I'll send you a v2 patch.

Regards.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039181874E9
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbgCPVnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:43:08 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35823 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732636AbgCPVnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:43:08 -0400
Received: by mail-ot1-f67.google.com with SMTP id k26so19583649otr.2
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMrl/A4S6Os3YKniWIbLiOD8XUx/BAWQkzygslygIP0=;
        b=Ldm8Vw/ml3LDuNk/Sl8EV0aDsuBxJFUDKM0gcQErgV85iZrIM33vtem51He5gs2qbW
         tnwhCYte5Dq+Cz7Gx6Dpyrom3n0/OAMoLdObTgFsuG/uG0cZr8/UhfOglxf2q+8qweMV
         81cLpqcVi0O3tp4RT7JhlwH+xlh7OM9qLgGEltbiRPQVSZgKa2yR21TShplxtRFjFkio
         1N3/cFGWQ86tVjXq3pEkwXQ+6uRvHPpSLFPds/yBf0Zj8+rCihVrILs7qvjN0ebpx1PN
         A33XMEBEMTaVYJrtMYIfGxYypx42XxzS87mJPJTJ55E1aMCpNLd+q5X3lfYAA5CVOL6F
         SSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMrl/A4S6Os3YKniWIbLiOD8XUx/BAWQkzygslygIP0=;
        b=nJEvbU2lp8rJliDLojXIF2LCweH3nQ9e91Pe5HvJVWIUc2dTrIAWPuTpCk07c9ZIWQ
         882kTzU2v8dgAYAviCeqQl20k30lXy1dvyc1XpCB4ivINKtj1OZHatALZurIzo2ziqF6
         Mx2tU0qxQ+5lI+1+dUTLpKm1JCWom0uEvrmzFkeF+Or+25wjnQ/W8p3GV6sS//DHMkf7
         aqHNZc6sD8kiZ09qoOnVHmXhOnSdDyHlfX91SFQnbMamHwhNrodng6sz/XgLbxQIcL71
         gPeejcRVMy8HyeMRNL0ss02eR4qCDqH38zt7lh6rr6Q43tzAFjz5SH0OoePKJj/3hNSP
         Ws8Q==
X-Gm-Message-State: ANhLgQ1gihDlIWw3BWOn8x5cBTTgGhbBzpYJYUJn7hV4NqpAB+vlOdUY
        PtAJsnk5yvD7oG/kUoX+hNDnc9TgA5MDSAI5HXkBJw==
X-Google-Smtp-Source: ADFU+vsfOUDl2usOfPoCGuD95oqi+EJZczpkiHeGbcNg5IfGGLn0G3tJWv1OPuc56W4ecmTljIjyHuiVxjSNoRZCgnc=
X-Received: by 2002:a05:6830:c5:: with SMTP id x5mr1098239oto.302.1584394985594;
 Mon, 16 Mar 2020 14:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com> <1584340511-9870-4-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1584340511-9870-4-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 16 Mar 2020 17:42:49 -0400
Message-ID: <CADVnQymgwy7+YkLvZ44iq_iO5kFBPqy-Q9hzNEvS=u5p_UBsQQ@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next v2 3/5] tcp: stretch ACK fixes in Veno prep
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 2:37 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> No code logic has been changed in this patch.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_veno.c | 44 +++++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)

Indeed this looks like a pure refactor.

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal

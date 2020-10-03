Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9A2821F8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJCHYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCHYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:24:40 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A72C0613D0;
        Sat,  3 Oct 2020 00:24:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j136so3886973wmj.2;
        Sat, 03 Oct 2020 00:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idnflRHEhQrwO84o8nmaCo8NzWGfvoXd7P5NS/OgPaI=;
        b=mD0/vV560JGwpXE6z2vCuFdlUecEQwIV0cbzIaYB7Uo3e4bBcQiJxU4pPxciOMPYDn
         PoofEITy5cK2ZitwuVvPK06mQGbAYhTxe/1ac8PyiE7rUEZ3QI2sjz4of3FR9OXZCGu/
         Cz+gFhBq//o6g/xk+te23qF3FrSMWp6OFUcigmIzDK3OyJ5NIl1zAmQVni/qe7cHGSs4
         vTGMSrt0WzcvrVCJgn7jWv0+FlRgecwnFh76wY8v3xJs7FjwyTc9jry/lMD4n/IWSUik
         ZVNOT75xCLctv5CCWpm2AGDlk8asp7mguZVm1YT94RkVh17PUjVh5Xz8QUVvTNeAdueu
         qvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idnflRHEhQrwO84o8nmaCo8NzWGfvoXd7P5NS/OgPaI=;
        b=lWWFyTsbvrWWL2eLpwITXCPNaH3RtSr36IBWCoBWDpORmzk6+JYdVhVZTjQTJlOQFO
         4nZG2ya2r9ryp8FDukocHUxXgw2OYhW36hir8LbPhHTZzY6s+wl9Wwe230gNIKE5MYRk
         6HSQfRzkzkljXh5rV8/KWnMEywNpw4986yZ+kUgA3n84LLb8hEuK4yqxKIAs4fTOzXYp
         1aKVw2x7Ccdy3//8LSsAj+6NBI3+tlr5TQJapoK+T/mKOcn7UQwMRArTyKWiqyMwZJKB
         Qe24uj26DaQMRq9nAruXjXrZ7vnNDv8pdw4RRKSaU/bf6ACvEyaPScFh4j+4Qilkv2Y8
         tlJA==
X-Gm-Message-State: AOAM530DHYBIVxvhMxD7srMKnyFpXnaaAWgb7Aj++g1D+LhaUd0+ZV+C
        wWjoBcFiZH/Ddxm1ywJA3fYxx7F2ZrTYHzxV1lY=
X-Google-Smtp-Source: ABdhPJyOYcTGDD0SMefHRmS+5CoQe/msVq2iqbwHj8Cr53ULm8jUfH/K92PCu7mTWgYoa2vyJ0PqnYRHpESfOsenZCY=
X-Received: by 2002:a1c:1905:: with SMTP id 5mr6608324wmz.32.1601709878948;
 Sat, 03 Oct 2020 00:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601387231.git.lucien.xin@gmail.com> <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <20201003040428.GC70998@localhost.localdomain>
In-Reply-To: <20201003040428.GC70998@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 15:40:05 +0800
Message-ID: <CADvbK_c4cStJcjLQr_fA=zo2d9GzRFy42LkeeY3_CVYu7RxGug@mail.gmail.com>
Subject: Re: [PATCH net-next 03/15] udp: do checksum properly in skb_udp_tunnel_segment
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>, tom@herbertland.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 12:04 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:48:55PM +0800, Xin Long wrote:
> > This patch fixes two things:
> >
> >   When skb->ip_summed == CHECKSUM_PARTIAL, skb_checksum_help() should be
> >   called do the checksum, instead of gso_make_checksum(), which is used
> >   to do the checksum for current proto after calling skb_segment(), not
> >   after the inner proto's gso_segment().
> >
> >   When offload_csum is disabled, the hardware will not do the checksum
> >   for the current proto, udp. So instead of calling gso_make_checksum(),
> >   it should calculate checksum for udp itself.
>
> Gotta say, this is odd. It is really flipping the two around. What
> about other users of this function, did you test them too?
Not yet, I couldn't found other cases to trigger this.

But I think gso_make_checksum() is not correct to be used here,
as it's trying to calculate the checksum for inner protocol
instead of UDP's. It should be skb_checksum_help(), like on
the xmit path.

>
> It makes sense to be, but would be nice if someone else could review
> this.
Fix the mail of Tom Herbert, and he is the right person to review this.

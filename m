Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C01B890D
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 21:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgDYTiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 15:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgDYTiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 15:38:11 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F00C09B04D
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:38:11 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id o139so7068798ybc.11
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vb8jkGS62zhjLtxNqBLiSP8Qic4U0L3kG52+bvRtGhk=;
        b=AEHWnujdI+riNO4hhzNeaJrAJrMOLfBhAl3XCDEQvA/h9rV66DrpdLvNdFmDL8Crb1
         qbbv3HUvAu7SDl6UshtbDZ1MprdbNLqg5g4XRLw6foI/dYFB9TrHmkdEscaBKspcmqyP
         /JNfB8nPa15d0v50JOT5TY9HivLIeeYEDTMNyOD8ZYx/RD/lslztEIDMahX1hgJXignk
         2ALYSKAEv4mCopvZyHDdSulWygRpT/A59UFdL1qlnbB3E8WFW7/+owsE12IRNEnUv4um
         HBJ2BoKWYFD9m1XAEI5EqyYq2wdqwST3hs1J9cQK5kumX+1zKKCbmMCBazfWni3uCImE
         YtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vb8jkGS62zhjLtxNqBLiSP8Qic4U0L3kG52+bvRtGhk=;
        b=tYeOXFG3Hy4lEnkgIjaF4ozwo0A2tN1CmsP2XlY4ycRb7OdSVVHViJ/bfm+vc0M/qQ
         DvFR9Rqr9aKtu/OJC59UK45z5bjz+lEdI+FisV+lxi2JqoEgdA1QK+Do+9e3gY9fU4wb
         YayMfVG+os0tTyuZMInbGXX6FMoy1fwvzMbSLxk/QlYIlLfC6/EyGDBFHCvm7V+ZxZXq
         A2Hc/OmqsdjSrMwtbYSUw2d6SbWBSpZA3kI/smfjD+KZyeaPAySK012d6GUvkMlJxhNK
         2Efurw0e3Dq4Z6Y/PqZ7eF1eSO66XeJYyXsuKBZBiTwaIQZwCrAkIw0Gm9MC5lF/nJos
         YILg==
X-Gm-Message-State: AGi0Pua5B84Luoa4tqWGjDggYYP2JKxtXoSwKjDlWzoN86eHAv1x+YsD
        OgYl4JdZS3tijghnpzxqR/rz1ti0aBBgZ0f2fzxvdwRC
X-Google-Smtp-Source: APiQypKu6YRsLJMsPegeO8fOMosIuMwSf8qrJyUG0I8UYU3cFziwWSoq9a1m8yhqpI+9c4AfV/bZE0jBbC1bIle30YI=
X-Received: by 2002:a25:71d5:: with SMTP id m204mr26700827ybc.101.1587843490341;
 Sat, 25 Apr 2020 12:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200425192300.46071-1-edumazet@google.com>
In-Reply-To: <20200425192300.46071-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 25 Apr 2020 12:37:59 -0700
Message-ID: <CANn89i+Zj55pShGJqVMPAE=Nic6_tr77i41D7bh_QpNPJc_MTg@mail.gmail.com>
Subject: Re: [PATCH net] fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 12:23 PM Eric Dumazet <edumazet@google.com> wrote:
>
> My intent was to not let users set a zero drop_batch_size,
> it seems I once again messed with min()/max().
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Sorry, apparently the Fixes: tag did not make it.
Will send a V2.

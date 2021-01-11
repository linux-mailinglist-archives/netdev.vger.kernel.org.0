Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252532F24F8
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405417AbhALAZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404035AbhAKXWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:22:51 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44876C061786;
        Mon, 11 Jan 2021 15:22:10 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id q6so160462ooo.8;
        Mon, 11 Jan 2021 15:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DgansWbp6EOOMIZIYLe9Evg4g8LF/aKPN964N6EgpBA=;
        b=FoK1zRX4zHNP4qnwUUxF2VQM7D/dgBKw6gjLE2cC5Dv4qXeTWIWNlGwPnwt/D27rAb
         BtUacUcmxUQxKceD0vDirm9Ae0Qj4Gz9PRw7MaxnjnIvoIrOaIpEcjc/Vax/xJ22LjXo
         8ep2Gk03LqxKZ/CHnXHANp68KaOSlYsvYY3C/8a7m9XGZHrlwl/UJU2gy5ITN5E8CYTG
         3gzrCHExRqOJzHF5oTJaqkYRA4jiM1HY/Ybrp5VkjU8z1mmOLt39rmINzP7bLtYPEyeF
         HLhOGCqcxCyGAD/jCuRqbejv5OXh/z4Z2k5v0/opSaCvjY7aQhr7szNj51v6Wfonfccw
         ty3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgansWbp6EOOMIZIYLe9Evg4g8LF/aKPN964N6EgpBA=;
        b=d2bDyC6STI3dvzmwe56Cal/fGMQPPadvG2AoHZLNz7SrTuhdAh67lw5K3b+8mZ/22L
         4S1HI8wB24s52FSE53rGhIcUw9iSuKbaw/0mW5FvOaHQddrxULVIJF3Mn83VTjYdtETO
         Bj1KGUGookPR2SDzQRGSO5ibDw9i/nAnUybTxsjxiG6mPvC06EKrQrHbaKeCmq9rIjcn
         xu/15YoZjdJsyD5acnQUAroINF90VtphEmG/Vq43+qCh1EAUCFNiSqec/6UJWL2l7Thj
         nC0XgLVyqAIYXHd7I+qT2iFE5Y/3t56Sl/5e1KHdiAd3rnWYMzRamnbkXhweUM8ZX1Ya
         8xHg==
X-Gm-Message-State: AOAM532j4/l+IwgxmIW9suwxpNYDSl0vc4pu6KoNLHOfW7s3oomDdPk0
        /QpRfxwb3Xki4EhXx6LttyU=
X-Google-Smtp-Source: ABdhPJyRhVT/ujecpFERa/iukIarjWSSPEjeAeEgl4z5V3GI+c04/xFmGwsQ5mDTOWaZ45A6SnIXwg==
X-Received: by 2002:a4a:a3cb:: with SMTP id t11mr1047467ool.30.1610407329633;
        Mon, 11 Jan 2021 15:22:09 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id z14sm223857oot.5.2021.01.11.15.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 15:22:09 -0800 (PST)
Date:   Mon, 11 Jan 2021 15:22:06 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>,
        enkechen2020@gmail.com
Subject: Re: [PATCH] Revert "tcp: simplify window probe aborting on
 USER_TIMEOUT"
Message-ID: <20210111232206.GA3279@localhost.localdomain>
References: <20210109043808.GA3694@localhost.localdomain>
 <CADVnQymUn1aKoA4nW8dhEi-fUXNCbr2--vDEmmMtHHXGp2AFNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVnQymUn1aKoA4nW8dhEi-fUXNCbr2--vDEmmMtHHXGp2AFNQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Neal:

Thank you for testing the reverted patch, and provding the detailed analysis
of the underline issue with the original patch.

Let me go back to the simple and clean approach using a separate counter, as
we were discussing before.

-- Enke

On Mon, Jan 11, 2021 at 09:58:33AM -0500, Neal Cardwell wrote:
> On Fri, Jan 8, 2021 at 11:38 PM Enke Chen <enkechen2020@gmail.com> wrote:
> >
> > From: Enke Chen <enchen@paloaltonetworks.com>
> >
> > This reverts commit 9721e709fa68ef9b860c322b474cfbd1f8285b0f.
> >
> > With the commit 9721e709fa68 ("tcp: simplify window probe aborting
> > on USER_TIMEOUT"), the TCP session does not terminate with
> > TCP_USER_TIMEOUT when data remain untransmitted due to zero window.
> >
> > The number of unanswered zero-window probes (tcp_probes_out) is
> > reset to zero with incoming acks irrespective of the window size,
> > as described in tcp_probe_timer():
> >
> >     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
> >     as long as the receiver continues to respond probes. We support
> >     this by default and reset icsk_probes_out with incoming ACKs.
> >
> > This counter, however, is the wrong one to be used in calculating the
> > duration that the window remains closed and data remain untransmitted.
> > Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> > actual issue.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > Reported-by: William McCall <william.mccall@gmail.com>
> > Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> > ---
> 
> I ran this revert commit through our packetdrill TCP tests, and it's
> causing failures in a ZWP/USER_TIMEOUT test due to interactions with
> this Jan 2019 patch:
> 
>     7f12422c4873e9b274bc151ea59cb0cdf9415cf1
>     tcp: always timestamp on every skb transmission
> 
> The issue seems to be that after 7f12422c4873 the skb->skb_mstamp_ns
> is set on every transmit attempt. That means that even skbs that are
> not successfully transmitted have a non-zero skb_mstamp_ns. That means
> that if ZWPs are repeatedly failing to be sent due to severe local
> qdisc congestion, then at this point in the code the start_ts is
> always only 500ms in the past (from TCP_RESOURCE_PROBE_INTERVAL =
> 500ms). That means that if there is severe local qdisc congestion a
> USER_TIMEOUT above 500ms is a NOP, and the socket can live far past
> the USER_TIMEOUT.
> 
> It seems we need a slightly different approach than the revert in this commit.
> 
> neal

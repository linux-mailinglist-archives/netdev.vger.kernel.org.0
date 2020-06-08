Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2831F1CF0
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgFHQIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730322AbgFHQIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:08:05 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F92AC08C5C2
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 09:08:04 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id w15so10529028lfe.11
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 09:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ClSQBWTNKy6QM/u0O+83mkKXa/fUb2mZhnsBDib3FXU=;
        b=Wj7uIHi3iVob7U2MnpWEYNidthbOPgWUvDSYkULGV6+X5T7T2QDw4sHvTkrkAIv0Ab
         6Fg0K6exQtytZPQKO34LagmdPRaq460ZHKWIsEukUVc/6/emrmYy/9IVYBXfE7+n142s
         THP8lUfiXgV4DF0FjAkuCp2x97R1OfEHEVP/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ClSQBWTNKy6QM/u0O+83mkKXa/fUb2mZhnsBDib3FXU=;
        b=qbURH6k2vaWn38pWOD/Vs/9q2y0tJMxv4sR8XqSyrvU1iwuQ/1OEWcVqk9wwMgHSaB
         RdMjj7REuIBjvg21gU4p+a7A2CQ/W5CaBToROiwbFGBtrB3WWUQxGUkNulnR9rcO/FDU
         YXPtS648u9oxcl/i7u/oXATsiUGCX357ib0RE3ol4PHEElQKQVxQ+AQRm0ikRoLhxmT4
         kYu0whirii9YHgJiCttfPNnbMF2D4iG4FrGk1J6RuP4j7lpkMa5HTnhSpPeQKkvF942B
         Z9GiJj4FdBkch+hdlebXSzDNgEUsEjnDPaAmCB1j8NAwmUtgZugH3GS0T73RSJT2njeu
         rfMg==
X-Gm-Message-State: AOAM533VfP9nrOd7RuZaE9LUJfOeibeRAJvUxmOK770iYRtYB6i64ba2
        eVapovHPdRqt30IwDh2gCf2v+Ju9dMk=
X-Google-Smtp-Source: ABdhPJyfxWQApqG5k50E2SK4qsjVXRwjux4SineCcpB/67KnFY3SBrvN27HniI9/q/bWiCG5hY1ejA==
X-Received: by 2002:a19:8447:: with SMTP id g68mr13345552lfd.132.1591632482800;
        Mon, 08 Jun 2020 09:08:02 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id t16sm3791637ljj.57.2020.06.08.09.08.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 09:08:01 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id j18so8134459lji.2
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 09:08:01 -0700 (PDT)
X-Received: by 2002:a2e:b4c1:: with SMTP id r1mr6601345ljm.370.1591632480876;
 Mon, 08 Jun 2020 09:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid>
 <87v9k1iy7w.fsf@codeaurora.org>
In-Reply-To: <87v9k1iy7w.fsf@codeaurora.org>
From:   Evan Green <evgreen@chromium.org>
Date:   Mon, 8 Jun 2020 09:07:24 -0700
X-Gmail-Original-Message-ID: <CAE=gft76Nqo93QvvXU9xU-6sY-Q88H4RezMx8G6MWSBE7vJDKA@mail.gmail.com>
Message-ID: <CAE=gft76Nqo93QvvXU9xU-6sY-Q88H4RezMx8G6MWSBE7vJDKA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Acquire tx_lock in tx error paths
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Govind Singh <govinds@qti.qualcomm.com>, sujitka@chromium.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        Michal Kazior <michal.kazior@tieto.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuabhs@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 4:39 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Evan Green <evgreen@chromium.org> writes:
>
> > ath10k_htt_tx_free_msdu_id() has a lockdep assertion that htt->tx_lock
> > is held. Acquire the lock in a couple of error paths when calling that
> > function to ensure this condition is met.
> >
> > Fixes: 6421969f248fd ("ath10k: refactor tx pending management")
> > Fixes: e62ee5c381c59 ("ath10k: Add support for htt_data_tx_desc_64
> > descriptor")
>
> Fixes tag should be in one line, I fixed that in the pending branch.

Ah, got it. Thanks Kalle!
-Evan

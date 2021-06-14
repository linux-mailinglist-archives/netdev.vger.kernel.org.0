Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7AD3A6CA2
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhFNRFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:05:38 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:44938 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbhFNRF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 13:05:29 -0400
Received: by mail-oi1-f180.google.com with SMTP id a26so14980691oie.11
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 10:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qUD1nzeCJjz28MISB5nQ0Rc0a40kxWRVNB9uQtzdX7M=;
        b=b9HRtOmxIpZjMLYild1RTE/eKbG/RgKq2v6xZ7r8m3BS91ZL+dU1zOvCsw18LE8Lfe
         ljAui7fBDbS7Hn3zfvvEDom3aqWhZfr7jkZfWWHVpdUxLI1QXX9R36it7as4m+QS7j3a
         hPNx0tVG2IpU75NIykWf78YxOtH5Vt6Cn35i7Qy67IqQvwc2at5pzaJr+PjLdBC3dofy
         7ju7dvXMtKZJDEJctgRwlLA71PG4wxLVAAoDTGyLlk1wOZB2EBSqYDpM6RgVosCHyVDr
         xYr7PTasWvvKrjkCRA5vF8YTq41Rqfj00cTgJKwbukOa2bb8ZuA3KfC7zRGenp9acjAW
         LPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qUD1nzeCJjz28MISB5nQ0Rc0a40kxWRVNB9uQtzdX7M=;
        b=oOczppcunGuBHIc5mnolvopT+RJMGOPVD4E0IJOVFWbZtZYxeWaLEe2a2nG7/X2YcN
         rG5szRB87hCBBugIdADnZ58aPDpfZnTQACwC0pFQpBN0BE3im6PkikoRHIeMWfRlCWT4
         4bd/xB5hrHfwlIWZaemG/Sf6adFRZajkUju0eBgEKdMDJlxRjXmLvYa+CKCRW1upY4v2
         H2wGYYpufh0PqTPkkoz5VzPDElabF06GgJxkhFaclN0YazKad89vbeDqnzC93BxCCFnC
         3xE2wTut8kL/kGXHWNfRmzHTbEej3KBkDRiiM+j0jp6c7AaufUGPL1Q/KoT+eZyE9JVa
         pJ5g==
X-Gm-Message-State: AOAM530nYsyq5INCyyAfo+2sLaq8m0avi7WOjjhGtCwRmUWtMDiTdklo
        hlYIVci4rRq2jyqs4J21rs46STISaX34jnOCVLg=
X-Google-Smtp-Source: ABdhPJwWl5vo8sBvjdzUr9bzwt2xnzRvFbkTdhcE+rcxhhc7bjn2zux4cSKeLWPEGlKSjNcHacw+NjwtU1frRr+1LsQ=
X-Received: by 2002:aca:b8c2:: with SMTP id i185mr56981oif.172.1623690146603;
 Mon, 14 Jun 2021 10:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
 <8735tky064.fsf@miraculix.mork.no> <CAKfDRXgZeWCeGXhfukeeAGrHHUMtsHWRPEebUkZf07QCnU4CFw@mail.gmail.com>
In-Reply-To: <CAKfDRXgZeWCeGXhfukeeAGrHHUMtsHWRPEebUkZf07QCnU4CFw@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Mon, 14 Jun 2021 19:02:15 +0200
Message-ID: <CAKfDRXi=4Vsf_a40EdLsyunjKGXaFnA0ZeNbMcBDw1Tk+eSzMQ@mail.gmail.com>
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,

On Mon, Jun 14, 2021 at 5:49 PM Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> I will do some more testing tomorrow and see if I can figure out
> something. So far, the only thing I know is that if I try to perform a
> more demanding transfer (like downloading a file) using qmi_wwan +
> rmnet then I get a kernel oops immediatly.

I got curios and decided to test your proposed changed today.
Replacing the call to netif_rx() with return 1, and then letting
usbnet_skb_return() do the netif_rx() call, seems to have resolved the
issue. At least I am not longer able to trigger the oops using my
earlier reproducer (running a couple of Speedtest).

Unless someone beats me to it, I will prepare another patch tomorrow.
Thanks for the help.

Kristian

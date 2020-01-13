Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73AF138D2B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAMIsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:48:09 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38052 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgAMIsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:48:09 -0500
Received: by mail-io1-f67.google.com with SMTP id i7so507953ioo.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 00:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o0tbvY1aV0QQ4gVPbOQCDCzaP9ZJPdbkW+kTe+QTV6I=;
        b=Lua+pi38fYAeS5+Bri+c/VX78RyWKX/+XLA1hJuno0UwvpCcL2kF1yr98AdgDLWS/j
         x3BuiLXKIuXeswDbu6JcofAHtMnS4Q9a0NtlIzCylLcxAMd6ARb11WBMg4uXIMvXtHTE
         H1UukF7ENUBKls+txxeDkm1gi4IBFUGB27cq9zF0vlT5CsjcPnTuPxevgpfqYzwTym57
         zQNJtJ1bL1O7HfZNsELX/cbhpKnfG10LGMoTuY18kF351MAglfPfo34ULCWVqU944IqE
         Dof2dbgHZHGhMe0aDu9HRYpYfD0erMs3RhEv4CDdvUIC83wMaf1FRwpbVFN6o60z8nSR
         bbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o0tbvY1aV0QQ4gVPbOQCDCzaP9ZJPdbkW+kTe+QTV6I=;
        b=UOtzzUEq5J1kUwH60Fm6iK/+mvrh6p7on+W7g4k+x5rH9eG0Y6HJ2pSavNHz7Asg6A
         0S/ePTBXyz24X7lTNofgZBw1r4bdgi+0BjhpcmIviXgRW+ZtKPWNn2Yezeyii8ZwXMaZ
         47jPxC74OZ05zPSNHn5ZP1QYoJnXVh0bWBt4/e1iEoLT2L1JnnKmxSX/C9ojIjdTsx65
         itPwTc8uJC78ZoqDtIRfQSfIAq/Zr+n0QTzM5u+5eMvx+bpHXnOUPHWNYiNCzisfX2hc
         WQntzJR3xxBIoTPf72LDYNSD2gUezITrRmh+iz/l/0JJdfzqmPm+sQuS5avZj1oMB9tx
         L82A==
X-Gm-Message-State: APjAAAVbZtgtJzCtkQlnEo4c/MFBfc54A1UoTyY4XUIYPwBdDFmLZpFY
        pOeTZ7gBPh4nAQltw/v/xovkuA3SJ9ueACqDSGZAVw==
X-Google-Smtp-Source: APXvYqxFyWFQjjr101lDPHux865PaT2IY87BRRl/DMxxdMcbCOnDXO0BS+lotVVy71XD6mxnZA7W3qnHmlt/xayABlk=
X-Received: by 2002:a6b:d214:: with SMTP id q20mr5948941iob.298.1578905288965;
 Mon, 13 Jan 2020 00:48:08 -0800 (PST)
MIME-Version: 1.0
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com> <20200112125055.512b65f6@cakuba>
In-Reply-To: <20200112125055.512b65f6@cakuba>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 13 Jan 2020 09:47:59 +0100
Message-ID: <CAMGffEntn9nQAUk5ejEiEfnSjGda20rqQVi-zNu+GFr3v39pAA@mail.gmail.com>
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev <netdev@vger.kernel.org>, tariqt@mellanox.com,
        "David S. Miller" <davem@davemloft.net>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 9:51 PM Jakub Kicinski <kubakici@wp.pl> wrote:
>
> On Thu, 9 Jan 2020 11:23:17 -0800, Jonathan Lemon wrote:
> > On modern hardware with a large number of cpus and using XDP,
> > the current MSIX limit is insufficient.  Bump the limit in
> > order to allow more queues.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> Applied to net-next, thanks everyone!
>
> (Jack, please make sure you spell your tags right)
Checked, It's correct both in my reply and in net-next.git.

Thanks,
Jack Wang

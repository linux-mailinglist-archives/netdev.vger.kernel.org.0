Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F436F8B2C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKLI46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:56:58 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42593 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfKLI46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 03:56:58 -0500
Received: by mail-qt1-f194.google.com with SMTP id t20so18935416qtn.9
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehqq8IaZ/5dSL//9xwGmnF4fadf7SCRUUDA3N7vZ7A8=;
        b=XbmmTe9tJNwvAIP0H2kHJfpgxuoiAchUrT/hgItf2F4kfvAf2U83buYKUcG76/pxCL
         nxQ8NR0uPsQKifJ5kyZPEu0XIUSGOkhP8MUHO/tCN4EYVm22/e/UI2x1uGuThmokemsz
         KLdop2Skw6qGwXN35vmsQjxMrNlQFi4LCUquvkEes0yZG7WoC/0V8mKE0XobD9W2HkKn
         ewbg2sT73/VDRblkbCIBq83YHBPg/vLx3Qng8wfg4au17z/IOQeaahj/t29XLi4c5czl
         zSlXnEcjpNuZn+POx+Gac4A/r2RzHgDIhAuqAAeEdRigSvn7HVubXHyGWQpxdxuCTzpK
         1/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehqq8IaZ/5dSL//9xwGmnF4fadf7SCRUUDA3N7vZ7A8=;
        b=pvhWBDBrgrEM/FBbC1LK5alghT3vBKXwC+GjindGB/DXSNYybtyPI9mXJ1Twov4kYY
         31jEjadGjlOAcPTmyr9TuinqvU1zMZtCFtYf1h1yoSxpzRiy6+kEljtUhYbTaLQYnDfc
         54Ax9pvJeGUT2BtGPnmryJwUrb/Z3QbhSQV7LEcW9s+HXLNhMhUACOHKW9+0f8OUjEfv
         kOX+bo5eD59sbpagNDP/RnnhCe39QJo6YCkwnjZszwzjou0nz3Pcelu59TEwk+J6LaS0
         fS2m8Meocx1qwzaqJc/5hdNdbCVzZSGyQMVO36dD3F1/tFmR5G4P+L6oiu3puoZe8B5p
         Jpdw==
X-Gm-Message-State: APjAAAWaKccCAQgRwCpNk5E7qRmHyyLg3sloURy9S8Iz526abkeqo6rm
        Q2usNiWvB+zYfAa1EeOxIhWuJ1FvK36oOYSm41IrlfSZW/E=
X-Google-Smtp-Source: APXvYqwNsgcTK3qOcfmIaZDIkVv0vQHtN0QmMOy2DK33HG94UjGKZQI0NZPo194mhENov4l+mCmgyV/GpQ6mp7Tycyw=
X-Received: by 2002:aed:3ae8:: with SMTP id o95mr30387057qte.277.1573549017191;
 Tue, 12 Nov 2019 00:56:57 -0800 (PST)
MIME-Version: 1.0
References: <CABT=TjGqD3wRBBJycSdWubYROtHRPCBNq1zCdOHNFcxPzLRyWw@mail.gmail.com>
 <CAM_iQpUpof_ix=HJyxgjS4G9Mv5Zmno05bq0cmSVVN9E_Mzasg@mail.gmail.com>
In-Reply-To: <CAM_iQpUpof_ix=HJyxgjS4G9Mv5Zmno05bq0cmSVVN9E_Mzasg@mail.gmail.com>
From:   Adeel Sharif <madeel.sharif@googlemail.com>
Date:   Tue, 12 Nov 2019 09:56:45 +0100
Message-ID: <CABT=TjGn8S3jy4bw6ShRpYJdcE3-H4fNaxEPGfNaxiEcxBtPrA@mail.gmail.com>
Subject: Re: Unix domain socket missing error code
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should but it is not used when two different sockets are communicating.
This is the third check in the if statement and it is never called
because the first unlikely check was false:

if (other != sk &&
        unlikely(unix_peer(other) != sk && unix_recvq_full(other))) {

Thanks.

On Tue, Nov 12, 2019 at 1:12 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Nov 11, 2019 at 5:41 AM Adeel Sharif
> <madeel.sharif@googlemail.com> wrote:
> >
> > Hello,
> >
> > We are a group of people working on making Linux safe for everyone. In
> > hope of doing that I started testing the System Calls. The one I am
> > currently working on is send/write.
> >
> > If send() is used to send datagrams on unix socket and the receiver
> > has stopped receiving, but still connected, there is a high
> > possibility that Linux kernel could eat up the whole system memory.
> > Although there is a system wide limit on write memory from wmem_max
> > parameter but this is sometimes also increased to system momory size
> > in order to avoid packet drops.
> >
> > After having a look in the kernel implementation of
> > unix_dgram_sendmsg() it is obvious that user buffers are copied into
> > kernel socket buffers and they are queued to a linked list. This list
> > is growing without any limits. Although there is a qlen parameter but
> > it is never used to impose a limit on it. Could we perhaps impose a
> > limit on it and return an error with errcode Queue_Full or something
> > instead?
>
> Isn't unix_recvq_full() supposed to do what you said? It is called inside
> unix_dgram_sendmsg() to determine whether to wake up the dst socket.
>
> Thanks.

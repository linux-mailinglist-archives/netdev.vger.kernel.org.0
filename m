Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECAFF6AD0
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfKJSf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:35:26 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40633 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbfKJSf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 13:35:26 -0500
Received: by mail-qt1-f193.google.com with SMTP id o49so13197103qta.7;
        Sun, 10 Nov 2019 10:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YDEA+luNacr7QwPtDY48QKwRiAJxb2dNjh4HN7LfjPg=;
        b=Rp/G26EhX86QtswbNAGpkYjvY8XjrOen94y9md8JgUYVFW/ofAIx8F8pIm9MMnEo9b
         61/+70EM787Dq+U9mcXx8AjZoMH3/6MyQY5dknj1dMbLze6VdQzd+O31hEkF/tbDn9Xy
         KYjgU38/Yz7KvewzpQYh6m5I3qDlFr+OeQ5jvPATQ25xme0F5Dvlna+bVGW6AdtdtLhA
         YFs+F3tIOKH9EWKP7/7JhfmlwaqDwgrPcN8+8dFxFyUg6egxSR1v0QAZsj2AMQtIO0qt
         UDZmWDgRDcLKVpTX3WLVHD3lmaqde/XlJmJggeQ9mi+Z9nJICyWBv8nsSjOAzWOzuUme
         fB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YDEA+luNacr7QwPtDY48QKwRiAJxb2dNjh4HN7LfjPg=;
        b=YuSDfzF/HqIEiBHAcIpLFvXKHYemmDqc5i3i7+BALVNCp4MSfZynVeomKFeyAGPn4C
         xEv+ee3Drj7IC8NrHNI90GbIXTxlMAD3nV1r51klKKams4YJjIQK/7Rh58tee3hEQRjX
         3L/MN3s4C9QgyOk3GBkHcZaeDeZ5pnV7cIeJ5UpV1swycwh0EjhiR/3U2E+spyPYBEeR
         otuEU5CjJGw3JxrEMN8WJyr14MgMxnVUC7NBbQdd1s6nCPPA/yASWpxwztwid4LIFFdS
         WUTBouNS3drY7v/C9apjVBrZeKgUfTIi30k4b6uN2M82/42XhKLbdbXsK6yZzj3tRpmL
         ieaw==
X-Gm-Message-State: APjAAAWQu8xl/3HTw45RxXK0GJxpVBXpKCFrKIMoS+70omLyDxZ2KmyG
        5P/Q7BpQMxnrgsgdczHYuc/qas+4DZv4x8rnd2GA+r9tflc=
X-Google-Smtp-Source: APXvYqy+oFIlIjca6UBaXY12cnDBGnAtWU8/CPNyf2Ns1oTRhrxrn2uIcUPzRciOEitAQEjKLR16nJKXgweYEt7OiOc=
X-Received: by 2002:ac8:605a:: with SMTP id k26mr20744677qtm.212.1573410924975;
 Sun, 10 Nov 2019 10:35:24 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-4-git-send-email-magnus.karlsson@intel.com> <E9A83A68-F43B-495E-8BFB-0DFC956C8444@gmail.com>
In-Reply-To: <E9A83A68-F43B-495E-8BFB-0DFC956C8444@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 10 Nov 2019 10:34:46 -0800
Message-ID: <CALDO+SaRuMxeZXxDp4xHHW1pp2JmsO6t4vbza2FgpA45_7v-nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: allow for creating Rx or Tx only
 AF_XDP sockets
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 3:00 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:
>
> > The libbpf AF_XDP code is extended to allow for the creation of Rx
> > only or Tx only sockets. Previously it returned an error if the socket
> > was not initialized for both Rx and Tx.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tested-by: William Tu <u9012063@gmail.com>

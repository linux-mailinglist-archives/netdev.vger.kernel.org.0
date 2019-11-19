Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86C10116F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfKSCsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:48:16 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34246 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfKSCsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 21:48:16 -0500
Received: by mail-io1-f67.google.com with SMTP id q83so21458946iod.1
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 18:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UAoADNZWJ+NPMJNsOUelfZUZ8FK5v+GdTQzUf+W/L7U=;
        b=L9Pvwcw555rdY3NaC7wKA/C+x6hTyZGjpSHT2nC5URdLDw+luOXgVEoxK4qorCQcS9
         T2He1Ned4dAj3FJIAUxBDPFEcdAXX2dWsZqrsSm4N5tUPIWYSu4ePgCMp0Lg5psPHoy1
         qsUXyjxQC6Bon21ZoMa06yaVjxAEl38CjKMx0L9hMMngHOkoHhmwi3m8JOYjpgbIfFvm
         PfXTirvL3mD27SZZMWDOnmlq1fMYKnFUySLjCLhdTizynKL0nT/Cv3qorTBSLLBmvjes
         gHmMdtHOSh2UKoiLifjSt6vHAKmtjfWLjx6AlUzy+fhImX4Wrt1exWxCNyiIaqof9vKZ
         WfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UAoADNZWJ+NPMJNsOUelfZUZ8FK5v+GdTQzUf+W/L7U=;
        b=LdLZ/o806JPCIjVond1I+nZmN832T6/W0N1HnMutmfdyGWVaZ6f+esbsI7mD8z8fqq
         g6OUjghzu9lLp99pefFQKzEzcGBo36+tvZR3Y6qrL2fP2k4zwdxTrCQbNfJTiMtdugnl
         E5L3ESMdnBsGyO6BzoRJpApfe9Lb7i14xuHiIFpOr5GtNz/U5csnU1ALQh/29sX0nIPw
         F8B4bHl9Z0b25nWHsIV/OrsHi8TrKRbeqrq3qEW/f1/t/AsA4CYCeBHw5TIzLTf5U7iA
         MLkzbojjg+5Br7lO3Doxvc880eJ6VxMeKjyflXHKLUqwJHNPDXqqdmW0NQ3b6k+HH4OG
         dyAw==
X-Gm-Message-State: APjAAAVaJBflfqbHXH5lbJlxncqYHmqAbISW1gk5yjDrNjhWMoG+22mu
        dq+qIXZU/VIbUUPZEj5r3PlmUDGLcGyeGHHOGedEmjvb
X-Google-Smtp-Source: APXvYqy4qVF89/Es0gHQhgXYsDyWeid3WhEH9C4Fw6BAuEjALPqutvQD+V9FlSGFw474SsDCvJYmGIcePhXg6iAYn+4=
X-Received: by 2002:a5e:d70c:: with SMTP id v12mr14795206iom.284.1574131693438;
 Mon, 18 Nov 2019 18:48:13 -0800 (PST)
MIME-Version: 1.0
References: <20191118234240.191075-1-adisuresh@google.com> <20191118.180345.383002223234440388.davem@davemloft.net>
In-Reply-To: <20191118.180345.383002223234440388.davem@davemloft.net>
From:   Adi Suresh <adisuresh@google.com>
Date:   Mon, 18 Nov 2019 18:48:01 -0800
Message-ID: <CAHOA=qz09H1D-kmHa-iVhsPYg-33XRqq+=X25ohxsa3+sRx1iQ@mail.gmail.com>
Subject: Re: [PATCH net v2] gve: fix dma sync bug where not all pages synced
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Addressed in v3


On Mon, Nov 18, 2019 at 6:03 PM David Miller <davem@davemloft.net> wrote:
>
> From: Adi Suresh <adisuresh@google.com>
> Date: Mon, 18 Nov 2019 15:42:40 -0800
>
> > The previous commit had a bug where the last page in the memory range
> > could not be synced. This change fixes the behavior so that all the
> > required pages are synced.
> >
> > Fixes: 9cfeeb5 ("gve: Fixes DMA synchronization")
>
> 12 digits of SHA1 hash signifigance in Fixes: tags please.
>
> Thank you.
>

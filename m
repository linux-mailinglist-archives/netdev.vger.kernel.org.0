Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E681A4237
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 07:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgDJFVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 01:21:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38075 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgDJFVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 01:21:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id f20so1551052wmh.3
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 22:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k9bnCNibGTTNZ8RfqJKKqIRm03Js0FIJzOCaGoNQsuc=;
        b=fHqdymfbkjjLYvSs+zmDnvKHLnbVPWjV8BrXSrAyodywDHjTW3EWchSZZUi7fvMS4k
         YrhSlnC09aPDPKVbTxgSyUrAXMJBZbbpIYJYbTA3waCo2MH4Y+9C2mow1qkuESFEdug8
         5ITcoGDMvO6R5XpSNA1pmXivaUIXUEQF4Tlpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k9bnCNibGTTNZ8RfqJKKqIRm03Js0FIJzOCaGoNQsuc=;
        b=X8TeF3ijPh9kBEtHqVJ7Hez62SwYV15DPqh44SKE1jx+2aRMa8TUXPZGKRZt/GjvdF
         pZeRI/NCM/dhnDftOEDBitUYnPch6HIzOPeGGFOGUL4lbEk/KlJol3jQutBY3ngxs+dz
         gOPK1+gRcaPm/4nbKihgYlrtnQ8G8LTldl4IshjOkLuu6jwHz+nJdjxUtwvgi9TJ52fy
         eVQrlGh+xvtLVj47xPqJwqrTVJzg7yLXLXWimz4281Why80LGFejYPFcKP/cIufHLKpJ
         h+ktLq5vHtkAa0Ulx57Wymw++8dRjhHvpOlz5e9223msbKy0XeWQmIgQgazpVpTcV1nN
         nGcQ==
X-Gm-Message-State: AGi0PuZnWgJEEc2oju7CaGfqcitM3yvD0Nf+zjiIT3ZrbhYOMYJoPdHx
        7v1nzYTu0J+mZvp0xzmox0GEwJmI6QCTC8a+ptryww==
X-Google-Smtp-Source: APiQypI1GNpcvuB391atB3Y+MsS7V92B8mhbmt+Th68wpnYqHV5ThzvOTFL1P1/F60xBajq5y7FUWUz7uEriVPLW89U=
X-Received: by 2002:a1c:2705:: with SMTP id n5mr3217827wmn.94.1586496097819;
 Thu, 09 Apr 2020 22:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
 <20200409174113.28635-1-keitasuzuki.park@sslab.ics.keio.ac.jp> <20200409123203.1b5f6534@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200409123203.1b5f6534@kicinski-fedora-PC1C0HJN>
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Date:   Fri, 10 Apr 2020 14:21:26 +0900
Message-ID: <CAEYrHjmy=R0x+zAcANDcTqx2qOhoUjy0Z2okxkjX1JHC3CgZ_A@mail.gmail.com>
Subject: Re: [PATCH] nfp: Fix memory leak in nfp_resource_acquire()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kubota Takafumi <takafumi.kubota1012@sslab.ics.keio.ac.jp>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for reviewing.

I'll check back the runtime log and see what I can do.
Thanks.


2020=E5=B9=B44=E6=9C=8810=E6=97=A5(=E9=87=91) 4:32 Jakub Kicinski <kuba@ker=
nel.org>:
>
> On Thu,  9 Apr 2020 17:41:11 +0000 Keita Suzuki wrote:
> > This patch fixes a memory leak in nfp_resource_acquire(). res->mutex is
> > alllocated in nfp_resource_try_acquire(). However, when
> > msleep_interruptible() or time_is_before_eq_jiffies() fails, it falls
> > into err_fails path where res is freed, but res->mutex is not.
> >
> > Fix this by changing call to free to nfp_resource_release().
>
> I don't see a leak here. Maybe you could rephrase the description to
> make things clearer?
>
> AFAICS nfp_resource_try_acquire() calls nfp_cpp_mutex_free(res->mutex)
> if it's about to return an error. We can only hit msleep or time check
> if it returned an error.

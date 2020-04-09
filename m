Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27141A3904
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgDIRir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:38:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38565 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgDIRir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:38:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so12880367wre.5
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 10:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cB5yBSX4XmqsF1ppUkd5OJUCXOdbq3LIDZ0hfF3NUgw=;
        b=AGeMCB2RRpgTqU0NyD8K0PMZxZc9+wdj85illkNZBFhXaDT9YCV/M4sHa4D+5pqg2O
         xcFqG9jDLQZo3duKjJI2k43wS7IYfPKRw+rB0EmR0stDi++HHUpZETn74dUlqeETl/DK
         2ldu2cXbWe1c/D5YBxpd4VpeItFyYoIF+U+tE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cB5yBSX4XmqsF1ppUkd5OJUCXOdbq3LIDZ0hfF3NUgw=;
        b=XNgyjm/j2I1cy0c03S0c8nfP7Y1h0vFjMs1rOMau9glI/OJgfzgHOoR94UtNt/AgkF
         5uoHvAjvSW9si+LD3v1+oDSEY70RP0KvQKu38KdHdqqJDUvb276l29ghkaI8Phc7Hx5S
         QxsrZOxlvqSITcsnRmapbzaAgjFEALif8sUf5HlEKucK9K06TWAT17jVFtkvy5/yfPmN
         UTps+G27F0Xx6+0w5Oo3QifM8VHLRFKXABVf+xPyVr2xNjfugI0ndz4WWg66JuTQyPWy
         ncdRz4X9cWvizxwJ6048MtpURSdb6d4Om29yBYFFetBZsYrr1e4o5Rynayo3XdHj6/XN
         L9/Q==
X-Gm-Message-State: AGi0PuaE1KUFVEDgJga29zYuOpVpaBGKxYaAdZ56xMpSisg1DZMwBjKH
        EvCABV8GTKeuyGyRumTQFjgy0EfCE9cTTq3Q60OLhc8DkDI3RSVq
X-Google-Smtp-Source: APiQypKHuqryJeoz1PSWp+rhiE3ZzkNIIf6gabELUM2oO0fS6yQjNadMGyH6yBef5R2sSWoP37RfT6f3UF604jlXS8I=
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr219309wrs.415.1586453926274;
 Thu, 09 Apr 2020 10:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp> <20200409.101844.1655988786538703860.davem@davemloft.net>
In-Reply-To: <20200409.101844.1655988786538703860.davem@davemloft.net>
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Date:   Fri, 10 Apr 2020 02:38:35 +0900
Message-ID: <CAEYrHjkjYESXHG1x0Obnz+T5xv00vyZKHzUg=ZC70f0JymSU=g@mail.gmail.com>
Subject: Re: [PATCH] nfp: Fix memory leak in nfp_resource_acquire()
To:     David Miller <davem@davemloft.net>
Cc:     Kubota Takafumi <takafumi.kubota1012@sslab.ics.keio.ac.jp>,
        Jakub Kicinski <kuba@kernel.org>,
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

So sorry about this. It seems like I accidentally touched the patch
file after generating / testing the patch.
I will resend the new patch immediately.

I have tested the patch using kmemleak.

Thanks.

2020=E5=B9=B44=E6=9C=8810=E6=97=A5(=E9=87=91) 2:18 David Miller <davem@dave=
mloft.net>:
>
> From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
> Date: Thu,  9 Apr 2020 15:02:07 +0000
>
> > This patch fixes a memory leak in nfp_resource_acquire(). res->mutex is
> > alllocated in nfp_resource_try_acquire(). However, when
> > msleep_interruptible() or time_is_before_eq_jiffies() fails, it falls
> > into err_fails path where res is freed, but res->mutex is not.
> >
> > Fix this by changing call to free to nfp_resource_release().
> >
> > Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
>
> Did you test compile this?
>
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c: In function =
=E2=80=98nfp_resource_acquire=E2=80=99:
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c:203:2: error: i=
mplicit declaration of function =E2=80=98nfp_resource_relase=E2=80=99; did =
you mean =E2=80=98nfp_resource_release=E2=80=99? [-Werror=3Dimplicit-functi=
on-declaration]
>   nfp_resource_relase(res);
>   ^~~~~~~~~~~~~~~~~~~
>   nfp_resource_release
>
> And this makes me feel like the test was not runtime tested either.

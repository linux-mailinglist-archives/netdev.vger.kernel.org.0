Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFC4224B3D
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGRMyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 08:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgGRMyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 08:54:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54A4C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:54:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f23so13118678iof.6
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UCSXz/vwofP95RhXpSs1RZ9YjTka7onpHVrb9zta8lc=;
        b=en63a4ImrlATVYMbqqjFe/MHylTQtCztyHwoQtWktyg2iOr2P5ovdH6qxG76iBAfNg
         VzlniC9Hk3Nd18pxlqxSfqdwp0x397/6crQFt+UITK7JtYodNmG6rLHOqn5oCcLnIlQ7
         UzIly59jyorQKEtJ9ooaDCGG+8zb9bjH25dCrVg4hL473K8vNdeKWfJm+SI8l42gKLcW
         PuA56amEgsZ0BNKlaWUPSHEpeX8CMorG8+mc3jamsBrfDwpZJFC9ZtaxY1h6K+SkWr+Y
         5vlHlQ2+pPJ8hDTs51QUZvhyHe1od23X8aSjZeSO5FusKLeGNMEPCNHCAJG184xsdvRo
         U3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UCSXz/vwofP95RhXpSs1RZ9YjTka7onpHVrb9zta8lc=;
        b=o+soEXfo4x7sWjALunOp3GO0/JKzu2tbRzT5c5wZRryiBMsQIR2APoicCvwgrQ7nVg
         Zam7fTryGstgw2X4j55Z3goCUE+XJusM9apj+SAeRF+tCkj+jCOMSc/vuXHJWi4F1Mq7
         WHMUZSdvRcpD983RskBEC+JVn5bxvN1Nh+EnGBcEP0/4Y0aCphSuCnk/HwKsBYrOvb5I
         aD5tFgEsp3gGLC2Q7Lbti6qg6iPgAGSqSKJwwKEJx+hajBh2WJ8mg6BFbxgdDaGCFoUo
         PPpSeQ9p/NV+00Pajai2bZ9m6Cd5w8zcwR0XGMiI13Fa+kwIhlP5zyCYm1kSjHlAFaHC
         1I3A==
X-Gm-Message-State: AOAM531w4zkf5/EvsvHStCZ2iLfWPGcyUJUlwh89C86GmHnGLqfDEElY
        Dyi9EvHNI5EeEuyduafUmCEgEbgvY6uHHhEvXFIIKKj5
X-Google-Smtp-Source: ABdhPJxdsehSeoUuXVqxat1V0//13wW3Cm0L0AzXhlgkO3XA3zFeSVPufnAuYYBlDCQLSvMCNwXvUF6YbNINQxJbWBg=
X-Received: by 2002:a05:6602:148f:: with SMTP id a15mr14370958iow.26.1595076879295;
 Sat, 18 Jul 2020 05:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200716171109.7d8c6d17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupxX5Cbvb03s-xxA7gobjwo8cM7n4_-U6oGysU3R18-Bw@mail.gmail.com>
 <20200717104812.1a92abcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20200717.110259.1742782189944982464.davem@davemloft.net>
In-Reply-To: <20200717.110259.1742782189944982464.davem@davemloft.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sat, 18 Jul 2020 18:24:26 +0530
Message-ID: <CALHRZuq9bK2fmo1QyqpZv+cPUMFi+CtYJZakf74N+OZYyV_zhQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, Jul 17, 2020 at 11:33 PM David Miller <davem@davemloft.net> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 17 Jul 2020 10:48:12 -0700
>
> > On Fri, 17 Jul 2020 10:41:49 +0530 sundeep subbaraya wrote:
> >> I can separate this out and put in another patch #4 if you insist.
> >
> > Does someone need to insist for you to fix your bugs in the current
> > release cycle? That's a basic part of the kernel release process :/
>
> Please submit the bug fix for the 'net' tree.
>
> Wait for the net tree to eventually get merged into net-next.
>
> Then you can resubmit this series on top.
>
> That's how we do development, and we would appreciate it if you
> would submit bug fixes and new features properly.
>
> Thank you.

Sure will submit as you said.

Thanks,
Sundeep

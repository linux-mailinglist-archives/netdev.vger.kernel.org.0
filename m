Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029513D65C7
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbhGZQtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbhGZQtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:49:10 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299E4C061798;
        Mon, 26 Jul 2021 10:29:21 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r17so16847690lfe.2;
        Mon, 26 Jul 2021 10:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ndKq+LGDON/UckbBHbtSzNl8tCW9FVvB6He4yfXkxNE=;
        b=YsxgKSTD9vroLSiRzpOsnVo3wM9+Mx0r4LrK++z5i3tX+lM7nSsj5Z3vsu6lZxUvv/
         q+xT9GVTvJ8qnaUaHTHR9g1R1eLE+a/ZnPG68w4HACOceDhJWSbe6IQxsKcW32DGipNR
         r4BcKujtBuXwYE1dxVHwghud5C0WMHrRWbcXegseNXHbq8bknb3PQjmrKn/rx9CjeBEw
         5hBtqmAmvHy5NlRd7QLMdKGvtxm0f4jWLqdqlKKC1r/l30/CKU7m6T8ocVftlySQCOPE
         LpU2SDZZTXzSyC5ZFssi5kS6O+ay9760WSMW+PxjlQr76QXacRdl9/fjb8pkNe+FJbsr
         FhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ndKq+LGDON/UckbBHbtSzNl8tCW9FVvB6He4yfXkxNE=;
        b=V7PA48pEjicKKMDDcKBhfsz0SlHsOv7OhSBphF5z4iMnt6uY5w6ciDScAB/O2mF5wf
         TV5nz/qVVOYRFcty6oR4V9YbMsmyD7/RZSvOKG6uaJjLEd4YzsJC021aWrYRxp7/38LP
         DyYUHoBJlLfm/lgwOhJ0JhL9IsVlIPY0nL6c7cSF+jWKShLfsIVELytdn5fwnMnS66z6
         +RBGguWvrg15hfrCTyZjr9dioSMaajKDFZAnbndvgc+MKLcTDmHTZBvFHEA8CKt0kyTC
         ZWlp4hsCgBV8TqMfbAthkMENKbR3jV7NNb7OrZRDhHKp3GkrQw1auNVRLBDQYP6CC8MK
         IvAw==
X-Gm-Message-State: AOAM533CR6RkTlTH41JpjtdNXS4pHRPOYUaJp42sp7/Q+4puTI5RnJoy
        Sc6rjiF4btVljLkOACkT08M=
X-Google-Smtp-Source: ABdhPJynhVi5xWfz4QxD21z+iK+btrTFhGSenshuxDRY6e4XjYz3lHMpwXa17bNhLBrSf8tCpQkqbg==
X-Received: by 2002:ac2:4c97:: with SMTP id d23mr13427935lfl.249.1627320559562;
        Mon, 26 Jul 2021 10:29:19 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.94])
        by smtp.gmail.com with ESMTPSA id d8sm57071lfq.138.2021.07.26.10.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 10:29:19 -0700 (PDT)
Date:   Mon, 26 Jul 2021 20:29:16 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        socketcan@hartkopp.net, mailhol.vincent@wanadoo.fr,
        b.krumboeck@gmail.com, haas@ems-wuensche.com, Stefan.Maetje@esd.eu,
        matthias.fuchs@esd.eu
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] can: fix same memory leaks in can drivers
Message-ID: <20210726202916.5945e3d9@gmail.com>
In-Reply-To: <cover.1627311383.git.paskripkin@gmail.com>
References: <cover.1627311383.git.paskripkin@gmail.com>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Jul 2021 18:29:38 +0300
Pavel Skripkin <paskripkin@gmail.com> wrote:

> Hi, Marc and can drivers maintainers/reviewers!
> 

I reread this I found out, that I missed logic here.

I mean:

> A long time ago syzbot reported memory leak in mcba_usb can
> driver[1]. It was using strange pattern for allocating coherent
> buffers, which was leading to memory leaks.

I fixed this wrong pattern in mcba_usb driver and 

> Yesterday I got a report,
> that mcba_usb stopped working since my commit. I came up with quick
> fix and all started working well.
> 
> There are at least 3 more drivers with this pattern, I decided to fix
> leaks in them too, since code is actually the same (I guess, driver
> authors just copy pasted code parts). Each of following patches is
> combination of 91c02557174b ("can: mcba_usb: fix memory leak in
> mcba_usb") and my yesterday fix [2].
> 
> 
> Dear maintainers/reviewers, if You have one of these hardware pieces,
> please, test these patches and report any errors you will find.
> 
> [1]
> https://syzkaller.appspot.com/bug?id=c94c1c23e829d5ac97995d51219f0c5a0cd1fa54
> [2]
> https://lore.kernel.org/netdev/20210725103630.23864-1-paskripkin@gmail.com/
> 
> 
> With regards,
> Pavel Skripkin
> 
> Pavel Skripkin (3):
>   can: usb_8dev: fix memory leak
>   can: ems_usb: fix memory leak
>   can: esd_usb2: fix memory leak
> 
>  drivers/net/can/usb/ems_usb.c  | 14 +++++++++++++-
>  drivers/net/can/usb/esd_usb2.c | 16 +++++++++++++++-
>  drivers/net/can/usb/usb_8dev.c | 15 +++++++++++++--
>  3 files changed, 41 insertions(+), 4 deletions(-)
> 



With regards,
Pavel Skripkin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5A138F424
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhEXUTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhEXUTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:19:41 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757BAC061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:18:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id i7so25862295ejc.5
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 13:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZW8cCiAzHyHOwo3G4SSuR3ks7aYQun1vtH9zKbGIGuk=;
        b=vIJLXNbc9yDAo6QEQH9QWf4Z22/sQx5haK6JrsiBGwopXQSb3KEBU/qP+MV95muAuo
         xMqVZCuMgOodmvj4wt9A3oLssA/4E+rdJxpYOiZVaSJnO9MiXHquG13cwhiH0eokTufD
         noU1KIP0963N6ljBb4QXwWVpTmTqJLplxYpZIL3mBFr/BJahwerOUUrcdvNe7wi6YLcf
         hr6hpEpeld53rKuVINqmQscvIygKxNSrgzbsqs/LQu7uCJ6K6oG7VTN3bZgAVurry29m
         ZxosufL0sqFZnO5Fa6R61sM+6hTH04wTm2twzvsB0+9xIL5tyKSwm5NP3TqPqTAZOmYi
         MNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZW8cCiAzHyHOwo3G4SSuR3ks7aYQun1vtH9zKbGIGuk=;
        b=e7C3QWxTy+kvjVfyAye4J5ZinZG2i9+hhIOzPqHO7WolQVEvabK56p08wfZKBSJMEg
         tpSPJ/lbllrCgumORoBytxW6amApUqJBqbubaXLCKUYpNSIGtWBzQ2pXSjJkoPrhKUDl
         HL71jWujkd/zzD6dYmCh6CHKhIJCcRQInS/ujq8VbWH9z7zpp1WjHMtPTDNYkE6JXkqL
         LbXvC9Ad5dzDeZHYVxMKjdlllJgnapAIbL87nl+IFXBSCNHeEat6RRroHXNgWO12UB3D
         QmGCjnVcRm6QM6O3LMhtG5SxOB2SCzsikYRs4vZz/nrJ0tHhfcqsJFOU540nxAoEZSLT
         8PFA==
X-Gm-Message-State: AOAM532pFSOQhjGR2UpZOPsAN0HFWLFN4V3V5unrWZGxzMekPWiAb6Hy
        dnP5sKmrmdYtx4a0vWMCEFRVvLsk9MGq1P5lpKo=
X-Google-Smtp-Source: ABdhPJxO4DbvD/i19lelK40wBRTpdS5grbN28GfxNDNeB7glg+/HsGKu90dDD4CnW9jQyw71c2ZcPKo4Mz6CcOBXAV0=
X-Received: by 2002:a17:907:76e8:: with SMTP id kg8mr23522257ejc.130.1621887490023;
 Mon, 24 May 2021 13:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210519111340.20613-1-smalin@marvell.com> <20210519111340.20613-9-smalin@marvell.com>
 <34e4a50b-4075-2364-d654-4039564f43ff@grimberg.me>
In-Reply-To: <34e4a50b-4075-2364-d654-4039564f43ff@grimberg.me>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 24 May 2021 23:17:58 +0300
Message-ID: <CAKKgK4yyf=o4S1c3svRzFoR-mhc9MUP2QGyu6aB3e-8nmW5k6Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 08/27] nvme-tcp-offload: Add Timeout and ASYNC Support
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Shai Malin <smalin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/21 1:51 AM, Sagi Grimberg wrote:
> This should be squashed in the I/O patch

Sure.

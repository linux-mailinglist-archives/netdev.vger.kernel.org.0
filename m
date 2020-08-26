Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27A2524BA
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHZA2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgHZA2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 20:28:02 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA90DC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:28:01 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w14so332365ljj.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RLbIHhzJWC9vCxPstzO75d+NmpabbCBp5xKdkj1CaU=;
        b=O57CImDdH1ClxTceQRs306qzuCCRk1GoRBhAGp3WeBsn9oH0gwf7W37XhWmPaVz/Nr
         CeHmWAV8n521pJ1EaILXnFbUQUMPDekJ64hBN8z9t5ZDBXKLyIrIxg7Tfo5tPxZ1dGIJ
         yTg6RbFzRWQxVeIq/Gx3gQveGc1HPDph9cLw8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RLbIHhzJWC9vCxPstzO75d+NmpabbCBp5xKdkj1CaU=;
        b=VpwGQGltCgHZxrBNWUHYHuWhXTN1bK01ktZMt8qxhObvHh7+c+6h5nTQnUCLRThEZ/
         iDUOoivZpok+/WEZhdxoaAW+kYCdXRa+v1LOswMyw27zNS05+aN5vWT4tl8u3DEVtijt
         2KAUIVEusxgM6NYdFvx8uHOg2YrMbQaM3tyCtDuQ2B8P82JWLuvbaq71U3G56DlG0sx7
         26Pi8E2t7fK/94SQaZ+/NTkj+ZJrEu8fBfKfOWHTV6zSQxlhGoNqZs2zTP7C19idHlGy
         MMfo/TgQrgmcg1lik7bjOALfOPpRQctX5l5nKUbikwLocHKQH+gvpnZ93gAwT3ROe1v1
         45Ag==
X-Gm-Message-State: AOAM533iByvdkxA3lmgyA4/QbNadzbGdSxrqHwlYD4nPS8W1KuVDP0mq
        KneybzRxuuSreORJbrVIQbPZCptmp2I2ug==
X-Google-Smtp-Source: ABdhPJwo6wYDXpwsrYp4hLyXepD+Efb08cH8Clijpgm6qp8rT4Crbf6jiNGchS9ZPSmpGFIvv8A6/g==
X-Received: by 2002:a2e:9b4c:: with SMTP id o12mr5847195ljj.49.1598401679496;
        Tue, 25 Aug 2020 17:27:59 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id t25sm139027lfq.7.2020.08.25.17.27.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 17:27:59 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id s9so16801lfs.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:27:57 -0700 (PDT)
X-Received: by 2002:a19:3:: with SMTP id 3mr5956730lfa.121.1598401677254; Tue,
 25 Aug 2020 17:27:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200824093225.13689-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200824093225.13689-1-kai.heng.feng@canonical.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 25 Aug 2020 17:27:45 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOizniWUk3pUM1X5UHyGcrJy=ybAwp6_jjXfEGjNPe27g@mail.gmail.com>
Message-ID: <CA+ASDXOizniWUk3pUM1X5UHyGcrJy=ybAwp6_jjXfEGjNPe27g@mail.gmail.com>
Subject: Re: [PATCH] rtw88: pci: Power cycle device during shutdown
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 2:32 AM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Sometimes system freeze on cold/warm boot when rtw88 is probing.
>
> According to [1], platform firmware may not properly power manage the
> device during shutdown. I did some expirements and putting the device to
> D3 can workaround the issue.
>
> So let's power cycle the device by putting the device to D3 at shutdown
> to prevent the issue from happening.
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=206411#c9
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Can you at least include some more details, like which hardware
version and firmware? And which platform? It seems a bit harsh to
include a platform workaround to run for everyone, unless there's
truly no downside. But even then, it's good to log what you're working
with, in case there are ever problems with this in the future.

Brian

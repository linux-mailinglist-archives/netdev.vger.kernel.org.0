Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C9539EDD2
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFHEz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhFHEz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:55:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBA5C061574;
        Mon,  7 Jun 2021 21:53:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l1so30391317ejb.6;
        Mon, 07 Jun 2021 21:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HhTJvhXQRpXrK1DarhAlRYbBfua3nyn/yHyOslBWJcs=;
        b=ioZ3BNAMIpb4kBehQ3jJ7ZUK3o7D5uE0qxuvePy6skLatGTSbTmt0EFQasHk2IC8UC
         qZgBez6I9509CoyWBVRNGfYAaXFf+VUfxuXflzzIbZZM+YaWTywQ3ZWBFlQmJCsYKBn5
         +NPHQFVwQDP7zm2JmvfeIee5TT61w7AzVMWCr4SyKwKtral77QymPtCDom4YxaxBdwnd
         +JY3DL+QLD6eiqZqQUPwuYkxZrE4/fyCaANWEryi26ZKyzMEe21psLSBjNInbdlAZHlR
         NZhbCDylPspsaA5GjBgBWAz5qx6B/48lmflyY3T7lSWnYOmfhz/tu3/KD5b39MYu5prh
         ATKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HhTJvhXQRpXrK1DarhAlRYbBfua3nyn/yHyOslBWJcs=;
        b=G/7F7j1I4AAGhglIGHww5jzGWKZk2iWOpwc1t5fEqziUJlJ030h1GxIivWIYyNFGq2
         KRMCsTDhyWKLFzVVBK0BWrNx9km19s7VW/Pdei1/szgbIjWHe7s3LToMWnUkEOzIb2k5
         zHxbAX+1LdUHfS9W29fdXcB+9Dzds4xCS8BKjHBcxZ173aV/QpCXGKwAfG7zK3I60FZ/
         EX0ocggdnC3YNUgM9LTRA3N+2n8egp4JLW72k2iFcOtfKzJgCWXSAAs9bwP9M4Ap6ZKI
         b2v/eOMmDmF1v/EZ5Wxy+/r1FyiO/+CmuIn/i3wznLj6WsZS6jUQJLIQOw1H/ruVQyP0
         tcxg==
X-Gm-Message-State: AOAM532yF8+l48VJxxILaDXMHycHb8V8zel9RQexomcHH+dFwjFOW9cI
        TE9V4x9oq5H2ZE/H268JveyGHT7gMP/qqA==
X-Google-Smtp-Source: ABdhPJwOGDkpPewucg2h667ejKhMAaKvXo7/m9DONKIyJ4jEepIVd+ykVanF4zO4tHR7NDs1ZDDbqg==
X-Received: by 2002:a17:906:2c1b:: with SMTP id e27mr21626901ejh.5.1623127998599;
        Mon, 07 Jun 2021 21:53:18 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id d5sm8460426edt.49.2021.06.07.21.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:53:17 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 8 Jun 2021 06:53:17 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hao Xiong <mart1n@zju.edu.cn>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: fix the erroneous flush_work() order
Message-ID: <YL73vTBtgWkaup+A@eldamar.lan>
References: <20210525123902.189012-1-gregkh@linuxfoundation.org>
 <BF0493D4-AB96-44D3-8229-9EA6D084D260@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BF0493D4-AB96-44D3-8229-9EA6D084D260@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Thu, May 27, 2021 at 10:14:59PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> > In the cleanup routine for failed initialization of HCI device,
> > the flush_work(&hdev->rx_work) need to be finished before the
> > flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
> > possibly invoke new cmd_work and cause a bug, like double free,
> > in late processings.
> > 
> > This was assigned CVE-2021-3564.
> > 
> > This patch reorder the flush_work() to fix this bug.
> > 
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-bluetooth@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Lin Ma <linma@zju.edu.cn>
> > Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > net/bluetooth/hci_core.c | 7 ++++++-
> > 1 file changed, 6 insertions(+), 1 deletion(-)
> 
> patch has been applied to bluetooth-stable tree.

Can you queue this one as well for the stable series? It is
6a137caec23aeb9e036cdfd8a46dd8a366460e5d commit upstream and in
5.13-rc5.

Regards,
Salvatore

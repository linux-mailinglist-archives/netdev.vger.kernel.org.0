Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1706A47E606
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244321AbhLWPuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244269AbhLWPuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:50:01 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21757C061757;
        Thu, 23 Dec 2021 07:50:01 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id y70so7661076iof.2;
        Thu, 23 Dec 2021 07:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62a8WqCVCfLtKcBuPYIIPd3ieisksyyskCcARTtW33c=;
        b=N+ENe7/Sg0yz+UQJF0BcJ05vwJhcPh2IrxxSASrH29AvgzimI23igkrL5cFygzqExW
         FV5IvR/w+OXFWvbbRldc51dUm2xbRXJ9jdUoU5DfWSSXjtqDutonMDjtNTqL2nYeSP1a
         P+g6+P9huB/mz8A0j5XXPaziZBiugm8n09euRa1RsdXMd1P0gO0Nxpoth1jAV8wewtZn
         LSJPFtyC8DKOxSFThmvjKKkojq9Rltd5Jm38PHbdyNThKRzXrcis0ltNDZVMaQLIGTLI
         bz9WmPkrEJP4uzxmhWHZT/TgyfrOeOQE56eFpytrOx4v0rGfqza8TYNEjbT1S07r9BGH
         +klw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62a8WqCVCfLtKcBuPYIIPd3ieisksyyskCcARTtW33c=;
        b=s0fp+bFl+1/Hh3s69nj29rGeIJiADOpINtb2N7+oND3f1vaGGjOeKhywo0Ahgu7KcE
         fGPoRctAZ5krJwhFtG91CLkR5pobot39iu7NfeSdc9Qu7f86fjTwiQpPSQi6KDuNwSdc
         vNcAjpl2sDeCd+nRXEflK7GNZZMhaNNNsZU0u+qmFQ2QRgZVNPJUvkpM/L72ee0mAw+Q
         3Qvfz1AYVrq+mdXTHJRyaiZ5Ya+D/xCgtzi8N4JLRf8WSirfl4oqBjL5NLZ6bFQavA2m
         NoJ/iAsuWx82AxgwI0xGe3RDcjeKN3yrpJlu6m2h50GTpiWEa+Jad4E+fWjB9CP4pVfB
         pUPw==
X-Gm-Message-State: AOAM5337G6N7pmTSPR6pLJN4bbso/UsqFNq0uYPArCf1OUJuRItkEMHy
        Bsm9jhZldYDlNpvs21fmtvnDLMEOpsXpMXVhb3U=
X-Google-Smtp-Source: ABdhPJwEbqd7uZYcmlny31sQLctCH/pTjM8DqTv5mP5ne+ZG4nSoE+qxJfsYeEGP+lBa9W3471ggxfnncPuM/ikFRVc=
X-Received: by 2002:a05:6602:2a4d:: with SMTP id k13mr1407242iov.133.1640274600493;
 Thu, 23 Dec 2021 07:50:00 -0800 (PST)
MIME-Version: 1.0
References: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
 <c156c75f-5797-917c-a8f7-ad7620903bf1@nbd.name>
In-Reply-To: <c156c75f-5797-917c-a8f7-ad7620903bf1@nbd.name>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 23 Dec 2021 07:49:48 -0800
Message-ID: <CAA93jw7iF6SD+qbASxNspxvydNOz71GirmGqref-3uOmbRvMBw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: enable threaded napi on ath10k driver
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Abhishek Kumar <kuabhs@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>, briannorris@chromium.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        dianders@chromium.org, pillair@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

what is your definition "Good results"? I would really love it if I
could get back more flent benchmarks like this one:

https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/59002

As the ath10k has cost me more hair and time than I care to think about.

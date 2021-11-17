Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0554454DA5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbhKQTKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:10:14 -0500
Received: from mout.gmx.net ([212.227.17.22]:55857 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240338AbhKQTKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 14:10:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637176023;
        bh=xwC46mm+72ZQCm15/bVMv9FqczPa4aPsJ4i0DvPIWMk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=i12xtPkFKEY1+mpcKCogQScdYhgI+IYXZkFxUcF0ao65ieV4/YGR8rse32G5Qc+34
         WEXazWe9mh77eUHevZbllrlqdiEZ+S4b8vDsZV/S6TmxXcNySHfepAo6Wu00Jaj6AQ
         n7HsoCOC/vymcOjF+mLk8X2QCXJrMrVv3uxrlB5I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.243]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0XD2-1mQNZS433k-00wRzg; Wed, 17
 Nov 2021 20:07:03 +0100
Date:   Wed, 17 Nov 2021 20:07:01 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1] ath9k: fix intr_txqs setting
Message-ID: <20211117200701.02e5ea74@gmx.net>
In-Reply-To: <163713885373.10263.4223864617658431026.kvalo@codeaurora.org>
References: <20211116220720.30145-1-ps.report@gmx.net>
        <163713885373.10263.4223864617658431026.kvalo@codeaurora.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SibizoRZJF31qU3eUhQNOByzzifqIF8NTHeCJISvjhg5Hcd/Yet
 vqvGlaKb2uym8hIX53IUZcE63C5Ix41O42jiyZjzrXnw9YQ8tjhqUdBKQzLmTt8KtfE9QcR
 IEsX4rJOkXVodq2sg/VpDg1VLMm4FQAF+zuh8+gcNUZIWDcEKd2oGXEOKw/NUAtiqcWwgo8
 4gSfl+sFLjdkpbIII9fSg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:u9+Oh2e9Z1Y=:2xBJYOoe2TPdXM0kpjeLVB
 n4TBfwZRaCt+r0+p5hVFc+gH0Ju2sZU7pPJsQiqQEnZYWkvkV45jzrgBaiXCA7h0uEEZKVZw1
 9G7h7mBWkWx6NkoyIbm/idsjMBoLQupXB3mN1zOyT7gNybKgby7eTI+QEwLIR2xcTopDo0DxN
 L8f8f3wCua0OL0v8sqq08eWiMAgpWXCVm8l0ITzh0rWjYgjbkYykTz6Oik+OV6v03xR46nEpH
 2QRigaGI56nFzym4G+Fh4n6Ie+Z+/CM1vr8cGh1QZlrtOym1nFTJUXbxwERWnkWA3lgrqCfux
 7qjAuDkOkHAVCrLcvjOCaiMdsERrkJC80JATdAbvvKl+bSq3jWiBimli1uicY1C0imqTeo+vz
 d5F4eOlLn5nMTUNpmo6V/eN2ucbVzL+dtkRLEkLMgwP4oLKqniQdwebPeWVCZ8t4sg5sHxcQk
 8lEagZgemnLmoJoiLuNfRAb4QknWRTllPSVflmXZrE+K5XzYuiKZX1hD2pyKLnIXqMHoHAayU
 x/Z+SVzkh7MdlF0IxSuKOkBTZAs3aC6ca5lpEqDtkTBeCtIa8Lhl1oFVPPVQ7kM852G5gTUsf
 CyfPDW14DH0gJo7JfMoT+sM6HNaEKat39y9AMWL94UwxKWjWjsepYnFe8GCGffOOrQuxCFTL+
 uBpeQGvwZDL7dYnICRB3K2TB222K1xo59DQ0TGMYHkEdw/KZQLyand36tGDQorGUVlruovr+g
 NGYEUqPsGtHKSaiGVuGUU+ZrARPVy0rl2eaBGSS2Amml76+GfNRqJPgw2g89W79zgBzDBlzkT
 JnS50SiSEfjK0zbAVHNsammQMai5Ma4NKmOAbb9uRswEMJU8mSb1L4Mwrawwz5W2M7jZ6TF4u
 VjE8oQ9UOwoaiIP1Tde+lVZu1fdf5UfRFy32XPdzNmgtoeeNs7tj3oyRLVSJ3eWBojCAMPqST
 TVN6bE3pvddl8J9lNIT8PCO3Rl5LQdivppjTBbMp+QyAV+wQ259Z/Sj9DCAdv4eTiqknhTasO
 7tMvu00BxvVNP6Nc9Z8pwjk+t94lLYtECR8+Ma7LcY9iHc6nDYv/VzmbS4oQm4GUxYWnj7ibG
 nPXjExW9YWk3uk=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Kalle,

On Wed, 17 Nov 2021 08:47:40 +0000 (UTC), Kalle Valo <kvalo@codeaurora.org=
> wrote:

> Peter Seiderer <ps.report@gmx.net> wrote:
>
> > The struct ath_hw member intr_txqs is never reset/assigned outside
> > of ath9k_hw_init_queues() and with the used bitwise-or in the interrup=
t
> > handling ar9002_hw_get_isr() accumulates all ever set interrupt flags.
> >
> > Fix this by using a pure assign instead of bitwise-or for the
> > first line (note: intr_txqs is only evaluated in case ATH9K_INT_TX bit
> > is set).
> >
> > Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> How did you test this? I'm getting way too many ath9k patches which have=
 not
> been tested on a real device.
>

Did test it with an Compex WLE200NX 7A card (AR9280) running IBSS mode
against one older (madwifi) and one newer (ath10k) Atheros card using
ping and iperf traffic (investigating some performance degradation
compared to two older cards...., but getting better with the latest
rc80211_minstrel/rc80211_minstrel_ht changes), checked via printk
debugging intr_txqs is not cleared when entering ar9002_hw_get_isr(),
and checked wifi is still working after the change...., can provide more
info and/or debug traces if needed...

Regards,
Peter

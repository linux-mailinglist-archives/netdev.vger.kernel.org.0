Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5252FC367
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbhASW1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730796AbhASW0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:26:05 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FF8C061757;
        Tue, 19 Jan 2021 14:25:25 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id w18so43004945iot.0;
        Tue, 19 Jan 2021 14:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckQsUQ1LKR1mQXUCM/yL+eZIKUoNzImIqmnZkfMbC3Y=;
        b=CERfv+nwmEmSScikj66V2CkDoFpDpYI273t4hfbNwjoqpuqJy9+uV5ZOUEP/6ZEQn/
         M9MwbTFJ8zUi7qq1AvPhMPT5JrPWzTHi1Kg1gzenf5FoWEBwis2cO911+05j85VgWPeq
         hLaBGPGfxLbZvTftWrjPp7j6GlKYoqMyuKcIkZfZwqpYS33iMWln1NGlFGBJ2jx5LUCL
         VwZgVh/CksTySsbKCzQEWIj+NZIizbVYxIZnFEAB/URgvREpSlsEG7TePH5vay2Ys88E
         0uGAXUeWA3IUTpdi6plUnYLtnoCDo0v+BB/PGEHnbeKRXY/Mawzqpfw+qkw++xN24JLy
         yn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckQsUQ1LKR1mQXUCM/yL+eZIKUoNzImIqmnZkfMbC3Y=;
        b=lMzVut9RtrjmJSDBgpB06rsWlCzUbaGSZDS+H0HjeIFeIGV/6XELMzkE7yN6ghnOBR
         exSaD4zYhpnT+ErdsnhFu4/dCP9tprqixi0NudUkgqXDhPCl61FHz/VtWjXDabwQhlos
         OCXl2o+rzWhlPV+7NfhViKYIZZcPfMS/uKooQaOZ7H2/PgoJIHJ0UPRKjGRrlb0MyaKE
         KmTNDGt9vDQbb5Z3+RozeZaa42gFB065x/B2GhaOWKgKH1F0XCR2GsPW1BaotUCBB8xf
         5IqAMPhf6uwR4UpytUvfv8BgxybgSYzzwIFCuXiRUGyNewuANDSylNw96j5pZgKnuPcj
         sdCg==
X-Gm-Message-State: AOAM5323XmMA5kOKPrfNMouETxHPXSI2Nd5EexdNftYVn+kefTttOkD2
        VlsWQfhlsV4XfMA8vlejI/7E5n9w/lqBTtBYyi8=
X-Google-Smtp-Source: ABdhPJylN6iYGS9pZS0XhZW5StN63C1HfTKCSdFeDNy6fAtLirkNvErTelv9k1RwWpw+XADvqOjsuXK7VyUDytCgRuw=
X-Received: by 2002:a02:5889:: with SMTP id f131mr5339131jab.121.1611095125034;
 Tue, 19 Jan 2021 14:25:25 -0800 (PST)
MIME-Version: 1.0
References: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
 <cover.1610777159.git.lucien.xin@gmail.com> <7b4d84fe32d588884fcd75c2f6f84eb8cd052622.1610777159.git.lucien.xin@gmail.com>
 <f58d50ef96eb1504f4a952cc75a19d21dcf85827.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <f58d50ef96eb1504f4a952cc75a19d21dcf85827.1610777159.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:25:13 -0800
Message-ID: <CAKgT0UciYR6t7nUpAiAi79LSbqg048g_ZKCi511KDXUnXo2e5A@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] net: ixgbe: use skb_csum_is_sctp instead of
 protocol check
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 10:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
> checksum offload packet, and yet it also makes ixgbe support SCTP
> CRC checksum offload for UDP and GRE encapped packets, just as it
> does in igb driver.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

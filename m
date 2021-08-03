Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F2F3DF431
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhHCRyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238461AbhHCRyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:54:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BCCC0613D5;
        Tue,  3 Aug 2021 10:54:04 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u2so16374272plg.10;
        Tue, 03 Aug 2021 10:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=7w7E/NHu0k1VJGAL/P9Q/nTang9rJY0W7RSl3u509B4=;
        b=mVGRRanp+EiOMsn9nvAbHmJP777BHRDBkBea2qAhuWmI98I/0cK8q/TSwf2DUfSlZM
         pdsc9GZkA0g6qlhmiMJXevF4y9D18N0RX+LlystQ1oHFFklPfqnvwiVBgNNC2k7RSSYG
         si+JU6PMFUR6IVD0VWEh/uuJpVuiJYtNvwUWbpFXFVHQeJzvd/hfNLGgBNYzdBgkKMEJ
         EDQGoVQpHLlpTru/J6n89xFTP+Bnhjq6b/RnSUCGMy2gSsjO85uKSqGm+mFBKerEndeQ
         h/oGCFduYW7ZW4PHXTSp1LlNxR2A+fRfMhajIm+idoKoHK22+aocKCR3dt+NPzN2nUKV
         ovtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=7w7E/NHu0k1VJGAL/P9Q/nTang9rJY0W7RSl3u509B4=;
        b=i+sncxqnLFxChBiGhKrPYk5MvKenpiBT2fMqr7Pi40QlwKESeFu4ysrBIScf5avNs0
         Bxbdu0BP8UhifrWrGFUUOZ6mk/BNgsDO++dwqMj336tj83MlZPQxAVk7BGr3Q02vJp4b
         pNlCF9BxBmxXN9o3/GjQd1zes6VGHo+cRqHwOE2qhqmgJMcMccCMpqIVP2ZBtRyleirS
         ZI3RRWUdIaWlxN2E94UW4FjpYn2dUD5L1nL/25jwxJyAjPHS7/VIfmFiU/6gr8ImpQau
         nTLAKxTXcSF2hDuSpnlFMMBX9a/A5aSjUhbwTNwkvKoGHlu6RJtC/jIUyrsgg8jvXxsk
         7l1w==
X-Gm-Message-State: AOAM531xIGFzOsOOYDaQfLTfpgoBROC3jKZUwDljeQdCvPREs9jmc4Hd
        pE7nyiQluLA7ghyaa2R3XYU=
X-Google-Smtp-Source: ABdhPJxdF8P1ue4xo5SMrsOZy5M/V6nyz3jQvOoZz76lQW6zMbEUq5n4StGvBd+PgHggtonSkGNQrA==
X-Received: by 2002:a17:90a:7f04:: with SMTP id k4mr24573451pjl.32.1628013244311;
        Tue, 03 Aug 2021 10:54:04 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id k25sm16011888pfa.213.2021.08.03.10.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:54:03 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: dsa: mt7530: always install FDB entries with IVL and FID 1
Date:   Wed,  4 Aug 2021 01:53:54 +0800
Message-Id: <20210803175354.3026608-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803165138.3obbvtjj2xn6j2n5@skbuf>
References: <20210803160405.3025624-1-dqfext@gmail.com> <20210803160405.3025624-5-dqfext@gmail.com> <20210803165138.3obbvtjj2xn6j2n5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 07:51:38PM +0300, Vladimir Oltean wrote:
> 
> The way FDB entries are installed now makes a lot more intuitive sense.

Did you forget to add the Reviewed-by tag?

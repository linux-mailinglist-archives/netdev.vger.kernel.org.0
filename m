Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E66D03C9
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfJHXG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:06:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37240 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJHXG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:06:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id l51so404211qtc.4
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=atsmqMocA5CyL6gwgsiLT5GHB2fp+M6rgJRLl0QguUI=;
        b=Yf1PnrqJhvtoylbafl92Bfw8ux3dLraYowqxbyDrdbEwmrb/Foqz5TlOsshmV0Dmtg
         eWdp9Ap/S27I1mPrqK6kCp3hFGr9kR/inLVgnQFRqJzjSdQKagRKhz9TqP5rjUyZKts4
         YvbQaD/6PuXN9wVWjluEGRnxy3nEbI9/RROkQ7hkF+J4IKdS7Txg3eNz2CBKTvLvb6im
         0NPb7qDBIn1959sX1s1XGAYXkgxH4CcDaEj19c54dw84PbhgslpexIDawjhjDwwXaIkU
         Xrhc0g55tOtHLW3GeWPrOzB1IQwv3bHit1hVr/EeyLrLwXYc/9xd63ti23ss0gRZQTQb
         iAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=atsmqMocA5CyL6gwgsiLT5GHB2fp+M6rgJRLl0QguUI=;
        b=XIyJJUe/zY0DzLJv70qQlXDeXQeCE3h9kAWQvVXpa3Zs7bJ/t4aoJNVSKyZWpRUYXi
         p3TBKekjqFD1+o6S3B1PQ2WZ1eDFbpbos5nyGBp6gC3lgAE+GXuL8sS4jaY2k49cCyAP
         4yge+Em44tHfQCvBMdYO7GRQ32RqCPSn3qUbOKysXKxvIgqRCqNG6qJeVZ4QN/XYb5wk
         DkjRyhUwLiAELMlm4evi5tbilIc95Lb6UAPBbgEZOncHOIgqQIBuwL5UNVCV9kYWJbH2
         lY/CMgx3qD8eu3ODsS4UtT2npYeerH2sPLi0LDyaQyn3Oz7mquvEn7ElOxnFG/NQU3xC
         rgvQ==
X-Gm-Message-State: APjAAAVBTgm81v/P+I7UMPHlgKQ+lJL2rX9phW8rlcVcKnpGeZ54w1wp
        UiXvIe5v0h6w/7Gzkq1rs73/0w==
X-Google-Smtp-Source: APXvYqx/64qjNyPamHObAX+fZWZqmEP0Vy13opmS7WjDT+nYyQ/NnL33mmrlR73uH81IkMFcAKV8/g==
X-Received: by 2002:ac8:4a84:: with SMTP id l4mr463525qtq.118.1570576015229;
        Tue, 08 Oct 2019 16:06:55 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t73sm93418qke.113.2019.10.08.16.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:06:55 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:06:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     MarkLee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net,v2 1/2] net: ethernet: mediatek: Fix MT7629 missing
 GMII mode support
Message-ID: <20191008160643.1c1d31ff@cakuba.netronome.com>
In-Reply-To: <20191007070844.14212-2-Mark-MC.Lee@mediatek.com>
References: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
        <20191007070844.14212-2-Mark-MC.Lee@mediatek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 15:08:43 +0800, MarkLee wrote:
> Add missing configuration for mt7629 gmii mode support
> 
> Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")

Thank you for adding the Fixes tag. It seem, however, that the patch in
question did not change the ge_mode setting. Is it because GMII now
makes a call to mtk_gmac_gephy_path_setup() that the different setting
is required? The Fixes tag should point to the commit which introduced
the wrong behaviour, it may be the initial commit of the driver if the
behaviour was always there.

Could you add more information to the patch description and perhaps
update Fixes tag if 7e538372694b didn't introduce the problem?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D128C9BF
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfHNC6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:58:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45764 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfHNC6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 22:58:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id k13so11366808qtm.12
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 19:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HbY62YV5pb9Hfx4P3shXifbC8TndbAXOUagIox/AV1s=;
        b=ptmBQJPQsuXb6A1uEWlmuXNa0qtfbrNgeGfNXtZA/l2TTcoeLU0ogKdKjNRQiqwrMv
         RrUSwNtve5i6eqM6KT27He55iVzuANvgzvQbs5v42IRwiCuiY7EOWhaPq7HupCeozuGW
         ztuMySJXDVLI7gcPFruFRX2ohubFrTNDG1tGFA2pNBIz0p49ykGJis6YfxXN9/lpFp08
         4xOSTmaPvnV+MRjNE03v3hyrQXkJhx75Yp5RnybkLYdZ7QRbCs+OH6rvKRru71yM3gfP
         aKPPP0XpQLEbvZE5BHK0N+liTKzVss2EnKETGy8XXix1yJ3C5GR2gY+G8DJKHY67GPnR
         KSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HbY62YV5pb9Hfx4P3shXifbC8TndbAXOUagIox/AV1s=;
        b=WhK2rq3dpaZ8RKKhrRqh0br83cs4biBnRJ5nvycOAV5uBqyiwqC63pbJMdcyD532lk
         pXHAkNkXc+2vpNYka55biomfy3tHjnwqVFrCbHTHNUeY7BAKt8kwn0Do7ZWYew0gQO9d
         eMVbefKugZpxvES689GE6bGR+YnjJ9gHBT26M+FLajiNlEvP2sn06UfSjCrsQ5l+e8oL
         SYGPHhljLJZ23VRa3nh+JTXqy/muOdqUT+3k01V7Mn9+n1C6Hjo+Zg1PRbk0zAuQEgd0
         01rPRl8wdobpcey0NG63OT4HWOqLWFqnA+9XYzP/bVtjr8TFNwg1P+ghkmox0i4XQnVO
         eP1Q==
X-Gm-Message-State: APjAAAXvFfRyfi0tcnjEqOE2z64ug1tnS7qFOj7fvAdlpZzXCtfpWKPt
        k1H1/qqM2Kozn7W/sjBFP5WqDw==
X-Google-Smtp-Source: APXvYqyVGbZPiqbFpO7k4NS8OpwbqhyTgknbQgzrENZCqyryTiJYS94uxY+pyW5Zf8BV2Nd2uIyAQA==
X-Received: by 2002:a0c:ae31:: with SMTP id y46mr1001617qvc.172.1565751487013;
        Tue, 13 Aug 2019 19:58:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w24sm65506083qtb.35.2019.08.13.19.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 19:58:06 -0700 (PDT)
Date:   Tue, 13 Aug 2019 19:57:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>
Subject: Re: [PATCH net] net: phy: consider AN_RESTART status when reading
 link status
Message-ID: <20190813195755.19570c51@cakuba.netronome.com>
In-Reply-To: <46efcf9f-0938-e017-706c-fb5a400f6fbb@gmail.com>
References: <46efcf9f-0938-e017-706c-fb5a400f6fbb@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 21:20:02 +0200, Heiner Kallweit wrote:
> After configuring and restarting aneg we immediately try to read the
> link status. On some systems the PHY may not yet have cleared the
> "aneg complete" and "link up" bits, resulting in a false link-up
> signal. See [0] for a report.
> Clause 22 and 45 both require the PHY to keep the AN_RESTART
> bit set until the PHY actually starts auto-negotiation.
> Let's consider this in the generic functions for reading link status.
> The commit marked as fixed is the first one where the patch applies
> cleanly.

Queued for 5.1+, then.

> [0] https://marc.info/?t=156518400300003&r=1&w=2
> 
> Fixes: c1164bb1a631 ("net: phy: check PMAPMD link status only in genphy_c45_read_link")
> Tested-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.

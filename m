Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223ECD8043
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfJOT2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:28:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56319 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfJOT2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:28:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id a6so272476wma.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 12:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EbAnyTOslp6v1Q8FsmUFH6BpJr8FNaYvIMIlQEjnqCI=;
        b=G90I0dyrX3/1JAVSlVemOrG13hF203/pZ3Lk38+XtGFF4rkUlZ/iPoV1/27W04fCiN
         rLpCP/3Dz4tB/k9Gq51AKs4+FJ1LW3x+x/bQdVmWSl036tb3ZB/sSuRMc0A3vXrj25ZN
         i7dh49TtP7P6EGenJ5aLCCZT9aHDh8pSWd5g04fxKv3T+uQL22Cn0LUD4jDYyOAnZllD
         1kjxE3kIPbGN3ZQR9vPIA6GQAbuZE/2M2uwOgW7IFirWuitnCb86tY9t2WShf+n+d/by
         vvR7SIag0PpihD6oqYflk2DE7u4BsxgixPGQTxK/LkrkBW4o7ur01/8OJwnqNhUXb1Py
         QjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EbAnyTOslp6v1Q8FsmUFH6BpJr8FNaYvIMIlQEjnqCI=;
        b=J/GhMgsuBH2YrDt+8HpImDCqhUA38dw6gJg7gRI6ibZM5N+cQyVtC2Ts7HtIVNXVdS
         JXWbeBnTZ7OlPUL/SJuPF8Bo+RTx7/Ff5357YNuy+TBWcegWdKqH3nUD/3WkrirNgT6Q
         ggeo0HVAlt3FvS9j8bZ/Xw/Zg6/AicuYHzKs0UiZlVlug1tFFMvKBK5CgruW+ra79aIT
         iIAFM8SV71RCYISn74fpS/NE3YRNmrtEBjxRUQ6xAuCD/6z2hOXjMRiQFYzOIeP2uRhH
         XtwqPR0Za13KVNWlwFKrY1ziD0d3ErEo/oQPzOUew22AI679m/EYxKKSjmzbl9/oT/BP
         gfbQ==
X-Gm-Message-State: APjAAAW8KE2e+Hm0uR2n3SrWM0mziCQw0HV8yt04NEU+jIZIPZhenfJk
        TtJUvZ7Vs2Ow4ZqWe6C3v29ueA==
X-Google-Smtp-Source: APXvYqz7nP0l7vdHzimkwgpLFEg+eNxzWXUfJJzNLYDn7AUPiBz5wwZf6tij4i9ykaeLXoR8PZtrxQ==
X-Received: by 2002:a05:600c:2318:: with SMTP id 24mr60488wmo.146.1571167724173;
        Tue, 15 Oct 2019 12:28:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i1sm342582wmb.19.2019.10.15.12.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 12:28:43 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:28:36 -0700
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
Subject: Re: [PATCH net,v3 1/2] net: ethernet: mediatek: Fix MT7629 missing
 GMII mode support
Message-ID: <20191015122836.78bff48f@cakuba.netronome.com>
In-Reply-To: <20191014071518.11923-2-Mark-MC.Lee@mediatek.com>
References: <20191014071518.11923-1-Mark-MC.Lee@mediatek.com>
        <20191014071518.11923-2-Mark-MC.Lee@mediatek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 15:15:17 +0800, MarkLee wrote:
> In the original design, mtk_phy_connect function will set ge_mode=1
> if phy-mode is GMII(PHY_INTERFACE_MODE_GMII) and then set the correct
> ge_mode to ETHSYS_SYSCFG0 register. This logic was broken after apply  
> mediatek PHYLINK patch(Fixes tag), the new mtk_mac_config function will
> not set ge_mode=1 for GMII mode hence the final ETHSYS_SYSCFG0 setting 
> will be incorrect for mt7629 GMII mode. This patch add the missing logic
> back to fix it.
> 			 
> Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
> Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>

LGTM, thanks

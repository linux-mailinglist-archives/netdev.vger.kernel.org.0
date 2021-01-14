Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3780F2F56A5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbhANBub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729853AbhANA0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:26:53 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B16C061795;
        Wed, 13 Jan 2021 16:26:12 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id p22so3883533edu.11;
        Wed, 13 Jan 2021 16:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDsS/z4mXF9eMrJqA0x1EbI049u2C8sU9wgOjVH2AZY=;
        b=A4qsZrlXN1DpGsCM3hXGpFWTEUAnPUFXzO+9aBWZxqR0TDVcJfX47ZVbwalmvpIBO2
         AFzjuctGyVDXluq+XJas/vF7qfAUHYl1D7SFqZhB5g6OMH3UVFdfygtm6afNiaaKDHf9
         /y5/PD9IPi49Rdcl2DNPHkJVvn6avxlLfnfJ8s6E6scqMWzDprUHKf/K1TEyB+Ppbkpn
         9FCll2h0BrBRMPzKUFaY9dUrkwxLJ1Rw9XwCEhlwFHq9ZyNqBF7h5SCwJdf0donS9FJp
         070EY5EEHNG/MWOBovK4O5wrLT7EddhobpZjj2xi2bCreqtmKohPaZ+ocj8BQVnklFAh
         PJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDsS/z4mXF9eMrJqA0x1EbI049u2C8sU9wgOjVH2AZY=;
        b=YjHaPMGv6d1DyR6HnUPPwNOXs8PtxhqQhblNj5R2v2o9VmA79g/v2qz8Fap8FWigLk
         Pdxg6AJvS/mgSQJsRTLkMl4XPOEOypb4Q6NL9G3aLGW+WsPH9Ja6/j1VYjAZKUR4sU7s
         x5RUO8MgUllArjufnuU4ruMzJ9ZLVbl55l1crgdbUGE0jhZF39oj6S4LYkMkWZx9yxv0
         1nfSESS+TfplNePmoVEfJTOqtolk/yB5pIFF2ODDdEiwc4RTo3cvGfHoGk3uoP2c1HVY
         vZ8KscZkfq51u+Kmm+hSMZcwmkGNGicJcKR+2QbPtw8vvS64YqJWdwAI5dgb+Jo6+tb+
         eSBA==
X-Gm-Message-State: AOAM530j8WiMWcwm5SZRkf+TNr3S5lrBRJX+QsZkc75+d4DX3xS7hyzJ
        ZOIpJ2afTt6wTfw9L3XDjIM=
X-Google-Smtp-Source: ABdhPJyCmrSMxSMsVfAqfjhVJAweHKBZpQgFheKCR/6QVxyAKZyOq3hYBG8NgYa64mIVaKy7huM7EQ==
X-Received: by 2002:aa7:c698:: with SMTP id n24mr3674666edq.277.1610583970764;
        Wed, 13 Jan 2021 16:26:10 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm1533356eds.87.2021.01.13.16.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:26:10 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:26:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/6] Fixes on Microchip KSZ8795 DSA switch driver
Message-ID: <20210114002608.hldp4w3drwtdforq@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:16PM +0100, Gilles DOFFE wrote:
> 
> This patchset fixes various issues.
> It mainly concerns VLANs support by fixing FID table management to
> allow adding more than one VLAN.
> It also fixes tag/untag behavior on ingress/egress packets.

As far as I understand the series, it "fixes" something that was not
broken (but which nonetheless could take some improvement), and does not
fix something that was broken, because it was too broken.

Good thing you brought up the bugs now, because FYI a tsunami is coming
soon and it will cause major conflicts once Jakub merges net back into
net-next. Had you waited a little bit longer, and the bug fixes sent to
"net" would have not been backported too far down the line due to the
API rework.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=b7a9e0da2d1c954b7c38217a29e002528b90d174

You should try to find a reasonable balance between bugs due to an
oversight, and "bugs" due to code which was put there as a joke more
than anything else. Then you should send the fixes for the former to net
and for the latter to net-next.

Good luck.

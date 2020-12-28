Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D190B2E359F
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 11:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgL1KAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 05:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgL1KAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 05:00:12 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EFEC061794
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 01:59:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g24so9243304edw.9
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 01:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ohmxakg2s974QnM8v946sOkR4ToKBSOibLcBOIb3lZw=;
        b=O8mxvwijH80CKd3cIzi4GTRtJM12Uw6Idz9RKqMi+rkSkEBeVcEMd/OpidJIpAVm3T
         B/dgPn25E3fcOFjes5ZO+YtdJFuevUJf3XGLALiDi+I6dkvu8NqTHvpixRZFLZoWztFe
         VjN77g6aUT5n2S0wLQ1Vc3EdChmQSNGHnwsiIANEXQK7lw1JocpsfbfEjYDjIIMVtQ0V
         VSQT/69hRkdhhQZ3WTkkQFuuFE7X0iWk1y6v619PVXpqrDo4SaeuWNyCslomISQlU2A6
         KfIaWHPRwfFkNq+ADY6RGarDI2GFD7sU+5DJ+ObMzt6kJIzeU4IreltsvEIgXjsDR9pI
         Ltlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ohmxakg2s974QnM8v946sOkR4ToKBSOibLcBOIb3lZw=;
        b=OIwhNdsMN+gu2XS+8TH9I1cZlWg0hWVi6C19SUd51lH1vDz74yYTtcMAU7Tb3aqfT1
         osHrKtH3gFK2GVBEVlLLXL6hT3sVowmJOyQoof2zAzV3unBwffh6PNnPBbiSsQdrh3ek
         MEVRMDXxRKLHDTpxrNHpagpyxyPqi+cuimG4UOewLhTHQK+JlS0LYcDZ/TCOMUPaPsZ2
         1koetB0v8uXOx6jfrO/ioLqxyRaZdIdQXl7x24Tuut+MV4HdR4GZId6aOkW0UbpfT0cS
         TCKB0ONeN9cgJykFEKoZmCWLHyebSkK+v/6Ytfj5elMZIxKXrIpz+PSepFd4T/cwa7qM
         E0mw==
X-Gm-Message-State: AOAM533w+7RikJgxYcG8KqwqFqF9pDQSN73AekYnjMkII/HPNsYxn+ko
        78SJ/jWpbQi9IYqVY/P4Vueeew==
X-Google-Smtp-Source: ABdhPJy78Lupt7SboqBGFXs6LyLUicBN9prN/z0zgpnCjapDwAjner/CywqBp8I4xQ87ZSQvb/ZTug==
X-Received: by 2002:a50:aac8:: with SMTP id r8mr40900026edc.9.1609149570304;
        Mon, 28 Dec 2020 01:59:30 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j23sm22561262edv.45.2020.12.28.01.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 01:59:29 -0800 (PST)
Date:   Mon, 28 Dec 2020 10:59:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [RFC PATCH net-next 0/9] Get rid of the switchdev transactional
 model
Message-ID: <20201228095928.GA3565223@nanopsycho.orion>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 17, 2020 at 02:58:13AM CET, vladimir.oltean@nxp.com wrote:
>This series comes after the late realization that the prepare/commit
>separation imposed by switchdev does not help literally anybody:
>https://patchwork.kernel.org/project/netdevbpf/patch/20201212203901.351331-1-vladimir.oltean@nxp.com/
>
>We should kill it before it inflicts even more damage to the error
>handling logic in drivers.

Awesome, I totally like this patchset. To be honest, I didn't see much
or a point to do the transaction model from the start, yet I remember
there were people requiring it. I guess they are fine now without
it or they don't care anymore.

Acked-by: Jiri Pirko <jiri@nvidia.com>

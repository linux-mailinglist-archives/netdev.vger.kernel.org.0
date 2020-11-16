Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F394E2B543B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgKPWVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729352AbgKPWVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:21:49 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAF9C0613CF;
        Mon, 16 Nov 2020 14:21:49 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id f23so26716704ejk.2;
        Mon, 16 Nov 2020 14:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LvKmyBClDrxmbOjdU4SYq+jmudR7ixga/tzYs7bA34Q=;
        b=JD3P5Bkj+ckKSW8BmML8odAS4B3PCgzONPezUA2pXhDV1+UOtiBMZXN26AflYkDYln
         BXp8JUNkxlrXO+W5skJ8Wv56HDTmBbnstTzUakTI1hDXM1imm20RSanS6guno27rJ2Bp
         oDMKGLfOumHuUChHpYAPDMcncrZ283ZBbDV7OoBWWUXLT/BcPXcfgBpIaF9iP38otF1W
         l/tN+WXyuWAzicbxHuHFc9ydqBN1P82qPObUcuj+6vXTlZ12oRTWWnoGr9ekHV8FnNFj
         qWRUxODga2bwy4aa4gPkalpJ+dUMmBba6AJLiTpPkMBb4vKtVSniwFeJ4JfuAQgL/A8g
         P4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LvKmyBClDrxmbOjdU4SYq+jmudR7ixga/tzYs7bA34Q=;
        b=n1LhmGqEAG4EHZwlpvsa9/ZEAIN0z+qcbGv5hhv5bNqnQT02gBt8N4VIX4gtgR35o4
         9rr34kAaT7CUWLJyXa/1RX2vX3BwmUcVf01zxSK/De3IILxMX/3iHc773thM/ZLlOe39
         sqjqJ9sAsiTiIlljlw1en53wZGhgb/WfhsAq8mqjiIeun76VGSEoSfKa3Fuy1WYo3l/7
         VgHWcZhnctQdSqt7JHO36eqvgTcuM8J1uOO86MAFIrZ+IYefsFfqonsDMa4wbr2Ons8Z
         rYXOyBqldg8Hq/73S+Jo4sCCFNwSrnyDksaFkZFAflaCE6fWtOiQHCrkvWEAgDqhJrid
         MnUw==
X-Gm-Message-State: AOAM531wgy6X/s3HfVwHqhNmqTJz+STvRbM7HM9hFY+7pkt0FRBv5ykU
        8+02wtTdC9JKTptdVEHB6x8=
X-Google-Smtp-Source: ABdhPJykTKVIHmQ5V/fxkZU1REYE6zGqtAXZAtmBijltU6Sw3wuKFrMyT/Hz2TqmAIUh9+5k72XdMg==
X-Received: by 2002:a17:906:6c93:: with SMTP id s19mr17303243ejr.544.1605565308089;
        Mon, 16 Nov 2020 14:21:48 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f18sm11273742edt.32.2020.11.16.14.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:21:47 -0800 (PST)
Date:   Tue, 17 Nov 2020 00:21:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116222146.znetv5u2q2q2vk2j@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
 <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 01:34:53PM -0800, Jakub Kicinski wrote:
> You must expose relevant statistics via the normal get_stats64 NDO
> before you start dumping free form stuff in ethtool -S.

Completely agree on the point, Jakub, but to be honest we don't give him
that possibility within the DSA framework today, see .ndo_get_stats64 in
net/dsa/slave.c which returns the generic dev_get_tstats64 implementation,
and not something that hooks into the hardware counters, or into the
driver at all, for that matter.

But it's good that you raise the point, I was thinking too that we
should do better in terms of keeping the software counters in sync with
the hardware. But what would be a good reference for keeping statistics
on an offloaded interface? Is it ok to just populate the netdev counters
based on the hardware statistics? And what about the statistics gathered
today in software, could we return them maybe via something like ifstat
--extended=cpu_hits?

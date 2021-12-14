Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44550474CD0
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhLNUyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhLNUyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:54:18 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90099C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:54:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so66471194eda.12
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jJzVIxIwAcRhrQBADY0zhgs6ffMlJwwbNnJr4iyIrko=;
        b=BwIEMSaVYd1Zsb7rclznV5/jXEQOTl2YbwpdOrUM06uduXUHYdGRCAv0OVnA/JIk2W
         CQk75Q+Haj5fXW3T5HXYJrwF4PITuu1A5a/pFxlz+uVk6H0N/SRdCxaf9eNkM0dPrfsp
         sxJwjNE2ZOrTALvCDxmfMQBSD1HPQtg1X552CNEY/N+0NY1etRTwVV6vmV3Pwu3T083+
         ulfcKAZxQxltlUBh5JXkptwWB3SRw2QAWYkRacE8N0+Fkmc8QXiL6eU/uIC2OuaFWe/Y
         xsnJZcmJsgTTMtBtSah80gNc/x+Q/7RmWpCPN57qcFQOPs/g+UZi3Wku/nhI70oXBSXr
         cFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jJzVIxIwAcRhrQBADY0zhgs6ffMlJwwbNnJr4iyIrko=;
        b=Nyu/rNTiZNVLBdo8GqQI211lfo+VmxVhsY3yCrfyZ7RE7Rjqc9D9BhXWSjtf74tSDe
         25sExOo1j5bQIWbTt44/4szX+vWkpEsAiMYYPvPeIMoE4SGUsrhppRXXcd4zWmnJTZIu
         7+ykRTMTS/f6XsOfb2HkeJGcGvElzB4WL81iMFtgloJ9foel4RJvNb4XnwUDc0QsV+vt
         ZiTepBP8YE9sbtB6paWyv/No7RXo6EmdJ7bgoKwdrsVdshZJa8bbI57i8TOuL5qDth0U
         /bD/CvrZIo+Pp8Nn+B/a9BuibVOC0jsyKO0+CtR272hybt26oFlv/oKeasdKFh42mgth
         3Pdw==
X-Gm-Message-State: AOAM533WoRmJnhpfFEb+Qd7p8ZJssItnXhzDxOmGOOm4aY8mM/JaDuyu
        nZClnffFd8lf5xRU7mzyxOc=
X-Google-Smtp-Source: ABdhPJz/tw4sLjqmGceCgnoqIUMUv6ixOx80kZmMXKH7XRQ7TovgdKh/xtUHVB2pg4oDd0Zm3GpIFw==
X-Received: by 2002:a17:906:f43:: with SMTP id h3mr8233949ejj.414.1639515257073;
        Tue, 14 Dec 2021 12:54:17 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id g15sm276133ejt.10.2021.12.14.12.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 12:54:16 -0800 (PST)
Date:   Tue, 14 Dec 2021 22:54:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] net: dsa: hellcreek: Allow PTP P2P
 measurements on blocked ports
Message-ID: <20211214205415.yht4gogvddifvnh4@skbuf>
References: <20211214134508.57806-1-kurt@linutronix.de>
 <20211214134508.57806-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214134508.57806-4-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 02:45:07PM +0100, Kurt Kanzenbach wrote:
> Allow PTP peer delay measurements on blocked ports by STP. In case of topology
> changes the PTP stack can directly start with the correct delays.
> 
> Fixes: ddd56dfe52c9 ("net: dsa: hellcreek: Add PTP clock support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

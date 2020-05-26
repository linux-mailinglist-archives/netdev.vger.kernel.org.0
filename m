Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623501E2810
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgEZRNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728503AbgEZRNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:13:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B4FC03E96D;
        Tue, 26 May 2020 10:13:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id q8so10446014pfu.5;
        Tue, 26 May 2020 10:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F1Q0365fQcCdID2kLoD71mWg1BqQGJpoHfozbnd6CZc=;
        b=G93tJd93hLmaoT/aqbZdcPYPDjj+69hVL/nYU9NuDv8vJYlGr1uvLmZfdmFlCfih+F
         uUaTNz24k3eX5ISGzDL9OG64MQ48hvOBQASoJaYIFVworZ28Fa8DeyElhu1uECrDMjfz
         KTW4TVQzLQ3WpfAhJwQkymTuW7Xqj1PkJZEM7bR1EJOxwJf0HTTQERezzoueCeNDs7WT
         t7+s1g76ekGrhBvAvrMrFtcaVsM06qSUy95npV1gLlbr8SpuRjdnD5ZHany8FdqKsOno
         FnsSlPpeY2y4Oq7NBIOiEYJCrLujbnIAqvFxTe17BsPYzOBqsN//+WZOHHfjsO+dsu6T
         tC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F1Q0365fQcCdID2kLoD71mWg1BqQGJpoHfozbnd6CZc=;
        b=UcGhiJpLPfFNGR1EuwsMpd8oxIihTKe0c9+sHVIizsR5vinIMTDZEhDOGT5AirsPuS
         QwfNubsKrp3uVL4+pzdv9V3cTqzC+rd2xG2hawlv/zV5oKUmh4iVCy4N/IvTo1ABmknK
         hPycWXNIji+tfAnjzf+1iwqLed/AX2oP9foyNZ6e3oj7/Dlbk2bve7iq3xTXDippEdpD
         rgcGEGqZ/Yp7xSqN/FqEP8dsrLevOv79NaRL8c4zq/DU0haf5o+nRkN9vmKhjST5UZ9y
         hZY+3K6VXyEJc8VmFhW0Rc9vRUx6lX2hxPqqeVns52lnqAmRoysQpju/oK7WHZfzcnSM
         kN4w==
X-Gm-Message-State: AOAM530/fagNDLDvLoL60DYgB940SGpvgKJRiO1PIlKctkK5l5DFzADw
        jlotEbCEDid7JYq3NY24bIM=
X-Google-Smtp-Source: ABdhPJy6qnu3WKbboaapp37lyLqmDYBXjUJcrBs4IPyQ0TWCoI/A9XkzSFJfpV+fDfaBdlrk3WenwA==
X-Received: by 2002:aa7:95a5:: with SMTP id a5mr22174411pfk.151.1590513201862;
        Tue, 26 May 2020 10:13:21 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm119304pff.120.2020.05.26.10.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 10:13:20 -0700 (PDT)
Subject: Re: [PATCH ethtool v1] netlink: add LINKSTATE SQI support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
References: <20200526082942.28073-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8c167a35-c49f-9fc1-d53a-6970d4c95e75@gmail.com>
Date:   Tue, 26 May 2020 10:13:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526082942.28073-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 1:29 AM, Oleksij Rempel wrote:
> Some PHYs provide Signal Quality Index (SQI) if the link is in active
> state. This information can help to diagnose cable and system design
> related issues.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>


The uapi updates should be separate commits as pointed out by Michal,
with that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

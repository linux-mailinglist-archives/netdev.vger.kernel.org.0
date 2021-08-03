Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5923DE9FD
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhHCJtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbhHCJte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:49:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FFAC06175F;
        Tue,  3 Aug 2021 02:49:21 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j2so24563764wrx.9;
        Tue, 03 Aug 2021 02:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WkKYrqAH/p3yb7AGf0mOVeBhocXEE8pQBGTyhds/SrE=;
        b=jb11dqHMAsfqSvVkpRHpswlyJ3KzHcUXgIhVoUg0xBhXFfLwbi6uiIjxx7vx0l9voi
         p7+HD+D0SQs/zBkuQxr13c009CqMTmwirz8Lu0SJEcmB+fOSgqtL+URz9f933VB+swqd
         drE6FhtVrMeISSAWtKimLn057zNBYkAeus+ORYoFNJhwDpq5jKf+NhwToJEQWM6qNm8p
         v6G5otOMXC8eBKCTbZtXjQsHgc7bI58xCRVXHz71UXVRI45tOqr+tFIU8FH8o7J5tRal
         6qCwknImDAaJ3N9w6d/vFRyo8KDzRUxxZJOZvk/7OL/w2QSJeh65/itw3DRUOHqjdlBM
         OLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WkKYrqAH/p3yb7AGf0mOVeBhocXEE8pQBGTyhds/SrE=;
        b=r1h+VaabSxgTQ5pwRSLmT62eb3xrijwYoI+Z5TV08Si72C3JNS1zNslnkqeazpAF2D
         XLTFXSsJEPNNQg01trv2uo+YM2PNgRBvesDizmR7q5w5b490C4XrZ/DDFAyL51mGwR6n
         YrCyhoHijHXQvDgx/MFMbiIdOh3NjLcHKLjFOra3AnaIFmrZq/vlR8wdKOZDcAz/NLVg
         YA8XjkHkthgcmUnNerj77e5sm7/rIrTQsdyLmidCbIxrGTSmZ2fRKlBgA9VuXmd8ZyeV
         N0ra4QoMEBM3glQd+AS163/VCTzVuvXaoopAXkl06+n7dJIKcyQMUiJJXe3DlS7/Xvq6
         +/Zw==
X-Gm-Message-State: AOAM533qIENkX1fALQ17t8OHmD9IAv+qJciebDpAU9r6UCV6GqF6njWH
        N9TCpB9QSvRNmTr99QggmIAR3FcUCRtcdQ==
X-Google-Smtp-Source: ABdhPJyaPy+flbIPzXZWQ3NSokt1sGpr884HoXO285d3l1dsfZxCgEAF9UdLQfBRUCZpALg7IZp5lw==
X-Received: by 2002:a5d:4803:: with SMTP id l3mr22400917wrq.131.1627984159822;
        Tue, 03 Aug 2021 02:49:19 -0700 (PDT)
Received: from ?IPv6:2a01:cb05:8192:e700:59e:566b:b6f:f3db? (2a01cb058192e700059e566b0b6ff3db.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:59e:566b:b6f:f3db])
        by smtp.gmail.com with ESMTPSA id k18sm1941613wms.1.2021.08.03.02.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:49:19 -0700 (PDT)
Subject: Re: [PATCH net 1/1] net: dsa: qca: ar9331: reorder MDIO write
 sequence
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210803063746.3600-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3bdbe4e2-00c9-afee-5bda-7267ff2bda3e@gmail.com>
Date:   Tue, 3 Aug 2021 02:49:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803063746.3600-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2021 11:37 PM, Oleksij Rempel wrote:
> In case of this switch we work with 32bit registers on top of 16bit
> bus. Some registers (for example access to forwarding database) have
> trigger bit on the first 16bit half of request and the result +
> configuration of request in the second half. Without this patch, we would
> trigger database operation and overwrite result in one run.
> 
> To make it work properly, we should do the second part of transfer
> before the first one is done.
> 
> So far, this rule seems to work for all registers on this switch.
> 
> Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

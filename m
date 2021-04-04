Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5E0353627
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 04:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbhDDCSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 22:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbhDDCSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 22:18:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2F5C061756;
        Sat,  3 Apr 2021 19:18:06 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h8so4128083plt.7;
        Sat, 03 Apr 2021 19:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogPlJCl307ppzwE32UAHrOUEFBqq7KLp1IICe+Xs+wc=;
        b=QwS7hEwIp2Ql81JgIDk/cFvIY0dgKuHD5gETHIsVZOxFq5CENCyR3uDchLTLI0IWOE
         Xh+M0+Q1YZQDbZbvndFYs77eDNNIEbBMsQdhxRiMrwU4lot4QHNNZfEsSfNgvPw9hOsk
         F040i0tpraDNkhbfcMjGTR0PWozlDHyVfoZsQtoKPdXnuHkDRpclF6sePI8Z55lWiGXk
         WDEQ4K9yz4AsC/bV/J8dl/H9DgKpHxDkD73BXfUtoN3D7353OM6Fe/i0IxxEiWivUZGt
         OrFRZnNGqzHOfLIj9/DfLTKhN3bzZeVVEjIDhjv6TveA+YN0lxTuPuclmjODVwjRS1E/
         7JSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogPlJCl307ppzwE32UAHrOUEFBqq7KLp1IICe+Xs+wc=;
        b=LRx2VEs2Fr+iJ7R4Eh2fCpAIyauM9XD8RnTdqAn1T5LwVxIvmmm2uLrTV2ravPBgQh
         nJGJtZr5MBfE+1I/PJxecR+VZsqOTRBvJjI3ncvYVb3yW7cSPAD8mB/y6EPgLe0ZwsaU
         Ppbt8gdpa5pusJqkY/pWcDTYy/kYKR2hRNdYHot9FpVQ8F6C690cPC2L/hdufFQ2ZNfP
         svii1uCT98hG1XoAYi3DeyE+SVbHmtaO1XH5N9vHWyf9J2HVrCfzT9XK/U6/bhqJDzML
         IGaNgk6N44ZL+YQTf0HO4IrPokeW5d7f9qJM43mRqdEH9YF8pSmulv5o3cjw3Q17kvx+
         FidQ==
X-Gm-Message-State: AOAM530pSx9FaE0LW1bRTuwJ+5laLb3cjoDYwp0G/Lf8oEW32o8Buj3H
        SwI8YZ9CZiMrPpLq4jY7BZg7ryo+GKQ=
X-Google-Smtp-Source: ABdhPJyXQ8bz4E1DNYZgF5SKyo4C3d/U1/w77VU6DY59MosrOVcVFndjI1pTbiE6jJnNwLAbZfMbHQ==
X-Received: by 2002:a17:90a:fe93:: with SMTP id co19mr20520799pjb.142.1617502685566;
        Sat, 03 Apr 2021 19:18:05 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:d9ea:8934:6811:fd93? ([2600:1700:dfe0:49f0:d9ea:8934:6811:fd93])
        by smtp.gmail.com with ESMTPSA id j3sm10645347pfc.49.2021.04.03.19.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 19:18:04 -0700 (PDT)
Subject: Re: [PATCH net-next v1 3/9] net: dsa: qca: ar9331: reorder MDIO write
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
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b43d3738-391b-cfab-d20d-fb6fd30752b1@gmail.com>
Date:   Sat, 3 Apr 2021 19:17:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210403114848.30528-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/3/2021 04:48, Oleksij Rempel wrote:
> In case of this switch we work with 32bit registers on top of 16bit
> bus. Some registers (for example access to forwarding database) have
> trigger bit on the first 16bit half of request and the result +
> configuration of request in the second half. Without this this patch, we would
> trigger database operation and overwrite result in one run.
> 
> To make it work properly, we should do the second part of transfer
> before the first one is done.
> 
> So far, this rule seems to work for all registers on this switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Seems like you could send this as a separate bugfix for the "net" tree 
along with a Fixes tag?
-- 
Florian

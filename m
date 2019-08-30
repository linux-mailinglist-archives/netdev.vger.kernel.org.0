Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0EEA2C37
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfH3BV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:21:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32788 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfH3BV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 21:21:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id go14so2494453plb.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 18:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YXCp75rK0Qyzg6kzVVR4V73a9w8Z/QXHdXxxNx64vEo=;
        b=rvc3lRopbzeZHypKdYN1M+T0Pcuy6a4PFH4SvHLbHhj/7rJTGYEJBPz7vRwBi1/8Pg
         Zfyrafh26MEWhPnUsAHjij5jr1SjReJU//avswQF6KvRozjnK1raZ3AkzjT1SpISs0Ov
         9Nf+Xs5wDE4brTzzKeWX5DkgJDrsbX3X4xuTe6RquovaWoic/xeCMAqSD1c33RgnLnom
         L/Wm7PZHVLZ+9vcFhnmCbeYIrmk27pcfLgs0vqM0kaUgZSE44hpTZm1HugedHuSZRKgX
         8H51GnTGS/1EutzivPW4vmHja51uEevvO1wkez6K64po7NZaNk+ShepqaBjEO3HeJLww
         IVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YXCp75rK0Qyzg6kzVVR4V73a9w8Z/QXHdXxxNx64vEo=;
        b=IZync40yjDbcNXpoPHnfYKJLz6Apa+C+bNkorqn7tz4Ynv9iEi4kx2/FIxsBsppJY6
         0BGD4ixzlxVmpKiuU+/PJT8WJ31rhwOYcwekGaS1N4e7iJQDLbwV7WCMXNW8M0FpCAIq
         yBmx/xBhevyonkKC1P0P1IkMJ68pkus6MiFgwMyi/wts4mFGarbaIrS9YCDV5AwYErxK
         P895ZpKzPxhxSkGDW4Ay/vmWmM0xVN/eyBTMCB+VLVrFGgJysD+eJG3tzHziyk31DDhf
         GqDXLLMk9+mop6cRS5LZSAINKsFqWyulMdPiFpxxJKTY1yReT5EBfKx5vVdEyHQ66zBd
         jTmA==
X-Gm-Message-State: APjAAAXN39cSxIZuzpmS2kUFOmvOcNkwP3dDuL/6gYm6EBdR+HLq4n2k
        wQ+nzuSxw1XTV9CJgFA9b/J8/w==
X-Google-Smtp-Source: APXvYqwaOa+AYRU5A+BPF8iRPkKBVnlS6pkonbmG/CKHwB+mDQdKTwDnK3V0NbgdR59hqLA9RKq1Wg==
X-Received: by 2002:a17:902:e493:: with SMTP id cj19mr12871862plb.292.1567128116053;
        Thu, 29 Aug 2019 18:21:56 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y16sm4704826pfc.36.2019.08.29.18.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:21:55 -0700 (PDT)
Date:   Thu, 29 Aug 2019 18:21:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190829182132.43001706@cakuba.netronome.com>
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 03:46:20 +0300, Vladimir Oltean wrote:
> - Configuring the switch over SPI cannot apparently be done from this
>   ndo_setup_tc callback because it runs in atomic context. I also have
>   some downstream patches to offload tc clsact matchall with mirred
>   action, but in that case it looks like the atomic context restriction
>   does not apply.

This sounds really surprising ndo_setup_tc should always be allowed to
sleep. Can the taprio limitation be lifted somehow?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B6A3DE81E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhHCIO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbhHCIOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:14:55 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EEDC06175F;
        Tue,  3 Aug 2021 01:14:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so3696424pjd.0;
        Tue, 03 Aug 2021 01:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=/9SojXjYKulRNr83vm1FtyvmUfogZ+luvbdjXo2aXGE=;
        b=NccFQpSsZHFQ8ok/Yr5CXCW9v0dzQ1Zzb6LDno1qVe5rjruvHUf6+ZczBQwwEtcAx7
         GUsIBfM8aIX3bpsC7LNuNnrE1xY2sD/4+vrlEd+KRyr3PgoPn5jl2TtxfToASawXpTyh
         qfF4CnedozBoBfR3IQFAnwBw9Mh8WzG0HpQjkFmM4zkx4jpKbEMNS9TyJBQlBlLsrYrG
         QhLvKmRHc3zpD8oz3SuLJBiKpDi1K/3zWlusjSxIbLkrnA2tVt1xRXKtm065Ztt7nKMd
         ehTN2l44m7y2WKz5Vjw73a8YOzyrCo1TkTLPi6b9RFR2Szpn4xsRQSIHs46Urmx1Vc21
         x6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=/9SojXjYKulRNr83vm1FtyvmUfogZ+luvbdjXo2aXGE=;
        b=fvXMzix2Vr9SMiMmOOMGoTXYN36sDPEwTjGbcHQqoS2OxF8jXCgkroYOM3TIR+cxFD
         d7iLhKmLVp2JCqRysuS3GGa9pwKi0b/pz5nm+rA6M9BHnfcHhsV+mXQHEzLRGg4l+NxF
         Jk88I4lJDxzU6xLk9hXH6HYLPpeQrDronvLORx4kPbcRvkS+q5HH/d0S4R/0R7phoQpo
         byqaX5fJHFHjZK3TbGBCWSsaAsXoZAf3ioDpb+eaLMshBaeM+a1f4eg25E94PSfnezM2
         uV7sb/slUgrkKsu+ICKUrfikTPKic87Zl8SxPw9uASKLD0AsHLJg5Ck1wyQlxo7LqlLM
         30ag==
X-Gm-Message-State: AOAM5315Gh3cu3xknGTE1bD3yEVKAaKytej/GlGcjweiMlRyisUSKvAG
        gr8cdHaUgDp4mJiikuWxXZg=
X-Google-Smtp-Source: ABdhPJwXGuLapacqlKKksk7rDnddiutOIOrRkxXIEA687wK/6T2sd9dyDdrn8LcuOcf1LyCNcFdWfw==
X-Received: by 2002:a17:902:8648:b029:129:dda4:ddc2 with SMTP id y8-20020a1709028648b0290129dda4ddc2mr17376567plt.4.1627978483528;
        Tue, 03 Aug 2021 01:14:43 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id i13sm9165359pfq.72.2021.08.03.01.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 01:14:42 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: dsa: qca: ar9331: make proper initial port defaults
Date:   Tue,  3 Aug 2021 16:14:35 +0800
Message-Id: <20210803081435.2910620-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803065424.9692-1-o.rempel@pengutronix.de>
References: <20210803065424.9692-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:54:24AM +0200, Oleksij Rempel wrote:
> +	if (dsa_is_cpu_port(ds, port)) {
> +		/* CPU port should be allowed to communicate with all user
> +		 * ports.
> +		 */
> +		port_mask = dsa_user_ports(ds);
> +		/* Enable Atheros header on CPU port. This will allow us
> +		 * communicate with each port separately
> +		 */
> +		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
> +	} else if (dsa_is_user_port(ds, port)) {
> +		/* User ports should communicate only with the CPU port.
> +		 */
> +		port_mask = BIT(dsa_to_port(ds, port)->cpu_dp->index);
> +		port_ctrl |= AR9331_SW_PORT_CTRL_LEARN_EN;

All user ports should start with address learning disabled.
To toggle it, implement .port_pre_bridge_flags and .port_bridge_flags.

> +	} else {
> +		/* Other ports do not need to communicate at all */
> +		port_mask = 0;
> +	}
> +

Return-Path: <netdev+bounces-1967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E0A6FFBED
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:38:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 064541C20F64
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28C9174F0;
	Thu, 11 May 2023 21:37:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22F42918
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:37:59 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABEB7A88;
	Thu, 11 May 2023 14:37:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f4ad71b00eso16272425e9.2;
        Thu, 11 May 2023 14:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683841072; x=1686433072;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HP9IX+oFYEkrid2vkZ3A+oMe1Mtqy6JGFpwOKyjaMok=;
        b=QdJCtUjea8qftgI+GZM8430w5EaTtcdx0/3fVmTE5ljy+b8kGp6zY1hEL+T3jRwcDB
         QESTDMbpcuD0mMfAOgxzRfLlfmXniMDbmgwKc2fQBGE1SIt70IlPPrD6GC2KjphkFuFo
         oq4WG1QEh+6r6Thsci69a2/2IavsSWOB5zkgGXkopBmTqYJpscD1Upo6pgBCO8nTKWJm
         hKZ+HhEQKWDNicDH5TW3c5ejYIpn/oIJ0DCuDTINPf+FheikWZ5YFAzqvaBBvqS+4X1Q
         OZo0uI0Md1CdoT20igJ6qom+4JD3rO9wLmcMBUK/uhch9/p5KLqYzrztuXklH4VoJ0XD
         fRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683841072; x=1686433072;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HP9IX+oFYEkrid2vkZ3A+oMe1Mtqy6JGFpwOKyjaMok=;
        b=YsPUEgpUXVh+yOnwmAPxqPGE0O7ngFhSs+aflWC19tE8+i1Awgfv16na2NO5FGuvQ0
         SBw66RCvjJdWPtQ4n/QooI8QYE8WpkQWhblWlm9Cd4ghlaNpPRxheHSfc2BmD8XirSfu
         WdXGgfHpPpe5+CUpy7iYy9K4SgWzOJcDUEpK8y7iQ1gZaVZczv4BHtEVrZGOSq7bLGI9
         vI0qF1y04JNpta8hu4U7jYIXxVcu6Oo8ekl4QAlSGr+QeHUW32hxCwW+KR4/gnH7Qb13
         VzsHuizwHsP2MY9P2pnsjbDBrfb47Z8/qnVzptstcCMWSNHPWyu3WzNMGvLtmk1dNXEy
         uDlQ==
X-Gm-Message-State: AC+VfDy0EOg3gFjOt1kcQkslVS6OTgtW0agOrim8GHWrEUrt6oJhfNYm
	xu/MT9Om6cbNJWsj7hQeqyU=
X-Google-Smtp-Source: ACHHUZ7ZIcU6DfMmilb1gsY37lnau5Q0qoIFKe5W0rGcb++N2S1k1GKwOFjgI7qkBb/p8RbCtXHR2A==
X-Received: by 2002:a7b:c381:0:b0:3f1:8c37:fa79 with SMTP id s1-20020a7bc381000000b003f18c37fa79mr15931005wmj.31.1683841071831;
        Thu, 11 May 2023 14:37:51 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id c3-20020a7bc843000000b003f42314832fsm14806666wml.18.2023.05.11.14.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 14:37:51 -0700 (PDT)
Date: Fri, 12 May 2023 00:37:49 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: alexis.lothore@bootlin.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	herve.codina@bootlin.com, miquel.raynal@bootlin.com,
	milan.stevanovic@se.com, jimmy.lalande@se.com,
	pascal.eberhard@se.com
Subject: Re: [PATCH net v2 2/3] net: dsa: rzn1-a5psw: fix STP states handling
Message-ID: <20230511213749.j2be7po5n2vgfwmu@skbuf>
References: <20230511170202.742087-1-alexis.lothore@bootlin.com>
 <20230511170202.742087-3-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511170202.742087-3-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 07:02:01PM +0200, alexis.lothore@bootlin.com wrote:
> From: Clément Léger <clement.leger@bootlin.com>
> 
> stp_set_state() should actually allow receiving BPDU while in LEARNING
> mode which is not the case. Additionally, the BLOCKEN bit does not
> actually forbid sending forwarded frames from that port. To fix this, add
> a5psw_port_tx_enable() function which allows to disable TX. However, while
> its name suggest that TX is totally disabled, it is not and can still
> allow to send BPDUs even if disabled. This can be done by using forced
> forwarding with the switch tagging mechanism but keeping "filtering"
> disabled (which is already the case in the rzn1-a5sw tag driver). With
> these fixes, STP support is now functional.
> 
> Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> @@ -344,28 +376,35 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
>  
>  static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  {
> -	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
>  	struct a5psw *a5psw = ds->priv;
> -	u32 reg = 0;
> +	bool learning_enabled, rx_enabled, tx_enabled;

Absolutely minor comment: in the networking subsystem there is a coding
style preference to order lines with variable declarations longest to
shortest (reverse Christmas tree). Since I don't see another less
frivolous reason to resend the patch set, I thought I'd just mention
for next time.


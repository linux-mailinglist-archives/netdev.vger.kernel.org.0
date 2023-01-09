Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478D1662709
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjAIN3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjAIN3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:29:50 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D83BC0F;
        Mon,  9 Jan 2023 05:29:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u19so20008961ejm.8;
        Mon, 09 Jan 2023 05:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OnLgVlQcPUmhGddpJYGzFYAsfQhj3TvV2AMn1iaicV4=;
        b=U0mU7RMxkmdrEdFGy9CJinO/If0ziVK7HzWZwo7R85GUyz6cSI7XQD1JoGsqiEp8tA
         +QcYaPpK3zPBijaX+YJd/w6l9Y1ItyCd06CMjFrOG3WZJHK15sDrIMKJgGDnWpAbA/1n
         X9a13cQt3BTasjrHlr+X3cWfIMcdKAKeeRp/S2sVSELPIftbUS+whnD2WERmwB6QqHe2
         5o/V1B9CA4Ura/1X6EXDtpUbZiC2DYYTTxiIEE5cgG2PBCDJgsxrXPvN+CThUAbvucsc
         At+7UXZq/WrTJIwbwRFHnmlfji81yAHU2tpuVQFPVo7BJKxR0pzsOzGWPXQFKSVQHdBz
         1YMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnLgVlQcPUmhGddpJYGzFYAsfQhj3TvV2AMn1iaicV4=;
        b=B6FiHHTZ8kCeizRSNORRAoeU4yPWdcQTKVfJOZMYu9yRfioSmdDv3OczcQlO2w0e98
         RDS33V9dEcAzAKdx96BIpVPeyWP/a81pLOkgPZD/cH0b21/misSkbrTLPPhoewkBeMRN
         WVq20zDRP2LO6cFkkmYvmryCMkkAIYcz4eo1Cb29LEwto0YD6eLMpW1bJzM+b/ihOzew
         bN8Vx/w9Y2SeA6BE+SrHFLVYkqRrfBe8CW8XgXGfAzAwpcZW4oy4M9SoJQSZh1pI1gTX
         e8DGvfyyBKTB50lHxauvR8WEwwQjWnxDffmilTpkfMdC0pJ267Efp++J6qhkCejDIeAI
         kD5Q==
X-Gm-Message-State: AFqh2koh8exg6Tn0aAobQ/7x/1yqQOvXTFYrymDCJYYJTVF/RoGFE6Sy
        F6EWDIFPPcAYkc/Z3FoJZAw=
X-Google-Smtp-Source: AMrXdXuk/fs7Fa0jTnCxkLCt/vvpaLyKgXMW78MxFDCX5QqZMNBLOgiPVgoxVohrUH1FftyprV4BLQ==
X-Received: by 2002:a17:906:280d:b0:7c1:2a0f:55b1 with SMTP id r13-20020a170906280d00b007c12a0f55b1mr60218751ejc.14.1673270986856;
        Mon, 09 Jan 2023 05:29:46 -0800 (PST)
Received: from skbuf ([188.27.185.38])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709062bcc00b007ae38d837c5sm3761223ejg.174.2023.01.09.05.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 05:29:46 -0800 (PST)
Date:   Mon, 9 Jan 2023 15:29:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 2/3] net: dsa: mv88e6xxx: shorten the locked
 section in mv88e6xxx_g1_atu_prob_irq_thread_fn()
Message-ID: <20230109132944.ipczdt3oj2kpfppn@skbuf>
References: <20230108094849.1789162-1-netdev@kapio-technology.com>
 <20230108094849.1789162-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108094849.1789162-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 08, 2023 at 10:48:48AM +0100, Hans J. Schultz wrote:
> As only the hardware access functions up til and including
> mv88e6xxx_g1_atu_mac_read() called under the interrupt handler
> need to take the chip lock, we release the chip lock after this call.
> The follow up code that handles the violations can run without the
> chip lock held.
> In further patches, the violation handler function will even be
> incompatible with having the chip lock held. This due to an AB/BA
> ordering inversion with rtnl_lock().
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

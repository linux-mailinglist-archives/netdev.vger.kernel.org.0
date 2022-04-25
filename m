Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4050D67F
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 03:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiDYBWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 21:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240118AbiDYBWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 21:22:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7445D668
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:19:35 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a11so2192954pff.1
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=twjKUpWANBumQ25AlQNsVztOik/nSUL/y/DPoxklvEE=;
        b=MG8iVw0ey3oC5+3CuF7StSPv9yc7/DoafU+RKBl350fSsJp1UrHhhCSKQqWrKoM62/
         g7sZBAc3JSobXMCNgFSZ6SX8dVJg0EBM2r9V+H+M9xr3cKLTHCozCs7WHzuUR6S/6ec1
         yIsVMC/tRP6C1iQnRMvXorqHjC3ow/nW4WR/gEV0zgc9PW7BC1XxPeF35YZ2NYHep5Hl
         li3sQ4j5k7zXqiDtBVHtthIWpfgziOzwTFM1wf/EQ+DCeKr3o3r2DGLEhKsatkzcX0no
         yjYNoZat1P4Y4bB2xN0aeFDn3rlSnc+tDkYAV4y9oeR7wzzv3j+R8Ter86u9Os5hoPgH
         DCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=twjKUpWANBumQ25AlQNsVztOik/nSUL/y/DPoxklvEE=;
        b=JxLLywssDoyZ5v9xHogagy9a67s6aFRu3FvD+gwFL1MSGnbtii/4P/v5hHm/ql7C5k
         Pno2FECOzJwuEvqv5NVQDhGk6IIqO0d7FwubIGr3+b0edqhChnLW/BDip7qn4i3zXPl1
         IGKihSTY2IW6Xar2NPSxCbE9WwtO0oHvZQvZB9t71NfKlrxRoZFVszHtPF2K2WxQce8o
         ie11mjqADHaRO54/UqQYHPELM67IZnenk/HB9VZxA0e64q1AJHkCCfZnxnKqc8XN5IA3
         LnGVyPVR6YREbyL7dmvG/N3aBylv2zk+HxROz8QeSGORblOWamFopnMZTYlH2HWbgqa0
         TCQg==
X-Gm-Message-State: AOAM5324wXfvKOuJOONYkddyYlYOW8MVFZ0MAkJkqbXo1K5STPNGgrYw
        qusJY5xbF7bCNOziKTVJmAE=
X-Google-Smtp-Source: ABdhPJwzSEU6LKqRDLReHnh+FtsoAH+DFWJU2ibdPI29ED2ClTtU64gOZDQKtV0bmU2BomRnBaKHVg==
X-Received: by 2002:a05:6a00:23d5:b0:50a:93e9:965e with SMTP id g21-20020a056a0023d500b0050a93e9965emr16722200pfc.10.1650849574619;
        Sun, 24 Apr 2022 18:19:34 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 123-20020a620681000000b004fa7c20d732sm9113659pfg.133.2022.04.24.18.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 18:19:34 -0700 (PDT)
Date:   Sun, 24 Apr 2022 18:19:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425011931.GB4472@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424022356.587949-2-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:

> +static bool bcm_ptp_rxtstamp(struct mii_timestamper *mii_ts,
> +			     struct sk_buff *skb, int type)
> +{
> +	struct bcm_ptp_private *priv = mii2priv(mii_ts);
> +	struct skb_shared_hwtstamps *hwts;
> +	struct ptp_header *header;
> +	u32 sec, nsec;
> +	u8 *data;
> +
> +	if (!priv->hwts_rx)
> +		return false;
> +
> +	header = ptp_parse_header(skb, type);
> +	if (!header)
> +		return false;
> +
> +	data = (u8 *)(header + 1);

No need to pointer math, as ptp_header already has reserved1 and reserved2.

> +	sec = get_unaligned_be32(data);

Something is missing here.  The seconds field is only four bits, so
the code needs to read the 80 bit counter once in a while and augment
the time stamp with the upper bits.

> +	nsec = get_unaligned_be32(data + 4);
> +
> +	hwts = skb_hwtstamps(skb);
> +	hwts->hwtstamp = ktime_set(sec, nsec);
> +
> +	return false;
> +}

Thanks,
Richard

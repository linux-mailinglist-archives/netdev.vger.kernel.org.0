Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AF667509D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjATJUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjATJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:20:15 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF31EDE;
        Fri, 20 Jan 2023 01:20:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b7so4267338wrt.3;
        Fri, 20 Jan 2023 01:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4H5o1b9Ms7Ozi0FsB6Noqhmr/uWFh8slPEVAaOnL02E=;
        b=Isx5iwovEeR0Nvmzt3uXxV/DUX5lA0BNGOuM7jUtppRNJPSRz1t9VgCS92+FWEO74N
         ZIECBlauyS5Z3C/A9cDIPFEEu1xmPpNju9S+sz0ijxdBAoLsAaKOHSLaD6q62y5cE9L4
         HOPkn6VL+6+CBBVK1/Pw8edW4BDP7/5RLtLdOnsc/TkLLRSz4ZC3+vXKeV/jeSLmN8j/
         3BzPtcXXF0Jno1dr+e0WQfvAIspajmbxfICQjLrl8deaWukDy2uHqSyAdW/1GGn2yXR6
         vN0KsEspT6N5xejEQ6QEYVLsUaZl8AfGp5oPReTTm8Q5A6K8QZQdhJJGg/xtI1B96NMG
         0eIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4H5o1b9Ms7Ozi0FsB6Noqhmr/uWFh8slPEVAaOnL02E=;
        b=MSYiQrQygrdDOMiX/MV7ktUpUj40DSEEbtRq7+Ui/lTLpJbPteRsDtB9puANBzjGhq
         ZT+k85ztcFHNtKKCpyVtqPc2gccsb1rOuMStzf1TT2ETEMH3/lSwR+WkIXM1ztrllyVi
         HNvW+nBZthuDXhz3oHn5MgTTMaSnWoPd9dpqTLrgXBLDtJqn6pufd47grbM2b6sHSj0X
         zMjJzYUjF3GzW8OK1vJNt0je53J2sO7FMHyfKcb6JKNewdk+gntrn3sahFVwZmf204bD
         LLl0TCNZFBbP5x8wpaRUQl9kpMkRQp2e8mcG6sjhMS0DRVF5med9WyMmsd1yzdzQWJar
         qTXg==
X-Gm-Message-State: AFqh2kqCbwXK7cc5EqJKVaLBwWUh7PfCZWPP/YorbmEwTEQSCbNpTG4a
        3uAWUaYWEc8QgUGkLg/I92w=
X-Google-Smtp-Source: AMrXdXs7qSOqzyxI5jhiyJayhO2rG15Pz+Bh9icCsQvwnaJnxN2/k0f9XWsFeIOcQ28cZ4Yy5GSTRQ==
X-Received: by 2002:adf:fbd1:0:b0:2bd:bae0:8de5 with SMTP id d17-20020adffbd1000000b002bdbae08de5mr11463507wrs.58.1674206412245;
        Fri, 20 Jan 2023 01:20:12 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h3-20020adfe983000000b002bdf5832843sm14728101wrm.66.2023.01.20.01.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 01:20:11 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:20:08 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 7/8] net: microchip: sparx5: Add support for IS0
 VCAP ethernet protocol types
Message-ID: <Y8pcyOn2tgscwO/A@kadam>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
 <20230120090831.20032-8-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120090831.20032-8-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 10:08:30AM +0100, Steen Hegelund wrote:
> +bool sparx5_vcap_is_known_etype(struct vcap_admin *admin, u16 etype)
> +{
> +	const u16 *known_etypes;
> +	int size, idx;
> +
> +	switch (admin->vtype) {
> +	case VCAP_TYPE_IS0:
> +		known_etypes = sparx5_vcap_is0_known_etypes;
> +		size = ARRAY_SIZE(sparx5_vcap_is0_known_etypes);
> +		break;
> +	case VCAP_TYPE_IS2:
> +		known_etypes = sparx5_vcap_is2_known_etypes;
> +		size = ARRAY_SIZE(sparx5_vcap_is2_known_etypes);
> +		break;
> +	default:
> +		break;

return false; to avoid an uninitialized "size".

> +	}
> +	for (idx = 0; idx < size; ++idx)
> +		if (known_etypes[idx] == etype)
> +			return true;
> +	return false;
> +}

regards,
dan carpenter

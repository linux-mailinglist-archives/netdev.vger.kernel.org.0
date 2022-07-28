Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D985583618
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiG1Az5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiG1Az4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:55:56 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2D75A2F9;
        Wed, 27 Jul 2022 17:55:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j22so557044ejs.2;
        Wed, 27 Jul 2022 17:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=heYoV5fSvwFSYO3IxD1olBe1fDtvUC4jcV2+G7UYBRA=;
        b=OI+Z/oL2ronUsu2Gsta8991dVXXa9mLxRuZPF4T5Z79DSQ2aYF/XtzeNfwDzTTfnlH
         zwtsHowaXObkQMIhPH+VvUjQhjCd6AHsnyarg8pCteauChA764r/M59qShSARkBWJTu1
         G+hwAQrfM12HdZs+B/S5FDZmS91jG88BzYjlsFh9q7fSqAp+P8pVe0OJjZ6izp29p/dg
         88XSmU4EkipxfBeN1pYl5UB+3l6JBog15+9deNrroSKjqaLyI0ZsXTSoZXPcfxgVYCRm
         zPqgJGMw5UU5xF8iVJ1PIcSK0LUl0UfGWcjLDV2wRR33U8B+Ok/NBU5OKhTVROLJ1pBT
         8gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=heYoV5fSvwFSYO3IxD1olBe1fDtvUC4jcV2+G7UYBRA=;
        b=jxjENpqDvgqPUa+BnZmqDeDEF4w9M15ISEOMWMJhKi3b2Q+Zox2wvpLNTsHGR5Inq5
         RYYc9w/HU9RNxRvWqCl1kXW9/qN1jPEUQunEu1k4Ov2M/6u1HP8IcoRHy2kvoD1l+dwz
         7gHo+hdLxBhD86JLnNpaaW4NP5Bfc7dCFnsELDv2B7ZxHjCEDti0oXiaRtMqCw+ysZwT
         Gx6LFcoXVbM9KMNyaW8shuc4sg9H/ppX5ku8xoGEVtH36+Fr3BVTlNS3Z7rNDvX6czoE
         p8wgYV68LHIJ8gMDW16f1trxIO5+9SDfL4X8PrSUm1eXSPDj9mWzUeASDIRLDleQ9AaE
         MLiQ==
X-Gm-Message-State: AJIora/v6rWnfPUjYw09yNn1gjeI4et8L2tGLjs3IRL8pUlJZVDX80mw
        yL/P6f0WDX4Mx4Ugnppr4VE4WDNs7tA=
X-Google-Smtp-Source: AGRyM1s+QC7Uq9vb+l/I/SxeK96Eaj5ZmxSyWN3GuejGLXSeHbBFsfEXSGa/08w2xHsW/+tV9Ohc8Q==
X-Received: by 2002:a17:907:2d12:b0:72b:67fb:89a5 with SMTP id gs18-20020a1709072d1200b0072b67fb89a5mr19346795ejc.507.1658969753673;
        Wed, 27 Jul 2022 17:55:53 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id s20-20020a05640217d400b0043baadb2279sm11233720edy.59.2022.07.27.17.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 17:55:53 -0700 (PDT)
Date:   Thu, 28 Jul 2022 03:55:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] net: dsa: microchip: remove of_match_ptr() from
 ksz9477_dt_ids
Message-ID: <20220728005550.amch6d4wlygg5l2p@skbuf>
References: <20220727025255.61232-1-jrdr.linux@gmail.com>
 <20220728001648.cwfcmcg75lpqip5v@skbuf>
 <CAFqt6zZF-bTh_8vYxwhG5wWvCkFHc2duK2A14_Fdt9Agzfkxwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqt6zZF-bTh_8vYxwhG5wWvCkFHc2duK2A14_Fdt9Agzfkxwg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 06:16:50AM +0530, Souptick Joarder wrote:
> Few other drivers threw similar warnings and the suggestion was to
> remove of_match_ptr(). Anyway both approaches look fine.

I don't disagree with this change, I'm just saying that as a next step
we may block this driver from even being compiled if CONFIG_OF=n.

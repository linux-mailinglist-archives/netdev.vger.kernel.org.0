Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9105828FB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiG0Ouw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiG0Ouv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:50:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798383E755;
        Wed, 27 Jul 2022 07:50:50 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l23so31931578ejr.5;
        Wed, 27 Jul 2022 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=isWnztje5tstM7edgrduRx0RaEbKQwk8/oOOQONRCl8=;
        b=gfRgHcn1q+DgnbXdYQJcrPcRc9rkVJ051UGzvx0ESR8n09eLyoxuZu+IGcFN17ILFl
         UUWiRBIgqesBe50nYgHnKPNGbwvHFwxfd5mm5cjQw68kdvqJYJJBPwmj0LKzYBndxKKK
         kOulPg6hKNXqjBo0zhydMFhc0rsKd/hWzqKiDmRgy8sHcb83v2M5SuNYdshhW1T6D9u7
         ck5Nly/0NnOx8X2hkFJSW4K7HXMHkkAzI6+XsBBicEsWTw7i5CQWclFxvpVhEOCDTvjO
         hLoO+quVPfmZbWau4QA11cWzoLcHDyZ+pQZymevxmS/AD0c5n1wthOdVbPsG8+5QKdo2
         wC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=isWnztje5tstM7edgrduRx0RaEbKQwk8/oOOQONRCl8=;
        b=IAoICt8y3mtbReqKOq0iHM78uGWfGMuhga/Z8DbivCWbuTq5+pdyqcpwyn2uVH34I/
         oawHm7dP9jsdDHsnLhkt23gttbzITzlsphzW2ca51eiio8KYLJYA8FrIfmRU4ydff3HD
         Bg2Uvy2hDnpft37gZB3Y8zecK+VQRVFfJMh80p9JJctydPWWRBfISG3EAW/dzQ5yAGGg
         TVQcknOoFN0Jd1ThONsuiupcIPmON8oLtxaBrK7N4KPVCCQfCOiOJZJFel7xf5bFmIS7
         ZAlmhVguAcs52Tfk2n3i6REaQGabYJ4G6Em/DcqDTmDqy+2TI7QgSUIrlMgW9jZNr648
         bIbQ==
X-Gm-Message-State: AJIora9aouxG39DXK0A+TVbnFn5N8SI1beZN0GNKDdvKeb+5Ez7dXPl4
        yCRtGxj4VGae50ZDwE95yxk=
X-Google-Smtp-Source: AGRyM1tH3fyxkralipHbCpBky6s6tIdvaJuupLWwSVu3JnFx7PEsv5qyNhwjlDNVizJZNnb0GNj14w==
X-Received: by 2002:a17:907:1b1c:b0:72f:9aac:ee41 with SMTP id mp28-20020a1709071b1c00b0072f9aacee41mr17902078ejc.56.1658933448933;
        Wed, 27 Jul 2022 07:50:48 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id w8-20020a17090649c800b0072b2378027csm7696512ejv.26.2022.07.27.07.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:50:48 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:50:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v5 02/14] net: dsa: qca8k: make mib autocast
 feature optional
Message-ID: <20220727145045.s545bzwk4zcu6ggj@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-3-ansuelsmth@gmail.com>
 <20220727113523.19742-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-3-ansuelsmth@gmail.com>
 <20220727113523.19742-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:35:11PM +0200, Christian Marangi wrote:
> Some switch may not support mib autocast feature and require the legacy
> way of reading the regs directly.
> Make the mib autocast feature optional and permit to declare support for
> it using match_data struct in a dedicated qca8k_info_ops struct.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CB759895F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345104AbiHRQxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239618AbiHRQxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:53:08 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF406A4B1F;
        Thu, 18 Aug 2022 09:53:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id q2so522419edb.6;
        Thu, 18 Aug 2022 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=GOWW/qFhZlHI+4MNURyBEz3OtdlugS1ktx9LFuaupsg=;
        b=o87xqvSeDmbXvW+okF/9yO7iUirFTOoRQ5QlpY4A6ULUi9VagfCCCxmB+6Dm0uafEP
         i2wkBJK6y0jy30/iITXPF265OaEUkOKfSqzKg64unNiWq9RGKqbrueQQARu8cUGcoXuR
         9Ld7Z8E78FyCONZmqyNAQ/L8rAUT6geh+yv5slNIw18X48LSqW1kY0V2DT+aLEbCfKBL
         GbP+gaUSO3AEzitWXejkcLXfgkPIZL7SiiEM2V+YjVL2nk1yMSCfRUghGKNaF22U92/l
         k6V1G9QQ/5BDNTEnR81MhYPzCia6D0NoSkcaemKFSm6GbGoyHYXaplAE1jUyntaxuz0K
         KQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GOWW/qFhZlHI+4MNURyBEz3OtdlugS1ktx9LFuaupsg=;
        b=h8X7ELF1J6glxOuaBIgwJhuw5rBDlQkfSxLRk6AgjJMZBmfA9ovQpFBWkxd9eTFjR0
         dJcdIOt6x2EiEFzZAPN7eIPgz4hYcKv2CLLq5dO1CPD5DF1s0UH+nn3pN33RtvRtiE5I
         rhY3OxVh3WNN5930sLYb3XJwXv89BDigGxAFB82dhaTTGyAZwWVphuVlsrik16NWCBJ6
         z/ygW2kUODXCbBHtwmFKuSYoegFWdJM7Tz0fmPTXMrdYnNNVVJQDb5USQTy5SvED+fhR
         ip9TOmJZatmNOrB75kL09SwotX3t6Q7SrNQ+o2pXci0rp4Z7tcRFAbJC+Qa9CZtZdsTf
         FOhA==
X-Gm-Message-State: ACgBeo0xqhwq7UluxVJB0Ie3r1KAMwfybQ7LIzt45qWdoAKOyjNkeEad
        CfRdCNy0TkGr3sIjCd+WHYc=
X-Google-Smtp-Source: AA6agR77iZ5BBrGReAEA8LTqA21WJutAcKsnKcB6RpzR02r+YSigZMoVG5S0dxPGKYYDujx67X2MPQ==
X-Received: by 2002:a05:6402:3907:b0:431:6776:64e7 with SMTP id fe7-20020a056402390700b00431677664e7mr2942577edb.0.1660841586273;
        Thu, 18 Aug 2022 09:53:06 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709062f0b00b0072b7d76211dsm1054375eji.107.2022.08.18.09.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:53:05 -0700 (PDT)
Date:   Thu, 18 Aug 2022 19:53:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
Message-ID: <20220818165303.zzp57kd7wfjyytza@skbuf>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-3-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725153730.2604096-3-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 11:37:20AM -0400, Sean Anderson wrote:
> Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
> clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
> operation is supported.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---

What does 1000BASE-KX have to do with anything?

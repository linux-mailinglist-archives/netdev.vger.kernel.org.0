Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E740578961
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiGRSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRSQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:16:05 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F672CDD1;
        Mon, 18 Jul 2022 11:16:04 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l23so22814010ejr.5;
        Mon, 18 Jul 2022 11:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7UDF6r+GMUXDZ8LsxT+YDZqzkLbdjQrKJwZqxdgZ6QA=;
        b=bwE7ePkNhjlgzgFJcf8R80Cpe4O4RxVzT+v4Go9vlS1Ru0ut08zdll78zjfqd4ZQVg
         0E9iNszQGa5+3o/D45yi0O3je7YNipQcbXwX4ZfgsBSfYUOktMF76yZ4wnH6ORjM+dSG
         wNYTqSn3uTfOU6ybPHXg7IGLV95MK9YFk4AH5hluKGoaV92QeZ1baMRyhtQIzMz+R3mP
         GyFjNbC/0HBVPlJ8y+YYd3STk0rgwkRK6P19aVzpD7q6mAevXGjbOWLlnAXrLZNykyO/
         Mp/OLSRvLIszCiCfxCnRezDRqYC4O3DxhANzaaAjqQCDMKkAiJrruz7Cck1yMZ2hcz/F
         5hlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UDF6r+GMUXDZ8LsxT+YDZqzkLbdjQrKJwZqxdgZ6QA=;
        b=e5LMgfvb7CS/RrlTLtf9UeaNAU8bGiZWGYdNQ2irEJWWjRB0i0b958tTNC0m3430fz
         p+2UUJXJ93NnVqaNYY6bZn0bO/MVyWNoq7DOx9JJ3KSE1zouo3yVvb4uGCNRabwUPYm9
         noGvrnkVPn0W019f9il73WXQhgMTVO8kgCrZTd5QGuHLr/sOMglT1qKkg8JdK7qcBZB1
         xX1gft7enVGceYTF8o7c4he0vju/mlCnC1qb0UcV85aDfM7aZwiW7KzvvyaqiA9l2QML
         9BBm7TBamdbb4VSHYWuGAeLzNcvnws04lNZFvpq/mjfwaPHRGtRBIzRIA+TsOJ7Q4Xe0
         BxbA==
X-Gm-Message-State: AJIora9B7mn1A8RCRpu2lZQEeR4E7WbhMMy2sm82g289Ge+Qc++uKDLS
        aQrw8mE+w3QIjR11dgr5/Qw=
X-Google-Smtp-Source: AGRyM1uDElJDptc1QLTVFcqYz1rmwXnCcaQQnLR5QHnwWrTkGr0Sbec+dTtC7wfL2O1OO4IGPFwbMA==
X-Received: by 2002:a17:907:3d90:b0:72f:2994:74a1 with SMTP id he16-20020a1709073d9000b0072f299474a1mr7027324ejc.261.1658168163062;
        Mon, 18 Jul 2022 11:16:03 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id lc13-20020a170906dfed00b00703671ebe65sm5661284ejc.198.2022.07.18.11.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:16:02 -0700 (PDT)
Date:   Mon, 18 Jul 2022 21:15:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/4] net: dsa: qca8k: code split for qca8k
Message-ID: <20220718181559.lzzrrutmr2b7mpsn@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <62d57362.1c69fb81.33c2d.59a9@mx.google.com>
 <20220718173504.jliiboqbw6bjr2l4@skbuf>
 <62d59b1a.1c69fb81.a5458.8e4e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d59b1a.1c69fb81.a5458.8e4e@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 07:23:35PM +0200, Christian Marangi wrote:
> Ok, so I have to keep the qca8k special function. Is it a problem if I
> keep the function and than later make the conversion when we have the
> regmap dependency merged?

You mean to ask whether there's any problem if the common qca8k_fdb_read()
calls the specific qca8k_bulk_read as opposed to regmap_bulk_read()?

Well, no, considering that you don't yet support the switch with the
MMIO regmap, the common code is still "common" for the single switch
that the driver supports. You should be able to continue making progress
with qca8k_bulk_read() being called from common code (as long as you
leave a TODO comment or something, that it doesn't really belong there).

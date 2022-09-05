Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017A05AD827
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiIERK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiIERKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:10:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC1521263;
        Mon,  5 Sep 2022 10:10:54 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id se27so18247547ejb.8;
        Mon, 05 Sep 2022 10:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=tBVrdTB9xIC90iM4fjZnxcb7J9/VjAAw7Iau0YgY0UU=;
        b=lz6J9n65q56lFIHcXXrSupN7+Tr/wuCvFt8ZiuoLSvf7FVpITdaEBc6oBfjaEO8N6e
         lRdj/pdoadvk6NIFH0lG4D/QGxK7NghKtuSCNX/cln8Ph5hDNdflhw7jaWVCc/tNFyV3
         1g2YlomMx6/VU87lazh57CHPtYlrCqgpyOS/1ZvGM+fhoc7JBbgEdDj5dg331In3M3Ht
         sDtmAboW23fxrYr2fWk/kK919kppthdll3iKWyvuj7CsSZlcZGhwdDPiuYIYcob7XdtC
         4WKAXG9kn91PWsYG4al21dNSI4l2VvWLZMXg+wAtEQLr/t0vkez/ahtH7ikK2yP6Y574
         Ep/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=tBVrdTB9xIC90iM4fjZnxcb7J9/VjAAw7Iau0YgY0UU=;
        b=5D82PlIdQuWEqHqSC42E6F4MezTlchp/vPCLFlhjxmRIQpgsEtZtW7JnuoW/tGgv07
         6jMJy6dPujF/4/aV1gn0QrRCWZcbDNz6zqoJPV/7chyyG5yeIQLJXcVJecWmC3ecYKID
         bu5A7t99ANE2GaCAT2cSkQu4UQrLp6qLF6lA16N9e3qodzGuTmUh8K2SGtevbE1zxfrY
         dZk9vUKeandchrVEoF6FIYtI4PswVmOXMQaix68vb2Ndg1kHZNWhZPzC+sTp0Dc31VLh
         eJW1ZCkBnt8qfPBEzBSXhjpGdTgYrPxA+xUmq/SknHj28uo8SO2H95OVg8NtRRobM7gD
         fvYA==
X-Gm-Message-State: ACgBeo0R8ztpGaqH/2Yd8juD5Qemfvf6pZYD7pfhwAZPKFsJFI50Gga6
        L/+C4K/sU+eOltdZ2p4VbNk=
X-Google-Smtp-Source: AA6agR5z0t46w8Cc3nMbpBsPOYoDG4I+1Qjj4UCfM3lTlFV/8u/GYgPcukqOJtJ9ICTW6+WZwFZotQ==
X-Received: by 2002:a17:907:a057:b0:730:a2d8:d5ac with SMTP id gz23-20020a170907a05700b00730a2d8d5acmr35681838ejc.764.1662397852654;
        Mon, 05 Sep 2022 10:10:52 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ee35-20020a056402292300b0044dde9244fdsm3858332edb.8.2022.09.05.10.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:10:51 -0700 (PDT)
Date:   Mon, 5 Sep 2022 20:10:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH] net: dsa: qca8k: fix NULL pointer dereference for
 of_device_get_match_data
Message-ID: <20220905171048.yorwelgr2ondlji2@skbuf>
References: <20220904215319.13070-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904215319.13070-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 11:53:19PM +0200, Christian Marangi wrote:
> of_device_get_match_data is called on priv->dev before priv->dev is
> actually set. Move of_device_get_match_data after priv->dev is correctly
> set to fix this kernel panic.
> 
> Fixes: 3bb0844e7bcd ("net: dsa: qca8k: cache match data to speed up access")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

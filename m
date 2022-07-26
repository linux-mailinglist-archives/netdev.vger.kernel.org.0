Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A95808A8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 02:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiGZALq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 20:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiGZALp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 20:11:45 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AB81EC46;
        Mon, 25 Jul 2022 17:11:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id z23so23146377eju.8;
        Mon, 25 Jul 2022 17:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DaJtRwbaZ/95OtG2thhjgOOXMHffGiWf5BIXiFFlYzE=;
        b=ZNwE4oWkXbmyM9WjAAa01fxn8bKaTEE1+mmz5zCN5K4AzZbcSH01eAnKv9GlLiCeQ5
         QE+bjc/giI+rT/0Z7Dit1uA/o9nRJeWhrbp/+N6aCy9AIh9culhXqEtbCwcC3U47q/zP
         i+iOMsLzRJslSwJBOGi6J0i5NjBIFrAKhx+BlOCt0sgRpVyEh4wUM3jLQjc22lxh1Wym
         emAWMLBdtpzyMprIngrkJa4qCxH31TJGrMN01fhUnH+Qk3N9Tz9CFotXo2S7EdtYsuF3
         xTXiPF5cEBTzKdTBbsVSNI/ZAEEnixO1mXaWEUYO5AC2jBh3ZCiQkoy/MnhISRK+7my6
         DUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DaJtRwbaZ/95OtG2thhjgOOXMHffGiWf5BIXiFFlYzE=;
        b=fCZY2jYhpLb+y2rUng8WIlvSX8QWBNt5Cr14wuySTfsUZh8l2twATAzBjhnMqbSYmp
         23rFsye5GWw1v2goE1BMdeslhYIKwueQwRnhntnjCO0xrtVU5G8JXa6X4sq9FObDl3Xi
         DENI4pytcP/hBkK67p0twiMB/gFmYVpjezqNs9A2sk2aSQgHdPGkecDS3j3Q6WqFkf3s
         S9VbPuNHxnmGZ4G7kCvAa7vR4jsMycHor7q0DaqZspWlg8YOz4XjQCtxqqCTC1IL2mS/
         mPPBfWOb5RHbSIWDQOZDg2GSD4yP8z44D1D53oE42XuI5B49wRSlke/13bekTBOQqiPY
         4lDw==
X-Gm-Message-State: AJIora8xHEfiGz3zTf6H9l0Sq5XmTiYLrhx5Ij9H09E5XBiqHKwAm1n8
        UwdyWzdZTXfrOnGYpc7al4I=
X-Google-Smtp-Source: AGRyM1uz7x9+yKoOJpTInNUO1AytXtKOZpdkcvDGyE8rNpguwOznHSc0Ul/rMPxhFdhKXf/+tKfLpg==
X-Received: by 2002:a17:906:8462:b0:72b:4e05:a8c1 with SMTP id hx2-20020a170906846200b0072b4e05a8c1mr11928152ejc.443.1658794301810;
        Mon, 25 Jul 2022 17:11:41 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id g9-20020a50ec09000000b0043ba51a84f2sm7682375edr.14.2022.07.25.17.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 17:11:41 -0700 (PDT)
Date:   Tue, 26 Jul 2022 03:11:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 05/14] net: dsa: qca8k: move qca8k bulk
 read/write helper to common code
Message-ID: <20220726001138.lticvyixmwws7sj3@skbuf>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723141845.10570-6-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 04:18:36PM +0200, Christian Marangi wrote:
> The same ATU function are used by drivers based on qca8k family switch.
> Move the bulk read/write helper to common code to declare these shared
> ATU functions in common code.
> These helper will be dropped when regmap correctly support bulk
> read/write.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

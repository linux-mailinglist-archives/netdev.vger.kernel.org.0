Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51EC681818
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbjA3R7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbjA3R7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:59:15 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA63C2A4;
        Mon, 30 Jan 2023 09:59:14 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hx15so14640524ejc.11;
        Mon, 30 Jan 2023 09:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XHLoozyb2RYHzQtFH+RQ/5NcNp5JCD1/uIEcg70kyYE=;
        b=Fp4Fwo73tje/w2T0XpOX3seWAiXKAKoSFXxqY+kSJkre/kcKz5mT1vNWN7Tk/lik/a
         Pb46q/aa1tVlUjSs1askiNO7Z49paNuaHTFs+SRhJZilq5SLGKXtJcxTv/hSIT1DKkcp
         GjkURp0D+PScd6O+31pP8gHMPXkLQNmJtdgGB4ALQETvm6ZeqZm/FdxyFJkNizoqhYyR
         mhXS288p58SVq8jG4bg171F2YcX47uKhdozv5px8Eaa3DYM8K/XN3m9RthwI7cfcvxSc
         6zRTi+5r5qJYox2mfxmEf1Hpfw5+zrf7ld8zuPotrcPImsBYXPgjKHLSEXyQ+ifN1vTA
         uTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHLoozyb2RYHzQtFH+RQ/5NcNp5JCD1/uIEcg70kyYE=;
        b=q34Tlew/3jxOUXmg37z0IxTj8zYY7RdfBk8aYtRGYDw2she49HzsNC2Ht8oyR3XOs5
         WqFJR5vVZy/llyglSM8uXEOGJCiM01zVUAhUZAhgIsVQ6V+BHPpQvktnjjOXbQ14FnUY
         1PqabminNbNiu4NPcD7QX0KmgpwjBRYGRg/e78dXbDkTM9gUr625R6SUUM8A3q0X9YZw
         9zvGeAFM6M0tAEAQ96mwmeHrKFQnekgsEUwA9E4X966SEsidxv/YL1qBJQo85o/irNlv
         UxSgDMFrz0GvcX7hJK3sjaZiQFIfHgPR+nUZqi9wUk0tFeYtFARQkSBTxF1faM9WE4lP
         vLyw==
X-Gm-Message-State: AO0yUKUOsZpgKI4LTDuXrxTIYywHtddiEVSL4etdoK6gSbb+ZVO6OtL0
        xnXId72ul7DhH1JlXvUqrgE=
X-Google-Smtp-Source: AK7set+g9NdekGLado/RJP7WlMhZWoLOIwWHP9C41qfRjwV+VSAF/QsbUf6dKPy624p1TIHokfQHuA==
X-Received: by 2002:a17:906:55ca:b0:885:a62c:5a5c with SMTP id z10-20020a17090655ca00b00885a62c5a5cmr7439534ejp.46.1675101553456;
        Mon, 30 Jan 2023 09:59:13 -0800 (PST)
Received: from skbuf ([188.26.57.205])
        by smtp.gmail.com with ESMTPSA id c7-20020a170906d18700b00871f66bf354sm7087996ejz.204.2023.01.30.09.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 09:59:13 -0800 (PST)
Date:   Mon, 30 Jan 2023 19:59:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v3 01/15] net: dsa: microchip: enable EEE support
Message-ID: <20230130175910.bcr2fl5gvqczbccs@skbuf>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
 <20230130080714.139492-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130080714.139492-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 09:07:00AM +0100, Oleksij Rempel wrote:
> @@ -3006,6 +3070,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
>  	.port_hwtstamp_set	= ksz_hwtstamp_set,
>  	.port_txtstamp		= ksz_port_txtstamp,
>  	.port_rxtstamp		= ksz_port_rxtstamp,
> +	.get_mac_eee		= ksz_get_mac_eee,
> +	.set_mac_eee		= ksz_set_mac_eee,
>  };

<<<<<<< head
	.port_setup_tc		= ksz_setup_tc,
=======
	.get_mac_eee		= ksz_get_mac_eee,
	.set_mac_eee		= ksz_set_mac_eee,
>>>>>>> net: dsa: microchip: enable eee support

with commit 71d7920fb2d1 ("net: dsa: microchip: add support for credit
based shaper").

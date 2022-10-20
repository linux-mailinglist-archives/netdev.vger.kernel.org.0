Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD63606132
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiJTNMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiJTNMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:12:50 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D031D4DE7;
        Thu, 20 Oct 2022 06:12:19 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k2so47315625ejr.2;
        Thu, 20 Oct 2022 06:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+gkU/NqbzBkggz5iJ5jkNMymmdjI88HmNgirY0p7mo=;
        b=TPiipjpDMk6wGWOJP+Agw+/0B6vH+/ztEW3I5tVyt2LoCYXke1TXQmFBwagKR/ECpK
         gEOm4H8c5qA8hZGz4VSJZPpkqt/IbvYZ19Te5+K8V6qcAjLW+yd00jruzQfGjWyTw1cr
         D5eAElpBXfz6xrI/19Get5d4/+bXbVvXDLrr4XJpc6KgZGXdlyBIfs1ftcluwlcs3TzI
         FPdNNA1X3wp1dFiIVzbhTRBNAtVDAHuEP77BPZNag0f6UGW/O85leK27nNsrOFr5A8gj
         BturwMnkyEbZpgiYOgFFYhxOalzV668fNDGJNiEqvHrmEQZIJTIN3mr4jmBQMU8LwU4k
         tOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+gkU/NqbzBkggz5iJ5jkNMymmdjI88HmNgirY0p7mo=;
        b=7W7IWtjwhgG9FLm3wGD0kh4eBSTZZODWU5sd/gUIj2L4CyJZCAXh0iZ6T30vhGLLaq
         N7gBMAnqxK8/cuti85vZB2T2DhsxxQLkUz1d4FgGtthnpxSXkjJsISUEWPjCIx8egEJx
         NxxI84cqJzZWtpHWSPjnsv5beFyZjkKjKt9k87F2rhREmOC+7p+80LNN0PMO8aUDpdyD
         lQ4nN1hmcAKETXLP3ZC8qvBASh7NTTcMbqoMhW83LCvdP7V1Ig88PViuzdq8pY4zvlCk
         KhaQiUESTwnjgrTYF9l4Xrj2WVZ4wUGOPZiKMvJUN+IAt2F8XUndvaahNvZq0/1pnT+9
         20Gg==
X-Gm-Message-State: ACrzQf0lyu97Oqb28xFSpVKHGcl82Hf2k2iuWcSGZMqfDfAxBWI9EyCn
        znL4cnPSZFDTLtDUeEW/+kWUBsy9Y6Ucww==
X-Google-Smtp-Source: AMsMyM5DbMLGWM6/Y2wrW1N6novb2sRwX3cXwGgYvEbzR4IRYbS95ez4JesKLlaXMHBQzh6YJHjLTg==
X-Received: by 2002:a17:906:db0d:b0:77b:a7cd:8396 with SMTP id xj13-20020a170906db0d00b0077ba7cd8396mr11433584ejb.264.1666271466154;
        Thu, 20 Oct 2022 06:11:06 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id w11-20020a170906d20b00b0078258a26667sm10359958ejz.52.2022.10.20.06.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 06:11:04 -0700 (PDT)
Date:   Thu, 20 Oct 2022 16:11:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 11/12] net: dsa: mv88e6xxx: add blackhole ATU
 entries
Message-ID: <20221020131101.zotvyglhlayqdvu7@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-12-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018165619.134535-12-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:56:18PM +0200, Hans J. Schultz wrote:
> Blackhole FDB entries can now be added, deleted or replaced in the
> driver ATU.

Why is this necessary, why is it useful?

> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
>  				  const unsigned char *addr, u16 vid,
>  				  u16 fdb_flags, struct dsa_db db)
> @@ -2742,9 +2794,10 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int err;
>  
> -	/* Ignore entries with flags set */
> -	if (fdb_flags)
> +	if (fdb_flags & DSA_FDB_FLAG_LOCKED)
>  		return 0;

I don't understand this. If no driver looks at DSA_FDB_FLAG_LOCKED
(not even mv88e6xxx, up until the end of the series), then why was it
propagated all the way in the first place?

> +	if (fdb_flags & DSA_FDB_FLAG_BLACKHOLE)
> +		return mv88e6xxx_blackhole_fdb_add(ds, addr, vid);
>  
>  	if (mv88e6xxx_port_is_locked(chip, port))
>  		mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
> @@ -2765,9 +2818,10 @@ static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
>  	bool locked_found = false;
>  	int err = 0;
>  
> -	/* Ignore entries with flags set */
> -	if (fdb_flags)
> +	if (fdb_flags & DSA_FDB_FLAG_LOCKED)
>  		return 0;
> +	if (fdb_flags & DSA_FDB_FLAG_BLACKHOLE)
> +		return mv88e6xxx_blackhole_fdb_del(ds, addr, vid);
>  
>  	if (mv88e6xxx_port_is_locked(chip, port))
>  		locked_found = mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
> -- 
> 2.34.1
> 

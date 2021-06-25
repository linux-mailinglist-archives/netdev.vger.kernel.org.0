Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB03B4A48
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 23:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYVvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 17:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYVvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 17:51:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775D5C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 14:48:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bg14so17261400ejb.9
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 14:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rh9kArooUtc2vDLItI7c1zDzzLEszzYifTssPYKU7Kw=;
        b=uqg3Gw/w9QpBmqupEXjSwhPtzTufm21VYbQU+EG2UjNafaAGN+4YXNrTXWc2OdQ4bP
         XzwVvUFJeER0wm1Ejd4uJlmXKlyUTNiip9fw2d5bAqoCOucATlKBTj6nd/H2anP5IIZ4
         GH5Oq0s+STR8XF6sPecTe4oYk9gGXqOHQ77ZuGaGjNEe14HfxKBYM3g6zOMsdmihz8O+
         VLZxVhbU/iSC58nr0ThOqi8WU2RfI9Horo3Uw6BAegaspvZEdi5sqREG4JMUZfEEGp3K
         t7zKy6NqAcv4QQKLIGkh+0lBB4Ae2Jlds5h97ACBPCelMTFyeYLYBopp10QgLQeFG+vU
         FfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rh9kArooUtc2vDLItI7c1zDzzLEszzYifTssPYKU7Kw=;
        b=H2uedqEhVSmqQm3eLD/dfQfXOSsHvGs493/6KHP9+66mRE+RFHbxkHIk3VIA1P1/Y2
         Y+Toc2dyJMcriWEi/QeYrHYJ29C5yYxlHL01c19FByH9bGI1ERg7m2iwVNlGBBMcocuq
         kFQot3k2K2Si1ReifluWkRcbS7DQp74NEThlEE3BKEnlpZLK30DbU4ar2A+edwC0JJ07
         SgrNovK4GpdfIdDQv7UflZZTk510bNchQNc/ItDYcJrTaGRXSNDSnx8oFYELP0ZZdjKM
         tcpFK9P9mAb0k+/YyTX2BnfoZuynFZfOWYf+8VkTIP9a+t2RWJt4JjoA0NFymX6GY2VL
         /K7Q==
X-Gm-Message-State: AOAM531zHQRDmMIHpHCi9W/iUiScvF+XSm1yKEWOTRD/A1h/byuRorw8
        1HsGuo2+BH5Xvy7G92ZXQcc=
X-Google-Smtp-Source: ABdhPJzjKwsN9KitzJwNhfSXqy3pbrW1CX0K3X7OSSY4T1IK0DBG+zKLK4kpXlBnvEAAJnZA5rnpfw==
X-Received: by 2002:a17:907:3fa7:: with SMTP id hr39mr13070257ejc.23.1624657733918;
        Fri, 25 Jun 2021 14:48:53 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id jl10sm3313374ejc.56.2021.06.25.14.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 14:48:53 -0700 (PDT)
Date:   Sat, 26 Jun 2021 00:48:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 4/7] net: bridge: ignore switchdev events for
 LAG ports which didn't request replay
Message-ID: <20210625214852.sjdmjv3jq4rjszea@skbuf>
References: <20210625185321.626325-1-olteanv@gmail.com>
 <20210625185321.626325-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625185321.626325-5-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 09:53:18PM +0300, Vladimir Oltean wrote:
> @@ -166,7 +168,7 @@ bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>  u8 br_port_get_stp_state(const struct net_device *dev);
>  clock_t br_get_ageing_time(struct net_device *br_dev);
>  int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
> -		  struct notifier_block *nb);
> +		  void *ctx, struct notifier_block *nb);
>  #else
>  static inline struct net_device *
>  br_fdb_find_port(const struct net_device *br_dev,

Damn, I forgot a "const void *" here and it blew up everything.
Sorry, my fault. I'll use the extra time to test the patches some more
and give reviewers more time, will resend some time tomorrow.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0EA5E4F8A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIUSgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUSgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:36:41 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F429A030B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:36:40 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 3so6787744pga.1
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Z8tm45LnJNQoMzl4XG1X4c6B5SYGcr0T+s+XpFWz9ko=;
        b=ggB3YORQVn227+KE30ri4cNmLjbUVtLY16bW4BXdQfp+M91eQha+qvzuxi68rW3qaO
         kJ/R27cv2t0a0oyepmPeTX/eXcG5Ox8+mKUcPloLmGN24L6VhPUu4jZhWZ+E5i2NR4Ee
         OaFr2rh1koJtaKQCWUvxGp5B9BbZOztjuJaxW7FO0r2WczfrPOSELFyJHT5CAZiM2tUW
         RjSrlQHahBnC/pnl9gO0NoXKBT7UA7yFhGx3XBbPxCXst+s9ofVKXS/tRg9KofB0yWzp
         eW2dt3nfy1mk8FGQbB1krZtkWxJVKE+hc7A075TEzn7Trt2IliJOm+F/WPstSjWOxp0F
         ykIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Z8tm45LnJNQoMzl4XG1X4c6B5SYGcr0T+s+XpFWz9ko=;
        b=vZP/5zGoivyjOBD+a/DMTX8fg8aIiW/p6w/EW7MlW1dgLKpi5ebsGNnCXC42duCNvp
         N3kWaRoBCq6sw4gYg5edxHJGSfoeCirNTrc4EkOsIpJlEIuBDosLzUCAiBQzwnJVA9n+
         9pB4ySiEkxS9VFPqL809vVJYaTqLhgxDY46Ltxg2GJutC2bACZQXVu6orBqSse3FyUgp
         ID4V89Xp1XY2gsRy4+8NQzWha7w4PB0wXwTMButP6SkErEU9IVj0w8Nr9+7j3W/h5/7s
         KDbMJXo+nDKmJsLaZk/5LAv5iZTvav7nwchkrNrTeXQTn7uwQ7hTHuEKYsqkfaVlGlhg
         OBCg==
X-Gm-Message-State: ACrzQf2tw8uUENE9sjbgrxupjizy+DgZ1Ond0Q7Ot0O2oYc5ifOjCuiT
        mIeQsaujxQZmV4CMP1xwTmkBvg==
X-Google-Smtp-Source: AMsMyM7pG1Xn9+GQl5ITiQc9ntoSTPzuvybvO6yGsdsiX/HZeG517sJrkGfDcbZ1pXSUIe+f1fWitA==
X-Received: by 2002:a65:6bd3:0:b0:42b:9117:b9d1 with SMTP id e19-20020a656bd3000000b0042b9117b9d1mr25733466pgw.238.1663785399924;
        Wed, 21 Sep 2022 11:36:39 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a380a00b002004a2eab5bsm2196578pjb.14.2022.09.21.11.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 11:36:39 -0700 (PDT)
Date:   Wed, 21 Sep 2022 11:36:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220921113637.73a2f383@hermes.local>
In-Reply-To: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 19:51:05 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> +.BI master " DEVICE"
> +- change the DSA master (host network interface) responsible for handling the
> +local traffic termination of the given DSA switch user port. The selected
> +interface must be eligible for operating as a DSA master of the switch tree
> +which the DSA user port is a part of. Eligible DSA masters are those interfaces
> +which have an "ethernet" reference towards their firmware node in the firmware
> +description of the platform, or LAG (bond, team) interfaces which contain only
> +such interfaces as their ports.

We still need to find a better name for this.
DSA predates the LF inclusive naming but that doesn't mean it can't be
fixed in user visible commands.

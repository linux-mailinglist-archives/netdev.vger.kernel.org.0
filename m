Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63ED344C6A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCVQ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhCVQ4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:56:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379EAC061756;
        Mon, 22 Mar 2021 09:56:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id j3so20177159edp.11;
        Mon, 22 Mar 2021 09:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=in5zPWN2s1K/tCcc950Upp69w93UR8g2HDZ0TgRoXRM=;
        b=DhcHmXJBGHTgBNm2rEBfRQ2WT31PbZ5H6CB6K6j3kJWA/q3XmOLMNm3B+pZBwA8nTN
         WbkTrUgUfBR9LvMY12FjMK1Yl2rxjfnVTHW5SJY+GK1tI7qRxe4YpbdHqPH7XgVonYP2
         /2IuWqtzb6S7DdL0uXvDfstvowKP5PF83Rb59ovAQl+Bt/R5+MSL2keffSccbDouzH/0
         8wB2bJoeF4KiC7Cj+x8OtcCJ8/sLXsmqOW+yM97z5M1Te9vHKbhGpLGO3yKRnD74YU5z
         07tvi7we5mYd/emSvnsLeCisYcZUjTTOKFhBCD8Mj/uXmTCVR7ExHGgAS2auO+Kctkht
         sugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=in5zPWN2s1K/tCcc950Upp69w93UR8g2HDZ0TgRoXRM=;
        b=RdnxGLWX/RK5hDX9rc+l45OzF6o1TZaZ424AF55c60LXplbQlhC+/0gwCdqLoMZwmT
         RT6mY5pk4rYdJ3A/ohbqaTzoLqSjpVkCly3Jfy0bIEWbNP8NlVb9MYJi5ndOmSkvzzE8
         0aFTQT/s1lhlKfWLbF11zCroH88pF1Lonkg/bGnK3qX2A/navypQwHhU1RhQNyScBhR9
         0CXXFdhhGsR8Bja7U/Iewc6BEFRFS5SB6nqlb4thxaijSTTnkfLzalhMFE/S7UnYOEJc
         38cpDs73sixU+86vS/eFK4yp88sKZ9+p0xSZQgBUC3Mh2YflKWwvYVn4WiESxatntIFY
         nRpg==
X-Gm-Message-State: AOAM532d7dtHnzS/qzV14x03U2lAeasbIA+l9A58Oc/SJ+TxI2m8QknP
        +7ojdOKzFWKepbZemDI2ee8=
X-Google-Smtp-Source: ABdhPJw8kbQvgz9YUmfHBxMrExsPx8A56GEChaihtAgtGZ9HEx+Pf2ZfCc+wSixEp9N4AU5FAE8EPQ==
X-Received: by 2002:aa7:c0c7:: with SMTP id j7mr554934edp.298.1616432176029;
        Mon, 22 Mar 2021 09:56:16 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id j7sm11538303edv.40.2021.03.22.09.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 09:56:15 -0700 (PDT)
Date:   Mon, 22 Mar 2021 18:56:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net-next 08/12] net: dsa: replay port and host-joined
 mdb entries when joining the bridge
Message-ID: <20210322165614.56sgtdxpmnp2dkja@skbuf>
References: <20210320223448.2452869-1-olteanv@gmail.com>
 <20210320223448.2452869-9-olteanv@gmail.com>
 <7a89fd44-98d7-072f-6215-84960e27b0d9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a89fd44-98d7-072f-6215-84960e27b0d9@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 06:35:10PM +0200, Nikolay Aleksandrov wrote:
> > +	hlist_for_each_entry(mp, &br->mdb_list, mdb_node) {
> 
> You cannot walk over these lists without the multicast lock or RCU. RTNL is not
> enough because of various timers and leave messages that can alter both the mdb_list
> and the port group lists. I'd prefer RCU to avoid blocking the bridge mcast.

The trouble is that I need to emulate the calling context that is
provided to SWITCHDEV_OBJ_ID_HOST_MDB and SWITCHDEV_OBJ_ID_PORT_MDB, and
that means blocking context.

So if I hold rcu_read_lock(), I need to queue up the mdb entries, and
notify the driver only after I leave the RCU critical section. The
memory footprint may temporarily blow up.

In fact this is what I did in v1:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-15-olteanv@gmail.com/

I just figured I could get away with rtnl_mutex protection, but it looks
like I can't. So I guess you prefer my v1?

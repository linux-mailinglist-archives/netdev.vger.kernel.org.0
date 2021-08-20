Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27C13F2A4A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 12:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhHTKuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 06:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhHTKua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 06:50:30 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC515C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 03:49:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id x11so19482191ejv.0
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 03:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7isrxJtlp0r22J+iexNuvfburw69U97Ape1SC3iuf7E=;
        b=gdGakSHq38yULKmpkgy/9jM/jlrCe5SZeLjVuj+14KVzRhp3HGZbJDHIUd7rUGBqB0
         20+MaxsWefAdi5WXEtDTWIgXLQNTqwdAgefkZrl0UupWiPPSgUWL4gm3AHlZpjgoUTln
         RiFq00sS5K1efhCIaSGk3pu4o5V5fTAZ18e9ugWozj1HFIAYy3dH72zBz98jmQa6C3oz
         sUWvVrSm4wXKtQWdrywsrpUXcSp2IttMdLU8PlKJ4VlX0tbH+7Mb3rSmDbvcCiupNKOm
         TtCNMyQsER0AuAbOoDhr65J8bFswoJ05cMeQ+910xcXHzvLQ6MI8uZtLg9SPKLZwXq33
         w1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7isrxJtlp0r22J+iexNuvfburw69U97Ape1SC3iuf7E=;
        b=NcU4Zmk7rfzZw6LRNmy4Tq2YNX7s/iBl/UMQSJ2Qj4uzENpETJW1MNow2xSgeQ8OEa
         1eVGo+e/bTWX1siWTJUVwq4MQ7iUefxylRF6/et5UFLu+n2DyFhibHxRYYc1+2D9LLqr
         rADWgxvzHB3m49KecRn07MnUMa3qeb3SFaEd2vQewbF0vb4kujb0CbtyFjg+D5utyEfN
         MDeUE9fdQWFoZInaYPk11GL66qd8ko1CC6DuZ/YP1s74ietdB2tSBOJf9G/0S92+/Hcy
         jL4g8zhm6qeHySKjWIDM+91vVeszVyqcRdNujYBM2G53yO0wj+SofkO1shSwPH8NJ+q5
         L1tQ==
X-Gm-Message-State: AOAM530ErdySnRvCOfkaQ5+j/DR+lQv5UHMzwm95Mdz9CB4fFkbEsY0o
        foG5Hlw88p8ppB3eSLck9dQ=
X-Google-Smtp-Source: ABdhPJySybXjBmQSQyTOrZkqRi9TKGwofYysZBr8hJwc46IPpkJh4onb50TB3AsPz/aA3P/mfhyfnQ==
X-Received: by 2002:a17:906:2642:: with SMTP id i2mr21578744ejc.323.1629456591486;
        Fri, 20 Aug 2021 03:49:51 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id u23sm3308197edx.29.2021.08.20.03.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 03:49:51 -0700 (PDT)
Date:   Fri, 20 Aug 2021 13:49:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210820104948.vcnomur33fhvcmas@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR9y2nwQWtGTumIS@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > Problem statement:
> >
> > Any time a driver needs to create a private association between a bridge
> > upper interface and use that association within its
> > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > entries deleted by the bridge when the port leaves. The issue is that
> > all switchdev drivers schedule a work item to have sleepable context,
> > and that work item can be actually scheduled after the port has left the
> > bridge, which means the association might have already been broken by
> > the time the scheduled FDB work item attempts to use it.
>
> This is handled in mlxsw by telling the device to flush the FDB entries
> pointing to the {port, FID} when the VLAN is deleted (synchronously).

If you have FDB entries pointing to bridge ports that are foreign
interfaces and you offload them, do you catch the VLAN deletion on the
foreign port and flush your entries towards it at that time?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409913E5AB7
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240697AbhHJNIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbhHJNIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:08:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B935AC0613D3;
        Tue, 10 Aug 2021 06:08:26 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id e19so35299192ejs.9;
        Tue, 10 Aug 2021 06:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xs/+O7rAz0hyKzsctUcio2WQZUKn46iac13X1YxyLOs=;
        b=HCCl7rgFmcy3zKwIxkaZ/SBUd8zqPrb094075z1tmOI4VPtPFJxydk1aoQ4B2mcRJ2
         cQbJUQDbzcm1dkhCvmLco8Me5ubngY8nbgtYF0sJ4eL85zbQyFqLGyp/ySVX1oMF/iSG
         vbjIbxMCaeikvl+bgs/I6KvQSlwON8h6QIJ/y4JkTJzU3UePnUxBhQOh1L7I7o6lC6Va
         ajSBOfrGIA0UG06ic10DngwwBxhWDA2POkbpQH93j60p7JEWn4jt32GvxfG2iNSy4hfj
         yyCxV6P1vKnmRiuGGEdWGMZQPJ5OaIGrTF36KT7jCgkXxKcljAlP0sCWBR/x3nM56IYM
         tq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xs/+O7rAz0hyKzsctUcio2WQZUKn46iac13X1YxyLOs=;
        b=H3uO4uX3kTzkyDqsI6ddJbwdtQ5lQL+5yR9AaGTABOvQqiWqC6881CxtuyfW90vwKg
         Pd0xAdu9HKfusKypLX2RTIba4WeYUe3t8Z62/85XeXxQzvHm6Jz6TIpJacgJD1ajaIAt
         F/pHvixOkWZS0d1D+Pcn0dgDKh81sB1l7hkGe1ayWUjhgQbX5CaTGSmurI4epFQ8iSXb
         JjD/cvQgJuA5MG991EpQBD2WYeA/9egyxS3e4R4Ze/SCuTWlYBg4RI07ZWdteNON15Il
         rDMQwPiBRqIIK85oTQ2uY//atSLvBBxT677/Sg9TGtMdapQSnuO+hHj0h/a3q+EAFkwI
         nltA==
X-Gm-Message-State: AOAM531SegdyiacFQIUb8leS8bsyYS9U3zWeZTbi8FvEUBrZSiM/Rwxk
        cb3VbqIMO/h8EQl1SNToMLE=
X-Google-Smtp-Source: ABdhPJwUr/73rEkMhaIveh98iMIskFOJfJbfcePSx7fWzOrGY6Gd0FewqY2WalFFgiQ4kd1+ecE4PA==
X-Received: by 2002:a17:906:dfe5:: with SMTP id lc5mr27153744ejc.20.1628600905375;
        Tue, 10 Aug 2021 06:08:25 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id b25sm9645288edv.9.2021.08.10.06.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 06:08:24 -0700 (PDT)
Date:   Tue, 10 Aug 2021 16:08:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-s390@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH v2 net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Message-ID: <20210810130821.7gdngordzzxkpws3@skbuf>
References: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
 <dfa98bf7-cab4-4076-ef5f-880a8baa89ee@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa98bf7-cab4-4076-ef5f-880a8baa89ee@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:41:48PM +0200, Karsten Graul wrote:
> On 10/08/2021 13:50, Vladimir Oltean wrote:
> > The blamed commit a new field to struct switchdev_notifier_fdb_info, but
>                   ^^^ added?

yes. but I won't send a v3 just for that. thanks for noticing.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB5F2FADE8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390871AbhASAFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732241AbhASAFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 19:05:11 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB7DC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 16:04:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a10so9406791ejg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 16:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R2oXVpB2Ii8XEJfOgd9+ImRNyuWGmvWzEyYrs7b0pZI=;
        b=RQUx658w3RTT2dTdCdkN4UbZl5iBtJPdGLzylJ/1vInZEQFPeAsXmvQlA8t2AX6UJe
         1TLR0oti2NAVdzeX+IEQMgCwnmfDjNh+bxpN24rdCa8CpKgOLaE1GNB/sBM6W6ticttI
         gE8uZGi1lANBS2BKsuR4dBYbhMmQMVD8qZzFU+0a6NpkulbJ23rIltBE8xh9OFaOEkch
         LyruOf4/Hdsk5H2xLvC+3UzC/eJT1/LA8N/S/WkRk0cIENd3+8Qx++R+OWVPZYQZan/W
         9OHXiLosqDgyQqVIagYsvuwSYCEmrLecrBhAQEOiwlLTkoibSW540wliKwfbcqeEkgdu
         pKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R2oXVpB2Ii8XEJfOgd9+ImRNyuWGmvWzEyYrs7b0pZI=;
        b=c1Y6NJzhbborabLIsOYb1fzgelKEwQedz5iCDWfb8hm4w6F0T6um/FTons1Z7a0C1r
         lujKJzbPgjadfk9ep3E+Ibj8n7XPyoAYyfoqpe41fLBCd5cvMn6PeWqSAnubOJjsqBBf
         8tONIyrKa2fO/x/VW89ggobPB8EKLF7WObHrTBL38KShGMU02niSSIfEHFfG8VwtMy67
         6i7AwlRYJTuk1NoAtdg7gi711Wmi13EFw57j1XebkPo/xNubHeF0eIuy9WAMfMjuT+Rs
         HboDroCKgT1CnKCYGzV6TwHjyKA1Snu49/tegRMu6MqkmBl6He5raSdKQObHepJ9nbx0
         HH1Q==
X-Gm-Message-State: AOAM533AJ7+ppXnCkgRHTG5hIjGR6lr10V0Jcc2f6zIANechbgNrh1zm
        ajbiE5ckqFY8/8fCWUnpVekkN9LlQYA=
X-Google-Smtp-Source: ABdhPJzxKc+AGHGD9RaaKlbsIhGyY4+dtEE2HSUmTiFaL/BQccwqssO7xR3yTijK9rA+5kX9w6ezDA==
X-Received: by 2002:a17:906:da02:: with SMTP id fi2mr1256879ejb.230.1611014669209;
        Mon, 18 Jan 2021 16:04:29 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l16sm2717275edw.10.2021.01.18.16.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 16:04:28 -0800 (PST)
Date:   Tue, 19 Jan 2021 02:04:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 04/15] net: dsa: felix: add new VLAN-based
 tagger
Message-ID: <20210119000426.sf42ecoefafhy6lh@skbuf>
References: <20210118161731.2837700-1-olteanv@gmail.com>
 <20210118161731.2837700-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118161731.2837700-5-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 06:17:20PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are use cases for which the existing tagger, based on the NPI
> (Node Processor Interface) functionality, is insufficient.
> 
> Namely:
> - Frames injected through the NPI port bypass the frame analyzer, so no
>   source address learning is performed, no TSN stream classification,
>   etc.
> - Flow control is not functional over an NPI port (PAUSE frames are
>   encapsulated in the same Extraction Frame Header as all other frames)
> - There can be at most one NPI port configured for an Ocelot switch. But
>   in NXP LS1028A and T1040 there are two Ethernet CPU ports. The non-NPI
>   port is currently either disabled, or operated as a plain user port
>   (albeit an internally-facing one). Having the ability to configure the
>   two CPU ports symmetrically could pave the way for e.g. creating a LAG
>   between them, to increase bandwidth seamlessly for the system.
> 
> So, there is a desire to have an alternative to the NPI mode.
> 
> This patch brings an implementation of the software-defined tag_8021q.c
> tagger format, which also preserves full functionality under a
> vlan_filtering bridge (unlike sja1105, the only other user of
> tag_8021q).
> 
> It does this by using the TCAM engines for:
> - pushing the RX VLAN as a second, outer tag, on egress towards the CPU
>   port
> - redirecting towards the correct front port based on TX VLAN and
>   popping that on egress
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Should both taggers be reported as DSA_TAG_PROTO_OCELOT as I am doing in
the current patchset? Currently a kernel can only be built with one
tagger or the other. But it is not possible to e.g. rmmod one tagger and
insmod another one.

If we allow compilation of more than one tagger for the same hardware,
how do we select between them if both are built into the same kernel?

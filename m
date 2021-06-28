Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EB43B6163
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbhF1Ofr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhF1Ocr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:32:47 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982F2C0611C6;
        Mon, 28 Jun 2021 07:23:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h17so26148799edw.11;
        Mon, 28 Jun 2021 07:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rfKuoJAtusVapu2kMNkcCOghL39W8RTkgqPaXUuzpo8=;
        b=ZDRo78BaHPXxHFuzCVbfLd4RGcEPVTnhlS9BBkW9pXPF0D1YWb3CfCZroYT4gN+9yx
         DHJPJ6Vk6gsB2GDCvGqaNltY9IdKnbRbFiW2ZCeevawG11FbaaPem3QT6umspNl74ZGF
         sp+XIF68u49BhCc/fAOJhPWGAVapss6+9HA1+XYgSNMRQIX9hcNYY/HrUfycufng+SDs
         /iWH7Mw6UYidGttFQHvdpsBDniMNgibVXGdQoDHFnU1sm51c/EtzJ9EvGXZ59DSl9+Gp
         Q+3q+kR3R2Sye0HfyIgXV5O7Jb43WJwdYWw/M8Ulb47lVWdSpuFeCdHPQpdQRbU6qYGi
         o+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rfKuoJAtusVapu2kMNkcCOghL39W8RTkgqPaXUuzpo8=;
        b=YZN3auLm1D5fusVay4gpd96yVLxEgSK1TbLPHsWzlChwGC7a2XtZcNudhRLj7v+T7B
         kk88yY/sXMZzd1q7yoVIycWbIn3u9ps2sNT7Trdf2c+r44p5sdY+Uk9CsQ6YLxrRh0Xn
         rpuBcefzM4u+eIBw2MrE/c3vL7uD128BnEYUN8pd0xKcUOq5n32iN5BnKqiBRh0YZGu7
         24JV4K27T7lATy54BNM1XmBs7xrwmdvd1+DiNpEhe6vxe1E6y1TssbtPPb0Hz20vV9tY
         tZJHXhqk0FeKihKARdOeE1safrrg5hB/SDiSGexGz6RIFtS00ciICN+Hn9Tr2SnHyAek
         nZXQ==
X-Gm-Message-State: AOAM532AcSj4NScclQgULL2T36n/ckmmBLLJemxKoFHOwAWL+BY6u3RI
        lHnmH7z3NKC6KpaSiv+VVhnXaeuM0zk=
X-Google-Smtp-Source: ABdhPJwfobLX0Nexj7XfdQlU1nOg96cEbyQjKFS9BY0XcmMGP7zeiIu2sXZM7wjh3rbbdIaU05pSlA==
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr33653045edu.103.1624890211191;
        Mon, 28 Jun 2021 07:23:31 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id cd4sm6983770ejb.104.2021.06.28.07.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 07:23:30 -0700 (PDT)
Date:   Mon, 28 Jun 2021 17:23:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210628142329.2y7gmykoy7uh44gd@skbuf>
References: <YNOTKl7ZKk8vhcMR@lunn.ch>
 <20210624125304.36636a44@ktm>
 <YNSJyf5vN4YuTUGb@lunn.ch>
 <20210624163542.5b6d87ee@ktm>
 <YNSuvJsD0HSSshOJ@lunn.ch>
 <20210625115935.132922ff@ktm>
 <YNXq1bp7XH8jRyx0@lunn.ch>
 <20210628140526.7417fbf2@ktm>
 <20210628124835.zbuija3hwsnh2zmd@skbuf>
 <20210628161314.37223141@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628161314.37223141@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 04:13:14PM +0200, Lukasz Majewski wrote:
> > > > So before considering merging your changes, i would like to see a
> > > > usable binding.
> > > >
> > > > I also don't remember seeing support for STP. Without that, your
> > > > network has broadcast storm problems when there are loops. So i
> > > > would like to see the code needed to put ports into blocking,
> > > > listening, learning, and forwarding states.
> > > >
> > > > 	  Andrew
> >
> > I cannot stress enough how important it is for us to see STP support
> > and consequently the ndo_start_xmit procedure for switch ports.
>
> Ok.
>
> > Let me see if I understand correctly. When the switch is enabled, eth0
> > sends packets towards both physical switch ports, and eth1 sends
> > packets towards none, but eth0 handles the link state of switch port
> > 0, and eth1 handles the link state of switch port 1?
>
> Exactly, this is how FEC driver is utilized for this switch.

This is a much bigger problem than anything which has to do with code
organization. Linux does not have any sort of support for unmanaged
switches. Please try to find out if your switch is supposed to be able
to be managed (run control protocols on the CPU). If not, well, I don't
know what to suggest.

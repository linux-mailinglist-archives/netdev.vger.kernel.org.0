Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C463D4839EF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiADBmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:42:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FBBC061761;
        Mon,  3 Jan 2022 17:42:18 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id l15so11204986pls.7;
        Mon, 03 Jan 2022 17:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o6C20VmBcv+nmS+7ue+qVqUNPArDkdLd7xrcun84wt8=;
        b=bdkRCfqMEAEppLm3HcDbB+ar7oAYffrj58ZEQEMUvQmbROu+aHoMhPKBK9A1i5xA4f
         jDmwafAkvbrpSvIPPZlLtTg6hziyRIePDf5FxTOb3dyZ2JMKp5EgTIrGdCr816YUK0j6
         nx/AUbTGLzXnShl5ZZXoq5AJyui2TWNcEXgxMtFGqoBuVr/yGPng7tjGo9pO8v6bsu/s
         rZyBntxf998bzFWRRYon7d5LAl2peja5d65Lhf4um4r+7MGDOnsCNr3u9VInbY9A81ce
         PufLGZJwMDeg413pp1d8ElYKiKGB1fX+PEM4+R2ws3nDlpSpo+MEeHTCiLM9AQAhmthJ
         VSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o6C20VmBcv+nmS+7ue+qVqUNPArDkdLd7xrcun84wt8=;
        b=sPBNYGmyWsmoqtExLSFQG31jTkm6KSqWTDKhqdc8+Z2mEfjc0UM3ls3gSHbd2D/e9C
         1OatNxm5ywJqxIagGd5RL/0dSm/aqnTSQwxXll3uiOVzsH9gTLLc0JDGcDI+xs1yA0MC
         yEVzp1TVZDcnF3rv11dIfnKW22V0W5uEBie2kWp3LPJoEhnH5Op3gyP/aciyVM5IXxDD
         fMzy+DARjIyad42H6qmtSBqQT+l98OfR66iHXy/y2uWA82wtdAeha6Z6uTGivgsVjgpX
         GaL8It4s+0Cz0U/+jMKfRW2mJFWq+MgB6SJ9zcEals+o4gta+JZhizFJtW10aYsupEDV
         +pUg==
X-Gm-Message-State: AOAM531FbGRbfkneWHZ2LIkG6oDDWyYCl1kMceRubtvpqcv5XERXByGG
        fYE7Nsj1i5juGOw5t+yYObo=
X-Google-Smtp-Source: ABdhPJxhi4U0dfEuYH6XId7KcJPjpuFjGFYp/j4ZZlZGGKolygfkz3YGRy3onHs8SYrK9/BlnB6ZGA==
X-Received: by 2002:a17:902:e549:b0:149:ad2b:f0fa with SMTP id n9-20020a170902e54900b00149ad2bf0famr16188568plf.123.1641260537866;
        Mon, 03 Jan 2022 17:42:17 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id pg12sm43916433pjb.4.2022.01.03.17.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:42:17 -0800 (PST)
Date:   Mon, 3 Jan 2022 17:42:15 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220104014215.GA20062@hoboy.vegasvil.org>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <YdOMlfbMH9b553V/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdOMlfbMH9b553V/@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 11:53:57PM +0000, Russell King (Oracle) wrote:
> On Mon, Jan 03, 2022 at 03:25:54PM -0800, Richard Cochran wrote:
> > Make the sysfs knob writable, and add checks in the ioctl and time
> > stamping paths to respect the currently selected time stamping layer.
> > 
> > Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> 
> As I stated for patch 2, this patch will break mvpp2 PTP support,
> since as soon as we bind a PHY, whether or not it supports PTP, you
> will switch "selected_timestamping_layer" to be PHY mode PTP, and
> direct all PTP calls to the PHY layer whether or not the PHY has
> PTP support, away from the MAC layer.

Oh, that was a brain fart of mine.

I'll amend that to switch selected_timestamping_layer only if the PHY
does support time stamping.

IMO, the default should be PHY because up until now the PHY layer was
prefered.

Or would you say the MAC layer should take default priority?

(that may well break some existing systems)

Thanks,
Richard


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A2D3EC251
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhHNLPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbhHNLPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:15:41 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC28AC061764;
        Sat, 14 Aug 2021 04:15:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w5so23068586ejq.2;
        Sat, 14 Aug 2021 04:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zyLTEao8GoUQ5VMv7Ikv+o0Q4wNAX8MPGnCruQejids=;
        b=AimOhyrIEK/nBoXMt6oUsKR6TdfYbL1w+oLAQ+jdX5/0xs4DL8U5rvqs7CgmWDMLKW
         wvslvSIcz+Ym28vRU9/sxDlIGZnsFtfalf14+xGPpg2njX50jPOotSHh1pl6wZBBvOVT
         CNr08GTjhd2hRTXwHHO+418Hla+qX40pN79lNlVo3wZTW+y/n1mj9nReuSY/H2hDIU0q
         9yXwDE6ZQNWy+h8B0O2kfBtDbOdmUXhtx5BBZpFto/fjTOnZMESji10aTB24M2gbQuek
         XIqi/Egqqa93uwOFKIt4J+ZeQBlj0IEgapFheLqmIM5sWVDK0b4ByN2U5lKf37P/kPlT
         cJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zyLTEao8GoUQ5VMv7Ikv+o0Q4wNAX8MPGnCruQejids=;
        b=YpL3JFoyBJ3ofXXCtfxTEDWIfgPpoWRRjhppnV9Oqctih8Ne7+RK9cJ0HEyHajso+I
         kVBN+sbr5JOxo/jQrAZZsu9OWLnSbC8x3EZmgkwAlAGlE6qXzhXzhRs5CV/Xx45981nX
         hir1LFtvBh9gw7mQyT8XJtj1ctrIsLcmd+Vc0ysRBWaNSJ6iNtnXq0eJO1HtXZKXv+VQ
         Zn5tPyE7riCDUtqw9HR2txDuVXTdxaC8EymLq/g4rZTPWhs2uPasoBUiSrcXHIoUBuPl
         +hAf+Mw8fIRJrosFUDDWdjT31QFJ6lYLKkD6+BvIkOxFZIHlDLWh+E5ErzoP6LCLu2Ju
         MUJw==
X-Gm-Message-State: AOAM533cPws70Lqr+/wN2ap1Uje+OMP3b94wmzpnUra99TYZwHZ4dWIn
        SgqNBexD5j8bX3mVlsgZZMs=
X-Google-Smtp-Source: ABdhPJxgGK6dgJwNmAYSM82+wgSFo/CNF8W5Tku5UDRYv6CwxYclsKfMLF6NCCXPtIvX7E/HYWrJPA==
X-Received: by 2002:a17:907:104f:: with SMTP id oy15mr7085148ejb.46.1628939711482;
        Sat, 14 Aug 2021 04:15:11 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n15sm2110779edw.70.2021.08.14.04.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:15:11 -0700 (PDT)
Date:   Sat, 14 Aug 2021 14:15:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 06/10] net: mscc: ocelot: split register
 definitions to a separate file
Message-ID: <20210814111509.p2ypda3yj5em5ro4@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-7-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:49:59PM -0700, Colin Foster wrote:
> Moving these to a separate file will allow them to be shared to other
> drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

What about the VCAP bit fields?

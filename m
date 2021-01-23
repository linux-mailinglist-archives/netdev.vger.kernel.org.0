Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B0430187E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbhAWVOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAWVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 16:14:45 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AED3C0613D6;
        Sat, 23 Jan 2021 13:14:05 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id j12so5964240pjy.5;
        Sat, 23 Jan 2021 13:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xrDzudvDNG2fzllxzF5s0DnJ66F4Ddj8oXL2djg9H1c=;
        b=cZ+4u7WYxh/96OX0BUO92HsWyJVgXXnIPSqw082exCGUF/+rczi6n8WtbeK61dsk5r
         xMG8ByEt+KGhAxogkLFp3dqXo4/KqRTmcu+YI9504r5aeeKBJOFp0WpKaemElkvaBYCF
         tmc0iGGts71BVp7ggt3uF0J2bHoYXi2EO6N93UOFFbA9uiBVpeabkHzGRVYBmKLGMedp
         yN9sIJOQ630sxFcOgAchSq/8LzRyukApKs2Y5fs3fP88kOFERTRX0h0wltxtEt5a2n+J
         6i1+fdvNP8SaK9FIgNZqfXAR+rhMFZ9QHv/dzXQDSANm0tMQFr7HhcOJ9SL8Jh0gy61Q
         T9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xrDzudvDNG2fzllxzF5s0DnJ66F4Ddj8oXL2djg9H1c=;
        b=nqgGfa6BiFWHvzmvlFKD1qPOkklnMYHDa/296VQfYwhl1t0EoaagnFZVqev/mh/CiH
         1U6x3wkYQLk8TGozZGmuc8/xNMas7OSWQ0xuxxoHg45BnP2ypkSNeoyKHp/1soIAodQf
         x0y2SAVUyIMJAu7WVQt0nwSrKJfiy+IvdrXK2SUkRPJVYitklDCh1JweSN/GdgaDiJdi
         eNsvUmjnQJxTOTUIsaYETIya+yF9JkGrUMaCXofkmcAnioa9lOe+wdaq6L/irhlbowxV
         7eL+xR+XFF8t0tFw27H0U5BCanRQkQSslslaZLQwN8rfhaCNjqebEsNUCgHzfjYvtOl+
         l+qA==
X-Gm-Message-State: AOAM531OhrV0HFbT778tqVCBCB/zaOySK5nuA1fW4ZuyzoQFRXUWiFhE
        eiAGf/6pP/YWhzuhCUOZeWXOGmiD+tY=
X-Google-Smtp-Source: ABdhPJycLRNBdDKA7LXwJHiYsOYDEQMTgcKYBKgsirezYlVlVJgraCQBohQuBIPSE5J4ydZZ+cam0Q==
X-Received: by 2002:a17:90a:de09:: with SMTP id m9mr1714639pjv.117.1611436444466;
        Sat, 23 Jan 2021 13:14:04 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f71sm12551835pfa.138.2021.01.23.13.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 13:14:03 -0800 (PST)
Date:   Sat, 23 Jan 2021 13:14:00 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210123211400.GA6270@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
 <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
 <20210121102753.GO1551@shell.armlinux.org.uk>
 <20210121150802.GB20321@hoboy.vegasvil.org>
 <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210123132626.GA22662@hoboy.vegasvil.org>
 <20210123121227.16384ff5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123121227.16384ff5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 12:12:27PM -0800, Jakub Kicinski wrote:
> I see. The only thing I'm worried about then is the churn in patch 3.
> This would land in Linus's tree shortly before rc6, kinda late to be
> taking chances in the name of minor optimizations :S

;^)

Yeah, by all means, avoid ARM churn... I remember Bad Things there...

Maybe you could take #1 and #2 for net-next?

I should probably submit 3-4 throught the SoC tree anyhow.

Thanks,
Richard


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2238A2B1270
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgKLXFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:05:48 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B62C0613D1;
        Thu, 12 Nov 2020 15:05:48 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s25so10508565ejy.6;
        Thu, 12 Nov 2020 15:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9INYHTC2YCDlk5WKrasdFSNycJRuAFg38eBMPmO9A9g=;
        b=JOjHbyXV9MpnYrA72npdXOuY+owbQ4KG/mzWwBPt4t+LnDUBZxykaWQNhjuX7lCKzw
         jlHvozqYYu1pG1mMFQ1RgHijtCJrsMNu6Ti33HSsRv5ISmkk2VZlEEWKrJzE2C3i2sYq
         YtymckQ3S4X3Mc8AeUlXotxJEVLHjptJuilFL6to4IWXfUDy16YVFk8CFiCm+vkf/6ef
         vRnH2UpHT/LtZ3bY2isshcLob87q7lmC9C9PF7p/btxNywOteM+HuFVawhkugp/XPXwn
         0A+Ty03q1+tUYd31BUe55+9YFW+3BpSk/jCUggP+oh5J8CrvVWL1rcYaNUOYxIhE5CUI
         NZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9INYHTC2YCDlk5WKrasdFSNycJRuAFg38eBMPmO9A9g=;
        b=oWBLWDyyQlOnvcIKBfuQBgfYDlH0z5srsJd0erfCRsPkdEs3yeAMWJ0qxSu/KzddP3
         4AxaIBJqYtmq3gxBoeDJ9p30kqi87yMqEplDxx6hVxnqnAOhoVZpXi7kjX6+t0s9XUxh
         fHzXsaPePeNmc0+b6MeJGXlsAnFur34MM9c3vVwHH/kfT+MZfagG10FZ49V90BdP5eLL
         0NdMso6J8zIp1hHbsWfNzd0wjVtj/uKzHt48LDRExV6Ll67macCyCKd2e09K8nEMWMq+
         tRARZ0GOr6dsUTtN1TeBpfwh4LpseI0uvJDiUMieAqBVlMyl0ROVYDu5ZinxlZLTz00+
         XkrA==
X-Gm-Message-State: AOAM532+a7XJtU6/XVFCyVq7yb4oiOTvgBqHGd3rLi702nyoBtjLgbSE
        yN/1axrXF+8NZWGk61gBAmU=
X-Google-Smtp-Source: ABdhPJwu27+hJH90HsawanhiEUQ1bNs36kGCr4y8Xx4ki2Qxk0Fg/1ZvjZA86wApCYu+DAPZX+Zoeg==
X-Received: by 2002:a17:906:a88:: with SMTP id y8mr1694161ejf.469.1605222347234;
        Thu, 12 Nov 2020 15:05:47 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id e19sm2674855ejz.35.2020.11.12.15.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:05:46 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:05:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 04/11] net: dsa: microchip: rename ksz9477.c
 to ksz9477_main.o
Message-ID: <20201112230544.p2jnfzbk3bhdui3p@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-5-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-5-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:30PM +0100, Christian Eggers wrote:
> PTP functionality will be built into a separate source file
> (ksz9477_ptp.c).
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

You might consider editing the title. "ksz9477_main.c".

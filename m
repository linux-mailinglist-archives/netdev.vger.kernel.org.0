Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B768633E20C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCPXWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhCPXWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 19:22:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97A6C06174A;
        Tue, 16 Mar 2021 16:22:37 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x21so61290eds.4;
        Tue, 16 Mar 2021 16:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LaPgj/Jk08RP/1ma4VmgriaC+i/dmTiewwV5KcR+BIQ=;
        b=XOxbzQUa9977LbbLHXB8mLiT8Qo7rkwIqY8It3PpPPsDSIrjcbfhi7Ve/GQDvDJDvY
         kxc76hBO0M/JQjDYOu0LXd7TLWfSUMzs+070vfv4pd6/IiwevP7ukDHk9R22rNBpglik
         zpOZskXcdHtzQgF5FREilfxcFclqSbAlZ+iwdHi9O91pu15Vrem0YV50qRGhe20jUbdd
         OD4MDY+fdm5eS3oAG6Pw3zOd7SuUfRHLogWUWqhWwLge+M2bMEwE1WVw4BhTSc4IZoUQ
         gkI//rBz5MMxBQtHH+oalX8a78/HsVc73WRcAE1Glngn2MfflXhstfkv39pgFQ+Cx8XY
         tbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LaPgj/Jk08RP/1ma4VmgriaC+i/dmTiewwV5KcR+BIQ=;
        b=NEzlcUlCW5Cb+v4WuIRGg5tmK5+89LRegVO7hfwKNlUmxlpI52YEZINVSYPEQ4Q9sw
         Cx7BRr1EmxM63Jz1Y2YNEWDQwA8HcIZcxPrLUIK2B9eF+GL9ZBVfRNMg564SBLvWQUw5
         YbN1c7yxDckLib+3a3Ga77p4W2uqOyG7a4imct+I0TqJOyezQctHDVd2rRJPlHmQCPp9
         xsoSzdRt854JFVZwGtWXxOZeifN1eCNyo1V/rterx9QNgJyvd7V7zAcYeCQ66JGu39gC
         mdOVm3g0GOXcj76UR3qPVE+InxvSiSqRCN4lh1ZFvIs5KkZf0lc31ESbYEawMfBORsTa
         MEnA==
X-Gm-Message-State: AOAM5333KGzJdmtSTqqVGmkPs0hIC86ekncY3TuhwfTtzp/2Gu4rY4j1
        NaE91xZy+AVkN0ca1ToxjJo=
X-Google-Smtp-Source: ABdhPJyUp5uK+1EHJSXXgD4WgIrLjeyv0LUhOs7uyoeVRvJnneCkxpoD5J0tlLYLeYfHzMnHbmk6DA==
X-Received: by 2002:a05:6402:5244:: with SMTP id t4mr39294331edd.87.1615936956462;
        Tue, 16 Mar 2021 16:22:36 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n26sm11035962eds.22.2021.03.16.16.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 16:22:36 -0700 (PDT)
Date:   Wed, 17 Mar 2021 01:22:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: ocelot: Extend MRP
Message-ID: <20210316232235.6gl5ph2clqfjp626@skbuf>
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
 <20210316201019.3081237-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316201019.3081237-3-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 09:10:18PM +0100, Horatiu Vultur wrote:
> This patch extends MRP support for Ocelot. It allows to have multiple
> rings and when the node has the MRC role it forwards MRP Test frames in
> HW. For MRM there is no change.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

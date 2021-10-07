Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961E4425C8D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbhJGTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhJGTr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:47:59 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C302C061570;
        Thu,  7 Oct 2021 12:46:05 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x7so26504695edd.6;
        Thu, 07 Oct 2021 12:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NrCVdsgDNocRT0wIqN/j5SheKK9MCd2SRyvKMi/lfKU=;
        b=nbm5jqik/K+hu0Zb7UU3fSb2rGsKEH9bDKC5MazZB0Nx+fcXWUAygPwUOi7gIS0mYC
         IKOmIaG0Pg3Vh5cY4MKWTYLzN7kHK3wuXXl6TKfVsYJEEGdDcHGTIKeICvsseA0jVZ8I
         1wTmus+hY2HD4XzSqpgMFZ/mh1zYvawZF/ImyZ+IV0EQtUW1lmgXRVmRAN6qury1ZUD2
         zPRhQeiGQLIeiiwfwXFWpaCZ5M3nJ/6MMgucevOIOBS3uZySkfFqyYc4xN2SWYygJeXR
         uWLHd7ABuUVWUtJGLeq6s9/zXfAvHD6nynRxHy5RxJ5NJkqvtRss1afE2t+HxAo30Sa3
         LR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NrCVdsgDNocRT0wIqN/j5SheKK9MCd2SRyvKMi/lfKU=;
        b=3wsO4gqBsps6RbWGXZs96tpSR6Z/F7nunVv7jy59ZkQ8ydzRRw87Yx6d4kLUEZCW52
         ldLD360KE8yM/jpqGrBWCM3srFuuu/Xo66KHvJbZlUUg8e5zY7cHmroJ/fZSTulznrcm
         tCe6hUP7GMIHoeq3s9V5whLj1GW48vEp7xm+zpRAOMgEUA6Vn2wDpD1dbGUvlC/IDC+2
         7DtsPIkD8jT2wdE6ywbCpaLKnFC4DvknholNIim0tRvFCRdocvnfYttxC2G3Mupbl8om
         2MlTlYEffNnnHF9EjmNrCghygXrM53tOZNOErhO/48D3mB2Zcn5djN731h6u3vNJyBrS
         Ww8Q==
X-Gm-Message-State: AOAM531gIc7CT3VBDdmhEkQFThvHtsZtG0lsWRPq2PBdkiePUJZKQd8c
        myGL5zDOJLL0meAK4McFaUWctEWtnU4=
X-Google-Smtp-Source: ABdhPJyju9Lw9bM4dIj+1moPwPuxx3VJR/KMBZO0jM/VbM9M1Me4VvyBTWp6maCAf2bzC4xHZ0x2Cg==
X-Received: by 2002:aa7:db17:: with SMTP id t23mr8535799eds.75.1633635963816;
        Thu, 07 Oct 2021 12:46:03 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id t4sm159075edc.2.2021.10.07.12.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:46:03 -0700 (PDT)
Date:   Thu, 7 Oct 2021 22:46:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 04/10] net: dsa: tag_ksz: add tag handling
 for Microchip LAN937x
Message-ID: <20211007194601.mkwbc3tcjtgkduut@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 08:41:54PM +0530, Prasanna Vengateshan wrote:
> The Microchip LAN937X switches have a tagging protocol which is
> very similar to KSZ tagging. So that the implementation is added to
> tag_ksz.c and reused common APIs
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

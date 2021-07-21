Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920683D1A7A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhGUW5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhGUW5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 18:57:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F56C061575;
        Wed, 21 Jul 2021 16:37:49 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h8so4532302eds.4;
        Wed, 21 Jul 2021 16:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OGYJhiDzvCvS41BWqjNRM6F46YWrygkTOyNc6brBDEA=;
        b=qb6uimvAqTc1LkagrjvDagClJatgfuzDC+UbEurKbMZLYpj7vOjHn6CkVsunp4lqnk
         jR/o1RZc6X12Hd5SQHJRZYUv8Hhzxsrmd/ct3F5bTUUOgIt5gxE3GaRmxI71B8KRAXo5
         yrJ5YZroPlkmM8n6vsnlEuz9ja1UBxudvGwwDnI/A+A7ECsk88E2jqnJ2FzJH+9dzxEH
         l2VS9PS8lpkou07wjA/4sTqwtnsyciBcds5euI7jTI7sIvFbLtNeRCDrxQOSVclyVRAY
         MGmPJN3L0xO+eVJHU0JHFRQTKdtmUdoZsmIKSyj2g7FFBWqUhqqFKJ6WqJZOXhfgl65I
         w6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OGYJhiDzvCvS41BWqjNRM6F46YWrygkTOyNc6brBDEA=;
        b=njgUOz6vvPKHTQTxyeVfveSGwOaUiSbq8VFE2SsJcGjgcQQj5eRaCmWbsYcYck3Gdp
         9M8rlL12NoL6jGOpbFsiQEm8gMQtN8OYRHzY5a2nuSctZrOCKz3diOFnm9szkG++9wFS
         s597NdgB8C/mIw7ZMZ9d7hZSh40m7JqJhAjpZV86dpKuMmM03DOiCfVK2pqsUhiQ+NG+
         NrM0u0EcxHTl5r8YqVp47QvnHJgMf9yArHN8d55HUMl26zemlHCXW6ofsH9CPUuVZV+n
         CY1p31UnOdrwt8hvYESErmxOpoK+cr3FhSdwLj098s2m/sdGDEKqRddbnQfFaRZdAoDq
         rJLw==
X-Gm-Message-State: AOAM5331xJSYS5ua9xpQBTs7QptStb9QIyNqNjYmI9IkjyJwHc8c/OCh
        +gUryAmQedCdc4Mi1DtLChg=
X-Google-Smtp-Source: ABdhPJzLpDmWYbk+ice1H5ZAK3nHU42QIBvqosJRQ4a30j2mPqPJ4/wMtAdJNi9xIKHFImR3P4b5iw==
X-Received: by 2002:a05:6402:14d4:: with SMTP id f20mr51561692edx.316.1626910667911;
        Wed, 21 Jul 2021 16:37:47 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id m26sm9258494edf.4.2021.07.21.16.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 16:37:47 -0700 (PDT)
Date:   Thu, 22 Jul 2021 02:37:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: dsa: tag_ksz: dont let the hardware process
 the layer 4 checksum
Message-ID: <20210721233746.qi6tdreubw74l6l2@skbuf>
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-3-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721215642.19866-3-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 11:56:42PM +0200, Lino Sanfilippo wrote:
> If the checksum calculation is offloaded to the network device (e.g due to
> NETIF_F_HW_CSUM inherited from the DSA master device), the calculated
> layer 4 checksum is incorrect. This is since the DSA tag which is placed
> after the layer 4 data is considered as being part of the daa and thus
> errorneously included into the checksum calculation.
> To avoid this, always calculate the layer 4 checksum in software.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---

Fixes: 8b8010fb7876 ("dsa: add support for Microchip KSZ tail tagging")
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

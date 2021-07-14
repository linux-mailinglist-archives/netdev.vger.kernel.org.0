Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1993C917A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbhGNUCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 16:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241185AbhGNT54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 15:57:56 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656A1C06175F;
        Wed, 14 Jul 2021 12:48:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f9so4631540wrq.11;
        Wed, 14 Jul 2021 12:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aUBnfseT0Zje0G2mRhBHziBu0gGM/po1m8DQFWGOJ/o=;
        b=CX7Piuv6Dln3mJRSNmkklr+7tIkBfgYYnqF318JjM167vyqBwl/JhQSSwm9ZJ/rIIB
         9BGMH+PwEceWIalwFeLIw8Ds5AAoq8TUPfIQRCyK11XUjiR5+0jBk+szZ1jUCIELEnzD
         ZTg5k5Ra6b1tS2wSOTnYejPIad1KFpQRPGY389qYT0AmKhy8yJY9ANeeEKqFMBtzaxOw
         iuXC38wiVwk8b4gyOZzZD1UG3e+BV1NeuZjBZI0H8cWwyfrG7ZG8npdqYkckjcfZRb9j
         f7+e2js04X67g/ydqsIX8VuoaOk/CYnxPeCgRVq97VxSVQ97lsgsiJwwgi18PpoOf9GM
         8xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aUBnfseT0Zje0G2mRhBHziBu0gGM/po1m8DQFWGOJ/o=;
        b=hd/SyXgROU6V6yFpPKsbRaADORL+BGe1sZu19ZCMGiaMIfQA6uC4fksF2RMt1Pn4mh
         oP29KIyFdFDZd4D6lcSl5kpGHuholOQUGiBU1TCC2byyZ9PBCYrdK607WnwKNHUmlgrD
         L7RVBjLzasKj4jb/binuFkn9UGwrhGSYFz0wLAtyGt8PrFbALKTDnfs4oh1sXeFYABkZ
         a6eTStci0/ypyKdjor9kBcLLKPNmzxgHwODR/jjKhB+zWGZ/SSWhn2Mi7X6QBCWdc2Zp
         xy7nT42y4VRYOXtExczHYDsvkx2ZE9bxfha8tedLbDDeayDVNb5cWUn0qCZTDrhttlyR
         Z52Q==
X-Gm-Message-State: AOAM531711Zdy76OzAqXxh/XDsPSBytZATp2o2/pzCQkZ907S6W2itZM
        CdFnarZwM0GJIk8N+uHgrOg=
X-Google-Smtp-Source: ABdhPJyNNCxhreBnW/CwIZZ/vYJQQU4HSJPOJiDlvP+OMcnzbH7MSEORMih0UI+hSnYwAk2HDjCjQQ==
X-Received: by 2002:adf:e7cc:: with SMTP id e12mr15444294wrn.51.1626292094018;
        Wed, 14 Jul 2021 12:48:14 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id o5sm2004382wms.43.2021.07.14.12.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 12:48:13 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:48:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <20210714194812.stay3oqyw3ogshhj@skbuf>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714191723.31294-3-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lino,

On Wed, Jul 14, 2021 at 09:17:23PM +0200, Lino Sanfilippo wrote:
> If the checksum calculation is offloaded to the network device (e.g due to
> NETIF_F_HW_CSUM inherited from the DSA master device), the calculated
> layer 4 checksum is incorrect. This is since the DSA tag which is placed
> after the layer 4 data is seen as a part of the data portion and thus
> errorneously included into the checksum calculation.
> To avoid this, always calculate the layer 4 checksum in software.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---

This needs to be solved more generically for all tail taggers. Let me
try out a few things tomorrow and come with a proposal.

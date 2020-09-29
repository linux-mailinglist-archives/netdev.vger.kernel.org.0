Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB127D2CB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgI2PdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgI2PdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:33:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9445DC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:33:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ml18so26075pjb.2
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xdnx/+iVzw5VE3vVEpsA7ZB6zMSPgW1lE0R336Q+81c=;
        b=T0ZPL6SvBmp/0/W/Zgeak6XZz4Ddc94BMa+zXFO5bUnJdGQl5Dmgp+H292pkYvMQFD
         dSc16DhGI28iMErahoyckp9QRBLzUPLDP3mEh8h0ZxvatuZdZ7QYoZkls7w6Y99xBM5B
         us18/PYXPJDHlSPqUObdVXr1pw3avUmij67PqjPoFkinxSfFlbRV5RZcTwHqzme8KEt8
         myyAfJ+KO8cqH+rrV4zgEv4cdOr3CuxjQ7lbmqGTo7/lVGjw5gwELpgCIzHgqSqMjhnh
         xwOLac1NLzPHm/d94x/iOiSCCs7QzdA21S+vMxsV1/qcWRkOZqp2Cb4uCWVipUzJ4sxR
         X6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdnx/+iVzw5VE3vVEpsA7ZB6zMSPgW1lE0R336Q+81c=;
        b=fshyxwbGwbBmPZ1RU7qVQpX+AVTYfcxuyQTVfuaNvzrfzac55rXVAn6+DwEnXj5FgL
         7oTgLvC7EnDV7mMlfE2CRebR3LKUTOrRgoYYkoENmolakD40ahXTgF3u0HITovgbl/Cf
         WE+xaNEhxQkm8hDlc96Iwwl/9QVtpkpRB6og9JzZACWjM3jSoQEdcOellR0Leorl1lVQ
         2toock9MJFz2G9aT+z4acizlf/VAxq4il4lANPuDZsi8ewFgmrEHVyZ0Nwu5T1x8Hz9G
         fXyVwy60mNbqRfAgQb74o1mgKxetIqWdyBquDZjyTPsB9OBhtYSOMqMRzUPb/RovOV0e
         FCuw==
X-Gm-Message-State: AOAM531VBZMSj+D7pQsVyRgYwx2p7DsgYrL201NSNaOnC3qmu4qC2qpi
        EWn2KHzJ9Qys/N7SDBsU2+E=
X-Google-Smtp-Source: ABdhPJwH0nbZHj5mxlFSqwIVAUdz/JesUJ9h0JhepC+9e1e35QZ2YLBPNoHdI5GtcuMZuOvoQMm2/g==
X-Received: by 2002:a17:90a:9a92:: with SMTP id e18mr4334078pjp.211.1601393604049;
        Tue, 29 Sep 2020 08:33:24 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id e16sm5086801pgv.81.2020.09.29.08.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 08:33:23 -0700 (PDT)
Subject: Re: [iproute2-next v4 0/2] devlink: add flash update overwrite mask
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>, Jakub Kicinski <kuba@kernel.org>
References: <20200909222842.33952-1-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <198b8a34-49de-88e8-629c-408e592f42a6@gmail.com>
Date:   Tue, 29 Sep 2020 08:33:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200909222842.33952-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 3:28 PM, Jacob Keller wrote:
> This series implements the iproute2 side of the new
> DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
> 
> This attribute is used to allow userspace to indicate what a device should
> do with various subsections of a flash component when updating. For example,
> a flash component might contain vital data such as the PCIe serial number or
> configuration fields such as settings that control device bootup.
> 
> The overwrite mask allows the user to specify what behavior they want when
> performing an update. If nothing is specified, then the update should
> preserve all vital fields and configuration.
> 
> By specifying "overwrite identifiers" the user requests that the flash
> update should overwrite any identifiers in the updated flash component with
> identifier values from the provided flash image.
> 
>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite identifiers
> 
> By specifying "overwrite settings" the user requests that the flash update
> should overwrite any settings in the updated flash component with setting
> values from the provided flash image.
> 
>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings
> 
> These options may be combined, in which case both subsections will be sent
> in the overwrite mask, resulting in a request to overwrite all settings and
> identifiers stored in the updated flash components.
> 
>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings overwrite identifiers
> 
> Cc: Jiri Pirko <jiri@mellanox.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> Jacob Keller (2):
>   Update devlink header for overwrite mask attribute
>   devlink: support setting the overwrite mask
> 
>  devlink/devlink.c            | 48 ++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/devlink.h | 27 ++++++++++++++++++++
>  2 files changed, 73 insertions(+), 2 deletions(-)
> 
> 
> base-commit: ad34d5fadb0b4699b0fe136fc408685e26bb1b43
> 

Jacob:

Compile fails on Ubuntu 20.04:

devlink
    CC       devlink.o
In file included from devlink.c:29:
devlink.c: In function ‘flash_overwrite_section_get’:
../include/uapi/linux/devlink.h:249:42: warning: implicit declaration of
function ‘_BITUL’ [-Wimplicit-function-declaration]
  249 | #define DEVLINK_FLASH_OVERWRITE_SETTINGS
_BITUL(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
      |                                          ^~~~~~
devlink.c:1293:12: note: in expansion of macro
‘DEVLINK_FLASH_OVERWRITE_SETTINGS’
 1293 |   *mask |= DEVLINK_FLASH_OVERWRITE_SETTINGS;
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CC       mnlg.o
    LINK     devlink

I updated headers in -next; please redo the patch set and roll the cover
letter details in patch 2.

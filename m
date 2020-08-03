Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856B023A955
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgHCP2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:28:05 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368A2C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:28:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 9so14664035wmj.5
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7ed6al/WjAOZrLPX2ruzPZED/8yesWjySh80z0AKANI=;
        b=pdLYVj0s2K37J3hwNYbnwmw23ICKSU11cK8twNdwLXoVwSyj6vptA6/d/R5A4UnH99
         N+VnqNNxICJ0WdWFAJ0ne5ud/0s+WA9RPrqEDQm5S95JA6rvKn31tQt9XKhaz9GhZ2xI
         0NvfL/6zoMdOReNW8DtUilo+vEWWrIDQXvg9YQ/tR0s8YXryYZCDy1pSZNMSX6J1hqPV
         zOJiAMbUBVpQk1INybSi2oQC6BIlIYcWBWex4d4mu/3H69hgVSYPLnYYilu7X9oXPdgT
         sOrCfeOwRQWPnhRO1lZvYnhG3mXkjQ/onOYusZ0U47hFRlrHPMy8XY2G974RInet6/Fj
         iyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7ed6al/WjAOZrLPX2ruzPZED/8yesWjySh80z0AKANI=;
        b=QsAr1w8Kv0M0oPUSwA5h580YJ0j8UDxXnEFhz33fYT9EU2Ky/y1KOx4hLX8J7dbON1
         Fe74UL6r7zUmupOAgl8GrABXHQktzv2Sn6zo84e9oaQVwK04qD5oo4QW8eW8bUDz6lBC
         lxXwy3nj91neXvC0f55vuhzzwXSP0By9SCy5gGVKPV9/H8xO3hRaRJAzKmvPvqrW4RLk
         YsQZ5MK9Nkh1FwngS8jLJlYA2x9LUl0STUcEe7cmNSJF4IQG/g+/1G02dYLT7hMm7WzY
         dvqzOOMQP56ZwrLUfHKZwMbi/bJE9/rTluE6pnUiE9LERdvGPypSSWMRqNFUob6AhwKD
         i0dA==
X-Gm-Message-State: AOAM533GOQ4gDbkj4JZ+45w/FEX3N8uNwmpO1OvnFJJ1ZrnNyd0C1SVi
        o1OH7Qh6gKxt0qtqvQz+eEDaqg==
X-Google-Smtp-Source: ABdhPJwTRwMCpWZ+NuuHSHnbvBuGUrveIpw6iiyH/8xEY9/fUD+OQ+jGhxaispuSkrVxhovgTsf2Jg==
X-Received: by 2002:a7b:cc14:: with SMTP id f20mr491884wmh.82.1596468482354;
        Mon, 03 Aug 2020 08:28:02 -0700 (PDT)
Received: from localhost (ip-89-176-225-97.net.upcbroadband.cz. [89.176.225.97])
        by smtp.gmail.com with ESMTPSA id n11sm17789530wmi.15.2020.08.03.08.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 08:28:01 -0700 (PDT)
Date:   Mon, 3 Aug 2020 17:28:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v2 0/5] devlink flash update overwrite mask
Message-ID: <20200803152800.GC2290@nanopsycho>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801002159.3300425-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 01, 2020 at 02:21:54AM CEST, jacob.e.keller@intel.com wrote:
>This series introduces support for a new attribute to the flash update
>command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK. This attribute is a u32
>value that represents a bitmask of which subsections of flash to
>request/allow overwriting when performing a flash update.
>
>The intent is to support the ability to control overwriting options of the
>ice hardware flash update. Specifically, the ice flash components combine
>settings and identifiers within the firmware flash section. This series
>introduces the two subsections, "identifiers" and "settings". With the new
>attribute, users can request to overwrite these subsections when performing
>a flash update. By existing convention, it is assumed that flash program
>binaries are always updated (and thus overwritten), and no mask bit is
>provided to control this.
>
>First, the .flash_update command is modified to take a parameter structure.
>A new supported_flash_update_params field is also provided to allow drivers
>to opt-in to the parameters they support rather than opting out. This is
>similar to the recently added supported_coalesc_params field in ethtool.
>
>Following this, the new overwrite mask parameter is added, along with the
>associated supported bit. The netdevsim driver is updated to support this
>parameter, along with a few self tests to help verify the interface is
>working as expected.
>
>Finally, the ice driver is modified to support the parameter, converting it
>into the firmware preservation level request.
>
>Patches to enable support for specifying the overwrite sections are also
>provided for iproute2-next. This is done primarily in order to enable the
>tests for netdevsim. As discussed previously on the list, the primary
>motivations for the overwrite mode are two-fold.
>
>First, supporting update with a customized image that has pre-configured
>settings and identifiers, used with overwrite of both settings and
>identifiers. This enables an initial update to overwrite default values and
>customize the adapter with a new serial ID and fresh settings. Second, it
>may sometimes be useful to allow overwriting of settings when updating in
>order to guarantee that the settings in the flash section are "known good".


I'm missing examples in the cover letter. It is much easier to
understand the nature of the patchset with examples. Could you please
repost with them?

Thanks!



>
>Changes since v1
>* Added supported_flash_update_params field, removing some boilerplate in
>  each driver. This also makes it easier to add new parameters in the future
>  without fear of accidentally breaking an existing driver, due to opt-in
>  behavior instead of forcing drivers to opt-out.
>* Split the ice changes to a separate patch.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Jonathan Corbet <corbet@lwn.net>
>Cc: Michael Chan <michael.chan@broadcom.com>
>Cc: Bin Luo <luobin9@huawei.com>
>Cc: Saeed Mahameed <saeedm@mellanox.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>Cc: Ido Schimmel <idosch@mellanox.com>
>Cc: Danielle Ratson <danieller@mellanox.com>
>
>Jacob Keller (3):
>  devlink: convert flash_update to use params structure
>  devlink: introduce flash update overwrite mask
>  ice: add support for flash update overwrite mask
>
> .../networking/devlink/devlink-flash.rst      | 29 ++++++++++++++
> Documentation/networking/devlink/ice.rst      | 31 +++++++++++++++
> .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 19 ++++-----
> .../net/ethernet/huawei/hinic/hinic_devlink.c |  8 +---
> drivers/net/ethernet/intel/ice/ice_devlink.c  | 33 +++++++++++-----
> .../net/ethernet/intel/ice/ice_fw_update.c    | 16 +++++++-
> .../net/ethernet/intel/ice/ice_fw_update.h    |  2 +-
> .../net/ethernet/mellanox/mlx5/core/devlink.c |  8 +---
> drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 +--
> drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +-
> .../net/ethernet/mellanox/mlxsw/spectrum.c    |  7 +---
> .../net/ethernet/netronome/nfp/nfp_devlink.c  |  9 ++---
> drivers/net/netdevsim/dev.c                   | 21 +++++++---
> drivers/net/netdevsim/netdevsim.h             |  1 +
> include/net/devlink.h                         | 35 ++++++++++++++++-
> include/uapi/linux/devlink.h                  | 24 ++++++++++++
> net/core/devlink.c                            | 39 +++++++++++++++----
> .../drivers/net/netdevsim/devlink.sh          | 21 ++++++++++
> 18 files changed, 244 insertions(+), 67 deletions(-)
>
>Jacob Keller (2):
>  Update devlink header for overwrite mask attribute
>  devlink: support setting the overwrite mask
>
> devlink/devlink.c            | 37 ++++++++++++++++++++++++++++++++++--
> include/uapi/linux/devlink.h | 24 +++++++++++++++++++++++
> 2 files changed, 59 insertions(+), 2 deletions(-)
>
>base-commit: bd69058f50d5ffa659423bcfa6fe6280ce9c760a
>-- 
>2.28.0.163.g6104cc2f0b60
>

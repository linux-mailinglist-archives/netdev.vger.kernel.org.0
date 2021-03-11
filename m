Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538183371CC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 12:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhCKLvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 06:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhCKLvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 06:51:18 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249C4C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 03:51:18 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ox4so30006150ejb.11
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 03:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6jJgRsc9AbnvyFi54h5qkcGvbSi01bvQLx+PXrG3JeI=;
        b=lAzhR7FB+TVU5CfPGOK3Uwmh61Z5rv+EDVzwNHK5BIca8CnXYcxrjgHltqGz61zPhu
         u/QY/EUCEg7PRh3nhW5196JD1gPIbIPXPGt6Pj1zjdoeeLYDRSD1ynsxCYRTlkuDkgTH
         nOeVShEXoz3ONrcPs9ll8KXqtTs2ZkDlHNc/XDpy/yOxMMPKIHk7EyqWaj+Z7npZzkp4
         7QBuWBZumKs0YeKPPJKtl9ryKr01akHkrVfnq3yq7xuLlfqj0/gBqBaSnqQTufKUxDeK
         2xVupkbffQHPwlRgyYAQ7gMKPHIJARoBz+wwcAMDAF9zkoXDiBPR1V7jdJ6Co/1IqTC1
         yg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6jJgRsc9AbnvyFi54h5qkcGvbSi01bvQLx+PXrG3JeI=;
        b=dSNDH3pRZmMsanGEhJHuX7iBDAJrSNMd55/1P0uqgRL7lK0iLMLz4M2QqZglpV2IpN
         ggwNsQZvw57zcjI/+N0zyfLeQI1oVO0zFZq8V/G6U3ztObYUEOyIt5EpwuRrbMtPZqyV
         r08gIynEJAoOQnLSNPEOX6chWQ3cQVOJYnJkQdhMhi7Pebgi7WMPVu5945lD73Y8Wqzm
         abUC9MKSiU6UFYV+Rl8mGFcR5vX5bl41ZeIQvxaT+3qvGPsT9kfSX58B5ux4lA7tjVFG
         vPgzHr48wPmxieEHpiy7W78PwijqkMzE8b4RClTXISXXjHUtg56uMAmgx7hmvZxVd662
         rk8A==
X-Gm-Message-State: AOAM53195rTJp5+6YWIDwJF4lMxeGdIaBWeX91ibjzNMkJgKHLj8mXjX
        UioZ8iOhftuRoGejs82FuF1zbQ==
X-Google-Smtp-Source: ABdhPJzn/XjzNGGdMXUxH41H5kbhtdZmthjHjo2mmJt/bhStdyC4YUyQD0rauIelh2tO3GroDTk8Cg==
X-Received: by 2002:a17:906:53d7:: with SMTP id p23mr2728016ejo.140.1615463476876;
        Thu, 11 Mar 2021 03:51:16 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id x4sm1083598edd.58.2021.03.11.03.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 03:51:16 -0800 (PST)
Date:   Thu, 11 Mar 2021 12:51:15 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, oss-drivers@netronome.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, drivers@pensando.io,
        snelson@pensando.io, netanel@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com
Subject: Re: [RFC PATCH 03/10] nfp: Replace nfp_pr_et with ethtool_gsprintf
Message-ID: <20210311115115.GA12530@netronome.com>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
 <161542653266.13546.11914667071718045956.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161542653266.13546.11914667071718045956.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 05:35:32PM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> The nfp_pr_et function is nearly identical to ethtool_gsprintf except for
> the fact that it passes the pointer by value and as a return whereas
> ethtool_gsprintf passes it as a pointer.
> 
> Since they are so close just update nfp to make use of ethtool_gsprintf
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

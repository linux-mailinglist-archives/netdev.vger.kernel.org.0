Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19E46E761
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbhLILT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbhLILT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:19:57 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE19C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 03:16:23 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t9so9065187wrx.7
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 03:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8AS2+fjKTCdK/tugD/kZ9IGEKX/TtBYXDsW8ZkOfDyg=;
        b=x6rXfAfjFtrkIF+z7JJTXZmxjIaepniVgtEU7LC9PP8nRcL1Lbk9QPVuWWOqpjnwWL
         59pkV3rQnoKYPV6Mj6AtWpkYcOqlwjI+AfluBUUAOgR0Y69a5btfStVj0XYnPPd/9moV
         VAKEXHAL56W3VnPW53nGiT+RQHog0zOLvb2pcwo0EtV3aIYJVOhZtyKs/w9BlZXXDP/B
         n2Q0nyEMNTCVt/ukL0I7P04WPS+u2+z08GVj14ULrfUGq7wTaNQvtv+aDEN7Tki2E2w4
         oSIOQus7l63MybcJYvjIT/2p1N79pd9qBqdHspP2TzoW+0virTLt5w9C4TqQ+gEshV2E
         7riw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8AS2+fjKTCdK/tugD/kZ9IGEKX/TtBYXDsW8ZkOfDyg=;
        b=3ikmZ70b8kaUt8qESXNnOVBqyP8HY5p4NvTKA8qmd6jS2UKrFUUxFoVClFtfyLN3Yk
         AhxiMi5hNtpRe/mJadGocHKZZKejji7OYkbzNh9+FuU8TRbtv4JnW7JM/ocajcywB2dt
         RpBfAIWCwawb8tJTD5tqrkNx/ySiIVJMNXtAS/I3SVOc16GxHeie2ipuawxSP017i+7t
         JIdLBaxvbDr/SBWL2i0e/IKIF0a6KYkH/mZtlh1O3GvxoZxMxmsygg0ntH5CLi56I2yZ
         rAIYmw0e6s4HFjbVRgo4nc1IIG9TQmxAeAumbRp/hyZGJsNuG1niV+3PYP8EX/y9e+Sj
         975Q==
X-Gm-Message-State: AOAM53251xe2gR68yAxy2V791fyF+HmW4dhQqmJA4d58ZmqV+Cz/QgQ5
        Gsl3Iyklun1Hsbax8ErSCAN4DP9o078/XbEuDMo=
X-Google-Smtp-Source: ABdhPJyKYDOGxA6gESzkGn6KuNPY64wNqQOflplK4/lamEoWYnS+Kt6okDeHVbs8ynuyDRz0wvieAQ==
X-Received: by 2002:a05:6000:547:: with SMTP id b7mr5616505wrf.543.1639048582498;
        Thu, 09 Dec 2021 03:16:22 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p19sm6032208wmq.4.2021.12.09.03.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 03:16:22 -0800 (PST)
Date:   Thu, 9 Dec 2021 12:16:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shay Drory <shayd@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v4 2/7] devlink: Add new "io_eq_size" generic
 device param
Message-ID: <YbHlhd0sFDwF5b6g@nanopsycho>
References: <20211209100929.28115-1-shayd@nvidia.com>
 <20211209100929.28115-3-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209100929.28115-3-shayd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 09, 2021 at 11:09:24AM CET, shayd@nvidia.com wrote:
>Add new device generic parameter to determine the size of the
>I/O completion EQs.
>
>For example, to reduce I/O EQ size to 64, execute:
>$ devlink dev param set pci/0000:06:00.0 \
>              name io_eq_size value 64 cmode driverinit
>$ devlink dev reload pci/0000:06:00.0
>
>Signed-off-by: Shay Drory <shayd@nvidia.com>
>Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

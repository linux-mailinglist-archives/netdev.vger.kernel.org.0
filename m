Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3D46B500
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhLGIEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:04:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57962 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhLGIEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:04:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5912B80E8C
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 08:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF41AC341C3;
        Tue,  7 Dec 2021 08:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638864043;
        bh=HB1Cc0/98W1dCe9faFpKpNd5F9rQqTzzYIO2vc3IaWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yrcwm62qHbnqm1MoJXy48AKs/QODHx0tWw7xLZ1tzrTou0Md/DTkI87AHxj+u9lCH
         cXXtT2LjHYsOIA7KtP60cLG1zvtNNdchJZFPzWDvITlLD32gYs/272QYcPMbypCxM9
         uB0yNLmfb4oMCKDe4Awz2gZjxS23OmFIxr2THAqPRvG+ilSQUrzwjnZtCmqXlqWNOv
         5Hdsk0aM4755n3XPZJVvvbjJ0Ua2axmyNV1/I/kAj33mPGB+RvAAsoax9C5faghw27
         7DYZ9+Vl5ti25OhqGQZHpwDpQXo215nfHjsz72P5zSxQzYmq6taoPxtsYn+OLucbHB
         hbTc2Y4eboe6g==
Date:   Tue, 7 Dec 2021 10:00:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next v2 4/4] net: wwan: make debugfs optional
Message-ID: <Ya8Up73OsIsPnNJN@unreal>
References: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
 <20211206234155.15578-5-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206234155.15578-5-ryazanov.s.a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 02:41:55AM +0300, Sergey Ryazanov wrote:
> Debugfs interface is optional for the regular modem use. Some distros
> and users will want to disable this feature for security or kernel
> size reasons. So add a configuration option that allows to completely
> disable the debugfs interface of the WWAN devices.
> 
> A primary considered use case for this option was embedded firmwares.
> For example, in OpenWrt, you can not completely disable debugfs, as a
> lot of wireless stuff can only be configured and monitored with the
> debugfs knobs. At the same time, reducing the size of a kernel and
> modules is an essential task in the world of embedded software.
> Disabling the WWAN and IOSM debugfs interfaces allows us to save 50K
> (x86-64 build) of space for module storage. Not much, but already
> considerable when you only have 16MB of storage.
> 
> So it is hard to just disable whole debugfs. Users need some fine
> grained set of options to control which debugfs interface is important
> and should be available and which is not.
> 
> The new configuration symbol is enabled by default and is hidden under
> the EXPERT option. So a regular user would not be bothered by another
> one configuration question. While an embedded distro maintainer will be
> able to a little more reduce the final image size.
> 
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

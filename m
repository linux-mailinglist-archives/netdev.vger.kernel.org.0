Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563461F3930
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgFILM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgFILM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 07:12:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4268207ED;
        Tue,  9 Jun 2020 11:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591701147;
        bh=ewuOrh3hec6FNb/T9bCOHV2iU6/KcE9Pbmc3oCcJEYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cDnD3U8K/dydzAC8XwVD7RME1DfHGWF90PR+Kb32egq/ZLw/pOwaul2WZEYqgtKPp
         YyXJ61MC9tPIfpNTctfID0CawBabJjKChVFB1rn8WwbOyRj5xtVx2AKMk0yaqUcNHq
         r6rOZ8+4mWkTjrFcrxXEiZmu9nJoPcXi10+scr8g=
Date:   Tue, 9 Jun 2020 13:12:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 5/7] venus: Add debugfs interface to set firmware log
 level
Message-ID: <20200609111224.GA780233@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-6-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-6-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:46:02PM +0300, Stanimir Varbanov wrote:
> +int venus_dbgfs_init(struct venus_core *core)
> +{
> +	core->root = debugfs_create_dir("venus", NULL);
> +	if (IS_ERR(core->root))
> +		return IS_ERR(core->root);

You really do not care, and obviously did not test this on a system with
CONFIG_DEBUG_FS disabled :)

Just make the call to debugfs, and move on, feed it into other debugfs
calls, all is good.

This function should just return 'void', no need to care about this at
all.

> +	ret = venus_sys_set_debug(hdev, venus_fw_debug);
> +	if (ret)
> +		dev_warn(dev, "setting fw debug msg ON failed (%d)\n", ret);

Why do you care about this "error"?

thanks,

greg k-h

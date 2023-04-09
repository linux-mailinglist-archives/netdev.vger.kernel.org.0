Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2296DBFC8
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDIMIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 08:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIMIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 08:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AB5212C
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 05:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5E560BC1
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 12:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8234C433EF;
        Sun,  9 Apr 2023 12:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681042097;
        bh=CAZCweiix7IKAJjlfdC/lEOuZj7gXMgMKo0FNKgRCc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXjWOyFHZJMnM7Ob6By7wD/cjfOSRZep7XDO3OHIKBtKsZ2LU/qs7nGWVDmP16bW0
         ckPdpCl8ZZ38XgBv/fMcqrpkABuC7ku1rSJu/oSRsjHHoRk/jt9TQD2ToRmekgL+mv
         lMtLf+EmKVpZsEz0eWLRng3GhWcHS53OURdsKMi+qVJWrOldzvvJH8IPkktkdI92/a
         afFmAjb0M2nlt6eluk6RerTQ3dZi4ogTurnEFz1521L+P3POXBzeAbBCIDupTSQyYE
         ML7kWHyTb8nUV3vdkQZFzFPbwpeQhsFZKmGsVf1WL19OLuJSL/utTX092YMeawnRmY
         QDt9iOsWoD1eA==
Date:   Sun, 9 Apr 2023 15:08:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 08/14] pds_core: set up the VIF definitions
 and defaults
Message-ID: <20230409120813.GE182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-9-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-9-shannon.nelson@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:37PM -0700, Shannon Nelson wrote:
> The Virtual Interfaces (VIFs) supported by the DSC's
> configuration (vDPA, Eth, RDMA, etc) are reported in the
> dev_ident struct and made visible in debugfs.  At this point
> only vDPA is supported in this driver - the other interfaces
> are defined for future use but not yet realized.

Let's add only supported modes for now.

<...>

> +static int viftype_show(struct seq_file *seq, void *v)
> +{
> +	struct pdsc *pdsc = seq->private;
> +	int vt;
> +
> +	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
> +		if (!pdsc->viftype_status[vt].name)
> +			continue;
> +
> +		seq_printf(seq, "%s\t%d supported %d enabled\n",
> +			   pdsc->viftype_status[vt].name,
> +			   pdsc->viftype_status[vt].supported,
> +			   pdsc->viftype_status[vt].enabled);
> +	}
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(viftype);

I think that it is handled by devlink.

Thanks

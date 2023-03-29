Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71026CD357
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjC2HgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjC2Hfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607D446BB;
        Wed, 29 Mar 2023 00:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFF5B61AE1;
        Wed, 29 Mar 2023 07:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC4C433EF;
        Wed, 29 Mar 2023 07:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680075198;
        bh=9t0eHIsz0o5SNikX6I93qBW5h+kCwz8SzMCmVMOCLls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=stBkacp9IN/w1iQ3Yzd+ZCk5NdOPY0qg6fQTPfUiyARToJcY4Vg0kOf8SN/aQWi+9
         XJhA21H7Is6ncWw62ClA2U1Qwo533fhFgwN6fRVD/FXRvPH2hPQzzQKQOqSqhe3nXD
         CNfybADiTkE0XneBJGK6cPq4Z0XTLkR2aLRa/25xgMkaQ8zFsWZA/cy8ko05ZuUYzi
         9jCQjIklkQL7aXcIsN1G0yFNM32VHwKq0ZdYtYgnhrU6+DpIGSXJmyZILBGlDIKu4j
         LHn4SVDDDWjRABb5xvscAI0tBxk6+PVlo8CNQWbZtYVJrnTEZb9k9YJt423Cp6/jxK
         w0U7Ya3w0lxSA==
Date:   Wed, 29 Mar 2023 10:33:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [EXT] Re: [PATCH net-next v4 8/8] octeon_ep: add heartbeat
 monitor
Message-ID: <20230329073313.GG831478@unreal>
References: <20230322091958.13103-1-vburru@marvell.com>
 <20230322091958.13103-9-vburru@marvell.com>
 <20230323104703.GD36557@unreal>
 <MN2PR18MB2430F4C6F2EE41D650C3651DCC879@MN2PR18MB2430.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB2430F4C6F2EE41D650C3651DCC879@MN2PR18MB2430.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 06:14:10PM +0000, Veerasenareddy Burru wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, March 23, 2023 3:47 AM
> > To: Veerasenareddy Burru <vburru@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayarekar
> > <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> > Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> > Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > Subject: [EXT] Re: [PATCH net-next v4 8/8] octeon_ep: add heartbeat
> > monitor
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Wed, Mar 22, 2023 at 02:19:57AM -0700, Veerasenareddy Burru wrote:
> > > Monitor periodic heartbeat messages from device firmware.
> > > Presence of heartbeat indicates the device is active and running.
> > > If the heartbeat is missed for configured interval indicates firmware
> > > has crashed and device is unusable; in this case, PF driver stops and
> > > uninitialize the device.
> > >
> > > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > > ---
> > > v3 -> v4:
> > >  * 0007-xxx.patch in v3 is 0008-xxx.patch in v4.
> > >
> > > v2 -> v3:
> > >  * 0009-xxx.patch in v2 is now 0007-xxx.patch in v3 due to
> > >    0007 and 0008.patch from v2 are removed in v3.
> > >
> > > v1 -> v2:
> > >  * no change

<...>

> > > +	struct octep_device *oct = container_of(work, struct octep_device,
> > > +						hb_task.work);
> > > +
> > > +	int miss_cnt;
> > > +
> > > +	atomic_inc(&oct->hb_miss_cnt);
> > > +	miss_cnt = atomic_read(&oct->hb_miss_cnt);
> > 
> > miss_cnt = atomic_inc_return(&oct->hb_miss_cnt);
> > 
> 
> Thanks for the feedback. Will fix it.
> 
> > > +	if (miss_cnt < oct->conf->max_hb_miss_cnt) {
> > 
> > How is this heartbeat working? You increment on every entry to
> > octep_hb_timeout_task(), After max_hb_miss_cnt invocations, you will stop
> > your device.
> > 
> > Thanks
> > 
> 
> Yes, device will be stopped after max_hb_miss_cnt heartbeats are missed.

If I read code correctly, device will stop after octep_hb_timeout_task()
calls which happens every msecs_to_jiffies(oct->conf->hb_interval * 1000.
You don't cancel/resechdule job if timeout doesn't happen.

Thanks

> 
> > > +		queue_delayed_work(octep_wq, &oct->hb_task,
> > > +				   msecs_to_jiffies(oct->conf->hb_interval *
> > 1000));

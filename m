Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91199633455
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiKVEHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiKVEHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:07:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68D2DE8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0901D6153F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC5C433D6;
        Tue, 22 Nov 2022 04:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669090061;
        bh=kchhsUfl+ctN8yKDSC45Kn8LiGTcHiYQVnrc+Yy1tw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q0GSaI2DsZdhDd8ErZeGNj38GE4pMajTPnkiNXoA/HwG//ayGjvz991FxYYhii7p7
         AHo6oTyKlibdQFomHdp8INts/oBLDm7jcMquNDQXxIkrjfEWvRQMFzeEqLZzCLprkO
         8Yh1/LiIgiNYcypUe8M4Z197+4y0/4+MqKkTYLd5Dop8FWAgBg3Q59KSdKjbo4f9aY
         Jn6GQiLQcPA7c9+16DcPwEPQOsFOGju+tpjW1JmB0lwNYemWJYcsrt6F/7rc8Y7qY0
         vxKto6O7ePJ3PzWSf/NW45AqDSP80cyJ5GfdIh3KNh31msd6eaSoFr3ePOFZ3AMTxK
         DtYBUw/g8DESA==
Date:   Mon, 21 Nov 2022 20:07:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 3/8] devlink: report extended error message in
 region_read_dumpit
Message-ID: <20221121200740.0a0b6581@kernel.org>
In-Reply-To: <f60f589d-930c-3f44-4872-eac6b83d67ef@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-4-jacob.e.keller@intel.com>
        <20221118174012.5f4f5e21@kernel.org>
        <243100a2-abb4-6df4-235e-42a773716309@intel.com>
        <20221121112322.21bffb4b@kernel.org>
        <f60f589d-930c-3f44-4872-eac6b83d67ef@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 13:18:37 -0800 Jacob Keller wrote:
> > Ah damn, you're right, I thought I just missed it because it wasn't
> > at the top of the function.  
> 
> I also saw a few other cases where it might make sense to use a 
> GENL_CB_REQ_ATTR_CHECK or similar.
> 
> Unfortunately there's at least one area where we check for attributes 
> inside a function that is used in both flows which would get a bit 
> problematic :( Will see what I can come up with.

Perhaps this series is not the right place to worry about the missing
attr ext_ack for dumps. Go forward with v2, we can solve that later.

I think the info discrepancy falls under a larger problem of message
building code between doit and dump.

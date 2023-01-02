Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A665B832
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbjABXdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjABXc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:32:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9482FBC8C
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 570D1B80D84
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81ACC433EF;
        Mon,  2 Jan 2023 23:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672702376;
        bh=98ACekL+YzYWx5j8867ZE8SzuoOKlyXRqSxMHfM7SmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qVdW1+cyCc0eC9mZ8akPwWZj8NN7MYBgblKnHwHXv7IbIZU0HJ+mq1d++cM+nXHqj
         sGq8pvD7TGasrOKID7+tfnEE6TWqUcj9rWMCJ9QX+29cANSP8/gBlebwAqJC7vlesr
         ewmSN34E7jg5rKxRCIS6iNg17sbvFu8gC5PnFDfh2ytFEcJirY24pL1NeU8XPVfLp1
         S+wmRy1gpxfpdp5qOyfghFrxEpc9d6oCzoes4tOh1mzTo8H8ahpCjtS0YAq1rKHkYR
         bf17K016dZ/ARz9ssbH7MAD+1npUEiJA/FNqUfmMONUiXCF9aeS9lnN3FN0urbuQAk
         Lo63TLeOU5Jvg==
Date:   Mon, 2 Jan 2023 15:32:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 06/10] devlink: don't require setting features
 before registration
Message-ID: <20230102153254.22dea2be@kernel.org>
In-Reply-To: <20230102152447.05a86e28@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-7-kuba@kernel.org>
        <Y7L3Xrh7V33Ijr4M@nanopsycho>
        <20230102152447.05a86e28@kernel.org>
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

On Mon, 2 Jan 2023 15:24:47 -0800 Jakub Kicinski wrote:
> On Mon, 2 Jan 2023 16:25:18 +0100 Jiri Pirko wrote:
> > Sat, Dec 17, 2022 at 02:19:49AM CET, kuba@kernel.org wrote:  
> > >Requiring devlink_set_features() to be run before devlink is
> > >registered is overzealous. devlink_set_features() itself is
> > >a leftover from old workarounds which were trying to prevent
> > >initiating reload before probe was complete.    
> > 
> > Wouldn't it be better to remove this entirely? I don't think it is
> > needed anymore.  
> 
> I think you're right. Since users don't have access to the instance
> before it's registered - this flag can have no impact.

Let's leave this for a separate follow up, mlx5 needs a bit more work.
It sets the feature conditionally.

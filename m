Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5801C510589
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 19:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351040AbiDZRiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 13:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352801AbiDZRis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 13:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A1F1CB19
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 10:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E44DF6169B
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9A2C385A0;
        Tue, 26 Apr 2022 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650994539;
        bh=j9T55L5pWRH64Fl0E+/hqztb83wa2rdXd804RfupJa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S1aoDavAMuk3T4+iZ059ocfm2tBBkMEdWXSrvzc/G71r6b5oeWgAFm6TVtN9pFK4Q
         klAuNrpEIAd29I7CxpVn6/Fe0IbC5DekriGJRMPL3I+L6lLTXqdc0+EiKnQGRn9Ndh
         jwY6hovdaJA+7QABg7T67rBk3If52N8ouCZsqpDVwADK/yBL8EABzQgAsb7afq+vYj
         kx78S+PlaL2C1nbwPkNI3/7WjabaxAMQwMC4F+anCyv+KhUkH9IkUqPMzSIq4L/ZW9
         8VULBdIlqJR+QNU/pzWzHNu6+QhoBdTNfRJNWkAUqiMhR7xJ8MLahKD5NjuXnVAZsD
         JqxVTmSqDCy6Q==
Date:   Tue, 26 Apr 2022 10:35:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 e7d6987e09a328d4a949701db40ef63fbb970670
Message-ID: <20220426103537.4d0f43b7@kernel.org>
In-Reply-To: <YmgIu4L6f4WfrIte@nanopsycho>
References: <6267862c.xuehJN2IUHn8WMof%lkp@intel.com>
        <20220426051716.7fc4b9c1@kernel.org>
        <Ymfol/Cf66KCYKA1@nanopsycho>
        <YmgIu4L6f4WfrIte@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 16:59:07 +0200 Jiri Pirko wrote:
> >>is this one on your radar?  
> >
> >Will send a fix for this, thanks.  
> 
> Can't find the line. I don't see
> e7d6987e09a328d4a949701db40ef63fbb970670 in linux-next :/

Eh, no idea which tree it came from, but FWIW I do have that one in my
local tree. So here it is:

   844		devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
   845							   slot_index, &mlxsw_linecard_ops,
   846							   linecard);
   847		if (IS_ERR(devlink_linecard)) {
   848			err = PTR_ERR(devlink_linecard);
   849			goto err_devlink_linecard_create;
   850		}
   851		linecard->devlink_linecard = devlink_linecard;
   852		INIT_DELAYED_WORK(&linecard->status_event_to_dw,
   853				  &mlxsw_linecard_status_event_to_work);

Unless I'm missing something looks like a false positive :S

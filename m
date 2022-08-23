Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C79C59ED31
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiHWUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiHWULv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:11:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2280E6D
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3AEEECE1F3E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 19:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63419C433D6;
        Tue, 23 Aug 2022 19:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661283129;
        bh=VWQScpq+XQKmkifLlsa3q/bd7bM0oBH/YyLYsh3AnE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZicFBBPWw0R4ZHa5vjVYlgJ1DQWVsRmo7sYNhadhUA/U0KBWs8cnz07M5Zy6ld/DM
         xkcmA9cYJwVVKZ+fQW+VfmAAeMDoe8ODZUHCx50kj9n35DvyYNkazjFx8sNqu7NfP4
         OqXYj0Rpn2VUTMc2M4+KUrtzk7WsLmY4Tg/LLKVi82sHhElb9aDBsqtsLZmvdt+2Ar
         9eME6vm5Iag97Os1nN2akHjTzCA8iaeeLEzQWIg02RhJLbWl48w4SCseFfHKIzXJEX
         UBc9ZodZmNMcRrUllZ+ct0OQbx1+RnFsZkINpo5dwtJyV/3TZRB68XtifLYmy88Pe1
         SzrDYXWt5bKfg==
Date:   Tue, 23 Aug 2022 12:32:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 1/4] net: devlink: extend info_get() version
 put to indicate a flash component
Message-ID: <20220823123208.61487225@kernel.org>
In-Reply-To: <YwR1GCPCKuK4WJRA@nanopsycho>
References: <20220822170247.974743-1-jiri@resnulli.us>
        <20220822170247.974743-2-jiri@resnulli.us>
        <20220822200026.12bdfbf9@kernel.org>
        <YwR1GCPCKuK4WJRA@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 08:35:04 +0200 Jiri Pirko wrote:
> Tue, Aug 23, 2022 at 05:00:26AM CEST, kuba@kernel.org wrote:
> >On Mon, 22 Aug 2022 19:02:44 +0200 Jiri Pirko wrote:  
> >> +int devlink_info_version_running_put_ext(struct devlink_info_req *req,
> >> +					 const char *version_name,
> >> +					 const char *version_value,
> >> +					 enum devlink_info_version_type version_type);  
> >
> >Why are we hooking into running, wouldn't stored make more sense?  
> 
> I think eventually this should be in both. Netdevsim and mlxsw (which I
> did this originally for) does not have "stored".

Well, netdevsim is just API dust, and mlxsw is incorrect :/

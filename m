Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2B0692E51
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBKEYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKEYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:24:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0137F83E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 20:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5592460909
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 04:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5559EC433EF;
        Sat, 11 Feb 2023 04:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676089439;
        bh=MNAUbunyonmyiqepQUwlEzjAiFs8OHDJHiDDZN/B7Bc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BmF0KEwz5x2HSU1SUod6D3CRkg7xuFZNrf/NcJQjpKxAb/CJLk2TYzV+1kPEJ91YY
         5WI7u2x9aHM3H1rah9J53z99z2OnwjtbOe7e2bMO/+6P3J00Ov6HtAcUpkhPgsXqTU
         Ja7PDCCpEPRHSek4Gro3f/ViBSkseurFt+rRybP/ybaIXUaie/buKLlmh/GmDZmkNY
         vQTgk0n7wKiw+MH8nGsjscq1cYNNK7PuLZmIX9WcAVMQkYJd52SLmwWQcR+doXoXr3
         RUaxTJw8lwh99r7za/Dsfg3Pwgwnzh1ysWa8Z9tFlE1FrfIR3ITwD8W/vvA6pQgI+r
         EjdjTEtHaWOag==
Date:   Fri, 10 Feb 2023 20:23:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, paul.m.stillwell.jr@intel.com,
        jacob.e.keller@intel.com, jiri@nvidia.com, idosch@idosch.org
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Message-ID: <20230210202358.6a2e890b@kernel.org>
In-Reply-To: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can you describe how this is used a little bit?
The FW log is captured at some level always (e.g. warns) 
or unless user enables _nothing_ will come out?

On Thu,  9 Feb 2023 11:06:57 -0800 Tony Nguyen wrote:
> devlink dev param set <pci dev> name fwlog_enabled value <true/false> cmode runtime
> devlink dev param set <pci dev> name fwlog_level value <0-4> cmode runtime
> devlink dev param set <pci dev> name fwlog_resolution value <1-128> cmode runtime

If you're using debugfs as a pipe you should put these enable knobs 
in there as well. Or add a proper devlink command to carry all this
information via structured netlink (fw log + level + enable are hardly
Intel specific).

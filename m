Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA450C7CD
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 08:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiDWGg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 02:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiDWGgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 02:36:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2097466FA3;
        Fri, 22 Apr 2022 23:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C32EB801BB;
        Sat, 23 Apr 2022 06:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6289FC385A5;
        Sat, 23 Apr 2022 06:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650695604;
        bh=X9YSwmcvX6g9UqtXKtTCGjeh33X8NZFfZpXvaeUUCkw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fsu1iea0epS7LXiIFvGSGQ0HA1YsPHEnldY+X4/DOUbz3OSrYHKcB6gh9GeA4IR7P
         FwYRNrPuq5c8JoBF2lL0OGNf0kHsy/NGvSvpVTjeb5Sxm1z737CeUknXTVflUz0MxY
         RlBj3R86pd9Tkg+QCTexyz5qcqCAgsjjIj35uGsyNDJAdLcxJv7AWuSctmtLXx+Tns
         VRGY3vszKa0wkZKrFqniYZ9a/UBlxynXCAd6uBmOF4wjwsVAuAa12dmbXKPrhEzT2f
         QvqsbEFc3F2UU7pXXAeqOwqWHpHvtd0HQK9DxRd8TuSQ1QkbENZd4oLSqO6+5KHKNy
         6wKru4VOglUZg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220411154210.1870008-1-linux@roeck-us.net>
References: <20220411154210.1870008-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gregory Greenman <gregory.greenman@intel.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069558761.20094.13183188216260268209.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 06:33:22 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> wrote:

> In Chrome OS, a large number of crashes is observed due to corrupted timer
> lists. Steven Rostedt pointed out that this usually happens when a timer
> is freed while still active, and that the problem is often triggered
> by code calling del_timer() instead of del_timer_sync() just before
> freeing.
> 
> Steven also identified the iwlwifi driver as one of the possible culprits
> since it does exactly that.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API support")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Acked-by: Gregory Greenman <gregory.greenman@intel.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Linux v5.17.3-rc1 and Debian LLVM-14

Patch applied to wireless.git, thanks.

7635a1ad8d92 iwlwifi: iwl-dbg: Use del_timer_sync() before freeing

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220411154210.1870008-1-linux@roeck-us.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


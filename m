Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69644F5637
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 08:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiDFGCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 02:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358232AbiDFEn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 00:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08751BA69F
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 17:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 450136167B
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 00:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB31C385A0;
        Wed,  6 Apr 2022 00:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649205710;
        bh=dlFwVWe2qnF0V8wafiw9HalXKvqkZXMrTrzmfI00Bx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t4OH8xcwkkeUh87mLfH3wYC84rbvKXXoHRXYTct0IcDBLuyOWo3C4l3viI+4RjNxK
         mlanBVC/8djO/eCUyYX1qRSKFNH0/+cVetyRMwXRzWGfslcyncP4UGkyirA3Yo7DQL
         iUNiSbYoXAqi6sJFgp7R9l0+FbNmroa9EVHkx4jscdiRnOtkgqjKeeDmXGwyovqxjS
         Lxm1ftyDk8tkGrLKGEwbCdK/oxwPIjQhheD9xzvY8CmoQHo6uxpasyqND4YnGio6LE
         Zq3sdxotb+tEavVYmpxWj8o99zT8ltZL3U27yA6SP6yY1sMAVqqKpSHYgsMRHodjb/
         +udyaSDOFfZIQ==
Date:   Tue, 5 Apr 2022 17:41:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v3 net-next 1/4] rtnetlink: enable alt_ifname for
 setlink/newlink
Message-ID: <20220405174149.39a50448@kernel.org>
In-Reply-To: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
References: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
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

On Tue,  5 Apr 2022 15:42:34 +0200 Florent Fourcot wrote:
> buffer called "ifname" given in function rtnl_dev_get
> is always valid when called by setlink/newlink,
> but contains only empty string when IFLA_IFNAME is not given. So
> IFLA_ALT_IFNAME is always ignored
> 
> This patch fixes rtnl_dev_get function with a remove of ifname argument,
> and move ifname copy in do_setlink when required.
> 
> It extends feature of commit 76c9ac0ee878,
> "net: rtnetlink: add possibility to use alternative names as message
> handle""
> 
> Changes in v2:
>  * Remove ifname argument in rtnl_dev_get/do_setlink
>    functions (simplify code)
> 
> Changes in v3:
>  * Simplify rtnl_dev_get signature
> 
> CC: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>

This patch needs to be after patch 3, AFAICT. Otherwise someone running
a bisection and landing in between the two will have a buggy build.

Please provide a cover letter for the series, now that it's 4 patches.

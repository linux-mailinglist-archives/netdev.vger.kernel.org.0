Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8284968E723
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBHEaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjBHEaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1BB442E3;
        Tue,  7 Feb 2023 20:29:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31F69614AA;
        Wed,  8 Feb 2023 04:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE12C433EF;
        Wed,  8 Feb 2023 04:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675830586;
        bh=a/+VYkPZb//IP5f1kx1v9iTH/S8V5BsO5GiI3+WJsFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WBUgN+eL2ov9xOAASRBcvbDJyw6cauMy/FZPUP+SWXXM7FavUxTuBP/jhszz+qG+I
         yttAv2RKCmF7SMNGAJs6UXvrP4Cq+wSVNip7cgHEkThriBZC6XJvhxTPpIeQ+9pBAg
         nzQ03JIf5xrjD0K6TFO8nW6XZOf2BVCfHLK8D4YJubqVTsxwsfM6Wm/oC+rfMnsfa2
         RHeWQaJtFiipnscII8Wzvd1aDydch5mnS4BjXc/OLD0JPLQbp7og5P4fX57OLw+Qi2
         hEq6NWfc+QewcKkzGY0eYhoY3FmdJHEcnobOJE90FBFJ47G9D6SyRZjhXj08KwioCB
         amw42+blQD3CA==
Date:   Tue, 7 Feb 2023 20:29:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net,
        Andy Shevchenko <andy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 1/3] string_helpers: Move string_is_valid()
 to the header
Message-ID: <20230207202945.155c6608@kernel.org>
In-Reply-To: <20230206161314.15667-1-andriy.shevchenko@linux.intel.com>
References: <20230206161314.15667-1-andriy.shevchenko@linux.intel.com>
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

On Mon,  6 Feb 2023 18:13:12 +0200 Andy Shevchenko wrote:
> +static inline bool string_is_valid(const char *s, int len)
> +{
> +	return memchr(s, '\0', len) ? true : false;
> +}

I was tempted to suggest adding a kdoc, but perhaps the function
doesn't have an obvious enough name? Maybe we should call the helper
string_is_terminated(), instead?

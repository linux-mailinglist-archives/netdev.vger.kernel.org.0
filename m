Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B6F63E99A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLAGKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAGKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37812A13DB;
        Wed, 30 Nov 2022 22:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA523B81DA0;
        Thu,  1 Dec 2022 06:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B56C433C1;
        Thu,  1 Dec 2022 06:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669875008;
        bh=ANjxj1GkQAM5iMVlPzJq877T+O++2CEqXrG0/qDJhD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=onp3GAH2AMjoUOpo0h2+gftRv9t084Dw41n1Nhb2CDWI5UiZMCT3sBWz6/S4Gl2Go
         8w1+WbhcwPLPWHMap3kcRloL6aO4ihkF17RBy1GoUG1+WhA3HO7XEOfDmFnab98tC2
         Z1xT9nDy6nP4cSfFN/8HwwwwhT7coJtb3OHTL1/17ohuu8Wo1TH+QEgmWcWi1J1Mhm
         U81YWsW4PL+efiWWqJpmzJXbqGoIOPwYxBAw4odgTlDa4Hpluhh3qfkh2YQfCm2WuO
         z1WUA2Ior5JcEq4k4LdjTtl2nHzZAFPkQI+EjnLEUAcfXLEVdETbcOEf/dOvJdm60J
         3AhwnAqV+ynqA==
Date:   Wed, 30 Nov 2022 22:10:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     <echaudro@redhat.com>, <alexandr.lobakin@intel.com>,
        <pabeni@redhat.com>, <pshelar@ovn.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <wangpeihui@inspur.com>,
        <netdev@vger.kernel.org>, <dev@openvswitch.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH v6 net-next] net: openvswitch: Add support to
 count upcall packets
Message-ID: <20221130221007.293d7dfd@kernel.org>
In-Reply-To: <20221130091559.1120493-1-wangchuanlei@inspur.com>
References: <20221130091559.1120493-1-wangchuanlei@inspur.com>
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

On Wed, 30 Nov 2022 04:15:59 -0500 wangchuanlei wrote:
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats
> + * @ovs_vport_upcall_stats: location to store stats

s/ovs_vport_upcall_//

> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_upcall_stats *stats)

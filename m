Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D034B4BC552
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbiBSENP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:13:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiBSENO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:13:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FA9E98E3;
        Fri, 18 Feb 2022 20:12:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE10C60018;
        Sat, 19 Feb 2022 04:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F912C004E1;
        Sat, 19 Feb 2022 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645243975;
        bh=6KkYYqoGjahK/UfJGfOIukayZSuSwHiDxr1L4Yg+7/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RQz1UfsmsuxnNg8ilQqILcyrhkkouStDQOxRxgrMQG5X/Fng40tFLkTTa4OSbBB9L
         q72Qii/G5KSVbKq6urMz5bBvNqycKMXQp6UNbGy877FrmXyS/jCEtoqexg+h+1wpw8
         ErCKEgWMdbICMFMZtZf6pEMU2KeemErkT14JdU6RxLp9OKm00PbFn17Q+O0wJkFICU
         Q3sea5mlZIzmZ+3n6Kv6OVZ+Ohl7YEk5CW7DwU4HxuziAoUrp4d08zIRdxS7ZmAeTV
         3ZkOwv0QdnFQ2dx3Ix2VSNqNmstKxGy1l2YiIF/+zqrKuwCmk2rjAW6Ic0K95kh/y/
         IScd/zTAuV+FQ==
Date:   Fri, 18 Feb 2022 20:12:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v7 net-next] net-core: add InDropOtherhost counter
Message-ID: <20220218201253.45874082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACB8nPmnJA7FYFZtRgF_RASOGZhCEFHcK3n0zbtT4OJ61gkrug@mail.gmail.com>
References: <20220207235714.1050160-1-jeffreyji@google.com>
        <20220207195139.77d860cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACB8nPmnJA7FYFZtRgF_RASOGZhCEFHcK3n0zbtT4OJ61gkrug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 13:31:03 -0800 Jeffrey Ji wrote:
> Hi Jakub, I'll remove the MIB counters & instead add counters to
> rtnl_link_stats64 and rtnl_link_stats, does that sound right? 

Yup! I'd ignore rtnl_link_stats, actually since it's legacy and just
add it to the 64-bit version of the stats.

> But keep the sbk_free_drop_reason

sounds good

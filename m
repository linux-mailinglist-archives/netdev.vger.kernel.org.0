Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44125E703D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 01:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIVX3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 19:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIVX3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 19:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30792E97
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF8A612A1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 23:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7970DC433D6;
        Thu, 22 Sep 2022 23:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663889384;
        bh=jTj9hjeuKXMgvWI+QaPNeZPkKLlaL+gGKOBXvAd9qFY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Hy/inp9yYj2LUT1HQHoYWh9xx2Y5ThroGj2uVIn8IkvbHgNIXTybJAnxnnp1kEwTt
         4HhG91Fh/GaWlIZ3aGiRDtq8/eir0DPLPY3Q5qmpdcLwUfBoFlcJp03Ja5M10cvfwl
         23HNaBDHCCq0ArccZQSVuYaPuvHGLxqb0sVc8tQCAI+xS3a7bCx/pe7TIMi6ATZimv
         V1DDmRUhMc/ix9vwo+NvK1vbSYjNALvNnoM0iv1s1+ZEMZy0SKIwht3MJtYtHdhBD2
         cFlmyV1dQEjSqr2dfGl1qz+NbjmeFAnXL9LSI7hPEo9/92xG5up6qY/sBV3/jPq0TJ
         H/ErTKSDU5EkA==
Message-ID: <12ecc390-bd02-9e06-ac29-416e79462064@kernel.org>
Date:   Thu, 22 Sep 2022 16:29:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2] taprio: support dumping and setting per-tc max
 SDU
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20220914200706.1961613-1-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220914200706.1961613-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/22 2:07 PM, Vladimir Oltean wrote:
> The 802.1Q queueMaxSDU table is technically implemented in Linux as
> the TCA_TAPRIO_TC_ENTRY_MAX_SDU attribute of the TCA_TAPRIO_ATTR_TC_ENTRY
> nest. Multiple TCA_TAPRIO_ATTR_TC_ENTRY nests may appear in the netlink
> message, one per traffic class. Other configuration items that are per
> traffic class are also supposed to go there.
> 
> This is done for future extensibility of the netlink interface (I have
> the feeling that the struct tc_mqprio_qopt passed through
> TCA_TAPRIO_ATTR_PRIOMAP is not exactly extensible, which kind of defeats
> the purpose of using netlink). But otherwise, the max-sdu is parsed from
> the user, and printed, just like any other fixed-size 16 element array.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> This is the user space counterpart of:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220914153303.1792444-1-vladimir.oltean@nxp.com/
> 

still waiting for the upstream api to be merged. When that happens,
repost and include example command lines for setting and dumping along
with json output to the cover letter. Also, include tc folks such as
Jamal, Jiri and Cong


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E8A513ED5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352801AbiD1XHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiD1XHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC87C4038
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C9A620B3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 23:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B13EC385A9;
        Thu, 28 Apr 2022 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651187055;
        bh=VWtfPXcndEZeqsRSPx5gpIwzE61Kcvu5FJko2d/+gu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTGlv52GyQN31CP0JlnrwZ6dCgpBKETcBRvkvbX8SLtDTW0VSkm1k1lV1UoE7NWGl
         ENMVjV2GiD/qBO+zhO/ywwfyk/1P5dpa8GrFJD1UhvoXY8E+/Y52RodNv8gh/7yWww
         XOFjsX0cskXW5M66h5RUpd9ZUkf1P+D8SkQ0esNP/xzWsXcUfQBppreQtxoIn6F+S2
         +oLTkePConCVKAVBQZ2lDYqet6nTshq8VVhyRukA+YjQQkwOHUOnXOG0PpND6UE/yR
         v+pRLser5vVvevYtVVzKyc6KAAkGerRYiNYM5eG9AnNfATp14Zi2++hKbD5p9hKwCH
         GLuVlbNhexl+Q==
Date:   Thu, 28 Apr 2022 16:04:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, sudheer.mogilappagari@intel.com,
        sridhar.samudrala@intel.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Message-ID: <20220428160414.28990a0c@kernel.org>
In-Reply-To: <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
        <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
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

On Thu, 28 Apr 2022 10:24:20 -0700 Tony Nguyen wrote:
> This patch uses TC flower filter's classid feature to support
> forwarding packets to a device queue. Such filters with action
> forward to queue will be the highest priority switch filter in

You say "forward" here..

> HW.
> Example:
> $ tc filter add dev ens4f0 protocol ip ingress flower\
>   dst_ip 192.168.1.12 ip_proto tcp dst_port 5001\
>   skip_sw classid ffff:0x5
> 
> The above command adds an ingress filter, the accepted packets
> will be directed to queue 4. The major number represents the ingress

..and "directed" here. TC is used for so many different things you 
really need to explain what your use case is.

> qdisc. The general rule is "classID's minor number - 1" upto max
> queues supported. The queue number is in hex format.

The "general rule" you speak of is a rule you'd like to establish,
or an existing rule?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B2A6EBA3E
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 18:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDVQOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 12:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVQOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 12:14:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D061995
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 09:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B5D760F29
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 16:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9715DC433EF;
        Sat, 22 Apr 2023 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682180042;
        bh=xWizu7LhUpe1TP/x/FJhje2VzDM4xDvcZ1F1bg1GFng=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tE6hwjlqFj5gjz0buZvbo7Tl62wac9zYakDJpUZqr5Xpyn0PPTrJ+THow3C8TlADe
         5XGyfXGyXiWWV/BOpruvkmOp86s3IP3+HYigMz6X5SLoJ2exPjsXRa3Hq+Wtq015o+
         x64nbqgi4HYkmqAJqFAk31dgrslcfCgIQ5K458zl2Yr+e/lB4Ckij7k2dzFrJlymqo
         lS0FZS8lmB4IxY9NjC7YkhPP116HE5+hzNjyc7w4yJcoPLSMNf01yqct4wG4K9e/7M
         Y3X59Aw2k4ucOB+djhnCH6n5Sc8EtOJfX+gzquvyI/F9I7cTiYwVlXNKLbpZFNkgC9
         O9N9hQwqUvKBA==
Message-ID: <535c37f2-df90-ae4b-5b5a-8bf75916ad22@kernel.org>
Date:   Sat, 22 Apr 2023 10:14:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio
 support for preemptible traffic classes
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/23 5:39 AM, Vladimir Oltean wrote:
> This is the iproute2 support for the tc program to make use of the
> kernel features added in commit f7d29571ab0a ("Merge branch
> 'add-kernel-tc-mqprio-and-tc-taprio-support-for-preemptible-traffic-classes'").
> 
> The state of the man pages prior to this work was a bit unsatisfactory,
> so patches 03-07 contain some man page cleanup in tc-taprio(8) and
> tc-mqprio(8).

Thanks for updating the man pages. These should go through main first; I
can sync to main after those are applied and before your set if needed.


> 
> I don't know exactly what's the deal with syncing the main branch
> between iproute2.git and iproute2-next.git. This patch set applies on
> top of today's iproute2-next.git main branch, *merged* with today's
> iproute2.git main branch. If I had formatted it directly on
> iproute2-next, patch 04 would have conflicted with iproute2 change
> ce4068f22db4 ("man: tc-mqprio: extend prio-tc-queue mapping with
> examples"). I would recommend merging the 2 trees before applying this
> series to iproute2-next.

I merge main from time to time; just did that ...

> 
> It may be desirable for patches 01-06 to go to iproute2.git, so I've
> sorted those to be first, in order to make that possible.
> 
> I also dared to sync the kernel headers and provide a commit (07/10) in
> the same form as David Ahern does it. The automated script was:
> 
>   #!/bin/bash
> 
>   UAPI_FOLDER=include/uapi/
>   # Built with "make -j 8 headers_install O=headers"
>   KERNEL_HEADERS=/opt/net-next/headers/usr/include
> 
>   for file in $(find ${UAPI_FOLDER} -type f); do
>   	filename="${file##$UAPI_FOLDER}"
>   	rsync -avr "$KERNEL_HEADERS/$filename" "$file"
>   done

... and updated headers.

Repost the patches as 2 sets with the man page fixes targeted at main
and the new preemptible work for -next.

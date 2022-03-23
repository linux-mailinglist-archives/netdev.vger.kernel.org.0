Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608664E544D
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 15:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiCWOgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiCWOgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:36:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE0D49F9D;
        Wed, 23 Mar 2022 07:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 862ACCE1F54;
        Wed, 23 Mar 2022 14:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F3BC340E8;
        Wed, 23 Mar 2022 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648046104;
        bh=mgIr0EJj1nfhvugLVQSBH+2sRCIPmpVhT59MmZP0smg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GFTobHABrfa11Tf04GwxRArl3nWDFDEwidsEE6ZNM4vzCZMsZj/+cAnVnbqE6XZ2w
         cOlWmeos7/DiPJXLFsNAHCVyVDi9lz0plBv7lDHJLNL+SJ5+2Ut2aOa8u7xwByc5/u
         XIRfq1MaDqSVBT6zorHbvipdxlX/ZdIQoSGXjlafMdYETm5qzpqd5mjaiglpAaV9Z6
         EMeTlzMpPw/yyICML66W8HOt7fIB+/NoV6m2Fnjk383GG5zvTZb6Kfq33bTP42iNSP
         Dx8kZKP2JRC4q7uyiXEdq9i+TBqOmb+kqMxLVfiDBhjcLmYxoSdZd7gDCm27MQx/T3
         nArunKyc1AVwg==
Message-ID: <7288faa9-0bb1-4538-606d-3366a7a02da5@kernel.org>
Date:   Wed, 23 Mar 2022 08:35:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v6 0/4] Add support for IPV6 RLB to balance-alb mode
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/22 6:09 AM, Sun Shouxin wrote:
> This patch is implementing IPV6 RLB for balance-alb mode.
> 
> Sun Shouxin (4):
>   net:ipv6:Add void *data to ndisc_send_na function
>   net:ipv6:Refactor ndisc_send_na to support sending na by slave
>     directly
>   net:ipv6:Export inet6_ifa_finish_destroy and ipv6_get_ifaddr
>   net:bonding:Add support for IPV6 RLB to balance-alb mode
> 
>  drivers/net/bonding/bond_3ad.c     |   2 +-
>  drivers/net/bonding/bond_alb.c     | 612 ++++++++++++++++++++++++++++-
>  drivers/net/bonding/bond_debugfs.c |  14 +
>  drivers/net/bonding/bond_main.c    |   6 +-
>  drivers/net/usb/cdc_mbim.c         |   3 +-
>  include/net/bond_3ad.h             |   2 +-
>  include/net/bond_alb.h             |   7 +
>  include/net/bonding.h              |   6 +-
>  include/net/ipv6_stubs.h           |   3 +-
>  include/net/ndisc.h                |   9 +-
>  net/ipv6/addrconf.c                |   4 +-
>  net/ipv6/ndisc.c                   |  64 ++-
>  12 files changed, 696 insertions(+), 36 deletions(-)
> 
> 
> base-commit: 2af7e566a8616c278e1d7287ce86cd3900bed943

net-next is closed, so this set needs to be delayed until it re-opens.

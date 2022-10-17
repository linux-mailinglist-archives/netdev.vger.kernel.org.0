Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFD5601682
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiJQSlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJQSlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:41:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88F5733FD
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 11:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3081AB80E48
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846CCC433C1;
        Mon, 17 Oct 2022 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666032057;
        bh=D67VPFKgAlhCIEE5WwxNrtzBZntU4nnrhPTgKmG+k40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sskAnIKA0Vww/oEc8RFcCYrf8SNJxpUl5dd1jhCKEwUWSuZBwTYegx1Ojjhc/Ib3J
         LutYOtixAIyiQbVvUH1lcqI7gaxMY2/dmq3Omr1UtzW/U+8QvcdhCVzv7vVE69rDG6
         LTGUxVoDCcZMW0QwAp/Ei0iwRCAAUAWiV7Fwn7M9Km6Xr8lGYn8MRdW+kAk1OL226x
         OIdIJZD7sGgqbjZRneiRZNrx/2xR73hgXwpLfOMvWiGmcT1MrBoSSuChrhuImaqWeM
         PExjrmKF7qbrscc9HmPBcyVDNPeW0YPaf1Np9ziZXxN2LZZIXhXHF97DDbZdy2SaYo
         KEzL7lYZrT3GQ==
Date:   Mon, 17 Oct 2022 11:40:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        johannes@sipsolutions.net, marcelo.leitner@gmail.com
Subject: Re: [RFC PATCH v2 net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221017114056.1adb8d3e@kernel.org>
In-Reply-To: <ac4c37d1-e33b-2cd8-707a-9f6abd382df3@gmail.com>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
        <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
        <20221013082913.0719721e@kernel.org>
        <ac4c37d1-e33b-2cd8-707a-9f6abd382df3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 13:04:35 +0100 Edward Cree wrote:
> On 13/10/2022 16:29, Jakub Kicinski wrote:
> >    (I think splicing the "trunced extack:" with fmt will result
> >     in the format string getting stored in .ro twice?)  
> 
> Yes, it will.  I guess we could splice "%s" with fmt in _both_
>  calls (snprintf and net_warn_ratelimited), pass "" to one and
>  "truncated extack: " to the other.  Then there's only a single
>  string to put in .ro.  Is that worth the complication?

I vote 'yes', with a simple comment next to it, it should be a fairly
obvious trick to a reader of this code.

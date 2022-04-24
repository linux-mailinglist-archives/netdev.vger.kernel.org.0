Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491D450D326
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiDXQNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiDXQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4895B54F99
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 09:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07BFAB80AB3
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F895C385A7;
        Sun, 24 Apr 2022 16:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650816646;
        bh=G9fUkkjUSdBw+xD7bLt329nQj6C966TD800VXHVJMpA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UFEJSnN99OmMOal/RX742b4gHOqSKgcRJ30W7hmaj5eKnwQSmixcQ1+EQGLsMQ9bu
         yvGR24fmGn0kol+rRNbJbm5GrqDg7QTG1xmwpDtkRbBFgjeQAko8x+lQw01XJMy0S7
         OybpcHUKqAjkGlcOaAqp/WPB15LmFyuErbnbDa/oQNonLTr4sAsxSe1mJI49fBeXCe
         JnQqkEJHk9RLIK79cUqCfVp8VhnBrbXnthB16GUrBBP1ENgLHYIdS6PUAfWiJ90uJE
         2QRUquGlu4fYZNNMUsMn6z5QbJOodl25GUNncm0HrJcD+N/FdpSR41UTGjpfrXfnDl
         5wYOo1jkY2SYw==
Message-ID: <cde7f66a-7a23-0d98-d5fe-04ecc8cd5f6b@kernel.org>
Date:   Sun, 24 Apr 2022 10:10:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH iproute2-next 1/3] libbpf: Use bpf_object__load instead of
 bpf_object__load_xattr
Content-Language: en-US
To:     Hangbin Liu <haliu@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        toke@redhat.com, Paul Chaignon <paul@isovalent.com>
References: <20220423152300.16201-1-dsahern@kernel.org>
 <20220423152300.16201-2-dsahern@kernel.org> <YmSuaX7MUIqoNbC3@Laptop-X1>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <YmSuaX7MUIqoNbC3@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/22 7:56 PM, Hangbin Liu wrote:
> Hi David,
> 
> This patch revert c04e45d0 lib/bpf: fix verbose flag when using libbpf,
> Should we set prog->log_level directly before it loaded, like
> bpf_program__set_log_level() does?
> 

that API is new - Dec 2021 so it will not be present across relevant
libbpf versions. Detecting what exists in a libbpf version and adding
compat wrappers needs to be added. That's an undertaking I do not have
time for at the moment. If you or someone else does it would be appreciated.

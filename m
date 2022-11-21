Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF485632DDF
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKUUXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUUXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:23:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2E45654A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E706136A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641CDC433C1;
        Mon, 21 Nov 2022 20:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669062230;
        bh=eIlcdxxc4MGysu44viTWUwFmD9Brj78qjDXhujEcvhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BV/4ZB0a3gFVwPynFZySJmnlkfNW8LAgjnd9O7Wf8xFlW6M75TiiZC3jyI0avZC9o
         OIxIOHWZkoY3ARVLfeN7d02+ELl96vsvZv2Th48dG0zbHYM8zPnV6DT14n4FO/uqZS
         cwQT5/ynYJL9wq44hEYFnFdfLT++5wiC4gvofbZp3vi1h9v3uKzmEiy8q9dlQvC6qq
         uccFfZag0vnYVpXK1cMQaI9GPGXx4vehNKCAgLy2Sjh//XtICu8+WvxIsWGFCq9NxW
         C9s4CNDyU0F+XvxGIHr1EhM0kTff9NCFWZJbZKeZ7yUUiePUUXSZTjOwtPx4V6zBMj
         dkvK0UPcCKwfw==
Date:   Mon, 21 Nov 2022 12:23:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Nikolay Borisov <nikolay.borisov@virtuozzo.com>,
        nhorman@tuxdriver.com, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, den@virtuozzo.com, khorenko@virtuozzo.com
Subject: Re: [PATCH net-next 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Message-ID: <20221121122349.3b217935@kernel.org>
In-Reply-To: <Y3uKNf53EkKMmVwh@nanopsycho>
References: <20221121133132.1837107-1-nikolay.borisov@virtuozzo.com>
        <20221121133132.1837107-2-nikolay.borisov@virtuozzo.com>
        <Y3uKNf53EkKMmVwh@nanopsycho>
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

On Mon, 21 Nov 2022 15:24:53 +0100 Jiri Pirko wrote:
> >+	NET_DM_ATTR_NS,				/* u32 */  
> 
> I believe that we need to add a CI warning for this kind of UAPI
> breakage...

Do you have any ideas on how to code it up in python?
I don't think we let too many such errors thru.

Nikolay, you can't add in the middle of an enum in uAPI because binary
backward compatibility would break. Always add attrs at the end / before
the "cnt" or "max" member.

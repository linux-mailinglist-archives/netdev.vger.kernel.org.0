Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE67640CDC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiLBSNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLBSNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:13:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996E1E61EE
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:13:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F5D562335
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42301C433C1;
        Fri,  2 Dec 2022 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670004812;
        bh=ogidUybG6iOQ5z/Ec6MFOXVR+QQvJqL+GpOXrYVglq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tLLEc1kJuMeIlXtejc3Sxc+wAAQVSCcl4JrYUZqipnfXfkH7zHD63qlz7I7Tc5zKm
         eQfCI1hr0q8CCPlzVcd81wLPlYRCtto3/yJNSy2dGtUZSpzRtyFXy0TJb43zIuR0NV
         Wz0kxFzUkzvsC3pIQY+eLDUyP02xRZ8HhKmybkx67B8HI/Hj3N/7CVkaOoaffJu0Xr
         pkULbScFphFZRkcWDB0lfA+J91NANxcZb8U8O7kKptD+7dIv731AoVjhHTAdc8sDA/
         r6kDjJpubPUXwHfATFFOKRKU/YKY2uxWjBjoM0RTO0a+OyX74PARQDYyqDMVb8ZvRW
         6gWLLEiz16bVQ==
Date:   Fri, 2 Dec 2022 10:13:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com
Subject: Re: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
Message-ID: <20221202101331.178f0bcb@kernel.org>
In-Reply-To: <d2455b9f-78a3-81fe-46d5-c7aa03879294@mojatatu.com>
References: <20221128154456.689326-1-pctammela@mojatatu.com>
        <20221128154456.689326-2-pctammela@mojatatu.com>
        <20221130211643.01d65f46@kernel.org>
        <19b7c2fe-2e56-cc56-86ca-dface0270bad@mojatatu.com>
        <20221201143812.47089fb1@kernel.org>
        <d2455b9f-78a3-81fe-46d5-c7aa03879294@mojatatu.com>
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

On Fri, 2 Dec 2022 09:48:49 -0300 Pedro Tammela wrote:
> > Most definitely not to this reader :) The less macro magic the better.
> > I'm primarily curious about whether the compiler treats this sort of
> > construct the same as a switch.  
> 
> Apparently we can't do a switch case in pointer addresses because the 
> case condition must be constant.

Ack, thanks for checking!

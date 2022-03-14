Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECD74D7D6C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiCNIPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCNIPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E927210FC5;
        Mon, 14 Mar 2022 01:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B1961242;
        Mon, 14 Mar 2022 08:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE4FC340E9;
        Mon, 14 Mar 2022 08:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647245642;
        bh=Uvv06HiF9fvm1TbN8I3GVYyUnjN1QZ0WDKTX+78ozas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LyYRZofebb1+kpbeDD+Az+KCus+iFdqVP2mxR1SFrCtCxI89QanlnUfnmQYEDTE/N
         woV+Jnhee7pYbB3x9I3VXHkYvJWeYsG2LfUmPklqj5MCB1O/8MO2ltYWiOHxwbRPSd
         v09+uf02tkaMsKL56QI6wXDyisFQacVK+wbAbcOs=
Date:   Mon, 14 Mar 2022 09:13:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stephen@networkplumber.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Add check for kvmalloc_array
Message-ID: <Yi75RwIY330W5Fhb@kroah.com>
References: <20220314080514.2501092-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314080514.2501092-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 04:05:14PM +0800, Jiasheng Jiang wrote:
> On Mon, Mar 14, 2022 at 03:33:49PM +0800, Greg KH wrote:
> >> Thanks, I have tested the patch by kernel_patch_verify,
> > 
> > What is that?
> 
> It a Linux kernel patch static verification helper tool.
> Link: https://github.com/nmenon/kernel_patch_verify
> 
> >> and all the tests are passed.
> > 
> > What tests exactly?  How did you fail this allocation?
> 
> The failure of allocation is not included in the tests.
> And as far as I know, there is not any tool that has the
> ability to fail the allocation.

There are tools that do this.

> But I think that for safety, the cost of redundant and harmless
> check is acceptable.
> Also, checking after allocation is a good program pattern.

That's fine, it's how you clean up that is the problem that not everyone
gets correct, which is why it is good to verify that you do not
introduce problems.

greg k-h

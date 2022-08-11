Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0048F58F6B2
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 06:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiHKETC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 00:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHKETB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 00:19:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D12F88DD7;
        Wed, 10 Aug 2022 21:19:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDFB5B81EE7;
        Thu, 11 Aug 2022 04:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DAEC433D6;
        Thu, 11 Aug 2022 04:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660191538;
        bh=qrPkiDYtM2cZyMlQQ5KMoCWV5WW3vJgeT3j0PNech64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u4bJRQUpjahgZvw5OI9qbQRIkB+ZTp7FdAcK/CH/VRTygZaeLBR6gtmfVM8rq0dhJ
         grr82mUjPeN+WKDLSO71LfGnpi/XUYb5+j94AIJFiV52PrglZ8YQhCQW2TPQ4kKsNp
         xNizDk5j6bbhJBV1lPP7EjXH/eQUnTkRJq0wJQPXB3e0l3IFl5dgLHLgbRAnD8AWxR
         BS0OVG0RjmcGZuC7ezHGSXWetLQSsd+pJ3wou8A7nb1/zldKGxPdjy/oRPyL6QcF6l
         gaXbHS03JFBF8gfc20mW5ZAwua5fr5GWgcOmZyVpXe6ZTLQHgecNoJVIQr8dhOK2ld
         sCbx6GCvxQoGg==
Date:   Wed, 10 Aug 2022 21:18:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        ast@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2022-08-10
Message-ID: <20220810211857.51884269@kernel.org>
In-Reply-To: <20220810205357.304ade32@kernel.org>
References: <20220810190624.10748-1-daniel@iogearbox.net>
        <20220810205357.304ade32@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 20:53:57 -0700 Jakub Kicinski wrote:
> On Wed, 10 Aug 2022 21:06:24 +0200 Daniel Borkmann wrote:
> > The following pull-request contains BPF updates for your *net* tree.  
> 
> Could you follow up before we send the PR to Linus if this is legit?
> 
> kernel/bpf/syscall.c:5089:5: warning: no previous prototype for function 'kern_sys_bpf' [-Wmissing-prototypes]
> int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
>     ^
> kernel/bpf/syscall.c:5089:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
> int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)

Looking at the code it seems intentional, even if questionable.
I wish BPF didn't have all these W=1 warnings, I always worry
we'll end up letting an real one in since the CI only compares 
counts and the counts seem to fluctuate.

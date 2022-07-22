Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01D957D82C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 03:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiGVByH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 21:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGVByG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 21:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14B390DB8;
        Thu, 21 Jul 2022 18:54:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F775B826EA;
        Fri, 22 Jul 2022 01:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C85C3411E;
        Fri, 22 Jul 2022 01:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658454843;
        bh=0OqRsAZ/QLesAwX9/j/LcVf4uV5ZMaLztMcapuh0XCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EFbbBo/X5uLrhfgNgsG+c3AzHa7WgGE6Tj0/ulC7BMQjyq/W4LV7ogPTB2/1eba7V
         Kbs4vceVnGf2Lih0elQltmSM8tghEbbpi9hm+E4FVtDEXx9v+51e2cTRi34fzP7yvz
         +LJ6j3ij1oipliuf8x4Ydp53md6v2IZZAYAHmh6zmpk9S3sOYo4uG0V/u2DQn7UMiX
         //cqpsUyW8l8eWsAciO0nE0Gl/OFMZ2QX0fz28VpxAKcrZG3fydAdC7J5lhkha7gKT
         y7nfV9PGCq1i1cuA8GHKe6txCvZx6vxh/iGFcxwtp4ZgpFcAAsG0uEL6QNtEPEQRCx
         RxPxB5u61RMxQ==
Date:   Thu, 21 Jul 2022 18:54:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, ivan@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH net-next 0/2] RTAX_INITRWND should be able to bring the
 rcv_ssthresh above 64KiB
Message-ID: <20220721185401.0bbcd1d0@kernel.org>
In-Reply-To: <20220721151041.1215017-1-marek@cloudflare.com>
References: <20220721151041.1215017-1-marek@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 17:10:39 +0200 Marek Majkowski wrote:
> Among many route options we support initrwnd/RTAX_INITRWND path
> attribute:
> 
>  $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024
> 
> This sets the initial receive window size (in packets). However, it's
> not very useful in practice. For smaller buffers (<128KiB) it can be
> used to bring the initial receive window down, but it's hard to
> imagine when this is useful. The same effect can be achieved with
> TCP_WINDOW_CLAMP / RTAX_WINDOW option.

I think you based this on bpf-next so you should put bpf-next 
in the subject, it doesn't apply to net-next. Either way let's 
wait for Eric to comment.

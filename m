Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716E8584A20
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 05:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbiG2DQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 23:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiG2DQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 23:16:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3857A502;
        Thu, 28 Jul 2022 20:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0BB8CCE260F;
        Fri, 29 Jul 2022 03:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5B0C433C1;
        Fri, 29 Jul 2022 03:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659064557;
        bh=p+eNqUFzAh35JQT7E63CPeJG1c7obYJM/kyRGHxVTEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bnjCJQRkS0624rRxyzVtacd8ESQXXwEk99zxbSzAZ5Qz5hvMtPreW/aIJU1deJrPF
         QWASyw6zXNpwyJXTe+SPF5G077tvBrbDKwy5ZOlJkUNwb+mxIr1b3Pgc2D7W12qKb6
         8BdinEs3mSYW7om2da3fK3QYCHa+AYt86gJQ9NyPVBPVSStUdPO/uaiJUP1OTAiBAe
         8xmTbJ2xBWZ+aXhOVcjpaNQJS5Kk4h8BveREGgSVwAwXeafVD/wRdg9j4kDKJyLYUg
         A/klzNipt1rV6Oe/s9YT1xPCY4JjNZXnYpzKBA+Kbic9mGhlpfSlTAW6ktE/Wz8viv
         5hiTThqZTINQg==
Date:   Thu, 28 Jul 2022 20:15:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li zeming <zeming@nfschina.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/net/act: Remove temporary state variables
Message-ID: <20220728201556.230b9efd@kernel.org>
In-Reply-To: <20220727094146.5990-1-zeming@nfschina.com>
References: <20220727094146.5990-1-zeming@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 17:41:46 +0800 Li zeming wrote:
> The temporary variable ret could be removed and the corresponding state
> can be directly returned.

How many case like this are there in the kernel?
What tool are you using to find this?
We should focus on creating CI tools which can help catch instances of
this pattern in new code before it gets added, rather than cleaning up
old code. It just makes backports harder for hardly any gain.

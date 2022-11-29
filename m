Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1C163C5C5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiK2Q4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbiK2Qzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:55:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289936F0E7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F9CBB816D7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6CCC433D7;
        Tue, 29 Nov 2022 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740627;
        bh=31w2livJyiUmlabvPmyJg0gmkdJhS0O0PRjmIgC4xl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E0JwE0oGNQcNe5dmlwKeXZ1CffAF6AskW+Mpu6pDr3g07x6D+OGDMt8DlVR4Gxjuk
         8wvvTdxTWiqAE6Tervol/61QZ2mxWk1EmOarqHpSn5yg+w1HDEv9zDZG7lv54gzODg
         sUq0eljaSzwdW71zd6UUTJ8DUpk1zz7Chqh8IHHFSjgXmlGahX6H9A8hO+iEsiMbAo
         sLKkjMYED8aX92uDmEffHx6tkMhYBzDjgK9fmfvWVVMdRaEWGuzCmBJ50ZgxGP2SUf
         LP3P8Hsp85ZeLJJgdQ/sO5Ey3DFu0zP8rkdg8nz2xlgAGaEoh1Q6doEFHzBrcrBz7E
         Tcnd6Qajq5VqA==
Date:   Tue, 29 Nov 2022 08:50:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Yuan Can <yuancan@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] udp_tunnel: Add checks for nla_nest_start() in
 __udp_tunnel_nic_dump_write()
Message-ID: <20221129085025.79f9669b@kernel.org>
In-Reply-To: <df265cdb-7af7-a881-63ed-4250951c6576@kernel.org>
References: <20221129013934.55184-1-yuancan@huawei.com>
        <df265cdb-7af7-a881-63ed-4250951c6576@kernel.org>
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

On Mon, 28 Nov 2022 20:09:52 -0700 David Ahern wrote:
> On 11/28/22 6:39 PM, Yuan Can wrote:
> > As the nla_nest_start() may fail with NULL returned, the return value needs
> > to be checked.
> > 
> > Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
> > Signed-off-by: Yuan Can <yuancan@huawei.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
 
Applying to net-next without the Fixes tag, FWIW. The next put will
fail and we'll bail all the same, this patch is pretty much a noop. 
But not the first "fix" like this we go so probably not point fighting
it.

Yuan, please try to find some other error checking to run your bots on,
I doubt any of the nla_nest_start() uses actually need error checking.

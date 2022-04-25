Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8561B50E93A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbiDYTO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244891AbiDYTOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:14:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA0B2ED62
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 12:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7237B81A03
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48354C385A7;
        Mon, 25 Apr 2022 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650913870;
        bh=hpLRmFQ02CDEG2dtTuuuWGKlhs1BAlMBsFQV1jh2y4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LkBap+zb1sf0Q6qEV6fwZBDO2dFEUloXd4KnTo2QJX3zz5EtWRmzZuiGyM07o7uPB
         193icW/R6VYI/jUZQjva0LBhLhrX7EyXEN+bOt4s5b4SmDmQh+wstF7GyEtITYpABw
         oUxTaSICzexarsFtKJ3w0IkKUk83Q4yJowl0KulM59FwDtjqM8/ERGW7U3M/MrZEAJ
         Vb/6kGFbrEdx3eszin+Tb0Koo82wQNjhilPG42HExhmHwu1ekFSQh5cad/q8q8jFf1
         6QND0uSJUVwBOrZMhmqU0N8izuTRXplToy22Y0lIP3vAZ1fQqfcFxxqzVNhWFHn5qq
         theGJnIHEzohw==
Date:   Mon, 25 Apr 2022 12:11:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] wwan_hwsim: Avoid flush_scheduled_work() usage
Message-ID: <20220425121109.614a2f53@kernel.org>
In-Reply-To: <7390d51f-60e2-3cee-5277-b819a55ceabe@I-love.SAKURA.ne.jp>
References: <7390d51f-60e2-3cee-5277-b819a55ceabe@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 12:01:24 +0900 Tetsuo Handa wrote:
> Flushing system-wide workqueues is dangerous and will be forbidden.
> Replace system_wq with local wwan_wq.
> 
> While we are at it, make err_clean_devs: label of wwan_hwsim_init()
> behave like wwan_hwsim_exit(), for it is theoretically possible to call
> wwan_hwsim_debugfs_devcreate_write()/wwan_hwsim_debugfs_devdestroy_write()
> by the moment wwan_hwsim_init_devs() returns.
> 
> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Commit cc271ab86606 ("wwan_hwsim: Avoid flush_scheduled_work() usage")
in net-next now, thanks!

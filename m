Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05425952AE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiHPGkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiHPGja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:39:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99027D790
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 18:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75DFEB815A2
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16B4C433D6;
        Tue, 16 Aug 2022 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660613010;
        bh=TxOfL10dIhIc/JVGP8At+erNBqjka/TE9gsmKUh2aGg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g70xmbFyA14B5K14M5y/HwewCS0g9hJ0MYn+bozKU1tqUB+2UuEZBoD8Eqo6vcgtZ
         b40ZJ6Ig7MyoLi9Ty79bcE+gCLglf2+sLT8Q/LGRdvK0+V0skkQBu7wNWO6r4duWMN
         nyLdEFZO0OEe0CcSf+xg/GM8Zcd55H5sykBxZRFB7SV2wjSUriXfrZtK1l8JJskUJL
         S6apTUIoM3qq+Cv4xpYXpOMwrs8JTRiZ4Gec0yOeop62h6It/QPEeP46LURNew6bD7
         rbI4yH3uTmi6js+eyivnJOkRSJSqglRzEeG4hbxRffjLL01AAopVgGgWgpdXQdSrN5
         k3oOHQnf9e4CQ==
Date:   Mon, 15 Aug 2022 18:23:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes.berg@intel.com,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: genl: fix error path memory leak in policy
 dumping
Message-ID: <20220815182329.6a179069@kernel.org>
In-Reply-To: <20220815182021.48925-1-kuba@kernel.org>
References: <20220815182021.48925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 11:20:21 -0700 Jakub Kicinski wrote:
> If construction of the array of policies fails when recording
> non-first policy we need to unwind.
> 
> Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
> Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

syzbot says still pooped, indeed there's more leaks in
netlink_policy_dump_add_policy() itself. v2 coming...

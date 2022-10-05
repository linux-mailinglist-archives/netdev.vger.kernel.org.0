Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ED45F4D02
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJEAXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJEAXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:23:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83727564CE;
        Tue,  4 Oct 2022 17:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 423C2B81C4A;
        Wed,  5 Oct 2022 00:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D07BC433D6;
        Wed,  5 Oct 2022 00:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664929416;
        bh=mD2LhzbA1iNs/rh93HQfgura4zsxg+NMKqeLVu1NIjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aDBNU+BgzpTyr6yGIvISpEwHfm+2L1vy7GF/sgfKOEbOGU4EaYdOzNCILp27ei3m3
         rW3PP+D4Uc7G9fF/YHMtcs7WjK6f6GptN3+ETHikB9RP09pOfKQ//f38/CrYXPtKb9
         g+b7jBS6jmHHVOlwmEI6IOQ0hL3tC+eAsOGlPISZaDnHiobRmNSylsYTcAW+yH5sQ4
         mgGEnICPC35b+ICJKF/AUMrDrIh+oDAuQjphn2RAu/PvqvHQbhZwsufkuIVtX8b+po
         Kbsd+2iJ8gzqnw2YGIe2zp0XaksS71SREDZhy0d4Zqcx3YJfDUYWE3jLiTW/eQGPo7
         /+dd34UeROEew==
Date:   Tue, 4 Oct 2022 17:23:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        linux-hardening@vger.kernel.org
Subject: Re: [syzbot] upstream boot error: WARNING in netlink_ack
Message-ID: <20221004172334.2cb0233e@kernel.org>
In-Reply-To: <20221004170400.52c97523@kernel.org>
References: <000000000000a793cc05ea313b87@google.com>
        <CACT4Y+a8b-knajrXWs8OnF1ijCansRxEicU=YJz6PRk-JuSKvg@mail.gmail.com>
        <F58E0701-8F53-46FE-8324-4DEA7A806C20@chromium.org>
        <20221004104253.29c1f3c7@kernel.org>
        <202210041600.7C90DF917@keescook>
        <20221004170400.52c97523@kernel.org>
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

On Tue, 4 Oct 2022 17:04:00 -0700 Jakub Kicinski wrote:
> > why does a fixed size mean no memset?  
> 
> Copy and paste, it seems to originate from:
> 
> 0c19b0adb8dd ("netlink: avoid memset of 0 bytes sparse warning")
> 
> Any idea why sparse would not like empty memsets?

Google answers is. Let me test if sparse still wants the workaround.

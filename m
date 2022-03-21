Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63264E3083
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352447AbiCUTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352043AbiCUTKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BAC24F3E;
        Mon, 21 Mar 2022 12:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B230B819B9;
        Mon, 21 Mar 2022 19:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF8CC340E8;
        Mon, 21 Mar 2022 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647889728;
        bh=FjjsA8zqwAJ+IKcKR86hi1XdFe4x8oPOB7PEGC6DMMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aSM8SQRRdrCU+p808ZfQUx2BZqzYvJOPLCXhy0bPxVdT4wdxu7sFv7NyUGDo0MdAI
         MZIh7KFYpnBV0O7+OGUx9OIb9/9/6EKWM+cyvrGNKSTmmcsvPoJRAweLIVbKarwiA8
         wpHS9ev5I2p2mC4pbMBHOs++vV+D4B12+JHnxhWWCWLv1BQxnBTlIWdyhr8+1fhpd3
         ChIfWmjBznWlrpPlteuv+4Wmng7TE2w8xHgvFkwqBZDmnEIqTbrCsG5Zoq4VNcS1N4
         dXu0HY5dx8rGpOXlAzXRD1nx0NscP/DhUQHNZVatpYoZPRIOLXJZ8IBe/ks+XreOLb
         KG9vDFuO5zZ5Q==
Date:   Mon, 21 Mar 2022 12:08:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+fb57d2a7c4678481a495@syzkaller.appspotmail.com>
Cc:     Jason@zx2c4.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Subject: Re: [syzbot] net-next test error: WARNING in __napi_schedule
Message-ID: <20220321120846.4441e49a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0000000000000eaff805da869d5b@google.com>
References: <0000000000000eaff805da869d5b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 16:36:19 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e89600ebeeb1 af_vsock: SOCK_SEQPACKET broken buffer test
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=134d43d5700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ef691629edb94d6a
> dashboard link: https://syzkaller.appspot.com/bug?extid=fb57d2a7c4678481a495
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

#syz fix: net: Revert the softirq will run annotation in ____napi_schedule().

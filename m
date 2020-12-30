Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB802E7592
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 02:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgL3BiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 20:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgL3BiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 20:38:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BE920867;
        Wed, 30 Dec 2020 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609292251;
        bh=Zj+7kvWGhFidy9YRhsyGr5SYm2+ujzEHQdRwB6kn1b8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DODA7CW0dRa25xofNIoZcBPNVfB+QrSeUoUmboId5tMusHc9ySf4G8wZhtEKW7Xge
         QwpUXedVeu+0v5rdwlWeVk7rAARlX5ZXAZhKKlXdq+F2I4+UN1ERCTg+whIGXrM84E
         VBcG4ulG7SM6Tp/eulZZWDcyNR2PgZnivsf7OtH+SyBP4ChJiBHjglozKp6i2AkJis
         hOu5Ue6Uoc40Kz/Tmf7LYPH7I52Gl1ZHltAXujY9q3j0G+9EobeHYX0aU5byVhp7XI
         dodMyLUsaX4UEVb8AAgqc+GTRHF6CnpELPTRX0iAlseoFGTjdLcSazdjJH5GLqSFKu
         BQ5wDSPJAZKYw==
Date:   Tue, 29 Dec 2020 17:37:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+eaaf6c4a6a8cb1869d86@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        keescook@chromium.org, ktkhai@virtuozzo.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pombredanne@nexb.com, stephen@networkplumber.org,
        syzkaller-bugs@googlegroups.com, tom@herbertland.com,
        yoshfuji@linux-ipv6.org
Subject: Re: inconsistent lock state in ila_xlat_nl_cmd_add_mapping
Message-ID: <20201229173730.65f74253@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <000000000000b14d8c05735dcdf8@google.com>
References: <000000000000b14d8c05735dcdf8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Aug 2018 21:40:03 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    78cbac647e61 Merge branch 'ip-faster-in-order-IP-fragments'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14df4828400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9100338df26ab75
> dashboard link: https://syzkaller.appspot.com/bug?extid=eaaf6c4a6a8cb1869d86
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=13069ad2400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+eaaf6c4a6a8cb1869d86@syzkaller.appspotmail.com

#syz invalid

Hard to track down what fixed this, but the lockdep splat is mixing up
locks from two different hashtables, so there was never a real issue
here.

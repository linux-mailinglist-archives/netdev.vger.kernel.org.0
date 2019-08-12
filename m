Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89218A01E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfHLNx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:53:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49748 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfHLNx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:53:59 -0400
Received: from fsav102.sakura.ne.jp (fsav102.sakura.ne.jp [27.133.134.229])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x7CDrKgt043710;
        Mon, 12 Aug 2019 22:53:20 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav102.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav102.sakura.ne.jp);
 Mon, 12 Aug 2019 22:53:20 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav102.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x7CDrJAq043707
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Mon, 12 Aug 2019 22:53:20 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: WARNING in aa_sock_msg_perm
To:     syzbot <syzbot+cda1ac91660a61b51495@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        David Howells <dhowells@redhat.com>
References: <00000000000021eea2058feaaf82@google.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     linux-afs@lists.infradead.org
Message-ID: <7e84e076-7096-028f-b49d-29160aea0831@I-love.SAKURA.ne.jp>
Date:   Mon, 12 Aug 2019 22:53:19 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <00000000000021eea2058feaaf82@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/12 21:30, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    fcc32a21 liquidio: Use pcie_flr() instead of reimplementin..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11233726600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=cda1ac91660a61b51495
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

> ------------[ cut here ]------------
> AppArmor WARN aa_sock_msg_perm: ((!sock)):

This is not AppArmor's bug. LSM modules expect that "struct socket" is not NULL.
For some reason, peer->local->socket became NULL. Thus, suspecting rxrpc's bug.

>  rxrpc_send_keepalive+0x1ff/0x940 net/rxrpc/output.c:656

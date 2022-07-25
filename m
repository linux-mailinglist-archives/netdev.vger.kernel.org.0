Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5FB57FD3C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiGYKPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiGYKP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:15:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572E138BD;
        Mon, 25 Jul 2022 03:15:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 11B61352BB;
        Mon, 25 Jul 2022 10:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1658744125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfwO3eQzRbJ+P4zZizMEALzAzJGxDQ9gk1SkR5gMIlM=;
        b=AY53X++4aTD0nCr7lpNAfNGku2A2xh+4RUvLQry8G+cwTvbN/TW8yz8jzBaPvw69qO4sR3
        uRm+OM9i7waiCQl0qEmegSIgjfOJYyeVX/t6GvX1ffqvPYAx2t8U4yoL37Jq1BzfJYfFcE
        eAadBhkgMLQ2jk3/LGwQxN0zkUFGeiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1658744125;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfwO3eQzRbJ+P4zZizMEALzAzJGxDQ9gk1SkR5gMIlM=;
        b=o0XTcvJA/lPufEvUAQ6IX3VMnLv7FiZ6/eiyqhrbyhoy8ikkByCnqhVs4n35v/RU4zydSD
        oSY2J+jb8Cnc1fBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BD79313A8D;
        Mon, 25 Jul 2022 10:15:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IgmBLTxt3mKPJgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 25 Jul 2022 10:15:24 +0000
Message-ID: <fb9febe5-00a6-61e9-a2d0-40982f9721a3@suse.cz>
Date:   Mon, 25 Jul 2022 12:15:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [syzbot] WARNING in p9_client_destroy
Content-Language: en-US
To:     syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, elver@google.com,
        ericvh@gmail.com, hdanton@sina.com, k.kahurani@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, rientjes@google.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        v9fs-developer@lists.sourceforge.net
References: <000000000000e6917605e48ce2bf@google.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <000000000000e6917605e48ce2bf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/22 15:17, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 7302e91f39a81a9c2efcf4bc5749d18128366945
> Author: Marco Elver <elver@google.com>
> Date:   Fri Jan 14 22:03:58 2022 +0000
> 
>     mm/slab_common: use WARN() if cache still has objects on destroy

Just to state the obvious, bisection pointed to a commit that added the
warning, but the reason for the warning would be that p9 is destroying a
kmem_cache without freeing all the objects there first, and that would be
true even before the commit.

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=142882ce080000
> start commit:   cb71b93c2dc3 Add linux-next specific files for 20220628
> git tree:       linux-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=162882ce080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=122882ce080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
> dashboard link: https://syzkaller.appspot.com/bug?extid=5e28cdb7ebd0f2389ca4
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156f74ee080000
> 
> Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com
> Fixes: 7302e91f39a8 ("mm/slab_common: use WARN() if cache still has objects on destroy")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection


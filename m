Return-Path: <netdev+bounces-152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FFC6F57D9
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA4331C20E55
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24933D516;
	Wed,  3 May 2023 12:23:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1446A46AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:23:40 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6325C5587;
	Wed,  3 May 2023 05:23:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1269222769;
	Wed,  3 May 2023 12:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683116618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1aj1/GqmVdeLgj770nx57dpPk5kBLDi8DCbCRfjzh5A=;
	b=3NSXZIBV+sB8PZpGuqg7j7n8qezGfY59qBYR1exU5COZm9JyT9WUogVvLcs81qYBbfvqTY
	mnX9FTtzTqJpjpLJssAtkgFMC3626NBevjRpjBUsu/GsQRAklTmpZ0tVpjZx/50KtzKew7
	WJAWtn4yVvG1AV2zmBPL7ip1zuxzjEw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683116618;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1aj1/GqmVdeLgj770nx57dpPk5kBLDi8DCbCRfjzh5A=;
	b=GiNeFG3RUj/NEfWs7b+o/rT+gYLe6AH5qkekOLk5kVlW7cm1ufoaBPPhgnK6nVOXCmbvBg
	CJswCYKv5MvQ1ODw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 03F881331F;
	Wed,  3 May 2023 12:23:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id NKzrAEpSUmQ3egAAMHmgww
	(envelope-from <jack@suse.cz>); Wed, 03 May 2023 12:23:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 85A0FA0744; Wed,  3 May 2023 14:23:37 +0200 (CEST)
Date: Wed, 3 May 2023 14:23:37 +0200
From: Jan Kara <jack@suse.cz>
To: syzbot <syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, hch@lst.de, jack@suse.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] [udf?] KASAN: null-ptr-deref Read in filemap_fault
Message-ID: <20230503122337.fxyfchh4ximvnuwn@quack3>
References: <00000000000090900c05fa656913@google.com>
 <0000000000004a34a305fac69bcb@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000004a34a305fac69bcb@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed 03-05-23 02:23:19, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 66dabbb65d673aef40dd17bf62c042be8f6d4a4b
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Tue Mar 7 14:34:10 2023 +0000
> 
>     mm: return an ERR_PTR from __filemap_get_folio
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15220608280000
> start commit:   865fdb08197e Merge tag 'input-for-v6.4-rc0' of git://git.k..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17220608280000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13220608280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d1c8518c09009bad
> dashboard link: https://syzkaller.appspot.com/bug?extid=48011b86c8ea329af1b9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137594c4280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10cfd602280000
> 
> Reported-by: syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com
> Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Actually looking into commit 66dabbb65d67 it seems it has two problems -
one in filemap_fault() where in:

               if (IS_ERR(folio)) {
                        if (fpin)
                                goto out_retry;

we need to clear folio so that we don't try to folio_put() the error
pointer. And another in afs_dir_get_folio() where the changes effectively
make that function return ERR_PTR instead of NULL as well which will then
confuse afs_edit_dir_add() and other callers (which were not updated).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR


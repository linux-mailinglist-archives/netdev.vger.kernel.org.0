Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91A62C10CA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390148AbgKWQhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390139AbgKWQhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 11:37:40 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A61C061A51
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 08:37:38 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 5so9097625plj.8
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 08:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NPDzcaiioinbI0xutHnN4ITCAksvO7VM/A7YfnKL3t8=;
        b=IWpb9+t2hLMs3fQI31fe2Fh2XpE6OdjGahRcNeGWK1DgJW8519oFS2F3XMpFF8Ss+b
         n4hivcJix+7wt7lMfwfQRU23sddw6DmCK5J0ywMiEdvF/tUD+iWYsHWGJeqJRTKoVrUe
         yRBKbdZLCvj55JXALrX8zd66EdyXLdcFn1h6WGpy+dveqIni2Sk4VAjm6X33y9oV5axh
         elmG5Ek7a1hP5S/5Bh/aSH7q7z02o/6gKmT3pQWou8EznyZYsQnL/mcFl4TvS5rGsGyp
         TvEEpVSzA3wp7AyKGqB7bLn2fYjX+q20+hDTOcAM23jti1baTGOqOQ4N7/wrpAyHiE/p
         pqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NPDzcaiioinbI0xutHnN4ITCAksvO7VM/A7YfnKL3t8=;
        b=LOG8WBodhS86YVHfdo0XAUYXIvPQpuHOp80NsIyOMAnlZI9Sani7UnWA4N4jc4uvxw
         d0tLUPgA55A2tHV0L82/SyckRz6G12ekslXZzERIzNYi+8MTwiInQP/lvw4D25gUJtVG
         vV/IWZ8dfmDi2UprcSbAThm6fj5l7KbVMNu9mak47SpYCZ2MtMMocO7atnY1faVd2oPH
         ZRCfOmAgn2NOPG478dVvm+lCPAbVObdQQabrTTh+2xu7J2vat38bFb+lIBx839t7RZQt
         zDYAaR3OpzZhwSNjWn3Dh3f+QsJ5HVIe0HvhfjnH1VbDh5zhBsTbzqWA3flT+jrddJX8
         qtIA==
X-Gm-Message-State: AOAM531LrIhCViG4aJgMlrGMro1llhBNM7np+Ranm+vRl/lbKUsiXEtg
        HDustNHvq29XHj1PQzhY7anCwg==
X-Google-Smtp-Source: ABdhPJx3ImtYlkkbvp/jmFrOIcNG+vTvqV/MgveRUGMO+vUIm16Ij5kjths7BenX7cWWt8ifPFF1QA==
X-Received: by 2002:a17:902:bc8c:b029:d8:efb7:ae74 with SMTP id bb12-20020a170902bc8cb02900d8efb7ae74mr306721plb.10.1606149457725;
        Mon, 23 Nov 2020 08:37:37 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u6sm5647015pjn.56.2020.11.23.08.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 08:37:36 -0800 (PST)
Subject: Re: inconsistent lock state in io_file_data_ref_zero
To:     syzbot <syzbot+1f4ba1e5520762c523c6@syzkaller.appspotmail.com>,
        davem@davemloft.net, io-uring@vger.kernel.org,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000f3332805b4c330c3@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <948d2d3b-5f36-034d-28e6-7490343a5b59@kernel.dk>
Date:   Mon, 23 Nov 2020 09:37:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000f3332805b4c330c3@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 2:55 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    27bba9c5 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11041f1e500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=330f3436df12fd44
> dashboard link: https://syzkaller.appspot.com/bug?extid=1f4ba1e5520762c523c6
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d9b775500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157e4f75500000
> 
> The issue was bisected to:
> 
> commit dcd479e10a0510522a5d88b29b8f79ea3467d501
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Oct 9 12:17:11 2020 +0000
> 
>     mac80211: always wind down STA state

Not sure what is going on with the syzbot bisects recently, they are way
off into the weeds...

Anyway, I think the below should fix it.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 489ec7272b3e..0f2abbff7eec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7194,9 +7181,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	ref_node = data->node;
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7578,7 +7565,7 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->file_data;
 	ctx = data->ctx;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	ref_node->done = true;
 
 	while (!list_empty(&data->ref_list)) {
@@ -7590,7 +7577,7 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->file_put_llist);
 	}
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7713,9 +7700,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	file_data->node = ref_node;
-	spin_lock(&file_data->lock);
+	spin_lock_bh(&file_data->lock);
 	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock(&file_data->lock);
+	spin_unlock_bh(&file_data->lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
 out_fput:
@@ -7872,10 +7859,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		spin_lock(&data->lock);
+		spin_lock_bh(&data->lock);
 		list_add_tail(&ref_node->node, &data->ref_list);
 		data->node = ref_node;
-		spin_unlock(&data->lock);
+		spin_unlock_bh(&data->lock);
 		percpu_ref_get(&ctx->file_data->refs);
 	} else
 		destroy_fixed_file_ref_node(ref_node);


-- 
Jens Axboe


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0E7582A1C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiG0QA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiG0QA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:00:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5941B3E745
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658937624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XNYAzpbrdFeqkLd/QeiydKTf4ZkAUvL844eMUk9c+qI=;
        b=YMQl+9Q6D7Q/wdxyWyzlRh9PVPpZxiQxR7l68lRtGx9VgVQNpAorrIAr1F/vbqM6k5x4eb
        Tb9PE45mhXl3iDE6JxyL7d6iKULK4N2ugDeAlXVJIS6FEQKj8tTq5olFLOTtvooYjwVJnO
        pjhmqpkvDR8T23Pzz+oJ3WKOI5bITX8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-PwZ4nW0tMMyBcYo8tCDBPg-1; Wed, 27 Jul 2022 12:00:20 -0400
X-MC-Unique: PwZ4nW0tMMyBcYo8tCDBPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9FD43C0CD4C;
        Wed, 27 Jul 2022 16:00:19 +0000 (UTC)
Received: from T590 (ovpn-8-32.pek2.redhat.com [10.72.8.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFDB240CF8E2;
        Wed, 27 Jul 2022 16:00:12 +0000 (UTC)
Date:   Thu, 28 Jul 2022 00:00:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     syzbot <syzbot+3ba0493d523d007b3819@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, cgroups@vger.kernel.org, fweisbec@gmail.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org
Subject: Re: [syzbot] INFO: rcu detected stall in net_tx_action
Message-ID: <YuFhB2FaEacNI26/@T590>
References: <00000000000026864605c611cc51@google.com>
 <0000000000004bee3605e4b74106@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000004bee3605e4b74106@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 08:50:09AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 0a9a25ca78437b39e691bcc3dc8240455b803d8d
> Author: Ming Lei <ming.lei@redhat.com>
> Date:   Fri Mar 18 13:01:43 2022 +0000
> 
>     block: let blkcg_gq grab request queue's refcnt
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1004f05a080000
> start commit:   d6765985a42a Revert "be2net: disable bh with spin_lock in ..
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=3ba0493d523d007b3819
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c9edc8300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172463c8300000
> 

The bad commit has been fixed by the following patch:

d578c770c852 block: avoid calling blkg_free() in atomic context



Thanks, 
Ming


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CDA5EDBAC
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiI1LXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiI1LXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:23:42 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772D3DCEA6;
        Wed, 28 Sep 2022 04:23:40 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D110EC022; Wed, 28 Sep 2022 13:23:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664364217; bh=R+tt35RwTcDp8NVFqyIj6r8e594PICPVfST0BDBn7xk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tjAURJkUG3o+n3RG+G2zkCPBfuw65v9S0a7AySU6xqJmFpCWu2vhro9Jpjx9b2urX
         lvZBUko6OF1huj7hLxqAM5OqqgyQwx1SrjNXatZfsqiPlYiL1BQUho608ft8BevLJY
         HJ7RTBA2T565CJU5ihWEOK5uV4XB9SjxmQjTRLtJTCnT8A6nNIDyZwvjgKRzOoEO74
         qU9ynhEl2KZ49SM3hPrYocxX3dCKEIyaMgX3vx6WD984t/ECs5/4bR9TdfAOSKARdc
         vrBpjJyv0m+dAcSonnZ9LMit8CCERuMvmWlTBnhfDSa6GVILNyN+S7F1eKw2wSq/mZ
         pQKF97Jmu5A2Q==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id F011DC009;
        Wed, 28 Sep 2022 13:23:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664364216; bh=R+tt35RwTcDp8NVFqyIj6r8e594PICPVfST0BDBn7xk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKIEJoDTJ7Yc9jBpEtFLr2sp/gEB8RrIEQoj8Lu7A8jxb4E9DzbWsBvtcaFP0UCo9
         y13FjvUHpuzgm1XG9JZmoCene6H6DMzMntMQEUgzT3XWBY+fF2unGl/mciRmc6a+9r
         Exqk4x/OnmD1aAGxYBEGqoBItPVkSvABteTh1c+2FCAKDw4jr3gq5GwCLeMlDt/0VO
         jKkkBToQ1UGz9xVg4EPZnnkFpvitZYmkpNQtu9GsOlb8jAZG4D0KkfDIaxSiXKo0vW
         P0ftQJe6r6qocm5Qhz4DQf4iu6wBtSMvlaE18HVVdb4Cuhh5bUj+ylVhrayIMu8tvq
         YagPFpHIVaKkA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id d4a4fd30;
        Wed, 28 Sep 2022 11:23:29 +0000 (UTC)
Date:   Wed, 28 Sep 2022 20:23:14 +0900
From:   asmadeus@codewreck.org
To:     Leon Romanovsky <leon@kernel.org>
Cc:     syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzQuoqyGsooyDfId@codewreck.org>
References: <00000000000015ac7905e97ebaed@google.com>
 <YzQc2yaDufjp+rHc@unreal>
 <YzQlWq9EOi9jpy46@codewreck.org>
 <YzQmr8LVTmUj9+zB@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YzQmr8LVTmUj9+zB@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky wrote on Wed, Sep 28, 2022 at 01:49:19PM +0300:
> > But I agree I did get that wrong: trans_mod->close() wasn't called if
> > create failed.
> > We do want the idr_for_each_entry() that is in p9_client_destroy so
> > rather than revert the commit (fix a bug, create a new one..) I'd rather
> > split it out in an internal function that takes a 'bool close' or
> > something to not duplicate the rest.
> > (Bit of a nitpick, sure)
> 
> Please do proper unwind without extra variable.
> 
> Proper unwind means that you will call to symmetrical functions in
> destroy as you used in create:
> alloc -> free
> create -> close
> e.t.c
> 
> When you use some global function like you did, there is huge chance
> to see unwind bugs.

No.

Duplicating complicated cleanup code leads to leaks like we used to
have; that destroy function already frees up things in the right order.

And, well, frankly 9p is a mess anyway; the problem here is that
trans_mod->create() doesn't leave any trace we can rely on in a common
cleanup function, but the original "proper unwind" missed:
 - p9_fid_destroy/tags cleanup for anything in the cache (because, yes,
apparently fuzzers managed to use the client before it's fully
initialized. I don't want to know.)
 - fcall cache destory

I'm not duplicating all this mess. This is the only place that can call
destroy before trans_mod create has been called, I wish we'd have a
pattern like "clnt->trans = clnt->trans_mod->create()" so we could just
check if trans is null, but a destroy parameter will do.

... Well, I guess it's not like there are out of tree trans, I could
just change create() to do that if I had infinite time...

--
Dominique



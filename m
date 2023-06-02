Return-Path: <netdev+bounces-7390-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD5B71FFD7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613BC1C20A69
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0788F111A9;
	Fri,  2 Jun 2023 10:58:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB37A8466
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:58:04 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A78C0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 03:58:03 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33bf12b5fb5so78645ab.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 03:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685703482; x=1688295482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+R6ScZ/Un56g/QDJNYbFzDtHds5teBRsW9jLy+uI24=;
        b=1AXjAvflwc/uJbp/lBd/8rKNARlBO3y4OaLnZbCJui3lEWgw9Tsp7i5C95x9TRdfkH
         h68IwoM/XROIOZ4oSQuK30RHZziBey2MmTLrZjK1BvGsb4b5XeRPTty3uA2KSstG3CRT
         uIpm3VoLAi1RWtqrO18bXgi/GP2pYH0Gldr5t/hhQN1zBEVVaN2UCjm9gRVDPoyLOsbC
         OR2ub1aoyFpyTjKqnNmyht1plhwqk0BYS94bu+MbfL18CyzI5uv3zV/Ij3RDrjyCjxMs
         cXIkApmTJMZUzCnnp5QhujvQ+jknP0LfPqUqX1tHeaSvvDfM56oeG0hyCydQqUimUUUG
         OgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685703482; x=1688295482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O+R6ScZ/Un56g/QDJNYbFzDtHds5teBRsW9jLy+uI24=;
        b=RtgUY8YpBYfjhZz4Vd48nxRbEW3bcnXRyAjVNNsjjh4ohA6+sZBsITdLaTHtnAPfZ1
         cRCKKO5t/vvJdGWhl34G8USyB36wVphMbldsokIqjZhrDOMdXQA7NUg61SvLl9JZKSHf
         Wt+PZuPRD/SNcxpQHbxzn4wbq0uD6cMS0GX+w2r3LDGSxax5rmMpFoVTQgWRd6T91aAD
         BnTuYZDuO93UBTDL3AEWl6k5AO+juGSc5pRsXaYdNkrraeO5YAfNMEFhqhGyIaUIMdva
         ucL2jjmFPkM9Kvj2TBTk/8/Tyz7JzKktydSm+zSO3+UJ2+wGwC2p4lGqUIDQqHY/fkhm
         94Iw==
X-Gm-Message-State: AC+VfDyYhqSsWx4ONH1tijpnjWLqtVfeImg3BSnnQ+O52bg/pqxvzlBf
	rrqPCF9E+h/e3Y3o2gQUDMKA6/0uHzaZnAUx6Rnfhg==
X-Google-Smtp-Source: ACHHUZ4XzLlFhxj34TA+VRTk3cwSLwKaDIj9MmihQ/k+sNQL3X+68B23BasAbzjIInkv8Zd9eGTJbq0bcKczNhcOwgU=
X-Received: by 2002:a05:6e02:1785:b0:33a:e716:a766 with SMTP id
 y5-20020a056e02178500b0033ae716a766mr206692ilu.20.1685703482599; Fri, 02 Jun
 2023 03:58:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000015ac7905e97ebaed@google.com> <00000000000017cc6205fd233643@google.com>
In-Reply-To: <00000000000017cc6205fd233643@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 2 Jun 2023 12:57:51 +0200
Message-ID: <CANp29Y7kwQnezWxMZSQ=rFAky-Jn4SmMVqUh77tssnFYOUc=Kg@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
To: syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>
Cc: asmadeus@codewreck.org, dan.carpenter@oracle.com, davem@davemloft.net, 
	edumazet@google.com, ericvh@gmail.com, kuba@kernel.org, leon@kernel.org, 
	linux-kernel@vger.kernel.org, linux_oss@crudebyte.com, lucho@ionkov.net, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Looks like the guilty patch was just edited -next.

As there's no fixing commit, let's just invalidate the bug:

#syz invalid

On Fri, Jun 2, 2023 at 12:42=E2=80=AFPM syzbot
<syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com> wrote:
>
> This bug is marked as fixed by commit:
> 9p: client_create/destroy: only call trans_mod->close after create
>
> But I can't find it in the tested trees[1] for more than 90 days.
> Is it a correct commit? Please update it by replying:
>
> #syz fix: exact-commit-title
>
> Until then the bug is still considered open and new crashes with
> the same signature are ignored.
>
> Kernel: Linux
> Dashboard link: https://syzkaller.appspot.com/bug?extid=3D67d13108d855f45=
1cafc
>
> ---
> [1] I expect the commit to be present in:
>
> 1. for-kernelci branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
>
> 2. master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
>
> 3. master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
>
> 4. main branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>
> The full list of 10 trees can be found at
> https://syzkaller.appspot.com/upstream/repos
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/00000000000017cc6205fd233643%40google.com.


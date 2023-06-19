Return-Path: <netdev+bounces-11831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE15734B90
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 323B8280F72
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 06:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC67D3C0C;
	Mon, 19 Jun 2023 06:10:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE49623D9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 06:10:34 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A2AB1
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 23:10:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f85fa03cd9so3028e87.1
        for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 23:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687155031; x=1689747031;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+l56EVhv3DJvNU1IQjzDjseQEvnEEKyVbt3cN52claY=;
        b=F/kNBWEEgaE+8lZUPTIARp5HRaAoZ3OJ/XgML6vdgc6EtwY5p58wPd7kV++KSKFm4b
         OyFBJALpf5kDPATAbF5lTZpwdyu8JFxTuRi+4mcLd7Guw1jwIhL298AzYLOSzwyjpcFs
         diNAyNdCsjpLeq6GebJUxF9gkklqRHhSUKMHppwtT677LSlbWJNIV/RdCVO8WNFa+K36
         OgZIXUfm9t/cUUrLLTNJVyCLnRJeUoJ+PQMpUk/s6c2YsiD1uPs7ajY4/f44OtoctmS2
         w1T49dUAe0bYDleIE21DH/ZQZYp4NMlzFH7d4LkOKrbpxy5b2bL//xP4GGVLpTB7e7dF
         p7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687155031; x=1689747031;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+l56EVhv3DJvNU1IQjzDjseQEvnEEKyVbt3cN52claY=;
        b=aiSHQyWzS9YNMAHxf70rtDAs6xlTrteBejgy3VRnM5OFzaaz7jh4GkZkkmg+ZI/YZ5
         m4s+d1NGYSysA/EFanUhWfdTxaVuMWw9GA6b0Hef2b1Xezd/+CIzvI3HRE1DRo5UfBIh
         i57uuqWKsumPrbmK2CJ/W+6TJlwyRSWUmKhTRCWK5WnroqyrxxDFGZJnyA9k016zBu2F
         Nh9vVFo36LRupz/Tje3Jp/pqz8dTiaxItWoK2kcRnavyeSqo0e3rD6oediDP0x0bCow1
         c3ZZGXqtFwD2nIvfkbkmythv9CNZKbu+5qtjnmf0a0iFlgK4bPQQqa1zkXe6awFg3WJB
         6JLA==
X-Gm-Message-State: AC+VfDyXVLpyRuancW3xBXea/+yMMk4Avi7/9JyA7Q4AGS+NkahIMIV2
	9Jh+eK9au7nHlRLSwUbxBFg3BJveQL0Nkl1UqoamDg==
X-Google-Smtp-Source: ACHHUZ5YZyM2139hV/S/LS2+fvOQj0z9kDkZezC1c+rH06UyGBkfRjikrsYcNhvom7a/Prxm0KpMhNj4eVR2w8dGe7o=
X-Received: by 2002:ac2:5450:0:b0:4f2:7840:e534 with SMTP id
 d16-20020ac25450000000b004f27840e534mr267987lfn.0.1687155031253; Sun, 18 Jun
 2023 23:10:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000098289005dc17b71b@google.com> <00000000000051087405fe4092cc@google.com>
In-Reply-To: <00000000000051087405fe4092cc@google.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 19 Jun 2023 08:10:19 +0200
Message-ID: <CACT4Y+ZEL5FKx+R7poFFE_v2Di=qFRfv7GNnEoa9f9Y4r6ZK=w@mail.gmail.com>
Subject: Re: [syzbot] [bluetooth?] possible deadlock in sco_conn_del
To: syzbot <syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, edumazet@google.com, fgheet255t@gmail.com, 
	hdanton@sina.com, johan.hedberg@gmail.com, josephsih@chromium.org, 
	kuba@kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lrh2000@pku.edu.cn, luiz.dentz@gmail.com, 
	luiz.von.dentz@intel.com, marcel@holtmann.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, yinghsu@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 16 Jun 2023 at 17:09, syzbot
<syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit a2ac591cb4d83e1f2d4b4adb3c14b2c79764650a
> Author: Ruihan Li <lrh2000@pku.edu.cn>
> Date:   Wed May 3 13:39:36 2023 +0000
>
>     Bluetooth: Fix UAF in hci_conn_hash_flush again
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13755717280000
> start commit:   e4cf7c25bae5 Merge tag 'kbuild-fixes-v6.2' of git://git.ke..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=555d27e379d75ff1
> dashboard link: https://syzkaller.appspot.com/bug?extid=b825d87fe2d043e3e652
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10052058480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1190687c480000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: Bluetooth: Fix UAF in hci_conn_hash_flush again
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable:

#syz fix: Bluetooth: Fix UAF in hci_conn_hash_flush again


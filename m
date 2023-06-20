Return-Path: <netdev+bounces-12154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8B9736763
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B78E281110
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7474BC2CA;
	Tue, 20 Jun 2023 09:13:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A40C8F0
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 09:13:52 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15581BCA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:13:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51bcf75c4acso1222a12.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687252406; x=1689844406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gn6F1r4JetejXjMhljN018Vg+0Oo2AizIn4uwEH2p64=;
        b=NDqM+rm9D5qpt3J5Ss4X0ynUh/cA9LO6J8buwFEXXRWBW90GkOIJMZqS+4bQh++Kz3
         +DjF3NK5zPNFE6wjn/Ox7SWSBr3KAFvLdRwhDMs8VB3mWy/+gbpyRSKrwHEQ2LM4nxtO
         sdFATplquBv5MFYQcRu9Sz1RknwGTfB55BiB5UHF817kijlqJGi7U71alXhXjAQOREnb
         DhYo5FHEOilCY+LFqGSIG9tIHu4cAe7qYRvXsCvrACsbpdcx54zu1OF1j1et6HBCvoW0
         jVugB66kbzyOKemzdMUrpKfrWZjV1K6etP8DxzQI5HnKHruMKWvqL1Xnk/dgyGFAdglf
         hBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687252406; x=1689844406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gn6F1r4JetejXjMhljN018Vg+0Oo2AizIn4uwEH2p64=;
        b=KE0zQyFHQaUwBI1E4w6vionFGfAZ08CDjGCxVA9zDEAzhDxn7D6X3/W5wO6RbPohv6
         j3tGfWwZMTp88+SnCsrEgsKknebGxJuHVZq83Dwvle2+8yY2pL36kCsxghebEurc/qAI
         bZCPEFN4VAzog5bvYZTMGUAYM1QeGd1nhrmxEoDcXHEgo43SOjv5+rs7kxr114N49UQ7
         xKJAynyUkPO1u83siCvbR4yeyXRbfnIGmmgow3aKbuBlumfF4LXMI/FKGMBUnPU9niaI
         DlFLLAkzmN5ahP13U605AHjpoaRh4n2ELGjb/SCZV+FQQ1X1aau5Wo+2ODmoEb1Hcoj0
         77Fw==
X-Gm-Message-State: AC+VfDwMMXNZw25ggoxcHCzYbNx96stz1d5aR/7I9DZ8oz2k420z8Hnm
	x9AsuPQwM5FIUcEuA3QUkG9cq8WZu7InyWeO69IxNw==
X-Google-Smtp-Source: ACHHUZ7wa2QfFHSoh4ffltU5YMF6szFm+oz6f5YhUdVzPKlzXndLS78AruSCSvPYPbwzDDAyuWfXQR5K3SMnPhvv/60=
X-Received: by 2002:a50:c054:0:b0:514:92e4:ab9f with SMTP id
 u20-20020a50c054000000b0051492e4ab9fmr298095edd.7.1687252406029; Tue, 20 Jun
 2023 02:13:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000001f31eb056ea92fcb@google.com> <00000000000097ad8105fe89f0a9@google.com>
In-Reply-To: <00000000000097ad8105fe89f0a9@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 20 Jun 2023 11:13:14 +0200
Message-ID: <CANp29Y4_pqfAvKJMi5X+vcsa+UXPR99i0U8OkreoHwnQMnL2ag@mail.gmail.com>
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in xfrm_state_find
To: syzbot <syzbot+131cd4c6d21724b99a26@syzkaller.appspotmail.com>
Cc: anant.thazhemadam@gmail.com, davem@davemloft.net, dvyukov@google.com, 
	edumazet@google.com, glider@google.com, herbert@gondor.apana.org.au, 
	icytxw@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, steffen.klassert@secunet.com, 
	syzkaller-bugs@googlegroups.com, tobias@strongswan.org, 
	tonymarislogistics@yandex.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 8:41=E2=80=AFAM syzbot
<syzbot+131cd4c6d21724b99a26@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 3d776e31c841ba2f69895d2255a49320bec7cea6
> Author: Tobias Brunner <tobias@strongswan.org>
> Date:   Tue May 9 08:59:58 2023 +0000
>
>     xfrm: Reject optional tunnel/BEET mode templates in outbound policies
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13eeaa4b28=
0000
> start commit:   e4cf7c25bae5 Merge tag 'kbuild-fixes-v6.2' of git://git.k=
e..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D2651619a26b4d=
687
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D131cd4c6d21724b=
99a26
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1140605c480=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D14c9271848000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:
>
> #syz fix: xfrm: Reject optional tunnel/BEET mode templates in outbound po=
licies

Looks related.

#syz fix: xfrm: Reject optional tunnel/BEET mode templates in outbound poli=
cies

>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/00000000000097ad8105fe89f0a9%40google.com.


Return-Path: <netdev+bounces-12116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 741A47363B3
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CCFD280F7F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC09F187C;
	Tue, 20 Jun 2023 06:41:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB481119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:41:25 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE9AE7E
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:41:24 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-778d823038bso378222239f.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687243284; x=1689835284;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cgq4aymOJ0VwVRpx8ThomLoDAuRp6iIasCSJOBre16I=;
        b=isdQwxTBMQthgXYgKtK9e1HPRq4n7+vofbGElqFO6T8DAX8mxUmoumMztKl6COll7r
         C82U6EjKg7UhhfVMDRXmqilsPkggZj40WxetVQPmsm4J9ggVDMGyYdvTdQP7mwPT29xI
         oNjKDimc99SHGVBrEuXPbN1CsZ7pVq16xYnmvB0NzyymkxU2WU3LnM2r3yU6q49STAsr
         GjxZRGUQqL8IBYnhMIrMR/8GQj0lX6Z2K6a6+OfsdBovLccfbhjwsWSvg1qFtCUjr7wr
         0k65kT1K7UrRpKjTPP8kqYDMBrPTY48HrFfqLDDucuFH3IE+rB3h2VASSTAYduoF1hPB
         1xXA==
X-Gm-Message-State: AC+VfDz4PoHNhQ9Ud6oGtyJXebtAHiTbUI5QdBPeVv6EE/uK50slTaWO
	ahOcTcTjjIv/C5znQSIVbeMr3EpXtgh/hfha9/jOkx0H0329
X-Google-Smtp-Source: ACHHUZ6Orfc4iKNbp+A2S0qCgFR5kPjpvb2tLd5+FjEGOtDUON6Tmp5NyAFxOjuWLDW29xLn5EiVwxyoEKkYMr9BA4Vpi8NwG8Eb
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:110c:b0:423:f81:a7b9 with SMTP id
 n12-20020a056638110c00b004230f81a7b9mr3529983jal.2.1687243283998; Mon, 19 Jun
 2023 23:41:23 -0700 (PDT)
Date: Mon, 19 Jun 2023 23:41:23 -0700
In-Reply-To: <0000000000001f31eb056ea92fcb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097ad8105fe89f0a9@google.com>
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in xfrm_state_find
From: syzbot <syzbot+131cd4c6d21724b99a26@syzkaller.appspotmail.com>
To: anant.thazhemadam@gmail.com, davem@davemloft.net, dvyukov@google.com, 
	edumazet@google.com, glider@google.com, herbert@gondor.apana.org.au, 
	icytxw@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, steffen.klassert@secunet.com, 
	syzkaller-bugs@googlegroups.com, tobias@strongswan.org, 
	tonymarislogistics@yandex.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot suspects this issue was fixed by commit:

commit 3d776e31c841ba2f69895d2255a49320bec7cea6
Author: Tobias Brunner <tobias@strongswan.org>
Date:   Tue May 9 08:59:58 2023 +0000

    xfrm: Reject optional tunnel/BEET mode templates in outbound policies

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13eeaa4b280000
start commit:   e4cf7c25bae5 Merge tag 'kbuild-fixes-v6.2' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=2651619a26b4d687
dashboard link: https://syzkaller.appspot.com/bug?extid=131cd4c6d21724b99a26
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1140605c480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c92718480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfrm: Reject optional tunnel/BEET mode templates in outbound policies

For information about bisection process see: https://goo.gl/tpsmEJ#bisection


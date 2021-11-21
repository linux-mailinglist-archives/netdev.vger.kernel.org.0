Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4BA4584A8
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 17:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbhKUQ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 11:26:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238294AbhKUQ0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 11:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637511813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5o6/wBGbGY6DcbOKW8sJZyFNOEtnCAysm1b68CJVM+g=;
        b=f/eRZKAZxiYr1bJyNUD6VP71vaIeslR83uXJaYAL8ZO5u/adAvn3HMZDe9v/dH1v5eW/Kj
        i9cC0C7ZMz5HteVfceDbmUIgBIPaIBLughU7YYJ/0cZbWiFrBTCOxY0izitnj5P5YfOZgD
        FeDoVj+GOkiikG6r6KFSHmaYHQuDnaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-4J9HxJ_TPf2uHCKYncaYYw-1; Sun, 21 Nov 2021 11:23:29 -0500
X-MC-Unique: 4J9HxJ_TPf2uHCKYncaYYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAF0D18125C0;
        Sun, 21 Nov 2021 16:23:24 +0000 (UTC)
Received: from [10.22.8.49] (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5B4E60C5F;
        Sun, 21 Nov 2021 16:23:18 +0000 (UTC)
Message-ID: <97cf8c1f-2a1d-d505-9216-37a3da0fc7f6@redhat.com>
Date:   Sun, 21 Nov 2021 11:22:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] WARNING in cgroup_finalize_control
Content-Language: en-US
To:     syzbot <syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        lizefan.x@bytedance.com, lizefan@huawei.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nhorman@tuxdriver.com,
        pablo@netfilter.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org,
        vyasevich@gmail.com, yhs@fb.com
References: <000000000000d6442705d143337a@google.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <000000000000d6442705d143337a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: cgroup: Make rebind_subsystems() disable v2 controllers all at once


On 11/20/21 21:24, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
>
> commit 7ee285395b211cad474b2b989db52666e0430daf
> Author: Waiman Long <longman@redhat.com>
> Date:   Sat Sep 18 22:53:08 2021 +0000
>
>      cgroup: Make rebind_subsystems() disable v2 controllers all at once
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12232c06b00000
> start commit:   442489c21923 Merge tag 'timers-core-2020-08-04' of git://g..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b3f0df8558780a7d
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c08aaa363ca5784c9e9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14148c62900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: cgroup: Make rebind_subsystems() disable v2 controllers all at once
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>


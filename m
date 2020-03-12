Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0150F1838AB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCLS2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:28:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46198 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCLS2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:28:32 -0400
Received: by mail-qk1-f196.google.com with SMTP id f28so7891523qkk.13;
        Thu, 12 Mar 2020 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z1+jrFk0l780LY82KtgQMlOjuOPnOSNUeBpKHT6Qy6g=;
        b=Im3J3CT7QT/G7DEOXBPU5qa5NpzXZfgFk285tuuYBMicpySswnkSvESZnO6jErqFRd
         UPjDpp+0r/vIODgW1k2ShKCiqBy9MmTZB95AFcHg6b7GeSpKBLUrNugoVoATGkaO79DP
         mcRtqwQ/zX3X63/A+7p6exSokHYdR7eIJBUgv5B5sY+P2DtU9pohuGZNPHsQfo0VFSI2
         VxQkQ/6aIBCgeOjZES4EHfdnoV985yMvsQIIreKQVnp8LIh6qsdqDWBCyvkBNnEKbegw
         eLunF7LsF0q/MWSdI3ei6mjKA8959FeSB1VKEpCNXBnaDb99LSD6iiIueYU9p8geMzQv
         814Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Z1+jrFk0l780LY82KtgQMlOjuOPnOSNUeBpKHT6Qy6g=;
        b=I8ZDFnRMX4pvkgU2j0u0yY/djLRsHaPgEUY9wJNY4owkPY555l7HuYl3/q2Y9egQVO
         k8YiEj4CC0vC55Vji9SY1XbZc7J/OL9Iv+QT6BxMbHVXNFqc2ce9U0ViWHLOXFlzaxPP
         M+6r2cR457B/quC8+6wqWCxjBjkK43ZP1872rJuvehmqy+urzd2oIRDz3LU0cmTVDIXH
         TeSJRV7x2vj1IjPKDAKNjb5SgY4TlcuVwqtqwmlGaRqAeBTkxqAFV44L9zTK3sjWGkMq
         gCy4xpnOqjlYJYOCWP23JPNOoaA/X7mayP5ca0X0j7IPXg7bz8au34RN1w8iPClQnojl
         794w==
X-Gm-Message-State: ANhLgQ3Xp8s1GHOhRqkUNmUwrspEKU0pHJQqMLwkI20oP+2ydtW5vSb/
        a8LgbCy0AlzPugVi/mbIbW4=
X-Google-Smtp-Source: ADFU+vt9JCwr3OZM0QDXDy3zEeWocBIU5GDRQ52/xx5BmZffX9syssLvIR6XyxNZEWqjxRiPw4/j+w==
X-Received: by 2002:a37:b146:: with SMTP id a67mr1341985qkf.473.1584037710282;
        Thu, 12 Mar 2020 11:28:30 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fec8])
        by smtp.gmail.com with ESMTPSA id h5sm11049665qkc.118.2020.03.12.11.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:28:29 -0700 (PDT)
Date:   Thu, 12 Mar 2020 14:28:26 -0400
From:   Tejun Heo <tj@kernel.org>
To:     almasrymina@google.com,
        syzbot <syzbot+cac0c4e204952cf449b1@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: KASAN: slab-out-of-bounds Read in cgroup_file_notify
Message-ID: <20200312182826.GG79873@mtj.duckdns.org>
References: <00000000000041c6c205a08225dc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000041c6c205a08225dc@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 08:55:14AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    c99b17ac Add linux-next specific files for 20200225
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1610d70de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6b7ebe4bd0931c45
> dashboard link: https://syzkaller.appspot.com/bug?extid=cac0c4e204952cf449b1
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1242e1fde00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1110d70de00000
> 
> The bug was bisected to:
> 
> commit 6863de00e5400b534cd4e3869ffbc8f94da41dfc
> Author: Mina Almasry <almasrymina@google.com>
> Date:   Thu Feb 20 03:55:30 2020 +0000
> 
>     hugetlb_cgroup: add accounting for shared mappings

Mina, can you please take a look at this?

Thanks.

-- 
tejun

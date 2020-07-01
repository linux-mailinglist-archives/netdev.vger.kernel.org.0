Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF712115CD
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGAWXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:23:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:39652 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgGAWXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:23:12 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jql8H-0004G6-Ql; Thu, 02 Jul 2020 00:23:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jql8H-000NNc-L5; Thu, 02 Jul 2020 00:23:09 +0200
Subject: Re: [PATCH bpf-next] tools/bpftool: turn off -Wnested-externs warning
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200701212816.2072340-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <73e6534d-dc3c-7ecf-f10f-218707c6bb2a@iogearbox.net>
Date:   Thu, 2 Jul 2020 00:23:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200701212816.2072340-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25860/Wed Jul  1 15:40:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/20 11:28 PM, Andrii Nakryiko wrote:
> Turn off -Wnested-externs to avoid annoying warnings in BUILD_BUG_ON macro when
> compiling bpftool:
> 
> In file included from /data/users/andriin/linux/tools/include/linux/build_bug.h:5,
>                   from /data/users/andriin/linux/tools/include/linux/kernel.h:8,
>                   from /data/users/andriin/linux/kernel/bpf/disasm.h:10,
>                   from /data/users/andriin/linux/kernel/bpf/disasm.c:8:
> /data/users/andriin/linux/kernel/bpf/disasm.c: In function ‘__func_get_name’:
> /data/users/andriin/linux/tools/include/linux/compiler.h:37:38: warning: nested extern declaration of ‘__compiletime_assert_0’ [-Wnested-externs]
>    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                        ^~~~~~~~~~~~~~~~~~~~~
> /data/users/andriin/linux/tools/include/linux/compiler.h:16:15: note: in definition of macro ‘__compiletime_assert’
>     extern void prefix ## suffix(void) __compiletime_error(msg); \
>                 ^~~~~~
> /data/users/andriin/linux/tools/include/linux/compiler.h:37:2: note: in expansion of macro ‘_compiletime_assert’
>    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>    ^~~~~~~~~~~~~~~~~~~
> /data/users/andriin/linux/tools/include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
>   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                       ^~~~~~~~~~~~~~~~~~
> /data/users/andriin/linux/tools/include/linux/build_bug.h:50:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
>    BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>    ^~~~~~~~~~~~~~~~
> /data/users/andriin/linux/kernel/bpf/disasm.c:20:2: note: in expansion of macro ‘BUILD_BUG_ON’
>    BUILD_BUG_ON(ARRAY_SIZE(func_id_str) != __BPF_FUNC_MAX_ID);
>    ^~~~~~~~~~~~
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Lgtm, thanks for fixing, applied!

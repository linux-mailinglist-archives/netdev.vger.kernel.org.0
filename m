Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93A25319
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfEUO4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:56:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:52614 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbfEUO4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:56:37 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT6Bv-0002I1-KH; Tue, 21 May 2019 16:56:35 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT6Bv-000M6d-Cs; Tue, 21 May 2019 16:56:35 +0200
Subject: Re: [PATCH bpf] samples/bpf: suppress compiler warning
To:     Matteo Croce <mcroce@redhat.com>, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
References: <20190520214938.16889-1-mcroce@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f874efcb-f2a2-1d5f-7c43-cebdb828e465@iogearbox.net>
Date:   Tue, 21 May 2019 16:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190520214938.16889-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/20/2019 11:49 PM, Matteo Croce wrote:
> GCC 9 fails to calculate the size of local constant strings and produces a
> false positive:
> 
> samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_uprobe’:
> samples/bpf/task_fd_query_user.c:242:67: warning: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size 215 [-Wformat-truncation=]
>   242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
>       |                                                                   ^~
>   243 |    event_type, event_alias);
>       |                ~~~~~~~~~~~
> samples/bpf/task_fd_query_user.c:242:2: note: ‘snprintf’ output between 45 and 300 bytes into a destination of size 256
>   242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   243 |    event_type, event_alias);
>       |    ~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Workaround this by lowering the buffer size to a reasonable value.
> Related GCC Bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83431
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied, thanks!

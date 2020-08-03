Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5EB23A836
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgHCOSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:18:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:39824 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgHCOSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:18:34 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2bIP-00074O-0w; Mon, 03 Aug 2020 16:18:33 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2bIO-000GtZ-7h; Mon, 03 Aug 2020 16:18:32 +0200
Subject: Re: [PATCH bpf-next] tools build: propagate build failures from
 tools/build/Makefile.build
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20200731024244.872574-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e2189f4d-8372-6140-0d7d-d400b868e3f1@iogearbox.net>
Date:   Mon, 3 Aug 2020 16:18:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200731024244.872574-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25892/Sun Aug  2 17:01:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 4:42 AM, Andrii Nakryiko wrote:
> The '&&' command seems to have a bad effect when $(cmd_$(1)) exits with
> non-zero effect: the command failure is masked (despite `set -e`) and all but
> the first command of $(dep-cmd) is executed (successfully, as they are mostly
> printfs), thus overall returning 0 in the end.
> 
> This means in practice that despite compilation errors, tools's build Makefile
> will return success. We see this very reliably with libbpf's Makefile, which
> doesn't get compilation error propagated properly. This in turns causes issues
> with selftests build, as well as bpftool and other projects that rely on
> building libbpf.
> 
> The fix is simple: don't use &&. Given `set -e`, we don't need to chain
> commands with &&. The shell will exit on first failure, giving desired
> behavior and propagating error properly.
> 
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Fixes: 275e2d95591e ("tools build: Move dependency copy into function")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!

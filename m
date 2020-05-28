Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC41E6423
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391208AbgE1Oje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:39:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:35266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391177AbgE1Ojb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:39:31 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jeJgv-0008Kh-Gq; Thu, 28 May 2020 16:39:29 +0200
Date:   Thu, 28 May 2020 16:39:28 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Anton Protopopov <a.s.protopopov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf 0/5] bpf: fix map permissions check and cleanup code
 around
Message-ID: <20200528143928.GA27756@pc-9.home>
References: <20200527185700.14658-1-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527185700.14658-1-a.s.protopopov@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25826/Thu May 28 14:33:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 06:56:55PM +0000, Anton Protopopov wrote:
> This series fixes a bug in the map_lookup_and_delete_elem() function which
> should check for the FMODE_CAN_READ bit, because it returns data to user space.
> The rest of commits fix some typos and comment in selftests and extend the
> test_map_wronly test to cover the new check for the BPF_MAP_TYPE_STACK and
> BPF_MAP_TYPE_QUEUE map types.
> 
> Anton Protopopov (5):
>   selftests/bpf: fix a typo in test_maps
>   selftests/bpf: cleanup some file descriptors in test_maps
>   selftests/bpf: cleanup comments in test_maps
>   bpf: fix map permissions check
>   selftests/bpf: add tests for write-only stacks/queues
> 
>  kernel/bpf/syscall.c                    |  3 +-
>  tools/testing/selftests/bpf/test_maps.c | 52 ++++++++++++++++++++++---
>  2 files changed, 49 insertions(+), 6 deletions(-)

Looks good to me and is also consistent with what we do for the lookup +
delete batch interface, applied thanks!

Fyi, I've taken it to bpf-next given 5.7 is right around the corner. We
can take the permissions fix to stable once in Linus' tree.

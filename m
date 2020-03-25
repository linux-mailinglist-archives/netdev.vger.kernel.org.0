Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0677B193483
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCYXV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:21:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:48606 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCYXV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:21:56 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHFLK-0003Qi-Sm; Thu, 26 Mar 2020 00:21:50 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHFLK-000N0V-KY; Thu, 26 Mar 2020 00:21:50 +0100
Subject: Re: [PATCH bpf-next v3] libbpf: don't allocate 16M for log buffer by
 default
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Andrii Nakryiko <andriin@fb.com>
References: <20200325195521.112210-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6c65efac-bead-b29c-750b-0a4c1d216b87@iogearbox.net>
Date:   Thu, 26 Mar 2020 00:21:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200325195521.112210-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25762/Wed Mar 25 14:09:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 8:55 PM, Stanislav Fomichev wrote:
> For each prog/btf load we allocate and free 16 megs of verifier buffer.
> On production systems it doesn't really make sense because the
> programs/btf have gone through extensive testing and (mostly) guaranteed
> to successfully load.
> 
> Let's assume successful case by default and skip buffer allocation
> on the first try. If there is an error, start with BPF_LOG_BUF_SIZE
> and double it on each ENOSPC iteration.
> 
> v3:
> * Return -ENOMEM when can't allocate log buffer (Andrii Nakryiko)
> 
> v2:
> * Don't allocate the buffer at all on the first try (Andrii Nakryiko)
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24165136320
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgAIWQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:16:06 -0500
Received: from www62.your-server.de ([213.133.104.62]:58228 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgAIWQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 17:16:06 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipg5z-0001qB-MN; Thu, 09 Jan 2020 23:16:03 +0100
Received: from [178.197.248.58] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipg5z-000M5a-BD; Thu, 09 Jan 2020 23:16:03 +0100
Subject: Re: [PATCH v2] bpf/sockmap: read psock ingress_msg before
 sk_receive_queue
To:     Lingpeng Chen <forrest0579@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
References: <5e1620c332f3c_159a2af0aa9505b861@john-XPS-13-9370.notmuch>
 <20200109014833.18951-1-forrest0579@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1f40d981-b6b9-b674-8777-1e2bb466a35a@iogearbox.net>
Date:   Thu, 9 Jan 2020 23:16:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200109014833.18951-1-forrest0579@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25689/Thu Jan  9 10:59:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/20 2:48 AM, Lingpeng Chen wrote:
> Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
> if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
> and there's also some data in psock->ingress_msg, the data in
> psock->ingress_msg will be purged. It is always happen when request to a
> HTTP1.0 server like python SimpleHTTPServer since the server send FIN
> packet after data is sent out.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: Arika Chen <eaglesora@gmail.com>
> Suggested-by: Arika Chen <eaglesora@gmail.com>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> Cc: stable@vger.kernel.org # v4.20+
> Acked-by: Song Liu <songliubraving@fb.com>

Applied to bpf, thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7002B56C0E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfFZOcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:32:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:44820 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:32:53 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8yh-0000bx-KA; Wed, 26 Jun 2019 16:32:51 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8yh-000FYI-EM; Wed, 26 Jun 2019 16:32:51 +0200
Subject: Re: [PATCH bpf-next] bpf: fix compiler warning with CONFIG_MODULES=n
To:     Yonghong Song <yhs@fb.com>, ast@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, arnd@arndb.de
References: <20190626003503.1985698-1-yhs@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f78ebda2-dfa6-1c9a-63bc-2ef56d9e1379@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:32:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190626003503.1985698-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/26/2019 02:35 AM, Yonghong Song wrote:
> With CONFIG_MODULES=n, the following compiler warning occurs:
>   /data/users/yhs/work/net-next/kernel/trace/bpf_trace.c:605:13: warning:
>       ‘do_bpf_send_signal’ defined but not used [-Wunused-function]
>   static void do_bpf_send_signal(struct irq_work *entry)
> 
> The __init function send_signal_irq_work_init(), which calls
> do_bpf_send_signal(), is defined under CONFIG_MODULES. Hence,
> when CONFIG_MODULES=n, nobody calls static function do_bpf_send_signal(),
> hence the warning.
> 
> The init function send_signal_irq_work_init() should work without
> CONFIG_MODULES. Moving it out of CONFIG_MODULES
> code section fixed the compiler warning, and also make bpf_send_signal()
> helper work without CONFIG_MODULES.
> 
> Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
> Reported-By: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied, thanks!

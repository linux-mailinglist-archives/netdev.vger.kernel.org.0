Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0BA120942
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 16:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfLPPEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 10:04:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:49300 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbfLPPEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 10:04:22 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igrv2-0003Yc-DT; Mon, 16 Dec 2019 16:04:20 +0100
Date:   Mon, 16 Dec 2019 16:04:19 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     bokun.feng@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] kernel: bpf: add releases() annotation
Message-ID: <20191216150419.GB27202@linux.fritz.box>
References: <20191216124239.19180-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216124239.19180-1-jbi.octave@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 12:42:39PM +0000, Jules Irenge wrote:
> Add sparse annotation to remove issue detected by sparse tool.
> warning: context imbalance in __bpf_prog_exit - unexpected unlock
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  kernel/bpf/trampoline.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 7e89f1f49d77..fb43b7a57e38 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -213,6 +213,7 @@ u64 notrace __bpf_prog_enter(void)
>  }
>  
>  void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
> +	__releases(RCU)

Hmm, why are you not adding an annotation to __bpf_prog_enter() as well ?

>  {
>  	struct bpf_prog_stats *stats;
>  
> -- 
> 2.23.0
> 

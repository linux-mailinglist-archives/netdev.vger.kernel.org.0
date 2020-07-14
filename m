Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0545521F3AC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGNOPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgGNOPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:15:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D6AC061755;
        Tue, 14 Jul 2020 07:15:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a24so2024611pfc.10;
        Tue, 14 Jul 2020 07:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DAio3TnNTOjPe9yDwDItXd0o7RC8Gehby5x/FyQbpyQ=;
        b=rOAffERfaz2UrV/aTpHlw3LE+qz20urqxX+6me5hpwJ2HDvmNztB9cRc0EXprWkEdM
         Jlj3whEQl2yiERo84RsgSSoBDw8op80X+CguyWpDzcdtdPIoJNgCQjYSkBQf+pi/RwIG
         8BfylvHePmpveogaOzrmzbJLa5JX1tKimMPPJHh5X9manHtwJ4pFy7Gr8P0Zv4CMKjJo
         o49vk16JtSQP8TshZDf7MIOorbkkALU6B6J54U8BPnXpLHclWDfDB3WWQk+W6w4JJuQM
         /oedkiRJAu+TBuyAIFvy+4DmQcSp0C5gGWc2sGILREgdr3J7Gs53S6OkLm0ifNPALVlL
         kcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DAio3TnNTOjPe9yDwDItXd0o7RC8Gehby5x/FyQbpyQ=;
        b=djmKuisxoltQoD/a/qWrXWGvjNjQ2vjSQO5ny18gi8VQzXzI/T//ddfFFZmVcgF3GW
         4oVuxd/D48LmXAC23Zp61xY+LCsV5LjycbATky23wHtpL8jet1dt6/OxSGA1hxu4lNpK
         0/jsPTDDVAVmAnUl6DZWrikvxmLyV1fw+ejj4nVUq6cPSCHhu+LzALci7CXyLbT1s0co
         HwMsIymQ19WxG5SPl10TyUQIkEFbWUuhMKZP/KRrsluV/K865w3TvAHj8DKOsp/SrxKX
         jiKY1HGImlXepOqoVK596JRhffjcH2Jt8ICwoqTN51b0Beb15m8dj4ozzSaBkc9T6CuJ
         c9jg==
X-Gm-Message-State: AOAM531xur5WeyDUGGAuEBOfiU+q6qd4HN8YMWiifS3s4US+HLAniRI+
        lEu2AxW4+dBuY7Hx6cpcilLnniyQ
X-Google-Smtp-Source: ABdhPJyo3khVV52XT8MCJLPQdOIgAWkQukLAnutLjv1b+w0ozzXXf31UXmKYsEbgAsae5AM27N437w==
X-Received: by 2002:a05:6a00:2bb:: with SMTP id q27mr4723037pfs.176.1594736148707;
        Tue, 14 Jul 2020 07:15:48 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p5sm16337570pgi.83.2020.07.14.07.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 07:15:47 -0700 (PDT)
Subject: Re: [PATCH v2] tipc: Don't using smp_processor_id() in preemptible
 code
To:     qiang.zhang@windriver.com, jmaloy@redhat.com, davem@davemloft.net,
        kuba@kernel.org, tuong.t.lien@dektech.com.au,
        eric.dumazet@gmail.com, ying.xue@windriver.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20200714080559.9617-1-qiang.zhang@windriver.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bf395370-219a-7c87-deee-7f3edce8c9dc@gmail.com>
Date:   Tue, 14 Jul 2020 07:15:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200714080559.9617-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/20 1:05 AM, qiang.zhang@windriver.com wrote:
> From: Zhang Qiang <qiang.zhang@windriver.com>
> 
> CPU: 0 PID: 6801 Comm: syz-executor201 Not tainted 5.8.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> 
> Fixes: fc1b6d6de2208 ("tipc: introduce TIPC encryption & authentication")
> Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com
> Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
> ---
>  v1->v2:
>  add fixes tags.
> 
>  net/tipc/crypto.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index 8c47ded2edb6..520af0afe1b3 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -399,9 +399,10 @@ static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val)
>   */
>  static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
>  {
> -	struct tipc_tfm **tfm_entry = this_cpu_ptr(aead->tfm_entry);
> +	struct tipc_tfm **tfm_entry = get_cpu_ptr(aead->tfm_entry);
>  
>  	*tfm_entry = list_next_entry(*tfm_entry, list);
> +	put_cpu_ptr(tfm_entry);
>  	return (*tfm_entry)->tfm;
>  }
>  
> 

You have not explained why this was safe.

This seems to hide a real bug.

Presumably callers of this function should have disable preemption, and maybe interrupts as well.

Right after put_cpu_ptr(tfm_entry), this thread could migrate to another cpu, and still access
data owned by the old cpu.



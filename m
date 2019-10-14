Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAF6D6298
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbfJNMdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:33:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34905 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730394AbfJNMdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 08:33:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id c3so7981731plo.2;
        Mon, 14 Oct 2019 05:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=299WARGSZgoZwCiaRSp9MfhaJD92jcm3ybh9xwS/7l4=;
        b=GG4wBPKh4WWdXWO7eT20LMXhp9cSJvxqbfEVrPtEWg+cCsguD4J7kV24sXQj2gdVhP
         YeR5JrcakPxGza6af07ubK7OYWCC+DMN2air7u49a6u/FyOtH3rpcQjuFT6FkKt1ViOR
         HMYOanXyje3n8O3gV8DduH6/jBlr/amLx0cASO/O6H3Sl5QP7vaHGqSNnjtte/GFDOBB
         HlbWYA7by9uht2FNFiZyEKyCAAWNgFKKZCIoWv51q6hQXauOrykQYDr+FbUovyHzIbw+
         ofx/YhfGjNvFv6/7UiNKz3LzIvrapI6tm4PvRj/lkJrlqE5cGaruXh816YzxqsorMSc0
         Ewfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=299WARGSZgoZwCiaRSp9MfhaJD92jcm3ybh9xwS/7l4=;
        b=MSKTtyKeXOK5aWmo0sEw0ce/ejnPEgTGq1kzyKuK2Gc6U0/uj73hA+vhWHCdsQk9o8
         z5NaftJsG9zhNvXws2z56jNC7+FB/obPbQXw7GD4CuWlWMNTvgaN4zVgp/JLJJo14QZm
         OhPBu6egUudZTXdA3cziWZsbsd6KqYSsF+zwI/L7JSmJvkY5sk2NIZZi0ia/AVuha5yJ
         nNfZ52bHjDyiuI6tBscGBoX58+2nDleMVPCDOQXOkQruA509+IN3/Uj1+oykzUsn+p7G
         /Lc+4XKgCCjifMruHAQrwBmnfewQcXCn8/9fLd7AbHh4y3S1rhWB2z4PgtYzrmi2mdu+
         IibQ==
X-Gm-Message-State: APjAAAW3dCmnuKWUQzcy0wp0KVR8/uxz/9y5mRk50bsrVWD5wxh6cVRw
        r8iVZQ0ujw31lrlJg5erg1U=
X-Google-Smtp-Source: APXvYqyfZ5PCQZdAe1Noq2MUDZ373072WR8R6nw48Nl00ECz995ylpix0x5UKAVWOrQ9+kAo7KLUew==
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr29891517plr.277.1571056397925;
        Mon, 14 Oct 2019 05:33:17 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id w2sm20155282pfn.57.2019.10.14.05.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 05:33:17 -0700 (PDT)
Subject: Re: tcp: Checking a kmemdup() call in tcp_time_wait()
To:     Markus Elfring <Markus.Elfring@web.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
References: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
 <124b41aa-7ba5-f00c-ab73-cb8e6a2ae75f@gmail.com>
 <fc39488c-f874-5d85-3200-60001e6bda52@web.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0984a481-f5eb-4346-fb98-718174c55e36@gmail.com>
Date:   Mon, 14 Oct 2019 05:33:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fc39488c-f874-5d85-3200-60001e6bda52@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/19 11:51 PM, Markus Elfring wrote:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/tcp_minisocks.c?id=1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n306
>>> https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/tcp_minisocks.c#L306
> …
>> Presumably the BUG would trigger if a really disturbing bug happened.
> 
> How “buggy” is this place if the function call “kmemdup” failed?

It is not buggy. The BUG will not trigger.

BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());

This would be different if we had instead :

BUG_ON(!tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());

> 
> Can an other error reporting approach be nicer here?

There is no error reported if kmemdup() has failed.

timewait is best effort.

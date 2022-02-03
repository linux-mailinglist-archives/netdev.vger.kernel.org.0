Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C74A87F7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiBCPsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbiBCPsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:48:20 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96472C061714;
        Thu,  3 Feb 2022 07:48:20 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id r144so3725270iod.9;
        Thu, 03 Feb 2022 07:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WLH1O+Vnbs8udHEehPW8PKl/Vsqp6/y9M/lwajCfmXg=;
        b=O2CfoR+Kidy6Oil62L7eIH2efozt64sP75j6rrjblHbD93lfalaDPECmKMSLR1bMRI
         MyATwiK8Iq8ewDJjL9wop/yWJRNXHiz+mJrQzvj/rLk2NFXEmmVyCEkcg+achzY/Ujzq
         rBdpvZRBfpcjJDd2ziUgr3b7rDzDcNBZjr0Gp//MfAvWdMpIeAIpoAiu88IHAI0ldyRG
         j42emqwxOa9uI2aqBdX7uWycKCXtCy+lxyp3ULgGou70LGIa8eRS1fabpdxJaLNt4Z9c
         EqohgOdJ2zBGkWXIvlpxH3JWAuZYbjnKP6TLYl5zqR+gElcmUBERluM5d1nIYiV/h6cr
         sCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WLH1O+Vnbs8udHEehPW8PKl/Vsqp6/y9M/lwajCfmXg=;
        b=kbPlJ2uUhEOa4MCgi5/Tb3MOArMunrCJbx1nfLnal99dDid1n4Dlg8Ocw325aE40gg
         RPdAAn9o9c9HKMUqh4FlyNWwOTB+BEOTTaiTKt4V8vSqBP8ZJbbNx4YAfnYbb8unuW5x
         aT7ZHTSiLiYTCP4bo5I9qo+/HbHlUtbednGOKdMEhJ4Tfb/m3dWDhhXTgbxMXmiOvihl
         iYEDLwZaQPZuvJe959DZnvc1aoResWHz8okEZgOPq5XS4ToZIr/qyVSfcI+8oLW8jeD0
         ilZxxIGyFCgzMIDzMjovx25OwhzYkqONKps5jnuaW6PI1zYGeJT5sNcIhOA8lhjxKqw4
         0K4g==
X-Gm-Message-State: AOAM5323rKQDo+13iY+vy/UrqY1rAOPtbsay+jKSaTtq31UV/uxieU4K
        Euo8ltYcPleFCsogSmNsrJgTuBM4m4Q=
X-Google-Smtp-Source: ABdhPJytHT2ainnjTy8kuwJMbb9XvCK+xi9KdImDjah1yKuXQ7fyHkvMjlJDtILNHjHCwvaKCySTwA==
X-Received: by 2002:a6b:4e18:: with SMTP id c24mr18972137iob.179.1643903300006;
        Thu, 03 Feb 2022 07:48:20 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id o7sm8800664ilt.63.2022.02.03.07.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 07:48:19 -0800 (PST)
Message-ID: <e34e03db-9764-4728-9f6a-df85659c5089@gmail.com>
Date:   Thu, 3 Feb 2022 08:48:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH RFC 1/4] net: skb: use line number to trace dropped skb
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
 <20220203153731.8992-2-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220203153731.8992-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 8:37 AM, Dongli Zhang wrote:
> Sometimes the kernel may not directly call kfree_skb() to drop the sk_buff.
> Instead, it "goto drop" and call kfree_skb() at 'drop'. This make it
> difficult to track the reason that the sk_buff is dropped.
> 
> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
> introduced the kfree_skb_reason() to help track the reason. However, we may
> need to define many reasons for each driver/subsystem.
> 
> To avoid introducing so many new reasons, this is to use line number
> ("__LINE__") to trace where the sk_buff is dropped. As a result, the reason
> will be generated automatically.
> 

I don't agree with this approach. It is only marginally better than the
old kfree_skb that only gave the instruction pointer. That tells you the
function that dropped the packet, but not why the packet is dropped.
Adding the line number only makes users have to consult the source code.

When I watch drop monitor for kfree_skb I want to know *why* the packet
was dropped, not the line number in the source code. e.g., dropmon
showing OTHERHOST means too many packets are sent to this host (e.g.,
hypervisor) that do not belong to the host or the VMs running on it, or
packets have invalid checksum (IP, TCP, UDP). Usable information by
everyone, not just someone with access to the source code for that
specific kernel.


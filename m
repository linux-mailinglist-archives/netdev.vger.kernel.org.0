Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D89A3FD257
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 06:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhIAE1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 00:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhIAE1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 00:27:33 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427B2C061575;
        Tue, 31 Aug 2021 21:26:37 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id e7so1495091pgk.2;
        Tue, 31 Aug 2021 21:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=m3+x6eamp7airoZfilCRdbz7+5OQzTJOBB6pMEhx4vg=;
        b=Qdva0mO/jU8xhmjzTJw0+fCZ8gRJVJ7M0n7TFrg9LIujotS/bfp4tZgrVlA+y6ns6c
         NfR7q7wg8IjDhKBKxi0LIwXgS8Xeyk8I3xU+EkXOv1hf7CATtZYvbJ+GmGd2346sG9sc
         OvJ2nvHENEzZxSYqsLqibsZncXkmuOOZ6qSPLmnwNazZMSDDpC7MJLGnPCQkwssweofd
         YLiqugHH9pIyrtrU0tag/qdLp6h7dvluEO9JwH+qVq3qdokg2MR82ph0h9bgHla18w2s
         briguaIKGbC86NJvxjsdFksspf1fw/1bm1f2ZhOt3Z0QKzeGJPtCvr+k5HywnzHHma7d
         Dygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m3+x6eamp7airoZfilCRdbz7+5OQzTJOBB6pMEhx4vg=;
        b=qye9H8yB3Ijs6S6126It92lPpwOyxS4+p67Ohk9HLjnHrJQtLuvkS2x7Fg42XjqHK0
         We5eX+efcUgXikWh1+J5JD5JK47mv5j7iDatQ+dagf1fFc3ALn3OasAAlZ5HoCKvt1LU
         DwmSCfB3sK1nneEV+bPgiPi2U/Z6sRNXCDoUPOlGb1W03sjj6u7kGGoTU9rUGYSmqd8g
         kHve0bArOuoHJQY1BdJB+mWD/NtZFI0DtgfG2uUnKOEXlTuugZX5eHbSnKUxmXdKb+dz
         i3sXMIcPBYjJGdRiPtdoQI4Pwh9dwbj12wsNcwUe67F0HT+Z/E3fmlB20F4mf1DSg1Wi
         XBJA==
X-Gm-Message-State: AOAM531xYGeOAjlMlShGB+SxFVL4LLQjciPwquheRmm1asUKVafaPvsD
        MNYU0wvIpG/nA2bL4OLquV0=
X-Google-Smtp-Source: ABdhPJxj8vxWY8DO1ZQyUEokpWKcicJ3hv/lpz3OVFN/kyaVbkQsiBykCfaQ/VnCXTpWoIuFrffa1g==
X-Received: by 2002:a65:4286:: with SMTP id j6mr30401823pgp.10.1630470396434;
        Tue, 31 Aug 2021 21:26:36 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z65sm4532286pjj.43.2021.08.31.21.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 21:26:35 -0700 (PDT)
Subject: Re: [syzbot] WARNING: refcount bug in qrtr_node_lookup
To:     syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>,
        bjorn.andersson@linaro.org, dan.carpenter@oracle.com,
        hdanton@sina.com, linux-kernel@vger.kernel.org,
        manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000004b732105cae6d6f1@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9b98fb89-c9a1-d220-2583-66e89c765d23@gmail.com>
Date:   Tue, 31 Aug 2021 21:26:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0000000000004b732105cae6d6f1@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/21 8:41 PM, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acpi_mps_check' [-Werror,-Wimplicit-function-declaration]
> arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'acpi_table_upgrade' [-Werror,-Wimplicit-function-declaration]
> arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'acpi_boot_table_init' [-Werror,-Wimplicit-function-declaration]
> arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'early_acpi_boot_init' [-Werror,-Wimplicit-function-declaration]
> arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'acpi_boot_init' [-Werror,-Wimplicit-function-declaration]
> 
> 
> Tested on:
> 
> commit:         9e9fb765 Merge tag 'net-next-5.15' of git://git.kernel..
> git tree:       upstream
> dashboard link: https://syzkaller.appspot.com/bug?extid=c613e88b3093ebf3686e
> compiler:       
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=1413e2f5300000
> 

Tree seems broken, no idea why the following is needed.

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 63b20536c8d236083336c2b50dc5f54225a80eab..6edec9a28293ea3241bd7842ab5555a1691e6cea 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -22,6 +22,7 @@
 #include <linux/usb/xhci-dbgp.h>
 #include <linux/static_call.h>
 #include <linux/swiotlb.h>
+#include <linux/acpi.h>
 
 #include <uapi/linux/mount.h>
 

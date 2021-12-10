Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FD7470669
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244213AbhLJQ4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244155AbhLJQ4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:56:18 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103F8C061746;
        Fri, 10 Dec 2021 08:52:43 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bf8so14017039oib.6;
        Fri, 10 Dec 2021 08:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=22649vhBq2+EXGoWXGfR5yBZHrxpcXiBe7SMU6QvJ9E=;
        b=VftFAwBD3J9MksWNJ5Q0i0pQIydLpWe2AWuYf9hpQ/Ka1F7NoQydT0ZsBgvzcnqTFM
         7eSKfeBCTKGgjyzPFvXkS+1bGmvSjHVgpptuhuF/bIWT5D9/oZoa+UvPzksq41QYQlik
         AIMg32rj7fr2HUHp+J34ApUAL/Hgtpufq6jvZnFaB4ieYkpMHUyki2KqcLdg6HX12jX0
         cOV7ZE0a65Q/jG2Pq145sXlYdVdvVW4u8KbUB7S0MHSdLzRo76Pf4lURvrM1qrqecCfy
         daAlQlCQOa7tON7rXYVKL3q77PzIptp+nfPEqF9Dv5MHqG/yt+FfJg7CAT1ekh9RLi9x
         nG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=22649vhBq2+EXGoWXGfR5yBZHrxpcXiBe7SMU6QvJ9E=;
        b=0BFuakcU8BGOZNrRp6ptFOjTmBuJHk/ZGdvI+LTa+DssKyePcuqS1z8t14G+UEVxg2
         pMpMLA38hj+DPJ0Z7imuxdJdzOxtO+hFkVgn1DQ8Khsg5vv9TomkVCpdz0R4BcRLfWVu
         beE/7wYFlLRM3usZE1203QQA0zlLV52LXurVYgF1OhsSdOa2Ox4an0sm41JooorbojZo
         Km2LGJjbuuz2jGfE5LqJI6pnNcnhMuFXPLY7HZlqyKPJBGRZGdLWbmV3XMTTOmt4Xn1E
         InBI9T145BalUm0w4tURebk+5EyqMyZAnglmWgQQZmp2abz6qjOZjrZcgE6/qoMe3Vcr
         skQQ==
X-Gm-Message-State: AOAM531Y26VwVbyDQWtSfoXUGrJ/zyjgtCgjz4uzb2rtlwJ+Dtolqp6X
        lCJHN3TPaPfdEmeaAUijr9j+JcK7o9s=
X-Google-Smtp-Source: ABdhPJxW9Ar0jM0wiz/JsNh5FO3yZcq6iyIKA1cdOfyZnTsUsxNwdyAP2uJove/VQzA+HL9k+sLMbA==
X-Received: by 2002:a05:6808:699:: with SMTP id k25mr13313595oig.135.1639155162438;
        Fri, 10 Dec 2021 08:52:42 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s2sm597106otr.69.2021.12.10.08.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:52:41 -0800 (PST)
Message-ID: <36bbf0c3-06a9-db35-46f1-320cc502ef75@gmail.com>
Date:   Fri, 10 Dec 2021 09:52:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [syzbot] KMSAN: uninit-value in fib_get_nhs
Content-Language: en-US
To:     syzbot <syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
References: <0000000000005a735005d2bb2dff@google.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <0000000000005a735005d2bb2dff@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/21 11:57 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8b936c96768e kmsan: core: remove the accidentally committe..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=1724ebc5b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e00a8959fdd3f3e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=d4b9a2851cc3ce998741
> compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1225f875b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139513c5b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708


Most likely lack of length validation on nla like we have in
fib_gw_from_via for the other attribute (nlav). Will send a patch.


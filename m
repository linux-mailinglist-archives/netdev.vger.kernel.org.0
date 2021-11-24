Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E805E45CB57
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349731AbhKXRq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243906AbhKXRq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:46:29 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D408C061574;
        Wed, 24 Nov 2021 09:43:19 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id m27so9236636lfj.12;
        Wed, 24 Nov 2021 09:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=HaFcpK/P/GGsknj1HL812X9ZdJDmKc2b6kicKM3XERg=;
        b=VIuEhf0iRw2Yk5ATNVLXlqFx3lDuSFDLdKrsl/pWwxrquwVRMzO/fO85W8kVjSxKrR
         fOaU21uR4K5y9fWA3HZ8+W7J7StqXDqFr+XKipq1KAwaVgTBb27xPEkYyqr1mpR3MY1B
         5u5z06CURxeptEzBkuk3Rr383Cr64v4DMHG1zNeDr93M2NOWxFEAjIQjvdgff72Anu9r
         D6XYEy5r/NkyrUvbaM282gRpt2AYz56+0mo3QZ6UHwpHrGOmkUlg9H53pITiXKj3V9U2
         2sfa5oGTuNJ80ssdH5so4G7wjalQG8haCbnaRqwyv3BvR2sWhkEZdBE4jzvK+NqXaNb1
         1MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HaFcpK/P/GGsknj1HL812X9ZdJDmKc2b6kicKM3XERg=;
        b=SbxUswZuSxANAepfy5i+hr+s0EFYNNJ/BwZmmRM/yRNKlfsLd4XkS+ddJpuxZ19U5j
         9IqqppQs4EYw2sHlWdHiHjUaef3fWIVty31GlWpS2f8tfWL5U2k/bdX2ZbjiIP8KNhRm
         A+l2dSe+Be65gPbvvJmE3Ukh9D5Fdgeqvo+/Ucgqlu6zjlcORLlP6xiPpnwprQcp4y1H
         Y4527k3ewN4i+2uAca6SjTA/JsMoxlhdFOEpfqWYTdYEtpybw0JWA27YSc0AfIXJp8lE
         jF1u4M0LR7U/5/nYQjMcRLXN5jZJlqi97FyccuNWSBCJz8TPaJKDjSMzBCe15jZlTMyo
         1Rlw==
X-Gm-Message-State: AOAM53344xO4/B05HdohHbQfo8BStBf9PcrNO9CZhjcjNguKsFU/VlVB
        S+IAeEBKsQ0XxbL3VIcJ88I=
X-Google-Smtp-Source: ABdhPJz2AdPeAnDvJ7NGF6iYGbDdqLkFASTmqUMDU+WcZZ1wXrsHr7fvkSRXg4XxLG0fZ/R3VjGXcg==
X-Received: by 2002:a05:6512:a81:: with SMTP id m1mr16200807lfu.306.1637775797333;
        Wed, 24 Nov 2021 09:43:17 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.63])
        by smtp.gmail.com with ESMTPSA id b12sm44026lfv.91.2021.11.24.09.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 09:43:17 -0800 (PST)
Message-ID: <3233c950-3bec-99c8-4afe-efe6392c929d@gmail.com>
Date:   Wed, 24 Nov 2021 20:43:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [syzbot] WARNING: ODEBUG bug in batadv_v_ogm_free
Content-Language: en-US
To:     syzbot <syzbot+0ef06384b5f39a16ebb9@syzkaller.appspotmail.com>,
        Jason@zx2c4.com, a@unstable.cc, amcohen@nvidia.com,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, fw@strlen.de,
        idosch@OSS.NVIDIA.COM, justin.iurman@uliege.be, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, praveen5582@gmail.com, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        willemb@google.com, yoshfuji@linux-ipv6.org, zxu@linkedin.com
References: <0000000000009f52f205d18c60a7@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000009f52f205d18c60a7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/21 20:42, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 6f68cd634856f8ca93bafd623ba5357e0f648c68
> Author: Pavel Skripkin <paskripkin@gmail.com>
> Date:   Sun Oct 24 13:13:56 2021 +0000
> 
>      net: batman-adv: fix error handling
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114e3c16b00000
> start commit:   cf52ad5ff16c Merge tag 'driver-core-5.15-rc6' of git://git..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9479508d7bb83ad9
> dashboard link: https://syzkaller.appspot.com/bug?extid=0ef06384b5f39a16ebb9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17af7344b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15dc02fb300000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: net: batman-adv: fix error handling
> 


#syz fix: net: batman-adv: fix error handling

Looks valid


With regards,
Pavel Skripkin

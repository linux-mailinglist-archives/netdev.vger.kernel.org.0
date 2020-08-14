Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFB6244B97
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgHNPFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgHNPFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:05:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC97AC061384;
        Fri, 14 Aug 2020 08:05:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d4so4506010pjx.5;
        Fri, 14 Aug 2020 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ftk7cVeP2VJCv8rvQnvKeC7BVrEaHbeeYHcpYUiy4OM=;
        b=PViFerxHW5l9qfmgreTd/IZit/rdgX8jVzkh/lM/LGYel3JZ6+/kDlVTJjV61Ua1zL
         UTbh4wg1npg5hYawIC1NRelSlAjfBW0KhQ15GZcfpcott4XauhB0sNXBGWfEE1xprvOI
         EJSb2FkA2Xa/ZYAepJdhKAm2But19BK/V0uxoO+2GT1lnH5qJ/ybRKV4DbwPJAg9VKC3
         WP2dVdArQF1c7HbawiuX8cjzcZ0Olk57wojMlNc1qddn32pPUF39TtyLWEGP4ZXe8Rxe
         4WvAGEQvMkARg5HcSX2Z8DahCdNBcQHezbauG+gf8Q/0qEOYd4Lppi8A5nRvFDM/rUdm
         mosg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ftk7cVeP2VJCv8rvQnvKeC7BVrEaHbeeYHcpYUiy4OM=;
        b=d4c87FKMaFjYfmzPeC4pdzZMMV/91Xbpg4Ep0VU9gERf86oDGa2kB9rYD1mWCBRQcg
         u5yaqV1gjdTRTixG3a9EDW+C3u8rTlqVxyk5MCYDGXVjZLLW7ZRflNRibfw2slP/7AWd
         ub6E0un4ktwbDy5zRDkxW9ARrIgKmO4lSuQ8mwjISm1rZF0g3zeBI5HJCpIVaw0Yh9xV
         mAh4z4yDYT1Rq7+oe7enKlEerU1Y52mJLys6hJ6ok9ThEjO5YzP55+6oDywHGAoQShR6
         3T9foPqdUeZDWmfKmbHHjilRJQpaon1vZXyq5+oFFPp8JPGiHgmQfUlVvA7bnUp1G2Zs
         2wdQ==
X-Gm-Message-State: AOAM533tQ6Yydh/DLX9koZKxxZ8tMZkS4t/+ifpGK2j43mQ+SCcAvHuC
        5THHZ5YwRexemnnKEqdnTsyviBkZgo0=
X-Google-Smtp-Source: ABdhPJxk1RWg2dnouIo67Ez/jEBdW83owOuk8msCbL1MTY2sLMb2L5fyRpoVIA3x4+KLhIuRkWdfbQ==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr2331945plc.70.1597417548278;
        Fri, 14 Aug 2020 08:05:48 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id mr21sm8664024pjb.57.2020.08.14.08.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2020 08:05:47 -0700 (PDT)
Subject: Re: WARNING: locking bug in try_to_grab_pending
To:     syzbot <syzbot+2b713236b28823cd4dff@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
        yoshfuji@linux-ipv6.org
References: <000000000000dbe6ee05acd63ca2@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4c3119a4-2395-dafc-5146-d23d568c5aef@gmail.com>
Date:   Fri, 14 Aug 2020 08:05:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000dbe6ee05acd63ca2@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/14/20 6:17 AM, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 1378817486d6860f6a927f573491afe65287abf1
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu May 21 18:29:58 2020 +0000
> 
>     tipc: block BH before using dst_cache
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175599f6900000
> start commit:   6663cf82 flow_offload: Fix flow action infrastructure
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8572a6e4661225f4
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b713236b28823cd4dff
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e932a8c00000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: tipc: block BH before using dst_cache
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

#syz fix: tipc: block BH before using dst_cache

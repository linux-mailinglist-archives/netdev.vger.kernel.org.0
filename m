Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0993F13B0A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 17:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEDP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 11:56:41 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38699 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEDP4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 11:56:41 -0400
Received: by mail-pl1-f195.google.com with SMTP id a59so4183534pla.5;
        Sat, 04 May 2019 08:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ozyZS/tA6cPkZB5Jf/QmfWhCYZ2taRWbsknV+2MnVY0=;
        b=qXaN7ziX/RFvjumvzdXQz3iz1c9JXLK8N0N4VT40SAUxsfkqI7LLMjYDff2vfwQRP4
         wm6Q6O7wGCzMVnV/3xLLwwwsyHdpi05XBnPNWHhvW4eZxCqDm6BTczSQF8iE26a67WoE
         Odv1vJWtxKEkw5P2+rzlzIaKm03ynX0aJNnC1Jw5oTpV9ZYnIq4bixVcRkIBjwSXhoBZ
         uRtcXvhgjiPpgI375WOzG6ftz4yqE7IZFVt6oKnGQpDzkkfiVGBpZ0qv/mBfFJ5VlIx0
         Yr/+ENFw0ZjhATQOsxtlqqsw9sXKICHOYRTRxit5iDyXdXCTvEff80QplCrutUxUgit9
         +Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ozyZS/tA6cPkZB5Jf/QmfWhCYZ2taRWbsknV+2MnVY0=;
        b=Lr1EfPNsjCXipDFZT45aYV/YJTN6rGelv0EYXzfTFQPrVJ6gXML5ZGsisYZxFxZq9Q
         iucVybdmdC/EHe8eFOTBqARiG//AN6owbDczKUycr+a4fmJGCt2m9Bo/xAfT5EJXayS4
         4IVuXYp0FQuIy0pdaIOF2NyJPoLFJeBiSiDfaIo/zqc2gsdQ4gydhxUKs2qKIFo4hww2
         KMoTUeKl3dzg6lPSooJfPJdut0qJJoALADUq5PkPVSyMiaEPPW09vMelt/Oo1UkvECo7
         5DnU483Eqa/mHulgIoXrhTvJmzD6cdrMU3FM4Z6M1cOS1kyx8a54Wzxfl20pFm7gSkZ1
         /arQ==
X-Gm-Message-State: APjAAAXzZf49SFLJbJO/bTee+FDgcPBMf+1pM1krCOXm/8xHIUjVkY6N
        CizfBM7S8ty8/V8uzqglzMc=
X-Google-Smtp-Source: APXvYqzJ6nnN5y6pun4s6v+aB6cFgDzezM8CZNGf1Z/GAMyax5X7Q331TVHleQQS4b64EiSHAC0TFg==
X-Received: by 2002:a17:902:84:: with SMTP id a4mr19706617pla.210.1556985400387;
        Sat, 04 May 2019 08:56:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id a129sm6993370pfa.152.2019.05.04.08.56.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 08:56:39 -0700 (PDT)
Subject: Re: [PATCH] ipv4: Delete uncached routes upon unregistration of
 loopback device.
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mahesh Bandewar <maheshb@google.com>
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
 <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
 <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
 <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
 <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f6f770a7-17af-d51f-3ffb-4edba9b28101@gmail.com>
Date:   Sat, 4 May 2019 11:56:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 10:52 AM, Tetsuo Handa wrote:
> syzbot is hitting infinite loop when a loopback device in a namespace is
> unregistered [1]. This is because rt_flush_dev() is moving the refcount of
> "any device to unregister" to "a loopback device in that namespace" but
> nobody can drop the refcount moved from non loopback devices when the
> loopback device in that namespace is unregistered.
> 
> This behavior was introduced by commit caacf05e5ad1abf0 ("ipv4: Properly
> purge netdev references on uncached routes.") but there is no description
> why we have to temporarily move the refcount to "a loopback device in that
> namespace" and why it is safe to do so, for rt_flush_dev() becomes a no-op
> when "a loopback device in that namespace" is about to be unregistered.
> 
> Since I don't know the reason, this patch breaks the infinite loop by
> deleting the uncached route (which eventually drops the refcount via
> dst_destroy()) when "a loopback device in that namespace" is unregistered
> rather than when "non-loopback devices in that namespace" is unregistered.

Well, you have not fixed a bug, you simply made sure that whatever cpu is using the
routes you forcibly deleted is going to crash the host very soon (use-after-frees have
undefined behavior, but KASAN should crash most of the times)

Please do not send patches like that with a huge CC list, keep networking patches
to netdev mailing list.

Mahesh has an alternative patch, adding a fake device that can not be dismantled
to make sure we fully intercept skbs sent through a dead route, instead of relying
on loopback dropping them later at some point.


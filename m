Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374DD5215C0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbiEJMtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiEJMte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:49:34 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C8155222
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 05:45:34 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x23so14841142pff.9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 05:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=81CmoXK8W2fMc2E/XpNylErNEPWG7PeFWSGfTvENHek=;
        b=BuizLo0eMVf1CFKzq5z5mJXXTCdmsbZnthwaSpGZvyOinz0zK1oVrwY+RjDSbz0lsj
         W4/gcD2GsatA2CltDPm42940C9Zx8OlEiXWEDruJeUP+scX4B4Dn/BR45LSBkgx0ha/1
         1lof9Sxe/0+TSOSmg+ZbSpzVPPfdI8D1n/IK23ovFovWMObnth4tWgSXWT44+EFOD5cw
         YRdLOnhCKKUDhjj1PBpvvrU/SLEYIvonvF8JuhoBcVkVWvziCCxnA6XbN07WU1oTTJuX
         9N9BICkQtsDiH2S5IvrqAAzmp2SqDTXhUfx7lB75VtVwJ+wJsJW+JGZukF4rewQyhJ7E
         HF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=81CmoXK8W2fMc2E/XpNylErNEPWG7PeFWSGfTvENHek=;
        b=H5EegwHI30YFjHtYz+kUup2VdwGI5azOM4HpoWZNvGNqmT6x7B/Q/fYPUOpi7bW1tC
         j9nBbWJ+2y3RG9jvD9VVyEW2Vst22oeHxwEsws2LP2DKBwzc+0ya4g0BDVD9FVg1JWT3
         yNtMDar7tOJd1MONllfZq0xLlrzc6Qhdcc2VT3hsjhrOipx+e71EDXphTUDkCVA9kFem
         nHF3WAwmluxITtOj+YRKC/GDVStBUJq3lhlqamG2yFdMH4XOrvVSeYH2Phs3sIhWXDLa
         Ix0V4gDRbjXGZX3OhgDPzz/X63D7rG5oj6UL9B+kvcSrv6VOlSd/s1PKUrSrV48wdN6i
         xK0g==
X-Gm-Message-State: AOAM531v8CDi7IWLjej/rknCpnvy8XnERzG+IcOZZZUWpCC05pE5GJFa
        sMord1vrW3XACLGI93f2vij24A==
X-Google-Smtp-Source: ABdhPJww7Eg4/Zxst2GZrQrVNwauUtpxNCsfNjZ19FUR133ytWOXTk+q1xGx0v1s2BhN+B7mV7yS+A==
X-Received: by 2002:a63:2c8a:0:b0:3aa:86ea:f2c9 with SMTP id s132-20020a632c8a000000b003aa86eaf2c9mr16916062pgs.46.1652186733527;
        Tue, 10 May 2022 05:45:33 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q187-20020a632ac4000000b003c14af5063fsm10345438pgq.87.2022.05.10.05.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 05:45:32 -0700 (PDT)
Message-ID: <0e1b3d10-ae79-f987-187e-58109441ccee@kernel.dk>
Date:   Tue, 10 May 2022 06:45:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] KASAN: use-after-free Read in bio_poll
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     syzbot <syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000029572505de968021@google.com>
 <a72282ef-650c-143b-4b88-5185009c3ec2@kernel.dk> <YnmuRuO4yplt8p/p@T590>
 <20220510055039.GA10576@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220510055039.GA10576@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 11:50 PM, Christoph Hellwig wrote:
> On Tue, May 10, 2022 at 08:13:58AM +0800, Ming Lei wrote:
>>> Guys, should we just queue:
>>>
>>> ommit 9650b453a3d4b1b8ed4ea8bcb9b40109608d1faf
>>> Author: Ming Lei <ming.lei@redhat.com>
>>> Date:   Wed Apr 20 22:31:10 2022 +0800
>>>
>>>     block: ignore RWF_HIPRI hint for sync dio
>>>
>>> up for 5.18 and stable?
>>
>> I am fine with merging to 5.18 & stable.
> 
> I'm fine, too.  But are we sure this actually is one and the same
> issue?  Otherwise I'll try to find some time to feed it to syzbot
> first.

I re-wrote the reproducer a bit and can reproduce it, so I can certainly
test a backport. But yes, I was skeptical on this being the same issue
too. My initial reaction was that this is likely due to the bio being
"downgraded" from polled to IRQ driven, and hence completes without an
extra reference before the bio_poll() is done on it. Which is not the
issue described in the referenced commit.

-- 
Jens Axboe


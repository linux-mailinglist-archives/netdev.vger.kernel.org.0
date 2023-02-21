Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6A69E3E7
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbjBUPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjBUPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:47:28 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4FA265B2;
        Tue, 21 Feb 2023 07:47:27 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x10so18135015edd.13;
        Tue, 21 Feb 2023 07:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=scM9oYCSR1ND5NiwNb6ID5TUnyh6Ib6071WzOSOrsT4=;
        b=d0B6JhmUt4j5p3PHPLbXlteRY5kSw721PyQ1UDfSQYlq0razfwkmUCEPG544F9j4SF
         ZjBazQTGkCMhVyF/bp1NcvTD1EmyKaIVpJkSbZqIEcGsSGXLFqVvFOPWV9BKElhqOrnN
         CpytSaVygN02dpjIfbr6KZJBAn3P1InfeSYO9aETjq2eIgIiPWJ1/Ai3W39WmHNIgNnI
         juJE6vv+YXo+r4ewJrFbOnbSBhFXaVbKAob0vxjmw+uhxidsxxacg5zK+uaY9TMXwRbr
         fIs5HR3yFLofEc9sk8R4fqfFmOY/Wn/FG4+d5aQ/9YBkEoqk5G+si4QaEGwxFNn/Twk0
         YG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scM9oYCSR1ND5NiwNb6ID5TUnyh6Ib6071WzOSOrsT4=;
        b=2XciQtcJySXy5LOiLEHpASVygKRy8GsVDmunABmqiTJPpDcaPD3F71bzD5z2SfZcS4
         G48Qqgm/FEQICYjkVJ5KnWUevycLCk12lcRnHhDzYpWsf/V1pTvaUFshNINtkseekYNA
         JWCmolIe12Gir9rXHwFKVAdO/xiLaT50mzTnMliv2cjLYupHHn61F6Na35yO1saov3dZ
         UuMWvyDB4XFdEefAe9pPOBmj0xZsIT7DJng+eFIAXkQEel1IX8ZYNDL3abZHPIR+fAya
         Z1uKrjnK+M6b4wTrLWcboeR8KGKT/Pk6AzXKGZxSEZFW7ML86QxXcU/dOCSD3olYkbfA
         4uxA==
X-Gm-Message-State: AO0yUKUp9E/WFO4crMYMwablsQfCjQKgB1fhh7/d5D7DvKAQPKgWnOje
        W9cIIjUTM4LQxO1l6HnEbxbpy5A87NLZDluW4ec=
X-Google-Smtp-Source: AK7set9hq6lHx/3D/Eckys2B7FbwUbl4sjrwQyeG1UCSJlPURRvP/Mqbbu+8eLZrnD9uJ7HJEJJZ1Q8g4zlgrUZSIGw=
X-Received: by 2002:a17:907:1dda:b0:878:b86b:de15 with SMTP id
 og26-20020a1709071dda00b00878b86bde15mr6383597ejc.11.1676994445630; Tue, 21
 Feb 2023 07:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20230221110344.82818-1-kerneljasonxing@gmail.com>
 <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
 <CAL+tcoD8PzL4khHq44z27qSHHGkcC4YUa91E3h+ki7O0u3SshQ@mail.gmail.com> <aaf3d11ea5b247ab03d117dadae682fe2180d38a.camel@redhat.com>
In-Reply-To: <aaf3d11ea5b247ab03d117dadae682fe2180d38a.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 21 Feb 2023 23:46:49 +0800
Message-ID: <CAL+tcoBZFFwOnUqzcDtSsNyfPgHENAOv0bPcvncxuMPwCn40+Q@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix memory schedule error
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 10:46 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2023-02-21 at 21:39 +0800, Jason Xing wrote:
> > On Tue, Feb 21, 2023 at 8:27 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > On Tue, 2023-02-21 at 19:03 +0800, Jason Xing wrote:
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
> > > > and sk_rmem_schedule() errors"):
> > > >
> > > > "If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> > > > we want to allocate 1 byte more (rounded up to one page),
> > > > instead of 150001"
> > >
> > > I'm wondering if this would cause measurable (even small) performance
> > > regression? Specifically under high packet rate, with BH and user-space
> > > processing happening on different CPUs.
> > >
> > > Could you please provide the relevant performance figures?
> >
> > Sure, I've done some basic tests on my machine as below.
> >
> > Environment: 16 cpus, 60G memory
> > Server: run "iperf3 -s -p [port]" command and start 500 processes.
> > Client: run "iperf3 -u -c 127.0.0.1 -p [port]" command and start 500 processes.
>
> Just for the records, with the above command each process will send
> pkts at 1mbs - not very relevant performance wise.
>
> Instead you could do:
>

> taskset 0x2 iperf -s &
> iperf -u -c 127.0.0.1 -b 0 -l 64
>

Thanks for your guidance.

Here're some numbers according to what you suggested, which I tested
several times.
----------|IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
Before: lo 411073.41 411073.41  36932.38  36932.38
After:   lo 410308.73 410308.73  36863.81  36863.81

Above is one of many results which does not mean that the original
code absolutely outperforms.
The output is not that constant and stable, I think.

Please help me review those numbers.

>
> > In theory, I have no clue about why it could cause some regression?
> > Maybe the memory allocation is not that enough compared to the
> > original code?
>
> As Eric noted, for UDP traffic, due to the expected average packet
> size, sk_forward_alloc is touched quite frequently, both with and
> without this patch, so there is little chance it will have any
> performance impact.

Well, I see.

Thanks,
Jason

>
> Cheers,
>
> Paolo
>

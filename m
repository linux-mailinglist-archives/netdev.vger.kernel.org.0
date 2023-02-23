Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215EB6A0478
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjBWJHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjBWJHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:07:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437FB4BE94;
        Thu, 23 Feb 2023 01:07:45 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so5620000wmq.2;
        Thu, 23 Feb 2023 01:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HnQXK2gjczB2ZF+Tg148J7R6douhmpCC9lTEcuUAcS8=;
        b=MnFd0ndH9sx0lsllqrqddOkUXNXh6hC1qZtoQQVW/BCTJYvcvJybvmNQTWXoacZzW/
         Eel0CMWNmX6hNJCqTjxvbK8Wuidm1GRpu2iKurAi49jvb4yfv8D4L1tUNclZDy9YJvZ7
         rDuhsEXS9UFbB2IFX9JepEpC202Xa2P9AF9DHZpTIguttBce8Y6lp157jeq0nj78y3Gy
         L8m25a2eFKK2mZEb5dpoxA5Su+ebYrt5CYnKJdy6hz99AXlKCQHqbpeGBsC7B4B7Y9gM
         CX/WdYubw2pq+yebT9fXyhGqrwcfT3LM3RwWQ/NKZYPIFyRM+Nl4THY1KIp8vbae8lZs
         bfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HnQXK2gjczB2ZF+Tg148J7R6douhmpCC9lTEcuUAcS8=;
        b=EMODG43ZWdw52Z0VRzTij6uE7wEmLEiAD41LCC070waoAmkw4KeWK5UejzwkuAlMhB
         furkW/VVdg0U6HybEpNjJ6G/t8vQ+FuEt6yWmSHDmOm2G6qM22C7DmX5ygUy+FWfb07A
         kkq7UFOSr+BJ7FrdWvYsMFcPT9EjpBd39Jfv3L0ZGohGWghmtypx4ix9ykZ5AotFZCNW
         25QOJVNlPRd4HxoIcBhOe5GVGMyj7ADYWlZ0iaxav6M9ZedMUFjoELOIZ/aYJ53pNQqB
         Vd06k3VpNoCvJyAYq6tNgtvCMYqp3aND5v4yKgVugNLFfSw1cmHl4FYwPj7+83sQn8/7
         /7fQ==
X-Gm-Message-State: AO0yUKUAfALsVEnK7Y1P00mWj1rr1apN8/qJJU4o4te7epj1A0jCB/IF
        kqUcmBQBL2T9J1ikoUOqFB3hfzKRI1RWOlpisr4=
X-Google-Smtp-Source: AK7set8zo0tWDkLqcDs6tf/q37PjH+sBC1k9Rw51OnZNwCBWtuzaX2gfp5tygs/qSzmxRr0tjp5TT/ZxLDl3Ie65naM=
X-Received: by 2002:a05:600c:19c6:b0:3de:e8c5:d827 with SMTP id
 u6-20020a05600c19c600b003dee8c5d827mr628705wmq.118.1677143263536; Thu, 23 Feb
 2023 01:07:43 -0800 (PST)
MIME-Version: 1.0
References: <20230221110344.82818-1-kerneljasonxing@gmail.com>
 <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
 <CAL+tcoD8PzL4khHq44z27qSHHGkcC4YUa91E3h+ki7O0u3SshQ@mail.gmail.com>
 <aaf3d11ea5b247ab03d117dadae682fe2180d38a.camel@redhat.com>
 <CAL+tcoBZFFwOnUqzcDtSsNyfPgHENAOv0bPcvncxuMPwCn40+Q@mail.gmail.com>
 <CAL+tcoBGFkXea-GyzbO41Ve8_wUF3PT=YF43TxuzgM+adVa8gw@mail.gmail.com> <795aed3f0e433a89fb72a8af3fc736f58dea1bf1.camel@redhat.com>
In-Reply-To: <795aed3f0e433a89fb72a8af3fc736f58dea1bf1.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 23 Feb 2023 17:07:07 +0800
Message-ID: <CAL+tcoAwFH3t=KL9cLFT5eo2eaF66hUw5rZr0+VKgrY89K-_xQ@mail.gmail.com>
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

On Thu, Feb 23, 2023 at 4:39 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2023-02-22 at 11:47 +0800, Jason Xing wrote:
> > On Tue, Feb 21, 2023 at 11:46 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >
> > > On Tue, Feb 21, 2023 at 10:46 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > >
> > > > On Tue, 2023-02-21 at 21:39 +0800, Jason Xing wrote:
> > > > > On Tue, Feb 21, 2023 at 8:27 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, 2023-02-21 at 19:03 +0800, Jason Xing wrote:
> > > > > > > From: Jason Xing <kernelxing@tencent.com>
> > > > > > >
> > > > > > > Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
> > > > > > > and sk_rmem_schedule() errors"):
> > > > > > >
> > > > > > > "If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> > > > > > > we want to allocate 1 byte more (rounded up to one page),
> > > > > > > instead of 150001"
> > > > > >
> > > > > > I'm wondering if this would cause measurable (even small) performance
> > > > > > regression? Specifically under high packet rate, with BH and user-space
> > > > > > processing happening on different CPUs.
> > > > > >
> > > > > > Could you please provide the relevant performance figures?
> > > > >
> > > > > Sure, I've done some basic tests on my machine as below.
> > > > >
> > > > > Environment: 16 cpus, 60G memory
> > > > > Server: run "iperf3 -s -p [port]" command and start 500 processes.
> > > > > Client: run "iperf3 -u -c 127.0.0.1 -p [port]" command and start 500 processes.
> > > >
> > > > Just for the records, with the above command each process will send
> > > > pkts at 1mbs - not very relevant performance wise.
> > > >
> > > > Instead you could do:
> > > >
> > >
> > > > taskset 0x2 iperf -s &
> > > > iperf -u -c 127.0.0.1 -b 0 -l 64
> > > >
> > >
> > > Thanks for your guidance.
> > >
> > > Here're some numbers according to what you suggested, which I tested
> > > several times.
> > > ----------|IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
> > > Before: lo 411073.41 411073.41  36932.38  36932.38
> > > After:   lo 410308.73 410308.73  36863.81  36863.81
> > >
> > > Above is one of many results which does not mean that the original
> > > code absolutely outperforms.
> > > The output is not that constant and stable, I think.
> >
> > Today, I ran the same test on other servers, it looks the same as
> > above. Those results fluctuate within ~2%.
> >
> > Oh, one more thing I forgot to say is the output of iperf itself which
> > doesn't show any difference.
> > Before: Bitrate is 211 - 212 Mbits/sec
> > After: Bitrate is 211 - 212 Mbits/sec
> > So this result is relatively constant especially if we keep running
> > the test over 2 minutes.
>
> Thanks for the testing. My personal take on this one is that is more a
> refactor than a bug fix - as the amount forward allocated memory should
> always be negligible for UDP.
>

> Still it could make sense keep the accounting schema consistent across
> different protocols. I suggest to repost for net-next, when it will re-
> open, additionally introducing __sk_mem_schedule() usage to avoid code
> duplication.
>

Thanks for the review. I will replace this part with
__sk_mem_schedule() and then repost it after Mar 6th.

Thanks,
Jason

> Thanks,
>
> Paolo
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC91739DC
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgB1Obh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:31:37 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42499 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgB1Obg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:31:36 -0500
Received: by mail-yw1-f65.google.com with SMTP id n127so3417198ywd.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qJiZNnqWc4caNiOq4IoG0CuDMSK+NvjfI5ITeE/8QOE=;
        b=fNbefomLY7lJa1NK+hqyRAvPhyNkXKQxZj5du7bV0+gOBpy/kqu1wLBLXRdT/8OS4E
         WS6GAFDCmOc5vtYlA13dR8Qi/mdOi5qTaGm3pAvFVVJU1eiFcN8c+3hFnPypCuGy6xwv
         V70g9/ovaGVvMQJzq2kOX+x+bIrkmOwPcmk4tMCn7eE7fGpsCyA78RwzYtdqjwEXafns
         APl4WXCpjkdtKDKz9JFBoAkE0H/jS07FH/vnXyqBfE6gSlhTs8DV7ceFi7cqQNq0qjA3
         CUuUKcDsdKE+yhGBf2gRWJK7j111hAOlRpTY+io1bHOi814L+D7ON+hKMlN2J97t8T1o
         76Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJiZNnqWc4caNiOq4IoG0CuDMSK+NvjfI5ITeE/8QOE=;
        b=abcuiMBxD8mWT+H4GVf627e8zk5f4GEyDdoSUAd6r5bBxmdULXXx+qztH3E0mUnqmy
         CNZJjY8xL1oPRm+uFY0BAtzs1KNXNBtRIeMVKjaUI46KFyrRuco754QYMwBeny+Qqw41
         vGQmN4hkJV6Oe7J0N71sbxbgrA6oOWRMWJBkvRGZKxJ/2s4eLQ252J4oHD/zPhp1Qntf
         cU7Qgl7B5e1wcowS6hjeMzHMZh59NQrtu/EDdH7Gb0IyDVGHYVfBXOrMMsVrPW1+2tI3
         ydt0zfFKo3JXE3+yKW0OGetdn7/+wT0wh7Y55FJ/w+NfyQPVsTJ8Y2aFQlb3vAt2iThy
         AytQ==
X-Gm-Message-State: APjAAAWcW+ZhYxeRakEGccpOibW3dnVrpSsVERybZPJqmYBnuGdQOGOF
        Vy3i3tUsPMtWMtGFUyPNa4D0sFdu
X-Google-Smtp-Source: APXvYqwhY4kFhlI28dXSzP7P1Pb1gd7yL7D8EKRJIJ1ahFcxFWNCx9DxZ5lXs1X0RxTXM3FBhRVD9A==
X-Received: by 2002:a25:c8c3:: with SMTP id y186mr3759483ybf.159.1582900295272;
        Fri, 28 Feb 2020 06:31:35 -0800 (PST)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id y189sm3905375ywe.21.2020.02.28.06.31.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 06:31:34 -0800 (PST)
Received: by mail-yw1-f49.google.com with SMTP id j186so3485976ywe.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:31:34 -0800 (PST)
X-Received: by 2002:a0d:fb82:: with SMTP id l124mr4938885ywf.507.1582900293494;
 Fri, 28 Feb 2020 06:31:33 -0800 (PST)
MIME-Version: 1.0
References: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
 <1582262039-25359-1-git-send-email-kyk.segfault@gmail.com>
 <CA+FuTSe8VKTMO9CA2F-oNvZLbtfMqhyf+ZjruXbqz_WTrj-F1A@mail.gmail.com> <CABGOaVRF9D21--aFi6VJ9MWMn0GxR-s8PssXnzbEjSneafbh5A@mail.gmail.com>
In-Reply-To: <CABGOaVRF9D21--aFi6VJ9MWMn0GxR-s8PssXnzbEjSneafbh5A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Feb 2020 09:30:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfaTYB0p1yBuJK4226D-vjhhO_-zN3PUFKFdvyKVT5JdA@mail.gmail.com>
Message-ID: <CA+FuTSfaTYB0p1yBuJK4226D-vjhhO_-zN3PUFKFdvyKVT5JdA@mail.gmail.com>
Subject: Re: [PATCH] net: Make skb_segment not to compute checksum if network
 controller supports checksumming
To:     Yadu Kishore <kyk.segfault@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 12:25 AM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
> > Did you measure a cycle efficiency improvement? As discussed in the
> > referred email thread, the kernel uses checksum_and_copy because it is
> > generally not significantly more expensive than copy alone
> > skb_segment already is a very complex function. New code needs to
> > offer a tangible benefit.
>
> I ran iperf TCP Tx traffic of 1000 megabytes and captured the cpu cycle
> utilization using perf:
> "perf record -e cycles -a iperf \
> -c 192.168.2.53 -p 5002 -fm -n 1048576000 -i 2  -l 8k -w 8m"
>
> I see the following are the top consumers of cpu cycles:
>
> Function                                   %cpu cycles
> =======                                   =========
> skb_mac_gso_segment            0.02
> inet_gso_segment                     0.26
> tcp4_gso_segment                    0.02
> tcp_gso_segment                      0.19
> skb_segment                             0.52
> skb_copy_and_csum_bits         0.64
> do_csum                                    7.25
> memcpy                                     3.71
> __alloc_skb                                0.91
> ==========                              ====
> SUM                                           13.52
>
> The measurement was done on an arm64 hikey960 platform running android with
> linux kernel ver 4.19.23.
> I see that 7.25% of the cpu cycles is spent computing the checksum against the
> total of 13.52% of cpu cycles.
> Which means around 52.9% of the total cycles is spent doing checksum.
> Hence the attempt to try to offload checksum in the case of GSO also.

Can you contrast this against a run with your changes? The thought is
that the majority of this cost is due to the memory loads and stores, not
the arithmetic ops to compute the checksum. When enabling checksum
offload, the same stalls will occur, but will simply be attributed to
memcpy instead of to do_csum. A:B comparisons of absolute (-n) cycle
counts are usually very noisy, but it's worth a shot.


> > Is this not already handled by __copy_skb_header above? If ip_summed
> > has to be initialized, so have csum_start and csum_offset. That call
> > should have initialized all three.
>
> Thanks, I will look into why even though __copy_skb_header is being
> called, I am still
> seeing skb->ip_summed set to CHECKSUM_NONE in the network driver.

Thanks.

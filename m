Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE078346529
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhCWQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhCWQ33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 12:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29788619C2;
        Tue, 23 Mar 2021 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616516969;
        bh=eBf5ODrXs5Umg1VKVxuL6E8KDcWzaxXh5BAlofVjego=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HSkLjJzufs2M4dIEMmihAx4MLRTCKvxVqtN7nlT3TJxvxetMHBfXpPO2TDDWTuO5a
         emGA8qldAJqd7NCt2Muyc/n56SPJ1mFSU3pwcmz8mIecAqiLVSysFtMvbsXONge5A7
         hN67pbJvKHXhf/QB9kp2B12h8nFASvktHbg5vXJvJyXsN299iC8/L1a1McAuvWHntu
         a6EnixRlsVuwQjBXSBbebVK73hka+zrx9qgC+yGZOcsvuBejtHKWMXMHViGwE44YtL
         xkPpbeRzLuXE1CdNGU2ZIQ/G2fGuXsJNCmNpgbVnOt3G2w0aZ9NR1nb7TQmFhEn2bf
         pZJ9smoljdrVA==
Received: by mail-ot1-f42.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so19750748otb.7;
        Tue, 23 Mar 2021 09:29:29 -0700 (PDT)
X-Gm-Message-State: AOAM531fHtKhQegqTvo0zLJo3s4u8RvZpXCh+bykYRTTBLAXIW/rSSli
        g+KNKuF0H7nEWebml6FTakMjswNb76Qd2XRc9LI=
X-Google-Smtp-Source: ABdhPJyGmYV3gwAkwIj5JeoP0CPxLSK13pX3mpJFYr0hyF5iRe9TRcgDcCnYaTzVSamWmYnBs/iZGKeO9dgpyV3eF48=
X-Received: by 2002:a05:6830:14c1:: with SMTP id t1mr5085231otq.305.1616516968456;
 Tue, 23 Mar 2021 09:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210323125233.1743957-1-arnd@kernel.org> <CA+FuTSdZSmBe0UfdmAiE3HxK2wFhEbEktP=xDT8qY9WL+++Cig@mail.gmail.com>
In-Reply-To: <CA+FuTSdZSmBe0UfdmAiE3HxK2wFhEbEktP=xDT8qY9WL+++Cig@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 23 Mar 2021 17:29:12 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2r+wjJH3NsHf8XDBRhkbyc_HAbNtizO3L-Us+8_JC2bw@mail.gmail.com>
Message-ID: <CAK8P3a2r+wjJH3NsHf8XDBRhkbyc_HAbNtizO3L-Us+8_JC2bw@mail.gmail.com>
Subject: Re: [RFC net] net: skbuff: fix stack variable out of bounds access
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 3:42 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Mar 23, 2021 at 8:52 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >>
> A similar fix already landed in 5.12-rc3: commit b228c9b05876 ("net:
> expand textsearch ts_state to fit skb_seq_state"). That fix landed in
> 5.12-rc3.

Ah nice, even the same BUILD_BUG_ON() ;-)

Too bad it had to be found through runtime testing when it could have been
found by the compiler warning.

       Arnd

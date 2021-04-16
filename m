Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8EE361C13
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbhDPIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240762AbhDPIrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 04:47:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263586115B;
        Fri, 16 Apr 2021 08:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618562820;
        bh=vCr7NobGfgufbqpcRwx5p9dip3kCxkFPMkIA2Pgnrd0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ROwvHwXG8Au6Dof8pq66CXiNL1m1C09AxUIdzf/RkTAyGcn04OpPYJJafX1Jlm1cq
         BNg1vChmPjmtyg3sJ9YgE0X0mk6p0t0vHyWj8jWui0M/T5CqxXsFVYmCCe32bOrh3I
         MOO0Oa1zE/BNrkisNumPhByzk2WEb2NWrr+lp9lhwRaM/HxkQ04gpY7B1kcAmX5zPB
         oVAH4+I11umPeYLr74PHUddwn/DcT/YxuXK/+TUielBh18k9BMQW+Cz7kt2CywfJ6m
         Xt5dINDKvsG/8d7Oubqk6WSNLlvHCEbftEMbOccj18ml+KG0MG1Gx6/sH8lR48CbCm
         FisBxumZT8JKw==
Received: by mail-ej1-f54.google.com with SMTP id u21so40996659ejo.13;
        Fri, 16 Apr 2021 01:47:00 -0700 (PDT)
X-Gm-Message-State: AOAM533Qirbd/MY/RiZCA3q+AKRVkm89N4ZPE+FSVSp0pkAoKfcYFOcu
        raQnwOc3fN5M45jtpy7f/D+W5wURJOGKlLKda6w=
X-Google-Smtp-Source: ABdhPJzFgkNv5MPUkwGgoa4DQg+JXP1ANTSzjRHgw0M4TEzkdf3yLy2iKwLcLbZb+t3leAFkv4AaYe+3pjow9RGdSyA=
X-Received: by 2002:a17:906:c284:: with SMTP id r4mr7300148ejz.454.1618562818724;
 Fri, 16 Apr 2021 01:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210416034007.31222-1-zhuguangqing83@gmail.com>
In-Reply-To: <20210416034007.31222-1-zhuguangqing83@gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 16 Apr 2021 10:46:46 +0200
X-Gmail-Original-Message-ID: <CAJKOXPcG6v1wpiNVgeOkooN-8e+WP-pYcNfc48w9sMLqp-VFvg@mail.gmail.com>
Message-ID: <CAJKOXPcG6v1wpiNVgeOkooN-8e+WP-pYcNfc48w9sMLqp-VFvg@mail.gmail.com>
Subject: Re: [PATCH] drivers: ipa: Fix missing IRQF_ONESHOT as only threaded handler
To:     zhuguangqing83@gmail.com
Cc:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 at 06:26, <zhuguangqing83@gmail.com> wrote:
>
> From: Guangqing Zhu <zhuguangqing83@gmail.com>
>
> Coccinelle noticed:
> drivers/net/ipa/ipa_smp2p.c:186:7-27: ERROR: Threaded IRQ with no primary
> handler requested without IRQF_ONESHOT
>
> Signed-off-by: Guangqing Zhu <zhuguangqing83@gmail.com>
> ---
>  drivers/net/ipa/ipa_smp2p.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Did you test it? There are several patches like this all over the tree
so it looks like "let's fix everything from Coccinelle" because you
ignored at least in some of the cases that the handler is not the
default primary one. I am not saying that the change is bad, but
rather it looks automated and needs more consideration.

Best regards,
Krzysztof
Best regards,
Krzysztof

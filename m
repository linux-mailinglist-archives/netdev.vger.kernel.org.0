Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DADE33E1AA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhCPWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhCPWtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 18:49:06 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5489FC06174A;
        Tue, 16 Mar 2021 15:48:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y13so9849661pfr.0;
        Tue, 16 Mar 2021 15:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTHHLh0hTEeZauOlWKx3N6YCGdslyxRSMI7p5Hmw7jo=;
        b=CqLDhibfwjHh8p6Vd/+s2jfQeyE2Cx3eCSVa52SJZS6lGiC96C6E+neLRR9NXh5XDT
         85xKcYe15dXRqs12u4LzZtaGV5n+9/OTH9ms5sAMYn94Euv5XD26Io3kFx7KffwF1ApY
         FAQrYQ/zD1XhPiTm9NqjNdNOTFefstir4bNpewHOMUnBJKhObZmu67CuxPHQqWKy8xcD
         Qjb8Yi4RKhIKQokeR0OSAuIUfgCakX7ZnDFiptHcNMrTBalbp/n2TYi2U19vdVE2V1YL
         AMOXW86NEgWuMZ7ukyOXJ+lMR0SBEbtWw/8tYhs8eAbWvsYmDN6IGCsmN/MiQ8Uz/EZr
         B0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTHHLh0hTEeZauOlWKx3N6YCGdslyxRSMI7p5Hmw7jo=;
        b=SNzLlGhG6z16szYhMeJZTJhpsZ7VnYbJ/zkrN5ZUeVgagKBI4VqWLRsBHhQ1axyZoH
         qCMOGw+7nfFSqs/xUV/dRuPzHsB0r61oyJaa01fZdoNzzzFyttijaTK4EyysqMg8+4br
         naK9BSH1bXaEM3nusVvPXA7805l7hypLq0LwFXH80qcO4H+Ni1+xSVmkHj2qkOcO61Ej
         QRwlTbP9tT6kK1+MO/8hX054eSVHOjF6h19smh0vrfU/yzj+xLxZl+4oaF1ZTYdieex5
         a5YZg8+UFH7nF6/H7+7exYGmGjBr/lEW1K5xxzZik+wSYE1kFXb2FJm2j/qkcuY/Ekbm
         1FSw==
X-Gm-Message-State: AOAM530Uki9xXEM3MCbup0V7jMprgItnvdKkxFQvLS3cNRC7jZRRdEko
        M47oBdAWHsDaMb7S0pVhJZw8sE599fRMEpZfUU8=
X-Google-Smtp-Source: ABdhPJxDSD5FZtx9zrHIPa8F3AN4+4ja9E5BsIFXyJM1XP1lfiM/BWUKoVsp9mU2GPnfnKZfCy/UnkATaJp/I1zKcf4=
X-Received: by 2002:a63:1266:: with SMTP id 38mr22409pgs.266.1615934934830;
 Tue, 16 Mar 2021 15:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com> <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 16 Mar 2021 15:48:43 -0700
Message-ID: <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> I thought pfifo was supposed to be "lockless" and this change
> re-introduces a lock between producer and consumer, no?

It has never been truly lockless, it uses two spinlocks in the ring buffer
implementation, and it introduced a q->seqlock recently, with this patch
now we have priv->lock, 4 locks in total. So our "lockless" qdisc ends
up having more locks than others. ;) I don't think we are going to a
right direction...

Thanks.

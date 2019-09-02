Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9233CA584F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbfIBNov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 09:44:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40589 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfIBNov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 09:44:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id c3so14086636wrd.7
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 06:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNQqrN7t4YgqKAVJQdHaH4jGQlR9V2QENFls22XfU2A=;
        b=KMXI9TQESbrAPr3oYebSvGevhLGf9jZ0rQRqlxY5k85+dWfBlV3Lze4OjyI8SPrUO0
         yDoUd6ncdKSkgPAmLNDXtmb4k2wNHcNKDR/KSYNeILkU7rXZnJdSCm+Bjg0g3JUsCwwU
         L1fFlbxDDmLUIB5caa6Mwo1HWvsfRqXSLyMIj8aEYaM9TDsEsXhl3uIxyJBqvKDS8Poy
         LKycFlSmF3arzuGTaCvWrD0eWEcyaz6tULBZIRljMHO3dFuK0myd/6ZuajRpA5ts4xOF
         kHc+B005yRkUZkm8J9WSmk4X/HwAMPlSvTQmLpna52Q9o5owKbl28NYBdj2/vtz6Ggzm
         NeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNQqrN7t4YgqKAVJQdHaH4jGQlR9V2QENFls22XfU2A=;
        b=bu1spOKVL2Bi5i7igCRxfzHVZL9bU1x+xZtjxCR1/2Qu1vwXtggDE/xira4hdOA/QD
         vA69Xs/mqr/u9bquTKtjtVVYqYpyIYFRvrv17/dUoI4VrLcf1qBudU2HS/nCJk3jxEft
         72FIfmcaEYrL0Zdf2JMD20KFHbPrr6SHsXcxaMVsYourt6hrzrJraA6ENjn3VXKz7m+P
         yKh0MEnbk+UtUQYNjjwdW1bRjXMfmW12PGUqi4fll7c7k/dkv0XYXO33U7kW/WQg/gcy
         fqec6fn1J4wUoikS5jbSf8/slLIyin+bmemiLiUJVTRzwxV2abL7MztF+7LL1ouQ9mgw
         tMrA==
X-Gm-Message-State: APjAAAVP65FCyAzaUYC/Wng3LkqS8F2tR8t2TkOn7DNgo1hYhEAFkc8A
        LNrFqTzAJhXPpQiOMjY1s4A=
X-Google-Smtp-Source: APXvYqzgdrNwhwOMRljt4VKeimIsfMLtJ1u0FiZ91Tr/8ITmgAnu/mnLSLlQqZERGsiDDBrRo+g0Ag==
X-Received: by 2002:adf:f304:: with SMTP id i4mr39046625wro.61.1567431889011;
        Mon, 02 Sep 2019 06:44:49 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id k6sm51731101wrg.0.2019.09.02.06.44.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 02 Sep 2019 06:44:48 -0700 (PDT)
Date:   Mon, 2 Sep 2019 16:44:44 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        eyal@metanetworks.com
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190902164444.00f32685@pixies>
In-Reply-To: <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
References: <20190826170724.25ff616f@pixies>
        <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
        <20190827144218.5b098eac@pixies>
        <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
        <20190829152241.73734206@pixies>
        <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Sep 2019 16:05:48 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> One quick fix is to disable sg and thus revert to copying in this
> case. Not ideal, but better than a kernel splat:
> 
> @@ -3714,6 +3714,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>         sg = !!(features & NETIF_F_SG);
>         csum = !!can_checksum_protocol(features, proto);
> 
> +       if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag)
> +               sg = false;
> +

Many thanks Willem for looking into this.

Indeed the above suggestion avoids the splat, at least with the
reproducer.

I'll look deeper into this, to make sure the generated skbs are indeed
legit and have correct content.

Shmulik

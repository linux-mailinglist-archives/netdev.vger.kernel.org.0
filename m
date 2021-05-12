Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCC037BF99
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhELOQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhELOPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:15:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECF0C06175F
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:14:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r11so3224410edt.13
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B8+dsnVGPf7hsY+HQXduPDAnUEDSpNmU6uRk4M3oaqs=;
        b=c917zy549w9VdfbQA59q0ZGjmJzDalQGHwIAgrrORe6nhbyLpIm0hOhpfbR2lf56Do
         H4sq4JTjpYYzjFFtG0b3QjgOoRtfJPFdkjU9BzxOynd4sqh1WtoW8wGUXVi+Q6m6w22i
         kFeD/tXYufp88NZZwKtwHsIma/lW4Qxa4v5H11u4IUqDvj7C/BJPM/XGh4ma0/LydrAn
         utQySur7OvheW+UY9CJyqdC8EuH9SEGAQfSNUx682LoK/ZuEvSs5agLzdXj+D8v3A7OW
         mjja+ixSxQt/u0Qwy5OKTNtrwqxTXmk9tq3TKUOb1PkTmGMm2EiTX2wT/ZqpiDoRlZNg
         hYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B8+dsnVGPf7hsY+HQXduPDAnUEDSpNmU6uRk4M3oaqs=;
        b=VItp9HaaMRvo1x4XJwx3oJxwzIufr+LqivAgKlbbWyWj7EqwmgKv9z53G0WFdPNV7v
         6kVQ6IRD0r7h9EkLzllOstfGatJ3YaMCvhQhOmGKy545wrOpOyCUqNzF5myKoRXMyTPC
         vb4WXh5fcM8eE+QtDoARm3othKzYtEeCNRwcQYlikPySP8d8yZY2vJosA975I9nZDcHc
         qMtDt3+xdQl3MzUq7OAinrLAk9NRT4RPEb71cBzI9jH638iOcjCidAOAr9T0h4YZwJ8H
         0XULnFh9zuBXXSx/wCxyy7om4tmQUOwrzaOwrPT9dvUjsfSMadWdc5yMGaHyJiJO8DUm
         +yuw==
X-Gm-Message-State: AOAM532FHANNab5KGFpSY2DSFt8kvBupY7YVIqikf0WJvZ3Qs5SWieyC
        xgWQzUYBoKyL4W91KWMvqQVe5X7pG3l/Kg==
X-Google-Smtp-Source: ABdhPJwn3gG1dCuDXV/jCY6enaD11otUmkG3mrvmmgkyTpU9FcGRNwyqavQIoZSdViuvfxgq52m3rg==
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr43574242edt.55.1620828851939;
        Wed, 12 May 2021 07:14:11 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id e22sm11643517edu.35.2021.05.12.07.14.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 07:14:11 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id o127so13016026wmo.4
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:14:11 -0700 (PDT)
X-Received: by 2002:a1c:ba05:: with SMTP id k5mr7661497wmf.169.1620828850704;
 Wed, 12 May 2021 07:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210512074058epcas2p35536c27bdfafaa6431e164c142007f96@epcas2p3.samsung.com>
 <1620714998-120657-1-git-send-email-dseok.yi@samsung.com> <1620804453-57566-1-git-send-email-dseok.yi@samsung.com>
In-Reply-To: <1620804453-57566-1-git-send-email-dseok.yi@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 12 May 2021 10:13:32 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdOvfdeEPffem6ZDyMzu7yqWxBZrVi2S2wgwjBwqpqquA@mail.gmail.com>
Message-ID: <CA+FuTSdOvfdeEPffem6ZDyMzu7yqWxBZrVi2S2wgwjBwqpqquA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 3:41 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
> coalesced packet payload can be > MSS, but < MSS + 20.
> bpf_skb_proto_6_to_4 will upgrade the MSS and it can be > the payload
> length. After then tcp_gso_segment checks for the payload length if it
> is <= MSS. The condition is causing the packet to be dropped.
>
> tcp_gso_segment():
>         [...]
>         mss = skb_shinfo(skb)->gso_size;
>         if (unlikely(skb->len <= mss))
>                 goto out;
>         [...]
>
> Allow to upgrade/downgrade MSS only when BPF_F_ADJ_ROOM_FIXED_GSO is
> not set.
>
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>

Acked-by: Willem de Bruijn <willemb@google.com>

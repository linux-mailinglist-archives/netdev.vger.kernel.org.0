Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C610834ADF6
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhCZRwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhCZRwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 13:52:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524ADC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 10:52:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u21so9608901ejo.13
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 10:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VabkuKjLIRQQlc3i7w2ZMt66UrpEMnmCD5TRJbnvpTU=;
        b=R3VH+ZVQUfDS9x3Onensg1YF1qSIhYp5F7poOXsxPLs7Ykq9tr3P7xZOVFiXLnX83A
         m0AAZOM3JttQeBrnYlDCGJrl1yaglkL6vTZj1zo2OPLlqH3lJAXxf4WaPQEAEp75mnos
         loPxNLlGQE2mTS2h8mtkelPm8aGLinDPtw+fb43MebH0D+YH2fG5UPM6IeGz+Y2TQ4nz
         qXT/nwQzZxxUYgZ2jAbbKgewxdMxXQdZc6kOS2NV5D9I5+ODwGNak0qjaKD62+LQpMk2
         EiNHAt3GfkH+7AsNvUBlyQNKtlpqNNQYI4VyocyFiLHnG0bvh+moj9KGjisXxKSytcR+
         DSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VabkuKjLIRQQlc3i7w2ZMt66UrpEMnmCD5TRJbnvpTU=;
        b=NBLgGMrHlPnMYQXkfpSFwSZe8tv7/TeDy7ewj6Hv7lnPIo/ve7vDvNwPS4PQyneCCQ
         /9gxSGhWNIU2hvZAQ/tHeCqplgirIWZU/Lm1nrMfRikxxuObDKEf20oBxOHnfU9h9J/v
         /CcNmQ0Q4feLvPsOkUjfMhD7/stwtKmZMU44+4wDEzDbCD+IxBZfvLymRvrBu0pHukSr
         vLVexEDJ/lEjXvtwGT6S5cDAYOKZLoFRaPT/1MXK0v5pcIznafoQ6VNrAYt53lhxQqoj
         crAs5pCMDjgqZ6uC6vCVSxKyuz6RLzyhHHN/Wx9Txh0pK9GcV+hpLgNm/uj8DKtOWnAa
         kBxA==
X-Gm-Message-State: AOAM533KKDRhfH07kAvsDLo0FHmBaESntg4PB2ZWfj69vDLSqGXCWcXw
        nezUx5TVDMRQGxF36fGt9D8ketBG+tU=
X-Google-Smtp-Source: ABdhPJz1DECHdiYtD/zf+X94gJzcrF12MxcNONlB8+oOKXA7/76hRzXQedLp7xREivmOAKewCGe4TA==
X-Received: by 2002:a17:906:f296:: with SMTP id gu22mr16468744ejb.20.1616781137471;
        Fri, 26 Mar 2021 10:52:17 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id j25sm4630709edy.9.2021.03.26.10.52.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:52:16 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id g25so3439884wmh.0
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 10:52:16 -0700 (PDT)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr14111788wmm.120.1616781135548;
 Fri, 26 Mar 2021 10:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <88b8993a835f87440fd875bcbb080d8b7f6ab1bb.1616692794.git.pabeni@redhat.com>
In-Reply-To: <88b8993a835f87440fd875bcbb080d8b7f6ab1bb.1616692794.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Mar 2021 13:51:38 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd3b+oRkf+6hkZqYwwrAqM7rOgj8GDcz5LgwXCEvNLW7Q@mail.gmail.com>
Message-ID: <CA+FuTSd3b+oRkf+6hkZqYwwrAqM7rOgj8GDcz5LgwXCEvNLW7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/8] udp: properly complete L4 GRO over UDP
 tunnel packet
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> After the previous patch, the stack can do L4 UDP aggregation
> on top of a UDP tunnel.
>
> In such scenario, udp{4,6}_gro_complete will be called twice. This function
> will enter its is_flist branch immediately, even though that is only
> correct on the second call, as GSO_FRAGLIST is only relevant for the
> inner packet.
>
> Instead, we need to try first UDP tunnel-based aggregation, if the GRO
> packet requires that.
>
> This patch changes udp{4,6}_gro_complete to skip the frag list processing
> when while encap_mark == 1, identifying processing of the outer tunnel
> header.
> Additionally, clears the field in udp_gro_complete() so that we can enter
> the frag list path on the next round, for the inner header.
>
> v1 -> v2:
>  - hopefully clarified the commit message
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

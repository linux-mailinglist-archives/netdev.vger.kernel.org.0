Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB0643989D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhJYOe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhJYOeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:34:25 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590F1C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:32:03 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id f4so22548346uad.4
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XevUURrsnDZ//PxP6S02D884HbUkjp9GhF2n9rf59Mk=;
        b=iguK4+388xgUGqRLPb2Eeff13O4KUqJ385/6KEEQfWp9SSMnSGbEhEweHXlejhl6H/
         degvH7Vu00ogRWHporrHDi83LEpBn5gxLTDvn4wgFNGutzX621eviDSOvSnv9Fmu7xZj
         3/JrBMkJf9z1AFn4M51JxsAEEVrLVnmy95/680/vjcC/Gl2YxqToVoruNQfgZjPlh3m7
         ImfhqaRwJ9+TsN19ZsY1NOpYI6raqIc4Bt86sdyx4m2LUARtNzXUHVDyRJRHi+udFQjv
         aeukF21aJLURhk77GKHst2dUf4HpsRPXDDld199vxvL+Ryl7UczXw7YEu6sQgTf91nWX
         mS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XevUURrsnDZ//PxP6S02D884HbUkjp9GhF2n9rf59Mk=;
        b=1H69/Wm9xTFJpjEZDpQ5fMV/dwMVblgxXLcB3uFQy+hpfSD2gN2rP9DPqR1tp/KTB0
         N3+YnqPkIQXXM0YZbBsDNI7E+zd//aJTJ4UuTYOJ2Ci+ZtIB/Z2Mq6DkovtHjx0td0Tg
         vxfaPK+GjdFGcS5vY8Qly0SZBSwDwL+SLLdkFnYIDRGYGfMWi7+/OHTvTUhaFKDBQRks
         uGs8BPxdQHv35WSDvcV0xcC012wCNSnoyra1xriKtFrjsocWXmT+S0Kte9/cw7F+FNg5
         yzxjVPsRflcPHkgUWJcpfIlYvn4c3fFMOnoGJX0UJYpsEe2iJuETPoJPNsWCu9i1ve23
         F9Qw==
X-Gm-Message-State: AOAM530KepUVGXqpayAJC0HTwT+Kseiv5J+HZBZbPOw8UCtCnAi/WViS
        YlEwRmRyFe/eHQjaPzEJZbU1NHBhbds=
X-Google-Smtp-Source: ABdhPJwk7tF6hXn9UVnLtpPls75JsSxxAIrgoiDfzrTI5QGrf2McaBI16HCu3xUF7CclWcf9g1bFNw==
X-Received: by 2002:a67:ee88:: with SMTP id n8mr14710830vsp.58.1635172322461;
        Mon, 25 Oct 2021 07:32:02 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id u14sm9839745vsi.2.2021.10.25.07.32.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:32:01 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id s201so3139315vke.6
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:32:01 -0700 (PDT)
X-Received: by 2002:a1f:f809:: with SMTP id w9mr4574106vkh.8.1635172321602;
 Mon, 25 Oct 2021 07:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211019114441.1943131-1-cyril.strejc@skoda.cz> <20211024201423.1367844-1-cyril.strejc@skoda.cz>
In-Reply-To: <20211024201423.1367844-1-cyril.strejc@skoda.cz>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 25 Oct 2021 10:31:25 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf=Q573PoEcEvK7uDKFGh-aEyC4CV6bZt0=VV63cJ35Cw@mail.gmail.com>
Message-ID: <CA+FuTSf=Q573PoEcEvK7uDKFGh-aEyC4CV6bZt0=VV63cJ35Cw@mail.gmail.com>
Subject: Re: [PATCH v2] net: multicast: calculate csum of looped-back and
 forwarded packets
To:     Cyril Strejc <cyril.strejc@skoda.cz>
Cc:     davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 4:17 PM Cyril Strejc <cyril.strejc@skoda.cz> wrote:
>
> During a testing of an user-space application which transmits UDP
> multicast datagrams and utilizes multicast routing to send the UDP
> datagrams out of defined network interfaces, I've found a multicast
> router does not fill-in UDP checksum into locally produced, looped-back
> and forwarded UDP datagrams, if an original output NIC the datagrams
> are sent to has UDP TX checksum offload enabled.
>
> The datagrams are sent malformed out of the NIC the datagrams have been
> forwarded to.
>
> It is because:
>
> 1. If TX checksum offload is enabled on the output NIC, UDP checksum
>    is not calculated by kernel and is not filled into skb data.
>
> 2. dev_loopback_xmit(), which is called solely by
>    ip_mc_finish_output(), sets skb->ip_summed = CHECKSUM_UNNECESSARY
>    unconditionally.
>
> 3. Since 35fc92a9 ("[NET]: Allow forwarding of ip_summed except
>    CHECKSUM_COMPLETE"), the ip_summed value is preserved during
>    forwarding.
>
> 4. If ip_summed != CHECKSUM_PARTIAL, checksum is not calculated during
>    a packet egress.
>
> The minimum fix in dev_loopback_xmit():
>
> 1. Preserves skb->ip_summed CHECKSUM_PARTIAL. This is the
>    case when the original output NIC has TX checksum offload enabled.
>    The effects are:
>
>      a) If the forwarding destination interface supports TX checksum
>         offloading, the NIC driver is responsible to fill-in the
>         checksum.
>
>      b) If the forwarding destination interface does NOT support TX
>         checksum offloading, checksums are filled-in by kernel before
>         skb is submitted to the NIC driver.
>
>      c) For local delivery, checksum validation is skipped as in the
>         case of CHECKSUM_UNNECESSARY, thanks to skb_csum_unnecessary().
>
> 2. Translates ip_summed CHECKSUM_NONE to CHECKSUM_UNNECESSARY. It
>    means, for CHECKSUM_NONE, the behavior is unmodified and is there
>    to skip a looped-back packet local delivery checksum validation.
>
> Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>

Reviewed-by: Willem de Bruijn <willemb@google.com>

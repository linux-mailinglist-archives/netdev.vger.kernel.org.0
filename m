Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F53328B7
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCIOgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhCIOg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:36:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B431EC06175F
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 06:36:26 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ci14so28188587ejc.7
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NkrImNhNpTZbyH50e8J9HL5+BNOIlHrCZBcyIPHvdns=;
        b=it1he6lFFcNQQOZEWQXRhe/IQSNeucdGGvbtokOSAmr4bBlJkfu+kpji98BR0/GsGV
         +AaWi1JPDbGLv8yzjYXF0BEZFEPWXHO+tRoydoYdlfq4OiRfjRazY6/0cX5LwDqnxyb1
         52430PMmUh1QDQ5kEmtyaFUChfVSFLzAghdgi15N7bXgXmnU0Df0iJPe2B27zg8+KaSl
         au9sjdS60+iMcJEQVcx4fqIuaGdn9LGT4Ff49QkovaprjQoZcH6ViqVbSbhMVjA64ARh
         S/Y4vriSZjZNir9OFVoGpHvP3Tsvg+9pOdxPZEwfoXV6wbNG7iHDbb47feA7dZq0Bfev
         sSEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NkrImNhNpTZbyH50e8J9HL5+BNOIlHrCZBcyIPHvdns=;
        b=bri6gc+PLvH1xQw3t4EMH0dQSXTY9UE+gk8sPpJ4RWUbpI4FTev1fbtaQSi6JMdxDC
         QG/JsTN+e3XukzRolPSWMLc+x+kxe2XhZDww79fAL1CPeF3QocoYQWoqZ4POV+mWmdQs
         AyeLHfRqAJ/aj4TaVl5sZVExCX8ERbcgRZ+VHvl+ROnB0PkF8BmhN4g/XsEdXAu0bhre
         YTMCa20EFM9sAYscwQHcZlPH5hgZyrQEf86bS6DsP5G77Zv3WC2ePTbr9ukoT6zJmF0q
         K0IXFlRZ5hoKPNStYDHzWgFgRi9ZBbzx0Cq/Aw2Aytx6uSPBosbB9ZEMf50nNRQ0h6w2
         5s8Q==
X-Gm-Message-State: AOAM5325S5N6gozEvW7n+TEHlDBsIGJUhmBA6jBLpncAFIxDeHupnEKt
        Mh4zw7cVzDQuIStCSqbPk3CiUmqH53g=
X-Google-Smtp-Source: ABdhPJygztwTMFYbaFW+qMjv7dyQuDh+pa6E5jh2cU/r7kHFZTdSXHgskL5CGb+AXZjed5Airqhzig==
X-Received: by 2002:a17:906:3388:: with SMTP id v8mr20891146eja.278.1615300585222;
        Tue, 09 Mar 2021 06:36:25 -0800 (PST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id 14sm8473991ejy.11.2021.03.09.06.36.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 06:36:24 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id l11so12666687wrp.7
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:36:24 -0800 (PST)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr27886602wru.327.1615300583787;
 Tue, 09 Mar 2021 06:36:23 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615288658.git.bnemeth@redhat.com> <b07e88b0d023fd7c6f5bbee27ae1cb33e52b9546.1615288658.git.bnemeth@redhat.com>
In-Reply-To: <b07e88b0d023fd7c6f5bbee27ae1cb33e52b9546.1615288658.git.bnemeth@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Mar 2021 09:35:44 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf1RVx4HSyT7PvWfNpz2nYY5qWSf_RtYiejLbSccemQCA@mail.gmail.com>
Message-ID: <CA+FuTSf1RVx4HSyT7PvWfNpz2nYY5qWSf_RtYiejLbSccemQCA@mail.gmail.com>
Subject: Re: [PATCH net v3 1/2] net: check if protocol extracted by
 virtio_net_hdr_set_proto is correct
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 6:32 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
> set) based on the type in the virtio net hdr, but the skb could contain
> anything since it could come from packet_snd through a raw socket. If
> there is a mismatch between what virtio_net_hdr_set_proto sets and
> the actual protocol, then the skb could be handled incorrectly later
> on.
>
> An example where this poses an issue is with the subsequent call to
> skb_flow_dissect_flow_keys_basic which relies on skb->protocol being set
> correctly. A specially crafted packet could fool
> skb_flow_dissect_flow_keys_basic preventing EINVAL to be returned.
>
> Avoid blindly trusting the information provided by the virtio net header
> by checking that the protocol in the packet actually matches the
> protocol set by virtio_net_hdr_set_proto. Note that since the protocol
> is only checked if skb->dev implements header_ops->parse_protocol,
> packets from devices without the implementation are not checked at this
> stage.
>
> Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

This still relies entirely on data from the untrusted process. But it
adds the constraint that the otherwise untrusted data at least has to
be consistent, closing one loophole.

As responded in v2, we may want to look at the (few) callers and make
sure that they initialize skb->protocol before the call to
virtio_net_hdr_to_skb where possible. That will avoid this entire
branch.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D285E2D8AB0
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439921AbgLLXus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgLLXus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 18:50:48 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD49AC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 15:50:07 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id b23so6928565vsp.9
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 15:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ej7uLp8qg8vtsUQu3YaL16iTlQ3vih18bjmBmpZ1QP8=;
        b=HyWE0jTwkhh18+86WFrNME051jixuapo6wVhyO/RO2Zyhw80EXk47zPyEEdbN1PbFM
         dB0fOOBNG1Wmzz2UGIBSH4zeDGAYSPGoaURI5Gv3YFDmvY8fjzOHIQD8rInr9kDlO4P8
         zUwFfAVMO+Q+m2cmVAR+dYnWjE+p2HN4sIOkNwUAVyQKR3ySWeN7SLITKMO8vtcIqjXn
         Wmj+B+0Bm7NUu7ZUq8uw57iJSIxPA1HH+RGgSJInuEIyZip1kauc7JyJdJmeJhrj9tRK
         /GlzKU/2uhgujFeP+nXo+RWfmrvNrgYKrtRiFMv7ezbCibXq6AwqMjZd7lt06KhvdQEU
         4Trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ej7uLp8qg8vtsUQu3YaL16iTlQ3vih18bjmBmpZ1QP8=;
        b=Vh6dCQlbONCG21enNKafGvDEyCNnAsjptStiX+Ch4H8/AtMNRYAjDqGeOXk/HiOx3m
         DJvv4T8ELznzP8eBl6aAIJRclynhZpwUfjsLeYNtbOHa3tvJ231iaIpJpMKCUkDft5pp
         H8fjjqU/Lm4ukmwNNKdU659M3d1eIaX0dWK6A7WbxJLEy0YyfXjmWq1ef5o6T4QV+iyB
         DzdW1B+WvYMoPO0TyLhYieCjfTPDNjv6MVOoUwV4inxCLGnyzZU8Ou233uikQTufPSyi
         8aclixf5IE6xDNj9u339XKa72lS6LL7NVNCnIGeq1JJKJWIHvFU9MCnVtBvUX9E4Qrpr
         8AVA==
X-Gm-Message-State: AOAM530yBmbI/xN9PyVR/9GNC5g7/ghhN3hE4VVMmdKLBpxbFYCSbkph
        MdQV3oHGX1K+yKzm3x4A/sMvcacP2Hk=
X-Google-Smtp-Source: ABdhPJzn35xlKhDskrZVGzXvST5QteLF0d6gSes/5PJgyEyNFE4BLYW3Wos+Qe7SJARBhep4+EGB1g==
X-Received: by 2002:a67:db0b:: with SMTP id z11mr18032046vsj.21.1607817006645;
        Sat, 12 Dec 2020 15:50:06 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id n205sm19933vkf.1.2020.12.12.15.50.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 15:50:05 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id b23so6928527vsp.9
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 15:50:04 -0800 (PST)
X-Received: by 2002:a67:30c1:: with SMTP id w184mr17616262vsw.13.1607817004299;
 Sat, 12 Dec 2020 15:50:04 -0800 (PST)
MIME-Version: 1.0
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
 <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com> <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
In-Reply-To: <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 12 Dec 2020 18:49:28 -0500
X-Gmail-Original-Message-ID: <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
Message-ID: <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 5:01 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> On 12/11/20 6:37 PM, Vasily Averin wrote:
> > It seems for me the similar problem can happen in __skb_trim_rcsum().
> > Also I doubt that that skb_checksum_start_offset(skb) checks in
> > __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
> > becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
> > Could somebody confirm it?
>
> I've rechecked the code and I think now that other places are not affected,
> i.e. skb_push_rcsum() only should be patched.

Thanks for investigating this. So tun was able to insert a packet with
csum_start + csum_off + 2 beyond the packet after trimming, using
virtio_net_hdr.csum_...

Any packet with an offset beyond the end of the packet is bogus
really. No need to try to accept it by downgrading to CHECKSUM_NONE.

It is not ideal to have to add branches in the common path for these
obscure bad packets from virtio/tuntap/af_packet. We try to avoid that
with more strict validation at the source in virtio_net_hdr_to_skb.
Evidently syzbot again found a way past again.

If this is a packet with gso_type and checksum offload, we know the
accepted protocols and can validate the offset. If gso_type is none,
however, no such assumptions can be made. All we could do is try to
dissect and if a known protocol and valid th_off, compare that to the
checksum fields passed by userspace.

So that path is certainly more complex than your fix, which works as well.

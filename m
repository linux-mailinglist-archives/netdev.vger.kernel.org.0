Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8097E34AE61
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCZSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCZSQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:16:13 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB869C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:16:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id e14so9725509ejz.11
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ueDwB6DQpiQpMEgw8Y7yf7N+xd2IqFKtC5xzd+6Moco=;
        b=D3jrQdj5M+e3WNIaIXoDU4ogVk5p04fG7ZvNagJ0JZalpWWct0Usi76pxO9os/BcPt
         vRgO3eVFOGMZjnP1ecFEzmUNqDrMQWa4tltEi34Qc+UoO8I6k8KYv68Ns6dyFetLea/s
         oAbbwXcJfQxf78qrm+eAwfwEvdvCfhn80+RzJGd3gQ2vwyBsXJxuWAPVY5i6ivNGdf9M
         Pe37Ns5WHPbnbXV2XAp/GYEBfX1l9Qcgn1obyvFzMy+/bqzvZ/os8aCnn2LDXMpTvAeH
         44k63HQs44zHpnOaSNDal5ulllBnHjvD88AVxjWYnscG9pRTxAGuLj0hDVrt1MUSVwZj
         trYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueDwB6DQpiQpMEgw8Y7yf7N+xd2IqFKtC5xzd+6Moco=;
        b=bAv/T7hMGQKOXvc08dDQoIxRvUNZYWuIJvaQk7+BJ5uhViCClc3jDLohZer1VRYvsr
         HWOxxqkDhxTovNwQj/riaCkcK34n/dwr0YvSMV1rabWgRd3lZkUZlDooo4OqDHm2DQ3V
         C0n4DwjyXjK2b7ZeMlTSXH7vRq3MihqrH6A3PuAUJCe68HBic5LThrXD0t7zOimfJNP4
         RZaPDOUs81SwiIRjRzYw4yrW5akuvXJm3lys7iiD9ipTCwNIs53T+gOG5THNz/8gXbwe
         lq968eBhHA4dcAcYJrjj2P4RJHFaxNoBmBYdHKy41vMyFtFHNhGhd99Gm91djbicWKaq
         NJ5Q==
X-Gm-Message-State: AOAM531funb1jcpH52FtQhtpSXBoGu3ZLU4I0Auu+/xZoNPhj9fcgtJA
        uM4RV58Ge+VWR+9PWq0pvd0D/vzYCpg=
X-Google-Smtp-Source: ABdhPJzWp/cFErWRigM0Rv4vfapfFszpzhtmowAeq81gMQPnGA9SQMwZekrQ0eFnyYigxCK9jfDwxw==
X-Received: by 2002:a17:906:af91:: with SMTP id mj17mr16390249ejb.230.1616782571127;
        Fri, 26 Mar 2021 11:16:11 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id i10sm4146807ejv.106.2021.03.26.11.16.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 11:16:10 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id x7so6495069wrw.10
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:16:10 -0700 (PDT)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr16099044wrh.50.1616782569637;
 Fri, 26 Mar 2021 11:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <7fa75957409a3f5d14198261a7eddb2bf1bff8e1.1616692794.git.pabeni@redhat.com>
In-Reply-To: <7fa75957409a3f5d14198261a7eddb2bf1bff8e1.1616692794.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Mar 2021 14:15:32 -0400
X-Gmail-Original-Message-ID: <CA+FuTScNjt0dTEHM8WprhDZ5G3H0Y4af4fg2Xqs+eCCrNtHwVA@mail.gmail.com>
Message-ID: <CA+FuTScNjt0dTEHM8WprhDZ5G3H0Y4af4fg2Xqs+eCCrNtHwVA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/8] udp: never accept GSO_FRAGLIST packets
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
> Currently the UDP protocol delivers GSO_FRAGLIST packets to
> the sockets without the expected segmentation.
>
> This change addresses the issue introducing and maintaining
> a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> accordingly.
>
> UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> zeroed.
>
> v1 -> v2:
>  - use 2 bits instead of a whole GSO bitmask (Willem)
>
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

This looks good to me in principle, thanks for the revision.

I hadn't fully appreciated that gro_enabled implies accept_udp_l4, but
not necessarily vice versa.

It is equivalent to (accept_udp_l4 && !up->gro_receive), right?

Could the extra bit be avoided with

"
+      /* Prefer fraglist GRO unless target is a socket with UDP_GRO,
+       * which requires all but last segments to be of same gso_size,
passed in cmsg */
        if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
-                NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
+               NAPI_GRO_CB(skb)->is_flist = sk ?
(!udp_sk(sk)->gro_enabled || udp_sk(sk)->accept_udp_fraglist) : 1;

+     /* Apply transport layer GRO if forwarding is enabled or the
flow lands at a local socket */
       if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
            (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) ||
NAPI_GRO_CB(skb)->is_flist) {
                pp = call_gro_receive(udp_gro_receive_segment, head, skb);
                return pp;
        }

+      /* Continue with tunnel GRO */
"

.. not that the extra bit matters a lot. And these two conditions with
gro_enabled are not very obvious.

Just a thought.

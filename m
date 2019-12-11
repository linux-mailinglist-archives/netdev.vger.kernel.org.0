Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A4211BC5E
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfLKTAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:00:17 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39459 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfLKTAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:00:17 -0500
Received: by mail-yw1-f68.google.com with SMTP id h126so9366605ywc.6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LiYnu/zIEic5PWtCvRDc52iyqPUbIrsp7Fefx1KWNRM=;
        b=tS4db11oCQ99MyPpd7BWu6H1H3aEivbgAqU4tWnn83Y7UgeaYORbCcHuwHlte0L/0i
         TTL4naWxFdT5LJd+GVzh7ccUIP0/w9gSvKNaQnXb8x5sB/uNgg6LkjveU2AmxnrRAqzh
         3VGizdMFYn3Dxj9jf6wVXollv555bfyeid5qZGtzdCHII9oA6FSGkMppQOWEv8uyc73W
         YvnqeTwU7l279aaHny9hoF81G40VwX1RtjwWqFucG9T4sL5jS1ar6ICC6x1SiX/wXUIK
         756/rk69gYs5hhMYsJv8YBigc+JOieJUdcubKkAoA31FXaRZ0dwed1SLx6Je8uCq1VJn
         IZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LiYnu/zIEic5PWtCvRDc52iyqPUbIrsp7Fefx1KWNRM=;
        b=mJEE26EU4koBz5ffxaDZjG4ILuzIxeEmush219Caf6X3zEtDpCIr9hMvYd2jzFreh7
         hrXn/pQiIBluJ2KRtSRHS9ElvBOWE5US4nF2OutOfhSEp2qGOBEXMpA46H97iiaYQ3dn
         RCJg4EiKAYwtTvlVu+jmjumUzOu4XpMyobHvFsJ6+EQSFPQe8KWeCLBVgMP0dl7LZ7Mu
         bMg5qtmeFhM/WXQlzbZlmt+ofEsHhNPtWuawcjIr3yv3Ag6iL1dR70EvoHJrpoiRFZso
         QYvYMIW837Jf7FNNNcXF+gLFwqAQLwV4ziufRqlqVL+3wJEUi9T6AJqFNW/qU4c+0y5X
         MMnw==
X-Gm-Message-State: APjAAAUz78L+x6OHu5Y03jjHZnIcijieX1ojZZjMJvjKMzp9TTLR7FZR
        R+z6KvXdiB0G3hfT84WXlHy22aaq
X-Google-Smtp-Source: APXvYqwXNlODEvMikN/spwnsa2DFGuQ8lKE5PUI4U28u/MPKjb7BxaXxoF9ruIq6NJnuEvsPnf3pUw==
X-Received: by 2002:a81:5c56:: with SMTP id q83mr998313ywb.223.1576090816304;
        Wed, 11 Dec 2019 11:00:16 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id u77sm1496266ywc.70.2019.12.11.11.00.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 11:00:15 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id p137so9440760ybg.9
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:00:15 -0800 (PST)
X-Received: by 2002:a25:208b:: with SMTP id g133mr1138013ybg.337.1576090814496;
 Wed, 11 Dec 2019 11:00:14 -0800 (PST)
MIME-Version: 1.0
References: <83161576077966@vla4-87a00c2d2b1b.qloud-c.yandex.net>
In-Reply-To: <83161576077966@vla4-87a00c2d2b1b.qloud-c.yandex.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 11 Dec 2019 13:59:38 -0500
X-Gmail-Original-Message-ID: <CA+FuTSey4oa-WPRuAu8TAQFDO9e==e-+-SQ2p4237drq8GzOWQ@mail.gmail.com>
Message-ID: <CA+FuTSey4oa-WPRuAu8TAQFDO9e==e-+-SQ2p4237drq8GzOWQ@mail.gmail.com>
Subject: Re: RPS arp processing
To:     Aleksei Zakharov <zakharov.a.g@yandex.ru>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 10:34 AM Aleksei Zakharov
<zakharov.a.g@yandex.ru> wrote:
>
> Hi, everyone
> Is it possible to balance ARP across CPUs with RPS?
> I don't clearly understand how hash is calulated for ARP packets, but it seems that it should consider source and target IPs.

The hash is derived by flow dissection:

    get_rps_cpus
      ___skb_get_hash
          skb_flow_dissect_flow_keys

This calls __skb_flow_dissector with the flow_keys_dissector
dissection program, which is initialized in
init_default_flow_dissectors from flow_keys_dissector_keys.

That program incorporates IPV4_ADDRS and IPV6_ADDRS. But that does not
apply to ARP packets. Contrast case ETH_P_IPV6 with case ETH_P_ARP in
__skb_flow_dissect.

The flow dissector calls __skb_flow_dissect_arp() for deeper
dissection, from which you could extract entropy for RPS. But the
flow_keys_dissector program does not have FLOW_DISSECTOR_KEY_ARP
enabled.

> In our current setup we have one l2 segment between external hardware routers and namespaces on linux server.
> When router sends ARP request, it is passed through server's physical port, then via openvswitch bridge it is copied to every namespace.
> We've found that all ARPs (for different destination ips and few source ips) are processed on one CPU inside namespaces. We use RPS, and most packets are balanced between all CPUs.

I suggest looking at the newer BPF flow dissector, which allows tuning
dissection to specific use cases, like yours.





> Kernel 4.15.0-65 from ubuntu 18.04.
>
> Might this issue be related to namespaces somehow?
>
> --
> Regards,
> Aleksei Zakharov
>

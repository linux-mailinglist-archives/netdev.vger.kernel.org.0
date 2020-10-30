Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2591A29FA0D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgJ3Ax7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3Ax6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:53:58 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD664C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:53:57 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id u16so1712063vsl.13
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uLSWkRy8VIjtD7hvy6eRjmABjuy8kF+uxS4wTZ2vEI=;
        b=oa5P/lAefUQ1SyS6LTC+Ed16fEMFneJX/nOZIpj9zHqp9o99w+1gddX2k0JKQeFDPp
         5avCATPKYrwhcdTIPxjgq/k1UB6GkaAlWgnA6KEqADRFNDGwhhhSTR6w7MnEIlc/lPMS
         7hT3VJ2AKeBpumPrYjdbDk48OcQHMKiMFyX335bTtNEuIy+9ZQ4xAdka5XOXrK0WmvKO
         CSBIZH6skxfxt5Z9mQ/ZQORc3DLt5UXvlCe+fRP+su2igD/k1mX4EzDQaSKaJBFMzSdw
         uNI/41QChcA5Mw2p/DLVEGlbZwuQ6oExqMF4cRbpIuK2/ZAzH09ZDZvdU3Vyb7qJXhzK
         TiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uLSWkRy8VIjtD7hvy6eRjmABjuy8kF+uxS4wTZ2vEI=;
        b=Xf7gt3Fd/ps9EwcTGEZreRwmmG7ixI88pn4Z3qVLzrEe5D9fCYKbU/ZauOvcYS1vRM
         rXYVwrTGC73jNooKLUrmx/ZaaY453crq9aYsH3rIPCT1J5PsBNt8v4l+6bJxmiIsfv6y
         jGRTanqvzYVzebt5L5PXyUXaO9q+uYEjafJmcaoanoWMDUQlna8e2A+lDHnoduE760li
         qjN+b0Ccc2WTwYGlt8js7WlbKR5J6mBx+9Rpy3+8HMgzEwOqPzMwmN/2e7grgI1jgBEG
         QguOQEha83f8zcvkYAQBSqUEi2I/FA2XPFBBlYotJTF3cvJ+JB7knQ7fKhpOGOx3OQo9
         u70Q==
X-Gm-Message-State: AOAM533wRyq5qjlZegDd5/ElYrLpT8aCTr1oo24iWuvOnbx/z2CGT8jc
        gjVlh+AsCkpBD2tFDebUDjoMgh4f91k=
X-Google-Smtp-Source: ABdhPJyAxAUzs35akx7sJVDazxfDyQByGVYTKumDeJlF02s4xHYunltsj+4gmgU3ICqHdEMRL3H0Ww==
X-Received: by 2002:a05:6102:2ef:: with SMTP id j15mr5689959vsj.19.1604019236583;
        Thu, 29 Oct 2020 17:53:56 -0700 (PDT)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id 190sm544520vsz.13.2020.10.29.17.53.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 17:53:55 -0700 (PDT)
Received: by mail-ua1-f48.google.com with SMTP id t15so1265522ual.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 17:53:55 -0700 (PDT)
X-Received: by 2002:ab0:5447:: with SMTP id o7mr42107uaa.37.1604019234952;
 Thu, 29 Oct 2020 17:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201028131807.3371-1-xie.he.0141@gmail.com> <20201028131807.3371-5-xie.he.0141@gmail.com>
 <CA+FuTSeBZWsy4w4gdPU2sb2-njuEiqbXMgfnA5AdsXkNr__xRA@mail.gmail.com>
 <CAJht_EMOxSn-hraig1jnF_KwNsYaCYnwaZvVH7rutdS0Lj0sGA@mail.gmail.com> <CAJht_EPggyhiaROvReNJ4hCwQ6+Z0wf4zHADrSAaT8jBE0J+1w@mail.gmail.com>
In-Reply-To: <CAJht_EPggyhiaROvReNJ4hCwQ6+Z0wf4zHADrSAaT8jBE0J+1w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 20:53:17 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdy38GOTKRr9Ze3jvfTQqxR7s_c67J0z75AFZ-yihAVuw@mail.gmail.com>
Message-ID: <CA+FuTSdy38GOTKRr9Ze3jvfTQqxR7s_c67J0z75AFZ-yihAVuw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: hdlc_fr: Add support for any Ethertype
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 8:49 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 4:53 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > > Does it make sense to define a struct snap_hdr instead of manually
> > > casting all these bytes?
> >
> > > And macros or constant integers to self document these kinds of fields.
> >
> > Yes, we can define a struct snap_hdr, like this:
> >
> > struct snap_hdr {
> >         u8 oui[3];
> >         __be16 pid;
> > } __packed;
> >
> > And then the fr_snap_parse function could be like this:
> >
> > static int fr_snap_parse(struct sk_buff *skb, struct pvc_device *pvc)
> > {
> >        struct snap_hdr *hdr = (struct snap_hdr *)skb->data;
> >
> >        if (hdr->oui[0] == OUI_ETHERTYPE_1 &&
> >            hdr->oui[1] == OUI_ETHERTYPE_2 &&
> >            hdr->oui[2] == OUI_ETHERTYPE_3) {
> >                if (!pvc->main)
> >                        return -1;
> >                skb->dev = pvc->main;
> >                skb->protocol = hdr->pid; /* Ethertype */
> >                skb_pull(skb, 5);
> >                skb_reset_mac_header(skb);
> >                return 0;
> >
> >        } else if (hdr->oui[0] == OUI_802_1_1 &&
> >                   hdr->oui[1] == OUI_802_1_2 &&
> >                   hdr->oui[2] == OUI_802_1_3) {
> >                if (hdr->pid == htons(PID_ETHER_WO_FCS)) {
> >
> > Would this look cleaner?
>
> Actually I don't think this is significantly cleaner than the previous
> version of code. A reader of this code may still wonder what are the
> values of all these macros, and he/she may still want to look up the
> values of them. The comment in the previous version of code has made
> the meaning of these values very clear, and the reader of the code
> would not need to go to another place of this file to find the values.
>
> The struct snap_hdr eliminates a cast, but only one cast. So it might
> not be very necessary, either. Introducing this struct also makes the
> reader need to go to another place of this file to look up the
> definition of this struct. So it does not significantly improve the
> readability (IMHO).

Thanks for coding up an example. Yes, seeing the alternative, I agree.

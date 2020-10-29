Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9355229EEC3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgJ2Ou7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgJ2Ou7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:50:59 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6A8C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:41:17 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id d125so742979vkh.10
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdIxveiwN5+CKo4Oy7ujg8/P9OBop5DoCR8ei8B8tdQ=;
        b=PFfjl+iqAYkVoF5UTWndAYkoxyobD1MZfNzhXpYr0fzN9Hm5boAI7tlGKXhJqFIYwL
         nK/+Ctu2M0+dsW2Q2MDr3QBp2HT2d6MBueftHuILqdud0NO+tMhFbHtHeFYP57RQu+lP
         6gJJ0K4n/zc5TRJTyM/cgl96zQe2PAChHPJ4uwkgnDN9AwPuuMIR+zhn2YcSW2TMdIo5
         XJKIuU0uZdcQXuHuKcncNYtH1GfFYhRDcjIWgh1YKqHDrhkdIpI/OsgsmkmzEEwHCoc9
         Ft4cs7ye5SOFDZb7P3xmNUksBrdPHfjSVjpPC9kUPi/NymaX1pkHB70VZeazn6omwHZW
         mLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdIxveiwN5+CKo4Oy7ujg8/P9OBop5DoCR8ei8B8tdQ=;
        b=lZIINkCXQ/g3DWEOCv4PajlvwRNP1OWFPxrgKX42QQFubGr0Ga+rcDJ9T0E9Bbjvam
         w2RtObwOVVTEdBaSkqTNfi5yqk6MgRaQ1stc+enjUn+At5FSnEx8wesnJFhKuk1MNwGu
         LtJaV0EH/6YtNEzk6FOWWTMcowb3uUAP66fvRaHZXVrxftwwq/xeo6C8yT9/hdr1wBgM
         Q7DJT9FFhaH95RsMiL4klmWG/d2k9fHZsqdkENBEw/fZ/WhcrIKLEMmFU/hGA+8aspLg
         v7jUSwVSza38pilCX9ovO19uaQfz++oRy7oyixFRFJKgdLJ0S2Et0Z4vQ5QRAcEk0OXC
         R1LA==
X-Gm-Message-State: AOAM5300WUukDl8CKltv1aP4mzq5zDrzQ7KNq6aLaFo1yUlp+WMtFuC6
        iyfwsIuyxtHxgY6uZwj7O47V0Bbe83E=
X-Google-Smtp-Source: ABdhPJxFDC/XHsDu6Q8at7yrkEuK5wBOp4qmGFDgh4WYArzJwGJu3ZVmJN64H4Hcq2Dx+dkeJMABmw==
X-Received: by 2002:a1f:2f4d:: with SMTP id v74mr3265128vkv.21.1603982476280;
        Thu, 29 Oct 2020 07:41:16 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id o22sm372471vsr.12.2020.10.29.07.41.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 07:41:15 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id b129so1656563vsb.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:41:15 -0700 (PDT)
X-Received: by 2002:a67:c981:: with SMTP id y1mr3220945vsk.14.1603982474884;
 Thu, 29 Oct 2020 07:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201016111156.26927-1-ovov@yandex-team.ru> <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru> <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
 <ABA7FBA9-42F8-4D6E-9D1E-CDEC74966131@yandex-team.ru>
In-Reply-To: <ABA7FBA9-42F8-4D6E-9D1E-CDEC74966131@yandex-team.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 10:40:37 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeejYh2eu80bB8MikUMb7KevQN-ka-+anfTfQATPSrKHA@mail.gmail.com>
Message-ID: <CA+FuTSeejYh2eu80bB8MikUMb7KevQN-ka-+anfTfQATPSrKHA@mail.gmail.com>
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        vfedorenko@novek.ru, Network Development <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 3:46 AM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>
> On 28 Oct 2020, at 01:53 UTC Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > On Tue, Oct 27, 2020 at 5:52 PM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
> > >
> > > > But it was moved on purpose to avoid setting the inner protocol to IPPROTO_MPLS. That needs to use skb->inner_protocol to further segment.
> > > And why do we need to avoid setting the inner protocol to IPPROTO_MPLS? Currently skb->inner_protocol is used before call of ip6_tnl_xmit.
> > > Can you please give example when this patch breaks MPLS segmentation?
> >
> > mpls_gso_segment calls skb_mac_gso_segment on the inner packet. After
> > setting skb->protocol based on skb->inner_protocol.
>
> Yeah, but mpls_gso_segment is called before ip6_tnl_xmit (because tun devices don't have NETIF_F_GSO_SOFTWARE in their mpls_features), so it does not matter to what value ip6_tnl_xmit sets skb->inner_ipproto.
> And even if gso would been called after both mpls_xmit and ip6_tnl_xmit it would fail as you have written.

Good point. Okay, if no mpls gso packets can make it here, then it
should not matter.

Vadim, are we missing another reason for this move?

Else, no other concerns from me. Please do add a Fixes tag.

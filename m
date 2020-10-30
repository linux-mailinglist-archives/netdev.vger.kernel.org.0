Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF0B2A0C94
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgJ3Re3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgJ3Re3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:34:29 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17DCC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 10:34:27 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id b4so3837362vsd.4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 10:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvhVCk7riDtdonqRh+9lpvUnxEi06OXbYdoz8i3hLzk=;
        b=HZdB/K+6beozJr5DNF0bpn6TlDT1Dh50CGWntbN+MKoqKwsabAcj7ZDNDnuBJrApa2
         znNumtQy7ykbg25NhoI80JjowY4fqdOZtjqVXeivNXGA2a4ztDiK6yXgeJ5EiXDNeqxd
         ZOL2jobi2b+aKZVHlD3wXq/GSeLTLbI1S9RRR6xrMinS25XonL3j1KSYVkhPny1vALBd
         vEcTgBVRPJKJB9ZMl/gGSeEDqRG8JFK54aNY6loKAmCgEuXPz+gVBuPv/AfePLjkuz63
         25wbSs6qAfVzxCTajrO7qQhNhDQDRU0Jky19ZqR0+PoikQtssyGtEKHs1/Qw/zIeJ1DH
         6bFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvhVCk7riDtdonqRh+9lpvUnxEi06OXbYdoz8i3hLzk=;
        b=IZjdSujp2bNr5LWsnUvibFkD/Fa9y2Dm4PvoVcnFwdMx9PCp3q1Jm6SaQJ4TlJhdPM
         C2h7PQEvYTyVfY4Wmzjm54iGFQR/27F2eDyUpeEclwTwHpPU6mtv5J23Df9aDOYx3ogU
         vRWCiFbg0yxIQoC8qBKNtSs44BviR/+eOearjevzOtOvCxGlBfcZNuJ5brz2xs51KGC+
         OEoLRhXTOB7M7OSU6+Pp8yPPHY1g2RGXukghvsKq7hsYCvM/KKPvsGJNLE5zpuFJrKJK
         ua2hm28PKRqlSjrT9myblqTTJk07Hj9zhb3vo/EVktIZJCOxFwiwPWMcsaTE/R1JacVh
         g9zw==
X-Gm-Message-State: AOAM53005bjS+r3djsYY4rB+7MyDlBwSw9TubccUjx6MN8N2XgFr6xzi
        96GiGn7ro1NB04k/abMFJQBiW/MZ8wQ=
X-Google-Smtp-Source: ABdhPJyUGuuO4F+jHiNER9L/p6jvJm0SAKFcCNGrBGpWCH60RougFfycPLVZVn+7Bk7oMvJwXmJR/Q==
X-Received: by 2002:a67:ef5d:: with SMTP id k29mr8426749vsr.33.1604079266439;
        Fri, 30 Oct 2020 10:34:26 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id u185sm800914vke.14.2020.10.30.10.34.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 10:34:25 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id b4so3837298vsd.4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 10:34:25 -0700 (PDT)
X-Received: by 2002:a67:7704:: with SMTP id s4mr7984693vsc.51.1604079264869;
 Fri, 30 Oct 2020 10:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
 <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com> <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
 <ca372399-fecb-2e5a-ae92-dca7275be7ab@solarflare.com> <CA+FuTSdk-UZ92VdpWTAx87xnzhsDKcWfVOOwG_B16HdAuP7PQA@mail.gmail.com>
 <e1765f12-daa4-feb3-28e1-7d360830026d@solarflare.com>
In-Reply-To: <e1765f12-daa4-feb3-28e1-7d360830026d@solarflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 13:33:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf1dGDmRexKR54p=FnEY0LSBCc+tzknfVFTsmX7gk+fpQ@mail.gmail.com>
Message-ID: <CA+FuTSf1dGDmRexKR54p=FnEY0LSBCc+tzknfVFTsmX7gk+fpQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     Edward Cree <ecree@solarflare.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-net-drivers@solarflare.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:43 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 30/10/2020 16:26, Willem de Bruijn wrote:
> > Then you could (as follow-up) advertise without GSO_PARTIAL and avoid
> > the whole transition through the gso layer?
>
> The thing is, non-PARTIAL offload only supports tunnels that the NIC
>  understands (single-layer UDP tunnels), but AIUI GSO_PARTIAL can
>  support all sorts of other things, such as gretaps (though we'd need
>  some more advertised features, I haven't figured out quite which
>  ones yet but when I do and can test it I'll send a follow-up) and
>  nested tunnels (as long as we don't need to edit the 'middle' IP ID,
>  e.g. if it's DF or IPv6).  So we definitely want to advertise
>  GSO_PARTIAL support.
> But possibly I don't need to have NETIF_F_GSO_UDP_TUNNEL[_CSUM] in
>  net_dev->gso_partial_features?

If the device can handle fixing the odd last segment length, indeed.

If you remove them from gso_partial_flags, then gso_features_check
won't mask them out


        /* Support for GSO partial features requires software
         * intervention before we can actually process the packets
         * so we need to strip support for any partial features now
         * and we can pull them back in after we have partially
         * segmented the frame.
         */
        if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
                features &= ~dev->gso_partial_features;

as called in validate_xmit_skb prior to testing whether the packet can
be passed to the nic as is in netif_needs_gso.

Until adding other tunnel types like NETIF_F_GSO_GRE_CSUM, for this
device gso_partial_features would then be 0 and thus
NETIF_F_GSO_PARTIAL is not needed at all?

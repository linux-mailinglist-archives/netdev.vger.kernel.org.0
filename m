Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3153B24BEF4
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgHTNhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:37:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728923AbgHTNgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597930604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJFZdfzFerIu9POmyMKy1vvOc271UPpP8stdY8b9km0=;
        b=LLmqWri9kJnHUbj3LvohZ5B8UZ2yr6OFcA5ohCz7ZlXHhV2u+en11U/+caRr0SB1s88kEV
        prLHMAkX8ncJulNvdXOlK8JqWXD/VoJE2mIe5ZUJ+jUNteiK4PzJF9y5pP+d7C3pwp9mE5
        i/7i7yE2WP18jJ7SdyP8Y3vfO6KGbtE=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-6crcbYf3MPWTEMOKIJ_0yw-1; Thu, 20 Aug 2020 09:36:40 -0400
X-MC-Unique: 6crcbYf3MPWTEMOKIJ_0yw-1
Received: by mail-vk1-f200.google.com with SMTP id b185so445331vka.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJFZdfzFerIu9POmyMKy1vvOc271UPpP8stdY8b9km0=;
        b=Iq4l3joqcNryjlWU0qSrFCNEXNK8FEHZuUAHa3qD6iOhUUc0rhMM76kFq5WzEnjrH7
         51ZewxE27cui2oUmL8DCRuKNSmUzSTLM8CY6AqbChzo7Bi2iqcV40F1kh4H1YvgjcSuT
         AAkzNk5Ne2R0OUVPwAniSaZ85uqFG3Ix3oobtdNlQDr+eD77PK3Uw8YbeBmF9fnPu412
         07WFYuGnXyJaVz8IkZ/YNc7A5bfmDwuxZjRfzCaKXoaNuvAMZDp/Bai4IxjNaaYxfV0r
         d+nga77yspi0AZO4mhv9fT5BX62svw5pKu11/1BxfNn8Usn5Q00NIMiGmABp4KQuJgzH
         kBIg==
X-Gm-Message-State: AOAM533l/RxKo7O/y2h05/4lvVi3AOeN2IywYzGj1PZTphSKSUbk/v8W
        GpeG1pXiVzkvIZpRmL+gjQOObH1NdPrm6+m29q3tKhYuhu+hmZDdO1dcWSARLTSG0pvbDrBRjzk
        fmW3c2OgkqSeMCdn6g/jFDpOtFUr5DeNF
X-Received: by 2002:a67:fd17:: with SMTP id f23mr1661793vsr.161.1597930600478;
        Thu, 20 Aug 2020 06:36:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3esja4NRlaAgbmQLfQyoOhLU9wonUoDgOOH0wJbsBKP92LWYMPOrmrXG5ZLffHaPBPmZYhAtDALk+Hpk3hks=
X-Received: by 2002:a67:fd17:: with SMTP id f23mr1661777vsr.161.1597930600267;
 Thu, 20 Aug 2020 06:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597842004.git.lorenzo@kernel.org> <20200820151644.00e6c87c@carbon>
In-Reply-To: <20200820151644.00e6c87c@carbon>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 20 Aug 2020 15:36:29 +0200
Message-ID: <CAJ0CqmWGmPf8WDr0ofejFJZVaVWubeh9GNBYjusqLfLqBd6NFA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] mvneta: introduce XDP multi-buffer support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
>
> General issue (that I think must be resolved/discussed as part of this initial
> patchset).

I was thinking about this issue as well.

>
> When XDP_REDIRECT'ing a multi-buffer xdp_frame out of another driver's
> ndo_xdp_xmit(), what happens if the remote driver doesn't understand the
> multi-buffer format?
>
> My guess it that it will only send the first part of the packet (in the
> main page). Fortunately we don't leak memory, because xdp_return_frame()
> handle freeing the other segments. I assume this isn't acceptable
> behavior... or maybe it is?
>
> What are our options for handling this:
>
> 1. Add mb support in ndo_xdp_xmit in every driver?

I guess this is the optimal approach.

>
> 2. Drop xdp->mb frames inside ndo_xdp_xmit (in every driver without support)?

Probably this is the easiest solution.
Anyway if we drop patch 6/6 this is not a real issue since the driver
is not allowed yet to receive frames bigger than one page and we have
time to address this issue in each driver.

Regards,
Lorenzo

>
> 3. Add core-code check before calling ndo_xdp_xmit()?
>
> --Jesper
>
> On Wed, 19 Aug 2020 15:13:45 +0200 Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > Finalize XDP multi-buffer support for mvneta driver introducing the capability
> > to map non-linear buffers on tx side.
> > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify if
> > shared_info area has been properly initialized.
> > Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> > Add multi-buff support to xdp_return_{buff/frame} utility routines.
> >
> > Changes since RFC:
> > - squash multi-buffer bit initialization in a single patch
> > - add mvneta non-linear XDP buff support for tx side
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>


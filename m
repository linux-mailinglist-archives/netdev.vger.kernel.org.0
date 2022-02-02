Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662C54A6DF1
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245514AbiBBJiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:38:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244330AbiBBJiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:38:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643794704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2cPtzmwcNByN4PCoCcRY3DUcgzXe8IfxPSgJS/JZS8=;
        b=OoV/blA4GgwpWYV10sQTDR1ihofKdFdhEkMeZdM7BR6UTHkVuQvYuanRWc5RXLr6qTLfEv
        6yT6bGc5bdTKPb2NRramVbTHcbjcYNhnI+wtN30BjkLFci/RsCWuIfnOBjslbJ+P9ZGkMA
        wmha+cS7qJ5HENxF28QEdqnUBwd3tWE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-e-dLbTczMraiMBohkfU0Rg-1; Wed, 02 Feb 2022 04:38:22 -0500
X-MC-Unique: e-dLbTczMraiMBohkfU0Rg-1
Received: by mail-wm1-f69.google.com with SMTP id bg32-20020a05600c3ca000b00349f2aca1beso2235970wmb.9
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 01:38:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=I2cPtzmwcNByN4PCoCcRY3DUcgzXe8IfxPSgJS/JZS8=;
        b=uInhci6Jrw3R3KrIF0+sdosCImoBkpS2rdcGawS4yXqhz2ZD3UQMXX/oO+e3q9x9DU
         mNRbUdO1XlQGk0nulr5si47VXDzuUH9xLpqu73HX4bQjXZbV7mrzIK6hi37MAqlfXj64
         jF/pkMM+gNz+xrK+AQI+C2a2cBLt4fE0qe8WIo2jeXpGc9C93pHxqVq7YhmlxozRSmCx
         FnIYBhyzw5qcNeuT9q31YZqOtTtf3wdfjb+MaDKHd3NVy7eGm+NUcMBTL+TjnTqYeCxG
         Vue9IjDn4Apn0TkAO4xzVwwmdzLC5smiGKeN19g5qdeZMGuivvEryeD2Iidf0OlL+PbO
         tnnQ==
X-Gm-Message-State: AOAM530qEFP7VmN2D6tU3IVpsWkgITuSgVoMaJsn//EZXlQ/KeiXz+g4
        Pq686Ej0Hisx+floB6J+rBQOSI3nYVbK36hzEEHk6tc8ZJZ/2CVgABUMrIx89/DS5+Y/9Dr7MW7
        VW2oZJqQxLq/tQk/B
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr5313626wmh.157.1643794701697;
        Wed, 02 Feb 2022 01:38:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4k5MAWPtq2rSkBx+i2ImrcT2Nm7MhY2ngR9AZWie5KTkOgJV3LwsvJbANCB0K4zq33Wl5TA==
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr5313609wmh.157.1643794701478;
        Wed, 02 Feb 2022 01:38:21 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id bi18sm3775136wmb.20.2022.02.02.01.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 01:38:21 -0800 (PST)
Message-ID: <dea6da64eec5fd0ad780128bb2e76da94e416789.camel@redhat.com>
Subject: Re: [PATCH net] tcp: add missing tcp_skb_can_collapse() test in
 tcp_shift_skb_data()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Davide Caratti <dcaratti@redhat.com>
Date:   Wed, 02 Feb 2022 10:38:19 +0100
In-Reply-To: <62ad3eb-cbb6-a59e-f5fe-5c439d21e760@linux.intel.com>
References: <20220201184640.756716-1-eric.dumazet@gmail.com>
         <CACSApvZ8vXXJ_zKf_HpoVgACwWxS2UvBw9QCv1ZnPX9ZpF3D_g@mail.gmail.com>
         <62ad3eb-cbb6-a59e-f5fe-5c439d21e760@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-01 at 12:01 -0800, Mat Martineau wrote:
> On Tue, 1 Feb 2022, Soheil Hassas Yeganeh wrote:
> 
> > On Tue, Feb 1, 2022 at 1:46 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > 
> > > From: Eric Dumazet <edumazet@google.com>
> > > 
> > > tcp_shift_skb_data() might collapse three packets into a larger one.
> > > 
> > > P_A, P_B, P_C  -> P_ABC
> > > 
> > > Historically, it used a single tcp_skb_can_collapse_to(P_A) call,
> > > because it was enough.
> > > 
> > > In commit 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions"),
> > > this call was replaced by a call to tcp_skb_can_collapse(P_A, P_B)
> > > 
> > > But the now needed test over P_C has been missed.
> > > 
> > > This probably broke MPTCP.

Indeed it looks like it could cause MPTCP data stream corruption, in
case of multiple substreams, if we hit this code-path. Thanks for
catching and fixing it!

> > > Then later, commit 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
> > > added an extra condition to tcp_skb_can_collapse(), but the missing call
> > > from tcp_shift_skb_data() is also breaking TCP zerocopy, because P_A and P_C
> > > might have different skb_zcopy_pure() status.
> > > 
> > > Fixes: 85712484110d ("tcp: coalesce/collapse must respect MPTCP extensions")
> > > Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > > Cc: Talal Ahmad <talalahmad@google.com>
> > > Cc: Arjun Roy <arjunroy@google.com>
> > > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > > Cc: Willem de Bruijn <willemb@google.com>
> > 
> > Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>
> > 
> > I wish there were some packetdrill tests for MPTCP. Thank you for the fix!

Do you have by chance a drill for the zero-copy case? it may help
creating the MPTCP one, too.

Thanks!

Paolo


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF95D4FADF9
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiDJM47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiDJM46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:56:58 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B065C1BE8D
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 05:54:47 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id d3so9581998ilr.10
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 05:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axXWXIW4nKB+e9Ya+pJRTZmLVaPnsXCtOxK3jLG9vIQ=;
        b=lcVCw8EyS1oA6R8n36ZGGlEGi41md6pmZhHZrz703VrvW9REt/OHnjqeB73igmiW2/
         p9IvVod9/abuwaSa6pX5Q8M0NKq+r1dANmKe+1gOAla+HOrJ2jz2QGmKJAFQK4c8WnEW
         D1ftd2j98nVOSkijsxI9BdguMDFteEnxgcuhaxRRcYdS6T+6VsIRcejFhkFfA1lSaBke
         D3wbzjXvykAMjkJp7HHdnwwdPki2R1tmRPvMP1onHNo42uG7XV9aaFqQt9pYkC6HKneh
         z3BMBSRoAzUBwM4AgOr2v+zv8lVON0XcNaoOIVoNlBYFaRhOWIJsabvx3J6J4PX3ZdoG
         GBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axXWXIW4nKB+e9Ya+pJRTZmLVaPnsXCtOxK3jLG9vIQ=;
        b=DdcnfMRvVzli9jFJC7fUINutkT2tnqND+VeWgoDFz21yv0MQx0BN1n1vs3ln9kso+M
         MoJKRV9FLwiA4a2LE/CTkC1KI/rUB7D+P2uNv+YR/WADL+aazlgUiGnbPmI27n272w3U
         bNtVoNmjNxpgPkGK+EQJS+c+tEGlX0f5oOeBcHN84gNsDvEPNea2dqnSCYjq93skaUea
         I27N4LIz8xlMWSqqYUjmXQYA4GHLUv4tkygF/T6k6Jt24XRiGLMTKG8yoUUBUcf2dJTB
         vZZj6rTQ9GbnCUVq1kjHOPT947stIo48o2qviqhtKEPqV69gllHMFWSL7f7/UVIyz+DE
         qzTg==
X-Gm-Message-State: AOAM531U8wD2fAmnm2he7JcNtJxTuhLg9WTYChBiuaZhlqFMbTJbi5KH
        WS4OmFmw7wZErZqXfPZvowPF4kbdk0jLXU5KRrDVqA==
X-Google-Smtp-Source: ABdhPJx5IXqBqX87SVqD4hlXY+29wy57joUBpSFM8qn4ftKTlUE4ip+byHsM2JzIrjPtOjIDxevaEqbfil35UMT2j/M=
X-Received: by 2002:a05:6e02:2190:b0:2ca:6d85:4ca1 with SMTP id
 j16-20020a056e02219000b002ca6d854ca1mr9010678ila.141.1649595286998; Sun, 10
 Apr 2022 05:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com> <20220410072930.GC212299@hoboy.vegasvil.org>
In-Reply-To: <20220410072930.GC212299@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sun, 10 Apr 2022 14:54:36 +0200
Message-ID: <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -887,18 +885,28 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >       if (shhwtstamps &&
> >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> > +             rcu_read_lock();
> > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
>
> __sock_recv_timestamp() is hot path.
>
> No need to call dev_get_by_napi_id() for the vast majority of cases
> using plain old MAC time stamping.

Isn't dev_get_by_napi_id() called most of the time anyway in put_ts_pktinfo()?
That's the reason for the removal of a separate flag, which signals the need to
timestamp determination based on address/cookie. I thought there is no need
for that flag, as netdev is already available later in the existing code.

> Make this conditional on (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC).

This flag tells netdev_get_tstamp() which timestamp is required. If it
is not set, then
netdev_get_tstamp() has to deliver the normal timestamp as always. But
this normal
timestamp is only available via address/cookie. So netdev_get_tstamp() must be
called.

Thank you!

Gerhard

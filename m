Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400A66A6C9A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCAMv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCAMv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:51:28 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAE5136EC
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 04:51:27 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id i12so8215014ila.5
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 04:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677675087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mW+jBsU/XyUGPMqkN70SNtcytc4P1G9QTjSqRsLhK+w=;
        b=Aypo8XJ+ClHe34J3jcqic3RTa/bBqc5GgjhduzYDeSy7ESIpl21lnh0yW4FyUu0jYo
         XeimMIoWcv5Iib7Cz4Cd0Bf+/fPLaSwHHkZGZbJMcFdN1zuoSKzmblho4nouWesQPJZv
         Lb4WzTPjjgHk+rtMBJYUYoiNmvoxcAlfYSPqNo/q0QDAHlLJef7uVV2E4HhsQr0E33xW
         ONlI1wS3yzDXp9RTa8X+VpwQy6k0bIgXlLma17/v36Ui3BnInUhLHWkGdvNzbDieU/Mu
         LFwT/LhR+MfaBknrj8HgQ+gMJrj6WXbYh520IowwasZDHJawQ4NoQEKk7bs/8VlpTADC
         Yuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677675087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mW+jBsU/XyUGPMqkN70SNtcytc4P1G9QTjSqRsLhK+w=;
        b=h6koGHysDL5tIYTn8KvSVOZeKqrGrjaVWUgNUsr4q1xvWIagTVosGYqbu3ecN1B80L
         4ujJh4W1aqlywssiTYTqU40p8zYUkULHvJXRqe0tj7zQmgPAJt13rOwxEfOWefTxu4eN
         tJqCc2nVvEtWe3Lr2uPUS8TbVj32VRoNZWTJ028/FiH42wI8n/0DILExT6iCvKMvEXAF
         FikIudCrv8rCLSBnTEGFUR0o3UakHR6l0J5G2dl7dXzGgt+r5RH8AS7f0uDdjn7lMwQ+
         SvxOco6Lw2fVzsFYrr1QrNDq6v9MQuncNGqNbSQo3WIe+UjvOtIOSCc3L85apVi3Lol7
         3pdA==
X-Gm-Message-State: AO0yUKUM6Q23An0Wmu+CEkD+j9WXjqVgQufHI5Y2mqOtgwXjoB/zbmjO
        EJL7cn+k3CsscfXfS3CyIu8cUTva4iv5dQ1vRZXtew==
X-Google-Smtp-Source: AK7set+jvNsPiRGZsjykiEA+x/tq31AJ/T+TSw18qU/mi1XV83/a5QO56Gc1wmrrGmwCbrd3UoNqAPoQb/FhoLHw9+Q=
X-Received: by 2002:a92:710a:0:b0:310:d631:cd72 with SMTP id
 m10-20020a92710a000000b00310d631cd72mr3010747ilc.2.1677675086782; Wed, 01 Mar
 2023 04:51:26 -0800 (PST)
MIME-Version: 1.0
References: <20230224184606.7101-1-fw@strlen.de> <CANn89iJ+7X8kLjR2YrGbT64zGSu_XQfT_T5+WPQfheDmgQrf2A@mail.gmail.com>
 <CANn89i+WYy+Q1i1e1vrQmPzH-eDEVHJn29xgmsXJ8uMidP9CqQ@mail.gmail.com> <20230301123114.GA6827@breakpoint.cc>
In-Reply-To: <20230301123114.GA6827@breakpoint.cc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Mar 2023 13:51:11 +0100
Message-ID: <CANn89iK7eugDqgW=GO5gZS3=-O28bCGkgTKQ+OPs90oWkqCNkw@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
To:     Florian Westphal <fw@strlen.de>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        shakeelb@google.com, soheil@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 1:31=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Eric Dumazet <edumazet@google.com> wrote:
> > BTW I was curious why Google was not seeing this, and it appears Brian =
Vasquez
> > forgot to upstream this change...
> >
> > commit 5ea2f21d6c1078d2c563cb455ad5877b4ada94e1
> > Author: Brian Vazquez <brianvv@google.com>
> > Date:   Thu Mar 3 19:09:49 2022 -0800
> >
> >     PRODKERNEL: net-directcall: annotate tcp_leave_memory_pressure and
> >     tcp_getsockopt
> >
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 05032b399c873984e5297898d647905ca9f21f2e..54cb989dc162f3982380ac1=
2cf5a150214e209a2
> > 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -2647,10 +2647,13 @@ static void sk_enter_memory_pressure(struct soc=
k *sk)
> >         sk->sk_prot->enter_memory_pressure(sk);
> >  }
> >
> > +INDIRECT_CALLABLE_DECLARE(void tcp_leave_memory_pressure(struct sock *=
sk));
> > +
> >  static void sk_leave_memory_pressure(struct sock *sk)
> >  {
> >         if (sk->sk_prot->leave_memory_pressure) {
> > -               sk->sk_prot->leave_memory_pressure(sk);
> > +               INDIRECT_CALL_1(sk->sk_prot->leave_memory_pressure,
> > +                               tcp_leave_memory_pressure, sk);
> >         } else {
> >                 unsigned long *memory_pressure =3D sk->sk_prot->memory_=
pressure;
>
> re-tested: this change also resolves the regression i was seeing.
>
> If you prefer to upstream this instead of the proposed change then I'm
> fine with that.

This seems a bit less risky, if the plan is to add this to stable trees.
( We had this mitigation for ~4 years at Google)

I will rebase Brian patch (only the tcp_leave_memory_pressure part) and sen=
d it.

Thanks !

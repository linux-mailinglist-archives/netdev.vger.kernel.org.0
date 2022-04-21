Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD9550AA8A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 23:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441822AbiDUVRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 17:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441826AbiDUVR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 17:17:29 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5762B49FB4
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 14:14:39 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id f38so10998925ybi.3
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 14:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPBcza1h+Vp/v42wnVpnwU3Z/rSglRcIKNledeTlbnM=;
        b=E9zlGioI4jcEwl3fSPCOB9xIqg/uJRbJK4PmwZdDRPnVww5Hy9ckCU5tVyjLiBnFLm
         9TB7TT2G6vNvCHTnFwTwiL2PbHl4VgcEn91Oq8dDE6NQ9LsvXll7/xzt3xn0HQqfjlHE
         oZ9Rjr71v6tlkHprVnxwHs5dcOL51TRCfE60MXoTz0ZapVUikyJ0wnTx0i+AE4SiTx7u
         jEMvdI5+lJzbNbz/pqzVeSEwBsYGbbkUvbN1ULFRtW0T9SGkadPvkxqYCNRcs+i7Rm7f
         3PCfZKQZN2bVJReOp4ls0/pv4bhMA5tGOWslWkXAtGKyX749Bf/1p9hFHWkunsWX5OyW
         MDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPBcza1h+Vp/v42wnVpnwU3Z/rSglRcIKNledeTlbnM=;
        b=Gf7lzLJ785CEGRaYCIYsnGH8LV7swkXThruY+yzXjuU0ZO/vt1+4pTRfd1jppERQdG
         vBeZ/Zdhl36XTFqBTcN7XVvikIxvPp37w+2EfScblZhedW1rbzBcdZxb2aeBCBwG1sC+
         lq42H7nK6Y1lSz1lt1OqgLynTq98+lHRENHfSyxhSyPtOxCnA7eLdQrVvgh+qjcdCyVw
         kECBAsoff+kUnNCUWSvITWIvoRRmVR5HhiYaelA+CTgdvN9G/vwiB+9BtGvo+A2bGgGM
         ProZ9DQPZiH7suXtMFThhDAXXzAu1kwSPFwpp7WNT0qInKgLAPh2zUf4XqTEF6NVW1M6
         k25g==
X-Gm-Message-State: AOAM530FXq38fS2rG15cbuF0pc8qFDT+CLXm94l4Wu+c3fyYOR/oWMC1
        lnasgvVQG0nEWxBYoc67KqplLcZ0LnIs/e1el0Xpcw==
X-Google-Smtp-Source: ABdhPJwlIqBk1ViH4MgEwOz7z/evHFHZ2VHe049H55SZGMgvaA4njKtyonJ4XNRhRsuWtqtCQXnt3K1LE51PIfNobuw=
X-Received: by 2002:a25:3009:0:b0:63d:b1c1:e8e2 with SMTP id
 w9-20020a253009000000b0063db1c1e8e2mr1674413ybw.387.1650575678316; Thu, 21
 Apr 2022 14:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za> <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
 <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
 <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
 <20220406135807.GA16047@breakpoint.cc> <726cf53c-f6aa-38a9-71c4-52fb2457f818@netfilter.org>
 <20220407102657.GB16047@breakpoint.cc> <9c6d2d7-70b-bd12-ee14-7923664afb1@netfilter.org>
In-Reply-To: <9c6d2d7-70b-bd12-ee14-7923664afb1@netfilter.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Apr 2022 14:14:27 -0700
Message-ID: <CANn89i+v8niaz5ijpkd_XAbRqXSRBUt-nb43HN=11jkPZmOWog@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Neal Cardwell <ncardwell@google.com>,
        Jaco Kroon <jaco@uls.co.za>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Apr 7, 2022 at 5:48 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> On Thu, 7 Apr 2022, Florian Westphal wrote:
>
> > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > I'd merge the two conditions so that it'd cover both original condition
> > > branches:
> > >
> > > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > > index 8ec55cd72572..87375ce2f995 100644
> > > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > > @@ -556,33 +556,26 @@ static bool tcp_in_window(struct nf_conn *ct,
> > >                     }
> > >
> > >             }
> > > -   } else if (((state->state == TCP_CONNTRACK_SYN_SENT
> > > -                && dir == IP_CT_DIR_ORIGINAL)
> > > -              || (state->state == TCP_CONNTRACK_SYN_RECV
> > > -                && dir == IP_CT_DIR_REPLY))
> > > -              && after(end, sender->td_end)) {
> > > +   } else if (tcph->syn &&
> > > +              ((after(end, sender->td_end) &&
> > > +                (state->state == TCP_CONNTRACK_SYN_SENT ||
> > > +                 state->state == TCP_CONNTRACK_SYN_RECV)) ||
> > > +               (dir == IP_CT_DIR_REPLY &&
> > > +                state->state == TCP_CONNTRACK_SYN_SENT))) {
> >
> > Thats what I did as well, I merged the two branches but I made the
> > 2nd clause stricter to also consider the after() test; it would no
> > longer re-init for syn-acks when sequence did not advance.
>
> That's perfectly fine.
>
> But what about simultaneous syn? The TCP state is zeroed in the REPLY
> direction, so the after() test can easily be false and the state wouldn't
> be picked up. Therefore I extended the condition.
>

Hi Jozsef and Florian

Any updates for this issue ?

Thanks !

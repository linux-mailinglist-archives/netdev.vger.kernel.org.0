Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168FE5EDB8A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiI1LQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiI1LQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:16:15 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48593A8964
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:16:13 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id e187so15484883ybh.10
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=O096xr/QHvreBPM0O9FOqDkIoYKXG2ffLzpNQcHrCYM=;
        b=CfgV7ak4zcqFbD8KP5xLWiE1iDdSZpnfnXB/IMQWGo00UuJPDF3otyxkRMG6I56z3b
         nPD8R8c9+oZP/1AdYW0g0yjNgzPhSM6BXEjO+uozry4PcfUrw1qPhln8nYQFValT97Na
         5m50fEikp51qIbiDRSANXUpzq10tlx3lGe10L3QIY1B9MOTjhd6dNldmqlq1p71plMBM
         G4EV8+8flRGICiLJmsl5YXnMe1LHA5tjp/QWZlUhMVm604rPVjtZZATZ6tUyZrBeJKqu
         VRq65kbq1tuXkzHcuccUTnbQfxg5MhYNmFvdGtIYyQcxDj0bNPwE2jiAoeq6HSoS0mov
         mNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=O096xr/QHvreBPM0O9FOqDkIoYKXG2ffLzpNQcHrCYM=;
        b=xvSz6q+oQkH3yBF+pKosrfBRgmXIsPO38PtSVBVsRdKGEEy1p6D0m2ZMM1kFL0ckop
         MkYqtA5Y8lO10z0aSamUiR0nKB7enS2V0/N1hdkm/wXjuWXpflfkMMziFHhlHKd1ibAG
         q0Wwn32b7P8LzZ/nKHHaW5RA2ERKJuAm0kcw/fVT/o6mvQ/oZ3GAPAHOhn5g3A8ux+5l
         gMrK9x5S4nM7rGKkDtxwAltYkN2bquUasIUVFlB0E4r8WA1vZZyWgLzv7vO4wAGuY2Nv
         xziVBBMeJCZakVPW7BXwsjxzG0A9KjgNYjHYuemaqW1C73cmbLifLYBVepV3URLNGqOC
         rHzA==
X-Gm-Message-State: ACrzQf1Wwid8k3GFYsJJ8+GBf8c+C82S1inhDFyEzl3mM3q/+lx/TlpW
        jW8wqVzUrOantcoT/X/BfvAD/rlGxUBsqYlelGuiI1PWcPFzwg==
X-Google-Smtp-Source: AMsMyM7i1UucxgkRbURsxHtZVpLq1dMe6htFguoPCR7ghmbllxJpnAta+zkMwpW9TrLg5scLjVpvPZx1UcsS15XRY0c=
X-Received: by 2002:a05:6902:1143:b0:6af:1696:9730 with SMTP id
 p3-20020a056902114300b006af16969730mr31451588ybu.250.1664363772267; Wed, 28
 Sep 2022 04:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220927002544.3381205-1-kafai@fb.com> <CANn89iLdDbkFWWPh8tPp71-PNf-FY=DqODhqqQ+iUN+o2=GwYw@mail.gmail.com>
 <6afbe4af-ada1-68df-4561-ca4fb45debaf@linux.dev> <CANn89iJt4JjfmauHGrxeKGjY84Z1Gt1Feao6NwU9AFfSQRW9eg@mail.gmail.com>
In-Reply-To: <CANn89iJt4JjfmauHGrxeKGjY84Z1Gt1Feao6NwU9AFfSQRW9eg@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 28 Sep 2022 13:15:35 +0200
Message-ID: <CAG_fn=WrikVwpx_Z7DhqaPyw3OvQYmR49kH2H4+5fzAtmdtK_g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Fix incorrect address comparison when
 searching for a bind2 bucket
To:     Eric Dumazet <edumazet@google.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
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

On Wed, Sep 28, 2022 at 7:07 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Sep 27, 2022 at 9:46 PM Martin KaFai Lau <martin.lau@linux.dev> w=
rote:
> >
> > On 9/27/22 8:49 PM, Eric Dumazet wrote:
> > > On Mon, Sep 26, 2022 at 5:25 PM Martin KaFai Lau <kafai@fb.com> wrote=
:
> > >>
> > >> From: Martin KaFai Lau <martin.lau@kernel.org>
> > >>
> > >> The v6_rcv_saddr and rcv_saddr are inside a union in the
> > >> 'struct inet_bind2_bucket'.  When searching a bucket by following th=
e
> > >> bhash2 hashtable chain, eg. inet_bind2_bucket_match, it is only usin=
g
> > >> the sk->sk_family and there is no way to check if the inet_bind2_buc=
ket
> > >> has a v6 or v4 address in the union.  This leads to an uninit-value
> > >> KMSAN report in [0] and also potentially incorrect matches.
> > >
> > > I do not see the KMSAN report, is it missing from this changelog ?
> >
> > My bad. Forgot to paste the link in the commit message.  It is here:
> >
> > https://lore.kernel.org/netdev/CAG_fn=3DUd3zSW7AZWXc+asfMhZVL5ETnvuY44P=
myv4NPv-ijN-A@mail.gmail.com/
>
> I see, thanks.
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Alexander Potapenko <glider@google.com>

Thanks!


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

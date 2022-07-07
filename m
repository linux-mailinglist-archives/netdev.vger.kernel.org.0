Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78D56A873
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiGGQlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbiGGQll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:41:41 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14A55A2C4
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:41:35 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id c7so7248940uak.1
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 09:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N+xFgu7NddB/hxaGVW26AvTFITIQQoXvrDrXynFZGXk=;
        b=jay7gjXL3LkFVnAaXcH/GvsbxPVitqYwf0wBsHou0LYAx0TsOFlFmCRGRXCxeNiif7
         +/q/qyZFOZTNJUUjugA5rPcZQND+gJxcjUO0zXiT6Dg6s05IIp/Zfaz933KxZZw/FZu2
         o2sKPDdX2Lxy0pGjqQEsYuR1vB+snLL2+g2H52og6j90piDNmrfsa+s8EdixCE2htXys
         uBRFvrs8gpU9dFIgrNzq+pu4LKOZYgn/egoQK5A+JbRN9dBlUq9+HUA4EWUqlK2AEoPe
         CO/DZG5SQ8t03Zs07GW8LlbbZIwZ924q4YiOjr4csHefKt4xbkArQEEpt0c6ntY8tdM0
         bpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N+xFgu7NddB/hxaGVW26AvTFITIQQoXvrDrXynFZGXk=;
        b=KBPgZ8mgsOwkH6JL//yw8sTLBgmtOUMJyc63Q41lptVe7aYy7eFrOGxmJxanOBFZbH
         hYX/3OPKLq3q3D4vteM5XWWe7ZKRJXK+imR/E/6gmOKzUrb2jGSXTCnDCRBI1MDM/f4u
         GPQjdr4/A1PoOhqzKqlWxPZ2s5bHGHe4LIeL/aA5PyS/OcM5u3NjIspUeGdIGgsln8hc
         W9KPiy37rJb4Z+HIAsd7WyszGPCLqOhlTVE8X+Ay+VYJTqiZ8Wa3p6YesmfuH3xnSYf/
         WPn5dKUbsK5m+glyiU8NEtaq72tcOJ6som3XzABcsrakWF85kA7mCj44aBQ0OWfjP4Qv
         WW1Q==
X-Gm-Message-State: AJIora+NMSgXkv7OcSHDr3cgaL71E7TPWq9/mJXlcU6za/jRkwN5/Del
        7sIS6lxgswDB/TeaBSCSb3HMzSf2KTG8DQG63Mo=
X-Google-Smtp-Source: AGRyM1tVTfZOHY/GhvizBecstAemlIGMIl2GeKRbupgzoEVS4a7y8VfInzEXOgmlPZE1Kpiz75+FcdTuyTowdGXDW6Q=
X-Received: by 2002:ab0:6dc9:0:b0:382:c1da:3e56 with SMTP id
 r9-20020ab06dc9000000b00382c1da3e56mr8673659uaf.123.1657212094817; Thu, 07
 Jul 2022 09:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
 <20220622171929.77078c4d@kernel.org> <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
 <20220623202602.650ed2e6@kernel.org> <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
 <20220624101743.78d0ece7@kernel.org> <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
 <20220701183151.1d623693@kernel.org> <20220701184222.34b75a77@kernel.org>
In-Reply-To: <20220701184222.34b75a77@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Thu, 7 Jul 2022 19:41:23 +0300
Message-ID: <CAJGXZLj2pMki+88OO_fDf-KO1jehEKWg2m5yKTeB0K4yKuMmmg@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, kuznet@ms2.inr.ac.ru,
        xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 2, 2022 at 4:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 1 Jul 2022 18:31:51 -0700 Jakub Kicinski wrote:
> > On Tue, 28 Jun 2022 18:18:27 +0300 Aleksey Shumnik wrote:
> > > pre-up ip tunnel add mgre0 mode ip6gre local 4444::1111 key 1 ttl 64 tos inherit
> >
> > I can't get GRE6 tunnels to work as NBMA net at all.
> > AFAICT ip6gre_tunnel_xmit() takes the endpoint addresses straight
> > from the netdev, only ip6tnl seems to be doing a lookup.
> > Am I doing it wrong?

What exactly is the problem, may you describe it?
Have you added entries to the neighbors table?

> If it's just v4 could perhaps be commit fdafed459998 ("ip_gre: set
> dev->hard_header_len and dev->needed_headroom properly"). Would you
> be able to try some kernel older than 5.8?

I'll try.
dev->hard_header_len and dev->needed_headroom are set properly, but
the problem remains.
The problem with v4 is that the ip and gre headers are created 2 times
(1st in ipgre_header() and 2nd in gre_build_header() and
iptunnel_xmit()), they are overwritten, so that there is one gre and
one ip header in the packet.
Why take unnecessary actions if it could be created once.
v6 has the same problem, but also the packet has 2 same ip6 and gre
headers, duplication occurs, that is, they are not overwritten as in
v4.
v6 doesn't even have dev->hard_header_len.

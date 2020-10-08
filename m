Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4FC287E10
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgJHVfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbgJHVfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:35:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA3EC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:35:54 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id k8so5082531pfk.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oheKvah+2lx/nMXJ+9fN0O3BVpVSIvVbxBo55jA872M=;
        b=uAOTS1qkmTQ2A9ub099/J55F+68N+LHKPA5vFDAH7MlhFvw14FoxffhzBOJbIZ40br
         2A9PsZFaknbBztfgrt+BeCfVxi6b4dq+HOc6K6xiSAxnOcRuJDKneiBUXbZGfXpnVV4Y
         pJSgZXw0m2vJYTOpgp35yLMHgSlwFC/Dxl30jglbRysQrGq+IXnu6N7+JYEEk+7BdXA0
         3OrW21mXX5NfA21UKUWTL4+iETAy0OPxa5Ua6/avvsXRpT2NoC2Fqh8b0DJKYDzH5yOX
         VLsIiAVdLSyJNT9XTazNZEdDokRRofuTK5/MUxwIpn+one3ZXsifriBjzwpe+oI38hgk
         jamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oheKvah+2lx/nMXJ+9fN0O3BVpVSIvVbxBo55jA872M=;
        b=Mro50FPgc//dHEft3r+m/EMGMhRobQZyXlRS/LtDF7rhaR6GWpeAJ75gcPOidZVRCR
         efSI5F11bBqs3VvVIn/V1E4/lKqjzCt/EvKONRGsUJDnyckny9GvAgRjlJyVPkNTr41c
         m9X5SNKpl1l05H6Ob0ZMFUvrgucxsMWEn9ZqDEKWbo33YqazvuPBQ8HbPLx3X0xd7zfo
         xTsO0qts4X7K4YHh4Rl55caW4m++OrNJaqwAtJdBqnspGf3OZtcN47Tzw0D7r3OKUGmE
         07Ohx3r2RAbceASQPCG+hu8I0HgYntwb3enLb2cJk+ctowzHsmGnDROpqCV5ZT76hwnw
         u1/w==
X-Gm-Message-State: AOAM530OIf9EhR8qXq+BDZ/OFQ3wgr1oYoKuiXyTHSF97QCF6Es7cfDe
        boJrCvcUCdLN/7PsoiGyFJ/cJ4rtjBTb+oSgLSE=
X-Google-Smtp-Source: ABdhPJxvkkD241Lz3LRAUtRW949ws2854urhLUqWkCY7jgN0oYYXvAlFNIBGiakgtnCM/cq+xyQ7RTq0XnPgt16Ib7U=
X-Received: by 2002:a63:4c6:: with SMTP id 189mr731624pge.233.1602192954358;
 Thu, 08 Oct 2020 14:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com> <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
In-Reply-To: <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 8 Oct 2020 14:35:43 -0700
Message-ID: <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 1:32 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 4:11 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > OK. I understand that t->tun_hlen is the GRE header length. What is
> > t->encap_hlen?
>
> I've looked at that closely either.
>
> Appears to be to account for additional FOU/GUE encap:
>
> "
> commit 56328486539ddd07cbaafec7a542a2c8a3043623
> Author: Tom Herbert <therbert@google.com>
> Date:   Wed Sep 17 12:25:58 2014 -0700
>     net: Changes to ip_tunnel to support foo-over-udp encapsulation
>
>     This patch changes IP tunnel to support (secondary) encapsulation,
>     Foo-over-UDP. Changes include:
>
>     1) Adding tun_hlen as the tunnel header length, encap_hlen as the
>        encapsulation header length, and hlen becomes the grand total
>        of these.
>     2) Added common netlink define to support FOU encapsulation.
>     3) Routines to perform FOU encapsulation.
>
>     Signed-off-by: Tom Herbert <therbert@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> "

I see the ipgre_xmit function would pull the header our header_ops
creates, and then call __gre_xmit. __gre_xmit will call
gre_build_header to complete the GRE header. gre_build_header expects
to find the base GRE header after pushing tunnel->tun_hlen. However,
if tunnel->encap_hlen is not 0, it couldn't find the base GRE header
there. Is there a problem?

Where exactly should we put the tunnel->encap_hlen header? Before the
GRE header or after?

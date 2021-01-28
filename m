Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F7A307276
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhA1JUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhA1JOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 04:14:53 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660EC06174A
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:14:12 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c4so1894978wru.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9UwxCVn6UwVvqFqT2NKsjuOUrFcePHVypp4wF/XeAR4=;
        b=fUlidcYN2z4PZsKofgxqKClK+1ECmVGARiCKrSuoqoldDvrSglkyQcIG5xjtlniD10
         5luceoz0DtMSrK3I0CWugMBVHfzLkVPgYHzVEQmjX+kDJUyAA4aOQ/aZV+HGs16li+dN
         JauWhjxlxUwyITme7R98ugIMuEV4f4IQbcKpLyZVN9cESHKWFAH3RLD2BHDKvmmE77fW
         8dufvc8o2jOLiJlVwZsl6FlBb9pRuJjB3GGeI6Rkxz1WEn+8PGEqo+8Iyp0oRMRYa3QU
         T1XOsz6CSDEvOQuPta44fc+gVkRgK2GWu5yvICNMlCYhEjVDZlz9MjbKgMqYgOWJwRu5
         gp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9UwxCVn6UwVvqFqT2NKsjuOUrFcePHVypp4wF/XeAR4=;
        b=VAf8AK/WWGcng0gPOxolT8e80EjtzrQHTE2QsIQ1/SxqbfB+P0xs97fcB+dxnr1TLL
         zsiXgmfU2Nzpheag7MCzzTmpbSpj4Sx43JNoOFrL2w8HwL3e/Lp41z8lB6+Zzat6xp1o
         uxUQEL9cZptpCmZJ0tnlOR6Sw9lxvBLKl9kMZO8pTSK/vpSdVLuOWrN2wtgq7DbnW/fI
         3RxcqCslPyPBQujOAOhL3uh9Yx+akQUEu/3G7c6IbY1J6cbKTg5OySEIfm/ZSRsxi7nc
         HA/TR1BaxQ3rISsbLV0z1Jc+iV21mQ/YBKyGAIahdpTQ3j0A163Xd3yECCOXHSHCKY96
         wGPg==
X-Gm-Message-State: AOAM531NdymEG1t+nGczx0CQ5NUemJFp1/4GLvTHZ/em8+tn07hlyL30
        hpsmmdLR3hnFT3syk8X+abV9WTzrtgUG3I62/uc=
X-Google-Smtp-Source: ABdhPJxWQ14YaOUQNOslSp0y9k2BeVJWn29kDx1wFOXhdbf1worpw5ov828F6TvoribqwD9RaElwG2qjKAB1Ev+9kvI=
X-Received: by 2002:adf:9d82:: with SMTP id p2mr15201323wre.330.1611825251339;
 Thu, 28 Jan 2021 01:14:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611477858.git.lucien.xin@gmail.com> <100e0b32b0322e70127f415ea5b26afd26ac0fed.1611477858.git.lucien.xin@gmail.com>
 <CAF=yD-LPcS47BRbUXwyxipvbtGKB2bNmqZrQWGjYzjA4jptJKQ@mail.gmail.com>
In-Reply-To: <CAF=yD-LPcS47BRbUXwyxipvbtGKB2bNmqZrQWGjYzjA4jptJKQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 28 Jan 2021 17:13:59 +0800
Message-ID: <CADvbK_dF4fwS9QyvrBdQCWc2qWcumZTv9vM-MXg+ALFhTB9Bpg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 9:59 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Jan 24, 2021 at 3:47 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> > while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> > for HW, which includes not only for TCP/UDP csum, but also for other
> > protocols' csum like GRE's.
> >
> > However, in skb_csum_hwoffload_help() it only checks features against
> > NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> > packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> > NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> > to do csum.
> >
> > This patch is to support ip generic csum processing by checking
> > NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> > NETIF_F_IPV6_CSUM) only for TCP and UDP.
> >
> > v1->v2:
> >   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
> >     if it's an UDP/TCP csum packet.
> >
> > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/core/dev.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 6df3f1b..aae116d 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
> >                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> >                         skb_crc32c_csum_help(skb);
> >
> > -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> > +       if (features & NETIF_F_HW_CSUM)
> > +               return 0;
> > +
> > +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
> > +               switch (skb->csum_offset) {
> > +               case offsetof(struct tcphdr, check):
> > +               case offsetof(struct udphdr, check):
>
> This relies on no other protocols requesting CHECKSUM_PARTIAL
> with these csum_offset values.
>
> That is a fragile assumption. It may well be correct, and Alex argues
> that point in v1 of the patch. I think that argumentation at the least
> should be captured as a comment or in the commit message.
will add a note in changelog and repost, thanks!

>
> Or perhaps limit this optimization over s/w checksumming to
>
>   skb->sk &&
>   (skb->sk->sk_family == AF_INET  || .. ) &&
>   (skb->sk->sk_type == SOCK_STREAM || ..)
>
> ?

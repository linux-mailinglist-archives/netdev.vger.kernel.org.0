Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9A1238BF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfLQVjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:39:10 -0500
Received: from correo.us.es ([193.147.175.20]:34402 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbfLQVjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 16:39:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B3BCFEB46F
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:39:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8451DA711
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:39:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9DCF2DA70D; Tue, 17 Dec 2019 22:39:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E2A7DA70B;
        Tue, 17 Dec 2019 22:39:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 22:39:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 71A994265A5A;
        Tue, 17 Dec 2019 22:39:04 +0100 (CET)
Date:   Tue, 17 Dec 2019 22:39:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
Message-ID: <20191217213904.sqvvg7ljiibdt3xi@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <20191209200317.GA10466@netronome.com>
 <CADvbK_fJjN0MsYpmoJ+WD=rRNYub96+nHsv3EozHTj5MG2d1ag@mail.gmail.com>
 <20191213093026.GA27379@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213093026.GA27379@netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On Fri, Dec 13, 2019 at 10:30:26AM +0100, Simon Horman wrote:
> On Tue, Dec 10, 2019 at 12:05:15PM +0800, Xin Long wrote:
> > On Tue, Dec 10, 2019 at 4:03 AM Simon Horman <simon.horman@netronome.com> wrote:
> > >
> > > Hi Xin,
> > >
> > > On Sun, Dec 08, 2019 at 12:41:31PM +0800, Xin Long wrote:
> > > > To keep consistent with ipgre_policy, it's better to parse
> > > > ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
> > > > cls_flower and ip_tunnel_core.
> > > >
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  net/netfilter/nft_tunnel.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> > > > index 3d4c2ae..f76cd7d 100644
> > > > --- a/net/netfilter/nft_tunnel.c
> > > > +++ b/net/netfilter/nft_tunnel.c
> > > > @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
> > > >  }
> > > >
> > > >  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> > > > +     [NFTA_TUNNEL_KEY_ERSPAN_VERSION]        = { .type = NLA_U8 },
> > > >       [NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]       = { .type = NLA_U32 },
> > > > -     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR] = { .type = NLA_U8 },
> > > > +     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]         = { .type = NLA_U8 },
> > > >       [NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]        = { .type = NLA_U8 },
> > > >  };
> > > >
> > > > @@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
> > > >       if (err < 0)
> > > >               return err;
> > > >
> > > > -     version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
> > > > +     version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);
> > >
> > > I have concerns about this change and backwards-compatibility with existing
> > > users of this UAPI. Likewise, with other changes to the encoding of existing
> > > attributes elsewhere in this series.
> >
> > userspace(nftables/libnftnl) is not ready for nft_tunnel, I don't
> > think there will be any backwards-compatibility issue.
> > 
> > Pablo?
> 
> Thanks, I'm happy to defer to Pablo on this question.

I agree with Xin. This uapi is not in good shape and there is no
upstream userspace code for this, no nftables support for this yet.
In this particular case I'm inclined to fix uapi, better sooner than
never.

Thanks.

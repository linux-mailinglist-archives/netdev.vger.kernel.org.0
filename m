Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68011CD38
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfLLMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:33:43 -0500
Received: from correo.us.es ([193.147.175.20]:45566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729092AbfLLMdn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 07:33:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DACE7DA722
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 13:33:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDA43DA701
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 13:33:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C355EDA703; Thu, 12 Dec 2019 13:33:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B27DDA712;
        Thu, 12 Dec 2019 13:33:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Dec 2019 13:33:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4EC5D41E4801;
        Thu, 12 Dec 2019 13:33:37 +0100 (CET)
Date:   Thu, 12 Dec 2019 13:33:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
Message-ID: <20191212123337.oozyghzz2j2qfkjs@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <20191211215104.qnvifdmlg55ox45b@salvia>
 <CADvbK_cxeZmJa_FMd+p_35CPOSMDfnos1j3TC0_3u9TdmZZH=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_cxeZmJa_FMd+p_35CPOSMDfnos1j3TC0_3u9TdmZZH=g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 11:20:19AM +0800, Xin Long wrote:
> On Thu, Dec 12, 2019 at 5:51 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi,
> >
> > On Sun, Dec 08, 2019 at 12:41:31PM +0800, Xin Long wrote:
> > > To keep consistent with ipgre_policy, it's better to parse
> > > ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
> > > cls_flower and ip_tunnel_core.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/netfilter/nft_tunnel.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> > > index 3d4c2ae..f76cd7d 100644
> > > --- a/net/netfilter/nft_tunnel.c
> > > +++ b/net/netfilter/nft_tunnel.c
> > > @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
> > >  }
> > >
> > >  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> > > +     [NFTA_TUNNEL_KEY_ERSPAN_VERSION]        = { .type = NLA_U8 },
> > >       [NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]       = { .type = NLA_U32 },
> > > -     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR] = { .type = NLA_U8 },
> > > +     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]         = { .type = NLA_U8 },
> > >       [NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]        = { .type = NLA_U8 },
> > >  };
> > >
> > > @@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
> > >       if (err < 0)
> > >               return err;
> > >
> > > -     version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
> > > +     version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);
> >
> > I think NFTA_TUNNEL_KEY_ERSPAN_VERSION as 32-bit is just fine.
> >
> > Netlink will be adding the padding anyway for u8.
> >
> > I would suggest you leave this as is.
> okay.
> 
> do you think I should prepare another patch/fix for the missing nla_policy part?
> [NFTA_TUNNEL_KEY_ERSPAN_VERSION]        = { .type = NLA_U32 },

Yes, please, thanks.

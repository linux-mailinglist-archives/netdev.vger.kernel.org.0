Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0A1D03E0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfJHXK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:10:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbfJHXK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570576254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mQ/AQeOBE8ywKhgESd5kfsCunrLGPABoUZLkxezye0=;
        b=Q/OiCMkRwc7FHrjMruB3w2Tiw41CWyRnUFcLtmIGKot2qrWQ5wOZKBakhvaXqLjYjoESHm
        q0l9WMCGFw3XSnJ6FOPoJ1smP8fmSJVSA+kOGBMKPyqQ327gxpaE8ThpXDVhOFXAjb2X12
        Pog2UeTcXbQzQNGjneNVNJ2bS4eDmr0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-2mUTnoGWPDa98MIrTDQQOA-1; Tue, 08 Oct 2019 19:10:51 -0400
Received: by mail-wr1-f70.google.com with SMTP id b6so203705wrw.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:10:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DFxgMKQmeN7Y/Loc2XddzVm+DZL4YYnrclUMj8Tltzw=;
        b=QiA0eNPCAg4Z9XFiC6j9DDbNzFzhwFaiEvio3eocJy5WA8heaGwiRVD6/BgRIpmYZh
         yzqtjAfy5reNdlxFpllQhYHlaq+pdBQ4URluaNSExVUwwvNMbXda/Du01vsAAfvpPx76
         s44D84yciA9o7JHX5equXEK25SCHC6km4zUelB2amj5qV3YXo6X2Pq8l3wgWPczrsMVK
         RZAkPMYqtkbLNGsH2rF81/G/d3mM9/KzFrRc8r5w+k/REfj2T4anCCepr4Xcln0Nmqsz
         KHU29WaexS50Dnvda5M8NeiKUPLC6tRRVVahs4MCpr+rHpYwR7hoWYR+lCkvxyougHQX
         949w==
X-Gm-Message-State: APjAAAXE9+Huqb4qQsSW+FwU4kQccH925wRk3dkDX5NWlWc/TwliqMQz
        eGpDasmzeebFg4vWkJyPF+q4fme1s/ANeKquItGNJETpfX7FZfv5rZBg/H4xvB4vDrq0Z3wprqt
        T8GXkoq8Ed75f7Yz4
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr170440wmc.11.1570576249747;
        Tue, 08 Oct 2019 16:10:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzx7+Hi4qLrdPP4cSQKpJqwzL9gnZXlLkmUPDIErTC21t1tHO8b+4iYng4leQFkuwOk6Z8ngg==
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr170432wmc.11.1570576249573;
        Tue, 08 Oct 2019 16:10:49 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id t13sm436705wra.70.2019.10.08.16.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:10:48 -0700 (PDT)
Date:   Wed, 9 Oct 2019 01:10:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
Message-ID: <20191008231047.GB4779@linux.home>
References: <20191003161940.GA31862@linux.home>
 <20191007115835.17882-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
In-Reply-To: <20191007115835.17882-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: 2mUTnoGWPDa98MIrTDQQOA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 01:58:35PM +0200, Nicolas Dichtel wrote:
> The flag NLM_F_ECHO aims to reply to the user the message notified to all
> listeners.
> It was not the case with the command RTM_NEWNSID, let's fix this.
>=20
> Fixes: 0c7aecd4bde4 ("netns: add rtnl cmd to add and get peer netns ids")
> Reported-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  net/core/net_namespace.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a0e0d298c991..f496ce0e8da8 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> -static void rtnl_net_notifyid(struct net *net, int cmd, int id)
> +static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 port=
id,
> +=09=09=09      struct nlmsghdr *nlh)
>  {
>  =09struct net_fill_args fillargs =3D {
>  =09=09.cmd =3D cmd,

We also need to set .portid and .seq otherwise rtnl_net_fill() builds
a netlink message with invalid port id and sequence number (as you
noted in your previous message).


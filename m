Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966F213C6B1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAOOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:55:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22663 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726248AbgAOOzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 09:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579100138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJxqHG8eV6VNy6F7YlNGdWptQATKgg+b3NRN48rWarQ=;
        b=E951ffGenevh26j8SOni9I2bfauPKCu5o+UtRciKHBoqmAnRf04OKpfCNjGlzqqYj0ZaoM
        6ChZdx05+z3vRr6p973RkMYoW9wW3K9tcbwX5uGPaVcFSbPi9aS0oBaYX9Uq0S26Mwca7S
        NnWSOQUKpSQ9qA9SiuhoI0zAGpNWIv4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-5afN0zhUPViKF_Yigmi_Wg-1; Wed, 15 Jan 2020 09:55:37 -0500
X-MC-Unique: 5afN0zhUPViKF_Yigmi_Wg-1
Received: by mail-wm1-f69.google.com with SMTP id t4so46611wmf.2
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 06:55:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zJxqHG8eV6VNy6F7YlNGdWptQATKgg+b3NRN48rWarQ=;
        b=gr1R0nSwpuWgivTmzkFGyYCLnorOOGn8UZl+CrSyaOr5LgThxOrhToEOG3r++4fouY
         TxkSdwVn/xFIHgIe/bDKFL2pY/Vpls0ViLN12ml4PB8UNqdyO1Vp84X+b8BY4mjy35E6
         R6gY1eW81aOa+rQXLYquWpKY12lcG3qNBDD11PWoYnbIOT2jKSNE4JE0XSZSIYlxiHpS
         0t0OeuG3wcVVkdyPPaU1al+B1s6h+3Nb28dQbSL/XkpPJyYhovvndjNDbsj7i1GaTQwW
         oYDWSzArrhoj5scack3oErTyvtqHQTQZ5P391EqhdP11lBupV8nnxCyuoNPI7ea53F7F
         Yy+w==
X-Gm-Message-State: APjAAAVjUfEWp71JB/OF4OGCwUW1Yhsbt2g2kbWUaHlan2fjIDwnMM6t
        RX86Px3cABO7NRqXkTAkO8uExVMQGEgK+ULse8NTl/7QBiSff4qZ/2sCuYt3lfvCKlSdFy6jB8n
        pBe7kVsGtM4CJhWLa
X-Received: by 2002:a5d:5706:: with SMTP id a6mr18802514wrv.108.1579100135834;
        Wed, 15 Jan 2020 06:55:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyFus1GCdCcVugnna61SsfYvRo/s8hIlqYosIXJxvWL2xGYEq59+BnIMF7uL/mqrXogyXqL8Q==
X-Received: by 2002:a5d:5706:: with SMTP id a6mr18802500wrv.108.1579100135604;
        Wed, 15 Jan 2020 06:55:35 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id f1sm63177wmc.45.2020.01.15.06.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 06:55:34 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:55:33 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] netns: Parse NETNSA_FD and NETNSA_PID as
 signed integers
Message-ID: <20200115145533.GA10783@linux.home>
References: <cover.1579040200.git.gnault@redhat.com>
 <0f37c946179b082bf1c5e34d2cfdd9223979ea83.1579040200.git.gnault@redhat.com>
 <b4a7a751-5566-fd9b-d038-c80878ec41f7@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4a7a751-5566-fd9b-d038-c80878ec41f7@6wind.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 02:30:13PM +0100, Nicolas Dichtel wrote:
> Le 14/01/2020 à 23:25, Guillaume Nault a écrit :
> > These attributes represent signed values (file descriptors and PIDs).
> > Make that clear in nla_policy.
> > 
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  net/core/net_namespace.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> > index 6412c1fbfcb5..85c565571c1c 100644
> > --- a/net/core/net_namespace.c
> > +++ b/net/core/net_namespace.c
> > @@ -706,8 +706,8 @@ static struct pernet_operations __net_initdata net_ns_ops = {
> >  static const struct nla_policy rtnl_net_policy[NETNSA_MAX + 1] = {
> >  	[NETNSA_NONE]		= { .type = NLA_UNSPEC },
> >  	[NETNSA_NSID]		= { .type = NLA_S32 },
> > -	[NETNSA_PID]		= { .type = NLA_U32 },
> > -	[NETNSA_FD]		= { .type = NLA_U32 },
> > +	[NETNSA_PID]		= { .type = NLA_S32 },
> > +	[NETNSA_FD]		= { .type = NLA_S32 },
> Please, keep them consistent with IFLA_NET_NS_*:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/core/rtnetlink.c?h=v5.5-rc6#n1793
> 
Oh right! I'll also update rtnetlink.c in v2.
Thanks!


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2572C65ECF
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfGKRlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 13:41:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46073 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGKRlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 13:41:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id x22so275671qtp.12
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6pCqVaAQnVTEmOJWGnRveGPNLHhDMYxLq3MEYF24/ck=;
        b=CH7jSXX+s3VkJy59+NIcuyhkF0is0DrJ+hBfMthrCOFnpE/E4sbNc5RdTjhWHA3Ddo
         xeRTXMAcfMYngjh1KHvUKixrAJD//r5tEej3d4mGEXWsy6rQa6BwGFL7n2aDkDJBbtVx
         wXsSWdz0pKh0ZhoIWlCihYsfkiOOtfZwG368v9hnBf3PkE5fO8Z/41cu7m/vVDyTPlWf
         igooCgtk9C+/UkFIG+bycOgBgVltlkFrLXNIg+j8Kg+OuRkEKYnyGC7hyqEZBT/5zidk
         KXXSwloy5Rs1bRcLbgndN9eSDIz8MZAFEz0c2sGno4QsBJDvbr2KgLsZEVPYmSLa8AC2
         rDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6pCqVaAQnVTEmOJWGnRveGPNLHhDMYxLq3MEYF24/ck=;
        b=Qx+TccGXoTtNbglqxwtzgrCEaDEfVBs6pFQqqLVRKeLk/rniCgbWTjJVbt9u8pTUtn
         NI++yb5pEDAFcHFq9CK7Qeae0p97cIm80dJZrm7BhYzhEnfzJYq083SpTOudCL/ANdFH
         rPd/8f9nWtEDKc7Pcm4ORSaMh6nfZpK27dYVlJXoN89r+t6OdWhdHnQrNVTeIm34Nbo3
         8gHorsL5+RIjlrSj3S4PGut3BNnEbwMVBbE+8dVAqfCi0iWIvZ1bcoTDBeAsIAuypqMk
         5PyOQ9awGoAyLCh7/EMJ8DBaC70CriJxBFkLtZ1GKy7Fryjcb3RSHJ4+Gy5TqtDL8aYn
         +rDw==
X-Gm-Message-State: APjAAAV0Ax2ghJUCCOIEV23MAB3znmw7hpiTItmf7BJ9JD8XmCnJ/1mN
        vw9GAgqMiIZisogDCY8Dgu4=
X-Google-Smtp-Source: APXvYqx5FOOqpoAktSdIQWd2Gp+bsFscWO8zgzINj5V0Wi/dr0Q8CF7amsMyMManiJb0bNiRE4H2rg==
X-Received: by 2002:ac8:341d:: with SMTP id u29mr2711939qtb.320.1562866860113;
        Thu, 11 Jul 2019 10:41:00 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.27])
        by smtp.gmail.com with ESMTPSA id 5sm2584027qkr.68.2019.07.11.10.40.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 10:40:59 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 9B630C0918; Thu, 11 Jul 2019 14:40:56 -0300 (-03)
Date:   Thu, 11 Jul 2019 14:40:56 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        John Hurley <john.hurley@netronome.com>, Yossi@redhat.com,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aaron Conole <aconole@redhat.com>,
        Rony Efraim <ronye@mellanox.com>,
        Justin Pettit <jpettit@ovn.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Zhike Wang <wangzhike@jd.com>,
        David Miller <davem@davemloft.net>,
        Kuperman <yossiku@mellanox.com>
Subject: Re: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Message-ID: <20190711174056.GW3449@localhost.localdomain>
References: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
 <1562489628-5925-3-git-send-email-paulb@mellanox.com>
 <20190708175446.GL3449@localhost.localdomain>
 <d4f2f3ce-f14d-6026-a271-d627de6d8cea@mellanox.com>
 <20190709153657.GF3390@localhost.localdomain>
 <5ded2e5b-958e-eca3-76ad-909ebf79234e@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ded2e5b-958e-eca3-76ad-909ebf79234e@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 07:21:51AM +0000, Paul Blakey wrote:
> 
> On 7/9/2019 6:36 PM, Marcelo Ricardo Leitner wrote:
> > On Tue, Jul 09, 2019 at 06:58:36AM +0000, Paul Blakey wrote:
> >> On 7/8/2019 8:54 PM, Marcelo Ricardo Leitner wrote:
> >>> On Sun, Jul 07, 2019 at 11:53:47AM +0300, Paul Blakey wrote:
> >>>> New tc action to send packets to conntrack module, commit
> >>>> them, and set a zone, labels, mark, and nat on the connection.
> >>>>
> >>>> It can also clear the packet's conntrack state by using clear.
> >>>>
> >>>> Usage:
> >>>>      ct clear
> >>>>      ct commit [force] [zone] [mark] [label] [nat]
> >>> Isn't the 'commit' also optional? More like
> >>>       ct [commit [force]] [zone] [mark] [label] [nat]
> >>>
> >>>>      ct [nat] [zone]
> >>>>
> >>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> >>>> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> >>>> Signed-off-by: Yossi Kuperman <yossiku@mellanox.com>
> >>>> Acked-by: Jiri Pirko <jiri@mellanox.com>
> >>>> Acked-by: Roi Dayan <roid@mellanox.com>
> >>>> ---
> >>> ...
> >>>> +static void
> >>>> +usage(void)
> >>>> +{
> >>>> +	fprintf(stderr,
> >>>> +		"Usage: ct clear\n"
> >>>> +		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
> >>> Ditto here then.
> >>
> >> In commit msg and here, it means there is multiple modes of operation. I
> >> think it's easier to split those.
> > Yep, that is good.
> > More below.
> >
> >> "ct clear" to clear it , not other options can be added here.
> >>
> >> "ct commit  [force].... " sends to conntrack and commit a connection,
> >> and only for commit can you specify force mark  label, and nat with
> >> nat_spec....
> >>
> >> and the last one, "ct [nat] [zone ZONE]" is to just send the packet to
> >> conntrack on some zone [optional], restore nat [optional].
> >>
> >>
> >>>> +		"	ct [nat] [zone ZONE]\n"
> >>>> +		"Where: ZONE is the conntrack zone table number\n"
> >>>> +		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
> >>>> +		"\n");
> >>>> +	exit(-1);
> >>>> +}
> >>> ...
> >>>
> >>> The validation below doesn't enforce that commit must be there for
> >>> such case.
> >> which case? commit is optional. the above are the three valid patterns.
> > That's the point. But the 2nd example is saying 'commit' word is
> > mandatory in that mode. It is written as it is a command that was
> > selected.
> >
> > One may use just:
> >      ct [zone]
> > And not
> >      ct commit [zone]
> > Right?
> 
> It is optional in the overall syntax.
> 
> 
> But I split it into modes:
> 
> clear, commit, and "restore" (I unofficial call it like that, because it 
> usually used to get the +est state on the packet and can restore nat, it 
> doesn't actually restore anything for the first packet on the -trk rule)
> 
> It is mandatory in the second mode (commit), if you don't specify commit 
> or clear, you can only use the third form - "restore", which is to send 
> to ct on some optional zone, and optionally and restore nat (so we get 
> ct [zone] [nat]).

I see. Thanks Paul.

  Marcelo

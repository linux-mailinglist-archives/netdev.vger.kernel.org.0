Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082EE638BE
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGIPhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:37:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37810 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIPhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:37:01 -0400
Received: by mail-qt1-f194.google.com with SMTP id y26so9490240qto.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=2Y3/bGb0PpFsyvrz1J4CN540sOnrqVLwUvg/oZhM3q8=;
        b=ZCbvV9ApR4tfS2J66guZ+GfozJyTsbqwoWmD43MqGCcqp5RB3XOkpJFi6k57enmx1y
         Yp/mzAqTqpS1iTr1FgbP4ddDoug7phKZ8238k83XvLY7qDe0EhNa1CNFrRRzX6W4O+I+
         fTHECrUdP28J6o45tAovsa6fC3llfRD5TQEB000NauVERRy6oCkAcR1s4PIIxMQkqxSS
         va1wpQQ3WWsqVo5jMMtqqHt6piYnInal5em7YztMKbf+Gh+MoEWjNM6do89X7jW0qYvG
         Ijh6sttixhSMhc4eThs9Smy1cMP++Mm69Tn9iJnghqoClm4ZxPaAMC8HFBjOnogiD1y3
         S3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=2Y3/bGb0PpFsyvrz1J4CN540sOnrqVLwUvg/oZhM3q8=;
        b=WvQOBM81xVlJP4qxt2DIlAPZM2Bzg5kuBpZ8UmKcfoXOdsLlVT0ZssxniXKgFoMwHg
         1Xj16Xr6Ijvk3kHxs8FckoPcXLuxf6LdpFQB5Aeg2bCv+iOlv7s+soCSbf4VxqnwL8oZ
         PmuUHf0dQv3pqw5ElB74Vwx1BVozTpRp8YuNGVpKVnz2E0SJ5CY26Lav7qLC7MyCqLA2
         s0MgyHvu0x/Cv+T0BdvQXx6ihK+4f/d7sQM8IZjycxvoPRjpNayc97gbPf9FeGQQKgKC
         kBc0U6WnxGfs7rhCVUa1C6GSFTe76P2+95FK2KR+WXuRNQ6hgF8eO9k5sZCRkMmCB4di
         R6WQ==
X-Gm-Message-State: APjAAAXntzabf3bYnCQTC5MsZ3Osj+LkAyGgPY2avq731WDICA5Vvshn
        w7ASCbdwlvZgomk+WihV6Kw=
X-Google-Smtp-Source: APXvYqzwvxvF2vKhHwD096RyK0JBBckubE9Rx5DIcet6UR9VSiF3GRTQBVSBmMf2F9e+CEfDHKncXQ==
X-Received: by 2002:ac8:4a0d:: with SMTP id x13mr14501479qtq.356.1562686620677;
        Tue, 09 Jul 2019 08:37:00 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.139])
        by smtp.gmail.com with ESMTPSA id g3sm8795045qkk.125.2019.07.09.08.36.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:36:59 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1D514C0AAB; Tue,  9 Jul 2019 12:36:57 -0300 (-03)
Date:   Tue, 9 Jul 2019 12:36:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>, Justin Pettit <jpettit@ovn.org>,
        John Hurley <john.hurley@netronome.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Message-ID: <20190709153657.GF3390@localhost.localdomain>
References: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
 <1562489628-5925-3-git-send-email-paulb@mellanox.com>
 <20190708175446.GL3449@localhost.localdomain>
 <d4f2f3ce-f14d-6026-a271-d627de6d8cea@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4f2f3ce-f14d-6026-a271-d627de6d8cea@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 06:58:36AM +0000, Paul Blakey wrote:
> 
> On 7/8/2019 8:54 PM, Marcelo Ricardo Leitner wrote:
> > On Sun, Jul 07, 2019 at 11:53:47AM +0300, Paul Blakey wrote:
> >> New tc action to send packets to conntrack module, commit
> >> them, and set a zone, labels, mark, and nat on the connection.
> >>
> >> It can also clear the packet's conntrack state by using clear.
> >>
> >> Usage:
> >>     ct clear
> >>     ct commit [force] [zone] [mark] [label] [nat]
> > Isn't the 'commit' also optional? More like
> >      ct [commit [force]] [zone] [mark] [label] [nat]
> >
> >>     ct [nat] [zone]
> >>
> >> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> >> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> >> Signed-off-by: Yossi Kuperman <yossiku@mellanox.com>
> >> Acked-by: Jiri Pirko <jiri@mellanox.com>
> >> Acked-by: Roi Dayan <roid@mellanox.com>
> >> ---
> > ...
> >> +static void
> >> +usage(void)
> >> +{
> >> +	fprintf(stderr,
> >> +		"Usage: ct clear\n"
> >> +		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
> > Ditto here then.
> 
> 
> In commit msg and here, it means there is multiple modes of operation. I 
> think it's easier to split those.

Yep, that is good.
More below.

> 
> "ct clear" to clear it , not other options can be added here.
> 
> "ct commit  [force].... " sends to conntrack and commit a connection, 
> and only for commit can you specify force mark  label, and nat with 
> nat_spec....
> 
> and the last one, "ct [nat] [zone ZONE]" is to just send the packet to 
> conntrack on some zone [optional], restore nat [optional].
> 
> 
> >
> >> +		"	ct [nat] [zone ZONE]\n"
> >> +		"Where: ZONE is the conntrack zone table number\n"
> >> +		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
> >> +		"\n");
> >> +	exit(-1);
> >> +}
> > ...
> >
> > The validation below doesn't enforce that commit must be there for
> > such case.
> which case? commit is optional. the above are the three valid patterns.

That's the point. But the 2nd example is saying 'commit' word is
mandatory in that mode. It is written as it is a command that was
selected.

One may use just:
    ct [zone]
And not
    ct commit [zone]
Right?


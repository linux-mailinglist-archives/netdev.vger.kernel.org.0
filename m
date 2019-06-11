Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905723D179
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405155AbfFKPxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:53:55 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41452 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388958AbfFKPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:53:54 -0400
Received: by mail-qk1-f196.google.com with SMTP id c11so7956547qkk.8
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=AlkrbQYAq5ggfeanUdZINnoihFF0gPgxsWNEjFNogf8=;
        b=ueOGSkOWX2A7u4tyMuh00k0YLIN81nyqTYlMK8cjU2o320bmCfWS5vnLcXJ4d8mMhc
         pcEC07aQ3HxqPF1QL/3tIeEJESOLryxpDT4UYmlMgDLL39Vxlodbk5ahlIzX7a1TxVQ3
         dA+0r9tTO9VDUuVdZyvQonYTdQ+e3y08EP+I01dxNBETKJP6ihPnFSv7TR6rhgD01oBi
         U9Fc+AR8qKXsdvceDt2CZ1O7IBJoeIzNgLftVt5I8I6YV/2L+suJRNiATCBglR7Gw2gt
         PnVMwUqkZ7JU5GNWdRjMYEXnYHm7ImzXiJGFTtc3aiFVLmJDthwDkGSZ/YDTNJWnisl4
         fX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=AlkrbQYAq5ggfeanUdZINnoihFF0gPgxsWNEjFNogf8=;
        b=Gi5MKGLYvM08rUE/EUmrfq6Kyw+REUDorlpym4p1VAewnky+Kptazn6lB+uoUOppP2
         RyJUGAOkj9e8gB3bezc4Bd0pHClwFKwgg2dekyBBxZ+ZJ+cI2FBMhfwhO/MKgNSM7vNP
         8xwR8OJHDBVZbzbqlsClfgBck1nzDuqUCVXhkK6ewK5S5pq28nqmDRg1n+qVX10aAkP2
         gPU6mzNL3RbNrpXG7FRyDs8V9KjMYLGJlNewBOTIF4tnfCP9ePF6XEwR6LeHOu3RUXPM
         ElTu3B4DgbDMDWqHhQqcZAT72OcPZemtfWL5+9RfgNWFhIfdj3zWUFKOBYQuWtb+0eis
         Oyxg==
X-Gm-Message-State: APjAAAXlXSD/vYj2tt9mPZqzcS9hZeznK6k0Rln9Lrd7bFPfYN40meWH
        /og5QUGodeGzJ9gotT+vfmc=
X-Google-Smtp-Source: APXvYqwQB1j7I2NffgkhLOmbhzuVdcytJYqGlXc+2cPoSKggZcK2ig1KRcA1rO+oYlC5q7SrAIsw3A==
X-Received: by 2002:a37:a9c3:: with SMTP id s186mr9450705qke.190.1560268433861;
        Tue, 11 Jun 2019 08:53:53 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.36])
        by smtp.gmail.com with ESMTPSA id y20sm2324522qka.14.2019.06.11.08.53.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:53:53 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A4DADC087D; Tue, 11 Jun 2019 12:53:50 -0300 (-03)
Date:   Tue, 11 Jun 2019 12:53:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Message-ID: <20190611155350.GC3436@localhost.localdomain>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <87d0jkgr3r.fsf@toke.dk>
 <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
 <877e9sgmp1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877e9sgmp1.fsf@toke.dk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 05:34:50PM +0200, Toke Høiland-Jørgensen wrote:
> Paul Blakey <paulb@mellanox.com> writes:
> 
> > On 6/11/2019 4:59 PM, Toke Høiland-Jørgensen wrote:
> >> Paul Blakey <paulb@mellanox.com> writes:
> >>
> >>> Allow sending a packet to conntrack and set conntrack zone, mark,
> >>> labels and nat parameters.
> >> How is this different from the newly merged ctinfo action?
> >>
> >> -Toke
> >
> > Hi,
> >
> > ctinfo does one of two very specific things,
> >
> > 1) copies DSCP values that have been placed in the firewall conntrack 
> > mark back into the IPv4/v6 diffserv field
> >
> > 2) copies the firewall conntrack mark to the skb's mark field (like 
> > act_connmark)
> >
> > Originally ctinfo action was named conndscp (then conntrack, which is 
> > what our ct shorthand stands for).
> >
> > We also talked about merging both at some point, but they seem only 
> > coincidentally related.
> 
> Well, I'm predicting it will create some confusion to have them so
> closely named... Not sure what the best way to fix that is, though...?

I had suggested to let act_ct handle the above as well, as there is a
big chunk of code on both that is pretty similar. There is quite some
boilerplate for interfacing with conntrack which is duplicated.
But it was considered that the end actions are unrelated, and ctinfo
went ahead. (I'm still not convinced of that, btw)

Other than this, which is not an option anymore, I don't see a way to
avoid confusion here. Seems anything we pick now will be confusing
because ctinfo is a generic name, and we also need one here.

  Marcelo

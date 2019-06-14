Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377B946821
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 21:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfFNTYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 15:24:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38199 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFNTYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 15:24:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so3791022qtl.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 12:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bl/eCP9M5+h3LOq6o85bLzz30Wl1r6eQWyDsqTLa8Cc=;
        b=qc453USAgLioccGGkaVHMJu3QCW9bt+OMk7jHruC/8P2731KYxETVbae/BppWMw2xq
         hmqlXkpf1nBRZwuPIdtVYZ89KT/mnhFqKaBE2Fs5MIXNtAR24ObysXFN8ZaPqCHbb892
         fWsicrGsFxhaMa9jfm6KR5OhVGE80ulxbxhDEuesEf/muOOA+VijCXzb57CblqBeNmqB
         TlSEMS2o350quox8zueyxEkgjQT4HqWvGxI5M9Fr2EjFCCdKyKnvWLBjZByOSaUq5UdO
         u+ieQDcKX9FrmL3lmmgMETb5fywvX882jk6jsmrOF7qtwRg5FkZ4SPSt8xthpSaOnS5J
         uOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bl/eCP9M5+h3LOq6o85bLzz30Wl1r6eQWyDsqTLa8Cc=;
        b=qkt90J/0fkLIUTxTfYv5NQ1j6fcLaAheyMvUkjC4FshxbVu0821YVAm5W6Oey6DDp4
         kjd9YvTJXNvBuW92qvLOijOGXcX8mjz+lN/EiFf1Hx0YP4WhHH/5i58ZQ1S3sjzZyH+2
         qPBSUAyRNuie9ldQrAN7pqq6pI3onoVVqAvYaimehtzaKnDCUhNXf0VT5ULnSv3bDT3f
         9TcY4ul2voA0b5PofecmuEm1nxckuaAYFgqKshuOvZn1KQJvSf1JsZ7OIbcrX8pH9s5h
         kT1st+Drk34uwbJjQGhQ9VFmtCAx2/XBbw8XqEMmg2aT5YCQ4KwhBWpaRCgNG+6xX4xy
         3vAg==
X-Gm-Message-State: APjAAAXaGdP6hTYLXyL6795hRFhLT9HF1+cW2wpOJb+ux7OPiiDC9aiY
        f5lihLec2jTOBTF47zYM3no=
X-Google-Smtp-Source: APXvYqxCk05XKAHxpSlF66mqnnDmQulfcMiuIW4g7KKBshcW0AKf9RKLA6bTCdxf9BxF9GCOkDJ/fw==
X-Received: by 2002:a0c:ee49:: with SMTP id m9mr9805411qvs.217.1560540247918;
        Fri, 14 Jun 2019 12:24:07 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.120])
        by smtp.gmail.com with ESMTPSA id g10sm1796165qkk.91.2019.06.14.12.24.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 12:24:06 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 98BE1C1BC6; Fri, 14 Jun 2019 16:24:03 -0300 (-03)
Date:   Fri, 14 Jun 2019 16:24:03 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
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
Message-ID: <20190614192403.GK3436@localhost.localdomain>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <87d0jkgr3r.fsf@toke.dk>
 <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
 <877e9sgmp1.fsf@toke.dk>
 <20190611155350.GC3436@localhost.localdomain>
 <CAM_iQpX1jFBYCLu1t+SbuxKDMr3_c2Fip0APwLebO9tf_hqs8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpX1jFBYCLu1t+SbuxKDMr3_c2Fip0APwLebO9tf_hqs8w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 11:07:37AM -0700, Cong Wang wrote:
> On Tue, Jun 11, 2019 at 9:44 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > I had suggested to let act_ct handle the above as well, as there is a
> > big chunk of code on both that is pretty similar. There is quite some
> > boilerplate for interfacing with conntrack which is duplicated.
> 
> Why do you want to mix retrieving conntrack info with executing
> conntrack?

To save on the heavy boilerplate for interfacing with conntrack.

> 
> They are totally different things to me, act_ctinfo merely retrieves
> information from conntrack, while this one, act_ct, is supposed to
> move packets to conntrack.

Seems we have a different understanding for "move packets to
conntrack": conntrack will not consume the packets after this.
But after act_ct is executed, if not with the clear flag, skb will now
have the skb->_nfct entry available, on which flower then will be able
to match. So in essence, it is also fetching information from
conntrack.

I see act_ctinfo is a subset of what act_ct is doing.

  Marcelo

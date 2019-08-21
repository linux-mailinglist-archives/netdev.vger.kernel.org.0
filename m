Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1B1970D1
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfHUELM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:11:12 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:44078 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfHUELM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 00:11:12 -0400
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x7L4B95u068890
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Aug 2019 00:11:10 -0400
Received: by mail-lj1-f182.google.com with SMTP id e24so769093ljg.11;
        Tue, 20 Aug 2019 21:11:10 -0700 (PDT)
X-Gm-Message-State: APjAAAUq0yZzL6KKQVRoSD/MJUT2YKYwNFKyrZDwhnZCArGHxDque/jE
        Hlxe7elNUqmlR79Bwfc1FqIPCqIVxhjkxtiCQIs=
X-Google-Smtp-Source: APXvYqyyYoE6BFoFjTkA2zz1wluz3q243WVH3e1WosI+d49h5maVbSQ2ufFUYVzX6TSOO32UnCu5k7eQ/8WRsQuAzG8=
X-Received: by 2002:a2e:3c12:: with SMTP id j18mr1434819lja.50.1566360669574;
 Tue, 20 Aug 2019 21:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAAa=b7ft-crBJm+H9U7Bn2dcgfjQsE8o53p2ryBWK3seQoF3Cg@mail.gmail.com>
 <20190815.134230.1028411309377288636.davem@davemloft.net> <CAAa=b7duRXsiVBfzbvHhoU000gGh53Mme3ZKCO5SoiTdgRaXtg@mail.gmail.com>
 <20190815.135111.1048854967874803531.davem@davemloft.net>
In-Reply-To: <20190815.135111.1048854967874803531.davem@davemloft.net>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Wed, 21 Aug 2019 00:10:33 -0400
X-Gmail-Original-Message-ID: <CAAa=b7fc99q0JTcn2FaBaN4as3U_SMutG7J+AuqSa3xBHaPQ4Q@mail.gmail.com>
Message-ID: <CAAa=b7fc99q0JTcn2FaBaN4as3U_SMutG7J+AuqSa3xBHaPQ4Q@mail.gmail.com>
Subject: Re: [PATCH] net: pch_gbe: Fix memory leaks
To:     David Miller <davem@davemloft.net>
Cc:     Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 4:51 PM David Miller <davem@davemloft.net> wrote:
>
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Date: Thu, 15 Aug 2019 16:46:05 -0400
>
> > On Thu, Aug 15, 2019 at 4:42 PM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Wenwen Wang <wenwen@cs.uga.edu>
> >> Date: Thu, 15 Aug 2019 16:03:39 -0400
> >>
> >> > On Thu, Aug 15, 2019 at 3:34 PM David Miller <davem@davemloft.net> wrote:
> >> >>
> >> >> From: Wenwen Wang <wenwen@cs.uga.edu>
> >> >> Date: Tue, 13 Aug 2019 20:33:45 -0500
> >> >>
> >> >> > In pch_gbe_set_ringparam(), if netif_running() returns false, 'tx_old' and
> >> >> > 'rx_old' are not deallocated, leading to memory leaks. To fix this issue,
> >> >> > move the free statements after the if branch.
> >> >> >
> >> >> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> >> >>
> >> >> Why would they be "deallocated"?  They are still assigned to
> >> >> adapter->tx_ring and adapter->rx_ring.
> >> >
> >> > 'adapter->tx_ring' and 'adapter->rx_ring' has been covered by newly
> >> > allocated 'txdr' and 'rxdr' respectively before this if statement.
> >>
> >> That only happens inside of the if() statement, that's why rx_old and
> >> tx_old are only freed in that code path.
> >
> > That happens not only inside of the if statement, but also before the
> > if statement, just after 'txdr' and 'rxdr' are allocated.
>
> Then the assignments inside of the if() statement are redundant.
>
> Something doesn't add up here, please make the code consistent.

Thanks for your suggestion! I will remove the assignments inside of
the if() statement.

Wenwen

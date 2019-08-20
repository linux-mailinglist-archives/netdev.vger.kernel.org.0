Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7998C956D9
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 07:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfHTFtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 01:49:08 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:43187 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfHTFtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 01:49:08 -0400
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
        (Authenticated sender: pshelar@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 4E63D100005
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 05:49:06 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id s25so1534086uap.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 22:49:06 -0700 (PDT)
X-Gm-Message-State: APjAAAVCoRMzXGkZ19DjcO+auL3t2Vs1YuSGIpxOJMBH4vPuMbck+/3C
        YYzHWLQwnyTKKpxCv2uz9mvWTSS4alBtifPSYuk=
X-Google-Smtp-Source: APXvYqyPXH1Wm/m/mk37bn0XnByU7w4P/giiETPrj9CVVG5E8QKw+FEFQjO+XfFQeJwP6QPGOc6RuTnqp5vrVX1ah2M=
X-Received: by 2002:ab0:a8a:: with SMTP id d10mr15666627uak.64.1566280144937;
 Mon, 19 Aug 2019 22:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <1566144059-8247-1-git-send-email-paulb@mellanox.com> <20190819174241.GE2699@localhost.localdomain>
In-Reply-To: <20190819174241.GE2699@localhost.localdomain>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 19 Aug 2019 22:50:54 -0700
X-Gmail-Original-Message-ID: <CAOrHB_ANDffyHx41TKEMGyrM25ZGuYBAqTqujS9BdRSDjRyFJA@mail.gmail.com>
Message-ID: <CAOrHB_ANDffyHx41TKEMGyrM25ZGuYBAqTqujS9BdRSDjRyFJA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc chain
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:42 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sun, Aug 18, 2019 at 07:00:59PM +0300, Paul Blakey wrote:
> > What do you guys say about the following diff on top of the last one?
> > Use static key, and also have OVS_DP_CMD_SET command probe/enable the feature.
> >
> > This will allow userspace to probe the feature, and selectivly enable it via the
> > OVS_DP_CMD_SET command.
>
> I'm not convinced yet that we need something like this. Been
> wondering, skb_ext_find() below is not that expensive if not in use.
> It's just a bit check and that's it, it returns NULL.
>
> And drivers will only be setting this if they have tc-offloading
> enabled (assuming they won't be seeing it for chain 0 all the time).
> On which case, with tc offloading, we need this in order to work
> properly.
>
> Is the bit checking really that worrysome?
>
Point is this would be completely unnecessary check for software only
cases, that is what static key is used for, when you have a feature in
datapath that is not used by majority of users. So I do not see any
downside of having this static key.

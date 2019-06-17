Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4ED4923E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFQVSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:18:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37701 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQVSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:18:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id bh12so4685831plb.4
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 14:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYOD4WIEeBKnRcsb0ekNv9arASMm7g0t2+IXo/601vI=;
        b=H65QpEaeMls2Xmqxn0r8yV3MaQpBNh83aHKpmq07zghFPUw23x7cJ8TQVZYMXCGHA8
         cv/f6LnIhNEoefbelWMuUyjCKq++dV+gybxidwf8Ws+10j4AvGyZBcvlcU52pRpfNt6J
         LTpx1djugSO9d7ImlBw3Yl/rBBVU5AGVeycw1zoSdf+wugs8wLOX1gad2uBWNxUCWbNC
         Gf7jCyiqq56+kmt2NN3HTsGAKfdT7uLAvuv9mBm1J68NE7w80jqhgXfw9lXndU4TnXau
         1/xUjzKZOXIf+LTnxAtosSElPYoWBv+c9w9tvuz+y3nBlAUD8UcJc+XTDTcmBgnd3Gpw
         w1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYOD4WIEeBKnRcsb0ekNv9arASMm7g0t2+IXo/601vI=;
        b=PMwykWZLFrG+9IspGhSH0WxK3fvpO/s2aPpenlIVsQjMybmt+kkYs/z0fXjWxghzuZ
         eE3BLcoJzF6hfdFyCd0aPw90mPRLSzuAfOFikIQwidhw0W2lgI7A0L/GWj3PQ7ePrhyy
         vC+opYlUxI1E0ESiKPqeqYc5Z2+mRW4ohBCFXsf8YS9siyN81rdOoxl9VST/t+mtm9Uz
         v1xVNSsZHnqQdwoaO2GsKET+23o9g6QVIs6IUq40ii8/U7GSUpTh0LeX+uQeegx9dT/U
         g6G+RNSnIUYGXK3I5utTKRduNMZ42qg0dvPaKMYjJcmwWP/FLGeRhmnlhhxNrQb+CoyW
         LeRA==
X-Gm-Message-State: APjAAAVqOk8+UVVarTGjbzz8unJF392CowlXZlkyk4qdtOJLCtAbM9L0
        8/MGCh3LSqMbsjp8T1crS0vy6Z3igEDv96ILRik=
X-Google-Smtp-Source: APXvYqyirT1r1S/qLQmQMjaQPycBRHTUhOJP+BHGJZDu78LXlXTBtcxn7iVmTH7BgwOqKiC5wh2GxPDDcbjet6OsYzM=
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr32304428plr.12.1560806293728;
 Mon, 17 Jun 2019 14:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
 <1560447839-8337-2-git-send-email-john.hurley@netronome.com>
 <CAM_iQpU0jZhg60-CVEZ9H1N57ga9jPwVt5tF1fM=uP_sj4kmKQ@mail.gmail.com> <CAK+XE=mXVW84MXE5bDYyGhK5XrC_q3ECiaj5=WsXFV0FXBk+eA@mail.gmail.com>
In-Reply-To: <CAK+XE=mXVW84MXE5bDYyGhK5XrC_q3ECiaj5=WsXFV0FXBk+eA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Jun 2019 14:18:01 -0700
Message-ID: <CAM_iQpW+bnMG+43cyMJuLYCqEKM4jk5LbxGtsHFOFY=Ha7nZfA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: sched: add mpls manipulation actions
 to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 3:56 PM John Hurley <john.hurley@netronome.com> wrote:
>
> On Fri, Jun 14, 2019 at 5:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Jun 13, 2019 at 10:44 AM John Hurley <john.hurley@netronome.com> wrote:
> > > +static inline void tcf_mpls_set_eth_type(struct sk_buff *skb, __be16 ethertype)
> > > +{
> > > +       struct ethhdr *hdr = eth_hdr(skb);
> > > +
> > > +       skb_postpull_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> > > +       hdr->h_proto = ethertype;
> > > +       skb_postpush_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> >
> > So you just want to adjust the checksum with the new ->h_proto
> > value. please use a right csum API, rather than skb_post*_rcsum().
> >
>
> Hi Cong,
> Yes, I'm trying to maintain the checksum value if checksum complete
> has been set.
> The function above pulls the old eth type out of the checksum value
> (if it is checksum complete), updates the eth type, and pushes the new
> eth type into the checksum.
> This passes my tests on the checksum.
> I couldn't see an appropriate function to do this other than
> recalculating the whole thing.
> Maybe I missed something?

I never say it is wrong, I mean to say using a csum API is more
clear. Please look into checksum API's, there are many options
for different scenarios, there must be one serves your purpose.

Thanks.

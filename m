Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40DCFD3C3C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfJKJ0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:26:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45347 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfJKJ0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:26:55 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so19983425iot.12
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 02:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wJip+MK1HKfpS7Zjj3mcCMBUZIBPyN+WSmp3ZVDLBt4=;
        b=Y2WOAv605GBG8WC5RA2Po3+OTJTraIxmTwCWo+c9f9ENmzNYXuO9A35t4EvODoau+y
         zggZzL2lmpzHIP1DQmIlIfO8e/XFx/BjfBq2s1hyZiJiXl7wkekr4kk0mz/zPWpsnZFG
         5FQLYBi3zDVWu8SsK+UPVhyPKT2tuGen+Otm+yCxwdPFwDrMQI6xnNWvpAqiE7/KtSjB
         I/53TX5nE/nyClylJ0o2Bm0sLaeQhyaGH20ucT9b6SGszd+7L6Q0aRGBARrkHhujOg3H
         j0kpxb+Yv9WDIS0i54SCvp0C0cdboxEjXWR9ShPubuiqpXGLYRuCtbnH73VNUPFnAlO+
         6Smw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJip+MK1HKfpS7Zjj3mcCMBUZIBPyN+WSmp3ZVDLBt4=;
        b=uHOiZJl84Gt3/jJyr+moWJKsOYNURiNDS7CNO6Pw3/H8ka1VRIJgIXu+8+Ml/9kWD9
         lM+1jphTzr/btb1KIulCbWKexdx3UFewLK3+n/DkRCHcOuGIFs4Zm7Ndemjz4uJ/OHFw
         uj610x4ata2lCcguO1yN8X+9yjcbDctR9PfXO32cdTH4wD1rkqri9AGlM+8FHRmytGZg
         n4IjEfBJcvgr+0/MWYjTv6XoMPTwSAcfeRx/6FqG0Vh7hVgoU7DVLiPgonJdpubOWvl9
         BWzFK6pm9x50YRVd+u1jArEWwRMv3eqI+N8ldDY3s5C/y6mqFA8yI+OnPqrWCQrqBpQs
         7Tfw==
X-Gm-Message-State: APjAAAVGbM4RaiuvwxcjKNbD5vfRZUOF2P+g4bqf+1N9Mt+F0SZOq+dm
        nnMfIU84V+LcziC9+gYO9A47Rxg8aOJlEa5uOlX+hQ==
X-Google-Smtp-Source: APXvYqyxTVTvF26/Dh5TI1hOF3MQBIBS2wLHLM0oMBgwtkHz0WtHQHLKfT3WudOsFrerfnZDNP0oHL5LcUR/K9lpTnE=
X-Received: by 2002:a5d:8905:: with SMTP id b5mr3983593ion.187.1570786014769;
 Fri, 11 Oct 2019 02:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570732834.git.dcaratti@redhat.com> <d53ddea1cab35c3bd7775203aa8ce8f9a3b1ae6e.1570732834.git.dcaratti@redhat.com>
 <20191011073437.uwtftvhofrrm5r5v@netronome.com>
In-Reply-To: <20191011073437.uwtftvhofrrm5r5v@netronome.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 11 Oct 2019 10:26:44 +0100
Message-ID: <CAK+XE=mkg0=bX0pHuz9mVk1LbzmGqyN75hEhoNTZKtTyYfQFdw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: fix corrupted L2 header with MPLS
 'push' and 'pop' actions
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 8:34 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 10, 2019 at 08:43:53PM +0200, Davide Caratti wrote:
> > the following script:
> >
> >  # tc qdisc add dev eth0 clsact
> >  # tc filter add dev eth0 egress protocol ip matchall \
> >  > action mpls push protocol mpls_uc label 0x355aa bos 1
> >
> > causes corruption of all IP packets transmitted by eth0. On TC egress, we
> > can't rely on the value of skb->mac_len, because it's 0 and a MPLS 'push'
> > operation will result in an overwrite of the first 4 octets in the packet
> > L2 header (e.g. the Destination Address if eth0 is an Ethernet); the same
> > error pattern is present also in the MPLS 'pop' operation. Fix this error
> > in act_mpls data plane, computing 'mac_len' as the difference between the
> > network header and the mac header (when not at TC ingress), and use it in
> > MPLS 'push'/'pop' core functions.
> >
> > CC: Lorenzo Bianconi <lorenzo@kernel.org>
> > Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>

Acked-by: John Hurley <john.hurley@netronome.com>

> Reviewed-by: Simon Horman <simon.horman@netronome.com>
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539B5294727
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404208AbgJUEMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgJUEMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 00:12:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BAE621BE5;
        Wed, 21 Oct 2020 04:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603253562;
        bh=WwMaEJGS67O1ynzBgCYbwAVR6Y4hOs4XTNdOhgu1wIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WOjTvT4dyjyEmMp4OdCWXnGIRlG5eMMxSLw1ergNPmYz1Kvazp+CtYB+JH95Yulih
         CYuciWAM8OafKvXAj2XzJg55ncURP5G1BfWbkOt0Tp7JLxkf0pQnM1iM0ql2t1h67A
         Ilk5U3L+JlgJ1W6fRj3Uko/YEU57jjjzxOcRSmzc=
Date:   Tue, 20 Oct 2020 21:12:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Shuang Li <shuali@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: act_tunnel_key: fix OOB write in case of
 IPv6 ERSPAN tunnels
Message-ID: <20201020211240.04d005e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpWk_x6j7Ox=u8Om=dnrKUwU7zDpDghW3LExQLf0+8pL6A@mail.gmail.com>
References: <36ebe969f6d13ff59912d6464a4356fe6f103766.1603231100.git.dcaratti@redhat.com>
        <CAM_iQpWk_x6j7Ox=u8Om=dnrKUwU7zDpDghW3LExQLf0+8pL6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 17:33:22 -0700 Cong Wang wrote:
> On Tue, Oct 20, 2020 at 3:03 PM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> > the following command
> >
> >  # tc action add action tunnel_key \  
> >  > set src_ip 2001:db8::1 dst_ip 2001:db8::2 id 10 erspan_opts 1:6789:0:0  
> >
> > generates the following splat:  
> ...
> > using IPv6 tunnels, act_tunnel_key allocates a fixed amount of memory for
> > the tunnel metadata, but then it expects additional bytes to store tunnel
> > specific metadata with tunnel_key_copy_opts().
> >
> > Fix the arguments of __ipv6_tun_set_dst(), so that 'md_size' contains the
> > size previously computed by tunnel_key_get_opts_len(), like it's done for
> > IPv4 tunnels.  
> 
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you!

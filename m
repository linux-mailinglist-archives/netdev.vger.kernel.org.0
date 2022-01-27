Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4407049DAF0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 07:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiA0Gk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 01:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbiA0Gky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 01:40:54 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7538C06173B;
        Wed, 26 Jan 2022 22:40:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j10so1452290pgc.6;
        Wed, 26 Jan 2022 22:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n5qM1/vj9PwPlHTWllqmcE1wo+O1MivMDO+XLUTJELE=;
        b=mHOzz/IxobQr2uDXS5kwg0kN2MXqjdVkvvcQXiAM3ApIa/wNO7C0sy5ZP9deEhwWvn
         xxXfGSTd9l6m+e1lT2gr7ROGF1OIEepkqWQOiU+ODtaKhcA+pOgmCYb9FMsCr5AFwcsf
         dknaOdJqwkwUhn2BcU1YPZZCiAvud8yQuswsk2/f0za7aT5NBclimRevB7j4Uy2c0KPH
         M9RX1bVGk2ImF+J1LzjBXz8WnFttPBbxE9R7X4TWePsN4aEDjnNp9DeVzzS/Qaq+WTOO
         iTSbu0YS2p+Ro9/LLy9apcgJ+PXtWDVgDo2Ue3r/PJqDVTLgrPSluB09RTErWXpxnv6x
         TAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n5qM1/vj9PwPlHTWllqmcE1wo+O1MivMDO+XLUTJELE=;
        b=QT8EROZVPRSZAt3SLKkmzKS3Ay4KflgqVlTYtHGX9kyhB3tQD1+PJtnnuDaU80nl3L
         BUBN4B5OhN68ueAv2U7COsFE4fQVELomAjAV8gLD15be3FzLnJfa7tB55PspcHBvIbEd
         VzemJLN5yaSWZzPJeHjWmZH5y+LsoAaa8dAoxZoljE++3nYgDUw1fc4n8EvhFjDohnjQ
         rp7B1Z/qdhLaZIvMwNBu9lGTyGxLebR6xleCxpvTy21DQOf/bSVssOnA3m77nkcdMMbV
         z4Sf9GhygCnBxp0HI/cX9mVKd2Za7vo9PSrgeOj57mn60J/9U/740QA/bleNlw8AEEOi
         CmYg==
X-Gm-Message-State: AOAM530fOlmqXZK0j5Lo3eYRCBht3/ebqXR/jFoeJnwGod13uD3+3/0v
        Xa/WrOsWnrKeFi3tv5NhHIA=
X-Google-Smtp-Source: ABdhPJwuRAn1+/IQP06wgX2xDjlLknXkR0p05ZsovJpGTAS/WXfYZNW8OcSPrFTh4F0ON/A0z0a6SQ==
X-Received: by 2002:a62:750d:: with SMTP id q13mr1793409pfc.43.1643265653452;
        Wed, 26 Jan 2022 22:40:53 -0800 (PST)
Received: from Laptop-X1 ([8.218.130.160])
        by smtp.gmail.com with ESMTPSA id s9sm12849280pgm.76.2022.01.26.22.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:40:52 -0800 (PST)
Date:   Thu, 27 Jan 2022 14:40:47 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf 1/7] selftests/bpf/test_xdp_redirect_multi: use temp
 netns for testing
Message-ID: <YfI+b3JQw5w355Zd@Laptop-X1>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
 <20220125081717.1260849-2-liuhangbin@gmail.com>
 <61f22efcce503_57f03208c4@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f22efcce503_57f03208c4@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 09:34:52PM -0800, John Fastabend wrote:
> Hangbin Liu wrote:
> > Use temp netns instead of hard code name for testing in case the netns
> > already exists.
> > 
> > Remove the hard code interface index when creating the veth interfaces.
> > Because when the system loads some virtual interface modules, e.g. tunnels.
> > the ifindex of 2 will be used and the cmd will fail.
> > 
> > As the netns has not created if checking environment failed. Trap the
> > clean up function after checking env.
> > 
> > Fixes: 8955c1a32987 ("selftests/bpf/xdp_redirect_multi: Limit the tests in netns")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  .../selftests/bpf/test_xdp_redirect_multi.sh  | 60 ++++++++++---------
> >  1 file changed, 31 insertions(+), 29 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> > index 05f872740999..cc57cb87e65f 100755
> > --- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> > +++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> > @@ -32,6 +32,11 @@ DRV_MODE="xdpgeneric xdpdrv xdpegress"
> >  PASS=0
> >  FAIL=0
> >  LOG_DIR=$(mktemp -d)
> > +declare -a NS
> > +NS[0]="ns0-$(mktemp -u XXXXXX)"
> > +NS[1]="ns1-$(mktemp -u XXXXXX)"
> > +NS[2]="ns2-$(mktemp -u XXXXXX)"
> > +NS[3]="ns3-$(mktemp -u XXXXXX)"
> >  
> >  test_pass()
> >  {
> > @@ -47,11 +52,9 @@ test_fail()
> >  
> >  clean_up()
> >  {
> > -	for i in $(seq $NUM); do
> > -		ip link del veth$i 2> /dev/null
> > -		ip netns del ns$i 2> /dev/null
> > +	for i in $(seq 0 $NUM); do
> > +		ip netns del ${NS[$i]} 2> /dev/null
> 
> You dropped the `ip link del veth$i` why is this ok?

All the veth interfaces are created and attached in the netns. So remove
the netns should also remove related veth interfaces.

[...]
> ip -n ${NS[$i]} link add veth0 type veth peer name veth$i netns ${NS[0]} 
[...]

Thanks
Hangbin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C6549F154
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345562AbiA1CyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345558AbiA1CyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:54:07 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA5EC061714;
        Thu, 27 Jan 2022 18:54:07 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id d188so6123649iof.7;
        Thu, 27 Jan 2022 18:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tS81ruFsuho29ycHZi+M1HK42O7DPe+4ps0LHaE3qZY=;
        b=Pa04yQ9nWpYRy2QHaaLyCwejIe0+p2uxiPTfOEaa1pfRRpcep3QpYjdDPWpC2Y0wye
         snXZhbs6dTrgfu8bRejuySnzS0TykooSw1lyuelH+hytrWFTzt64brFiYk2sqHPeYOo6
         eRF6brh9RDyZjKqLO9AW/Ixmr9jNew3DOEW7Rv+mYSL2irA09uzCSi2BRFLLcecelP53
         q/LlPLd5Qu5BFq2MPKZxC0eGyC+e1tQFk6LA7N89jjYRQd5kaFyinIMnrEwuRsQoj7Mb
         wcueQEs6p0nl0vfuG8RxudVDtO/8KEYaI1KE/BJrvS7gmfF4pJlQvf4+sl9h/y4wdb6E
         4G9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tS81ruFsuho29ycHZi+M1HK42O7DPe+4ps0LHaE3qZY=;
        b=hqpR2n2G6uabuLMnVa/osOgLbtmJX6Dygy2LWUT34vGE0mwfYwRLbcdcPzeayrINIC
         G2i3S51YS+2d/Lsakte49tvpVfpjXnweg89lBENG7h/A0MYbaKzojT/TKOY1FwnPscfJ
         bHeUXWpVXQxJJ/zpHw8yAw+2WGCJaZ+j//qJwOBmfAQLboGrHFEapY7wAoJwz1VLEk6+
         6S42kku0I806Vj9rbCmgO4bgwtWQhp3alr5GUVJu92F1Hnw7ubeS/qrpqlC8FrIVsi7g
         3vLclnvd9RRMgDgneHzvT5L4aF+5floYiaR8HgWyg2QiTqFsPRyjOBKJGO38aS9fiIMU
         GeEg==
X-Gm-Message-State: AOAM532giYR9woNm7YNtr7NxaLyT5vmQKe91Xi/tt8vy5QQS0g7y/asT
        jz2tJW9P2PLbCOUwZ+QXjNU=
X-Google-Smtp-Source: ABdhPJwHuGwQJSP5jPhtwHimTGPfV3i8gGHw6mAwz1QH3W9q/DENQfom+cVZfWMNgKbXnpSx9UE8Tw==
X-Received: by 2002:a05:6602:13d3:: with SMTP id o19mr4136226iov.14.1643338446404;
        Thu, 27 Jan 2022 18:54:06 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id l7sm13203558ilv.75.2022.01.27.18.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:54:06 -0800 (PST)
Date:   Thu, 27 Jan 2022 18:53:59 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
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
Message-ID: <61f35ac73faa4_738dc20880@john.notmuch>
In-Reply-To: <YfI+b3JQw5w355Zd@Laptop-X1>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
 <20220125081717.1260849-2-liuhangbin@gmail.com>
 <61f22efcce503_57f03208c4@john.notmuch>
 <YfI+b3JQw5w355Zd@Laptop-X1>
Subject: Re: [PATCH bpf 1/7] selftests/bpf/test_xdp_redirect_multi: use temp
 netns for testing
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> On Wed, Jan 26, 2022 at 09:34:52PM -0800, John Fastabend wrote:
> > Hangbin Liu wrote:
> > > Use temp netns instead of hard code name for testing in case the netns
> > > already exists.
> > > 
> > > Remove the hard code interface index when creating the veth interfaces.
> > > Because when the system loads some virtual interface modules, e.g. tunnels.
> > > the ifindex of 2 will be used and the cmd will fail.
> > > 
> > > As the netns has not created if checking environment failed. Trap the
> > > clean up function after checking env.
> > > 
> > > Fixes: 8955c1a32987 ("selftests/bpf/xdp_redirect_multi: Limit the tests in netns")
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > > ---
> > >  .../selftests/bpf/test_xdp_redirect_multi.sh  | 60 ++++++++++---------
> > >  1 file changed, 31 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> > > index 05f872740999..cc57cb87e65f 100755
> > > --- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> > > +++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> > > @@ -32,6 +32,11 @@ DRV_MODE="xdpgeneric xdpdrv xdpegress"
> > >  PASS=0
> > >  FAIL=0
> > >  LOG_DIR=$(mktemp -d)
> > > +declare -a NS
> > > +NS[0]="ns0-$(mktemp -u XXXXXX)"
> > > +NS[1]="ns1-$(mktemp -u XXXXXX)"
> > > +NS[2]="ns2-$(mktemp -u XXXXXX)"
> > > +NS[3]="ns3-$(mktemp -u XXXXXX)"
> > >  
> > >  test_pass()
> > >  {
> > > @@ -47,11 +52,9 @@ test_fail()
> > >  
> > >  clean_up()
> > >  {
> > > -	for i in $(seq $NUM); do
> > > -		ip link del veth$i 2> /dev/null
> > > -		ip netns del ns$i 2> /dev/null
> > > +	for i in $(seq 0 $NUM); do
> > > +		ip netns del ${NS[$i]} 2> /dev/null
> > 
> > You dropped the `ip link del veth$i` why is this ok?
> 
> All the veth interfaces are created and attached in the netns. So remove
> the netns should also remove related veth interfaces.

Assumed so and just checked. Would have been nice to mention in the
commit so it couldn't be mistaken for a typo. Anyways Ack from me.

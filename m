Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238681EE6CE
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 16:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgFDOl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 10:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbgFDOl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 10:41:57 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF3C08C5C0;
        Thu,  4 Jun 2020 07:41:57 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n9so2272214plk.1;
        Thu, 04 Jun 2020 07:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Uk6PJ7Nzre4spAUUPUK7CAc4Akdbq548HfhSI26hbYI=;
        b=T0W+FRGOkYgkgG1NjbzAb2a6EANsfDB27gmlYxY/6fcea/KothkheSzJJNXQZqOahg
         zhIO2Qdv0YtQcTK6bs0t49VXuQsOlVShKwc2fjVd2sgt7RBABcWvVodP8U5nf8w7WXW8
         2OGWdy6a5TMS8DVEayp5mIcjB/wlJNHK40WtZ0KDiqakJtcEVA1jLmfPVcAlqVRnyU7n
         l1V6OMGAIZ+Nt8k8z5g0Wh6zWCKJo2v10JJEHGSTKHJQsnAOUzlkghzHwE++/H3hvEot
         RE3Tbk+KbjrzSXOOQ1BC0P/nbISieqOuriId5FZofSVGJs+Kda77RnaZToTJI2yPnpgf
         sAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Uk6PJ7Nzre4spAUUPUK7CAc4Akdbq548HfhSI26hbYI=;
        b=Zz/zOghxEFd+O0ETzj8Z3ZpGUKxUihpIoDfoI8p0tX7N2DYJjCLiGDJOJhxafoj5kx
         pg5g5vSguHetRA/oJ1Ey+BBKiwXnKBxHYCvkmyJQK8sumQDo+a/w6Axx3db8kfvEavLx
         uheX+BBQzzl4jaF4HORH56dNOIxNV8UfIHJ4m93hb3fZPAs4PBVc1yjDZ3QSFccdVi1L
         itbXFqk+YXmaGlBLsWd9kU6L/rXI2IamfZD6qq3ZUYL8wCz+IyHIDWJsVcZgWFh7Q+GI
         yK2g18PzMEVleJEJGaPUD6MAEp6DKGDuCGwLhXvx8Mdq/7y3xXcI3Ij66U2VexEacmh6
         qTEg==
X-Gm-Message-State: AOAM530fd5K5NcWjNpnLY0FJ41kxO2IiTNG7wfhY9cdrzLw01cATkQdL
        wWUEjThAebjT1btFg/FeIEE=
X-Google-Smtp-Source: ABdhPJw88RUGSpxEWmM4vBP4fPfOwYnZpQ/PPO96LJiYNYAS1w/xPF72Xfkc8aftyigEe2EjLQVm2g==
X-Received: by 2002:a17:902:8303:: with SMTP id bd3mr5245705plb.217.1591281716861;
        Thu, 04 Jun 2020 07:41:56 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1sm4617525pfn.76.2020.06.04.07.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 07:41:56 -0700 (PDT)
Date:   Thu, 4 Jun 2020 22:41:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200604144145.GN102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
 <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
 <87img8l893.fsf@toke.dk>
 <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
 <871rmvkvwn.fsf@toke.dk>
 <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
 <87bllzj9bw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bllzj9bw.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 02:37:23PM +0200, Toke Høiland-Jørgensen wrote:
> > Now I use the ethtool_stats.pl to count forwarding speed and here is the result:
> >
> > With kernel 5.7(ingress i40e, egress i40e)
> > XDP:
> > bridge: 1.8M PPS
> > xdp_redirect_map:
> >   generic mode: 1.9M PPS
> >   driver mode: 10.4M PPS
> 
> Ah, now we're getting somewhere! :)
> 
> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
> > bridge: 1.8M
> > xdp_redirect_map:
> >   generic mode: 1.86M PPS
> >   driver mode: 10.17M PPS
> 
> Right, so this corresponds to a ~2ns overhead (10**9/10400000 -
> 10**9/10170000). This is not too far from being in the noise, I suppose;
> is the difference consistent?

Sorry, I didn't get, what different consistent do you mean?

> 
> > xdp_redirect_map_multi:
> >   generic mode: 1.53M PPS
> >   driver mode: 7.22M PPS
> >
> > Kernel 5.7 + my patch(ingress i40e, egress veth)
> > xdp_redirect_map:
> >   generic mode: 1.38M PPS
> >   driver mode: 4.15M PPS
> > xdp_redirect_map_multi:
> >   generic mode: 1.13M PPS
> >   driver mode: 3.55M PPS

With XDP_DROP in veth perr, the number looks much better

xdp_redirect_map:
  generic mode: 1.64M PPS
  driver mode: 13.3M PPS
xdp_redirect_map_multi:
  generic mode: 1.29M PPS
  driver mode: 8.5M PPS

> >
> > Kernel 5.7 + my patch(ingress i40e, egress i40e + veth)
> > xdp_redirect_map_multi:
> >   generic mode: 1.13M PPS
> >   driver mode: 3.47M PPS

But I don't know why this one get even a little slower..

xdp_redirect_map_multi:
  generic mode: 0.96M PPS
  driver mode: 3.14M PPS

Thanks
Hangbin

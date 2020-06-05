Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EBF1EF155
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 08:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFEG0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 02:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgFEG0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 02:26:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973B8C08C5C2;
        Thu,  4 Jun 2020 23:26:17 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a45so2973582pje.1;
        Thu, 04 Jun 2020 23:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IRof0b1rFrwWWRJN8qOBPwgfMe6X5AOkvuliLGw1Vsc=;
        b=Bpjpe/8wXy/86s9EMI49DGRC48mS4AsGUndLn4M2QmXE/p6pyfOWJ2xokWLZru/Zxl
         RV9DgGKCKrzwwwqI/VwiiNCq0vhUvkLFOrJk6rnJBRzGNph8bZRdYx8PV9xj92ogaKTW
         3LzZiYdJ56SHYaIn46r4y+HjeWsJ9SRMKEYi3zDIEqh71uHsNDKNPLMywngZhfO2Pizg
         4O3pjuVx75qVFNru/BebhxPOYb8CVgWq1ZEQpLBrlkaci3eb3s5N4DOG8mPOm5FTP7tK
         an2NKelMynAJEt17swvuotgmpS08qzgO/hk/UNYMph3TtoyRjVk3nYD2wmuHYjVokgpe
         fNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IRof0b1rFrwWWRJN8qOBPwgfMe6X5AOkvuliLGw1Vsc=;
        b=dZrrRi1vVVN23U/x+tjC3M5yqAsjbsUiwYW+6sOf8Pxw8ocWt6pILJiTVVveD1vRX0
         aGH5Ncr+X2kS1eTVzw2Nsxn1PbdY6jv6qencAW8NWI9Jd9tc9ZVCheZQmu7E+6ogBYic
         9j4XAr9poPr772hWNB1MYfsIw/fRLs97aPsT+Ys3mOmG4MniwV06LBDbbSdG2Ldhpr8l
         cI5BK2WVsm0SRsqQroqDJi5r46JR/Ls6TGyZKlRpiRS1J6M2og732rPHLm5FIpIeCkas
         +2IaluwAspPTVy4p4C8+HbuJ7uRWYJ10mbYdyyIwIJtYpnYkagMTZIqL07i5ARZdtanF
         8tvA==
X-Gm-Message-State: AOAM533p/QRgcrKcFoX1g0jVrY4COc2pi/N8vSQhxXoYb9ZUvWvt3F5E
        vaRgAEGcb6k1ewEBiwP9J+A=
X-Google-Smtp-Source: ABdhPJyZ7wEAW9kU4s+T6lyF/Are+J1ZDJ6DeV43NRnom9K8PcISpZOuCuz6luwDSQPACrUchs3Gug==
X-Received: by 2002:a17:90a:d104:: with SMTP id l4mr1229681pju.25.1591338377072;
        Thu, 04 Jun 2020 23:26:17 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u128sm1852679pfu.148.2020.06.04.23.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 23:26:16 -0700 (PDT)
Date:   Fri, 5 Jun 2020 14:26:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200605062606.GO102436@dhcp-12-153.nay.redhat.com>
References: <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
 <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
 <87img8l893.fsf@toke.dk>
 <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
 <871rmvkvwn.fsf@toke.dk>
 <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
 <87bllzj9bw.fsf@toke.dk>
 <20200604144145.GN102436@dhcp-12-153.nay.redhat.com>
 <87d06ees41.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d06ees41.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 06:02:54PM +0200, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > On Thu, Jun 04, 2020 at 02:37:23PM +0200, Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen wrote:
> >> > Now I use the ethtool_stats.pl to count forwarding speed and here is the result:
> >> >
> >> > With kernel 5.7(ingress i40e, egress i40e)
> >> > XDP:
> >> > bridge: 1.8M PPS
> >> > xdp_redirect_map:
> >> >   generic mode: 1.9M PPS
> >> >   driver mode: 10.4M PPS
> >> 
> >> Ah, now we're getting somewhere! :)
> >> 
> >> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
> >> > bridge: 1.8M
> >> > xdp_redirect_map:
> >> >   generic mode: 1.86M PPS
> >> >   driver mode: 10.17M PPS
> >> 
> >> Right, so this corresponds to a ~2ns overhead (10**9/10400000 -
> >> 10**9/10170000). This is not too far from being in the noise, I suppose;
> >> is the difference consistent?
> >
> > Sorry, I didn't get, what different consistent do you mean?
> 
> I meant, how much do the numbers vary between each test run?

Oh, when run it at the same period, the number is stable, the range is about
~0.05M PPS. But after a long time or reboot, the speed may changed a little.
Here is the new test result after I reboot the system:

Kernel 5.7 + my patch(ingress i40e, egress i40e)
xdp_redirect_map:
  generic mode: 1.9M PPS
  driver mode: 10.2M PPS

xdp_redirect_map_multi:
  generic mode: 1.58M PPS
  driver mode: 7.16M PPS

Kernel 5.7 + my patch(ingress i40e, egress i40e + veth(No XDP on peer))
xdp_redirect_map:
  generic mode: 2.2M PPS
  driver mode: 14.2M PPS

xdp_redirect_map_multi:
  generic mode: 1.6M PPS
  driver mode: 9.9M PPS

Kernel 5.7 + my patch(ingress i40e, egress i40e + veth(with XDP_DROP on peer))
xdp_redirect_map:
  generic mode: 1.6M PPS
  driver mode: 13.6M PPS

xdp_redirect_map_multi:
  generic mode: 1.3M PPS
  driver mode: 8.7M PPS

Kernel 5.7 + my patch(ingress i40e, egress i40e + veth(No XDP on peer))
xdp_redirect_map_multi:
  generic mode: 1.15M PPS
  driver mode: 3.48M PPS

Kernel 5.7 + my patch(ingress i40e, egress i40e + veth(with XDP_DROP on peer))
xdp_redirect_map_multi:
  generic mode: 0.98M PPS
  driver mode: 3.15M PPS

This time the number looks more reasonable.

Thanks
Hangbin

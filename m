Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45101F3276
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 05:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFIDD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 23:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgFIDD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 23:03:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6C7C03E969;
        Mon,  8 Jun 2020 20:03:56 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so744827pjs.3;
        Mon, 08 Jun 2020 20:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o1xdnqtB0eVQDLfx59H38+2bM7V5x3vfyxVg2OMwsd4=;
        b=DSp8WUmfuA4+3D5VcKP+ZMoH8myBBpC/9l61ZE4iVgV9Iou2IM90B0iiVhQ+Xu5FnN
         iHqajEujKXP9U9+Og19F5i/GHc/UgPNfFrlej9FybM44BQhVdUdWAVQs3vk+46KFtd9c
         CT+gzmb02f76sFXIr3cvc7J25clNxBd8rcDB04dFu6Bn5YR5SE7to75adcXaN9waH1tj
         Px+UMc5zLlevn0yqZB88XiepRp2duK0Avu+66B1o6okZaAieLks9SPme7olwPx9SRyJv
         9VWtqBIlxglm8L2NOgCOBEIkSXKahVoJ3vOCcVqO0/4HjBKEQ0k5JH6M3lnUPbFJgWrb
         XwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o1xdnqtB0eVQDLfx59H38+2bM7V5x3vfyxVg2OMwsd4=;
        b=as1lyNkitdda7E+lYRdit96S9hX8tsO0ImfAOvOk25ZGgFBi+utfUd/8C/+D+K7E20
         d/XTX9KaL2z1ruyl/ylVgx8CKxx33hwj3PlVlqtP8XBKi7DtZMxgYCxYq94b9pIYKPxn
         95TPdVQRY/rVh1aFDv0n+Dg+9CA3y6zf4r3furFj7VRuK7uJMThMi6+xI59avwetRpYf
         YK+aOfi96NEvK9ET9QUFo6+WGrQ0Tyxbo8fpUkWd+eaLJ+90Vtj6kF+yj0MDsQe1RpAe
         IyjPAhn/J+SLcOZ8TxVJMYhU/b2Bptfzw0O7OUXJ6TU0GWTnrVcvEObocrTXquFAevMf
         eehQ==
X-Gm-Message-State: AOAM532tASoRWFPHF3TwKoXOclJgD023mod3rEuEinTihcHelv1byJKV
        LdidN5nNic6/jwgIf3Aj070Lu4soxDYTxg==
X-Google-Smtp-Source: ABdhPJxsiyCOP98DpLPuhVw1J/zX9ZVMMsnYITkaeiQbeL1OmgX4XWHV93r7SxpD5R8g6SgjcHVNZA==
X-Received: by 2002:a17:902:aa48:: with SMTP id c8mr1522401plr.128.1591671835936;
        Mon, 08 Jun 2020 20:03:55 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z8sm776966pjr.41.2020.06.08.20.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 20:03:55 -0700 (PDT)
Date:   Tue, 9 Jun 2020 11:03:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200609030344.GP102436@dhcp-12-153.nay.redhat.com>
References: <20200603024054.GK102436@dhcp-12-153.nay.redhat.com>
 <87img8l893.fsf@toke.dk>
 <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
 <871rmvkvwn.fsf@toke.dk>
 <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
 <87bllzj9bw.fsf@toke.dk>
 <20200604144145.GN102436@dhcp-12-153.nay.redhat.com>
 <87d06ees41.fsf@toke.dk>
 <20200605062606.GO102436@dhcp-12-153.nay.redhat.com>
 <878sgxd13t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878sgxd13t.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 05:32:54PM +0200, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > On Thu, Jun 04, 2020 at 06:02:54PM +0200, Toke Høiland-Jørgensen wrote:
> >> Hangbin Liu <liuhangbin@gmail.com> writes:
> >> 
> >> > On Thu, Jun 04, 2020 at 02:37:23PM +0200, Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen wrote:
> >> >> > Now I use the ethtool_stats.pl to count forwarding speed and here is the result:
> >> >> >
> >> >> > With kernel 5.7(ingress i40e, egress i40e)
> >> >> > XDP:
> >> >> > bridge: 1.8M PPS
> >> >> > xdp_redirect_map:
> >> >> >   generic mode: 1.9M PPS
> >> >> >   driver mode: 10.4M PPS
> >> >> 
> >> >> Ah, now we're getting somewhere! :)
> >> >> 
> >> >> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
> >> >> > bridge: 1.8M
> >> >> > xdp_redirect_map:
> >> >> >   generic mode: 1.86M PPS
> >> >> >   driver mode: 10.17M PPS
> >> >> 
> >> >> Right, so this corresponds to a ~2ns overhead (10**9/10400000 -
> >> >> 10**9/10170000). This is not too far from being in the noise, I suppose;
> >> >> is the difference consistent?
> >> >
> >> > Sorry, I didn't get, what different consistent do you mean?
> >> 
> >> I meant, how much do the numbers vary between each test run?
> >
> > Oh, when run it at the same period, the number is stable, the range is about
> > ~0.05M PPS. But after a long time or reboot, the speed may changed a little.
> > Here is the new test result after I reboot the system:
> >
> > Kernel 5.7 + my patch(ingress i40e, egress i40e)
> > xdp_redirect_map:
> >   generic mode: 1.9M PPS
> >   driver mode: 10.2M PPS
> >
> > xdp_redirect_map_multi:
> >   generic mode: 1.58M PPS
> >   driver mode: 7.16M PPS
> >
> > Kernel 5.7 + my patch(ingress i40e, egress i40e + veth(No XDP on peer))
> > xdp_redirect_map:
> >   generic mode: 2.2M PPS
> >   driver mode: 14.2M PPS
> 
> This looks wrong - why is performance increasing when adding another
> target? How are you even adding another target to regular
> xdp_redirect_map?
> 
Oh, sorry for the typo, the numbers make me crazy, it should be only
ingress i40e, egress veth. Here is the right description:

Kernel 5.7 + my patch(ingress i40e, egress i40e)
xdp_redirect_map:
  generic mode: 1.9M PPS
  driver mode: 10.2M PPS

xdp_redirect_map_multi:
  generic mode: 1.58M PPS
  driver mode: 7.16M PPS

Kernel 5.7 + my patch(ingress i40e, egress veth(No XDP on peer))
xdp_redirect_map:
  generic mode: 2.2M PPS
  driver mode: 14.2M PPS

xdp_redirect_map_multi:
  generic mode: 1.6M PPS
  driver mode: 9.9M PPS

Kernel 5.7 + my patch(ingress i40e, egress veth(with XDP_DROP on peer))
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

The performance number for xdp_redirect_map_multi is not very well.
But I think we can optimize after the implementation.

Thanks
Hangbin

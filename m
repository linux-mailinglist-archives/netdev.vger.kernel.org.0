Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C061FAD06
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 11:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFPJrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 05:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgFPJry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 05:47:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA720C05BD43;
        Tue, 16 Jun 2020 02:47:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d8so8145206plo.12;
        Tue, 16 Jun 2020 02:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyzotmJAnQ0cO3PA3sh0jydiotSQu+gi/7YbTkbxVqE=;
        b=JVhzLE9IQDEj7CTZuW7r+KWDWaw4Kdq/aOJuO8edzp50C4uLNigiM63mI1eUXgmkQw
         y++pw9y/L6I1hPhJOmKxrWDo/nAIuMM12Oj2WVhGP3+RQH0Ddgp4qRxNY7Gm0Cja8YF3
         Z+s1/dkZLlz+JEzEurdnduIfDaGnlBSA5ckVgK46kzPbe7HgSwGMKVBAJV/P6hcDsjr5
         ZTVjNNEUPZ8JbhRq5EIWQh13eW+R3O9lGbgvaVWnk+PYoXLpuTW4lOJq5QQIKOK5tNvw
         Bb+8OmLpY9lwC4baj8bEwJyYDAWvS8H+VIBOMBCUZa2WQCSO3jCqkz8wBQVuIpPaAhU2
         8LuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kyzotmJAnQ0cO3PA3sh0jydiotSQu+gi/7YbTkbxVqE=;
        b=XPjZrLSvYpf8nV8QkxPXsj1grXea1ln841wAUJWGTkGHpWy/rzpHH46E4Mb9J4l60z
         jUNpYW39mz0nVRJshuK5DGatFDTYPuQQL58bosbSaivj2QQjr2JLKshwhmq18YEeG8cm
         EzgVgD7DCOFRPb4x1rinF8jqMmRwjH9NBjHoSwO+qfeCZdWr98BXG8+Dt66JA6tSU5bb
         0faJN7T1Ly+rk43TNejWelHK+DiG8YbP4iKk1d4CIb3agMoEUtp8orPHxSFwwSfBk7Ds
         FO1RXXOzg009zmyxirNdh1Di50iV6SrJ1Cu6Tnk+MentpmVGmqxQuJNQgr8zlf+FZxGP
         5QHA==
X-Gm-Message-State: AOAM532fMyuVhAjkSlv3dj334lHFX9WnYCtnehHHmUaFwwU0YjUmQpoS
        WHi6DBjDZSlGLu6M3wuipQw=
X-Google-Smtp-Source: ABdhPJyOcnV1ct/4P9EcX0Q1kCE4tXQukYRbQg8WHlAEskv8l362aw1Y0x97BrNubz8SGPdpUsjNzQ==
X-Received: by 2002:a17:902:558f:: with SMTP id g15mr1383273pli.174.1592300872792;
        Tue, 16 Jun 2020 02:47:52 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j5sm7490428pgi.42.2020.06.16.02.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 02:47:52 -0700 (PDT)
Date:   Tue, 16 Jun 2020 17:47:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200616094741.GU102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
 <20200527123858.GH102436@dhcp-12-153.nay.redhat.com>
 <87lfld1krx.fsf@toke.dk>
 <20200616110922.1219ec5e@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616110922.1219ec5e@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:09:22AM +0200, Jesper Dangaard Brouer wrote:
> > > BTW, when using pktgen, I got an panic because the skb don't have enough
> > > header room. The code path looks like
> > >
> > > do_xdp_generic()
> > >   - netif_receive_generic_xdp()
> > >     - skb_headroom(skb) < XDP_PACKET_HEADROOM
> > >       - pskb_expand_head()
> > >         - BUG_ON(skb_shared(skb))
> > >
> > > So I added a draft patch for pktgen, not sure if it has any influence.  
> > 
> > Hmm, as Jesper said pktgen was really not intended to be used this way,
> > so I guess that's why. I guess I'll let him comment on whether he thinks
> > it's worth fixing; or you could send this as a proper patch and see if
> > anyone complains about it ;)
> 
> Don't use pktgen in this way with veth.  If anything pktgen should
> detect that you use pktgen in virtual interfaces and reject/disallow
> that you do this.

OK, got it.

Thanks
Hangbin

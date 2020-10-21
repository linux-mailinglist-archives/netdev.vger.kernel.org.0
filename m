Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F6294918
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 09:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502070AbgJUHwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 03:52:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502066AbgJUHwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 03:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603266774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJOdTyhI/dub5oZWC0RRrxke8AfF/6NA81FyCUT56ZA=;
        b=arWmnMoTH8HVH8MScKXtdfbbRQ8/uvgpURrEHv8z927JcQDWzBStcBc3/dqXaDB/iCxQDf
        mg3w/yCdZis8/RlG1yFiX9CTv9UYMOOhQO/85cIFptctRYKLHZz+aAS0UmjgkDHAcIrfvj
        l4vPIewizvBGUjquMGSxLdZawg4OLz0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-NzbHUWWNMwiOjbLPkGo-Pg-1; Wed, 21 Oct 2020 03:52:50 -0400
X-MC-Unique: NzbHUWWNMwiOjbLPkGo-Pg-1
Received: by mail-wm1-f70.google.com with SMTP id u5so199471wme.3
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 00:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZJOdTyhI/dub5oZWC0RRrxke8AfF/6NA81FyCUT56ZA=;
        b=euo+Z6PxFD/f1KjCH9JIZqr4zZJKJ5NASc4nGHhheNx9A7YvquxaKkz5sxZ15aqk7u
         dCihm9J0+dh9U04ss4GdKSx984ipLQjn3qIVQE8hQXuciB+S/jAH3iueWaLCdorSZ8Fz
         Dl7ThinY44FxfpYI/ZHpciT414I4t+QRUNTn/gLew4rlyTL0feidLvLrFUVmMsZPjd3H
         YjF9ko012j374r5YMpND9ymE5j0woAO3sLaANZurG2vbWnIhkrL8U7j+BnMWwjFERgtm
         qNuHe+eKAz4Yx0oaOi8vRU83nVG8bJLQXvs0dzb6cljb3raOeCSXVUTtKiKN2PZsIquu
         z0qw==
X-Gm-Message-State: AOAM531+B+gTOXWe+RNbTijrb2prbpe7Mbuv55Yu/EUdiMCUMn1u0g6e
        vgDERcphr4YELiPM6GesBU1IvR32Yk0jEPwBctBVG5UJ+EiN5nA36hICFjlZ6HtgxXOoin7RVLl
        Bixw3I1AvGRh9e//t
X-Received: by 2002:adf:9f0a:: with SMTP id l10mr2923916wrf.427.1603266769244;
        Wed, 21 Oct 2020 00:52:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMN5BmJiN6AH7AIcTE+JbHN8jA9gEgCL6xTJ52VhUPXiYFEv4EunVtqQFbSXrC2dTBobNGGA==
X-Received: by 2002:adf:9f0a:: with SMTP id l10mr2923900wrf.427.1603266768990;
        Wed, 21 Oct 2020 00:52:48 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p4sm2422181wrf.67.2020.10.21.00.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 00:52:48 -0700 (PDT)
Date:   Wed, 21 Oct 2020 09:52:43 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Po Liu <Po.Liu@nxp.com>
Subject: Re: [PATCH net] net/sched: act_gate: Unlock ->tcfa_lock in
 tc_setup_flow_action()
Message-ID: <20201021075243.GA3789@linux.home>
References: <12f60e385584c52c22863701c0185e40ab08a7a7.1603207948.git.gnault@redhat.com>
 <CAM_iQpXEPshoMYc5hkePa85T-H5uP3EGfHFRSDDqYrLuuB-bbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXEPshoMYc5hkePa85T-H5uP3EGfHFRSDDqYrLuuB-bbg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 05:37:22PM -0700, Cong Wang wrote:
> On Tue, Oct 20, 2020 at 8:34 AM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > We need to jump to the "err_out_locked" label when
> > tcf_gate_get_entries() fails. Otherwise, tc_setup_flow_action() exits
> > with ->tcfa_lock still held.
> >
> > Fixes: d29bdd69ecdd ("net: schedule: add action gate offloading")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> Looks like the err_out label can be just removed after this patch?

That'd require reworking the error path, as err_out is used there. I
don't feel that doing so would improve readability much.

> If any compiler complains, you have to fix it in v2, otherwise can be in a
> separate patch.
> 
> Other than this,
> 
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.


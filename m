Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DD240FEA9
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhIQRcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231855AbhIQRcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631899870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aEhlSynRz4N3FlqjKloHS3Kh6FbRHHHviXrUI8c+7hU=;
        b=efrrvyKp1zgzZm/y6FIufpIdLg9Uwap++8HwOaWXm58ORNFcL3vxlvRSAG10izvxWbF7RU
        CPagKpikeYdrUPE1ae2Qb3e28CaSRvLqnkZg8ePDvkn0WKwpple4qMH1LyDPoh8V7JXVoh
        tR5BZv0eWT/V5hETH3Pu/CiJgvVRDJA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-BAXfB_1zNsScRGDqnN35_A-1; Fri, 17 Sep 2021 13:31:07 -0400
X-MC-Unique: BAXfB_1zNsScRGDqnN35_A-1
Received: by mail-wr1-f72.google.com with SMTP id m1-20020a056000180100b0015e1ec30ac3so3966584wrh.8
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aEhlSynRz4N3FlqjKloHS3Kh6FbRHHHviXrUI8c+7hU=;
        b=AXp7H5IwiPHOjjXIsaYaRPE2bpFm4UEr6wEgazHBeSKHGClbHA9DJoftQPIQjJiw7g
         RraGKSYZ4PVTcrYk0xj+rLcerH2EpRJhsrRdU27UYoE60bswsVydCBS/uOy6zjIGehfD
         WVCpjibHPBOy1goz8Wji6TIGtylfZPZGXuKZc0KAYwV2pfAixNloo/mSRd/piqjYLy3o
         dOOMB0t7UTmr+dJFAxHdIFbGYJThNi2DtTVrHhksu/EPtkbpk4kX+hd0NCXoxUkuwqiE
         1zBCFVPPWHpfDbotIlnq/oDILDZTPkzgzXS6EBIXPrwBSLx3m7v4ULR1D4SxsNdf0M6m
         cPEg==
X-Gm-Message-State: AOAM531BKpM/ZTTPl56qZs/nVfUmZOPa4l34GnN4Q3qTyeYoKxYKWlPb
        HhDrZQS44vl0zKLlyvQBHCEWFwOiXi+91teQ/N1pho5kVzfkL1EitQuldtVM5YYgvnh6PJuLkGp
        j6oPz+ltldvctXNnB
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr16611802wmc.3.1631899866381;
        Fri, 17 Sep 2021 10:31:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzVIUlMhzaUcH8l76E4hgTLORUq4B9hZOc19zV/fBmI/JkObBLUeLEOY5d8c74bW5TKIB7kQ==
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr16611785wmc.3.1631899866185;
        Fri, 17 Sep 2021 10:31:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-134.dyn.eolo.it. [146.241.244.134])
        by smtp.gmail.com with ESMTPSA id a72sm11730585wme.5.2021.09.17.10.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 10:31:05 -0700 (PDT)
Message-ID: <ef20848328710215a2d237dbbab18ca953737c5a.camel@redhat.com>
Subject: Re: [RFC PATCH 4/5] Partially revert "tcp: factor out
 tcp_build_frag()"
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Date:   Fri, 17 Sep 2021 19:31:04 +0200
In-Reply-To: <CANn89i+e7xVLia3epGLpSR70kxuTMyV=VtKGRp3g0m56Ee30gQ@mail.gmail.com>
References: <cover.1631888517.git.pabeni@redhat.com>
         <aa710c161dda06ce999e760fed7dcbe66497b28f.1631888517.git.pabeni@redhat.com>
         <CANn89i+e7xVLia3epGLpSR70kxuTMyV=VtKGRp3g0m56Ee30gQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-09-17 at 09:41 -0700, Eric Dumazet wrote:
> On Fri, Sep 17, 2021 at 8:39 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > This is a partial revert for commit b796d04bd014 ("tcp:
> > factor out tcp_build_frag()").
> > 
> > MPTCP was the only user of the tcp_build_frag helper, and after
> > the previous patch MPTCP does not use the mentioned helper anymore.
> > Let's avoid exposing TCP internals.
> > 
> > The revert is partial, as tcp_remove_empty_skb(), exposed
> > by the same commit is still required.
> > 
> 
> I would simply remove the extern in include, and make this nice helper static ?
> 
> This would avoid code churn, and keep a clean code.

I thought you would have preferred otherwise. I'll make the helper
static in the next iteration.

Thanks!

Paolo


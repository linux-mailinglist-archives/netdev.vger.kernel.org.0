Return-Path: <netdev+bounces-587-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1296F8528
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CABE728103B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816C7C2C8;
	Fri,  5 May 2023 15:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7341933D8
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:00:23 +0000 (UTC)
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCD317DFD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:00:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5208be24dcbso1305459a12.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683298821; x=1685890821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NGdHYh9CCDHket38KLIMwIPku307zLIOZN52Q7dOE8=;
        b=cCyFUUT8pv20RSiDCmfJApHpznGJPieNzWhrw/7cim9OQpz8lztoRmXb/5BRDLw3nY
         smNTuaTnGXx7iuyoK5u05Bx/wNYDV66j73UQTYRShwHF/J/xyQFQn5ueaFAaT002KiNS
         AGYYOXqmZWc/2HbKq3LEnkT+te+wCxqbbJHuSyH/PcW4I3DXIhpXDC2PQ58G9IBU4JyD
         L3Vhei4WpslJbgs2bszbVa4q7/3LZJ6176Tnj3J0wEkHeQVUmPRveNH3cR+TuiSnQLCC
         KIgXMe3yDbMXWPGq1zOIYCU3smy3E8zHRK8qBQQTwLuMvKYTXwu0Q8YrzmOZbSSI6jIs
         l3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683298821; x=1685890821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+NGdHYh9CCDHket38KLIMwIPku307zLIOZN52Q7dOE8=;
        b=fGzDZX/nCVP+P1MlyeqE6Wom/ZgB/qeutbf+VWRGmeMAF7tZzR/UmIvmmS93GbYNPN
         XsqfFvW44yMyYYVbtKApNNEoi37lW2+vf9RDE/NeaIBI14boH+5oKVxM189BDiLGLZ3S
         i9/OnXpIzbXj2Kn1o0kfgRXMA3pGskX0LBQRYYMLNOYr04rbtE1VpuNX1/n3lSzlqKCI
         4H+oYtLlrDd/8XywLO45oDLjWrCBPlROa5HSbZRw/5u0Rx9hSXMmiRoz3DM6mgjvoU6Q
         GceTwUcMvtywwqVvDi4u/ON4wTaJqJ42eFUbSBTriZ2wcPyo1TChl9ARabQjIWf+Fd1Z
         Qn+g==
X-Gm-Message-State: AC+VfDzsaEou0XViGiW26yu2mI7lzt6uQgNskVcwCvdRxjlQN7n7XJnE
	wuXSEbXLb0WhVuK+io3u/1PgWw==
X-Google-Smtp-Source: ACHHUZ7PNWPoZgS18PJru+g1hywsbjanMWlxSjyoef1kUxSYms+TrZDat03GqXLncdoF6urHJ6r7Pw==
X-Received: by 2002:a05:6a21:2d05:b0:ed:1355:f88a with SMTP id tw5-20020a056a212d0500b000ed1355f88amr1704629pzb.46.1683298821234;
        Fri, 05 May 2023 08:00:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id i26-20020aa787da000000b0062dd8809d6esm1759156pfo.150.2023.05.05.08.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:00:17 -0700 (PDT)
Date: Fri, 5 May 2023 08:00:14 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: David Ahern <dsahern@kernel.org>
Cc: Aleksey Shumnik <ashumnik9@gmail.com>, netdev@vger.kernel.org,
 waltje@uwalt.nl.mugnet.org, Jakub Kicinski <kuba@kernel.org>,
 gw4pts@gw4pts.ampr.org, kuznet@ms2.inr.ac.ru,
 "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
 gnault@redhat.com
Subject: Re: [BUG] Dependence of routing cache entries on the ignore-df flag
Message-ID: <20230505080014.67bdd6cb@hermes.local>
In-Reply-To: <20230505031043.GA4009@u2004-local>
References: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
	<20230503113528.315485f1@hermes.local>
	<20230505031043.GA4009@u2004-local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 4 May 2023 21:10:43 -0600
David Ahern <dsahern@kernel.org> wrote:

> On Wed, May 03, 2023 at 11:35:28AM -0700, Stephen Hemminger wrote:
> > On Wed, 3 May 2023 18:01:03 +0300
> > Aleksey Shumnik <ashumnik9@gmail.com> wrote:
> >   
> > > Might you answer the questions:
> > > 1. How the ignore-df flag and adding entries to the routing cache is
> > > connected? In which kernel files may I look to find this connection?
> > > 2. Is this behavior wrong?
> > > 3. Is there any way to completely disable the use of the routing
> > > cache? (as far as I understand, it used to be possible to set the
> > > rhash_entries parameter to 0, but now there is no such parameter)
> > > 4. Why is an entry added to the routing cache if a suitable entry was
> > > eventually found in the arp table (it is added directly, without being
> > > temporarily added to the routing table)?  
> > 
> > What kernel version. The route cache has been completely removed from
> > the kernel for a long time.  
> 
> These are exceptions (fib_nh_exception), not the legacy routing cache.

I tried to reproduce your example, and did not see anything.
Could it be the multicast routing daemon (pimd) is watching and adding
the entry?


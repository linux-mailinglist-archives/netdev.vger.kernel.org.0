Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A4A2D2999
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 12:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgLHLMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 06:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgLHLMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 06:12:37 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031E5C0613D6;
        Tue,  8 Dec 2020 03:11:57 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w6so13607082pfu.1;
        Tue, 08 Dec 2020 03:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TH/uPORjkOAtDa2UQZ3J5kFBagiraxudgrtcpy7b0qA=;
        b=HatnHftiGOo8iw5vuSU4099PGMpefy2tstA43iJUZLrFlZI8v6A5KiXrVqyoYvrM54
         VREc2ti6Sb9BWBwAy4D+Mdmy88rjWsThsbfPLFIf8etrWVMKgoNNzwx/tEtVQi7MBgUY
         2LWcHFxpanpWpNlvjFnn4GDrjaznOrEXCAlwQDFpQOc6mCcHEttLhoIcP1Y5GjABt9NA
         J7BnJd93R+JDqOmV4Xq90w0L+WfbpKCo+L6YQkCLPrX1Y9/TfCY3E84SABT0tPMRTAQM
         WM1R9hOvolIkrHxZhqGszDzrzRLKgbQ67YySgNHkL5dF82mY1uKdvXwgpLtAQWLzTBTg
         4LUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TH/uPORjkOAtDa2UQZ3J5kFBagiraxudgrtcpy7b0qA=;
        b=OCDojNzy9fo1zaqAXFq2Hg7LiLvitaEF2ATeRKeAAaQz1KHN6VGhy4b1H1VEVsWR+1
         EpR2m/Nihkh2+3W/bMRsJw3I1YUkTpPB3AH5hXD2frFvHeteWRL8PIxVUKFgnPsDeUEb
         guQOIqpgLSHDC1Y8tLcdVbIfE7GuZB/bxbgsBlLtrSvf7GEB5ugLvvAAQOGgAZI+T3ue
         T7FUCxSUtqAO1S86hlsFmhaOTxLidUSN1bpEQ6u7iJJulA/dtfh3cGT6NmzzVcPDRNnq
         g/ehZnCIA4whq+HH090IQh+8EH1QCsh+V42RsBWIbOeDfDOC0AQxD0YDRkbzrxxeROb8
         IaZQ==
X-Gm-Message-State: AOAM530hTs09dV0M3Q+IrIbnQzje3r6ynoV98Yz2Ek10Seax1excHVPx
        xyUiPWOvW2il+2+S0nltdCI=
X-Google-Smtp-Source: ABdhPJxc72qYuapyzgvowaUTPy3c4neXGx5/5gT4XVxeY/42UVlkj1dLoWNaB217eqx/eWxtWpF5tA==
X-Received: by 2002:a62:b501:0:b029:19d:d2eb:210 with SMTP id y1-20020a62b5010000b029019dd2eb0210mr13626810pfe.78.1607425916641;
        Tue, 08 Dec 2020 03:11:56 -0800 (PST)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x10sm14982504pga.70.2020.12.08.03.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 03:11:56 -0800 (PST)
Date:   Tue, 8 Dec 2020 19:11:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201208111145.GF277949@localhost.localdomain>
References: <20201126084325.477470-1-liuhangbin@gmail.com>
 <20201208081856.1627657-1-liuhangbin@gmail.com>
 <20201208113914.7fe9e291@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208113914.7fe9e291@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 11:39:14AM +0100, Jesper Dangaard Brouer wrote:
> > +	/* If -X supplied, load 2nd xdp prog on egress.
> > +	 * If not, just load dummy prog on egress.
> > +	 */
> 
> The dummy prog need to be loaded, regardless of 2nd xdp prog on egress.

Thanks for this remind, Now I know why the pkts are dropped with I do perf
test on physical NICs.

Regards
Hangbin

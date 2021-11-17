Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645B453ED9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhKQDWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhKQDWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:22:42 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF951C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:19:44 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s138so961602pgs.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pBvTALBTJT+8zrl8QzaVlyuv6HmLp1NpzuAenIYXXpg=;
        b=plZ/+DJO+Uuk0IIW4nNsP2CiRGrevUdYlzcezdhvBIGecm5uGsHmG1kkUTb2vDNXDd
         lHqN7Onjf5KwMxJzU0We56QsNPpRRXqESbF75H+Dt11cW2bLo3KvC3CZLuI1YluCHhM0
         rLBdP49mdDVmYVO/khsCorhXsegOkvE0fSJ1ISpK3jRMx4oCHwJCFcM+sXUosLe1CiYo
         EUe9eEqT/Gq2+6lCE5SPp1bbSD3Z8hf/x+XrSdk7/1cxqbl/sUrUZfDgOhQ29kKKolYA
         WOEH6AzJAQeCikf4le1t8jLWv9BW8N8tIthVT7+4faut24OFJZZFCZvpj/hf1gC9H8dv
         pxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pBvTALBTJT+8zrl8QzaVlyuv6HmLp1NpzuAenIYXXpg=;
        b=ipo5bsYRfk7xrE3AU5INLvqczJAm5t/gZzxDPbEAEG92QXWrmgoFrmAzs3KsnSel1y
         g+ZGUAFhqDcSWPPclZ3HAWWsr7ZVBDNglqae21N+IQPn+T41dzqYHNaQwywPTuQhk0s+
         5h+iE/6Bs80dXPdX3w6D8CPQRuQBXGT1jI/jxv5Z3l/hSvdWpMsDb3oOf8QBLYG6KqHC
         7wF1YvhMpWQ2DGfij21u+67scc9dYD8GcEiTPrxYb3YfoekqZGOgHWmVAFQu4LRazoyh
         pBWrHnT01AFXw1o1/RyyiZO75NUPFBCoBMJzo2XMLtLW3SEEb3P39PcLzRfKbLyNwh8h
         VgTg==
X-Gm-Message-State: AOAM53256B357InIbAfhIjiiogw4HjIFOymG3RmpipvCA1zUIipK9dBI
        thKS77z0RYUgfVKEba2aVCLyQK1Mj+s=
X-Google-Smtp-Source: ABdhPJyWrDjf+OXVKhyQbv3fkAhyF9OrKI+OgPvDZrSA7k5jpM1jYP01sSgy5dmnZzhRVOAW4zRsTA==
X-Received: by 2002:a63:5023:: with SMTP id e35mr2889628pgb.284.1637119184242;
        Tue, 16 Nov 2021 19:19:44 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t40sm20731777pfg.107.2021.11.16.19.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:19:43 -0800 (PST)
Date:   Wed, 17 Nov 2021 11:19:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
Message-ID: <YZR0y7J/MeYD9Hfm@Laptop-X1>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
 <YYuObqtyYUuWLarX@Laptop-X1>
 <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 14, 2021 at 09:08:41PM -0800, Cong Wang wrote:
> > Hi Wang Cong,
> >
> > Have you tried this test recently? I got this test failed for a long time.
> > Do you have any idea?
> >
> > IPv4 rp_filter tests
> >     TEST: rp_filter passes local packets                                [FAIL]
> >     TEST: rp_filter passes loopback packets                             [FAIL]
> 
> Hm, I think another one also reported this before, IIRC, it is
> related to ping version or cmd option. Please look into this if
> you can, otherwise I will see if I can reproduce this on my side.

I tried both iputils-s20180629 and iputils-20210722 on 5.15.0. All tests
failed. Not sure where goes wrong.

Hangbin

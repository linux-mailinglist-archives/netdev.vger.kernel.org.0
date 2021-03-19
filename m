Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED53834208D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhCSPHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhCSPHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:07:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C368BC06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:07:14 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id r12so10255989ejr.5
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bGD6x0tPecnhinDKnHZu/CdzaVF9l2QBFMD0XEfM6uI=;
        b=aQIC3IO8ekz1FCCQkelvLZnY4qS+9jJQRg2pw4Io5Y0leEYvLhBVWmFmcxZ14TQVA6
         VRTgTB1QYMY5ix3RsYZ3r06KNWaWPDZNnFNLCyguhSJhNsqGGcTfdU+hbDfVnHf1LfJy
         T68fnAxtMO5Rj6VJr0/GHvPEw2DKVASe+9LHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bGD6x0tPecnhinDKnHZu/CdzaVF9l2QBFMD0XEfM6uI=;
        b=skJiV3+wy88ZfGp+7XCEtNFaiXbwJIh+GgsZWsEPhOZkAGtyP1VyF9QhTUl7x8K5Ji
         Vg6mjqMoR4dBRi9s2pPmHVi4gjoiIvBq1DZVkZEUM48QvvpwHHjbxAFgvnXlDumeOvvS
         /RDuyNInZkzI1O8+D1xC2dMKxeBobRwyk8kXt3W8Woj3DYymGOJQ30W7YTOvUIkaJ7my
         GkGdm4SdGWh5T0zKXNU/sCK9yHxn/IRkNy3sNbSXi+oiiOdVr8j4/w9/NIsZevR7v6Jc
         /xdaveqNxT1dxo3ehkXj/rRibXlvNCmr3K2CIeAAcrm/p5qo+QYfOUDj584+3BtGsKdE
         UpDg==
X-Gm-Message-State: AOAM533NdluGiFfFMpihbdLYnAnu91c6oLFvc1RTwUS5HC200vrBGnpC
        CYB2H94qnk59YzaUIn8Ak5dacQ==
X-Google-Smtp-Source: ABdhPJz+lP+srO1DUhiDPl6417LDuRyqXKPV5TLJWUSrcf8gzEjr5zExnXdLwd7rRxpWnazgrRW38Q==
X-Received: by 2002:a17:906:405b:: with SMTP id y27mr4954560ejj.332.1616166433503;
        Fri, 19 Mar 2021 08:07:13 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:fa59:71ff:fe7e:8d21])
        by smtp.gmail.com with ESMTPSA id e17sm3783613ejb.54.2021.03.19.08.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:07:13 -0700 (PDT)
Date:   Fri, 19 Mar 2021 15:07:12 +0000
From:   Chris Down <chris@chrisdown.name>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] SUNRPC: Output oversized frag reclen as ASCII if
 printable
Message-ID: <YFS+IFFRs5f1itQN@chrisdown.name>
References: <YFS7L4FIQBDtIY9d@chrisdown.name>
 <3844BF67-8820-4D6C-95BA-8BA0B0956BD0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3844BF67-8820-4D6C-95BA-8BA0B0956BD0@oracle.com>
User-Agent: Mutt/2.0.5 (da5e3282) (2021-01-21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Chuck,

Thanks for the (very) fast reply! :-)

Chuck Lever III writes:
>> This can be confusing for downstream users, who don't know what messages
>> like "fragment too large: 1195725856" actually mean, or that they
>> indicate some misconfigured infrastructure elsewhere.
>
>One wonders whether that error message is actually useful at all.
>We could, for example, turn this into a tracepoint, or just get
>rid of it.

Indeed, that's also a good outcome. Personally I've never seen these 
legitimately fire in production outside of cases like the one described, and we 
historically ran a pretty diverse set of use cases for NFS.

Maybe safer to convert to a tracepoint just in case? Either way sounds fine 
though -- let me know what you'd like for v2 and I'll send it over. :-)

Thanks!

Chris

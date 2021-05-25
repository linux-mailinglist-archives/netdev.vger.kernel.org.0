Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7E390151
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEYMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhEYMuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:50:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12584C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:48:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso11397056pjb.0
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fl69MKpw50sBn4p4bXdbF1N2VaniDbW3PbbALk2V8Tc=;
        b=nb2IWL2twSXRTc5cG+MW4MOsyTMOtQLq9wTcjq5fnndf4Hwhqkr7OVsCbkjCPTl9LJ
         ScqwKqWSOGa3nILmKa6uNS1QwtRDPNWeuXkzdbjiouroklO/PHblJ51jMaEW/yYMoG3V
         9LC059dNymclbzrB4urzEFJA1g10iJm0qCgyIl4fkewr79TGsAKg5FDCTnSOcZfoixfo
         SjNaezhojgZVAUHA/KnxVBJdoXyG2R7ZHXFUjjwvSntDBLubQPoqmBVw1s+QYUHTajJB
         CCcsyUqxXLF7/8Fb2Ev0GLMkTHxANrjV1vDWFTcBdv/+0utYiOkk27kUoJSFmsgjOlbF
         NO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fl69MKpw50sBn4p4bXdbF1N2VaniDbW3PbbALk2V8Tc=;
        b=AruZHhKCHhteY79qwt+TYHvFOjI4vR8zOb03NZNt0QWYLsj5JYBL+6nv15KlVtQj19
         KLxlCQoT7RcIxdpYC6Tf4R5fTtXM/AUsulrTjiwAWx/b+4d6hefawiiWdb+UNdQXR/e+
         hACZ87omeJ6GlImZb3axOnVal/MxmpTp9W9z6DqRrQCDU7mlf6axOiwskvIGUxcNtNCa
         6Zzk7QsHMV5ZVDyafu3q3PKPwXlXbEz9tluf07qtGHni+vBN7ia/xlToN9Lx3rswppEB
         gDtxfEEnsyPOzv/wqHPX2ilvJI5QeCvjmxWPtc46b58RMDGE6IJy4cJ8tBNr25eWMqkH
         TWQA==
X-Gm-Message-State: AOAM533N31OCBfAWwV0rpR+zxugowWW2Gk4B+ehOENoSnasjLWjtdl02
        +CMOwTnJT/XQtji0na05vJE=
X-Google-Smtp-Source: ABdhPJxuzB4H7abTIod2Kcd+tusKOA4oPE0O97C++ky3PxP+Ud39m+GNby5qBJvUQEKWA448zc1SKw==
X-Received: by 2002:a17:90a:1c02:: with SMTP id s2mr30064968pjs.172.1621946931637;
        Tue, 25 May 2021 05:48:51 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i29sm14629410pgn.72.2021.05.25.05.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:48:51 -0700 (PDT)
Date:   Tue, 25 May 2021 05:48:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Message-ID: <20210525124848.GC27498@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525123711.GB27498@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 05:37:11AM -0700, Richard Cochran wrote:
> Instead, the conversion from raw time stamp to vclock time stamp
> should happen in the core infrastructure.  That way, no driver hacks
> will be needed, and it will "just work" everywhere.

For transmit time stamps, we have skb_complete_tx_timestamp().

For receive, most drivers use the following cliche:

	shwt = skb_hwtstamps(skb);
	memset(shwt, 0, sizeof(*shwt));
	shwt->hwtstamp = ns_to_ktime(ns);

So the first step will be to introduce a helper function for that, and
then re-factor the drivers to use the helper.

Thanks,
Richard

 

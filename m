Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFD1403295
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 04:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347240AbhIHCYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 22:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347250AbhIHCYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 22:24:00 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C7C06175F;
        Tue,  7 Sep 2021 19:22:53 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id e16so738089pfc.6;
        Tue, 07 Sep 2021 19:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=RgKpPDodG3G5oLWhYuKNMeJdFTTOJJB0RNkReJ0NUcw=;
        b=R3aTWtDcq6OEPruWydNlWcCuhPQOTZh38ifMO0YYkI2RtcN8BOaFlFIPOFIetS6hLm
         lE9XRhFuw0NiGnNrApwroNdTVkGBN6+drWHFfVZtrLHxSyhjHYvEC+3zHfQQ3DDvVEQw
         DWd/xBKG8GgDtMpXx+hm4vv84Vy0J9fBiPcbAE6zmSu55kZ3zJ31dA6CJDjfjuyNx9zY
         5wJZCBwRbvFUtZ5RxYF3FHhdxSSfvlFvSyRwxEgiSaUYxmsclAl8BU2uYGdFIomvXuR4
         Cgdm6mMfqCJkIgN5nJVufdlXNEiBIysOBBydrKsG6OMhVPLGL6Ox/TXYKbIz9oK0Pl66
         +kbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=RgKpPDodG3G5oLWhYuKNMeJdFTTOJJB0RNkReJ0NUcw=;
        b=cuCTG+bZ9R45/YApcYrU0Dz8XpgBn7SXXAefxZe9hrW71CAhWGJefIXetaUFZ1HReI
         BHeAcEu2x5cKrXry3TRDLssERkttsbnSBoZmciS9lBOGMX88XHO7DjhexLYsx9ywUL+N
         wDQPOFbf2raVWNIItJxFLa9lX4Din5eGiQsuN391K9avJv+5PTgTjbVtDYtO6OIuIipF
         gNLyvXKTNMOiyhChKEwbCZGPlNP8UMgZYynJGUX840ZwhRh6cpZtVZhZQAQbWjbpHvfg
         I4QdiNYiO+vlh/ZAvwO5IX2wwBekyKIu3A+ZcfQKjfGEJ4N9IpTwKdoq0DRLoBwvhikM
         LmHQ==
X-Gm-Message-State: AOAM533WUf6V7/xMK2Fhx77GYPMn4OK/4SG1fxKxFc2DWGPRLMHnCVLm
        RxGuXkF4dw4XmaoLKp4kd07X/c7XU82Pgw==
X-Google-Smtp-Source: ABdhPJxYE3fKWGUVetuvwfA/m57aNn0CUrXx82i9bK8h75ppM+lWtRKW12hARoe9d818bHP9PuhMNQ==
X-Received: by 2002:aa7:9f10:0:b0:414:ab4e:7c53 with SMTP id g16-20020aa79f10000000b00414ab4e7c53mr1380478pfr.59.1631067773331;
        Tue, 07 Sep 2021 19:22:53 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n11sm330633pjh.23.2021.09.07.19.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 19:22:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 8 Sep 2021 12:22:44 +1000
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v2] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <YTgedODOPAQboQlm@slk1.local.net>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        Florian Westphal <fw@strlen.de>,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
References: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210907135458.GF23554@breakpoint.cc>
 <r46nn4-n993-rs28-84sr-o1qop429rr9@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r46nn4-n993-rs28-84sr-o1qop429rr9@vanv.qr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 05:11:42PM +0200, Jan Engelhardt wrote:
>
> On Tuesday 2021-09-07 15:54, Florian Westphal wrote:
> >> -	/* Try to get same port: if not, try to change it. */
> >> -	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
> >> -		int ret;
> >> +	if (htons(nat->range_info.min_proto.all) == 0 ||
> >> +	    htons(nat->range_info.max_proto.all) == 0) {
> >
> >Either use if (nat->range_info.min_proto.all || ...
> >
> >or use ntohs().  I will leave it up to you if you prefer
> >ntohs(nat->range_info.min_proto.all) == 0 or
> >nat->range_info.min_proto.all == ntohs(0).
>
> If one has the option, one should always prefer to put htons/htonl on
> the side with the constant literal;
> Propagation of constants and compile-time evaluation is the target.
>
> That works for some other functions as well (e.g.
> strlen("fixedstring")).

When comparing against constant zero, why use htons/htonl at all?

Cheers ... Duncan.

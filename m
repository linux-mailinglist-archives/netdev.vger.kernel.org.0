Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB73518A5
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhDARqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhDARlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:41:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF4EC00F7D4
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 08:06:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ha17so1313362pjb.2
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 08:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pqB5cCC/Jqcw+wkSt2/1lFjptsGclZ/CAukxZnCa79U=;
        b=hIqfbooU8DpK4C+ZGXLR6X0oujJvp8X52S6vDN4ergb7HgdU1tAQT+MT/idk4Q6LnV
         cReiqTDhJuZDNOd/4UOasU+V0bKxPRHFz3huDs523vvr01t8T35H/ykVB9bUKp3HN5Oy
         FjKnQYutACnCkZ8HzaqgnY5O5DERdTCBd9VRVFUPQ9ThD6orrVMpQzE/IeYU0Ik+Ciq8
         ybTHcLocTIG2CaGtmzfIk11iepbmf05O9N6iNVXvjfdRxnzfbwMI60VtYpETZRVt6GFT
         LoL6i0AFiHM6ngRb0+Kmmi0rEcep8U8DNbsoD4ufwvyZ/qarYDRpGBETwK8cjOxCYh2z
         yx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pqB5cCC/Jqcw+wkSt2/1lFjptsGclZ/CAukxZnCa79U=;
        b=K52fmKqobT6QOc0LRUs38DrCvFrIv3Hdz7IVT8LgYvpx05Ne73j7Y/9jkX1RaP+Cfz
         guP1zKlYd9WU3w7fLP1jq3LCHEKpjPtVbNxXeJsnIhp8peGIs0/lUUrODq/0FqlxLW2j
         kpACNctX7wgZGUWd5ptoT+1azWiu9Uq6GLtUrNGqo9J1dlmTx+OF9eMA6pNXQOJxr1N9
         cBFkjIxpiBGpi4bg4rcijYvgEzpoAV5y9zdBSm5xZuwQX3ZNnhsfaRazdiWxrbXMabVr
         v21uVt4uNd37v3BpHyxZinErLVJmIed1uId4HWTJtkoKnWkMLV+Gtl74nPXfQWhzU9Kz
         2QPg==
X-Gm-Message-State: AOAM533Co/n8uDnVNFyCoIgdka46/ezPqp92c3Q/r/HDwKep/uTx8g8a
        3VsR83/4f8PeolaF04pZqO3OMzP6uc3/Jw==
X-Google-Smtp-Source: ABdhPJy/3I/CIYWtFtcW1iznK2tds49Ijz9TIJhZHiEswS/THCHlUcmmjD/SchuTeMTTbd5RdrETTg==
X-Received: by 2002:a17:90b:4c0a:: with SMTP id na10mr9650562pjb.227.1617289610348;
        Thu, 01 Apr 2021 08:06:50 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id i7sm6037880pfq.184.2021.04.01.08.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:06:49 -0700 (PDT)
Date:   Thu, 1 Apr 2021 08:06:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Hongren Zheng <i@zenithal.me>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [RFC] add extack errors for iptoken
Message-ID: <20210401080640.34cc6777@hermes.local>
In-Reply-To: <2854a1c9-ca3e-312d-c94f-12aea1469bc0@gmail.com>
References: <YF80x4bBaXpS4s/W@Sun>
        <20210331204902.78d87b40@hermes.local>
        <2854a1c9-ca3e-312d-c94f-12aea1469bc0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Apr 2021 08:31:05 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 3/31/21 9:49 PM, Stephen Hemminger wrote:
> > @@ -5681,14 +5682,29 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
> >  
> >  	ASSERT_RTNL();
> >  
> > -	if (!token)
> > +	if (!token) {  
> 
> You forgot to add a message here.

This branch is unreachable, function is  only called from place where it is not NULL.

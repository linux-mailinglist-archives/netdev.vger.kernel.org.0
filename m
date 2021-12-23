Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2347E899
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 21:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350193AbhLWUDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 15:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhLWUDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 15:03:24 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAF6C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 12:03:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so6845367pjc.1
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gcq6QhZOGjt2BvPoa5butYmz3+sYb4kzZ7U5c4e3NkA=;
        b=L0IIe8mjv8kvVSzF7NgDX7G/KmpyRCXVKM7g9a8dFsxbcjh6e2WP/GCZCQf15n+WdI
         15h2VHnWH3R7ggpGOrM1fxzdSe0tYhDOYGxH+lyQQ/nLRboZ6oEqh6fwlkBa/OLr9vou
         eHGHLSBgFf+cAGBKbzz5KOwdnJQ2B9eZZsjIabkUGkv3rDwIOfOwidn7mCGZgRRe/O0/
         3sUZwOJFB7Vovin5tkdybhg147kBtOwf4gE0a/40Fnu+BbLBRkVJ0GSL8pf2BPYyqN90
         pkVT+Oo45mviwqHQ2FPleAfpAu8Kdj1psUFDC76nHKZmeRIe61YexjtS7nVdwc7T+7ux
         l0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gcq6QhZOGjt2BvPoa5butYmz3+sYb4kzZ7U5c4e3NkA=;
        b=Vf5FY1JK8PbEEfUcJ0pqjad3PJCWfYWcv59XX12WShUbycOzHmHWIpa3i9XHdFBS7W
         4EXoV7VzpLYAfF+/BjxYfFIkiLNAY9Ua2cwZmK6KIPTmMKSaSkqhGBiNEyiZkoavRKPK
         ndN3QsMom1XGkHr7KP/5wuI4po4urGwdb5P+XXUe+wQ/eiBA5w7KaNcofXoVwWo+lyzD
         Fmq7elYSB4VV7B+epwbrJq3FSxIFUyr/uzJONpwNfKJj030I5qQ43WkRmFAS8wMpB803
         ozONE987SeTM+0VlC4UOQHrGdZ2M6CFNSS8LKWrTuHOgkRAsDciTdzvuSWB/o2pqwzAS
         JU3Q==
X-Gm-Message-State: AOAM532MGmHlpqDb1fN/kFHj46j+HQAj55DmoQTcvOGmMbcEz3OY/KHT
        T9p4ZIweu3IqMq2EdEP/LqfCNLSzOE8=
X-Google-Smtp-Source: ABdhPJxVMIe2MZt6v9it0MTX1wnua9DmtrAViKcXRPsJmht14ji7licaP5YYdGPX0CQ8Ctbb9Rhn/g==
X-Received: by 2002:a17:90b:3810:: with SMTP id mq16mr4490485pjb.190.1640289803385;
        Thu, 23 Dec 2021 12:03:23 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c2sm7099410pfl.200.2021.12.23.12.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 12:03:22 -0800 (PST)
Date:   Thu, 23 Dec 2021 12:03:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ruud Bos <kernel.hbk@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Message-ID: <20211223200320.GA29492@hoboy.vegasvil.org>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028143459.903439-1-kernel.hbk@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 04:34:55PM +0200, Ruud Bos wrote:

> The added EXTTS function has not been tested. However, looking at the data
> sheets, the layout of the registers involved match the i210 exactly except
> for the time registers mentioned before. Hence the almost identical
> implementation.
> 
> v2:
>  - fix PEROUT on SDP2/SDP3
>  - rename incorrectly named sdp function argument to tsintr_tt
>  - fix white space issue
> 
> Ruud Bos (4):
>   igb: move SDP config initialization to separate function
>   igb: move PEROUT and EXTTS isr logic to separate functions
>   igb: support PEROUT on 82580/i354/i350
>   igb: support EXTTS on 82580/i354/i350

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>

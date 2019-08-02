Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F9A7EA85
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfHBC4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:56:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38910 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfHBC4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:56:34 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so53755185qkk.5
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AGcsiVskghKXKTPwmk4P4JA0sIIcQz2X4jy5Em4AmC8=;
        b=hsdn6aqqkOnymE2HgFmv9WV2k1diZ5VIWvhfEVFicAI+f5QcIe8ovHPyufx8cXq2AU
         oJOoC+rANwmmnA2yAN+lICss4ugdRztzzv7fhukfFVtMb5AactqVbujYzoKSBZeqVxte
         pkBoMBj9TuCo7siwxi2DlaT62jiRDW8FOkdJlAYDwueRkwUX9yBlakwuMB6v+Stan0LK
         XC7iZKbaTN+RiLjmviwi3v01RdVYvMHQVLusBF2MW8VVM1cIZj2/8o4NUeSM8PGpVmGt
         L4kyOH2tkf2/ubdf5XY5h9cigQBP4rnBL0e0APIpPo8juxcAUijO6l1sgoVM/mXZ/knT
         XRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AGcsiVskghKXKTPwmk4P4JA0sIIcQz2X4jy5Em4AmC8=;
        b=BNYs6D9YmP82+8QG69CTTBgiLxL1DNMOFDMmvMdmQIzlln4XBGivuT7A7UnKOjZiwr
         Hx8kYTzQs5cXNolbGijfek1tV/rqWhvB+/tNEm749c0WK1xRo00KJFO77ls43HSDMokj
         p3UhiBhvYqtPbsCt2GPXBXTvxFH+vdOBzeohdkqFVmdHoitBEUWn6bOV9RG/cWgC6r2R
         wdaoG93EmDoaZxmvRs/F2iHYPwk4RlxORWfZcQm6EzvgL59hPoaXbaaRBG9Ttz+yuKt2
         4+hhZ5v8WbZFdngI9xES/lPMMxP43WZ15wdJP0oqy53MvVI3OSAfrpLSgukKVjUQZ/PD
         D+7w==
X-Gm-Message-State: APjAAAWzABb8zee4/TCMgs53QsGlIQTzKm/oCKzqygBidOkFru0CH5Ec
        Ex8BJi/KFZbvzWnf7x4IJG5yxg==
X-Google-Smtp-Source: APXvYqyYZi4yt1e1ehHUYDiKwdTUpM0xPNEVpILsB7fjpu4rSy2YTQxg25vtKeU2tM7Zn6waReWrSg==
X-Received: by 2002:ae9:f801:: with SMTP id x1mr79486878qkh.242.1564714593159;
        Thu, 01 Aug 2019 19:56:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e125sm30096769qkd.120.2019.08.01.19.56.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:56:33 -0700 (PDT)
Date:   Thu, 1 Aug 2019 19:56:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
Message-ID: <20190801195614.0742c12b@cakuba.netronome.com>
In-Reply-To: <43995d3c-dff5-3000-317c-09b119c61565@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
        <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
        <20190801161129.25fee619@cakuba.netronome.com>
        <43995d3c-dff5-3000-317c-09b119c61565@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 10:47:26 +0800, wenxu wrote:
> > After all the same device may have both a TC block and a NFT block.  
> 
> Only one subsystem can be used for the same device for both indr-dev and hw-dev
> the flow_block_cb_is_busy avoid the situation you mentioned.

AFAIU that's a temporary limitation until drivers learn to manage
multiple tables.

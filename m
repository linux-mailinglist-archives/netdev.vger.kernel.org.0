Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E552100D75
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKRVMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:12:45 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43922 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRVMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:12:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id y23so20625971ljh.10
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 13:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ENBvXr5Rye+5NJiBGsqw2psDWzyDbL2JRjE4BUFAezY=;
        b=0Y6rTN0LMun6f1POClA5jNe4z2veaAJ29lPnfntBSLMrsYDRBgTQyA7D2VM65AcLyf
         tEKIcVioatfBwNqK++h/Gl+QnA6D10J03wPlbe4PCgokhGLcdXQLKw7Zf5aAabgCEsp9
         rN/T/iHkPqHeAzexTV1gxSctHDPsRcq534pvWNboGsPT/mIB6Yxv1PKhcvWeJam6Kxkb
         HRoGK5kaxecN5uNjcZISSNVJv2kVCb1RYbtlyXcPEmY8DqaKff30eGzx0Tx1ZvKBdsvu
         hHRjuQ7iKn04oqX2tNhZ8+b0Nqv3jCjw4qe083eWriyYZR4K2Elb/VbG9SJ8CSMj5eZc
         QmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ENBvXr5Rye+5NJiBGsqw2psDWzyDbL2JRjE4BUFAezY=;
        b=oeC0SSqgNFwisDeyTcmeav2rDWG8Mxz5QXo0xQiHNN1Oz05W+udJ0zgbimBZC56p+C
         x6KwC+HUhlXp9wXKeQLwwW1H4DMOxfYkN6EY+6LruvzyXVrjD4JPqqQ1wfCYK1iLgDKh
         Oj54aTTwUepcOFygTvqXyJwTdP3JrrgD0Rb2oq/sdfAbssY0uiMvRPL/C6o7ghjPhWxQ
         2NenNOo1NI/GBN0e08NjsBhVFzQy90I0HHhwK2wfxqG9A4jxk8sxCznEXe/Dotuvz095
         wKXOmOrGpohYqCY3UVv+tB1kuI6fz3fapQUdt4bddLAAqXSKSsiHB3+2cDfT0hjq0+rG
         p2gg==
X-Gm-Message-State: APjAAAXsfKzBFXsBku6DqXVYc9Ww5H3ZJNUz3gwdA00jWiVPT/PsGAXA
        I/4/EQXnE6roe3+4bGKYTxDInQ==
X-Google-Smtp-Source: APXvYqwV2SF9dFI6JMFwf1ONK2T0V+1jMBgnNKHYQsIIISXFtXYyp+qbIGaMe7eFBeFoCxBZtB134Q==
X-Received: by 2002:a2e:9ad8:: with SMTP id p24mr1117280ljj.114.1574111563067;
        Mon, 18 Nov 2019 13:12:43 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p5sm8809699ljg.57.2019.11.18.13.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 13:12:42 -0800 (PST)
Date:   Mon, 18 Nov 2019 13:12:30 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 01/15] octeontx2-af: Interface backpressure
 configuration support
Message-ID: <20191118131230.6114a357@cakuba.netronome.com>
In-Reply-To: <1574007266-17123-2-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-2-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Nov 2019 21:44:12 +0530, sunil.kovvuri@gmail.com wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> Enables backpressure and assigns BPID for CGX and LBK channels.
> 96xx support upto 512 BPIDs, these BPIDs are statically divided
> across CGX/LBK/SDP interfaces as follows.
> BPIDs   0 - 191 are mapped to LMAC channels.
> BPIDs 192 - 255 are mapped to LBK channels.
> BPIDs 256 - 511 are mapped to SDP channels.
> 
> BPIDs across CGX LMAC channels are divided as follows.
> CGX(0)_LMAC(0)_CHAN(0 - 15) mapped to BPIDs(0 - 15)
> CGX(0)_LMAC(1)_CHAN(0 - 15) mapped to BPIDs(16 - 31)
> .......
> CGX(1)_LMAC(0)_CHAN(0 - 15) mapped to BPIDs(64 - 79)
> ....
> 
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Can you explain what is being done here from user perspective?
How is this thing configured? Looks like you just added some 
callbacks for device-originating events?

And please keep the acronyms which are meaningless to anyone
upstream to a minimum.

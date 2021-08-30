Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7B3FB8A3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhH3PA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbhH3PAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:00:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329E5C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:59:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d5so3891886pjx.2
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2c9VQdN0RHnrAkMcvDlTkPtl2CCpI8pZmnib4CuptTQ=;
        b=UwPQfPanVnASPC7FguEG3o3FzsQU5Fd1lpo8lCEKig4/4CJ+rJT3NqU0q0+qGGHQjM
         DRP40UuObggA3+eNyajtH6oRxnnhxcuYvq/c846WdFhkvCWr0ghaZdi7ba4xKhs0gWAl
         QVBmfnt/2NH3/2tXLjZ9JDje5+FtQD8gNOdHa+1hw7SPu1bht3vFYgyyXuJKl++DeZ5m
         LPDtAI0Qe6ti+j9zYSX6U4xjrOoI56NfjXBBCCzpT0Vkk2a2fVHPu9vQ1/o5fXecb7iG
         Uq8VavCUsKOkDb7YPaKZVTk3/PY1x9vO9tmT/YPN2NFcEQIQ8SFgAlM8p+eXEnFs2QP9
         5rLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2c9VQdN0RHnrAkMcvDlTkPtl2CCpI8pZmnib4CuptTQ=;
        b=e0a8MxRKS+/iGY2mXGXBE5DvFE9IxL1Eyoqq0igoF+cxMqJnQSRNzmWr5tJijF8vHd
         oc0aFfEJg9/hgRQsUo1Q8xyY2d0q7KAzmeq2QqQQPRTZodZdZTWmrOoMi8J/M6p3VZA/
         zoGaZVf4ikvH1hMl6N1BiJaJHJWeC4SDpVyvOpyFxam8y55DYTH4SHwyiEBrcSY6QCEg
         oM1MRwF2g4qt+UPOuSJ7hY6S4UA+AB88xJ1H9fGrLldsuYCPfKXIe55ipTMUM8TbvGT4
         yLmYIOVKtDcu17+BlVQCwtiuDm1u9KXjwuabgRAPTc9YsJCAxoyc1O6ZWZA77c5PrIYv
         IidQ==
X-Gm-Message-State: AOAM5337q6yGo68ndhLyvInDIBzLfKdo3PTjWvJZcPM0Ss7Mvy4VmyoV
        27MDrt9qgw78Tf+D7Ae0nFt5Z1Z7eDqDkA==
X-Google-Smtp-Source: ABdhPJxf8/4qyluPcnhjOJy6cz8bh6+PU8dTq84aN6dB/Qm6/TP6RDCBsiWH4Hk1YEpgYTGJbUZCAg==
X-Received: by 2002:a17:902:ee93:b0:133:f9fa:f3c1 with SMTP id a19-20020a170902ee9300b00133f9faf3c1mr97998pld.82.1630335592711;
        Mon, 30 Aug 2021 07:59:52 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d22sm16688158pgi.73.2021.08.30.07.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:59:52 -0700 (PDT)
Date:   Mon, 30 Aug 2021 07:59:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     ebiederm@xmission.com (Eric W. Biederman)
Cc:     Andrey Ignatov <rdna@fb.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH net] rtnetlink: Return correct error on changing device
 netns
Message-ID: <20210830075948.73fda029@hermes.local>
In-Reply-To: <8735qwi3mt.fsf@disp2133>
References: <20210826002540.11306-1-rdna@fb.com>
 <8735qwi3mt.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 11:15:22 -0500
ebiederm@xmission.com (Eric W. Biederman) wrote:

> The analysis and the fix looks good to me.
> 
> The code calling do_setlink is inconsistent.  One caller of do_setlink
> passes a NULL to indicate not name has been specified.  Other callers
> pass a string of zero bytes to indicate no name has been specified.
> 
> I wonder if we might want to fix the callers to uniformly pass NULL,
> instead of a string of length zero.
> 
> There is a slight chance this will trigger a regression somewhere
> because we are changing the error code but this change looks easy enough
> to revert in the unlikely event this breaks existing userspace.
> 
> Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

This patch causes a new warning from Coverity:
________________________________________________________________________________________________________
*** CID 1490867:  Null pointer dereferences  (FORWARD_NULL)
/net/core/rtnetlink.c: 2701 in do_setlink()
2695     
2696     	/*
2697     	 * Interface selected by interface index but interface
2698     	 * name provided implies that a name change has been
2699     	 * requested.
2700     	 */
>>>     CID 1490867:  Null pointer dereferences  (FORWARD_NULL)
>>>     Dereferencing null pointer "ifname".  
2701     	if (ifm->ifi_index > 0 && ifname[0]) {
2702     		err = dev_change_name(dev, ifname);
2703     		if (err < 0)
2704     			goto errout;
2705     		status |= DO_SETLINK_MODIFIED;
2706     

Originally, the code was not accepting ifname == NULL and would
crash. Somewhere along the way some new callers seem to have gotten
confused.

What code is call do_setlink() with NULL as ifname, that should be fixed.

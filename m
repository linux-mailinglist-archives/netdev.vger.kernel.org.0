Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8552E3A0A4E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 04:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhFIC5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 22:57:14 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36625 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbhFIC5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 22:57:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id x10so11772907plg.3;
        Tue, 08 Jun 2021 19:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2/c6KMsKX6alZWBNUlZL1Vqah+CZUobnDVfUuNr6j0Q=;
        b=auri21nXSbQkAa3dvUFlWOI+SPSQ4IImLBtzfVw/IqXZDH/SR46D7ke3hItt9/DFHv
         Je40qmnqLMKvhRUV6Q4lCLMC9biyrw71rBjCsgpl+gU9vBvIkXoOPrO3immBN6iJdi0G
         JW+7Xkm1cLPzPbYaFAPPR5mcpfHO4hV7fsGjMw/Ile5/qi4oMPmrNnU52ydu2oMcObBu
         Pjggsq3hWSDuCOB9mqFZn1msujdotUWrtxaXndFDwM94+omZX2ZhpNeNUYZF3JDzHdIa
         CReV2iY0CQXP6+qYntXHohMS/7p+Hmzq2Q+7Mq942PG1sGaiBoss7W3hupqJ01bmMQUD
         AIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2/c6KMsKX6alZWBNUlZL1Vqah+CZUobnDVfUuNr6j0Q=;
        b=ujDchfT6+IGWQGvhIw1jPnAcKoqaQk/IwZQG4H5eACNVm58z4YscLH/50baMn4axfL
         CfT0FvbzTur1xloQ/Er7sU8VbMgvhCK5U0mVbuYCGPXFagYbkVLPvxBY9gb6cCUELAQB
         1/NM/4R746Pq2qvVcOvS9VfStVQ+Kwp7bJtztDlaIlVSeHJuC3prSZCe/HxP08P8dZyI
         qi7JeOpSxHcckz9zLHAZw01iP3A0yLrQ5EW2hmmsFnxTPRzCJnCWTBkOEjGv+WWhxUzG
         yzHwJaTjSW29XKv6UuAOiNY/zvYzfGDx6rDn2HZHagD5XeMMVNFAouIGQ0LkUOljVcc2
         bGvg==
X-Gm-Message-State: AOAM533fBZQCAtZItU1FujDPETih7ORKgkjcFV7FBLMRC2itvEqD4YCM
        uztxvMlcI7iNiWLSLYZujmI=
X-Google-Smtp-Source: ABdhPJwK7TIs+2Ga1pYR/gRHxcn4W1H2uk1DWAYqYpMpYa1YFA1dgiYVMAy1/eTQZyW/srD9+Fc0MA==
X-Received: by 2002:a17:90a:f197:: with SMTP id bv23mr28900818pjb.113.1623207255713;
        Tue, 08 Jun 2021 19:54:15 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id b14sm12527247pgl.52.2021.06.08.19.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:54:15 -0700 (PDT)
Date:   Tue, 8 Jun 2021 19:54:12 -0700
From:   Menglong Dong <menglong8.dong@gmail.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
Message-ID: <20210609025412.GA58348@www>
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
 <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
 <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
 <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com>
 <20210607125120.GA4262@www>
 <46d2a694-6a85-0f8e-4156-9bb1c4dbdb69@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46d2a694-6a85-0f8e-4156-9bb1c4dbdb69@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 06:37:38PM -0400, Jon Maloy wrote:
> 
> 
[...]
> I spent a little more time looking into this. I think the best we can do is
> to keep FB_MTU internal to msg.c, and then add an outline function to msg.c
> that can be used by bcast.c. The way it is used is never time critical.
> 
> I also see that we could need a little cleanup around this. There is a
> redundant align() function that should be removed and replaced with the
> global ALIGN() macro.
> Even tipc_buf_acquire() should use this macro instead of the explicit method
> that is used now.
> In general, I stongly dislike conditional code, and it is not necessary in
> this function. If we redefine the non-crypto BUF_TAILROOM to 0 instead of 16
> (it is not used anywhere else) we could get rid of this too.
> 
> But I leave that to you. If you only fix the FB_MTU macro I am content.
> 

Yeah, I think I can handle it, just leave it to me.

(finger heart :/)
Menglong Dong

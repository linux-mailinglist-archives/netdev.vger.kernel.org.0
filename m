Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4DE2A2AE0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 13:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgKBMmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 07:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728444AbgKBMmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 07:42:03 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F28C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 04:42:02 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b9so3994348edu.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 04:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QCjQBy+FCZ9+oENjGbS9CJuQ33vRbJf3vAJFS3zm74A=;
        b=iO+BBSLzEhlJWNu0m5Ibc9NC2X9KW4J6wU59kyez4B06yUEecymWgg2DouSkPWBno3
         jXKX3VqMXfqZbkB4QDIntY/rDAVqRlJBUxSht2HNJCXuSyiPW8da//bGexJ0xOGYwLU2
         DPM5C8spS9ufzZJQ2qOTTJi12k74EVjFq8DDqScCGMFejNPuiVZ4ekrHfw1eSkPMRE7T
         VzB64K1Or2GkhRUU+72yNR1ZfskckIkgXzzx7J0LxZ9MT/wwJew/mbibGLRAW9iaPsDp
         Yq0++8rkaUD4/N7iv1Ueha6tZoKs+e8YQSrgxg0gCBV1Rxr0gBJRW6IE91G1kka46/p3
         Sj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QCjQBy+FCZ9+oENjGbS9CJuQ33vRbJf3vAJFS3zm74A=;
        b=qb231jii3u/hP3tYVUZGpiJILTTKaBgbHPdSU/Bu/ZIq+KELAAlG1ILyA4B1QpVMwE
         uiI/5eSJVmvYJsDgwHuTFd3OigfWxDc5xYfGzvWk8LNnynpROTPd74DKpM7Q57+yO8V8
         xgluMRqpcWk4gaG6LpXa8OEI66HjqhRIockKghD1/S7G52BD1bv4gxPYjJIGIWf2OFST
         yftG+BJMm+AhpD8anP711QugWgUEohV9n/PlHa1X44Rh2h2RWsjzZyQAbkT/Unlfpfs4
         TXVlD09Tk7lz33O8gScgd4gg3x/pge8A/bApIdK4Wzk8tkmgve7v+0usa+xZi84N/QBe
         aQgA==
X-Gm-Message-State: AOAM532VRT0pNg7koXViOJ1p+KBMKIdZhSxVRyriAZWAkYw0rv9Z/54o
        n1WpiJrBFKT3if4VsfgQH9Q=
X-Google-Smtp-Source: ABdhPJzHpkJd50BAE40cBTsxPbcQZ45ZGX1vrbqev+jLDWJCmZjHXh4OGcq/I8D7XWf6+5WsjOCtYw==
X-Received: by 2002:a05:6402:1112:: with SMTP id u18mr16693899edv.349.1604320921653;
        Mon, 02 Nov 2020 04:42:01 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m5sm9481844ejn.110.2020.11.02.04.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 04:42:00 -0800 (PST)
Date:   Mon, 2 Nov 2020 14:41:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
Message-ID: <20201102124159.hw6iry2wg4ibcggc@skbuf>
References: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
 <20201102000652.5i5o7ig56lymcjsv@skbuf>
 <b8d6e0ec-7ccb-3d11-db0a-8f60676a6f8d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8d6e0ec-7ccb-3d11-db0a-8f60676a6f8d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 09:01:00AM +0100, Heiner Kallweit wrote:
> As mentioned by Eric it doesn't make sense to make the minimal hard irq
> handlers used with NAPI a thread. This more contributes to the problem
> than to the solution. The change here reflects this.

When you say that "it doesn't make sense", is there something that is
actually measurably worse when the hardirq handler gets force-threaded?
Rephrased, is it something that doesn't make sense in principle, or in
practice?

My understanding is that this is not where the bulk of the NAPI poll
processing is done anyway, so it should not have a severe negative
impact on performance in any case.

On the other hand, moving as much code as possible outside interrupt
context (be it hardirq or softirq) is beneficial to some use cases,
because the scheduler is not in control of that code's runtime unless it
is in a thread.

> The actual discussion would be how to make the NAPI processing a
> thread (instead softirq).

I don't get it, so you prefer the hardirq handler to consume CPU time
which is not accounted for by the scheduler, but for the NAPI poll, you
do want the scheduler to account for it? So why one but not the other?

> For using napi_schedule_irqoff we most likely need something like
> if (pci_dev_msi_enabled(pdev))
> 	napi_schedule_irqoff(napi);
> else
> 	napi_schedule(napi);
> and I doubt that's worth it.

Yes, probably not, hence my question.

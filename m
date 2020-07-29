Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D12231C97
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgG2KTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2KS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:18:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89832C061794;
        Wed, 29 Jul 2020 03:18:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e22so1824848pjt.3;
        Wed, 29 Jul 2020 03:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b4/21bXCudODfIY795t0rfeU7nBNchzrSSbcv04ppHA=;
        b=mrzqBECNYxJ7HgA62RBVbpwWRQUzqC6n9dMdDRaJkvrW9MtnP7bQ12a5YTj5Dpb47B
         oWVhfQ19xVeA/NijTmRyy6OrqFd7tWyEuxuwQ4rYUo8B3TuX6Ib93+/cBeSZTtB2m2b+
         mTzEQ4WH61JPeYzNB52dhyOlk1Bf/QSz+jAEUTFIsYWNHcES+pmJVcgJa5xNVF23XwL+
         jHW6A5MwIenK6b9+aBjz78pMePBdJkUlO1ReBAJE3OFfHjp0c8sDvPeGvND2on/f67Up
         lxey/ZcEFLtvoH8LPgQRYb3QorLMiFZo2b9ahI7Xav6Ofg0nKnCkxyr2AUZ2aGXRxEvK
         Gy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b4/21bXCudODfIY795t0rfeU7nBNchzrSSbcv04ppHA=;
        b=DLCdS/jv62h3/dBCUYwivMaIX5U5x8l9ZCjB7X20Tn14+iRkL8MMTmcuHePZhpfTXf
         a9Ua2WV14gAoziQThhLZDSoT4CJiQpyL2uwBKVR7E5wRcK6SVVK0k+aFRdQjd5PTt9iw
         SZS686kbRz5vOaKnB3+EXvpjCOyu4+3RCjv4pO/GWLj8tIHpLdLdSVNsJPsjmoSAlZLC
         fltrYer8XmqN/kLtp+o6/d7YAW8Ujg8seozyLsvP5zeFKdB48afFbHXvvua47Bcxjk94
         ithZo0SmQwLOe99jkWqfifnGhf0pG9DTGkHQdbLTDQFMEAYlXfWzCFYB9JCb24FWK6gR
         PAKA==
X-Gm-Message-State: AOAM530XpB2kOEEiD+Qxtb72WLfJvkoh2Agp1G0Wu2TinSyD5rhYJP1a
        KKRy5H4ZuO+GgfUSItXObyQ=
X-Google-Smtp-Source: ABdhPJw33dMoDVdSQ9nMnOoTWSXV4jmIgUS6olXEqFCUVr9ezYF9SmQWFQ/Qz0pl0lXb+VUZD0FMjQ==
X-Received: by 2002:a17:90b:4c51:: with SMTP id np17mr8719522pjb.91.1596017937931;
        Wed, 29 Jul 2020 03:18:57 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id e124sm1713290pfe.176.2020.07.29.03.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 03:18:57 -0700 (PDT)
Date:   Wed, 29 Jul 2020 15:47:30 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] farsync: use generic power management
Message-ID: <20200729101730.GA215923@gmail.com>
References: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
 <20200728200413.GA1857901@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200728200413.GA1857901@bjorn-Precision-5520>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 03:04:13PM -0500, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2020 at 09:58:10AM +0530, Vaibhav Gupta wrote:
> > The .suspend() and .resume() callbacks are not defined for this driver.
> > Still, their power management structure follows the legacy framework. To
> > bring it under the generic framework, simply remove the binding of
> > callbacks from "struct pci_driver".
> 
> FWIW, this commit log is slightly misleading because .suspend and
> .resume are NULL by default, so this patch actually is a complete
> no-op as far as code generation is concerned.
> 
> This change is worthwhile because it simplifies the code a little, but
> it doesn't convert the driver from legacy to generic power management.
> This driver doesn't supply a .pm structure, so it doesn't seem to do
> *any* power management.
> 
Agreed. Actually, as their presence only causes PCI core to call
pci_legacy_suspend/resume() for them, I thought that after removing the binding
from "struct pci_driver", this driver qualifies to be grouped under genric
framework, so used "use generic power management" for the heading.

I should have written "remove legacy bindning".

But David has applied the patch, should I send a v2 or fix to update message?

Thanks
Vaibhav Gupta
> > Change code indentation from space to tab in "struct pci_driver".
> > 

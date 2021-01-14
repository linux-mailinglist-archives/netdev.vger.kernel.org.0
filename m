Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D02F5C7E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbhANIee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbhANIed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:34:33 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DAAC061786
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:33:53 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 3so3894586wmg.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GjeLGr4dGUje6MMvo6pIfAne61VxoEvoHdwrClfl8/s=;
        b=ZIGADg3BlaqD32ynUhvAKUHK36WggmBH+HgCus+Lt0OiuAae5RFKTAAdAUBLBkfKrY
         g9mCLwos3GLeOzEZCwhYZwr8T5fiAWm2JBAxzVNiTStafjzlYckMK2ml72RUD1geMllQ
         TC4hDVHt/O8I3ZmVeHGXt1O5WQbtt/JbiFBmQso//vGSagy4KDFQiNpFLKIWEZL1gEtU
         rgvHU8MtqxV21EHUgiCzhfSYfGoPkgsH0esb0o3x3F9ayqx2pdlhR+Ode/A4/hYpSf0j
         AnO7uTlxvNucWcVxTJhpnRX7DXNGWSrX8lPRCWwv6I8P7aSS+LVkhBxZp6+rLxq35MjL
         qO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GjeLGr4dGUje6MMvo6pIfAne61VxoEvoHdwrClfl8/s=;
        b=HIFdAVcnn9wzOxRsXz6X5rcfSlPbnonK5UiRo6XmXToN3ilfIiuuxs+far59Poc8uK
         QoPYVXTVM2BH2jxrerNfTFw9tGopIfRkYpubeEKIxgbXieDZkslwXFOazMn4bZNNIYr6
         QcjNKzqgJ62pH3gsiUyVk4HKjEpyMpBV7jkOQP5nbmdwZUb92mdW3Geye4WhlX0/iI3E
         7dKS9juKQ6+wpYxGZ4V/9iDsJ6ZloQ/8JuZQ/7LumF9Vw5U0WNFMlhzjDleEJTcfvv8O
         +wJcptKaey23B2XiG/CBItoQLFMy01PQHr9xjHCNNHPU8bKh2dMozv/VelXb3bM1lPNF
         +19w==
X-Gm-Message-State: AOAM532YlKA4ZrEzmIVkK1DpfSCfd5uiXoi8dlCacmInBs/e5ikZT6eo
        ZoQ+8HOzCtYl//nG7h/6YktF/A==
X-Google-Smtp-Source: ABdhPJw3p4X/u/75/T9prjNVjPSDyTRHFC+ksLZ/wQbHtHizclaVB59YVOGqKuRlDUU9mMmbgYlTNw==
X-Received: by 2002:a1c:2d6:: with SMTP id 205mr2866556wmc.60.1610613232251;
        Thu, 14 Jan 2021 00:33:52 -0800 (PST)
Received: from dell ([91.110.221.178])
        by smtp.gmail.com with ESMTPSA id b14sm8094410wrx.77.2021.01.14.00.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 00:33:51 -0800 (PST)
Date:   Thu, 14 Jan 2021 08:33:49 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Dany Madden <drt@linux.ibm.com>,
        Daris A Nevil <dnevil@snmc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Erik Stahlman <erik@vt.edu>,
        Geoff Levand <geoff@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Allen <jallen@linux.vnet.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Lijun Pan <ljp@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Paul Durrant <paul@xen.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Cammaert <pc@denkart.be>,
        Russell King <rmk@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Santiago Leon <santi_leon@yahoo.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Wei Liu <wei.liu@kernel.org>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 0/7] Rid W=1 warnings in Ethernet
Message-ID: <20210114083349.GI3975472@dell>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
 <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021, Jakub Kicinski wrote:

> On Wed, 13 Jan 2021 16:41:16 +0000 Lee Jones wrote:
> > Resending the stragglers again.                                                                                  
> > 
> > This set is part of a larger effort attempting to clean-up W=1                                                   
> > kernel builds, which are currently overwhelmingly riddled with                                                   
> > niggly little warnings.                                                                                          
> >                                                                                                                  
> > v2:                                                                                                              
> >  - Squashed IBM patches                                                                                      
> >  - Fixed real issue in SMSC
> >  - Added Andrew's Reviewed-by tags on remainder
> 
> Does not apply, please rebase on net-next/master.

These are based on Tuesday's next/master.

I just rebased them now with no issue.

What conflict are you seeing?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D2F352075
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 22:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhDAUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 16:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhDAUNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 16:13:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB93BC0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 13:13:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id jy13so4678731ejc.2
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 13:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=12Y0UbLRnZ9vKxA6xytyBkUNmjYECoppNG78TbmCV7o=;
        b=PQrA0lxx0ZBOADTOpZAVNOUOdV+th6OasSxnnLAT7j4jZnF++enxbTt1x5STwMFADM
         qsLdgrOIM+R6VS4f7/cyo2eBBmkIsMbZajlfMH5hIdT2G7oY5FmFIEZyQGNPgGeilCTq
         zmiePqJUattM9m+MWuJ25ZtCY+F13Wec4i9duCUhNBm+lxpiprhvGpDfXNKIbJkkT7+0
         ujFDlBvnGBRph/Wgh+S4Qzp6982V+66TIjA/W69mQzrksdi5TbSWGz3fXdr6gQmX5RoB
         t+YRasISWI+paPh9aWRNsddNlEW5nCaO/e21qvq1h5SCjWw2TV2PWNF0RIx5T4x04MN2
         wxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=12Y0UbLRnZ9vKxA6xytyBkUNmjYECoppNG78TbmCV7o=;
        b=NhyKHx+BnFdrQelFHiFmmhwUtb5PLBenqQBA6rTPD9n/ejfzrG4SjK7sNp2vtIRxbr
         Lje824/CFFpQ1XEdwTWjnUXLJtjYyqexfn4zE98/KY6oTTrPrIbQl7/M1RlX5ZckqcbK
         cUgRFEoJVVc1kuw3eXkwpy4RgqiZD0rtuPHxKPsrNfR1T8/mbq6JuFaDJqNE0/cXBhHv
         1sTijf5BuH44GCjOBsWrGhdzlzjyCWQhZ3LfKeVHfcu39Xp+wyE+ETyho+ghD/TT6RBP
         DWbuI3i0okB/oHNT5QFNfWY3swzM+juVcbGR2plyDXA6fNPNH2OMn2kCc3DhCuCjgWWw
         CjkA==
X-Gm-Message-State: AOAM530E6XTiTJpB1RI72r8EOI/DgM2UN4EJdMRBIJfjqD59DfOYPoOv
        vc6y6pouyMgWkZizjqHOw64=
X-Google-Smtp-Source: ABdhPJzM6OmgxufCMgtKMxZEn2IIeKtCeuZ5hJAtTk6JQAFSiAgVchqVKef7KznlIvAzgupHycmiIg==
X-Received: by 2002:a17:906:39cf:: with SMTP id i15mr10968718eje.534.1617308032516;
        Thu, 01 Apr 2021 13:13:52 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l10sm4198348edr.87.2021.04.01.13.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 13:13:52 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 1 Apr 2021 23:13:50 +0300
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 2/3] dpaa2-eth: add rx copybreak support
Message-ID: <20210401201350.vxyivlvvur6iqdp4@skbuf>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
 <20210401163956.766628-3-ciorneiioana@gmail.com>
 <YGYVx+OxaSey3qNJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGYVx+OxaSey3qNJ@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 08:49:43PM +0200, Andrew Lunn wrote:
> Hi Ioana
> 
> > +#define DPAA2_ETH_DEFAULT_COPYBREAK	512
> 
> This is quite big. A quick grep suggest other driver use 256.
> 
> Do you have some performance figures for this? 
> 

Hi Andrew,

Yes, I did some tests which made me end up with this default value.

A bit about the setup - a LS2088A SoC, 8 x Cortex A72 @ 1.8GHz, IPfwd
zero loss test @ 20Gbit/s throughput.  I tested multiple frame sizes to
get an idea where is the break even point.

Here are 2 sets of results, (1) is the baseline and (2) is just
allocating a new skb for all frames sizes received (as if the copybreak
was even to the MTU). All numbers are in Mpps.

         64   128    256   512  640   768   896

(1)     3.23  3.23  3.24  3.21  3.1  2.76  2.71
(2)     3.95  3.88  3.79  3.62  3.3  3.02  2.65

It seems that even for 512 bytes frame sizes it's comfortably better when
allocating a new skb. After that, we see diminishing rewards or even worse.

Ioana


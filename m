Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A2F4AA08D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbiBDT5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiBDT5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:57:18 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE44C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 11:57:18 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso7060395pjt.3
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 11:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wDGw0/EwtJYTglZEqfDGb3FIN462zRDf9urboGC2t7A=;
        b=Bk9rhpq3K39sqcfpUMoJLxjONLVP7mBOncRpnvnFvdoquHHy0SI+S3PVTkNmzC6qC1
         Hn7axQi/nFdTpBvbEZ4XzLfGaP4rMAFWAq3v7KyXaOgmugpS9APiMuYLkOHYw2hXcPNd
         2/GEwlEADthc4am1sM/aGZ8vqH3dCMT8zVEvrmS9yPDQ+SKt7UQV5Yo+yIPBIRr3tuN9
         1BnbqqlWOnlIdC164bX0QW/M8+Tyd60RVHJg+nj4209UulaFHx1bg9TrYNJ2BDVDcnjX
         5uOr0A77F0GSamgDRXNohGvyGSGpYAuQ/ZjUW43X6doZKK6WtU+ACHhHBLQ9kcahdGxk
         W6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wDGw0/EwtJYTglZEqfDGb3FIN462zRDf9urboGC2t7A=;
        b=EOCEqKoYswrWAHL7RsACj+cIjKduH8xpSVjyjcurHuU2PAlS34ZY+UD+gR3eiP6ZM1
         v4eJUy13bePL/HQfDMDpzkIJd5Tjw1oENxQ3BZqih7sw0UllX7v+oZa6Awwtbwb5CpfW
         tEmfqhsZJGissTzO7zjBcsH3ih/kDf3/fCop1XDCURM0+gBiNNkjTTRda5ohoDrSL7SO
         1wYmCc01vnPI6zdVbRM8lbc4mDQIWfD0xFyJjmQoNFSYwpcNps1tcqWhJ4AAUtMp88IM
         yzIMmB32NyonEtKI3Fjos6NvyVp5iOZtB6/npnrzPV2meNsyocEA44QQopc+XTxH8Vdk
         7d9g==
X-Gm-Message-State: AOAM532+7jrA+7q5ux4d6H/Obg2YqByJn1PFyFiHdhWr416Le5UhgSLd
        GtdGqG54Dy2p1ScjWOyg1AMAAA==
X-Google-Smtp-Source: ABdhPJzfIwASGH9Q9YDrGpj7+nQBCQ9/oA7DJD4A2a/w8DbSTpauL5FCdoCfS7WdNzcYae8fuOcNsw==
X-Received: by 2002:a17:903:1249:: with SMTP id u9mr4926897plh.171.1644004637715;
        Fri, 04 Feb 2022 11:57:17 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id bx19sm1098827pjb.53.2022.02.04.11.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:57:17 -0800 (PST)
Date:   Fri, 4 Feb 2022 11:57:14 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: minor __dev_alloc_name() optimization
Message-ID: <20220204115714.3b98451c@hermes.local>
In-Reply-To: <20220203064609.3242863-1-eric.dumazet@gmail.com>
References: <20220203064609.3242863-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Feb 2022 22:46:09 -0800
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> __dev_alloc_name() allocates a private zeroed page,
> then sets bits in it while iterating through net devices.
> 
> It can use __set_bit() to avoid unecessary locked operations.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

That looks correct.


Acked-by: Stephen Hemminger <stephen@networkplumber.org>


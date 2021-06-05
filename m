Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966C939C98A
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhFEPkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 11:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEPkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 11:40:05 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA79C061766;
        Sat,  5 Jun 2021 08:38:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso6554425pjx.1;
        Sat, 05 Jun 2021 08:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s5riUd8tlyzlhqjCSWpehZNMUxTC9jRdlBf/Axj2umA=;
        b=BwdeCPHR8sk9ExJWW+Xk3JsQZ/Hru3k03XOP0f6zXgu+uuhD2uKWXLuJVf/GuH+PuR
         CZDcrje1huGeqNKeAspNMzSgvMhuUn0AKM/E5s0GEOLfHBECW3f8gA9nTm8Jkv2NYLKc
         LI0HrA9pS9sWQRtCVPK2K4SNiUjFtRdVG9jQVpslKpKTJiTDLTAQbgaElA8Zr83wwzZ9
         PIt2MYXzZpl6TdL+t3TqWWZf7CW8eDX2XMqlZb7Zp6/qCGPn/bKByFStpHTLQdV7de0+
         e3eaFPLGbPMl3Z9jQ7BMpeZK3Xp33hjszpsMwN+2uOk+C330y+Re8xCnHkNVa2O2UQok
         2NOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s5riUd8tlyzlhqjCSWpehZNMUxTC9jRdlBf/Axj2umA=;
        b=WaDujT9OZUTcSOyEBggDm8pYN/6ZYCZm5uoRR65kdWtsZWIG8b/B+56tS3I2cfGWJG
         /DflBSOfn7SNDN+bvr/zfWN5FmR/VxCvqOPxT3PFCyndwIBlWSJd5BJSABT/Z8DRzQUf
         mjNH5FifUi+0kBiCt1xoziDFWm9g9l8aNoIwYysG18JH70MC+B+etpMIBXw0IvyMcy4y
         L3OquCXCy5Jr9Z7TQS/RFAv5IFZjMafWBPrmk47Sqv1MjPLG6h6X+ORwDuyKzee3X/6Z
         hg1p/Rxi47hArlepyhsh6QgvlIKTUKbEKuUe32LI3vJxJmath4DEsBI8RdOaVYj2fcE/
         Z+xQ==
X-Gm-Message-State: AOAM531p0Fo6NlXY7nwmKxF3xKsVKUajDtpgXkvWNzxVcZJZYWVvOuza
        jxAmJX1pL/iU1QPoN/LRKLlUlZA+IqM=
X-Google-Smtp-Source: ABdhPJx4oCMbvuyUdygJ5jr+OrmeRCUPdIeC2NU/D8kXnHwNHNX+LMkfyUE3AOktMOHB8rw75U1UZQ==
X-Received: by 2002:a17:90a:ea95:: with SMTP id h21mr4323143pjz.90.1622907490943;
        Sat, 05 Jun 2021 08:38:10 -0700 (PDT)
Received: from localhost ([2601:645:c000:35:7a92:9cff:fe28:9fde])
        by smtp.gmail.com with ESMTPSA id gq5sm7405369pjb.17.2021.06.05.08.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 08:38:09 -0700 (PDT)
Date:   Sat, 5 Jun 2021 08:51:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
Message-ID: <20210605155143.GA10328@localhost>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603131452.GA6216@hoboy.vegasvil.org>
 <4b2247bc-605e-3aca-3bcb-c06477cd2f2e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b2247bc-605e-3aca-3bcb-c06477cd2f2e@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 05:54:45PM +0800, huangguangbin (A) wrote:
> > This won't work.  After all, the ISR thread might already be running.
> > Use a proper spinlock instead.
> > 
> Thanks for review. Using spinlock in irq_handler looks heavy, what about
> adding a new flag HCLGE_STATE_PTP_CLEANING_TX_HWTS for hclge_ptp_clean_tx_hwts()?
> Function hclge_ptp_clean_tx_hwts() test and set this flag at the beginning
> and clean it in the end. Do you think it is Ok?

No, I don't.  Use a proper lock.  Don't make vague arguments about how
it "looks heavy".

Thanks,
Richard

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664E53B8AF1
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 01:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbhF3X2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 19:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbhF3X2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 19:28:03 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A6C061756;
        Wed, 30 Jun 2021 16:25:33 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a127so4101702pfa.10;
        Wed, 30 Jun 2021 16:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yDF6eIHYx4lHuUbnt6LeNa9ic07VE8wVLsInf5Lm3v4=;
        b=mzdMGpAm6raA+Ilfd/q3Lm9o4IC5cFgtB+eiGiZq/Qie4h4inL+mPTOn4BIMTU3Rj7
         4cuPR9g0Nvf7LC0DNKI6/wUiDmRB7ez9yP8HRd3ddDY+GkTVgmE+CtNcp785qr1Ah+lN
         165ZpJpUOn8TxGpsgW+OWuEz623u9Bf5ITB53YXhKylhayDgZR+oU5y8ZSND87uxmnjc
         9pg0JfP6zUZ1flPC0YKRRKOMzUyAgA6FtuTm3AIj4EqK9/yu34xIsdVnFWKlDkGOMtEP
         HcUmpIPJQSWY6l7Sob5AcpBpzUE4js3N0ZQfXTC7wdtyteMv4lxoFD92kLoL67v6DSIp
         2ucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yDF6eIHYx4lHuUbnt6LeNa9ic07VE8wVLsInf5Lm3v4=;
        b=E566VjI0pGjD/B3Nhub0DluTIg6g35/eDSKTgOPgBODt99QxOCPAT2NY2h53YvxKlE
         JcsSHFFr8RWt5o1WfPbM/HGyZKtuc/86ekaQh7OLKWTQW6OK2sJzMdCgVhwa8aST4aBR
         X5gEB+ue1EWE5Zch0xglVfRIZqhmMVab4Pac6D9BP2aGIw5kE0yJY5GbX+dZC16hlSgy
         ix6IwcXOOnNgu4+wuruu9UC5bU3A56R16dACd7EmOPybZkuBA96f908tacQW+puitGzt
         3tN4ekTsdzyDgEtGKZQDCnEPTkBI7CdxrgvNQYHa/lqJ4JtG2gg7kRxsu5FpFElDPWLT
         P1Bw==
X-Gm-Message-State: AOAM532WbjTeGuszNKI6eCxKgIsOrFrkSsYE9xqYIGjWJKZLOLMf4Zw8
        SRldf0Qf39qbWFr1CHKLfpQ=
X-Google-Smtp-Source: ABdhPJwpbvjG6ISQ62Gx1WauLZDhTJ+HP2fPc575a/6kC6mOk201hah2ghg4/MGOXEX8ubIcZga8ag==
X-Received: by 2002:a63:e114:: with SMTP id z20mr36045534pgh.207.1625095533023;
        Wed, 30 Jun 2021 16:25:33 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id y3sm24461324pga.72.2021.06.30.16.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 16:25:32 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 1 Jul 2021 07:19:49 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 16/19] staging: qlge: remove deadcode in qlge_build_rx_skb
Message-ID: <20210630231949.gpmk433lrztp6iau@Rk>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-17-coiby.xu@gmail.com>
 <20210622072939.GL1861@kadam>
 <20210624112500.rhtqp7j3odq6b6bq@Rk>
 <20210624124926.GI1983@kadam>
 <20210627105349.pflw2r2b4qus64kf@Rk>
 <20210628064645.GK2040@kadam>
 <20210629133541.2n3rr7vzglcoy56x@Rk>
 <20210629142201.GQ2040@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210629142201.GQ2040@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 05:22:02PM +0300, Dan Carpenter wrote:
>*sigh*
>
>You're right.  Sorry.
>
>I misread IB_MAC_IOCB_RSP_HV as IB_MAC_IOCB_RSP_HS.  In my defense, it's
>a five word name and only one letter is different.  It's like trying to
>find Waldo.

That's fine. Thanks for reviewing the patch and prompting me to write a 
more comprehensible commit message!

>
>regards,
>dan carpenter
>

-- 
Best regards,
Coiby

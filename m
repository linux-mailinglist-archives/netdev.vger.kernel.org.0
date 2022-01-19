Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E25493AD3
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 14:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354651AbiASNEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 08:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354633AbiASNEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 08:04:52 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986EEC06161C
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 05:04:52 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id h2so2549444qkp.10
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 05:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PdBsLwTPPCRnlF0tAGck2uC9WYpIzKTvIZtFGv5axas=;
        b=id2q0sYnHRhFNE9VD9xueoZt/qcezsUBeZvxMkZqSpN6A21B1azzpRyW7wgh4WjfiK
         hWCfpAzLanOMfrKhduRcgE1Qru2f3jbOzbPV/YlF2ynDNO6GG5FrxtAmDqKFcvTLacg0
         quqzUTMC/M7z2d3BrugWX/AAfPxHRmLksobHfRXyR3ZLBAeT9dqRjkECzPIzC3RpoAU7
         HVM291if145vJdGYmP0D9AU4bBbiPb8ybnEpn9Li+DTcwBFOpCA0kkuMVAIJE/UQ3thI
         87k6B1OkcXdfhY9iKZuBKJJfUeMxb5TRggbPHSjbsPstzr1wQHtWaF3SY408Zneh01zb
         ZPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PdBsLwTPPCRnlF0tAGck2uC9WYpIzKTvIZtFGv5axas=;
        b=ontzGfD+HmiFUVqj+xWn41mqFZmuQEtaFFBndaH1kKAToxS+Szyc6QtWF+p9k7d74p
         YQGp8B/9Jm7gB4y0dJKRRfXE+ZL+2WaNRbWCsntNL58hmG8J57l1CteBSl++g2A+iTZI
         0p194iktGeA9yFhhDl1CbrEjHW6wnwQo0+gmyakrUw8KLac+rIXxrtnyP6/6jrybD38x
         ZfTyQmzfB9SSbz4cf+5aI6Jd0qgL0Ys1QNMJnBFFwzpIDyGFF89hn4ahoBmkmtPCFU3r
         VJpONVEeam5cfncDPOmEJZWalw6myQ5uutSDcAI44ei02Yg9i5BimUy1uLeR+DImV6cB
         kOaA==
X-Gm-Message-State: AOAM5336dQqbD+7SWOf1DE1dE+G5pxeymOJxTuG+BFDTUM5AV3NpiDuo
        I3JjZnbep5ezKL1tfUvs9DGxPw==
X-Google-Smtp-Source: ABdhPJwP2OqdieY5HOVRhMknqsPZXcnogOqeLFHeDfvJHpNa6Geya14CaF6r2cZylDrXsIK3Raih2g==
X-Received: by 2002:a05:620a:12f6:: with SMTP id f22mr21806061qkl.652.1642597491724;
        Wed, 19 Jan 2022 05:04:51 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id de3sm2993864qkb.79.2022.01.19.05.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 05:04:51 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nAAdu-001IJC-DT; Wed, 19 Jan 2022 09:04:50 -0400
Date:   Wed, 19 Jan 2022 09:04:50 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Praveen Kannoju <praveen.kannoju@oracle.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Message-ID: <20220119130450.GJ8034@ziepe.ca>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com>
 <Yee2tMJBd4kC8axv@unreal>
 <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 11:46:16AM +0000, Praveen Kannoju wrote:
 
> 6. Jason, the only function "rds_ib_free_mr" which accesses the
> introduced bool variable "flush_ongoing" to spawn a flush worker
> does not crucially impact the availability of MR's, because the
> flush happens from allocation path as well when necessary.  Hence
> the Load-store ordering is not essentially needed here, because of
> which we chose smp_rmb() and smp_wmb() over smp_load_acquire() and
> smp_store_release().

That seems like a confusing statement, you added barriers which do the
same things as acquire/release then say you didn't need acquire
release?

I think this is using barriers wrong.

Jason

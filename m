Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E351DFC43
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 03:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbgEXBm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 21:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgEXBmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 21:42:25 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945A4C061A0E;
        Sat, 23 May 2020 18:42:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id q8so7053137pfu.5;
        Sat, 23 May 2020 18:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WOxnSmEbJ8sld8voIH7dFeotuFTK+vKmyxU3MIIUb6w=;
        b=GtZPJ7jMgTd975u9HvJI8Vb4cQ0PF/kILo5F96YhAHphc7CWosNo5glezVlXxhXmfe
         2gU8cK7Y8pxzBSBxL2vGV0mECSCAAp8pkJw0+o85UREcMBs5pU34VmV2PquiuIlMBZVS
         I6mX64GzgFs+eJMW1wOvV1EV776L2G42DYYbsYCNlRri+pFm1GFU598QW95NFZbyWUIv
         mkxS+NW/iDwbC1BzK0EnISSbg2E5G/UhDnndhRbKFe1rh3EbsWJYpuQ85dqvt96abTs7
         h0rIdsreV3awAzUw83FAk+0u4QFJaMqks/RfYUAH6W3qqEF3vq6g7HD6yqmDacd3ngUG
         boqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WOxnSmEbJ8sld8voIH7dFeotuFTK+vKmyxU3MIIUb6w=;
        b=MrNZTLBwjzgF1XEaKZQeXlnLDwIhtmEM8VlqrszzVuyt2yjqIUKgPZjoBksSD4v3U7
         U4tzNKsTsGmOir0aueA/S4OvQ5mVb9qk/GiIbOD81RNENxHU6o+SpnshxkZ73ULoq4uj
         OYXHYOWxCMBTw7ZpGBlMSRiiQEBzWhiVdIwqEzz0HG1CCLj4UkLcrMhx2H0x3MjhxHz4
         aLFtkWqvEyRZ6wayU3QPBZW6avURIi0MDi+GDLQ8EOskffA0ccaAk/UlyH8wsWsAnsAj
         BV2TdSCh3JM9ln8Jk7O/t6XKPCgCtkLBkXewkv1vbI6a+nt2j5HX908G1UPDa2qTbHpb
         q4/A==
X-Gm-Message-State: AOAM531nl3FHRZu3mTsZ1c06VI8r305Iw4eEd9vj+/VoO2zc2ATZoGxn
        Ieh3m1xAuw7/sjvTGknFI+o=
X-Google-Smtp-Source: ABdhPJz/r2ARO1+zFfzMU6tmLJif4eacW94VQyHfz5ZBMq8FJBOIwE90YKcA4DCDXFxeOk1t1yVKbQ==
X-Received: by 2002:a62:c5c2:: with SMTP id j185mr3837671pfg.74.1590284544972;
        Sat, 23 May 2020 18:42:24 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y18sm9957798pfr.100.2020.05.23.18.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 18:42:24 -0700 (PDT)
Date:   Sat, 23 May 2020 18:42:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        steven.price@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, Wei.Chen@arm.com, nd@arm.com
Subject: Re: [RFC PATCH v12 09/11] ptp: extend input argument for
 getcrosstimestamp API
Message-ID: <20200524014220.GA335@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-10-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522083724.38182-10-jianyong.wu@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:37:22PM +0800, Jianyong Wu wrote:
> sometimes we may need tell getcrosstimestamp call back how to perform
> itself. Extending input arguments for getcrosstimestamp API to offer more
> exquisite control for the operation.

This text does not offer any justification for the change in API.
 
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index c602670bbffb..ba765647e54b 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -133,7 +133,8 @@ struct ptp_clock_info {
>  	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
>  			  struct ptp_system_timestamp *sts);
>  	int (*getcrosststamp)(struct ptp_clock_info *ptp,
> -			      struct system_device_crosststamp *cts);
> +			      struct system_device_crosststamp *cts,
> +			      long *flag);

Well, you ignored the kernel doc completely.  But in any case, I must
NAK this completely opaque and mysterious change.  You want to add a
random pointer to some flag?  I don't think so.

Thanks,
Richard



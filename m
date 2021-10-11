Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F422428D70
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhJKNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhJKNAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:00:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A80AC06161C;
        Mon, 11 Oct 2021 05:58:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g9so843608plo.12;
        Mon, 11 Oct 2021 05:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P+zqPiJMkL+KtxpVHxtGBbtNs2viWb6t1vt2KNlKUzo=;
        b=P8oLtMb/N7W8f/tv6HJjOq8idqEPpiA8VyFUaV2JuuOA/Gp3VORsnF3zbvPSQo6BnJ
         C8KxQ2Vgc2Dq2Qqs5T0wDl0cVahgwFbpch9lYS6N4SVtokHV+K8wzby+lNKUVJb1ukD2
         6ePTc0bSyI6KSBq0zKFIRsONR1d7fmRerDUAy6fwUIVFVl8ihpl7gQrLKDX8gSrWWkv8
         H4rZvCIfy3tU59YpAHKQ/Xeoz17y/68r8cCNua24thGI61GMBGpRUvRyc9Y3/N21leXz
         Bvl8Uu8APtMrwN/ti9erl/DXINwWIbeaQQpy8zOCP6nsyZ+VirPC+qeiF4BdEFo1tLl+
         hOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P+zqPiJMkL+KtxpVHxtGBbtNs2viWb6t1vt2KNlKUzo=;
        b=nt7ThDQCA+9rcolOyjmbXaUT0t2MM0Wp4O484d+HXa7Q3kcRLp+uN8pelURY4DU4yJ
         vrWzVPkBoS8maSTv3UT/jZ9VwUWIIIhRjByxhVZwNY6QFaoqqArcNteuD7mhkeIXBJBf
         xBQD9o4vE9Ba2rWus7z3faWI1oXyHRKDYc3h6aBROm3GxwGGMZO23jl29uTDuVTQ4zvK
         7qeuUhKP2LlfHrs9cW9F/pm/1cKwiYT5CtrbfxSn8tkfDyofSMnfE6r9JG13ynBm5jd1
         hR3SzMv+C6VijTxLEfkCvDW9szQ0n/iAXxhgiRHyIasti06u+hlfgjEVaf7KyNCdjL2+
         N3Og==
X-Gm-Message-State: AOAM533Sw+z32IeNbSCH1NVvJteq/N0hyt1Li21auiVIB2/PNqF4g7aQ
        QURd+NtOvKBCOW2Ld+MxWzrspd/5BVw=
X-Google-Smtp-Source: ABdhPJxMWBWaVMRRrE0DezJ4q8n7l34auwp1RjzTsLyan56u+vc0rRt8uOKrA06aYEkfYbcLlt9aaA==
X-Received: by 2002:a17:90a:bb13:: with SMTP id u19mr30795125pjr.42.1633957098059;
        Mon, 11 Oct 2021 05:58:18 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a28sm7951838pfg.33.2021.10.11.05.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 05:58:17 -0700 (PDT)
Date:   Mon, 11 Oct 2021 05:58:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211011125815.GC14317@hoboy.vegasvil.org>
References: <20210927145916.GA9549@hoboy.vegasvil.org>
 <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
 <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
 <20211007201927.GA9326@hoboy.vegasvil.org>
 <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 09:13:58AM +0200, Sebastien Laveze wrote:
> Of course, so what tests and measurements can we bring on the table to
> convince you that it doesn't lead to chaos ?

So, to restate what I've said before, you cannot adjust both the
physical clock and the virtual clock at the same time.

Here is a simple example that has no solution, AFAICT.

- Imagine one physical and one virtual clock based on it.

- A user space program using the virtual clock synchronizes to within
  100 nanoseconds of its upstream PTP Domain.  So far, so good.

- Now a second program using the physical clock starts up, and
  proceeds to measure, then correct the gross phase offset to its
  upstream PTP Domain.

- The driver must now add, as your proposal entails, the reverse
  correction into the virtual clock's timecounter/cyclecounter.

- However, this particular physical clock uses a RMW pattern to
  program the offset correction.

- Boom.  Now the duration of the RMW becomes an offset error in the
  virtual clock.  The magnitude may be microseconds or even
  milliseconds for devices behind slow MDIO buses, for example.

End of story.

Thanks,
Richard



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6882B0C65
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgKLSOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgKLSOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:14:31 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7938C0613D1;
        Thu, 12 Nov 2020 10:14:31 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id r186so4894013pgr.0;
        Thu, 12 Nov 2020 10:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JIk3ZmFkO5nDtBNY58QwFlU29QBzJt4HRYRhDxHGvtw=;
        b=lrLJnI44J9dH+9u441DWX8ZVVOmayYq3b645EPjtdZSPHXbVgQDdp0BrOPIdjwhtfl
         PVorMrdP7ho1Dbx3vVxbxaZicCs1bb4j6ghd9RWOC/TtDh+L2qe6WkRCaPl+ToR/49kP
         dLlytg+RYyohGBgn5PAksDepRA6QXzDsrtIpi51BV0xnj8skVwQGhqLovrOiaDv8xaOn
         QnEQke22Jz3UaTgJOZ0BmhY13OzcHHLwaVpjDXwdk7YWlDdcH5wbSQB/eY8NJxOXyOKb
         IFLRz70jw7O6BFH0xPAMkZR5FLARpFwhRhAPNCzE8wF1xHxIFoWfCQSx9zmqJBrJa3lE
         064Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JIk3ZmFkO5nDtBNY58QwFlU29QBzJt4HRYRhDxHGvtw=;
        b=RjuOlL/JXj4UdvtSqLba9m0nVpfnkwrnuN3nL6P7NrZ96asIqadl7vQg2/eGwd4++X
         BV/ZxlVZeeeNrqOKpQIuF8XPO54WboIdAHP1WdiPuzVvItqShUYY/QDWmcCtc/LxES06
         d1xa1wnSLeEbWauxKqQPcvESc3DYZDRLn0SGdOon4/cCGwYwCiP3FJM+OaHjRAUNKOgS
         tkyIh13sP8oBu4NM2aL8REvNPLTRlxoNF9DEBLAUwwtDCAfm7Oggdr0JF7PU+hTiyQ6U
         7FtndWAqitnX/0nWkNk4AyFowit7TgdGcIlCgLHQoZ603dXWoBOQQjnsqZXlsiJ2fsx1
         1lWw==
X-Gm-Message-State: AOAM533KvZbDcD4ZgTzu1+gnz6KzCxdNRavNtyHbx8nmZJD9n+RwC4Iw
        uMJxvdpLU7Obn/T8j2IzUr0/fwJnOKU=
X-Google-Smtp-Source: ABdhPJwzdsHb87ammH6NzxN2c3ahraQcKv+DVeBDD8QspmzkdK7v171REpUQVzmU2k/mnux9z/ZgYA==
X-Received: by 2002:aa7:83c9:0:b029:158:11ce:4672 with SMTP id j9-20020aa783c90000b029015811ce4672mr659205pfn.23.1605204871250;
        Thu, 12 Nov 2020 10:14:31 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e8sm7602600pjr.30.2020.11.12.10.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:14:29 -0800 (PST)
Date:   Thu, 12 Nov 2020 10:14:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        =?utf-8?B?546L5pOO?= <wangqing@vivo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock
 is ERROR
Message-ID: <20201112181426.GC21010@hoboy.vegasvil.org>
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
 <64177a8e-eb60-bc27-6d64-26234be47601@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64177a8e-eb60-bc27-6d64-26234be47601@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:05:25PM +0200, Grygorii Strashko wrote:
> But, as Richard mentioned [1], ptp_clock_register() may return NULL even if PTP_1588_CLOCK=y
> (which I can't confirm neither deny - from the fast look at ptp_clock_register()
>  code it seems should not return NULL)

This whole "implies" thing turned out to be a colossal PITA.

I regret the fact that it got merged.  It wasn't my idea.

I will push back on playing games with the Kconfig settings.  Even if
that happens to work for your particular driver, still the call site
of ptp_clock_register() must follow the correct pattern.

Why?  Because others will copy/paste it.

Thanks,
Richard

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A0B2B2DCE
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 16:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgKNPOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 10:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKNPOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 10:14:15 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123BAC0613D1;
        Sat, 14 Nov 2020 07:14:15 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d17so4402527plr.5;
        Sat, 14 Nov 2020 07:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qmAMP16i07tpeovQ+3O4vWE0SUyj6XLgAHu8H2A/50k=;
        b=WCGQ00OnR7FbKKyFM2kuqPgRD0BxvtC5FoFZLujcvlcMVtVUqkhC6KPH1FcK7RyVkw
         funKZTRHwDqWmmxkpDPGl3fXzO12FeMbEqq/7k8s3DqReZQpUnhxCV40McJZuVaq30Xu
         FjX5ywCwOsTR4XcklZ0Zvd6N4mAo9SnNaaF7+D0NrhrWVxQDZyBsTbd/NVeHQ6ayocg4
         NqonoQQuQ2Nf7DyHEr+aD9+2RNfLBkz2LLf4ACXTqObiYakbn3Cu7m1Ir9AG1HhlFiYp
         EFdgvdXyL9J3oTj+kOisAZok3iZNmbjbBej5TeVEwZ2saGsTHUEOfnveucYApjX6vMwD
         dFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qmAMP16i07tpeovQ+3O4vWE0SUyj6XLgAHu8H2A/50k=;
        b=YU76zl9hWUkXV1jxTuzF8r3Lx1fq6uOi88HaVZ/yi2/1IZ25+EGiwe7Z+24HKy3GqL
         USESbJRr0QBOaPk8BYC3M+KREvM+/j76gr3fLGGkku/AxOxhU5jh5HTwKuie8mF4xkKp
         d0YA56CLY1D+nuWw7c6uJPzDg9nXZiMrEnX2UQGz6vavy5OHJkQ8G+Xhw7bpgFTdrI9u
         Uycz3KNo6niSqnOAXHXMPSQA0Nzj4E0kw9c5yRK0UOjonpq/lpGzwKVXxdmJUfARmGa0
         GFRVtWZzuemK5Zfuz9i+5XY6m4MayM1XYVzPkhKu7dIpL1VKd4QAoP1zbWYHgquZJiB+
         J/Bw==
X-Gm-Message-State: AOAM532pcqLj2K9cRfTXR0RvqQ0QQlOru9nJMNkWIumd/KfMKsMWIXHO
        yO1GN6s+G9VrWQFp3yHgiSk=
X-Google-Smtp-Source: ABdhPJzaf0fA2BFrOwja55OcpnOo5wIiRXK8APZrQgRTrmwfXOfH/gxWLxnanYurB/rvN1OFaUPV7Q==
X-Received: by 2002:a17:90b:2343:: with SMTP id ms3mr8061968pjb.130.1605366854549;
        Sat, 14 Nov 2020 07:14:14 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y124sm12796375pfy.28.2020.11.14.07.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 07:14:13 -0800 (PST)
Date:   Sat, 14 Nov 2020 07:14:10 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     =?utf-8?B?546L5pOO?= <wangqing@vivo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when
 ptp_clock is ERROR
Message-ID: <20201114151410.GA24250@hoboy.vegasvil.org>
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
 <20201112181954.GD21010@hoboy.vegasvil.org>
 <CAK8P3a1pHpweXP+2mp7bdg2GvU5kk4NASsu4MQCRPtK-VpuXSA@mail.gmail.com>
 <20201112232735.GA26605@hoboy.vegasvil.org>
 <CAK8P3a3V98x3s7DvHtutiz97Q=5QjfS6Xn4kH2r2iamY3dzwkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3V98x3s7DvHtutiz97Q=5QjfS6Xn4kH2r2iamY3dzwkw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 05:21:43PM +0100, Arnd Bergmann wrote:
> I've prototyped a patch that I think makes this more sensible
> again: https://pastebin.com/AQ5nWS9e

I like the behavior described in the text.

Instead of this ...

     - if a built-in driver calls PTP interface functions but fails
       to select HAVE_PTP_1588_CLOCK or depend on PTP_1588_CLOCK,
       and PTP support is a loadable module, we get a link error
       instead of having an unusable clock.

how about simply deleting the #else clause of

    --- a/include/linux/ptp_clock_kernel.h
    +++ b/include/linux/ptp_clock_kernel.h
    @@ -173,7 +173,7 @@ struct ptp_clock_event {
      };
     };
     
    -#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
    +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)

so that invalid configurations throw a compile time error instead?

Thanks,
Richard

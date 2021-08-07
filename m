Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80233E3713
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 23:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhHGU5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 16:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhHGU5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 16:57:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF318C0613CF;
        Sat,  7 Aug 2021 13:56:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k11-20020a17090a62cbb02901786a5edc9aso4314106pjs.5;
        Sat, 07 Aug 2021 13:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aDPS+XgQ7hE35dLkgpgBaogFW2sWOGSB2/ljVEyiaXE=;
        b=QkN+d27NFol80qPk1x1PjEoadt867p+EnfVJEqQr3mIcvz03YJ3gO1J6bUhpUlgSBC
         HRu9ZMDPANHSGwqKlJ8kkTfoUCwVQ4k10powPrORmLPwjpXjciqPdQz3SjKEG3GbQJL9
         YeQwJOzEDSrDTavXdi928gnCdhu0CmelWuE5FttBfOeYNG+J2R91b5yAniGIQlJt1Tf8
         69Ha4VqwQtHl1irko2AgAAuQcTISDnNRWJKbMrj3qOu+uK//g4/psooaxzmqYYUXISXO
         5tS6uCo4XXLB91hv981M3AsXAqYVdHscQrx5l55M9tn4kj1LoQriaQdO9y0afbLI881u
         JC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aDPS+XgQ7hE35dLkgpgBaogFW2sWOGSB2/ljVEyiaXE=;
        b=ZETXojj/0+HQc5IqooKnxTJRAN0Che09uc4ENaKtK8Tjyl28jwbzRZ/Y7IogHqmlJC
         MxmzQXcR4ZpPOAe8ehn8lRh0uNYXr7rzj/FO68Pf0S923AmplAiUIc8Yiw1gpkM+2vfG
         QFPLtFFlrGjvdXK87U2K0/Gpj6kY3wWuiR/ckONZjz3aUoZOrfE809TIGT6+dcosJ/o5
         94uny19yAKD4RaFXoVDYVPHd3jtm3kP3ZTZ2pKjhju1vjYpyW7INv1/5qOimkRR05q6o
         oiFFauVJWxosijLE9JIsofXEHigyS92VdFj8dht97z72DurYE5lKoWKyY18M86lBV0qD
         /mnA==
X-Gm-Message-State: AOAM530qgFKZFqV6NRF4OiLYE7XemDkyzyCX5NKut4CYrVFUvTtCZipG
        uSUoqHKyUF4tyu6XTngdx2g=
X-Google-Smtp-Source: ABdhPJwYep8tTUVrpoNuljGQS+T87KcHeKmlJQ8E1VasglxRR6sopaSE2SP5GJqcCuWgm1dBo0iYFA==
X-Received: by 2002:a17:90a:5982:: with SMTP id l2mr17279489pji.18.1628369807552;
        Sat, 07 Aug 2021 13:56:47 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b15sm16955974pgm.15.2021.08.07.13.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 13:56:47 -0700 (PDT)
Date:   Sat, 7 Aug 2021 13:56:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v5, 02/11] ptp: support ptp physical/virtual clocks
 conversion
Message-ID: <20210807205644.GD22362@hoboy.vegasvil.org>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
 <20210630081202.4423-3-yangbo.lu@nxp.com>
 <87r1f6kqby.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210807142259.GB22362@hoboy.vegasvil.org>
 <20210807144332.szyazdfl42abwzmd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807144332.szyazdfl42abwzmd@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 05:43:32PM +0300, Vladimir Oltean wrote:
> >  3. Let the vclocks hold a reference to the underlying posix dynamic clock.
> 
> So even if the vclock holds a reference to the underlying POSIX clock,
> that won't prevent the hardware driver from unbinding, and further
> gettime() calls on the vclock from faulting, will it?

Oh, your are right.  The vclocks call the real PHC clock's methods
directly, not through the posix dynamic clock layer.

> What about:
> 
> 4. Create a device link with the vclock being a consumer and the parent
>    clock being a supplier? This way, ptp_vclock_unregister() is
>    automatically called whenever (and before) ptp_clock_unregister() is.
> 
> https://www.kernel.org/doc/html/latest/driver-api/device_link.html

Sounds promising.

Thanks,
Richard

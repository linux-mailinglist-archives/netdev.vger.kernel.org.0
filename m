Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A055D21F35F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgGNOBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgGNOBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:01:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E3CC061755;
        Tue, 14 Jul 2020 07:01:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ch3so1627393pjb.5;
        Tue, 14 Jul 2020 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LAPLL1Etr4X6H0p32fkloMK+YWS04CQtf0+/cOQk1mU=;
        b=vIHVGT1TrhoXOkx/9fjfQklH4Vibz4aOwc7msNBTqgYuyrUoEbrtPTb+buKDcFefSe
         xLWZb5yAeh+KF3XqMZQLWQBtP6NfQlBv+Ks06h66w3KePqP3ovJvU+S80nHVbIfDgkXv
         F6Ib03hpr0HqEVzvg3+jJATQ4ishv6kxNkCaughd+Uqtmmf0kHb/G7amcAGEtkSuxC/b
         kpNvR9gbXeAUmg78gOR04CivoC8JL8525d5hMKTtEb4q17L5GE3DXwBxeT28arAQs93D
         NpC0lYnxTZr2Kb2COqq9IndTR2GcTkjuqZ8az96FjFWKao/uHjgSfHLXLRUij2qg0M+o
         u6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LAPLL1Etr4X6H0p32fkloMK+YWS04CQtf0+/cOQk1mU=;
        b=koNTeqqJllfd/OqORR7GlpWnsQ+rhsDHKVN679v4HxuOkI8dx2xk42OqFDCR+Zyc3b
         g3yzFsrtHcn7MFH4TCfMjcYMXV/74hPRouhQ6LEjPIBDv95wzzUwccWlw5kzgAIpPncp
         xpFQObc6hyiUqC0WchiHJQCMCZmcl+EzNeNcwpi6nNj4xVrINHrqzj7e8v8UjOw6cpcz
         u8ecBbR9opjeQoarPb8jTcU6tb8idiDqiFbgYJ3Xt4IBv/fRr4JDDNgvGp3pT8a1Pz6+
         zkKdxVkRHfdQe1KUHwwDClyShFeV7A0VL58jrHpp7KOWZMjVLXHG5YPADlFX3LSBKrrP
         /9QA==
X-Gm-Message-State: AOAM530Ms/Xwyh1UXLajtIGtRZmQX0Lo5dlyvskngixM8eZ1cPsKPley
        9V97qEBoIQNJUzonMy66ZMc=
X-Google-Smtp-Source: ABdhPJyZyRrrrGr84lJWs57y8WD9U7YRpr1yreqkKuqtjTHduf4Fs1PA0K7r9pPKyGE9vqMoBRmN+Q==
X-Received: by 2002:a17:90a:319:: with SMTP id 25mr4957393pje.77.1594735296983;
        Tue, 14 Jul 2020 07:01:36 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v8sm2786556pjf.46.2020.07.14.07.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 07:01:36 -0700 (PDT)
Date:   Tue, 14 Jul 2020 07:01:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200714140134.GA19806@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711120842.2631-1-sorganov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 03:08:42PM +0300, Sergey Organov wrote:
> Fix support for external PTP-aware devices such as DSA or PTP PHY:
> 
> Make sure we never time stamp tx packets when hardware time stamping
> is disabled.
> 
> Check for PTP PHY being in use and then pass ioctls related to time
> stamping of Ethernet packets to the PTP PHY rather than handle them
> ourselves. In addition, disable our own hardware time stamping in this
> case.
> 
> Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")
> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> ---
> 
> v2:
>   - Extracted from larger patch series
>   - Description/comments updated according to discussions
>   - Added Fixes: tag

Acked-by: Richard Cochran <richardcochran@gmail.com>

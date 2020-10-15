Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBA028EB99
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgJODgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgJODgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 23:36:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1B3C061755;
        Wed, 14 Oct 2020 20:36:52 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hk7so1071586pjb.2;
        Wed, 14 Oct 2020 20:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dZZ2W2ZXWR/5JghdDs4vC5Scf0IVrUV4frx943KPZ1E=;
        b=penxqKEAqwt9WKx6d3RwfgllRNuRpxXp0bDCLQPX5YL0EHWqGzOlaY9nmCOhXpRmox
         k1Z9a8E8F9FNN7PCOHIgATLHdUxZw033r6g5vHPgJDseR7R+YnGvBxCJYmC6Z3Elsbe2
         mPrXePosQm2k45suj35J6MwI6lUhjIw1PICUb7buRVGixonnSqec9I128hmVMkntCHkw
         GGc8foHraT4p9/d3JmIPXTg1Jz8XX836qZfV5RdthMDqUf4EG4z1SpanGylIPUuyU8eN
         pEbS13YNjdVveMwEh23zD9xpK/twItuaPgQeWH6U44TF7RLCGVAdhMgB0I8cAOFsLfaP
         SvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dZZ2W2ZXWR/5JghdDs4vC5Scf0IVrUV4frx943KPZ1E=;
        b=AibL2dJSIgwfNmG/PQUTqUbdmgmkIy1zOsn1vxd73RhDihpLTaTOZfo/tsezaXO4KV
         QNVV5hT2jInRRrqU712FcNVww3vwS5afOQQ9X8vElEEPFWW1P2TOYh9QT8lGEyJkvi2m
         vWfNjTNrzOnK7o2LjXSvq/feKeDEvIXEN2ra0rQRY3hL/1fqb4NpdG0iPZse27lplJ0J
         Gy/tAN3SYY5TfHRJwMaOzM1T+oqzW0V44nlDLUumSU7V2XEqn9n8I5cpk5F60RjEJji4
         P1TRGtNO3hsFlgBJR6eWp5K8mgCQCtcubkck8o8bKP2eer/eFEGwtXQ5Uy3eBjzjjwVh
         S1vA==
X-Gm-Message-State: AOAM530R1gyuN2ygIKh94Cz2FyKDltfGJKyNolAtAN8e5NlPY4aPCXaE
        fTbIvDwh7HDGQuBXep4wjsM=
X-Google-Smtp-Source: ABdhPJzjxyRNZ8dsFvfMKwI2RYmKGXTl4u2CHHVFFulzsjTjXc/zhUSL3u+oZZX4cqRZIUdUZ0Bb4g==
X-Received: by 2002:a17:90a:6b08:: with SMTP id v8mr2326317pjj.126.1602733011710;
        Wed, 14 Oct 2020 20:36:51 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 198sm1188174pfy.41.2020.10.14.20.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:36:50 -0700 (PDT)
Date:   Wed, 14 Oct 2020 20:36:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ptp: get rid of IPV4_HLEN() and OFF_IHL
 macros
Message-ID: <20201015033648.GA24901@hoboy>
References: <20201014115805.23905-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014115805.23905-1-ceggers@arri.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 01:58:05PM +0200, Christian Eggers wrote:
> Both macros are already marked for removal.

I'm not sure what Daniel Borkmann meant by that comment, but ...

>  	switch (type & PTP_CLASS_PMASK) {
>  	case PTP_CLASS_IPV4:
> -		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
> +		ptr += (((struct iphdr *)ptr)->ihl << 2) + UDP_HLEN;

to my eyes

	IPV4_HLEN(ptr)

is way more readable than

	(((struct iphdr *)ptr)->ihl << 2)

and this

	(struct udphdr *)((char *)ih + (ih->ihl << 2))

is really baroque.

I don't see any improvement here.

Thanks,
Richard


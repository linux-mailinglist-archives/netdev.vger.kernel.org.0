Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076803F727D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhHYKCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbhHYKCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:02:19 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18506C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:01:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h13so35571722wrp.1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xIE9tsNJeTeSBxdezy8oZzOrZS+e+x+Uo9ApFEBP4uw=;
        b=LYnRdIu2svGteoQ9fizlcgTlls8mnDP2/PfVxFlAosCM+A2VyWaVlQ3Pzkw1tq5rXa
         kk2k3rzO+YegpOhPPBtqrhjNQP9RwuBnAtEQ2kJTC4Xo77yXjgw5KbNtpi5eqm9XV9BL
         8GR3SiF7pNXib6PYl7o14nTjtR86M6owmBOP2De/l/+EwHcnWY5w6JV8Vv5/+o/6JGtp
         YOoSy/tZr+fFUFWskCRakU0LoNsOPvWD6Amp8+NB71WSCbcWe6dn25lB47DDDg1yOuKf
         ajzVDzAZxfZGsgNYrDvZLZpwxisd8aote9+o032UDooyFGsZsjFtyrothHvsk+0TrbqR
         tKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xIE9tsNJeTeSBxdezy8oZzOrZS+e+x+Uo9ApFEBP4uw=;
        b=nKImHaGGVJWaHN0aKlZeDALVkCPwrS3T7xIYXg6dMwr2ilnuUKy4MK2xhUW8SQc4Jl
         6/HE6ZiyCBoN7yqj+O+vzAkL7k59bmPPY1aNHrCQm8bDrjgZXqtk/ohIy90/m1yJB8tq
         veO+v6P6oLMUkK+fHqEgANHYzE9gaWGLOUdgeFrBJqnAvrI69tV7pPdf+PWAmIchV8PB
         9vi0RNQNYgCrL2g9zeDPmdiTXRw9AtvHESSPB3Z28sw0OqJROwsjD56OPkDbYqPcnuit
         ca7lXlXWzzaCGkNU3stWTK07fODjWwfITqnCGGrCay5jiUU+TWl2cN6ucPDWP76lAbmz
         jkXg==
X-Gm-Message-State: AOAM533Z+M/pDOu0m2DVoiGe+PkxAdY69jDfSgJYYyzer6D6i8L2r0tW
        5V670wSF9kiVbw9jHgv7giJaSgf5e71E8w==
X-Google-Smtp-Source: ABdhPJw1zjNNNwo4IUSg1kB4lccfB4PSy19lEsnRIuAOySobjLVgPBS7mbtXQqQChE5dtNBbloOA7w==
X-Received: by 2002:a5d:64ca:: with SMTP id f10mr24447106wri.225.1629885692679;
        Wed, 25 Aug 2021 03:01:32 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id d24sm4778308wmb.35.2021.08.25.03.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 03:01:32 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default to
 block if we have no policy
To:     antony.antony@secunet.com
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
 <e0c347a0-f7d4-e1ef-51a8-2d8b65bccbbc@6wind.com>
 <20210817111940.GA7430@moon.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9b0ddb88-c7d3-9bb6-48f2-1967425b3fc7@6wind.com>
Date:   Wed, 25 Aug 2021 12:01:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210817111940.GA7430@moon.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/08/2021 à 13:19, Antony Antony a écrit :
> On Wed, Aug 11, 2021 at 18:14:08 +0200, Nicolas Dichtel wrote:
[snip]
>> Maybe renaming this field to 'drop' is enough.
> 
> action is a bitwise flag, one direction it may drop and ther other might
> be allow.
> 
Sure, but I still think drop or accept would be better.

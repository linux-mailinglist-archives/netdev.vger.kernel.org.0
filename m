Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D034430EA95
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhBDDA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbhBDDA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:00:56 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D74C061573;
        Wed,  3 Feb 2021 19:00:16 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id r199so435694oor.2;
        Wed, 03 Feb 2021 19:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cxh7dUMIL7BPYdgMoXE3JEI/hHRYkvMS8bnj28tZcZ8=;
        b=WlpqNmUQB3+7RuywIxM4HehzGzv4f4/QEiT0jgOdiA2yR1iInrmP/lht/kolBd9pyH
         S2i02qL1xMr6cW7of9zfqeeOzmC/hfzj4fbpSnQ99Y53/aAtgFfVM4EeQvMHQaVJ1XMD
         //Zho4sd067ZJepKf09IbDq2SuFrXq3xKZaVTox2zvT7zGzYg8MZimhGS6qujxyfgBdE
         gkpYeoNzWCQLoPP5VRJG7YAZLnBk+2FWQWYXhfrrrVkaESq0n+YGaweN9bYAEDNbcUp3
         Gkh4WqcrkZOyfNoFDAPv7mP2kUqFP9wFjZr6M6vZtGBYCVXPV9cSZrBlOyuUtdQw92AK
         r+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cxh7dUMIL7BPYdgMoXE3JEI/hHRYkvMS8bnj28tZcZ8=;
        b=pNjgtRCbnnfGSmDW3lKkfRrfpe1hvfQEeyOKXFk8Ou0vZLrkdRKJegigoKtebl953X
         ljHzAjLDImlKT9UucBdQ4yeNUXIRbJZJtta4STvhoVOv+4wjKDn2Fo4t7Tm+n5nbA7na
         g1z+n1OEha4+BbtfkTnkX4i25p5M60SFreGJhhFSx/rzcTOrIggeVxWiiBWgNc40wYql
         3Zewhx4rsALVzcXwCtnDzbApqOlHmoqz6NmAmzHoSjotkTrv61SVmnPsBH+5Mova08e0
         03o3cLQ05PCcJlU/KpbvTELuJYKBIITch49ozHRP/m5VKpSR5+m4r6IQrauzJoHdVJj7
         ueew==
X-Gm-Message-State: AOAM531xBOGpszGXk1TcLp+/7YG6B2E6DF+NZ3wWyMEM2QyLmPVDlctl
        mzEA8OTTRwJy2eTfdoMs8VgQgYMCEZg=
X-Google-Smtp-Source: ABdhPJy7t+G8+FCYjaqizk2Y7XwXX6SQDeqVDySGyWwPhuyK4CaESAqkI2hgx4/7K4IiQ6MkMPbp4g==
X-Received: by 2002:a4a:a381:: with SMTP id s1mr4260432ool.37.1612407615452;
        Wed, 03 Feb 2021 19:00:15 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id t16sm844818otc.30.2021.02.03.19.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 19:00:14 -0800 (PST)
Subject: Re: [PATCH net-next] seg6: fool-proof the processing of SRv6 behavior
 attributes
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210202185648.11654-1-andrea.mayer@uniroma2.it>
 <6fe3beb2-4306-11cd-83ce-66072db81346@gmail.com>
 <20210204032727.ffd2c1ae3410147ba7598d78@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b9971d41-7349-a6cf-3ec2-0d7accbfa5c2@gmail.com>
Date:   Wed, 3 Feb 2021 20:00:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204032727.ffd2c1ae3410147ba7598d78@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 7:27 PM, Andrea Mayer wrote:
> 
> I think there is an issue here because BITS_PER_TYPE(unsigned long) is greater
> than the SEG6_LOCAL_MAX (currently = 9).
> 
> I think it should be like this:
> 
>  BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > BITS_PER_TYPE(unsigned long))
> 
> I will send a v2 with the changes discussed so far.

yes, I had that backwards.



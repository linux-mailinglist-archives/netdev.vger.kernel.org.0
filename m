Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E582525EB38
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgIEWGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgIEWGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 18:06:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C20C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 15:06:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so4402529pfn.8
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 15:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DqanE+iGvh2VCIs4MtC9EFtqnuZmI+rFekZt4S5g6uA=;
        b=gq0k08OlD86Hp3WWaRyqyYGTCY6r947pZQniVxJhJtELnQ7ORsin+11pFCo84SDETs
         3Khqejf6YeMnp+B61Y2hmswmZfaJWSCUh/cxbwNRfeDlUosgzp2bABSH8Y/2V+vSpiIn
         llNIIrq9N3RlC5QL0EM/S1cPTvEANDHK9p5MQjNEg/OQodrYWsu7/+ZPaR5Dc7TJsFOP
         B/K43hlmcitZjOero//FRtwPW+AbnLX6FcrmUojxSahqTx/vNclxINrdvmtnyppisgnb
         zYUKQptdUliC2yVErFBFHsxVM6nrP085iJkqZ40D//c0OdP85dejVI0u5/DOVU9pcY2q
         fWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DqanE+iGvh2VCIs4MtC9EFtqnuZmI+rFekZt4S5g6uA=;
        b=ey0SKku63CMMzninDka399+J8d4EMvZOL+LJNSGIcQlrmpbPpnPZcqj5sUpOwCz8uZ
         Lekoa9w06qKrAAQlpVq5n91+qcy6s0K2oOqKAjINKV+4LJhFu/JTL/9JPNAdPTZQZWjI
         7nV+V+qAmgFBgHgWE8qZoxQmoXkBIv9ObAknEd9RkdbkjsyPg7cSl54bGjNcj+xkI8Um
         Aa5ilj/gYTTIHpGB3Jc98IT4c4qvLvmc5TL4In37drwLIErDfmCLgJuyl7LMbtOqN+e5
         VVuAlDY5cQtYcnhusukREn7t5dYp2PKquSG57D9MPrhnSmOO9wLx8DY+w2zzqbHbYjeZ
         vWmw==
X-Gm-Message-State: AOAM533jEmXAChTI7OX6+q9Il3XPPNs7hAJxoSg0mGVKsYEU9ooHmCGF
        GGBepzbIFr9ziA8h/Dj5mhGmL/IQQBBSTA==
X-Google-Smtp-Source: ABdhPJy1W3PMNT73gRLXNsLopxoe1U1skICL4kr9r3HMCRYO3SFfne+8sDrzCC8Lq3DV1ZZZG30qUg==
X-Received: by 2002:a63:c543:: with SMTP id g3mr12125297pgd.203.1599343568808;
        Sat, 05 Sep 2020 15:06:08 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 64sm3608487pfz.204.2020.09.05.15.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 15:06:08 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200904000534.58052-1-snelson@pensando.io>
 <20200904000534.58052-3-snelson@pensando.io>
 <20200905130422.36e230df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <328d7cc0-9bf9-3051-52d5-9f7ac2fd4075@pensando.io>
Date:   Sat, 5 Sep 2020 15:06:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200905130422.36e230df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/20 1:04 PM, Jakub Kicinski wrote:
> On Thu,  3 Sep 2020 17:05:34 -0700 Shannon Nelson wrote:
>> +/* The worst case wait for the install activity is about 25 minutes when
>> + * installing a new CPLD, which is very seldom.  Normal is about 30-35
>> + * seconds.  Since the driver can't tell if a CPLD update will happen we
>> + * set the timeout for the ugly case.
> 25 minutes is really quite scary. And user will see no notification
> other than "Installing 50%" for 25 minutes? And will most likely not
> be able to do anything that'd involve talking to the FW, like setting
> port info/speed?

Yeah, it's pretty annoying, and the READMEs with the FW will need to 
warn that the install time will be much longer than usual.

>
> Is it possible for the FW to inform that it's updating the CPLD?

We don't have any useful feedback mechanism for this kind of thing, but 
I'll think about how it might work and see if I can get something from 
the FW folks.  Another option would be for the driver to learn how to 
read the FW blob, but I'd really rather not go down that road.

>
> Can you release the dev_cmd_lock periodically to allow other commands
> to be executed while waiting?

I think this could be done.  I suspect I'll need to give the dev_cmd the 
regular timeout and have this routine manage the longer potential 
timeout.  I'll likely have to mess with the low-level dev_cmd_wait to 
not complain about a timeout when it is a FW status command.

The status_notify messages could then be updated in order to show some 
progress, but would we base the 100% on the remote possibility that it 
might take 25 minutes?  Or use some scaled update time, taking longer 
between updates as time goes on? Hmmm...

I'll think about this over the long weekend.

Thanks,
sln


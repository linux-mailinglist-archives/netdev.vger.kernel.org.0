Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EFD57C546
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiGUH0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGUH0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:26:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FACC2A976;
        Thu, 21 Jul 2022 00:26:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ku18so816064pjb.2;
        Thu, 21 Jul 2022 00:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=SbJNWDK0M1wZHtYDZkc0Drlqr/h/SXJ/tlHRQqdUMTI=;
        b=QFi8yqEQ5BCdBvt7z88bOmlZHc0lwDxg5wcNQFIPxxwaEB6Rfut3WF/5WGv0BjPfCD
         PwkhgCDonQIpdDCNigz5ItDxHS6cF6ACoaoeovjzSj7e7V6R13asngrSWcW8kPPxNyha
         QMnFeAA8Ug+5Sif0n6TKW8z0noESbAo4Eff9jjtvkaPGh4g9EQEMCINvAiyH7bzndWbw
         0qIxLxHDJn6Fvt8Zwc4wuhSRlsVCW0pF17Yv/BEdke0B9oKAILCB/jME7B6EoHtPC81T
         ynQ2+fYFqxkYnoDG8viYwWQremU2QOsYAMppg+S8LkBMuAU9kmhxSoW5sXO2VM9QjPb3
         LVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SbJNWDK0M1wZHtYDZkc0Drlqr/h/SXJ/tlHRQqdUMTI=;
        b=K8MM3krDhGeTI4eatZUpPC5lYWwv2tviEK2s2sk67ku8Xtd6WcZhPQhH0vA+OOM4Sc
         CSEic0wSZ5MMMWRH6FpspPNz5HD8Nb0mndjrw0+WbSNYX/pkwjb99ZTfmt1DRot5hU41
         vYF0sti1wmbuZU+dkTxBVXRRen6ZPIpuKoRZBYvi3Orm2e1CRE5nqtiUec+tMGEw8/I5
         L523OFib4SNE+x/zsJzJLiaXnkqIoTn6ECApUF9+wOSUKUmPRrwKsojG3GceNtBYXitG
         vhwNDIAZHiNUSzIVLwkhO6kJaLrmwFFEEVPh5WO7jZxOh5ors2/pUUSyC//4D4cYGUdb
         TP7Q==
X-Gm-Message-State: AJIora/5nJFdHz0eT0U+YD7FohUQzWmRQ2qP8YgKbdxlSGlsraU9yx1u
        l23b2ejhRnUbhaG5fE1gGeU=
X-Google-Smtp-Source: AGRyM1uKv5lo6lhHFNo8GXb7apy5wTjjn/W2WK2c5zABVP5gMPNn07FionuaFPivoDdlLKhi1X1s2g==
X-Received: by 2002:a17:902:f650:b0:15f:3a10:a020 with SMTP id m16-20020a170902f65000b0015f3a10a020mr42495170plg.61.1658388407001;
        Thu, 21 Jul 2022 00:26:47 -0700 (PDT)
Received: from [172.25.58.87] ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id q8-20020a63d608000000b00411b3d2bcadsm754934pgg.25.2022.07.21.00.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 00:26:46 -0700 (PDT)
Message-ID: <98780f47-dadd-577e-8baa-322c9503d825@gmail.com>
Date:   Thu, 21 Jul 2022 16:26:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH -next] amt: Return true/false (not 1/0) from bool function
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220721024443.112126-1-yang.lee@linux.alibaba.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220721024443.112126-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,
Thanks a lot for this work!

2022. 7. 21. 오전 11:44에 Yang Li 이(가) 쓴 글:
 > Return boolean values ("true" or "false") instead of 1 or 0 from bool
 > functions. This fixes the following warnings from coccicheck:
 >

commit 30e22a6ebca0 ("amt: use workqueue for gateway side message 
handling") is not yet merged into net-next branch.
So, this patch can't be applied to net-next right now.

 > ./drivers/net/amt.c:901:9-10: WARNING: return of 0/1 in function 
'amt_queue_event' with return type bool
 >
 > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
 > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
 > ---
 >   drivers/net/amt.c | 4 ++--
 >   1 file changed, 2 insertions(+), 2 deletions(-)
 >
 > diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 > index febfcf2d92af..2ff53e73f10f 100644
 > --- a/drivers/net/amt.c
 > +++ b/drivers/net/amt.c
 > @@ -898,7 +898,7 @@ static bool amt_queue_event(struct amt_dev *amt, 
enum amt_event event,
 >   	spin_lock_bh(&amt->lock);
 >   	if (amt->nr_events >= AMT_MAX_EVENTS) {
 >   		spin_unlock_bh(&amt->lock);
 > -		return 1;
 > +		return true;
 >   	}
 >
 >   	index = (amt->event_idx + amt->nr_events) % AMT_MAX_EVENTS;
 > @@ -909,7 +909,7 @@ static bool amt_queue_event(struct amt_dev *amt, 
enum amt_event event,
 >   	queue_work(amt_wq, &amt->event_wq);
 >   	spin_unlock_bh(&amt->lock);
 >
 > -	return 0;
 > +	return false;
 >   }
 >
 >   static void amt_secret_work(struct work_struct *work)

Thanks a lot!
Taehee Yoo

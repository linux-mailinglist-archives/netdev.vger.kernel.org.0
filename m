Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5A9569331
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiGFUVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiGFUVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:21:35 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7821820F77;
        Wed,  6 Jul 2022 13:21:34 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r21so188140eju.0;
        Wed, 06 Jul 2022 13:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IVs1PzHuez3hQcAirS0d2q10S8U/unbnwRNkqW7KJhY=;
        b=gXNpFpMrLWRQHhbXM/UxJAvfsUhf3EcI6SJ2wm46oGxsL9gYfbTnoCCdys1ny06Vvq
         mUxJzLKrt76BMDGd/vHIBW/bniKp+lcEBPmcmnJcAySrOpq4OTBm4GekEN1euq+MIaI+
         /zFrPtM92Tnn2vD5fByJZLro7HK6AJF8d4EDvPzssGJ3c4CVTBMtjzJ1IXXtgXLisAss
         3p+0qDB/dTVPiS4hdVlN7qafL9A25lQB8o6ET4+Mmwoh2M+CJxOCMo6Dl4+khWB175We
         Myhn9VYOu0c6dKHfGKJMzjH3D66vCA71Qxj3aV7ne/exUKDwJ/2UH8Bqru3VhnKpKQ6t
         5o5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IVs1PzHuez3hQcAirS0d2q10S8U/unbnwRNkqW7KJhY=;
        b=HtQaSnNHD+0n0thFIoYRGCA9dOhI31Q7VhEMuxIHiKNkn0v2KBLBnDteFYgrDO3AQX
         sMq1v8s//aceUf0bvgh+9G4XnqkTn+XWAVBPbRfK8siZ3ibxhdnBv2MTPDbMz6lBe9eg
         8e7/aCdp5MHRJFeTLW/mVbwMW9/aRyEbSLuFw95QhAnyY6+2cpkfXWLaFDYzJNTneZPg
         ozJJgyQMHEa0jw57c/Eui9VEEc2Aec6ApA6WQYPnzVp+qp5KD73VuhZslx5rsRlm5SxH
         5fRLr9/Q+M5UzbQuNELXdEbBXQnCHQWh3cVQceas+ePvd87IG2iS4rS2wAYHPUg4qv8X
         Wyng==
X-Gm-Message-State: AJIora9oxPc+wKnJKUcU1raZVYbtJOdzXFbwBUQY1XZAbNEmTAasuQ3V
        aCEgX8R7oU9gS5qGOjI/Oyo=
X-Google-Smtp-Source: AGRyM1usqPuiPgZ/X2EoQWVd4/tGjc7aIU1ds6yevsv1Qdo9wuRX+oI0PmAyvVtvV7TPRq5uSwSAWA==
X-Received: by 2002:a17:907:9710:b0:726:bdf6:edee with SMTP id jg16-20020a170907971000b00726bdf6edeemr40857024ejc.48.1657138893048;
        Wed, 06 Jul 2022 13:21:33 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id p23-20020a1709061b5700b0070e3f58ed5csm17653730ejg.48.2022.07.06.13.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 13:21:32 -0700 (PDT)
Date:   Wed, 6 Jul 2022 23:21:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <20220706202130.ehzxnnqnduaq3rmt@skbuf>
References: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
 <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
 <86v8tu7za3.fsf@gmail.com>
 <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org>
 <20220706181316.r5l5rzjysxow2j7l@skbuf>
 <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 10:38:04PM +0300, Nikolay Aleksandrov wrote:
> I don't think that is new or surprising, if there isn't anything to control the
> device resources you'll get there. You don't really need to write any new programs
> you can easily do it with mausezahn. I have tests that add over 10 million fdbs on
> devices for a few seconds.

Of course it isn't new, but that doesn't make the situation in any way better,
quite the opposite...

> The point is it's not the bridge's task to limit memory consumption or to watch for resource
> management. You can limit new entries from the device driver (in case of swdev learning) or
> you can use a daemon to watch the number of entries and disable learning. There are many
> different ways to avoid this. We've discussed it before and I don't mind adding a hard fdb
> per-port limit in the bridge as long as it's done properly. We've also discussed LRU and similar
> algorithms for fdb learning and eviction. But any hardcoded limits or limits that can break
> current default use cases are unacceptable, they must be opt-in.

I don't think you can really say that it's not the bridge's task to
limit memory consumption when what it does is essentially allocate
memory from untrusted and unbounded user input, in kernel softirq
context.

That's in fact the problem, the kernel OOM killer will kick in, but
there will be no process to kill. This is why the kernel deadlocks on
memory and dies.

Maybe where our expectations differ is that I believe that a Linux
bridge shouldn't need gazillions of tweaks to not kill the kernel?
There are many devices in production using a bridge without such
configuration, you can't just make it opt-in.

Of course, performance under heavy stress is a separate concern, and
maybe user space monitoring would be a better idea for that.

I know you changed jobs, but did Cumulus Linux have an application to
monitor and limit the FDB entry count? Is there some standard
application which does this somewhere, or does everybody roll their own?

Anyway, limiting FDB entry count from user space is still theoretically
different from not dying. If you need to schedule a task to dispose of
the weight while the ship is sinking from softirq context, you may never
get to actually schedule that task in time. AFAIK the bridge UAPI doesn't
expose a pre-programmed limit, so what needs to be done is for user
space to manually delete entries until the count falls below the limit.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96864F0FF
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 19:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLPScL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 13:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiLPScF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 13:32:05 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAA76F482
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 10:32:04 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qk9so8182317ejc.3
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 10:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bEp6X+kd+ZUKra+vj/Jby9rdX+eNGaULERxsVFbN5ao=;
        b=Y4HTZigyE3nWe1oSM96w36c01d87RVvSgik//pYDUewr29aleb73YBADMHWVrKzv+4
         DgRL6Vh6k4tF+yPUucffIDIrLLSXZvmVrY9+H0EN6ARtxlz6bvEktwCxXHIZwjc4iml+
         ag2EYie7bDEVkFllGU6AiAvPVJuMQbLjTCmQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEp6X+kd+ZUKra+vj/Jby9rdX+eNGaULERxsVFbN5ao=;
        b=pBcPbhy60IpPdDmRH4b1Rw2aDR9Gsudv5kRLMTqj8BgpZhduaJk9nMd6avmKZaBIgc
         vUu2zACGLB7swfLadqlvQFT3Hb6ih1KVaXDmmxcvKlrowHalVT7hNxmv40H6En5I2dEs
         VaG8GdPzrX+temM6PUg1Mu5tinQf8QbscOW8FHUD2cpIZF9V+pMz10Jh9KS000S7zT4J
         BKCs+rbQHdDANlHTTFdRo5aJYEIOT0w+k+giZP0ftPk3yasE9mm9i1wXT+whsObRykWL
         bVmLEkBxG1ftcD7fkbSNxZKVMpklSX49q0ReH8bE/iRGYB1hcnl/HUjp9xAmLrKLn2P6
         0qbw==
X-Gm-Message-State: ANoB5pkrR0Iep6IKUdQQUbpSOmo85PtybZZHvO56kdBSqeUVm8hI+Ome
        RsTAH4CDRIH5beXX7bJ7DQZZ7w==
X-Google-Smtp-Source: AA0mqf5/jMisEuPQc2GA/MdiKW9CIWa1auXj5/VfFOtVz0nThvp4/GDSBxNVG1bDLbPSL+o6oitLVQ==
X-Received: by 2002:a17:906:3f90:b0:7ad:943a:4da0 with SMTP id b16-20020a1709063f9000b007ad943a4da0mr27171962ejj.21.1671215523036;
        Fri, 16 Dec 2022 10:32:03 -0800 (PST)
Received: from panicking (93-44-112-168.ip96.fastwebnet.it. [93.44.112.168])
        by smtp.gmail.com with ESMTPSA id v25-20020a170906b01900b007add1c4dadbsm1104260ejy.153.2022.12.16.10.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 10:32:02 -0800 (PST)
Date:   Fri, 16 Dec 2022 19:31:59 +0100
From:   Michael Trimarchi <michael@amarulasolutions.com>
To:     NeilBrown <neilb@suse.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-nfs@vger.kernel.org,
        Anna Schumaker <anna.schumaker@netapp.com>
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
Message-ID: <Y5y5n8JoGZNt1otY@panicking>
References: <20220414110838.883074566@linuxfoundation.org>
 <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>
 <CA+G9fYscMP+DTzaQGw1p-KxyhPi0JB64ABDu_aNSU0r+_VgBHg@mail.gmail.com>
 <165094019509.1648.12340115187043043420@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165094019509.1648.12340115187043043420@noble.neil.brown.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neil

On Tue, Apr 26, 2022 at 12:29:55PM +1000, NeilBrown wrote:
> On Thu, 21 Apr 2022, Naresh Kamboju wrote:
> > On Mon, 18 Apr 2022 at 14:09, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Thu, 14 Apr 2022 at 18:45, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 4.19.238 release.
> > > > There are 338 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > >
> > > Following kernel warning noticed on arm64 Juno-r2 while booting
> > > stable-rc 4.19.238. Here is the full test log link [1].
> > >
> > > [    0.000000] Booting Linux on physical CPU 0x0000000100 [0x410fd033]
> > > [    0.000000] Linux version 4.19.238 (tuxmake@tuxmake) (gcc version
> > > 11.2.0 (Debian 11.2.0-18)) #1 SMP PREEMPT @1650206156
> > > [    0.000000] Machine model: ARM Juno development board (r2)
> > > <trim>
> > > [   18.499895] ================================
> > > [   18.504172] WARNING: inconsistent lock state
> > > [   18.508451] 4.19.238 #1 Not tainted
> > > [   18.511944] --------------------------------
> > > [   18.516222] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> > > [   18.522242] kworker/u12:3/60 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > > [   18.527826] (____ptrval____)
> > > (&(&xprt->transport_lock)->rlock){+.?.}, at: xprt_destroy+0x70/0xe0
> > > [   18.536648] {IN-SOFTIRQ-W} state was registered at:
> > > [   18.541543]   lock_acquire+0xc8/0x23c
> 
> Prior to Linux 5.3, ->transport_lock needs spin_lock_bh() and 
> spin_unlock_bh().
> 

We get the same deadlock or similar one and we think that
can be connected to this thread on 4.19.243. For us is a bit
difficult to hit but we are going to apply this change

net: sunrpc: Fix deadlock in xprt_destroy

Prior to Linux 5.3, ->transport_lock needs spin_lock_bh() and
spin_unlock_bh().

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
---
 net/sunrpc/xprt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d05fa7c36d00..b1abf4848bbc 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1550,9 +1550,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
 	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
 	 * can only run *before* del_time_sync(), never after.
 	 */
-	spin_lock(&xprt->transport_lock);
+	spin_lock_bh(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
-	spin_unlock(&xprt->transport_lock);
+	spin_unlock_bh(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can
-- 
2.37.2

> Thanks,
> NeilBrown
>

Thank you

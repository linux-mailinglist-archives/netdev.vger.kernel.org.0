Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B100F638CC2
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiKYOyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiKYOyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:54:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6004E28738;
        Fri, 25 Nov 2022 06:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC9FB82B2A;
        Fri, 25 Nov 2022 14:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCEEC433C1;
        Fri, 25 Nov 2022 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669388084;
        bh=X6duHG1DzBZC/eiNX9qpygv77VpsBbT5+iXpjXIGEkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/dl7Hwmgdaj6MxO/pCTgdFwlnEPhk8v1MD0NMui1v5oBmDHWPy0N0n6Ui60F3AQU
         ceyF3e3rjFlisClTQDa4tyWzVJHwV8YNEQG4pf0TXACO0ZggxXTnXtg+IaSdq3oaDq
         89g7u6+rlzAayKMyuWIl8rwv8CPNMiogCgCEBie4=
Date:   Fri, 25 Nov 2022 15:54:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <Y4DXMRK4HZFp7aOc@kroah.com>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
 <Y4BuUU5yMI6PqCbb@kroah.com>
 <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
 <a1652617-9da5-4a29-9711-9d3b3cf66597@app.fastmail.com>
 <23b0fa9c-d041-8c56-ec4b-04991fa340d4@huawei.com>
 <78fc17ac-bdce-4835-953d-d50d0a467146@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78fc17ac-bdce-4835-953d-d50d0a467146@app.fastmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 11:32:49AM +0100, Arnd Bergmann wrote:
> On Fri, Nov 25, 2022, at 11:25, YueHaibing wrote:
> > On 2022/11/25 18:02, Arnd Bergmann wrote:
> >> On Fri, Nov 25, 2022, at 09:05, Naresh Kamboju wrote:
> >>> On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>>> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
> >>>>>
> >>>>> Daniel bisected this reported problem and found the first bad commit,
> >>>>>
> >>>>> YueHaibing <yuehaibing@huawei.com>
> >>>>>     net: broadcom: Fix BCMGENET Kconfig
> >>>>
> >>>> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
> >>>> this -rc release.
> >>>
> >>> It started from 5.10.155 and this is only seen on 5.10 and other
> >>> branches 5.15, 6.0 and mainline are looking good.
> >> 
> >> I think the original patch is wrong and should be fixed upstream.
> >> The backported patch in question is a one-line Kconfig change doing
> >
> > It seems lts 5.10 do not contain commit e5f31552674e ("ethernet: fix 
> > PTP_1588_CLOCK dependencies"),
> > there is not PTP_1588_CLOCK_OPTIONAL option.
> 
> Ok, so there is a second problem then.
> 
> Greg, please just revert fbb4e8e6dc7b ("net: broadcom: Fix BCMGENET Kconfig")
> in stable/linux-5.10.y: it depends on e5f31552674e ("ethernet: fix
> PTP_1588_CLOCK dependencies"), which we probably don't want backported
> from 5.15 to 5.10.

Now reverted, thanks.

greg k-h

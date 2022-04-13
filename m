Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7624FF8B8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiDMOSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiDMOSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:18:14 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDF85F8DE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 07:15:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id t11so4187650eju.13
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sj26ljVoaGLJYe+WUwiF0a3U0eLQ0dS3nh2IKwO4+S4=;
        b=SvJ4RhiPAy4BSWaNWtn81CJYzkX/aNozZyZ2hieniiUOIxJvNiIP1hKdorVUgOI1EW
         s1WsqbmX3+ZU1OA84XFM0hicL2txCoXiTLOJ+loGrBpQELyLtX4hHb6Q4FcMtCbmk67e
         /34cun2lKuBTMX20kOBGH9CXh7wCjukRwNVhEDnH7ugUkV9bh43OQS0gQWBwKMYeRksr
         YKjeN8UmL95/s94a27t5M6gg8LT4+S0Ya17PDQUa7BX5+dRT8GrvrVM+UWgcdooQ5Tx+
         TGpeO1d+Cx5AzuaLpSyBvuOSCpmrJdifvfZAinIDdOfTBP3yfXHVe6Slxa5tqz09kcSj
         4HYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sj26ljVoaGLJYe+WUwiF0a3U0eLQ0dS3nh2IKwO4+S4=;
        b=YvXqcO72j0WLRFh+YzFHLqnW5/bKoRMd9aAr3YMMA8SJeQtiZF1GW3xPeuEH/zqpIO
         wtf0sRPau/0ZH6a31peVt1CPEIja0IvNUXg1l8Eg8VY2GSEdjQy17G5KEmW2Iour680E
         cCYO7Fh19AzSLSCC1bZ1W4NW2tflRiJacCKvr22mZfvUqpdKuHQkd7gtjGzBJvUkhW3U
         qn4OPaD5kZdgz1N7h1VpMil6QA7bueO32XVqan4PlmvAHjfH4iy4KN47rmpakcs3R7Nc
         mjqDGBY7GWoc7QSxy7UQw4OquBgHNtXMCpSxNcxXGUejiTJKPhhepP/BYvBr/2rxtH6g
         SCWw==
X-Gm-Message-State: AOAM5334uVIOmUsbX2ZnqKLUHIfHEW8Au3sMnrbSswXo8m2KTX/nKD6a
        su8l4iThHMjGBgot31UaADA1TSZ8eXk=
X-Google-Smtp-Source: ABdhPJwKRb82vSMaYbjLP4Qh7yiVu3vTfTXVVrvs3/etFknQYJE8CZZJSagdsMUidBaGKya0IO2pkQ==
X-Received: by 2002:a17:906:8a4e:b0:6e8:9109:cc01 with SMTP id gx14-20020a1709068a4e00b006e89109cc01mr13827856ejc.80.1649859348396;
        Wed, 13 Apr 2022 07:15:48 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm38443ejz.57.2022.04.13.07.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:15:47 -0700 (PDT)
Date:   Wed, 13 Apr 2022 17:15:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@nvidia.com" <roid@nvidia.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC net-next] net: tc: flow indirect framework issue
Message-ID: <20220413141546.velahw5nt2omes7g@skbuf>
References: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
 <DM5PR1301MB2172F573F9314D43F79D8F26E7EC9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <20220413090705.zkfrp2fjhejqdj6a@skbuf>
 <2a82cf39-48b9-2c6c-f662-c1d1bce391ba@gmail.com>
 <YlbR4Cgzd/ulpT25@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlbR4Cgzd/ulpT25@salvia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

On Wed, Apr 13, 2022 at 03:36:32PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 13, 2022 at 02:24:38PM +0200, Mattias Forsblad wrote:
> > On 2022-04-13 11:07, Vladimir Oltean wrote:
> > > Hi Baowen,
> > > 
> > > On Wed, Apr 13, 2022 at 07:05:39AM +0000, Baowen Zheng wrote:
> [...]
> > > Mattias' question comes from the fact that there is already some logic
> > > in flow_indr_dev_register() to replay missed flow block binding events,
> > > added by Eli Cohen in commit 74fc4f828769 ("net: Fix offloading indirect
> > > devices dependency on qdisc order creation"). That logic works, but it
> > > replays only the binding, not the actual filters, which again, would be
> > > necessary.
> 
> A bit of a long email...
> 
> This commit 74fc4f828769 handles this scenario:
> 
> 1) eth0 is gone (module removal)
> 2) vxlan0 device is still in place, tc ingress also contains rules for
>    vxlan0.
> 3) eth0 is reloaded.
> 
> A bit of background: tc ingress removes rules for eth0 if eth0 is
> gone (I am refering to software rules, in general). In this model, the
> tc ingress rules are attached to the device, and if the device eth0 is
> gone, those rules are also gone and, then, once this device eth0 comes
> back, the user has to the tc ingress rules software for eth0 again.
> There is no replay mechanism for tc ingress rules in this case.

I don't understand the mechanics of this side note, sorry (maybe also
because I don't know the mechanics of VXLAN / VXLAN offload in mlxsw).

Presumably, tc filters on the ingress of vxlan0 would not just vanish if
some random other net device in the system unregistered. Those rules
would have to be in some way related to eth0, like "mirred egress
redirect eth0" or something like that. In that case, yes I agree it is
fully to be expected for this rule to disappear when eth0 disappears.
But that makes the example also not applicable to what Mattias is trying
to achieve, except maybe to illustrate that the indirect flow block
framework isn't adequate for it.

> IIRC, Eli's patch re-adds the flow block for vxlan0 because he got a
> bug report that says that after reloading the driver module and eth0
> comes back, rules for tc vxlan0 were not hardware offloaded.
> 
> The indirect flow block infrastructure is tracking devices such as
> vxlan0 that the given driver *might* be able to hardware offload.
> But from the control plane (user) perspective, this detail is hidden.
> To me, the problem is that there is no way from the control plane to
> relate vxlan0 with the real device that performs the hardware offload.
> There is also no flag for the user to request "please hardware offload
> vxlan0 tc ingress rules". Instead, the flow indirect block
> infrastructure performs the hardware offload "transparently" to the user.

It would be difficult to draw a full relationship between your VXLAN
example and what Mattias is trying to do ("matchall action drop" on
bridge device). Since the bridge is an upper device with multiple
lowers, some lowers may monitor this tc rule and do something about it,
while other lowers may not. What do you report to user space in that
case, "partially offloaded"? Do you report the full list of offloaders?

> I think some people believe doing things fully transparent is good, at
> the cost of adding more kernel complexity and hiding details that are
> relevant to the user (such as if hardware offload is enabled for
> vxlan0 and what is the real device that is actually being used for the
> vxlan0 to be offloaded).

Assuming that this is what you're hinting at: when a DSA port leaves a
bridge, the "matchall action drop" rule that was added by the user on
the bridge should automagically disappear, because its offloaders
disappeared?

But maybe you liked that rule anyway... maybe the bridge had 4 DSA
ports, and 50 non-DSA ports, and that rule applies with or without DSA.

> So, there are no flags when setting up the vxlan0 device for the user
> to say: "I would like to hardware offload vxlan0", and going slightly
> further there is not "please attach this vxlan0 device to eth0 for
> hardware offload". Any real device could be potentially used to
> offload vxlan0, the user does not know which one is actually used.
> 
> Exposing this information is a bit more work on top of the user, but:
> 
> 1) it will be transparent: the control plane shows that the vxlan0 is
>    hardware offloaded. Then if eth0 is gone, vxlan0 tc ingress can be
>    removed too, because it depends on eth0.
> 
> 2) The control plane validates if hardware offload for vxlan0. If this
>    is not possible, display an error to the user: "sorry, I cannot
>    offload vxlan0 on eth0 for reason X".
> 
> Since this is not exposed to the control plane, the existing
> infrastructure follows a snooping scheme, but tracking devices that
> might be able to hardware offload.
> 
> There is no obvious way to relate vxlan0 with the real device
> (eth0) that is actually performing the hardware offloading.
> 
> Does replay make sense for vxlan0 when the user has to manually
> reload rules for eth0? So why vxlan0 rules need to be transparently
> replayed but eth0 rules need to be manually reloaded in tc ingress?

Yes, filter replay for vxlan0 makes perfect sense to the extent that the
list of filters to reoffload would be empty in the particular case you
give. So nothing changes. But the filters that you have to react on do
not always involve you (snooper) as a net device.

> > >> Maybe you can try to regist your callback in your module load stage I
> > >> think your callback will be triggered, or change the command order as: 
> > >> tc qdisc add dev br0 clsact
> > >> ip link set dev swp0 master br0
> > >> tc filter add dev br0 ingress pref 1 proto all matchall action drop
> > >> I am not sure whether it will take effect.
> > > 
> > > I think the idea is to make the given command order work, not to change it.
> > 
> > Re-ordering the tc commands doesn't solve the issue when all ports leave the
> > bridge, which will lead to flow_indr_dev_unregister() and later re-joins
> > the bridge (flow_indr_dev_register()). We'll need filter replay for this.
> 
> Existing drivers call flow_indr_dev_register() from module init, so
> they start tracking any device that might be offloaded since the
> beginning, see below.

There's a certain level of absurdity to the idea that, on a kernel
compiled with CONFIG_NET_DSA=y, the DSA module would track and save
state for every tc filter added on the ingress of any bridge in the
system, *regardless* of whether any DSA switch has probed, or will even
probe in that system. Distribution kernels come with CONFIG_NET_DSA
enabled by default.

> Mattias Forsblad said:
> >tc qdisc add dev br0 clsact
> >tc filter add dev br0 ingress pref 1 proto all matchall action drop
> >
> >And then adds a port to that bridge
> >ip link set dev swp0 master br0   <---- flow_indr_dev_register() bc this
> 
> Regarding your issue: Why does it call flow_indr_dev_register() here?
> Most drivers call flow_indr_dev_register() much earlier, when swp0
> becomes available.  Then, tc qdisc add dev br0 clsact will trigger the
> indirect flow block path to reach your driver.

So my main takeaway is that what Mattias is trying to do is
fundamentally inadequate to the very limited use case that
flow_indr_dev_register() was intended for.

The obvious alternative is for the bridge driver itself to bind to its
own flow block, watch for the same tc filters, and re-notify them via
other mechanisms to drivers which are interested. The advantage would be
that the filters have the same lifetime as the bridge device itself, and
the bridge device is notified of port joins/leaves, so Mattias could
avoid missing filters very cleanly.

That would create some bloat of its own, namely in the bridge driver
this time, but in the longer term, I think the tc filters on the bridge
device itself may be interesting to more than one single offloading
driver, so the cost of this bloat may amortize.

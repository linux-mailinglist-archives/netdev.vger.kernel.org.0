Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6356564233
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiGBS5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiGBS46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:56:58 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD1ADF4A;
        Sat,  2 Jul 2022 11:56:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id d2so9676726ejy.1;
        Sat, 02 Jul 2022 11:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C7xyE5qz49wgabxWugJk/UHAJ0/y1arn6JSkY7GXrMI=;
        b=HfbVlPQTO2dcpcwowQNh/BTUSjTccUmtgkT66l1e32q0iqoqpaqtBHJMGBBwbuk6YF
         NRyh+7Rr7eabP3QYPXtTpjWfyczrlqX9FrMi3GVS40D3x3LFkr4x/PenKEPY7YC93JnR
         C4h6LaSHKQKuZaIw7KMRipYviBWLcPBAdZqwJ/6lnZjcUpdXMqNZTs4GxXy9gDli76aN
         1gt6EtS6Ysp7wxbdemuKD5yEVTUzdUALDzNRAZItv7MeYhCD7FhQsFo4hY6aOEP5ZTwI
         r+MPPBAyyE1x93EUk4t5Y8RUx41Zdmraxmhn0P7YwWYNBQXs3ZhRjsgA841AxOxGGwFd
         w/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C7xyE5qz49wgabxWugJk/UHAJ0/y1arn6JSkY7GXrMI=;
        b=3Q8sqh61s6DHnpKLVg5TssuYqAgJGPFZHCdz/uU4ry22+7TdkCkhIFQ49HgMFOfE1M
         5xno7h+y5WhyR0cgb9QhL5mQ4MGF3F8yOhmQp2uYPArJJCmVmIWIx4U7YzRGMj1C/w5u
         r7nLfvIcpHQq6pwDKY4o/X8Y5UlUfjabL3kITGc3qoLN9mJ0OTel2J/Ee/jJOsM6QZjG
         V1ulaoAxa63uf+TC+rA8MfDehdbqhNVlxVJakXaYx4/FzIhbslTezBzfwhuZidxwrIpO
         8ijt8INUsAnsBfJx2YLM2vMVglKeXBqEcNA5rkKD1g4LO6mY/60PRiw2r/+llOaZye/d
         t5Nw==
X-Gm-Message-State: AJIora9oTVrZgh3CahctbXZQAuLgrhN1YAFaC5h5wxHY/JkXFdJn/mss
        MYC8at/yqGOmVDTESQ7EXXM=
X-Google-Smtp-Source: AGRyM1tHa7950NQtwqeVMRvlGkAnRtTpjmnLonvbbyIrJ1o8Ak1GK1+drfNXvGldvsx1y4V8LrYJvw==
X-Received: by 2002:a17:907:86a7:b0:726:317f:aee0 with SMTP id qa39-20020a17090786a700b00726317faee0mr20495781ejc.229.1656788216191;
        Sat, 02 Jul 2022 11:56:56 -0700 (PDT)
Received: from skbuf ([188.25.231.173])
        by smtp.gmail.com with ESMTPSA id z4-20020a1709060f0400b00722f069fd40sm12054959eji.159.2022.07.02.11.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 11:56:54 -0700 (PDT)
Date:   Sat, 2 Jul 2022 21:56:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: lantiq_gswip: Fix FDB add/remove on the
 CPU port
Message-ID: <20220702185652.dpzrxuitacqp6m3t@skbuf>
References: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com>
 <20220701130157.bwepfw2oeco6teyv@skbuf>
 <CAFBinCDqgQ1WWWPmfXykeZPsiwLNu+fPg6nCN7TMNNR_JL3gxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCDqgQ1WWWPmfXykeZPsiwLNu+fPg6nCN7TMNNR_JL3gxQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 07:43:11PM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
> 
> On Fri, Jul 1, 2022 at 3:02 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> [...]
> > > Use FID 0 (which is also the "default" FID) when adding/removing an FDB
> > > entry for the CPU port.
> >
> > What does "default" FID even mean, and why is the default FID relevant?
> The GSW140 datasheet [0] (which is for a newer IP than the one we are
> targeting currently with the GSWIP driver - but I am not aware of any
> older datasheets)

Thanks for the document! Really useful.

> page 78 mentions: "By default the FID is zero and all entries belong
> to shared VLAN learning."

Not talking about the hardware defaults when it's obvious the driver
changes those, in an attempt to comply to Linux networking expectations...

> > In any case, I recommend you to first set up a test bench where you
> > actually see a difference between packets being flooded to the CPU vs
> > matching an FDB entry targeting it. Then read up a bit what the provided
> > dsa_db argument wants from port_fdb_add(). This conversation with Alvin
> > should explain a few things.
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/#24763870
> I previously asked Hauke whether the RX tag (net/dsa/tag_gswip.c) has
> some bit to indicate whether traffic is flooded - but to his knowledge
> the switch doesn't provide this information.

Yeah, you generally won't find quite that level of detail even in more
advanced switches. Not that you need it...

> So I am not sure what I can do in this case - do you have any pointers for me?

Yes, I do.

gswip_setup has:

	/* Default unknown Broadcast/Multicast/Unicast port maps */
	gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP1);
	gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP2);
	gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP3); <- replace BIT(cpu_port) with 0

If you can no longer ping, it means that flooding was how packets
reached the system.

It appears that what goes on is interesting.
The switch is configured to flood traffic that's unknown to the FDB only
to the CPU (notably not to other bridged ports).
In software, the packet reaches tag_gswip.c, where unlike the majority
of other DSA tagging protocols, we do not call dsa_default_offload_fwd_mark(skb).
Then, the packet reaches the software bridge, and the switch has
informed the bridge (via skb->offload_fwd_mark == 0) that the packet
hasn't been already flooded in hardware, so the software bridge needs to
do it (only if necessary, of course).

The software bridge floods the packet according to its own FDB. In your
case, the software bridge recognizes the MAC DA of the packet as being
equal to the MAC address of br0 itself, and so, it doesn't flood it,
just terminates it locally. This is true whether or not the switch
learned that address in its FDB on the CPU port.

> Also apologies if all of this is very obvious. So far I have only been
> working on the xMII part of Ethernet drivers, meaning: I am totally
> new to the FDB part.
> 
> > Then have a patch (set) lifting the "return -EINVAL" from gswip *properly*.
> > And only then do we get to ask the questions "how bad are things for
> > linux-5.18.y? how bad are they for linux-5.15.y? what do we need to do?".
> agreed
> 
> 
> Thanks again for your time and all these valuable hints Vladimir!
> Martin
> 
> 
> [0] https://assets.maxlinear.com/web/documents/617930_gsw140_ds_rev1.11.pdf

So if I'm right, the state of facts is quite "not broken" (quite the
other way around, I'm really impressed), although there are still
improvements to be made. Flooding could be offloaded to hardware, then
flooding to CPU could be turned off and controlled via port promiscuity.
This would save quite a few CPU cycles.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB12623CD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIIACR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIIACK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:02:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B5EC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:02:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so530226pff.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GigLJhzAPHf+0AoS+2YvoCEzUGexyq+DDHjIG8TsSf4=;
        b=BfUugi/BqpFotwNLxMJ0w+bxpxXJVySuysT29yo3PwXBTEsYoeMLeHffcR4fA8cZFF
         zmR935IjJqdsowMpoZj8yUnpm8+Wr3DVdL6WinXdT5ZFLR92L2fUm9yPk+hbn43LjPKD
         P3oM1ZMqjxjXrsv/gaQpD0Ry7kvlYvbjjhEmZhYUpysGLUJ5Mjub566mCfndx4npGBxm
         Tz/xZ61w2ZGZiaZn1jiQw90xoocBP+jnswGXuTfwvVfGF112N0lJZ3JMUSmayD7EJKMu
         oVXmzvMeZzJ+UDSC1SxwZhfbuP9EFJ/esRviOfpaqHytxaEv4qDZssxPvl8r3i/XZney
         +zgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GigLJhzAPHf+0AoS+2YvoCEzUGexyq+DDHjIG8TsSf4=;
        b=HuEtOb0Zx3C6yfXebFEJgv33haKg43sdL3t5UEpEYV0OyIQB73nP8YHSZn6T+Hav5s
         FsaFeEd991qgd3d9KLaAiWV15IJE7eDEHh+aGTz4btvLUv+lg5AD4GPoXxib53oujkUm
         LtSN6JCvMDG38TaEYQ67FdUVjeAzBirgcHsrTEke6BkMfZDZwUzn08A79daF52C8kulv
         XxANav2NjOcmw84QgW1swI8X4WDuP4KFl+eqPkFerA1eqUwR7BjUf4byF4MfXcpmQnhv
         fws3Kvkujsjc5i+4JY0nUl0akpMJ77L56HIqp07XSdNYifE/JEZBiBshYd1U93V1/pUZ
         ct9w==
X-Gm-Message-State: AOAM531uNQb0MKPHNrvsfdpGkMzPn6fkunMP6kqzpBGvy80YcNMQrF1h
        IW2G4FGJ8YDVwbp+fPGmp5mox7AaYTo=
X-Google-Smtp-Source: ABdhPJzE43eOy6w42vaEL9VHBGB8LLBmvHkOJXPwNbd2JzUgtiyXu17YboHzueeaIkSo+UplEkOcCQ==
X-Received: by 2002:a17:902:a706:b029:d0:89f3:28c9 with SMTP id w6-20020a170902a706b02900d089f328c9mr1386355plq.5.1599609728820;
        Tue, 08 Sep 2020 17:02:08 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x29sm348150pga.23.2020.09.08.17.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 17:02:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
 <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
Date:   Tue, 8 Sep 2020 17:02:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2020 3:28 PM, Florian Fainelli wrote:
> 
> 
> On 9/7/2020 9:07 PM, Florian Fainelli wrote:
>>
>>
>> On 9/7/2020 11:29 AM, Vladimir Oltean wrote:
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
>>> drivers to always receive bridge VLANs"), DSA has historically been
>>> skipping VLAN switchdev operations when the bridge wasn't in
>>> vlan_filtering mode, but the reason why it was doing that has never been
>>> clear. So the configure_vlan_while_not_filtering option is there merely
>>> to preserve functionality for existing drivers. It isn't some behavior
>>> that drivers should opt into. Ideally, when all drivers leave this flag
>>> set, we can delete the dsa_port_skip_vlan_configuration() function.
>>>
>>> New drivers always seem to omit setting this flag, for some reason. So
>>> let's reverse the logic: the DSA core sets it by default to true before
>>> the .setup() callback, and legacy drivers can turn it off. This way, new
>>> drivers get the new behavior by default, unless they explicitly set the
>>> flag to false, which is more obvious during review.
>>>
>>> Remove the assignment from drivers which were setting it to true, and
>>> add the assignment to false for the drivers that didn't previously have
>>> it. This way, it should be easier to see how many we have left.
>>>
>>> The following drivers: lan9303, mv88e6060 were skipped from setting this
>>> flag to false, because they didn't have any VLAN offload ops in the
>>> first place.
>>>
>>> Also, print a message to the console every time a VLAN has been skipped.
>>> This is mildly annoying on purpose, so that (a) it is at least clear
>>> that VLANs are being skipped - the legacy behavior in itself is
>>> confusing - and (b) people have one more incentive to convert to the new
>>> behavior.
>>>
>>> No behavior change except for the added prints is intended at this time.
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> You should be able to make b53 and bcm_sf2 also use 
>> configure_vlan_while_not_filtering to true (or rather not specify it), 
>> give me until tomorrow to run various tests if you don't mind.
> 
> For a reason I do not understand, we should be able to set 
> configure_vlan_while_not_filtering to true, and get things to work, 
> however this does not work for bridged ports unless the bridge also 
> happens to have VLAN filtering enabled. There is a valid VLAN entry 
> configured for the desired port, but nothing ingress or egresses, I will 
> keep debugging but you can send this patch as-is I believe and I will 
> amend b53 later once I understand what is going on.

Found the problem, we do not allow the CPU port to be configured as 
untagged, and when we toggle vlan_filtering we actually incorrectly 
"move" the PVID from 1 to 0, which is incorrect, but since the CPU is 
also untagged in VID 0 this is why it "works" or rather two mistakes 
canceling it each other.

I still need to confirm this, but the bridge in VLAN filtering mode 
seems to support receiving frames with the default_pvid as tagged, and 
it will untag it for the bridge master device transparently.

The reason for not allowing the CPU port to be untagged 
(ca8931948344c485569b04821d1f6bcebccd376b) was because the CPU port 
could be added as untagged in several VLANs, e.g.: when port0-3 are PVID 
1 untagged, and port 4 is PVID 2 untagged. Back then there was no 
support for Broadcom tags, so the only way to differentiate traffic 
properly was to also add a pair of tagged VIDs to the DSA master.

I am still trying to remember whether there were other concerns that 
prompted me to make that change and would appreciate some thoughts on 
that. Tangentially, maybe we should finally add support for programming 
the CPU port's VLAN membership independently from the other ports.

The following appears to work nicely now and allows us to get rid of the 
b53_vlan_filtering() logic, which would no longer work now because it 
assumed that toggling vlan_filtering implied that there would be no VLAN 
configuration when filtering was off.

diff --git a/drivers/net/dsa/b53/b53_common.c 
b/drivers/net/dsa/b53/b53_common.c
index 26fcff85d881..fac033730f4a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1322,23 +1322,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
  int b53_vlan_filtering(struct dsa_switch *ds, int port, bool 
vlan_filtering)
  {
         struct b53_device *dev = ds->priv;
-       u16 pvid, new_pvid;
-
-       b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
-       if (!vlan_filtering) {
-               /* Filtering is currently enabled, use the default PVID 
since
-                * the bridge does not expect tagging anymore
-                */
-               dev->ports[port].pvid = pvid;
-               new_pvid = b53_default_pvid(dev);
-       } else {
-               /* Filtering is currently disabled, restore the previous 
PVID */
-               new_pvid = dev->ports[port].pvid;
-       }
-
-       if (pvid != new_pvid)
-               b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
-                           new_pvid);

         b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);

@@ -1389,7 +1372,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
                         untagged = true;

                 vl->members |= BIT(port);
-               if (untagged && !dsa_is_cpu_port(ds, port))
+               if (untagged)
                         vl->untag |= BIT(port);
                 else
                         vl->untag &= ~BIT(port);
@@ -1427,7 +1410,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
                 if (pvid == vid)
                         pvid = b53_default_pvid(dev);

-               if (untagged && !dsa_is_cpu_port(ds, port))
+               if (untagged)
                         vl->untag &= ~(BIT(port));

                 b53_set_vlan_entry(dev, vid, vl);
@@ -2563,6 +2546,8 @@ struct b53_device *b53_switch_alloc(struct device 
*base,
         dev->priv = priv;
         dev->ops = ops;
         ds->ops = &b53_switch_ops;
+       ds->configure_vlan_while_not_filtering = true;
+       dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
         mutex_init(&dev->reg_mutex);
         mutex_init(&dev->stats_mutex);


-- 
Florian

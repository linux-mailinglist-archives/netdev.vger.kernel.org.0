Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE8C348B14
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhCYIEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCYIEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:04:05 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CF3C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 01:04:04 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id q29so1192892lfb.4
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 01:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BLM9RBVaDjv91npDOqFDmADhoFS0gfEgEmOc4WLb1p4=;
        b=RhDzLJEnSvomh5MVdiv5YSjhaJs50134j+na7zcfSgGBeAOxZRjCSgmsD/pxbV/dui
         o59p+g69AzWkUVxzT/CHPgjYYOlWX17Y3jzAryiShd2Crj9bz7nGFXGiNlKfWO5LeeIb
         itFtm+D0bXsjX3TgeN0/BFm5yj1KJScAVBJnivCcFmheeY2EEomksy9w63XK2ZcHLRU4
         3fTuWUt8LhIl/gkDv/kTJRiWSGI/avRZVKM73aRabfPHcDlfuXDBjx+52KoG3uTcv8Fl
         V7yQTu9NpEl9SODXQLz02zFK5v5gk+Ljz6hqJqQkmwsIExohzgH/+BFkx3a05OZssbTf
         lz1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BLM9RBVaDjv91npDOqFDmADhoFS0gfEgEmOc4WLb1p4=;
        b=hQMv0JRsugDJlicc+KqGwgd9sRT5GdE1gjOSQvlnoVA4OsHsAtVWLYo2qEg2Q0tTt5
         IXw0l/HfcP8im8OvWha1dS/h/nUGU82lkX4JyWKebds/mFHLLpwk8w6yQmKN0KG3ajrd
         ta/xoL1JhA148wEXBzpFOTcTgp+oqlj16ydek7kBjh6DD5VGfsomWU9l/DKvPaW6xJ8Y
         /xtwpm5lCODx0GH3TG/4hOjZ/SZgzAGBPTeLOxfdaISlXNlN08SCLKW1ovXjegk4V0nU
         NZdxJqH+yBiQImA/QY3mSOCfysWLvyms5D2fKK6UcHXdNEmWM7X2biL3V+nRFMHh17GO
         1Bgg==
X-Gm-Message-State: AOAM533dXXrQgQh5wyCPEcc7aXaw2Kvh9+r4v9BP9gacKgowzvPygh3E
        c/G8rIbYt8GOzYXwtdJ3NXnsKzS7WrTPHqD3
X-Google-Smtp-Source: ABdhPJzcqO19KeTgX+6TBpp5wZsjnCpbdQfKde5MtnlJ/tlisdij2DAcZ1iDBXfyHn7lcLNC9QSyvg==
X-Received: by 2002:ac2:5221:: with SMTP id i1mr4366671lfl.160.1616659442558;
        Thu, 25 Mar 2021 01:04:02 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q3sm452418lfr.33.2021.03.25.01.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 01:04:02 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <20210325013432.muugsogq4mzmalpd@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <20210323113522.coidmitlt6e44jjq@skbuf> <87blbalycs.fsf@waldekranz.com> <20210323190302.2v7ianeuwylxdqjl@skbuf> <8735wlmuxh.fsf@waldekranz.com> <20210324140317.amzmmngh5lwkcfm4@skbuf> <87pmzolhlv.fsf@waldekranz.com> <20210324150807.f2amekt2jdcvqhhl@skbuf> <87mtuslemq.fsf@waldekranz.com> <20210325013432.muugsogq4mzmalpd@skbuf>
Date:   Thu, 25 Mar 2021 09:04:01 +0100
Message-ID: <87k0pvlkwe.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 03:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 24, 2021 at 05:07:09PM +0100, Tobias Waldekranz wrote:
>> But even if the parser was enabled, it would never get anywhere since
>> the Ethertype would look like random garbage. Unless we have the soft
>> parser, but then it is not the middle ground anymore :)
>
> Garbage, true, but garbage with enough entropy to allow for some sort of
> RFS (ideally you can get the source port field from the DSA tag into the
> area covered by the n-tuple on which the master performs hashing). This
> is the way in which the switches inside NXP LS1028A and T1040 work.

I see what you are saying. Any given flow would still have the same
not-really-an-Ethertype.

>> I suppose you would like to test for netdev_uses_dsa_and_violates_8023,
>> that way you could still do RSS on DSA devices using regular 1Q-tags for
>> example. Do we want to add this property to the taggers so that we do
>> not degrade performance for any existing users?
>
> Yes, so T1040 is one such example of device that would be negatively
> affected by this change. There isn't a good solution to solve all
> problems: there will be some Marvell switches which can't operate in
> EDSA mode, and there will be some DSA masters that can't parse Marvell
> DSA tags. Eventually all possible combinations of workarounds will have
> to be implemented. But for now, I think I prefer to see the simplest
> one, which has just become the one based on device tree.

Alright, it seems like everyone agrees then. I will look into it.

Just to avoid a DenverCoder9 situation; I tried changing the NIA in
FMBM_RFNE like you suggested:

8< ---

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0dbc7d..5aa5b4068f2d 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -543,7 +543,7 @@ static int init_bmi_rx(struct fman_port *port)
        /* NIA */
        tmp = (u32)cfg->rx_fd_bits << BMI_NEXT_ENG_FD_BITS_SHIFT;
 
-       tmp |= NIA_ENG_HWP;
+       tmp |= NIA_ENG_BMI | NIA_BMI_AC_ENQ_FRAME;
        iowrite32be(tmp, &regs->fmbm_rfne);
 
        /* Parser Next Engine NIA */

8< ---

From what I can tell, this works as expected. TO_CPUs from port 8 can
ingress the device with this in place.

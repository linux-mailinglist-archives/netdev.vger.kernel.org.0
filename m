Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF326B3A15
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjCJJRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjCJJQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:16:50 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD74810A4C5
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:12:48 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id a25so17923314edb.0
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678439567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pjcXuowgUyMOBLnLTA21tm2nqSB7fIIrIYaLB8x9XL0=;
        b=aTSRBBDlantGy8zPzrYswWWH2/Fi7uMOtJgriIgRH2oGgtB6MhneU76vobugKpxofe
         RIjTAMO2177HVf26fzf/RZCo2R5UzkVHBIiMhdQsvy8SBqE0O+luuHkaucNZtgl7XofG
         9pvM8ecXikBaOI1MLejQaveYVZ4k+AXiHWk0O6SW5pyZHyR/A4FPThMQeRFd9RDSx0y1
         ZWHXvl2949dZ24hC2LBZCkTz+oOq864jwNPGVuPohpAERaqC5gaLQ/f+p0/a+ubndVY0
         mwnFRtgqmzHkWUioxDnfXVAK43DlEOs7c6ZaIXgJJCwT1UFjfXyHX8cO2bBtDL3C1MPA
         7AIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678439567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjcXuowgUyMOBLnLTA21tm2nqSB7fIIrIYaLB8x9XL0=;
        b=nR6wxVFR+GGRYjbEpBQk4GSRufBv86m2JozMfm6S9jjdGIq5upcIjgo/wm8Zkl3IAD
         tN2ECNK4bJacFZtfnS3i6/2GvSydrZQRZ3eu9AfDMjz1ZHZfmFaGbx+Beg6lCD/gljZt
         ZZuJ+yH2qtOpcWEeGQ+FZq5tMlOIiHIRK1yYpzW7bGPAGY0+tGEFWsmroqqEEEl4GOHN
         YedTxGgpkK71RDd9Jg2UjeGE4rHEKe8Nt6PJXppg79MbL3eEWG+BOmGTcZcK5ximoXF1
         CE5hnLh92U1lJa1IOEDiJq3e9tPkiO/mKpR7Nkj3wj2/lD4Q1Ou63voRtOCmVkAVvluX
         bxXQ==
X-Gm-Message-State: AO0yUKWmRPZDPGt6Rcn7WkacIgPs0vxajkcIQk3BQNjq7KOxuuMk7BqU
        +8HYSMEVt/KX7zL+uFhOh8s=
X-Google-Smtp-Source: AK7set8h8vebVyM/Zcq7WWiJLyBXxHVf8v4oS+BwF/zzv3w4VU+BPrqNwnCUQeyrBoc7+0INFi2T6Q==
X-Received: by 2002:a17:907:8d02:b0:8ee:babc:d40b with SMTP id tc2-20020a1709078d0200b008eebabcd40bmr26020810ejc.58.1678439567086;
        Fri, 10 Mar 2023 01:12:47 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o11-20020a170906358b00b008e938e98046sm695441ejb.223.2023.03.10.01.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:12:46 -0800 (PST)
Date:   Fri, 10 Mar 2023 11:12:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Qingtao Cao <qingtao.cao.au@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Question: DSA on Marvell 6390R switch dropping EAPOL packets
 with unicast MAC DA
Message-ID: <20230310091244.hwjhu52u5d7nvkph@skbuf>
References: <CAPcThSFCN7mKP2_ZhqJi9-nGNTYmV5uB23aToAudodZDEnunoA@mail.gmail.com>
 <20230309110639.lvbhzexnim7vrkwx@skbuf>
 <CAPcThSH0Lp7ZNp4rhce3tFCjqPUZSuuySBFwv4sVvHKHFmy77Q@mail.gmail.com>
 <20230309131601.wxfsfo2dbfyj3ybe@skbuf>
 <20230309142103.dg4qfksz4k2itotd@skbuf>
 <CAPcThSECEBMN0X869GhBWnTpePKRx_SPCZTv66VrPNaWpHmCxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcThSECEBMN0X869GhBWnTpePKRx_SPCZTv66VrPNaWpHmCxg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harry

On Fri, Mar 10, 2023 at 08:34:12AM +1000, Qingtao Cao wrote:
> Hi Vladimir,
> 
> Yes, yes, yes!

Please resolve your problems with top-posting style and plain text
emails pointed out earlier. This reply did not make it to the mailing
list either, AFAICS.

> 
> The net2p9 along with all other ports are under a bridge (eth2) on my box,
> which is setup by a script using ip and brctl command after reboot.
> 
> My box previously supports a kernel configuration without any DSA driver
> enabled, so all those marvell 6390r switches work as a "dumb" one: their
> backend is the intel i210 and switch ports just act as its PHYs, so they
> are used as a normal home network switch.
> 
> Whereas the new configuration enables kernel DSA and driver, the physical
> interface eth2 was renamed to eth2cpu and a bridge interface named eth2 was

it's slightly unconventional to name a bridge interface "eth2", but okay...

> created to enslave all switch ports. From brctl showstp command, I could
> see the net2p9 had entered all the way to the forwarding state when I
> kicked off the wpa_supplicant on it.

the modern command for that would be "bridge link", but okay

> 
> Of course, I would try the ebtables command first things first in the
> morning today!
> 
> If it works, then I would have more questions, such as:
> 1. is the bridge layer RX handler involved just because net2p9 is enslaved
> to a bridge? (although wpa_supplicant was not operating on the bridge
> interface)

yes

> 2. if yes, then running wpa_supplicant against the net2p9 before creation
> of the bridge, would this prevent the bridge RX handler from stealing the
> packet?

yes

> 3. if still yes, then perhaps I could run the wpa_supplicant before setting
> up the bridge, so that the d-link switch port could still be authorized and
> all the rest DSA switch ports could still share the same uplink via net2p9

that's a question for you to answer

doesn't the port need reauthorization from time to time? if it does, do
you plan to temporarily remove it from the bridge and add it back?

> 4. if yes again, would the bridge RX handler steal other protocols than
> EAPOL?

the source code of br_handle_frame() that it steals *all* packets except
for a select few, namely packets sent to the reserved link-local multicast
range (01-80-c2-00-00-xx).

> how would we come up with a more generalized solution to prevent
> this from happening?

You'd need to talk to the bridge maintainers about this. Currently,
stealing is avoided for frames for which the frame_handler() of their
protocol added via br_add_frame() (currently MRP and CFM) returns an
error. I suppose this mechanism could be extended/abused to add new
protocols which the bridge should always know it should never steal:
their frame_handler() identifies them and returns an error.

However the list is bound to get quite large (PTP over IP needs this too)
https://lore.kernel.org/netdev/871r3gbdxv.fsf@kurt/
and not all bridge users need all rules, but if the rules get built-in,
then all users need to suffer the performance penalty associated with
the frame_type lookups. So I guess this is why we have the netfilter
based system. I would expect some pushback from bridge maintainers, but
I guess it's worth a shot.

> 
> BTW, running wpa_supplicant on the bridge interface doesn't work, just
> because of EAPOL Start packet with that multicast address as MAC DA will be
> dropped by the bridge since STP has been enabled on it.

I didn't suggest that you run wpa_supplicant on the bridge interface.
I wasn't expecting it to work.

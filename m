Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49772E027B
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgLUW0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUW0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:26:17 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50859C0613D6;
        Mon, 21 Dec 2020 14:25:37 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id dk8so11142639edb.1;
        Mon, 21 Dec 2020 14:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6lNTKSuS3VqpcSa/CTPY27q/5iitGsEsvvKQc7I5n2w=;
        b=NdA3rT0PUrDC9akyDO+o4y2HBqwn6xnbsWE2P1ljtRSIfSuodNLHoWKCXp8xrVPXK0
         1wVQIx959aTaIjVEBE8XzK5E5WaT8bSguPXElyRZNPF2rqkc93pTa098BuZp/8dljCSL
         wPCxxExWSv9hwW+7fyIDH2X6AQUsR6BZ2AKCxsFwuQ0rW5xfCaOLexXSHWAoBCUn9WBJ
         k25Oc9tFGAJXWhR8dya4fiaQwWrmOEhJ6aVJJtykXCDjXCxv86DbPzzDDNALgOgH0Dwu
         d54lqDjLS/32+61J7AEjLUB8ff73Ed/lHtolXLsHBoSXx5EDhey1VXrfGcECcmozhwtb
         dhrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6lNTKSuS3VqpcSa/CTPY27q/5iitGsEsvvKQc7I5n2w=;
        b=JJox9SXX9UlbIPm/Xdxz3wfQmqSeOIjWqT+Kx3fQh0LEoXO1yYc0KPPNGy/UWh7NCM
         IxbiFiJbHZFfHONqs7wkRQAwt37PmQ9a8+fpa+haPj9lApEwPSRH9XKmmuJ7lCNcvLWr
         mr4nDN4I1n2/CG6rm3DvHcNwTPXsEmYzF+CXRacp/Qyp8NWSMUkk99nF1bJvl1M1nYKF
         89CDEb70PisbpjP1nEg/V2NlMWi57gcV7eZx0mZ49X6zNl58Z5d2pZPxp/D2z5AiMuk/
         2xZBs3fNeJLvE61dCR8qx+5wjKDvD0yVSHs6fhNxFjaQd6Se51b8kexDNPxrBgaZ9Ygt
         VuBw==
X-Gm-Message-State: AOAM531H1usFN6TxvhzkzwCxxGvgLr88TCT+wtZ/Pkl+1AOPvmv9mM1H
        WoS0QDhCywwkLxqoRukSXoQ=
X-Google-Smtp-Source: ABdhPJy85PiYMitI9XBh7zpqSE0bayChQF8Lrnat0DAXajI0G5aFdzj8ekv2eM/WKEwKKVFzqbnEog==
X-Received: by 2002:a50:ee8e:: with SMTP id f14mr17486909edr.176.1608589536003;
        Mon, 21 Dec 2020 14:25:36 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id s1sm9674394ejx.25.2020.12.21.14.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 14:25:35 -0800 (PST)
Date:   Tue, 22 Dec 2020 00:25:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: systemport: set dev->max_mtu to
 UMAC_MAX_MTU_SIZE
Message-ID: <20201221222534.ln4onsjpryqzzfqq@skbuf>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
 <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
 <20201218205220.jb3kh7v23gtpymmx@skbuf>
 <b8e61c3f-179f-7d8f-782a-86a8c69c5a75@gmail.com>
 <20201218210250.owahylqnagtssbsw@skbuf>
 <cf2daa3c-8f64-0f58-5a42-2182cec5ba4a@gmail.com>
 <20201218211435.mjdknhltolu4gvqr@skbuf>
 <f558368a-ec7f-c604-9be5-bd5b810b5bfa@gmail.com>
 <6d54c372-86bc-b28f-00b0-c22e46215116@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d54c372-86bc-b28f-00b0-c22e46215116@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 01:49:03PM -0800, Florian Fainelli wrote:
> On 12/18/2020 1:17 PM, Florian Fainelli wrote:
> >>>>>>> SYSTEMPORT Lite does not actually validate the frame length, so setting
> >>>>>>> a maximum number to the buffer size we allocate could work, but I don't
> >>>>>>> see a reason to differentiate the two types of MACs here.
> >>>>>>
> >>>>>> And if the Lite doesn't validate the frame length, then shouldn't it
> >>>>>> report a max_mtu equal to the max_mtu of the attached DSA switch, plus
> >>>>>> the Broadcom tag length? Doesn't the b53 driver support jumbo frames?
> >>>>>
> >>>>> And how would I do that without create a horrible layering violation in
> >>>>> either the systemport driver or DSA? Yes the b53 driver supports jumbo
> >>>>> frames.
> >>>>
> >>>> Sorry, I don't understand where is the layering violation (maybe it doesn't
> >>>> help me either that I'm not familiar with Broadcom architectures).
> >>>>
> >>>> Is the SYSTEMPORT Lite always used as a DSA master, or could it also be
> >>>> used standalone? What would be the issue with hardcoding a max_mtu value
> >>>> which is large enough for b53 to use jumbo frames?
> >>>
> >>> SYSTEMPORT Lite is always used as a DSA master AFAICT given its GMII
> >>> Integration Block (GIB) was specifically designed with another MAC and
> >>> particularly that of a switch on the other side.
> >>>
> >>> The layering violation I am concerned with is that we do not know ahead
> >>> of time which b53 switch we are going to be interfaced with, and they
> >>> have various limitations on the sizes they support. Right now b53 only
> >>> concerns itself with returning JMS_MAX_SIZE, but I am fairly positive
> >>> this needs fixing given the existing switches supported by the driver.
> >>
> >> Maybe we don't need to over-engineer this. As long as you report a large
> >> enough max_mtu in the SYSTEMPORT Lite driver to accomodate for all
> >> possible revisions of embedded switches, and the max_mtu of the switch
> >> itself is still accurate and representative of the switch revision limits,
> >> I think that's good enough.
> >
> > I suppose that is fair, v2 coming, thanks!
>
> I was going to issue a v2 for this patch, but given that we don't
> allocate buffers larger than 2KiB and there is really no need to
> implement ndo_change_mtu(), is there really a point not to use
> UMAC_MAX_MTU_SIZE for both variants of the SYSTEMPORT MAC?

After your first reply that "the Lite doesn't validate the frame length", I was
under the impression that it is sufficient to declare a larger max_mtu such as
JMS_MAX_SIZE and 9K jumbo frames would just work. But with the current buffer
allocation in bcm_sysport_rx_refill it clearly wouldn't. A stupid confusion
really. So yeah, sorry for having you resend a v2 with no change.
If it helps you could add to the patch:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks again for explaining.

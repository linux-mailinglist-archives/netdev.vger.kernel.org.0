Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754ED42DF12
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJNQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhJNQ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:26:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DFDC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:23:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so5139159pjb.3
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=IGI5fR7VnikgYGVlf5PjT1UZlv/9yl+wcjA9DYbaNn4=;
        b=IddHURL28IWfjbkK84aQQBHVDAzfTzIFC/0JMZSKh6SFM6XtKruslMOVyocpUdwT0F
         PTduLji2fFMMnze3yJEPv1V61pteDZsO22mk8Qr1rsKHHacYnYvyZajXsdr9hBzReEnB
         Ph+EdUiZ4Ra//OGRT6UNkkrYV66hVIXMQm0I2ZAr87r0Na+aM93qOuhC0pu8kbJLUfA2
         pQd/p1iVsWJNJHWxb99FVDciWe+3M+rR2dqPzxMdUHv6lgwWDq4OAA8untEWkPpVPKB9
         2BDr8VtL+R3tVqOg1mTv5f7GxdkFLZwB1NdzZPMSHq9ivkmH8xG99ewpSJQ7TnQ6yDWL
         NA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IGI5fR7VnikgYGVlf5PjT1UZlv/9yl+wcjA9DYbaNn4=;
        b=Cr7YAM1NKduapBJ1oU0F5GcmLrHl9Ulj8T4qrXVbAvB4mk/SHO60ZL1nhKiKvROWS5
         hEnVGCnNc1r4e17LDWBACdHfGEeJj2d41M4F4skgVJuE0NZ+/XaE02UrN5hfvxO7rm/7
         +kxtDKTzwPRjdvud2crhwtRuvo0HkLuTidZ3Jpk9gGhlAGHHMI22iYrnQ8NCtudfTfX2
         fdmeUP6O3ktANdWLjbbNAQ/9RlB6M+Kz3pzi9vmPfcDjP1ijIfz6VTcAwhnhGd5iHmuQ
         zBTI+nfO2y38olFkp9FkqGnmXiB//KNgaa31D/HT/2b1OPhXuoS135AanEUbDuYURQob
         tcwg==
X-Gm-Message-State: AOAM5309rckc7UUOY7dH9xQ0l2kpXVhwokoYIaQy8Ud7fOHcYSX3AGnk
        WQCQ0jZkuUj09E5FHJ3kh+g=
X-Google-Smtp-Source: ABdhPJyrf8ZQT/nLW5LiHtFFmuggB2p1dz8TbJECXUOTISt68rKV1weaEcwAgJxwBFbIpckDxPSC3Q==
X-Received: by 2002:a17:90b:1e4b:: with SMTP id pi11mr7303301pjb.179.1634228636276;
        Thu, 14 Oct 2021 09:23:56 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id a11sm2789197pgj.75.2021.10.14.09.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 09:23:55 -0700 (PDT)
Message-ID: <39983085fd56096fbf7434976fc2c639f6ef1155.camel@gmail.com>
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
From:   James Prestwood <prestwoj@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, dsahern@kernel.org,
        idosch@idosch.org
Date:   Thu, 14 Oct 2021 09:20:39 -0700
In-Reply-To: <d935a56e-39b6-70be-16a8-313282c3e6c4@iogearbox.net>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
         <d935a56e-39b6-70be-16a8-313282c3e6c4@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Thu, 2021-10-14 at 10:30 +0200, Daniel Borkmann wrote:
> [ Adding few more to Cc ]
> 
> On 10/14/21 12:27 AM, James Prestwood wrote:
> > This change introduces a new sysctl parameter, arp_evict_nocarrier.
> > When set (default) the ARP cache will be cleared on a NOCARRIER
> > event.
> > This new option has been defaulted to '1' which maintains existing
> > behavior.
> > 
> > Clearing the ARP cache on NOCARRIER is relatively new, introduced
> > by:
> > 
> > commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> > Author: David Ahern <dsahern@gmail.com>
> > Date:   Thu Oct 11 20:33:49 2018 -0700
> > 
> >      net: Evict neighbor entries on carrier down
> > 
> > The reason for this changes is to prevent the ARP cache from being
> > cleared when a wireless device roams. Specifically for wireless
> > roams
> > the ARP cache should not be cleared because the underlying network
> > has not
> > changed. Clearing the ARP cache in this case can introduce
> > significant
> > delays sending out packets after a roam.
> > 
> > A user reported such a situation here:
> > 
> > https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/
> > 
> > After some investigation it was found that the kernel was holding
> > onto
> > packets until ARP finished which resulted in this 1 second delay.
> > It
> > was also found that the first ARP who-has was never responded to,
> > which is actually what caues the delay. This change is more or less
> > working around this behavior, but again, there is no reason to
> > clear
> > the cache on a roam anyways.
> > 
> > As for the unanswered who-has, we know the packet made it OTA since
> > it was seen while monitoring. Why it never received a response is
> > unknown.
> 
> Wouldn't it make more sense to extend neigh_flush_dev() where we skip
> eviction
> of NUD_PERMANENT (see the skip_perm condition)? Either as a per table
> setting
> (tbl->parms) or as a NTF_EXT_* flag for specific neighbors?
> 

This is all new code to me, but from what I can tell NUD_PERMANENT is a
per-neighbor thing, which a wireless supplicant shouldn't be expected
to manage. It also seems like a pain to mark all neighbors as permanent
prior to a roam, then undo it all after a roam.

As for table settings I'll need to look into those, and if/how you
expose them to userspace? I modeled both these (arp/ndisc) options
after the other arp_*/ndisc_* sysctl parameters, as they seemed to fit
in there.

Thanks,
James

> 


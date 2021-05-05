Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD45E373F4B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhEEQNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbhEEQNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 12:13:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5836C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 09:12:19 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b17so2751238ede.0
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 09:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lq9QE1KWIofg068mXEEQMoq14pdbbzqQ04CPhXSEQps=;
        b=hRJnetFs62TeujbYBDE2pth8Qcemr6044enw4ZiwWQSnwLcsEIbkJvE2swMsi5vQwJ
         0Hci1+s9GQt+QGGAJ0gzHrUvHKG31CjTBPvkswpALm4Y+OM4MaL3QQvaBhDe1r5nghO6
         OXNgudZBE5i0kOiba1KP4zQKDjn1agdvVHeGIK2moRu9T6P7DzXMK9pp0XgsEpwRiHOV
         uJBqrtg8GgaGWzCMss3uRkEqJz7OxfJI2Ui/v/LTAA/QwvAa4qTB0JqxXvs14cBDXq2j
         f93So6dKRWCPZJmtAXL9QOBN2MkfyDi05lvCU6PieqBGlDTGrTr2AeJtagbk/6bxLJnB
         v++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lq9QE1KWIofg068mXEEQMoq14pdbbzqQ04CPhXSEQps=;
        b=T6PUet/aWvB6wf91PvBdU7erVwLcyvhO0uZkaDwwIvDWUWx15X8K5DHqjtRyLti8xF
         L6G19bdtexPmJjC1rrMFQVUEfSDQHeKIOO0u7wStFDXap9OLMaE7e5wqFVNPKOsQ81hi
         pVVtra8LlEvHrLDYW/MjgTNTto+b9oA55YwXk3zIzL6VFo/PRJL9PN5fFtJiaYEWC8eV
         LKOkn23u8DDztZMNIZ8lJ/+gmVzEtstJa8Kc1G/L+M+8y1coDZFo5EYdfxwb0RiSVzeS
         Nvytu5tiGA+ePEcnWA6RRD8oOwlTPwZROXU8qu09n1iGbpDTwmOGczABvOVzuF0qMyO8
         z+jA==
X-Gm-Message-State: AOAM5336/DyQxJSAqsJaD80UF59p9AVLRDsDh3/AjwO5pQe6NFlvzQxY
        VrCPVnJ1cauhMWT24f1R8VzuLso3pfY=
X-Google-Smtp-Source: ABdhPJzZz53cNeXNVEG354mzxC0kYFBwSxERf9piLtGD2n6tvxrBtBDh8cGI0zsDZ2KGo/6+1P8WFw==
X-Received: by 2002:a50:fc87:: with SMTP id f7mr32792166edq.215.1620231138408;
        Wed, 05 May 2021 09:12:18 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id i19sm3057110ejd.114.2021.05.05.09.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 09:12:16 -0700 (PDT)
Date:   Wed, 5 May 2021 19:12:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
Message-ID: <20210505161215.xljue7z525znuf3y@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-7-tobias@waldekranz.com>
 <20210427101747.n3y6w6o7thl5cz3r@skbuf>
 <878s4uo8xc.fsf@waldekranz.com>
 <20210504152106.oppawchuruapg4sb@skbuf>
 <874kfintzh.fsf@waldekranz.com>
 <20210504205823.j5wg547lgyw776rl@skbuf>
 <87y2cum9mo.fsf@waldekranz.com>
 <20210504230409.kohxoc4cl7sjpkrg@skbuf>
 <87pmy5mu5m.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmy5mu5m.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 11:01:09AM +0200, Tobias Waldekranz wrote:
> On Wed, May 05, 2021 at 02:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Wed, May 05, 2021 at 12:12:15AM +0200, Tobias Waldekranz wrote:
> >> > and you create a dependency between the tagger and the switch driver
> >> > which was supposed by design to not exist.
> >> 
> >> Sure, but _why_ should it not exist? Many fields in the tag can only be
> >> correctly generated/interpreted in combination with knowledge of the
> >> current configuration, which is the driver's domain. The dependency is
> >> already there, etched in silicon.
> >
> > I'm a bit more of a pragmatic person,
> 
> Excuse me sir, I believe you left your dagger IN MY HEART :)

You might have misinterpreted my words, I did not mean to say "look what
a good quality I have and you don't", in fact I don't view pragmatism as
much of a desirable quality at all. What I meant to say in the context
is that, even though in general I value functionality more than how it
is implemented, I would still like to keep the separation between
taggers and switch drivers at least at the most basic RX/TX level, for
the reasons explained.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9551B3CFBEE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhGTNlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbhGTNhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:37:25 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B9BC0613DC;
        Tue, 20 Jul 2021 07:16:19 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f30so36075807lfj.1;
        Tue, 20 Jul 2021 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jTVBIBA0omypH2FRgKNKE6Qelif7GcHlqISFRiezRVk=;
        b=YvVakOre3y2udFxIyMgAmHOWsU8OUb44tgzp478SYH416Z6U6CbQt1m6fjJYHkvSFN
         k+l48gpQYsxhlbHXI2FQmuYdGXRScLsZKXP0sfGbXDQy9U8d1kO47Ls3Tpy8/bA8KYj9
         ZK9gcADyx523yaINdbRSAXTzxVIV5Lu2vLMmAEJ9X640NZN1omkuC5hJDoVUSYzUiUQq
         FV1OvbyAAcBwsK20s5u5bHKZgeoxXGdiE9kvz4ecl4UNPxa/FEWHUwAKdv7KD0l9rerZ
         8rtoM/3mrUYsAmx3rGx+3Sn+oPJ0rcW2YiGFjmtqB7IXx1vrzC27Zib/SQMhGjmIg/fx
         JTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jTVBIBA0omypH2FRgKNKE6Qelif7GcHlqISFRiezRVk=;
        b=uKbQVDOfvwJwjWrdtNMrmbbRIXg+5mQg+dytwbYb4RWGc+IpJ91TuqDLYRdj404gzF
         4pr2zb0+qwHuZIs4YhZdbFVupwjom2RsqD+DcZijopPAr9nPXNQkLSI5RIZPneQ9QMDJ
         7QUdCI31bXZj87G1EHqp3iPr4Fd0+Wp27/l6g7oGdUF4yysej570X2ccGj4RlNEBfIz6
         GdUhpiXlEFKp7xAr7VV3DvA+Lp0MVqs3CBLUgw81teCfFucS/5fvCBNEzoV+1w2dg89B
         eoYT10kYOPktcg8iJXOy/nspbxa140hHUp2VkR5kYEYNVTRXxfNTjoVj2txeiJpaS0Ft
         GAbQ==
X-Gm-Message-State: AOAM533GCInecqDSSJ+vuyTsSRSH5XRe8+vYB8ayQXBR/8PQ1YmeAAUX
        rj0IiEh05M6WhK9KURdM6lk5DBSvspmK5w==
X-Google-Smtp-Source: ABdhPJwelGJqbCgP7Ts7t+OT1UumfY0ywBCQVlebohtkI6Yx54qPHDZizuxJ4h3RkHVSBGLec5wDLg==
X-Received: by 2002:ac2:4d4e:: with SMTP id 14mr11167710lfp.290.1626790577484;
        Tue, 20 Jul 2021 07:16:17 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id t24sm2461669ljj.97.2021.07.20.07.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 07:16:16 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 16KEGEO3005281;
        Tue, 20 Jul 2021 17:16:15 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 16KEGBSb005280;
        Tue, 20 Jul 2021 17:16:11 +0300
Date:   Tue, 20 Jul 2021 17:16:11 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 0/3] net/ncsi: Add NCSI Intel OEM command to keep PHY
 link up
Message-ID: <20210720141611.GI875@home.paul.comp>
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
 <20210720095320.GB4789@home.paul.comp>
 <10902992a9dfb5b1b4f1d7a9e17ff0e7b121b50b.camel@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10902992a9dfb5b1b4f1d7a9e17ff0e7b121b50b.camel@yadro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:00:40PM +0300, Ivan Mikhaylov wrote:
> > While the host is booted up and fully functional it assumes it has
> > full proper control of network cards, and sometimes it really needs to
> > reset them to e.g. recover from crashed firmware. The PHY resets might
> > also make sense in certain cases, and so in general having this "link
> > up" bit set all the time might be breaking assumptions.
> 
> Paul, what kind of assumption it would break?

The host OS drivers assume they can fully control PCIe network
cards. Doing anything (including inhibiting PHY resets) behind its
back might break assumptions the driver authors had. This bit in
question certainly makes the card behave in an unusual way, so no
wonder Intel didn't enable it by default.

I do not claim I know for a fact it's problematic but it doesn't feel
like "the right thing" so some edge cases might expose issues.

> Joel proposed it as DTS option which may help at runtime.

Sorry, I'm not following. If BMC is fully booted it's able to
configure NC-SI appropriately by a userspace action coordinated with
other BMC tasks. If BMC is not yet ready then we can't communicate
with it via Ethernet anyway. So I can't see when exactly is it going
to be helpful.

> Some of those commands should be applied after channel probe as I
> think including phy reset control.

Do you have any other commands in mind? So far I assumed we're
discussing just the one to mask PHY resets.

> > Ivan, so far I have an impression that the user-space solution would
> > be much easier, flexible and manageable and that there's no need for
> > this command to be in Linux at all.
> 
> You may not have such things on your image with suitable env which you can rely
> on. There is smaf for mellanox which is done in the same way for example.

I can hardly imagine why an OS running on BMC would be using this code
in question and appropriate DT configuration but not having the right
means in userspace to control it. What would be the usecase?

If the network subsystem maintainers think this is a good idea, all
things considered, I'm fine with it. I210 losing link exactly at the
time when you need it (to enter the UEFI interactive menu) is
super-annoying, so probably any fix is better than none :)

Thank you for discussion.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com

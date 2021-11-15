Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C06450760
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhKOOqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhKOOqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:46:01 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED51BC061746
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 06:43:01 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g14so73004403edz.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 06:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CzJK4JDX6paenq4KcCz6jy46RXs4ivoWCXDNifpXO7o=;
        b=saHYB+jmp8hyRGGN65aWHLlKWn7anwGLToUEK3BOGPGcu6a5PPmg+9HWsGf93RFbuk
         wzIzXI5sz75bfohzWYFahzSiOHV38X/dUt/UinkOXyjZZB2LBP4QzHPQmkYGkdoaX1NI
         jiRy2h9dUmdaC4YnQs8Ei6z+wKJB3Gdtu79HDc5YL5QYeJnKxNZEKiqixDHFDGGZgl/h
         LumvZzG2f6A1KXD44AcJZT0/qdSeW+PTas7tKmcay4ucwWmb+h4GJEW9x2TcgrlN1gTW
         1ii3Ay3Ddo1XnwGTybmJRr4VAeNSFcIReeU5/K9GWV9eCzzbGSVt4HfM8M/NFH2KTIEH
         WjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CzJK4JDX6paenq4KcCz6jy46RXs4ivoWCXDNifpXO7o=;
        b=KesAduhEfFzEGffwR3rz8M27V+z869iYfwu/3DTkoAUNUtUozlHH7tjcFoP9UoWc1Z
         U2OoYltPRvGEGOHMEcD3rqbXwN/B8VCUya6jjrYEmyLX4f3eFqSqot7FdLOJHRJSsGMp
         k95K9paLGGvY4nLCFS2+qwt2HA3Fiii05VjQV27cc4IUMPt5YkQCNc7W2HQ5Wbqux0xL
         Oi6OvmuDuhkfjWB5Jstx3zW+uwx4gvX3dXImsnNRBwhcFwxTCNNXnKh/bAgd0oM+zCc4
         0s9+jkVFfKAis4cm7KEY7xFAENE0lVAy9aVZ1YgvH1Nogpuc7FeW/PFmyIX8/etQU8J1
         qXEw==
X-Gm-Message-State: AOAM533e2FvjlXOQSlRJmECYpuq4IprNiJKdNyZCxCNzdGdgTInxrmdu
        qF7Adp9dx9Ii9gOxnLss1iHoCw==
X-Google-Smtp-Source: ABdhPJxmZIfHRDtPhNYfKcXFT56AD2cOKKPguslKGLKBF9rhwU+J5uDGnBOPJeNbHUgF5k93n+vz/g==
X-Received: by 2002:a17:907:7f1a:: with SMTP id qf26mr49386530ejc.543.1636987380612;
        Mon, 15 Nov 2021 06:43:00 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id k9sm7515183edo.87.2021.11.15.06.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 06:42:59 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:42:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YZJx8raQt+FkKaeY@nanopsycho>
References: <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
 <YZCqVig9GQi/o1iz@unreal>
 <YZJCdSy+wzqlwrE2@nanopsycho>
 <20211115125359.GM2105516@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115125359.GM2105516@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 15, 2021 at 01:53:59PM CET, jgg@nvidia.com wrote:
>On Mon, Nov 15, 2021 at 12:20:21PM +0100, Jiri Pirko wrote:
>> Sun, Nov 14, 2021 at 07:19:02AM CET, leon@kernel.org wrote:
>> >On Fri, Nov 12, 2021 at 08:38:56AM +0100, Jiri Pirko wrote:
>> >> Thu, Nov 11, 2021 at 01:17:52PM CET, leon@kernel.org wrote:
>> >> >On Thu, Nov 11, 2021 at 01:05:11PM +0100, Jiri Pirko wrote:
>> >> >> Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
>> >> >> >On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
>> >> >> >> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
>> >> >> >> > > > I once sketched out fixing this by removing the need to hold the
>> >> >> >> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
>> >> >> >> > > > over the devlink reload paths. It seemed like a reasonable step toward
>> >> >> >> > > > finer grained locking.  
>> >> >> >> > > 
>> >> >> >> > > Seems to me the locking is just a symptom.  
>> >> >> >> > 
>> >> >> >> > My fear is this reload during net ns destruction is devlink uAPI now
>> >> >> >> > and, yes it may be only a symptom, but the root cause may be unfixable
>> >> >> >> > uAPI constraints.
>> >> >> >> 
>> >> >> >> If I'm reading this right it locks up 100% of the time, what is a uAPI
>> >> >> >> for? DoS? ;)
>> >> >> >> 
>> >> >> >> Hence my questions about the actual use cases.
>> >> >> >
>> >> >> >Removing namespace support from devlink would solve the crasher. I
>> >> >> >certainly didn't feel bold enough to suggest such a thing :)
>> >> >> >
>> >> >> >If no other devlink driver cares about this it is probably the best
>> >> >> >idea.
>> >> >> 
>> >> >> Devlink namespace support is not generic, not related to any driver.
>> >> >
>> >> >What do you mean?
>> >> >
>> >> >devlink_pernet_pre_exit() calls to devlink reload, which means that only
>> >> >drivers that support reload care about it. The reload is driver thing.
>> >> 
>> >> However, Jason was talking about "namespace support removal from
>> >> devlink"..
>> >
>> >The code that sparkles deadlocks is in devlink_pernet_pre_exit() and
>> >this will be nice to remove. I just don't know if it is possible to do
>> >without ripping whole namespace support from devlink.
>> 
>> As discussed offline, the non-standard mlx5/IB usage of network
>> namespaces requires non standard mlx5/IB workaround. Does not make any
>> sense to remove the devlink net namespace support removal.
>
>Sorry, I don't agree that registering a net notifier in an aux device
>probe function is non-standard or wrong.


Listening to events which happen in different namespaces and react to
them is the non-standard behaviour which I refered to. If you would not
need to do it, you could just use netns notofier which would solve your
issue. You know it.


>
>This model must be supported sanely somehow in the netdev area and
>cannot be worked around in leaf drivers.
>
>Intel ice will have the same problem, as would broadcom if they ever
>get their driver modernized.
>
>Jason

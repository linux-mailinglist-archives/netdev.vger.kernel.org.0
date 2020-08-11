Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C4624161E
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 07:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHKFqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 01:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgHKFqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 01:46:30 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30C1C06174A
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 22:46:29 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f12so10259881wru.13
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 22:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sdENeti3PjcBTV2MD8ryoLAaF0AsT7D1lB9LbxQtRAg=;
        b=oT9q0S9hkeGQCEViqUTO/mht8FkcwSNgauxXDAvs+4AU3J12fBYLq7Hi2HoVc0ANUE
         3SK3tW9m2/dJC0d6EBMBkSFOuVW1qGJwvWXyOk/jSGaLfAnJVvSghDNDACjo2iCuh55J
         fdMlBsFxvRU4GPlOXItOqp/yIXiVqaTykH85hHMhzaPTXqgokQ23+hxsfsNPEjqgYhEu
         oo71jQaD9lHXtkwT2IF5XiV06BETzcb9aDajxklrT6s9obso4Gytm8yY0MWWly2ZN04P
         pZUJmTkhatms3NCggpEC3f7tdNiSffhY6EetbnIQqKs/QakmLb0w/d6U6JBt0hakZ5WB
         0RgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sdENeti3PjcBTV2MD8ryoLAaF0AsT7D1lB9LbxQtRAg=;
        b=F4Zl1Z7MkLiAHXuf7b0hVdpxiri1P6sDvsMCoVEADFoiDPRuds/nLkIJ4kRCTFj72g
         62wABp1WjKjG0apx4MXf2anzwUFoKIPkdTBd5faQ0RcR35TEVankHRayZteuh81Yr7XF
         Im2ZFHsGQNce4jEe7H6kbJdDc4WqjHgcTz6v9uAUnfuXfRvhxcHUL66KySXO5U2PS70N
         +LbY6lrsYi92k7ToUe/3CrM+FXkSftET73RBeqcIcq66f3QpYL8KpHnoMLdCLVlhiD9d
         HX8Z7/i/MMpuqEUHgNsfbP2IUZi4Nm7W73iCFveE7DhUbam9rO64Gfvat7GQZF0mjWq7
         KCoA==
X-Gm-Message-State: AOAM532VKi4YX2sctS3qQKrnW8UaUKyNf3eEv5QZu1o/GEJgSufF+BLR
        R9ntO7Y6PFi82t6UzW5ua6ir0w==
X-Google-Smtp-Source: ABdhPJxTKzN+uv6VzWavZYndp5cyNmZyzaI1ppoIH5+RJJIUq+oAdwZNzGHpdJQOQBsP6g8WhouVxw==
X-Received: by 2002:adf:dd01:: with SMTP id a1mr4837577wrm.301.1597124788355;
        Mon, 10 Aug 2020 22:46:28 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y84sm3196275wmg.38.2020.08.10.22.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 22:46:27 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:46:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200811054626.GA24082@nanopsycho.orion>
References: <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
 <20200803141442.GB2290@nanopsycho>
 <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200804100418.GA2210@nanopsycho>
 <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200805110258.GA2169@nanopsycho>
 <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8b06ade2-dfbe-8894-0d6a-afe9c2f41b4e@mellanox.com>
 <20200810095305.0b9661ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810095305.0b9661ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 10, 2020 at 06:53:05PM CEST, kuba@kernel.org wrote:
>On Sun, 9 Aug 2020 16:21:29 +0300 Moshe Shemesh wrote:
>> Okay, so devlink reload default for mlx5 will include also fw-activate 
>> to align with mlxsw default.
>> 
>> Meaning drivers that supports fw-activate will add it to the default.
>
>No per-driver default.
>
>Maybe the difference between mlxsw and mlx5 can be simply explained by
>the fact that mlxsw loads firmware from /lib/firmware on every probe
>(more or less).
>
>It's only natural for a driver which loads FW from disk to load it on
>driver reload.

We don't load it on reaload... We just do reset witn activation.

>
>> The flow of devlink reload default on mlx5 will be:
>> 
>> If there is FW image pending and live patch is suitable to apply, do 
>> live patch and driver re-initialization.
>> 
>> If there is FW image pending but live patch doesn't fit do fw-reset and 
>> driver-initialization.
>> 
>> If no FW image pending just do driver-initialization.
>
>This sounds too complicated. Don't try to guess what the user wants.
>
>> I still think I should on top of that add the level option to be 
>> selected by the user if he prefers a specific action, so the uAPI would be:
>> 
>> devlink dev reload [ netns { PID | NAME | ID } ] [ level { fw-live-patch 
>> | driver-reinit |fw-activate } ]
>
>I'm all for the level/action.
>
>> But I am still missing something: fw-activate implies that it will 
>> activate a new FW image stored on flash, pending activation. What if the 
>> user wants to reset and reload the FW if no new FW pending ? Should we 
>> add --force option to fw-activate level ?
>
>Since reload does not check today if anything changed - i.e. if reload
>is actually needed, neither should fw-activate, IMO. I'd expect the
>"--force behavior" to be the default.

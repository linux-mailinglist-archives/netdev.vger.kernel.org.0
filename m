Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016FDF74E2
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKKNaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:30:30 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32897 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfKKNa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:30:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id a17so12058221wmb.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 05:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mkwenBuk+yOAxdES4LJS2kpTu2gXDKAkkdekG5IpFbI=;
        b=s328wBZB9kmOFPu4tqfyJMK+7A3waE1Qg75T6g83rUmKO/zjxLvxrHVvPNXJXpOeH/
         GCzJ3BeVkRa+0fRmeqCMvHYDRtabAIkSO0KudD+4MoildGDktJiNurEd4Bx21E6OTAZ9
         aYVXy7VSZXvm5EPSjShNaklxzwzydP4jKIu7REnJq3uxQwFHZqCeqtnpfXJm/QU95wIt
         uGZKN+tGdH1/uclUdMnOBG1Ax5e2u/121WZVo6BkUpFVC/JPqDJoaaRO0wR7Jxd0lYqF
         H0LR03kV+Y8BEZH76EZqZsUT1s0JV9D3yejviqk66P8pM+m6DWg7vpTJmaWyaw8TpwGz
         a2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mkwenBuk+yOAxdES4LJS2kpTu2gXDKAkkdekG5IpFbI=;
        b=eDyslJfHb1PTmU5C/RG8x1sK8yjCxgM3Iqly7lzSL+CXjpf6mo89TVsbyHwqQYpfDe
         dY+dTDiJ230b2l61fZ13LCywe8cub4k4upHAKL1ngt0xOI/oaZFDBcXc4BCxARnh0Kds
         zZWKF+NouC5LHduADcRU1rU3CAIMb4iUn0JCdYA/9pAmNBcl0FYnC3WOXjhfCKyAHekq
         QFopIv4jEG2sgkDDqbtRA/xHF8wCjCzuezoiyBZeZi53H9lx2wdBNKFObClz+xdtpnve
         qlFYLO88uGRRbvvI4R5r/lofryvPbTMNsruhwq7JDDRGwFVeUdzSeTduRd8CH1vLhY8h
         zUqQ==
X-Gm-Message-State: APjAAAWhn4MUSYSsufb6OfAHBU6KLPotYYP5ocLUQ42JkxMKLamAjuO2
        3sBoJqE5WQAqYbLOr5PPswC8eQ==
X-Google-Smtp-Source: APXvYqzwooUbxzm69efOp0rljYcE0gAn6F/FddFwTjRmADcvS5J3lQevJ5I6HflzU4YKaBn7XXxoTw==
X-Received: by 2002:a1c:1d48:: with SMTP id d69mr19104416wmd.160.1573479028082;
        Mon, 11 Nov 2019 05:30:28 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y6sm9905517wrn.21.2019.11.11.05.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 05:30:27 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:30:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Parav Pandit <parav@mellanox.com>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191111133026.GA2202@nanopsycho>
References: <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
 <20191109004426.GB31761@ziepe.ca>
 <20191109092747.26a1a37e@cakuba>
 <20191110091855.GE1435668@kroah.com>
 <20191110194601.0d6ed1a0@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110194601.0d6ed1a0@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 11, 2019 at 04:46:01AM CET, jakub.kicinski@netronome.com wrote:
>On Sun, 10 Nov 2019 10:18:55 +0100, gregkh@linuxfoundation.org wrote:
>> > What I'm missing is why is it so bad to have a driver register to
>> > multiple subsystems.  
>> 
>> Because these PCI devices seem to do "different" things all in one PCI
>> resource set.  Blame the hardware designers :)
>
>See below, I don't think you can blame the HW designers in this
>particular case :)
>
>> > For the nfp I think the _real_ reason to have a bus was that it
>> > was expected to have some out-of-tree modules bind to it. Something 
>> > I would not encourage :)  
>> 
>> That's not ok, and I agree with you.
>> 
>> But there seems to be some more complex PCI devices that do lots of
>> different things all at once.  Kind of like a PCI device that wants to
>> be both a keyboard and a storage device at the same time (i.e. a button
>> on a disk drive...)
>
>The keyboard which is also a storage device may be a clear cut case
>where multiple devices were integrated into one bus endpoint.

Also, I think that very important differentiator between keyboard/button
and NIC is that keyboard/button is fixed. You have driver bus with 2
devices on constant addresses.

However in case of NIC subfunctions. You have 0 at he beginning and user
instructs to create more (maybe hundreds). Now important questions
appear:

1) How to create devices (what API) - mdev has this figured out
2) How to to do the addressing of the devices. Needs to be
   predictable/defined by the user - mdev has this figured out
3) Udev names of netdevices - udev names that according to the
   bus/address. That is straightforeward with mdev.
   I can't really see how to figure this one in particular with
   per-driver busses :/


>
>The case with these advanced networking adapters is a little different
>in that they are one HW device which has oodles of FW implementing
>clients or acceleration for various networking protocols.
>
>The nice thing about having a fake bus is you can load out-of-tree
>drivers to operate extra protocols quite cleanly.
>
>I'm not saying that's what the code in question is doing, I'm saying 
>I'd personally like to understand the motivation more clearly before
>every networking driver out there starts spawning buses. The only
>argument I've heard so far for the separate devices is reloading subset
>of the drivers, which I'd rate as moderately convincing.

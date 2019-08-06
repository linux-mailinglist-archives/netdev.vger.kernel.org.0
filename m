Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098E28390D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHFSzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:55:17 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:40277 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfHFSzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:55:17 -0400
Received: by mail-qk1-f175.google.com with SMTP id s145so63765626qke.7
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Sg4DBo7+3DUATwq362R32eryR3ZEZKv5hRo777NyHi4=;
        b=sXsHeGq4FBokCm8V+843yL5aoKGIxHB9cYIrqkQLHWIoI4BkFMGKWNKkAz9Glr3X44
         otci4hpCdO495mB9aeYk9mjA8LaFYTx+/8iBTNMGoB965Bn1yPscXL3ztSzXtVmMN8R2
         Riz6HgDh7ddbwcclNod91IF5t3FR71CqAALCK35sSMXMRGRhjM4ly7QVsEpVR9fqHc4g
         Gcv4aoZl7SJwyXLe3b3rpj7NSOMjFZPJ5GHffpd9ovjuK2+4HxVS/WI4rBGqiSA6+Mvt
         hf4t5JbRBDK0LoX+UMIy1bDMDEx+M79sjYSrXkGyUph2jrIltAKbdf9f96bFWBy2vgyb
         zzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Sg4DBo7+3DUATwq362R32eryR3ZEZKv5hRo777NyHi4=;
        b=Ndmz4eAe09arTYWyhshOJyTCi4Fc98jSIwNqHhMLw06+Y4Gu97kVDh6kl5i/4zJTAP
         ODsbvD8SXvenFcjdL03LbS948sD+Px1taa9q7WPGpE9/3ap4EcymjphgrfcljQt4yyMA
         9wqW+nW4PxbcupIRer47JV1WhqzJN6DUfS2TiW4ZxUU5Pv45RbKuoP/5zEkgtf7Ffjw/
         wU67KhaP4DqrLkFHpmhAncutQr33ntUDeYMT9+DKrRDBldZvby1n95CRUxcBqorXlumT
         v2ia2JAj4S/+IGjH5Ea8pgJDe5OUfRKd37mbV5gKpAzpfri0kqptwDyZNewu38gtg0+V
         dYJg==
X-Gm-Message-State: APjAAAUusE8Exp6Ly4LrWQmT/sG4UHkXNA39YCAd4J94BT5fZIvwhE4L
        SRWp5/mSQHt/TpRNgc5Du5QpwA==
X-Google-Smtp-Source: APXvYqwdTD8FU9mhRPbvhUxE+qTO7ukGkvHsWWvY/h3E6zjtfz+h/eo1RDiy7vaGlQZZFQKm45KEAQ==
X-Received: by 2002:a05:620a:70f:: with SMTP id 15mr4712959qkc.171.1565117716183;
        Tue, 06 Aug 2019 11:55:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l63sm37528242qkb.124.2019.08.06.11.55.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 11:55:16 -0700 (PDT)
Date:   Tue, 6 Aug 2019 11:54:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        mlxsw@mellanox.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190806115449.5b3a9d97@cakuba.netronome.com>
In-Reply-To: <20190806183841.GD2332@nanopsycho.orion>
References: <20190806164036.GA2332@nanopsycho.orion>
        <20190806112717.3b070d07@cakuba.netronome.com>
        <20190806183841.GD2332@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 20:38:41 +0200, Jiri Pirko wrote:
> >> So the proposal is to have some new device, say "kernelnet", that
> >> would implicitly create per-namespace devlink instance. This devlink
> >> instance would be used to setup resource limits. Like:
> >> 
> >> devlink resource set kernelnet path /IPv4/fib size 96
> >> devlink -N ns1name resource set kernelnet path /IPv6/fib size 100
> >> devlink -N ns2name resource set kernelnet path /IPv4/fib-rules size 8
> >> 
> >> To me it sounds a bit odd for kernel namespace to act as a device, but
> >> thinking about it more, it makes sense. Probably better than to define
> >> a new api. User would use the same tool to work with kernel and hw.
> >> 
> >> Also we can implement other devlink functionality, like dpipe.
> >> User would then have visibility of network pipeline, tables,
> >> utilization, etc. It is related to the resources too.
> >> 
> >> What do you think?  
> >
> >I'm no expert here but seems counter intuitive that device tables would
> >be aware of namespaces in the first place. Are we not reinventing
> >cgroup controllers based on a device API? IMHO from a perspective of
> >someone unfamiliar with routing offload this seems backwards :)  
> 
> Can we use cgroup for fib and other limitations instead?

Not sure the question is to me, I don't feel particularly qualified,
I've never worked with VDCs or wrote a switch driver.. But I'd see
cgroups as a natural fit, and if I read Andrew's reply right so does
he.. There's certainly a feeling of reinventing the wheel here.

We usually model things in software and then compile that abstraction
into device terms. Devlink allows for low level access to the device,
it allows us to, in a sense, see the result of that compilation. But
that's more of a debugging/low level knob than first class citizen :(

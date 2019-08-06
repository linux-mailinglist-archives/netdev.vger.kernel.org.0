Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01249838B4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfHFSjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:39:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46084 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFSio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:38:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so88869150wru.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xg65xLmzgmz0HqMNsC5CrN/o0hKUVl4ldh6Mk+/jKXg=;
        b=YkzFaH36HtbCk3mG80XiOxCWA/35HJJvU/OrNFwOBd8reXQEqzWL3TcmKFIB7tNsis
         6sAXh3+ZBDzo9wRJn4UW1n3N8drTTDBnVu/sqRLY0tMVW1ZD1HC9vahC2/fwYtIwknGn
         OimuRCTwpx5cQqWKjGZ2Sn6i6thJDe1cdSGBjF+5yqa6RaATkm+253jebHO8rVUarwSw
         2IQ/lkmN/cOqBm1a/DFxRVjPO2lgroe1kYYz4cRserCofSDn+Ml9HgnUfd+KuATMBFob
         UdvaqiPHTxPHWPiy/6Jjsp4bDKEGzj5zoX0q78JZmSbElUXUsNtbOMRlNVKz0BM2kxme
         Uh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xg65xLmzgmz0HqMNsC5CrN/o0hKUVl4ldh6Mk+/jKXg=;
        b=MhRIbCiK1z2OfnhlvbzADHZOzxM/3obcPjpvFJaJ2zXG8Q1rxMhrBRD7E4W63rGdVt
         g7QTpurhFpb2NmsBSxjBznc/e6hY1XDiIusbiV4C6fD0CUoJlLdGPQ219FyAOkBCeC6g
         KS4J7TdDsHdO+vUSq/o1muBSWloz1UiTxqfxyS1OMvG54mWRanbFX6CEoQRjLuvCLAYg
         bMWx1QBwKeGpYfudsWQzHcWopJpkKk4bf7sC4kTmvO5IP0xY2AYzl+QZQoJY9GeOwdAn
         erMm1FKK+RfxxbaRqE/TG3iGKV4Li6tWfIKN8JMTcDeSd1tsrD4rLJu52/DqosqAfDqE
         S5cg==
X-Gm-Message-State: APjAAAWhVyHMjm4gmskWTINN3E8Bv/KZkOl67W2fFLkhXkxR+40/HVmq
        4VwIW7eJUMg6JS0SZbrEDjbQYw==
X-Google-Smtp-Source: APXvYqy1c8UHmRqGEuwyMgEDYSpMZ+pRtYmukK9re1QodTo8XnjJaVYEDbKqwzYkOzcLoe1fB6ommA==
X-Received: by 2002:a5d:5607:: with SMTP id l7mr6313019wrv.228.1565116722343;
        Tue, 06 Aug 2019 11:38:42 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 91sm181676519wrp.3.2019.08.06.11.38.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 11:38:41 -0700 (PDT)
Date:   Tue, 6 Aug 2019 20:38:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        mlxsw@mellanox.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190806183841.GD2332@nanopsycho.orion>
References: <20190806164036.GA2332@nanopsycho.orion>
 <20190806112717.3b070d07@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806112717.3b070d07@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 06, 2019 at 08:27:17PM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 6 Aug 2019 18:40:36 +0200, Jiri Pirko wrote:
>> Hi all.
>> 
>> I just discussed this with DavidA and I would like to bring this to
>> broader audience. David wants to limit kernel resources in network
>> namespaces, for example fibs, fib rules, etc.
>> 
>> He claims that devlink api is rich enough to program this limitations
>> as it already does for mlxsw hw resources for example. 
>
>TBH I don't see how you changed anything to do with FIB notifications,
>so the fact that the accounting is off now is a bit confusing. I don't
>understand how devlink, FIB and namespaces mix :(
>
>> If we have this api for hardware, why don't to reuse it for the
>> kernel and it's resources too?
>
>IMHO the netdevsim use of this API is a slight abuse, to prove the
>device can fail the FIB changes, nothing more..

It's slightly bigger abuse :) But in this thread, we are not discussing
netdevsim, but separate "dev".


>
>> So the proposal is to have some new device, say "kernelnet", that
>> would implicitly create per-namespace devlink instance. This devlink
>> instance would be used to setup resource limits. Like:
>> 
>> devlink resource set kernelnet path /IPv4/fib size 96
>> devlink -N ns1name resource set kernelnet path /IPv6/fib size 100
>> devlink -N ns2name resource set kernelnet path /IPv4/fib-rules size 8
>> 
>> To me it sounds a bit odd for kernel namespace to act as a device, but
>> thinking about it more, it makes sense. Probably better than to define
>> a new api. User would use the same tool to work with kernel and hw.
>> 
>> Also we can implement other devlink functionality, like dpipe.
>> User would then have visibility of network pipeline, tables,
>> utilization, etc. It is related to the resources too.
>> 
>> What do you think?
>
>I'm no expert here but seems counter intuitive that device tables would
>be aware of namespaces in the first place. Are we not reinventing
>cgroup controllers based on a device API? IMHO from a perspective of
>someone unfamiliar with routing offload this seems backwards :)

Can we use cgroup for fib and other limitations instead?


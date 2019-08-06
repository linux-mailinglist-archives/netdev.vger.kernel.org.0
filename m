Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CBF83889
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbfHFS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:27:47 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:39476 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHFS1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:27:47 -0400
Received: by mail-qk1-f169.google.com with SMTP id w190so63674258qkc.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2V537cr8FcxerQ9+wLyoBz4JeKNxIMYeKCZ+EBZjgTs=;
        b=D3rhxqsuCWr/cU7mWOC/UgGYqKjrhNbcje7vhdiEr+mZhO2OG+VpIJ7sRFBe51tISI
         2nsFh/q/vNbEBXTZrFLRt/MVpR/Y9ZjvWUVsBy8UnWL5pjiZoPsSga1/XBeonLRcwDCH
         M5/Td8gndVLuIGB/5mMeJdOtLxth5wHWBPH7q7EEGp12aQLiotBSXF1SAbftHL1JLDq5
         y8Tya2gtnX3gY0zRUz5hXI74lc0t/1pkUiffP2UiKfExCdVMWrkpEAybJBIeEJmnUUUW
         ZgzZftcCZZYj/ZDMcYgQ+Z9xU9MhsuEvOVpk9Vba9hQsKYxtj3EQOopMFgCt08EvOSSB
         CfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2V537cr8FcxerQ9+wLyoBz4JeKNxIMYeKCZ+EBZjgTs=;
        b=MUVzFItSrA3i6SuIjYPxoN8fZpm7TMQ5RyUIpSstxVK0ZTwCuMoS6yg+e5W4lWND5e
         joCX9sFFD66xsUHLvndZsFTPLC2hQHbnuDhli9Dapq0MnwOe8yFWfeC9Zx6jNMraPiai
         nAwYc1wF7B1TQJpSUv7/NEh+bfoFGA7bFQBxQaH3quBETa3fg4Jnrx7XGUs2oPal+GXu
         cAgZxY/J5VfDU/6+3/K6Axmx7FdMcM/b2vKOPArMRT77NTFyp9hUi2Ink68LpMJ8Gq2f
         0JT9njEGzDV0qjWyMTcchqL3nsHqC2YLA2rBRMq3BlybW148xFdISIiT51O3cTod87Zx
         5qow==
X-Gm-Message-State: APjAAAV7/Gr5YaH4NiWNGMX41kiWlA/WOClFtW0oCCQT6MeIU9P77/wy
        pmmEz8FOM7gPr3viwleGTuy92Q==
X-Google-Smtp-Source: APXvYqwhU3ybV15J/FgtN6dNjbRadgt626VMvWu5Q4w6bN+Nu9HWBkttaxSS4GlTP+lirpNL17T3bA==
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr4816660qkn.265.1565116066240;
        Tue, 06 Aug 2019 11:27:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i16sm35970449qkk.1.2019.08.06.11.27.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 11:27:46 -0700 (PDT)
Date:   Tue, 6 Aug 2019 11:27:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mkubecek@suse.cz, stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190806112717.3b070d07@cakuba.netronome.com>
In-Reply-To: <20190806164036.GA2332@nanopsycho.orion>
References: <20190806164036.GA2332@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 18:40:36 +0200, Jiri Pirko wrote:
> Hi all.
> 
> I just discussed this with DavidA and I would like to bring this to
> broader audience. David wants to limit kernel resources in network
> namespaces, for example fibs, fib rules, etc.
> 
> He claims that devlink api is rich enough to program this limitations
> as it already does for mlxsw hw resources for example. 

TBH I don't see how you changed anything to do with FIB notifications,
so the fact that the accounting is off now is a bit confusing. I don't
understand how devlink, FIB and namespaces mix :(

> If we have this api for hardware, why don't to reuse it for the
> kernel and it's resources too?

IMHO the netdevsim use of this API is a slight abuse, to prove the
device can fail the FIB changes, nothing more..

> So the proposal is to have some new device, say "kernelnet", that
> would implicitly create per-namespace devlink instance. This devlink
> instance would be used to setup resource limits. Like:
> 
> devlink resource set kernelnet path /IPv4/fib size 96
> devlink -N ns1name resource set kernelnet path /IPv6/fib size 100
> devlink -N ns2name resource set kernelnet path /IPv4/fib-rules size 8
> 
> To me it sounds a bit odd for kernel namespace to act as a device, but
> thinking about it more, it makes sense. Probably better than to define
> a new api. User would use the same tool to work with kernel and hw.
> 
> Also we can implement other devlink functionality, like dpipe.
> User would then have visibility of network pipeline, tables,
> utilization, etc. It is related to the resources too.
> 
> What do you think?

I'm no expert here but seems counter intuitive that device tables would
be aware of namespaces in the first place. Are we not reinventing
cgroup controllers based on a device API? IMHO from a perspective of
someone unfamiliar with routing offload this seems backwards :)

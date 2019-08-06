Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3145837F6
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbfHFRig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:38:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37597 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731830AbfHFRif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:38:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so9142964pgp.4
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0RlBRUuNIO3DBfeNJjyLBKQCnwsa1E/cfoU/w8ppL10=;
        b=KitOdRuvVoJei4o3CMQIUSxkGhlyoIKS997WtVrTeK2UFEtgaljVZzYxPMncFjK5+a
         IvMDmnm/ExGlLnJghzLfxpJh4i1K+3NlxeLBDN6ByQdoWZFqgnKbTZVLGkzf5EbGu46g
         gw3Fq09L8tCInQ1CeOJVGWgYIYaUZ117KBe7vWKK9y+LXIYEegX/6cQWMdcME+5oNW8u
         vlWQROIF9aab/TJsO8W1ICF0mHJdYKHm2boIAJQkl2P6CBbc4FIg3ZVQldOVONOB24C1
         t8Um5SKIzZvCINR4fFIeoIX/A3YLymqCHjBcE1ju6yPh0Sa/JUyRA5UHE8Hd6rrMh9EN
         nZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0RlBRUuNIO3DBfeNJjyLBKQCnwsa1E/cfoU/w8ppL10=;
        b=X7QbHC81LOSBax3hEC2IusN82pkjyxpCdxcl+cU/VRIjby7HVUs7aOX1MMtXNOzcR0
         sIj8rXNblXmiAaNo1Wvur39uPjaz72K74MU3hxLqqPdtl0qMOz8tvlY+Vyfm6DlAe2+l
         rrmMuaVc7oCe4UFxJa9rS5v7yCXiobemLf3OOoqMUFkc8f7/l6LageGkjOk5+p8xpN1k
         Q8qy4ayaqssVHCsgHPX3W/jFpLuPSMOxQlsBaHXuwKbJ0+Lo8aWkmnCzmZ93/G4A3yT7
         A14PhSXzTmcux5+XHJm4Y645mJ1ghipfNRD57/peooC05mdfElGxJb707J1yTgsEpdsK
         hZRQ==
X-Gm-Message-State: APjAAAVdapGyivgIAuY9qFbT1WLDJ4iqon0ODJyzq7tJq2CUANqZQ3Aw
        rSte+Rl+wj5Q5NhVQxN44RRobdjl
X-Google-Smtp-Source: APXvYqwT711h+O6aWnGssOozo/NVzjvxLowM6g46vhxhxfTUbJNkl1tllnfSVo9Vf/upfC37uc2ZqA==
X-Received: by 2002:aa7:8a99:: with SMTP id a25mr4883556pfc.127.1565113115038;
        Tue, 06 Aug 2019 10:38:35 -0700 (PDT)
Received: from [172.27.227.131] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id n7sm98538451pff.59.2019.08.06.10.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 10:38:34 -0700 (PDT)
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
References: <20190806164036.GA2332@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
Date:   Tue, 6 Aug 2019 11:38:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190806164036.GA2332@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/19 10:40 AM, Jiri Pirko wrote:
> Hi all.
> 
> I just discussed this with DavidA and I would like to bring this to
> broader audience. David wants to limit kernel resources in network
> namespaces, for example fibs, fib rules, etc.
> 
> He claims that devlink api is rich enough to program this limitations
> as it already does for mlxsw hw resources for example. If we have this
> api for hardware, why don't to reuse it for the kernel and it's
> resources too?

The analogy is that a kernel is 'programmed' just like hardware, it has
resources just like hardware (e.g., memory) and those resources are
limited as well. So the resources consumed by fib entries, rules,
nexthops, etc should be controllable.

> 
> So the proposal is to have some new device, say "kernelnet", that would
> implicitly create per-namespace devlink instance. This devlink
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
> 
> Jiri
> 


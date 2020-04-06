Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768B019FCF8
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgDFSUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:20:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43839 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgDFSUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:20:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id w15so588106wrv.10
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 11:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SAO+1TNMhMc1LSA8/WfvDrQsOzUQ3pBmaeEqYFvEUWQ=;
        b=Ti4tokQZ+rd2STnTkJvpDAUpfvBhf6GX/EgB0Dn2T64qiG0RCpz7wEsbqgLafqgIEQ
         UZKxgy6fgN7yEUKUyJpjLAy1m+5kGd8tOIiPCaRfroi5RB5hgEh6Jpn5Vu13fWGZU5jx
         +D0AGiJVyC/wIU/IFx0gkCaQUmuUB25rx7MZgjZm8z3uHN9Zhbm4BuadOT2MRvlhPjfB
         oLaat2rWlqcfPbXTUFTIZaI18Vq0lpfC8iOIRgPzxnpz0HVDOs1w9KOoFKIJ0gbX5Go4
         I3mmPuuhH42KTVN64ZGgxxf4WKOfZ1/Z1j9A/6KDshwgJ3jK3nNQbHDCco2FM9CP7MY/
         iGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SAO+1TNMhMc1LSA8/WfvDrQsOzUQ3pBmaeEqYFvEUWQ=;
        b=G8MZUkf0llSZgyFahPHnh3QpfrgbwPDyWL6AaQaMwAgxUx889g+1N6pq4MvqWgBrrV
         tfVq1XkuWqxSYoFubDYjgp6KrwI4tlXTQkdtFyGKSdx84OW47lIdARgMilS42s7Aka0I
         du56q/PBYNfYusZax8c1A4Ai+iRwjn6Bq3B1VoyllX150JpL2qpS1oEiOIyPh6fyIUQb
         a+9F25P+1BHgoawNJ0vSmD7FqV0/LDmVuhAYXSbRaLKJaG0FKOzTt7o1MXceP2sb/Zog
         flZx2gk9N8oWex3KA9ghgsGXzjneIVKFChFUxCY81jHPyyIWae0OXh60DkzVKwxHf0Ww
         Wf4Q==
X-Gm-Message-State: AGi0PubhPT09e/6l99qf1S08Y8JxjRzaU1LStYAJM0NpuKLbygKyreIv
        I/clyQguxSaAWuJFFQP3jzhGEcBg8uI=
X-Google-Smtp-Source: APiQypL+LeS+8HSQePGqZ2kElMZhjSSn6O18/rj4nXQWZq0A4XM15duJTAAhxGuugZWPx5CM/0Wf9A==
X-Received: by 2002:adf:a343:: with SMTP id d3mr485384wrb.163.1586197203241;
        Mon, 06 Apr 2020 11:20:03 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g186sm505137wme.7.2020.04.06.11.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 11:20:02 -0700 (PDT)
Date:   Mon, 6 Apr 2020 20:20:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Changing devlink port flavor dynamically for DSA
Message-ID: <20200406182002.GD2354@nanopsycho.orion>
References: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
 <20200406180410.GB2354@nanopsycho.orion>
 <2efae9ae-8957-7d52-617a-848b62f5aca3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2efae9ae-8957-7d52-617a-848b62f5aca3@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 06, 2020 at 08:11:18PM CEST, f.fainelli@gmail.com wrote:
>
>
>On 4/6/2020 11:04 AM, Jiri Pirko wrote:
>> Sun, Apr 05, 2020 at 10:42:29PM CEST, f.fainelli@gmail.com wrote:
>>> Hi all,
>>>
>>> On a BCM7278 system, we have two ports of the switch: 5 and 8, that
>>> connect to separate Ethernet MACs that the host/CPU can control. In
>>> premise they are both interchangeable because the switch supports
>>> configuring the management port to be either 5 or 8 and the Ethernet
>>> MACs are two identical instances.
>>>
>>> The Ethernet MACs are scheduled differently across the memory controller
>>> (they have different bandwidth and priority allocations) so it is
>>> desirable to select an Ethernet MAC capable of sustaining bandwidth and
>>> latency for host networking. Our current (in the downstream kernel) use
>>> case is to expose port 5 solely as a control end-point to the user and
>>> leave it to the user how they wish to use the Ethernet MAC behind port
>>> 5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
>>> disabled. Port 5 of that switch does not make use of Broadcom tags in
>>> that case, since ARL-based forwarding works just fine.
>>>
>>> The current Device Tree representation that we have for that system
>>> makes it possible for either port to be elected as the CPU port from a
>>> DSA perspective as they both have an "ethernet" phandle property that
>>> points to the appropriate Ethernet MAC node, because of that the DSA
>>> framework treats them as CPU ports.
>>>
>>> My current line of thinking is to permit a port to be configured as
>>> either "cpu" or "user" flavor and do that through devlink. This can
>>> create some challenges but hopefully this also paves the way for finally
>>> supporting "multi-CPU port" configurations. I am thinking something like
>>> this would be how I would like it to be configured:
>>>
>>> # First configure port 8 as the new CPU port
>>> devlink port set pci/0000:01:00.0/8 type cpu
>>> # Now unmap port 5 from being a CPU port
>>> devlink port set pci/0000:01:00.0/1 type eth
>> 
>> You are mixing "type" and "flavour".
>> 
>> Flavours: cpu/physical. I guess that is what you wanted to set, correct?
>
>Correct, flavor is really what we want to change here.
>
>> 
>> I'm not sure, it would make sense. The CPU port is still CPU port, it is
>> just not used. You can never make is really "physical", am I correct? 
>
>True, although with DSA as you may know if we have a DSA_PORT_TYPE_CPU
>(or DSA_PORT_TYPE_DSA), then we do not create a corresponding net_device
>instance because that would duplicate the Ethernet MAC net_device. This
>is largely the reason for suggesting doing this via devlink (so that we
>do not rely on a net_device handle). So by changing from a
>DSA_PORT_TYPE_CPU flavor to DSA_PORT_TYPE_USER, this means you would now
>see a corresponding net_device instance. Conversely when you migrate
>from DSA_PORT_TYPE_USER to DSA_PORT_TYPE_CPU, the corresponding
>net_device would be removed.

Wait, why would you ever want to have a netdevice for CPU port (changed
to "user")? What am I missing? Is there a usecase, some multi-person
port?


>
>Or maybe we finally bite the bullet and create net_device representors
>for all port types...
>
>> 
>> 
>> btw, we already implement port "type" setting. To "eth" and "ib". This
>> is how you can change the type of fabric for mlx4 driver.
>> 
>> 
>>>
>>> and this would do a simple "swap" of all user ports being now associated
>>> with port 8, and no longer with port 5, thus permitting port 5 from
>>> becoming a standard user port. Or maybe, we need to do this as an atomic
>>> operation in order to avoid a switch being configured with no CPU port
>>> anymore, so something like this instead:
>>>
>>> devlink port set pci/0000:01:00.0/5 type eth mgmt pci/0000:01:00.0/8
>>>
>>> The latter could also be used to define groups of ports within a switch
>>> that has multiple CPU ports, e.g.:
>>>
>>> # Ports 1 through 4 "bound" to CPU port 5:
>>>
>>> for i in $(seq 0 3)
>>> do
>>> 	devlink port set pci/0000:01:00.0/$i type eth mgmt pci/0000:01:00.0/5
>>> done
>>>
>>> # Ports 7 bound to CPU port 8:
>>>
>>> devlink port set pci/0000:01:00.0/1 type eth mgmt pci/0000:01:00.0/8
>> 
>> It is basically a mapping of physical port to CPU port, isn't it?
>> 
>> How about something like?
>> devlink port set pci/0000:01:00.0/1 cpu_master pci/0000:01:00.0/5
>> devlink port set pci/0000:01:00.0/2 cpu_master pci/0000:01:00.0/5
>> devlink port set pci/0000:01:00.0/7 cpu_master pci/0000:01:00.0/8
>> 
>> If CPU port would have 0 mapped ports, it would mean it is disabled.
>> What do you think?
>
>Yes, this makes sense.
>-- 
>Florian

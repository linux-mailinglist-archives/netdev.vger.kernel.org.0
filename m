Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A150519EE15
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgDEUmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 16:42:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52614 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgDEUmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 16:42:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id t203so4139552wmt.2
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 13:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:autocrypt:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=HFVcFquFzZtFkoYbcAS2OitZ4/Jgoq5tK65kPExzKzo=;
        b=WpddIZ66qPagyqfK1AXY82Dff6ug5Bn3c9jnB4jx3zg3ecPCmF4nhLvT6eRBb7Qy6q
         8BkX04FIZgYl+QDCHhTBlBht3Q55jsZxt5nE7TbiYmWiw5vYkZ6afgR3cOqwMgq1rzSd
         xA3Oo6si/CLqm8V/FWpRigEeQDjVqkiRE06F0dIcSC1ZZjPIW3BgVmtyTtJygk7duRUW
         1VQt8rHllrjq4/3PI2iB21l4m9sVKMo+Q7LxNZTwdGKpWxdDaLf8rVUx0eVmPKIbGTPN
         xGKcC8bJx7uVikSQnGi8Kvc3tmGWfIpq75IQHLc6Kmwqj2EvBXOiGEyLdkfDsgCiHkLy
         5YEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=HFVcFquFzZtFkoYbcAS2OitZ4/Jgoq5tK65kPExzKzo=;
        b=gMeewu6J4ellX6dKJzBcbZY831xJHpP5CWgXiihk6C24mj4yN51eYRBNUioBSW3A3H
         NMrfoKcTB4K+R1ecxenG6jFUgvEvgURBgPiy4MPGeh0dJYvo/GtRSKR4sM4kVo6vuafg
         +YDEEc/skbtANXDzRI7iytKic669PqLUmx9JxRzzTXxByheaDbaORZ9w5VZTXtbK2p0i
         04XDrESpCFc9f2RLh72y3uD4A1JkuQYVGdTk4NelK0BzJCw7fWWPaFUS4TL86cOMDSu3
         X48T4oM0dU+a0g0CxvpcD9mhP4ldOd0Dy0ra7uwYcRPF0yRDVnNV57I8Q4p2/Dq8LeqO
         2epQ==
X-Gm-Message-State: AGi0PuaxHgnZlz7m+v6yb5eMXBGJs5tfcts8wRq0mdSrsTVaN8y61tcV
        ngOfIFw1giwZAyTtaEFXA7k=
X-Google-Smtp-Source: APiQypKrsX5s6XkdBIWVQ5ynKmSd+DmTCAFpP+0IpNwtaldrnUUU96sKSa6XgM5YiHIwvmkLj3QLHA==
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr2366657wmn.81.1586119353068;
        Sun, 05 Apr 2020 13:42:33 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n1sm10398839wrw.52.2020.04.05.13.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 13:42:32 -0700 (PDT)
To:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Changing devlink port flavor dynamically for DSA
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <ef16b5bb-4115-e540-0ffd-1531e5982612@gmail.com>
Date:   Sun, 5 Apr 2020 13:42:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On a BCM7278 system, we have two ports of the switch: 5 and 8, that
connect to separate Ethernet MACs that the host/CPU can control. In
premise they are both interchangeable because the switch supports
configuring the management port to be either 5 or 8 and the Ethernet
MACs are two identical instances.

The Ethernet MACs are scheduled differently across the memory controller
(they have different bandwidth and priority allocations) so it is
desirable to select an Ethernet MAC capable of sustaining bandwidth and
latency for host networking. Our current (in the downstream kernel) use
case is to expose port 5 solely as a control end-point to the user and
leave it to the user how they wish to use the Ethernet MAC behind port
5. Some customers use it to bridge Wi-Fi traffic, some simply keep it
disabled. Port 5 of that switch does not make use of Broadcom tags in
that case, since ARL-based forwarding works just fine.

The current Device Tree representation that we have for that system
makes it possible for either port to be elected as the CPU port from a
DSA perspective as they both have an "ethernet" phandle property that
points to the appropriate Ethernet MAC node, because of that the DSA
framework treats them as CPU ports.

My current line of thinking is to permit a port to be configured as
either "cpu" or "user" flavor and do that through devlink. This can
create some challenges but hopefully this also paves the way for finally
supporting "multi-CPU port" configurations. I am thinking something like
this would be how I would like it to be configured:

# First configure port 8 as the new CPU port
devlink port set pci/0000:01:00.0/8 type cpu
# Now unmap port 5 from being a CPU port
devlink port set pci/0000:01:00.0/1 type eth

and this would do a simple "swap" of all user ports being now associated
with port 8, and no longer with port 5, thus permitting port 5 from
becoming a standard user port. Or maybe, we need to do this as an atomic
operation in order to avoid a switch being configured with no CPU port
anymore, so something like this instead:

devlink port set pci/0000:01:00.0/5 type eth mgmt pci/0000:01:00.0/8

The latter could also be used to define groups of ports within a switch
that has multiple CPU ports, e.g.:

# Ports 1 through 4 "bound" to CPU port 5:

for i in $(seq 0 3)
do
	devlink port set pci/0000:01:00.0/$i type eth mgmt pci/0000:01:00.0/5
done

# Ports 7 bound to CPU port 8:

devlink port set pci/0000:01:00.0/1 type eth mgmt pci/0000:01:00.0/8

Let me know what you think!

Thanks
-- 
Florian

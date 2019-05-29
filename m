Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C6C2D359
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfE2Bci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:32:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46532 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfE2Bci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:32:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id y11so452769pfm.13
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=it9dsvvDrxSVT1Uaee0cKztRQVHdCcEGkv2wc6YmDt4=;
        b=SLMQqHIQHkINUHhZals9Hfn3sJwgh0ENzQSS0sjnxmXnD2LNplHWARAQrNTQToitFS
         dSUFtDQ5iD4tLWgX+fA1LpuZL8pxTz4/UIP8SYWMEsxdtseskpWg8ryLDH5YbQPVxs01
         rV64gunch+srSdJ2LTs+IawPrrj1xLZNyBTaukjeq3fQFzcbfJD20W/N73wLs0VYG/mV
         yGstKtut/KbRR8ZsCl4DtCTsECtMsOgmwpWb+Qe4CYp5PvrmHWwFaZhqZkK02AYjarB2
         yFC2bi6rx4/v0/drTjWBWlwB1uElkKECxLcvT83RO//NoTXD5JiLDCJj58KGEJ7kF2HR
         OE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=it9dsvvDrxSVT1Uaee0cKztRQVHdCcEGkv2wc6YmDt4=;
        b=ljY6eP6Be9RK9BdUajJjLmc2zG4nMuSu78v2Wjaiqd4onbG5DUYhFxwi+76b8W+ObR
         gom7Tc3SMoYE0+utnEWHp0JYxRyLszfRvLvRiAntrxFeX/G20CLq+VUzkWqEs9D/g5UC
         pue45bUB//e9NiBmMSZNAJUBTF2ZPt1Zxk8IOMuA4OekJqKOERFZy9wwnuAxLd+u0PV6
         j2oJGTnxjIH2AxwgDViugc/b7H4rwto+qDSCEfrceSDsFvueZtzSj9qidYmsZKdA4Gc0
         eu2Mco/mnWbS5ok3WLtpd3C/gPTSMmHFfUFV9pBbN9zeet8C+1O4QosY5AJH2wg5MKzr
         hyyA==
X-Gm-Message-State: APjAAAX4ZlJxXJJS8W1xhwu4C9YkdRvVvmW6yjoY3rvVuL+J4lq4dtbY
        XU4SMnnSod/SYIjndd/kDGa+hyVO
X-Google-Smtp-Source: APXvYqw5aha7Qn+aOrrosU1Sk8tJjGMYa/dbq8RWiKCT8QncIK2tl0Xj7H+9UwC+s3my/g7hF1k9qg==
X-Received: by 2002:a17:90a:65c7:: with SMTP id i7mr9269926pjs.32.1559093557579;
        Tue, 28 May 2019 18:32:37 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o66sm3570027pje.8.2019.05.28.18.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:32:36 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 00/12] Add drop monitor for offloaded data
 paths
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20190528122136.30476-1-idosch@idosch.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5a96c7ca-0434-bed4-ef68-84b4f4d7dace@gmail.com>
Date:   Tue, 28 May 2019 18:32:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/2019 5:21 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Users have several ways to debug the kernel and understand why a packet
> was dropped. For example, using "drop monitor" and "perf". Both
> utilities trace kfree_skb(), which is the function called when a packet
> is freed as part of a failure. The information provided by these tools
> is invaluable when trying to understand the cause of a packet loss.
> 
> In recent years, large portions of the kernel data path were offloaded
> to capable devices. Today, it is possible to perform L2 and L3
> forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> Different TC classifiers and actions are also offloaded to capable
> devices, at both ingress and egress.
> 
> However, when the data path is offloaded it is not possible to achieve
> the same level of introspection as tools such "perf" and "drop monitor"
> become irrelevant.
> 
> This patchset aims to solve this by allowing users to monitor packets
> that the underlying device decided to drop along with relevant metadata
> such as the drop reason and ingress port.
> 
> The above is achieved by exposing a fundamental capability of devices
> capable of data path offloading - packet trapping. While the common use
> case for packet trapping is the trapping of packets required for the
> correct functioning of the control plane (e.g., STP, BGP packets),
> packets can also be trapped due to other reasons such as exceptions
> (e.g., TTL error) and drops (e.g., blackhole route).
> 
> Given this ability is not specific to a port, but rather to a device, it
> is exposed using devlink. Each capable driver is expected to register
> its supported packet traps with devlink and report trapped packets to
> devlink as they income. devlink will perform accounting of received
> packets and bytes and will potentially generate an event to user space
> using a new generic netlink multicast group.
> 
> While this patchset is concerned with traps corresponding to dropped
> packets, the interface itself is generic and can be used to expose traps
> corresponding to control packets in the future. The API is vendor
> neutral and similar to the API exposed by SAI which is implemented by
> several vendors already.
> 
> The implementation in this patchset is on top of both mlxsw and
> netdevsim so that people could experiment with the interface and provide
> useful feedback.

This is not particularly useful feedback but I found very little to
comment on because you have covered a lot of ground here.

What you propose is entirely reasonable and seems perfectly adequate to
report the Broadcom tags reason code (RC) (there are only a few reason
codes) within DSA. I don't know if other tagging formats may allow
similar information to be reported.

Looking forward to the non-RFC version!
-- 
Florian

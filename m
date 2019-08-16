Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1C90A75
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 23:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfHPVtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 17:49:02 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:44098 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfHPVtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 17:49:02 -0400
Received: by mail-pg1-f177.google.com with SMTP id i18so3557180pgl.11
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 14:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ByZkPxXyKGaEO1zs6euDN9HfYuTacfUk6zDml3LORtA=;
        b=ZWFtJj2kv81V4X5MJhjd8ndJJwgDXtzlE2NZyzfuIvfH4ENGgbimDKFFkg86JQrKtg
         6HgMKECCMHzm2idm//fAMFnEMo7zwd88n23WlOB4o31LvTn9Md83I3ZWspRyHsc5H1QV
         jYig2lT487zCaxdolXKscASf9bEPhCEgzMpxapcsUG0RQPD9qijw5eCw795Vr4y3NmBA
         yBZJs5QElarTo/hxYXwtVg4LIBDwQKp38yEJjYovcf/ABzXKBWQLuwRE3ExQy+bXRScn
         vM8zGTGJCZhBx4VB+PpjTtUkAx2bRRWROcv1sG1CAsP6Z302YUNkCQS2YPWHRNC1jLLp
         yOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ByZkPxXyKGaEO1zs6euDN9HfYuTacfUk6zDml3LORtA=;
        b=N3OGXpexXbK7ACv+siNWyQiiioug1DnNGkud5PbG7q7dNmLksV84ne65+b5scPeh5x
         71Q/Omgnrxst4YTVnCzaqtP2QJCiAS3e0fg/RQhtllWc+61vxN4bcUl4stLXWyGhBvN7
         dzMwCrAR3UlFEK+oFwmsX8dxzL3H5XLYA65ZqO3ir2YuB7NPayKLwSmkesU4v0Mc+WB4
         WohXFYxVy37X+EwnGN/sxy4iz/tEwzfFwEMgqqvTjx8RECanqVLHbbRiBvRJsPdSRt0+
         ALZltKFzcouxd21eKRR5buiK1FpMQo2gsLo+eZJJaCjOER1qhKJ37YtrowK0OOBAw+M6
         7Nvg==
X-Gm-Message-State: APjAAAXjHwvHMl6DwpGcZs0rv2IUCno29BXZ9mnEgDAsXCLzb68OH8nF
        Jllu2jwco/MQJt+OmeQ42rw5I75nPv4=
X-Google-Smtp-Source: APXvYqwVr+GnisM3j01CTd6eewDKwWz89HmB75FL8r4dJ0oUhRhN+EjToSPvFd0KHaqgPVOeUEsx/Q==
X-Received: by 2002:a65:4489:: with SMTP id l9mr9776950pgq.207.1565992141587;
        Fri, 16 Aug 2019 14:49:01 -0700 (PDT)
Received: from [172.27.227.212] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k5sm8448296pfg.167.2019.08.16.14.49.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 14:49:00 -0700 (PDT)
Subject: Re: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
 <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
 <ca625841-6de8-addb-9b85-8da90715868c@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e3f2990e-d3d0-e615-8230-dcfe76451c15@gmail.com>
Date:   Fri, 16 Aug 2019 15:48:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <ca625841-6de8-addb-9b85-8da90715868c@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 3:28 PM, Ben Greear wrote:
> On 8/16/19 12:15 PM, David Ahern wrote:
>> On 8/16/19 1:13 PM, Ben Greear wrote:
>>> I have a problem with a VETH port when setting up a somewhat complicated
>>> VRF setup. I am loosing the global IPv6 addr, and also the route,
>>> apparently
>>> when I add the veth device to a vrf.  From my script's output:
>>
>> Either enslave the device before adding the address or enable the
>> retention of addresses:
>>
>> sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
>>
> 
> Thanks, I added it to the vrf first just in case some other logic was
> expecting the routes to go away on network down.
> 
> That part now seems to be working.
> 

The down-up cycling is done on purpose - to clear out neigh entries and
routes associated with the device under the old VRF. All entries must be
created with the device in the new VRF.

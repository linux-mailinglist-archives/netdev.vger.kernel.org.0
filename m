Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732F81299B6
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfLWSCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:02:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45868 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfLWSCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:02:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so9512777pfg.12
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cGn0v8jkHpoTLOim1N0kRmJ0qeuwtzFZ+NDDJpX/U6c=;
        b=gMMMYKfKtxz1/N2Ev1Ymwq34bYA8/bFtVx5R4DXeMiVkGaqkyIaZTL7ucnAnt/vHtc
         ZwfILHjJFmRiVKAaCM3afda16n2X9jqHvxHgBzpT1SszSXa4Y05wLHIQcdjC6szJsHYi
         WD/xMBOaOyBoaLRu+auZ8z7h647oMiWIPHeQsPQzLbGpyABjxO3yAVT2jhpTz62Q5mzw
         /s/KYaQj1ZgK+nGBycmxvvpXiKHTso9Y+bkQ5nBI5o1iB4ykNysjLR4G9RjbnonHZjAE
         1earW8gfNvUCky/hzS2rUSR3s+nMFDxHluDROLsHasXdKie2u0ea4lsWuwCGeUJntr0C
         oe0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cGn0v8jkHpoTLOim1N0kRmJ0qeuwtzFZ+NDDJpX/U6c=;
        b=iNLnDvkxJwQNdii+TdeceAV7XPMUmj3vw3VUW3j69ZJLa8BzM14mPDu/vw/vFfqRg1
         /3xqeGCNB/yfMFlo26L7vUHA0V5VsNrXRMECNCRtAxob7zGGRjmEGtFzafQCdzY/flTr
         fksZ1S9gKmusKb9TeDHWCedLSZHn1mOPfKqi8zlK7YDXH0YFkNvFIWSXsxxg3BvOBjBq
         jeuEcDzpoWYhpXVdFTS9Kk9u0VKut0UJtOge6w6pl3CbPdFnpzUZAR0dXgFoe/TUL+fi
         SuvLwSy1ovlElKaTRr/wgX2Sk2rmgHGbdsrJb0ZG6v8dMIBrrX0aD4Z8EWh1+HABbZA/
         ZJCw==
X-Gm-Message-State: APjAAAXMBFw2WNKCn14b3n+4CnfBdVpHl+Yg0bkDljXkdQVqD0CkP/gS
        Ba7q3Ucwu+snb7I+2TQQPyw=
X-Google-Smtp-Source: APXvYqwmh0ips1/V5543MhZJt3VQPLXlWd9ln+TQ6mz4VldKxrhvy2Eig10g745BAdEOilh8qThhGA==
X-Received: by 2002:a63:31d0:: with SMTP id x199mr33298176pgx.286.1577124134233;
        Mon, 23 Dec 2019 10:02:14 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x8sm25532754pfd.76.2019.12.23.10.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 10:02:13 -0800 (PST)
Subject: Re: [RFC 3/3] net: dsa: mv88e6xxx: fix vlan setup
To:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <E1ij6pq-00084C-47@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <562d2a65-8361-9361-f761-082ace3a77bc@gmail.com>
Date:   Mon, 23 Dec 2019 10:02:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <E1ij6pq-00084C-47@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Ido,

On 12/22/2019 11:24 AM, Russell King wrote:
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Provide an option that drivers can set to indicate they want to receive
> vlan configuration even when vlan filtering is disabled. This is safe
> for Marvell DSA bridges, which do not look up ingress traffic in the
> VTU if the port is in 8021Q disabled state. Whether this change is
> suitable for all DSA bridges is not known.

s/DSA bridges/DSA switches/ ?

this is also safe to do with b53 switches in fact this is even desirable
because VLAN filtering is a global attribute so if you have at least one
bridge that spans one of your switch ports and that bridge requests
vlan_filtering=1, you *must* have a valid VID entry for the non-bridged
ports, or the bridged ports with vlan_filtering=0 otherwise there is no
default VID entry programmed to ingress the frame. Today this is
achieved by making sure that the default untagged VID 0 for non bridged
ports is always programmed at start-up and the switch is always
configured with VLAN awareness.

> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

This ties in with this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2ea7a679ca2abd251c1ec03f20508619707e1749

which I believe is still correct in the sense that with Linux a bridge
with vlan_filtering=0 also means that the bridge is not VLAN aware. Ido,
Jiri, do you disagree?

This seems to be coming every now and then, so maybe it is time to
revisit this documentation patch:

https://github.com/ffainelli/linux/commit/3fe61b1722a3b79d2e317a812c54f3afc902e5b0
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DF43A0604
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhFHV3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:29:39 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:39627 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhFHV3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:29:37 -0400
Received: by mail-pj1-f52.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so133779pjp.4;
        Tue, 08 Jun 2021 14:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=21bQniRrdFMnC4ruIgRd4eRSDPTkeTGogSrj3wCHmjQ=;
        b=UfBm2W1CH7llLiVia0XMgalmHVCUmz4CLcmbarUgx/rPi1qI7QVf9Nmf0KgCl/4kOk
         uujkSs8MvOjh92kN8ez7JHU9IGKmI6Nx8Rdw5LrQm0P9n9+1rJBbbTA+DkE+0yYGPGIY
         w9mFvbWmNywPRqOTy/jC06uic9X2IXGoU/DM87skhBig3xpomMJ2O2l+WbN+oGyS39cJ
         T2UWQuv1i13GwT7+j5NXbWcei+5C+Eevly0yudYNsCSHO1qgvF71yCjm0qQW65gwwhW1
         MzVLDwLVJ1abZS/tOdsmuYOrwC2/KTK2Jg2H1NOv0cSkcpt8v+6wcD+cxVWfwDB4pNav
         G4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=21bQniRrdFMnC4ruIgRd4eRSDPTkeTGogSrj3wCHmjQ=;
        b=S0mJrbTuKqfBADWZ9BKbQVwWRA47DqN13u+73Hfd64aI0LF/ps5ZR1uWBMlLzJ/19p
         ob/sZTeEccZZiWrkuewtNYIk6G4daen8n0YFAvR4u9BVAS2aWCAbwp+qgwEJ8yvUSFSu
         7IGIVK085liXrlgjPnKTyK6x/sJzwSf8HaQ70xtAjz0GOR2ZgQK9ooEF0N+3xPxWUwbH
         aWgDO8Gj6oFpgO94F7thfEcQNqTTQczxN0KF4iji2CSEuFUwqlf6ZEQmbFeSe7eDNEQ8
         K/RSovJJWzdEjWMyC24Fi8edWsWB3AyhEo2Nb3TWwC84PnjrAeLTcbQn6dufQRuJT4Da
         HOyw==
X-Gm-Message-State: AOAM533JKY9dQ7Jn/8JySFpXdPTIH38WmGsMk5mrtyrjjlBG8KOp6DrE
        vnf5ssEwU/WZRSi/1869Zu8nf/0MnyY=
X-Google-Smtp-Source: ABdhPJw7zk3kD5y1yzsheeLeAq6zZWzA3HjOllrzJbR00Hpxm038gEGyXgQEwHUnfMF3NWDOvdWU/w==
X-Received: by 2002:a17:90b:3696:: with SMTP id mj22mr7197502pjb.124.1623187591445;
        Tue, 08 Jun 2021 14:26:31 -0700 (PDT)
Received: from [10.1.10.189] (c-69-181-195-191.hsd1.ca.comcast.net. [69.181.195.191])
        by smtp.gmail.com with ESMTPSA id h16sm11763207pfk.119.2021.06.08.14.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 14:26:31 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
To:     netdev@vger.kernel.org
Cc:     mnhagan88@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ddffc050-776f-9972-b729-a837a2a51b79@gmail.com>
Date:   Tue, 8 Jun 2021 14:26:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608212204.3978634-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/2021 2:22 PM, Florian Fainelli wrote:
> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
> VLANs") forced the CPU port to be always tagged in any VLAN membership.
> This was necessary back then because we did not support Broadcom tags
> for all configurations so the only way to differentiate tagged and
> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
> port into being always tagged.
> 
> With most configurations enabling Broadcom tags, especially after
> 8fab459e69ab ("net: dsa: b53: Enable Broadcom tags for 531x5/539x
> families") we do not need to apply this unconditional force tagging of
> the CPU port in all VLANs.
> 
> A helper function is introduced to faciliate the encapsulation of the
> specific condition requiring the CPU port to be tagged in all VLANs and
> the dsa_switch_ops::untag_bridge_pvid boolean is moved to when
> dsa_switch_ops::setup is called when we have already determined the
> tagging protocol we will be using.
> 
> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Matthew, here is a tcpdump capture showing that there is no VLAN 0 tag
being added, unlike before:

00:00:42.191113 b8:ac:6f:80:af:7e (oui Unknown) > 00:10:18:cd:c9:c2 (oui
Unknown), BRCM tag OP: EG, CID: 0, RC: exception, TC: 0, port: 0,
ethertype IPv4 (0x0800), length 102: (tos 0x0, ttl 64, id 25041, offset
0, flags [none], proto ICMP (1), length 84)
    192.168.1.254 > 192.168.1.10: ICMP echo reply, id 1543, seq 12,
length 64
        0x0000:  0010 18cd c9c2 b8ac 6f80 af7e 0000 2000  ........o..~....
        0x0010:  0800 4500 0054 61d1 0000 4001 947f c0a8  ..E..Ta...@.....
        0x0020:  01fe c0a8 010a 0000 4522 0607 000c 31c8  ........E"....1.
        0x0030:  8302 0000 0000 0000 0000 0000 0000 0000  ................
        0x0040:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0050:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0060:  0000 0000 0000

Let me know how this patch goes.
-- 
Florian

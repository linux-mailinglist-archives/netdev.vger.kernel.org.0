Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C700010C4E8
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfK1IWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 03:22:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39046 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfK1IWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:22:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so26807847wrt.6
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 00:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPyHkE/xlemi6rCp8JUhdM9TMa4vGSjDKh4lPExeQCo=;
        b=J8UmETHv38orrOYb0TTqKrNrSQ4cqwdmIiORyLBsbvTLDJEkdMZXO7O3+SvABe3rkU
         L6ZHUPdH2QOP7wSbsPeb6ixQCiYGGbphMD3yupiji/z2bmJgC/AGF3TGIY9xYqn9blA7
         5Ok9NLV1JLs6AnZB6Xkz5HL2NXuVAdpWxUAJn34jeBkFKLCi92VJkY0H7x0UI/aVLlf+
         Y1Im4RG94SM/PXWZ1bMDDD7KQ6ABkPoM36tXnN2RbMVw2nwWYMdvEn+Or765n+NmWRQ4
         6X7GGL9+GKtf24TEUq79+UDjSAsZ8s07R02Y2T+Vm66FJ8v1NuNE842cTwYmMDnSfsIb
         ZBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JPyHkE/xlemi6rCp8JUhdM9TMa4vGSjDKh4lPExeQCo=;
        b=We4JlWMoyctKk3aie0+z37+QTJcKMazVdfmZEnR3HF30G1nWjG7dOgeLLgbmZndmLo
         gT0x/eIVwCUcGk1vb52mc7QEmXvoQBBGG1qfJgeWbNJSKbfiMYd3kyhbeKL2jKxyoD4q
         1A52sxRJtgJGgz9KgrKE3jWjv+Y6yhSaHUaY2vUwu1cdfUTY+B4Vak1+McOhYmYncHXu
         UmfcP5bI4YbUqnwPk6+LTUdIHPl0JB+haFxxdDOICvQpaAyxFG4Rl+CWef1L4eNzHCK5
         di4raiDWyUdD7u3ZLV4dNOjwacTkw4ZC2JkdRlqO4V7DNuGdA2M4H8n0igDgi86HW+A4
         jheA==
X-Gm-Message-State: APjAAAVCHAYV1hZWBnQdHOcJQNUs9ib/zc0OEbIQtQ3mL5iRnoez6/c0
        2uU3S0IrnD1AkAOl6zAd4XJoZ6F/OzM=
X-Google-Smtp-Source: APXvYqzNunvWbU7bVVRiqPGhDWFBwBuqffvTBGkKnTfQj/3s1HECNvbWbEH4wjZR5NTEqjoD0lJFRw==
X-Received: by 2002:adf:fd45:: with SMTP id h5mr44894801wrs.388.1574929340640;
        Thu, 28 Nov 2019 00:22:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:ac7e:81e:c2cd:dd25? ([2a01:e0a:410:bb00:ac7e:81e:c2cd:dd25])
        by smtp.gmail.com with ESMTPSA id n188sm4426236wme.14.2019.11.28.00.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2019 00:22:19 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 1/2] openvswitch: support asymmetric conntrack
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <20191108210714.12426-1-aconole@redhat.com>
 <eb0bdc35-7f29-77c7-c013-e88f74772c24@6wind.com>
 <f7tsgmkyja6.fsf@dhcp-25.97.bos.redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <57c14a3f-25fa-76c3-d846-a616f198467e@6wind.com>
Date:   Thu, 28 Nov 2019 09:22:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <f7tsgmkyja6.fsf@dhcp-25.97.bos.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/11/2019 à 22:19, Aaron Conole a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
> 
>> Le 08/11/2019 à 22:07, Aaron Conole a écrit :
>>> The openvswitch module shares a common conntrack and NAT infrastructure
>>> exposed via netfilter.  It's possible that a packet needs both SNAT and
>>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
>>> this because it runs through the NAT table twice - once on ingress and
>>> again after egress.  The openvswitch module doesn't have such capability.
>>>
>>> Like netfilter hook infrastructure, we should run through NAT twice to
>>> keep the symmetry.
>>>
>>> Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
>>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>> In this case, ovs_ct_find_existing() won't be able to find the
>> conntrack, right?
> 
> vswitchd normally won't allow both actions to get programmed.  Even the
> kernel module won't allow it, so this really will only happen when the
> connection gets established via the nf_hook path, and then needs to be
> processed via openvswitch.  In those cases, the tuple lookup should be
> correct, because the nf_nat table should contain the correct tuple data,
> and the skbuff should have the correct tuples in the packet data to
> begin with.
> 
>> Inverting the tuple to find the conntrack doesn't work anymore with double NAT.
>> Am I wrong?
> 
> I think since the packet was double-NAT on the way out (via nf_hook
> path), then the incoming reply will have the correct NAT tuples and the
> lookup will happen just fine.  Just that during processing, both
> transformations aren't applied.
Ok, I didn't look deeply, thank you for the explanation.

Regards,
Nicolas

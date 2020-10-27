Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C6729B387
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 15:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900490AbgJ0OxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:53:01 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38644 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773099AbgJ0OvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:51:09 -0400
Received: by mail-io1-f67.google.com with SMTP id y20so1816999iod.5
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+2CkWRicBSTEfduKB3ujAK1bRQMe1d//wnZFkIWjH6M=;
        b=FAyAEgBzQITVQtpGkFqsRGcBFIK86HWelj7YZ9pbRQcBRZHqimxQNG8SQLBVjNXXCy
         W1mZ4d1gKlB09KtUjGWgEZtmYtrDKxDDT7AoqPiB/A+4rbCZ2HlONeZpqlZIxvSk8EWr
         Cy4SYz8AxlDBK06O82oXJnXYWqam9ibNEoOgqRPUKWrqvYIy8lDe2D5BU1aFpRX7yRCq
         SE+krFDvow4BSImJZHgGhSUsv8vYKT+BqeTG6TjX6sDkjdPiPjIGdDLxLKwOoTqLfUvS
         hDIghKu53RkwOEmfQmWtVsC0m+KD+uFEGsd5v97gmHB2TRwE40Fn4fOuyOUA6Rgbqz5h
         trhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+2CkWRicBSTEfduKB3ujAK1bRQMe1d//wnZFkIWjH6M=;
        b=fzMho5jVFblayUNNK/1XC0lGPC1hdalFR8i3TkqOyhC9PV2zm3qLMd8Mg/174Xu6lV
         ZE0kmyMogiJa1JRXpv7Ftx9weOZ7bJWBzKEzSZk6+8ld7u7+TjKTPFRbK4M8DzQMhFLx
         SB+euKbYmB5QN4eUPHGTs4QRCK1TLvDn2D4jIxK16ShWSq8xnLe9Lqm33U0AYUCJe2ot
         XSNnWXcoEy0FR4I003tYx652BHHOhxFCiVvT1vLRXCt5DKe3E/ZST6U9S5dRb9plIIW0
         KYFXbbwiNQZ6hGIEXqLCJEUsVOqIDvWYjPTM9t0W0GbVxROldHsl2bmyWXhHX0m4c4P/
         tloA==
X-Gm-Message-State: AOAM532RjKbr+G6MKBBlmg2RxIe325qvwW/e8+Alqc/Yc+1eQrHsrElB
        XqrThG5YhHtnVO9H2DM+ljc=
X-Google-Smtp-Source: ABdhPJzF2zBLibGrvL4MEHcd01UgNHlBBqHX1buNwBpjx8kVuArteO9GryxdyLT7fMwLEjHTG8NOyw==
X-Received: by 2002:a05:6638:531:: with SMTP id j17mr2820814jar.69.1603810268956;
        Tue, 27 Oct 2020 07:51:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f994:8208:36cb:5fef])
        by smtp.googlemail.com with ESMTPSA id c2sm988000iot.52.2020.10.27.07.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 07:51:08 -0700 (PDT)
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
To:     Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
 <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
 <20201026135626.23684484@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e24e490-b3bf-5268-4bd5-98b598b36b36@gmail.com>
Date:   Tue, 27 Oct 2020 08:51:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201026135626.23684484@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/20 2:56 PM, Jakub Kicinski wrote:
> On Mon, 26 Oct 2020 16:23:29 +0800 wenxu wrote:
>> On 10/24/2020 5:12 AM, Jakub Kicinski wrote:
>>> On Wed, 21 Oct 2020 17:21:55 +0800 wenxu@ucloud.cn wrote:  
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> The TUNNEL_DONT_FRAGMENT flags specific the tunnel outer ip can do
>>>> fragment or not in the md mode. Without the TUNNEL_DONT_FRAGMENT
>>>> should always do fragment. So it should not care the frag_off in
>>>> inner ip.  
>>> Can you describe the use case better? My understanding is that we
>>> should propagate DF in normally functioning networks, and let PMTU 
>>> do its job.  
>>
>> Sorry for relying so late.  ip_md_tunnel_xmit send packet in the collect_md mode.
>>
>> For OpenVswitch example, ovs set the gre port with flags df_default=false which will not
>>
>> set TUNNEL_DONT_FRAGMENT for tun_flags.
>>
>> And the mtu of virtual machine is 1500 with default. And the tunnel underlay device mtu
>>
>> is 1500 default too. So if the size of packet send from vm +  underlay length > underlay device mtu.
>>
>> The packet always be dropped if the ip header of  packet set flags with DF.
>>
>> In the collect_md the outer packet can fragment or not should depends on the tun_flags but not inner
>>
>> ip header like vxlan device did.
> 
> Is this another incarnation of 4cb47a8644cc ("tunnels: PMTU discovery
> support for directly bridged IP packets")? Sounds like non-UDP tunnels
> need the same treatment to make PMTUD work.
> 
> RFC2003 seems to clearly forbid ignoring the inner DF:

I was looking at this patch Sunday night. To me it seems odd that
packets flowing through the overlay affect decisions in the underlay
which meant I agree with the proposed change.

ip_md_tunnel_xmit is inconsistent right now. tnl_update_pmtu is called
based on the TUNNEL_DONT_FRAGMENT flag, so why let it be changed later
based on the inner header? Or, if you agree with RFC 2003 and the DF
should be propagated outer to inner, then it seems like the df reset
needs to be moved up before the call to tnl_update_pmtu

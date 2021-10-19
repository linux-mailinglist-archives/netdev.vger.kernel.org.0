Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB1433876
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhJSOgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhJSOgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:36:16 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8A1C06161C;
        Tue, 19 Oct 2021 07:34:03 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso2345091otl.4;
        Tue, 19 Oct 2021 07:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=um4VG0wSttoV2jjrNXpLYkSXZc1Ps/RyVkR4quX0t2Y=;
        b=g+hnYkRNnfmn0E+j2icUP6Jpb+7GwiQyeh73T9mdz03BONs7CZJzL8gx6yhDQtHChP
         pYE2jZr0rPkxz5Np5rAOxScx0c9Wyln+2m8aqtJxykoXA/I/8RuNKdFaWriraTLyHRTT
         ZlAVfQjj0jfGoLeQG+teHrcjUAgPt3XMDmtZEhdEuYmCbW84eQ6QLJ4jOwcICuXS+Fdd
         J6c4ocj7w/ETYEvuhGpBogIxKFWzV7OjPwnT1BIUFZDoaEWO67Z4O6ttmpAkQKUEH6BI
         uCJAVXoNkJgprnTBTspfDl9vUSoD5KENFTrIDyDHWRN2RovgGQKLmLUvw84A85m/TCqI
         IN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=um4VG0wSttoV2jjrNXpLYkSXZc1Ps/RyVkR4quX0t2Y=;
        b=n/51Q4rKEYutF5Hi9FAZoQPpxVrwTwIZ/kSD4Flpim0w/B1m+BdYsKhrgWHmHJzKTv
         deRjY2Fym+USnAwwVWPJ6br1cvcxndA52Xd/cN+F5Rjm4LTYQ/IinHVJJ13/+r248kWa
         FYGnKdvY5hinQu8/zYRiY+07fKpfcA7fjPj+vhFmG1ywmdWptBTZYYEMbMLGOx/zEHS8
         eGQoqUYMqM93qpaOGqLsPywMNiN0J4NCgj3/1LY52iErvrISl0uNgB1+DaL1iQHfRcKx
         bX/SZ72bcBvCCOTawmQQvlhwyukaTFnQmAAeC6Co8GbyuJtPDTw0S636KPWBPj1wWF1b
         S8eg==
X-Gm-Message-State: AOAM533jMCh8g24G1DM6588nPvFnG2hLvBkeOeD2YoRnIIp71b6gRtHi
        cqiNQfLkv9TWRc7B8cMfhNdeu/3buXk=
X-Google-Smtp-Source: ABdhPJxd7YqYTCuqcoKIjDKNoSrVLgxSJI5HlyhZj5g8MyFgSco2uDhHaQs+WHrKmauaOMG/uKzSIg==
X-Received: by 2002:a05:6830:2b11:: with SMTP id l17mr3116738otv.298.1634654043043;
        Tue, 19 Oct 2021 07:34:03 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id p14sm2978368oov.0.2021.10.19.07.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 07:34:02 -0700 (PDT)
Message-ID: <c0279807-2f5b-4fe4-d7f5-d545b95860a7@gmail.com>
Date:   Tue, 19 Oct 2021 08:34:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc> <20211015210448.GA5069@breakpoint.cc>
 <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
 <20211018143430.GB28644@breakpoint.cc>
 <a5422062-a0a8-a2bf-f4a8-d57eb7ddc4af@gmail.com>
 <20211019114939.GD28644@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211019114939.GD28644@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/21 5:49 AM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>> Thanks for the detailed summary and possible solutions.
>>
>> NAT/MASQ rules with VRF were not really thought about during
>> development; it was not a use case (or use cases) Cumulus or other NOS
>> vendors cared about. Community users were popping up fairly early and
>> patches would get sent, but no real thought about how to handle both
>> sets of rules - VRF device and port devices.
>>
>> What about adding an attribute on the VRF device to declare which side
>> to take -- rules against the port device or rules against the VRF device
>> and control the nf resets based on it?
> 
> This would need a way to suppress the NF_HOOK invocation from the
> normal IP path.  Any idea on how to do that?  AFAICS there is no way to
> get to the vrf device at that point, so no way to detect the toggle.
> 
> Or did you mean to only suppress the 2nd conntrack round?

My thought was that the newly inserted nf_reset_ct fixed one use case
and breaks another, so the new attribute would control that call.

> 
> For packets that get forwarded we'd always need to run those in the vrf
> context, afaics, because doing an nf_reset() may create a new conntrack
> entry (if flow has DNAT, then incoming address has been reversed
> already, so it won't match existing REPLY entry in the conntrack table anymore).
> 
> For locally generated packets, we could skip conntrack for VRF context
> via 'skb->_nfct = UNTRACKED' + nf_reset_ct before xmit to lower device,
> and for lower device by eliding the reset entirely.
> 

ok.

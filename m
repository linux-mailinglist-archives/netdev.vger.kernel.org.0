Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C632FA7EA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407301AbhARRvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407171AbhARRuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:50:08 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7880DC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:49:28 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id s19so4289518oos.2
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jjpWpjRiXX2CNn8acfTa3iyawNrVbE7FJe6CcHRO2PY=;
        b=p/AvS338y6SbLP1rTcAU1jnNjZeoIEW+0juUg50Nkn4LaweXiEkJkmQHqV82YTDjwm
         SfKuDOM1LacTn0ayPcyR5AgyTGtHezjohFMFbF427ZAH3iJnVDeM21dX6reEpBNP53fW
         wAMxilfJyGntIeG5myrqduVNIHuGP4uylzfpQQSUCX78SlvIZaVpMZpnZRmEZVURhkJI
         Jn1s8bShvqyIhqq4cP9KdRrfXbpG8EvJzvBBYMjo6Rr5XNMHIt8r6c1Uuj8aBMJ3ypeQ
         PUhP6ZFbsv51snm4517acz9Q2e8FFIEeZudGScMsoyNxTwPm7kXv3SLGvdV0uzl2fOQT
         MSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjpWpjRiXX2CNn8acfTa3iyawNrVbE7FJe6CcHRO2PY=;
        b=g54bCsEBrahX0qi6gXL983JGJ1JpjnJBdFRF/NezT9AxxJYQk0RyMy9WKv1AupJ5iv
         k4ezbc6vUsCFPiturLWIdTWfgLlnNhf6H+/qPONrz8pMujz76DhRf+Sn0rYqgZUjRf5v
         5aiwX3dTIIfncLGEqfA9kFfq6c8RcGoDEtGdy8dFru1T3H5GfBisUMo1iI3YOtGx90vd
         RC917ev5RcPwbjEDPhuqe0EDnlSxHeqzaT4zLvgiShqpiOu/oz2PSAVUrEaaMhckTqwP
         SO4Bf+D84TYLWptJOo32RbsKqbp+P0x9poAVoXCVRt9rLNhxjl/o62c+II0Kb5sNXnMx
         +l1Q==
X-Gm-Message-State: AOAM531uUm6F5LHUFRD8bumRKE4cNsoJiwdPDC2E4fuNRol/QotHisXB
        84BwIimMgu4zbwpb9Kv2qBE=
X-Google-Smtp-Source: ABdhPJy2huqfEi3LgiUQ7rCUzbmf+zD4o7q/qy+EciDmfO2q8C4qzX6LphR6ljFju61GM5V9HhvENA==
X-Received: by 2002:a05:6820:131:: with SMTP id i17mr181153ood.43.1610992167976;
        Mon, 18 Jan 2021 09:49:27 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.8])
        by smtp.googlemail.com with ESMTPSA id 186sm3715071ood.6.2021.01.18.09.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:49:27 -0800 (PST)
Subject: Re: [PATCH iproute2] iplink: work around rtattr length limits for
 IFLA_VFINFO_LIST
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
References: <20210115225950.18762-1-edwin.peer@broadcom.com>
 <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210116211223.xhurmrb2tqlffr7z@lion.mk-sys.cz>
 <20210116172119.2c68d4c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <807bb557-6e0c-1567-026c-13becbaff9c2@gmail.com>
 <CAKOOJTyD-et6psSo0v-zvycFpJCLLmdSCr792OQzx_cLM2SjLw@mail.gmail.com>
 <fee064d8-f650-11b8-44b4-55316aec60d3@gmail.com>
 <CAKOOJTwSc6TppMu5+2n5boh7bz8vwAC2d7zpODzn9-ZYJyyTyQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <155ba7e5-2344-f868-73cf-f43169b841a9@gmail.com>
Date:   Mon, 18 Jan 2021 10:49:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKOOJTwSc6TppMu5+2n5boh7bz8vwAC2d7zpODzn9-ZYJyyTyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 10:42 AM, Edwin Peer wrote:
> On Mon, Jan 18, 2021 at 9:36 AM David Ahern <dsahern@gmail.com> wrote:
> 
>>> Assuming we fix nla_nest_end() and error in some way, how does that
>>> assist iproute2?
>>
>> I don't follow. The kernel is sending a malformed message; userspace
>> should not be guessing at how to interpret it.
> 
> The user isn't going to care about this technicality. If the kernel
> errors out here, then the user sees zero VFs when adding one more VF.
> That's still a bug, even though the malformed message is fixed. An API
> bug is still a bug, except we seemingly can't fix it because it's
> deprecated.
> 

Different bug, different solution required. The networking stack hits
these kind of scalability problems from time to time with original
uapis, so workarounds are needed. One example is rtmsg which only allows
255 routing tables, so RTA_TABLE attribute was added as a u32. Once a
solution is found for the VF problem, iproute2 can be enhanced to
accommodate.

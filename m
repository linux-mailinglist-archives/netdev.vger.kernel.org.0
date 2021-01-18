Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BF22FA7B2
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407219AbhARRkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407153AbhARRiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:38:02 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A961C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:36:59 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id i30so4106008ota.6
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fRdvMY29fOg7ZGphNHO2Qhb/dqCel2iQzk7CtfiDvTY=;
        b=kLjzCjIaqZTJgStTFAwp7iiuQkG6XPksq840eLne9dPMKOnNWsMioo7B+TT6wYUQeP
         kfBHWlNt+LZpeN7YKq6oGRNJ2QoCk0Brq2a8/BHqhb+J48WgFiDwyNAUgv4FdqE04AVz
         nol/g/96A6WW0DFcUqK75XjGyzIGhIhMjSD5ELFbXpzfSUM1RHmEC6YGX4Z3yHIyhxq1
         tiLHwY9RT1jPIC5n0S0fP+RdGsJhl41YiYUo+QEDB+7UJ7ETuDC06pz2sCNPub9m/uzD
         kl5cl9sNvkQYQy4xYtv0nkK7FG8WFtQD3jGlRf7hlU5uxIdz2V5EfZsqdlxVBrYBCfI+
         wrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fRdvMY29fOg7ZGphNHO2Qhb/dqCel2iQzk7CtfiDvTY=;
        b=V/3UL+9P/7OxJ2oXGOzWor6StGPGijw5ft+nEuGziX6AJd5A49GB40F6HSKgKsSEG8
         wH3eNtLHEt7Uafg6cdrds53akMhti5rX28O8jOThzNzP6WQfckOPWvSLV7U8cRO7HROS
         Kdw4W7SsCiyk0BVm2S1N9cIy5Zevb6PbefI+VeFbAPZT3G1r+JKkxWdat7OwvNXr0Qcg
         3ZZVJesgbxw2fnJwarBJ5a/re2Ft71qNKFeF/ZZUGPBeHPvJAbKQvupjRH1K4zSnLR7W
         o691V7N0AQHaZAekL3KEELhkESSrH0a/3QEtosnZgejQynZolG+LWm27QyCtNJHVGc8c
         oRRA==
X-Gm-Message-State: AOAM530SdbyX3im2ShG501lIV2Xv3J4FcS1WpwjMcRCFt/El301xO0Ox
        RoFTyJBvb7gNCKbGRWUPltw=
X-Google-Smtp-Source: ABdhPJyHxmpoP8Yd9pZ3L/+ZCAx3HXWuMkkhmMcFY19VffMTYJvPGhqhCElSVi4RRbKsKuveKJpI4A==
X-Received: by 2002:a9d:6d91:: with SMTP id x17mr480763otp.16.1610991418770;
        Mon, 18 Jan 2021 09:36:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.46])
        by smtp.googlemail.com with ESMTPSA id s2sm799620otk.45.2021.01.18.09.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:36:58 -0800 (PST)
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fee064d8-f650-11b8-44b4-55316aec60d3@gmail.com>
Date:   Mon, 18 Jan 2021 10:36:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKOOJTyD-et6psSo0v-zvycFpJCLLmdSCr792OQzx_cLM2SjLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 10:34 AM, Edwin Peer wrote:
> On Sun, Jan 17, 2021 at 7:48 PM David Ahern <dsahern@gmail.com> wrote:
> 
>> IMHO this is a kernel bug that should be fixed. An easy fix to check the
>> overflow in nla_nest_end and return an error. Sadly, nla_nest_end return
>> code is ignored and backporting any change to fix that will be
>> nightmare. A warning will identify places that need to be fixed.
> 
> Assuming we fix nla_nest_end() and error in some way, how does that
> assist iproute2?
> 

I don't follow. The kernel is sending a malformed message; userspace
should not be guessing at how to interpret it.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A84461FE8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbhK2TM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244800AbhK2TK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:10:56 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C32C052920
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:30:18 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id o4so35250396oia.10
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Syr0ONfCYHbV19iNYE6IrWYtIUc2TwPwgKVevnNHbTY=;
        b=c++sGWRpKYT+Ycv64f39xVz+jy0Rn1TNcq69P1h0PDSiITJMTmUMlfIB1Y/8+d3x1s
         GhI664exFRZwaN9VG43cemgf4xDkx53HCEjg9UpL8Ki0fJdhYziAK74mABUSDyxWLZdQ
         ty4JNRzgF1NLSQOTyPvQyQ5TKzMNPzeEfV5r1Xc1CHDdiSYC2xH/UqnS0drTJ08k+a6k
         ZYrDyvIeRvPtoVm8s7Jnu/qnEbnPqSDzOl7ZaEL2zInCfYLPyw5K1amIFv8/K5KijjAs
         LAXrWbhvhMo0IOGOmQkiKZYCxSoENn1PUNBQjHPv51wg7Ft4vZdunyN1gFBRPa747j62
         yqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Syr0ONfCYHbV19iNYE6IrWYtIUc2TwPwgKVevnNHbTY=;
        b=s86VEdl1wViuoVPL53cyiks8mOf0Romvt1QDuOWsGv5cYdW7a+i22Xt7/DT7TizxT1
         aK/hDi9E5hu01XL25y54w3RyYtvYvTg4MKjl0xNuankV1peb4yEk7Yfz2QlW1NUL4RGO
         t6+lgqpmL6nyY0UdLGEwWIV4d3mf7IujGjLnBwY1HXIF47QOxk43kIhWpWYc+KhPoVsJ
         eRGEB2QXmkNyO4rgKl54bse2rDDVyZnfNljJQqFEK8l8bNwfWHuZzJ9h5ivm5ts8DYVX
         RW0BZOPKG4q+tSVTJbtOOs0UrKVQSXKhc3e6320M0UHwxJwGNnu7P7DVGEKpshF8Rlsj
         puAw==
X-Gm-Message-State: AOAM5323ElmWO1OvmU1l0aSUQcbG1kRYDSNrksA6YB0+1/TDgE8O19+P
        iov0hjQ0B00Jcw+llza7DyY=
X-Google-Smtp-Source: ABdhPJwYEdBOcSKLRm7dHJ9GUQaQvQR8KyvK+v4AbBEsyIMND9exDuH7p4oe4pKBxHtoZlSE69pH4g==
X-Received: by 2002:aca:1b15:: with SMTP id b21mr40901578oib.64.1638199817731;
        Mon, 29 Nov 2021 07:30:17 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 186sm3032042oig.28.2021.11.29.07.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 07:30:17 -0800 (PST)
Message-ID: <21da13fb-e629-0d6e-1aa1-56e2eb86d1c3@gmail.com>
Date:   Mon, 29 Nov 2021 08:30:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal> <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
 <YaNrd6+9V18ku+Vk@unreal> <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
 <20211129135307.mxtfw6j7v4hdex4f@kgollan-pc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211129135307.mxtfw6j7v4hdex4f@kgollan-pc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/21 6:53 AM, Lahav Schlesinger wrote:
> Hi David, while I also don't have any strong preference here, my
> reasoning for failing the whole request if one device can't be deleted
> was so it will share the behaviour we currently have with group deletion.
> If you're okay with this asymmetry I'll send a V4.

good point - new features should be consistent with existing code.

You can add another attribute to the request to say 'Skip devices that
can not be deleted'.

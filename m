Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55EE2AABDD
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgKHPT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 10:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgKHPT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 10:19:56 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C72AC0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 07:19:55 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so8659474ejb.7
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 07:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bLnEhBbQ2tyoZwKrAGpUzu2y/pQAgUQ0TH9wCU9NAQI=;
        b=I7i6Wu0p+OkatQy+YAFWcaRFmkI+iRGa8Lszaw5MkVr7DrAgrZO5U+B2oLLWF/xpWk
         IVRuwNuZMB1H/c2rnzJiSyr9wEN8frJNyHZSg7tMv+kMGzybykSllxQ9Im+I8EuayLpj
         ushh9GbPmvNt/sEpNifkPzUNPG5PM8OgnIKZ4Q2j8Q0jdlV6t/KJtfY1lmpLoedBQNAK
         VSPcV7x3jvfBFItRNJQfwbqwokudNtvdDFsH4t1vVIFoxiqFoF/q+s77cpTTQiq6c2SA
         igj1z1ACffLl4vvJZtKXSo4vi1DYgj4q4Sq7ytR4v/Rfb2U72Q0Se+CL7EH74Aeq4MTL
         d1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bLnEhBbQ2tyoZwKrAGpUzu2y/pQAgUQ0TH9wCU9NAQI=;
        b=DIYDE3qAyJiMKmnvCp8EsADaY7FkJ+99opri9Qc17n6pQ2/2o2OlR22GOxwjOFmWV4
         4EE1Pv0YjZGTICda0lPvJBdbFhPIXcK/+jBwaTMpdx7G5BSOBNGBSEkuJJaxnM2q3Cdl
         2TBarHqsctpUv2JXDytQ7wnDRL9NZ5QbT55oyvwgScGM/1O/aDyjTeTFULZ7xilwGrM8
         m/VxqRqq0tb7A/2PTOQxmw5RjlL3sC0Y6Q3IWb844/FMs2tNU3iurpTuc51rCEi9oVhz
         CSGedasMEvmiMelSNR+x5QEgI94w+dnHTxpLgU45ttMBFIG3gPzDkCPO+kRMS/mR5IjD
         UtgA==
X-Gm-Message-State: AOAM5324qPgQpHMS+7KlVCmJGP0ECk7BgRrL8PXPAaVHtYrlSyP8QZ+/
        X+HtsP1LGXYB7jN7CUKV13aAVDjm4hU=
X-Google-Smtp-Source: ABdhPJz4ngLVrMdHQGnQDlYKMwIvkvJfkQuruMj1ticqP4xzfnJm86DYdnQKLEGCRvSuDs8ekOkOLw==
X-Received: by 2002:a17:906:d20a:: with SMTP id w10mr11007630ejz.3.1604848794433;
        Sun, 08 Nov 2020 07:19:54 -0800 (PST)
Received: from [192.168.0.103] ([77.124.113.118])
        by smtp.gmail.com with ESMTPSA id zm12sm6248742ejb.62.2020.11.08.07.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 07:19:53 -0800 (PST)
Subject: Re: [PATCH net] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, tariqt@nvidia.com
References: <20201104102141.3489-1-tariqt@nvidia.com>
 <20201104132521.2f7c3690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2f95eb05-6a2e-de29-4fd8-1dcff0ab0cfa@gmail.com>
 <20201105080019.24bd43fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <e64c2792-c8e6-fc1a-8208-434239073fe1@gmail.com>
Date:   Sun, 8 Nov 2020 17:19:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201105080019.24bd43fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/2020 6:00 PM, Jakub Kicinski wrote:
> On Thu, 5 Nov 2020 15:22:53 +0200 Tariq Toukan wrote:
>> On 11/4/2020 11:25 PM, Jakub Kicinski wrote:
>>> On Wed,  4 Nov 2020 12:21:41 +0200 Tariq Toukan wrote:
>>>> With NETIF_F_HW_TLS_TX packets are encrypted in HW. This cannot be
>>>> logically done when HW_CSUM offload is off.
>>>
>>> Right. Do you expect drivers to nack clearing NETIF_F_HW_TLS_TX when
>>> there are active connections, then?  I don't think NFP does.  We either
>>> gotta return -EBUSY when there are offloaded connections, or at least
>>> clearly document the expected behavior.
>>
>> As I see from code, today drivers and TLS stack allow clearing
>> NETIF_F_HW_TLS_TX without doing anything to change behavior in existing
>> sockets, so they continue to do HW offload. Only new sockets will be
>> affected.
> 
> Right, we want to let users turn off the offload when it misbehaves,
> and we don't have a way of un-offloading connections.
> 
>> I think the same behavior should apply when NETIF_F_HW_TLS_TX is cleared
>> implicitly (due to clearing HW_CSUM).
> 
> Right, I don't mind either way. My thinking with the tls feature was
> that offload is likely to be broken, at least initially. Checksum
> offload should work, one would hope, so its less of a risk.
> 
> The question is perhaps - do we care more about consistency with the
> behavior of the TLS feature, or current expectation that csum offload
> off will actually turn it off.
> 
>> If the existing behavior is not expected, and we should force fallback
>> to SW kTLS for existing sockets, then I think this should be fixed
>> independently to this patch, as it introduces no new regression.
>>
>> What do you think?
> 
> The current behavior of the TLS features is documented in
> tls-offload.rst, you can do what you're doing in this patch,
> but you need to document it there.
> 

I documented this in tls-offload.rst.
The preceding paragraph (with the note about old connections) is still 
valid.

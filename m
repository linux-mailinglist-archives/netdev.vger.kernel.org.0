Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31364222B60
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgGPTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgGPTB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:01:27 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517B9C061755;
        Thu, 16 Jul 2020 12:01:27 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o38so5770768qtf.6;
        Thu, 16 Jul 2020 12:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FxrUAa9DGlPrHQT2WlyDA4zCEI8N+BKlM4JUFceSy/c=;
        b=AtC0d0uboEYPfiO0CvojCod1/0ewrsAExcxKsfK8E0dDGlOsmeSj61hedFo6e26iF+
         1tHAibarPOr/NcVzFcu+FKD1eZ/jZJ+OSvAzAntuBVqGzdMIPABEVQRdbbNfpC8Ods+6
         RFv2vVAsE5aZP3FdMxuICBo3xVaS/NxykxqmBjvQVMU1ca1UbNTMcBNUH0xJMsA5EWJu
         RcP5gBx6qUKgPrwfBUh3bx8efJMqso/e5udh7HS/Zwvt1HLAWam3pYaEYnMpB9p7hbv4
         73ZwZfZGq1UezImMJDzrv2dB2jo3lSeSg9aW37UWRQkhrPun4B5YXLqX/X+BzwHep468
         YaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FxrUAa9DGlPrHQT2WlyDA4zCEI8N+BKlM4JUFceSy/c=;
        b=idEizq7ks05Lt3Um1GpvkjDiXDrFm/Ojf4PXbJ5w4E2vwu+Oto6WcL6mSauJvEOSdU
         bS9Vg8b2e6teXQ684ruhSTHB8dWN5qChPWeM2HxOjmf0htcHb7reHq0IBOVkCsfwEc4f
         HbqPzJQ51X8Ldjg15AiGyfA02mfT7xhqIZ3/UieOW0uXcwwdY21OS2WoC0qV8ZvbKHim
         lEIxymbdRsVQ4MgmK7ykPZFDy5Sy9KPCVUQtAduQLL2yyvOhsGaHHDh+2nC2mRBe8PhU
         xNMOFft9r7MQgvvgXtSE11dchpDazQwh0nyJaV8piFzOP2aCnJsLkSskYxx5Tp1e5Cep
         2U6Q==
X-Gm-Message-State: AOAM530gtDBrIay49iP2mYnpd8eIHzJ7a8jX7d3dH6Sya0UqPtoV8oZy
        umIiRcW1qRg3FQdvznq7j/Q=
X-Google-Smtp-Source: ABdhPJzQRirUQrB8Mh+KTHcGMIQ5f1STXFvUWmFKzmAYnRwxt5CusEQQQI4UmfZypVdrxTc1CgwhLg==
X-Received: by 2002:ac8:19c6:: with SMTP id s6mr6817617qtk.269.1594926085307;
        Thu, 16 Jul 2020 12:01:25 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c07e:4ca0:dde4:19ac? ([2601:282:803:7700:c07e:4ca0:dde4:19ac])
        by smtp.googlemail.com with ESMTPSA id o18sm7229031qkk.91.2020.07.16.12.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 12:01:24 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 2/9] bpf, xdp: maintain info on attached XDP
 BPF programs in net_device
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200716045602.3896926-1-andriin@fb.com>
 <20200716045602.3896926-3-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4cffee3d-6af9-57e6-a2d5-202925ee8e77@gmail.com>
Date:   Thu, 16 Jul 2020 13:01:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716045602.3896926-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 10:55 PM, Andrii Nakryiko wrote:
> Instead of delegating to drivers, maintain information about which BPF
> programs are attached in which XDP modes (generic/skb, driver, or hardware)
> locally in net_device. This effectively obsoletes XDP_QUERY_PROG command.
> 
> Such re-organization simplifies existing code already. But it also allows to
> further add bpf_link-based XDP attachments without drivers having to know
> about any of this at all, which seems like a good setup.
> XDP_SETUP_PROG/XDP_SETUP_PROG_HW are just low-level commands to driver to
> install/uninstall active BPF program. All the higher-level concerns about
> prog/link interaction will be contained within generic driver-agnostic logic.
> 
> All the XDP_QUERY_PROG calls to driver in dev_xdp_uninstall() were removed.
> It's not clear for me why dev_xdp_uninstall() were passing previous prog_flags
> when resetting installed programs. That seems unnecessary, plus most drivers
> don't populate prog_flags anyways. Having XDP_SETUP_PROG vs XDP_SETUP_PROG_HW
> should be enough of an indicator of what is required of driver to correctly
> reset active BPF program. dev_xdp_uninstall() is also generalized as an
> iteration over all three supported mode.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/netdevice.h |  17 +++-
>  net/core/dev.c            | 158 +++++++++++++++++++++-----------------

Similar to my comment on a v1 patch, this change is doing multiple
things that really should be split into 2 patches - one moving code
around and the second making the change you want. As is the patch is
difficult to properly review.

Given that you need a v4 anyways, can you split this patch into 2?

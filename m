Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2062B5879
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKQDrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQDre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:47:34 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F41C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:47:33 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 62so15116311pgg.12
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wxVPzA+uCtYAXyDLNpzdLAQkszyEfOrv2H7FBcDsrzw=;
        b=pkoPTThx43JA5XsRyac7Z5N3mH7VZIxJDUI75qx/fgm9xzbAOqaceMdrYQcPf3e4sk
         3T4SDBNep/I6/L9pi/RtGEKgGF/Nv96a8oZudOhOg7wOrhadIi/pvSITjQh7ZNNRMimc
         dvlkC9DlXEkNhU5MRkEfKyeUba8uxll/kCjbcah/bFIGRa8bVdbD4w02qhz8XLkCgPSc
         2FCbj6ZwGfqZUcDVbF4up4S8y1rA5ZgnsEiXQolp+KBm9vghJ5HpQRNSGucU8gImBM0a
         Q44S5WHBrxEAcuYhq5H7Rt+dC+dRUCCzuBFgTq1CZx511LOeHcD1xjtwbHGPhH6t8Rk8
         137Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wxVPzA+uCtYAXyDLNpzdLAQkszyEfOrv2H7FBcDsrzw=;
        b=Hbb5v8wDjuFHyRfqyZ9KWkOMTParfq1wPWjFqjxC3XRKXgw+z8qf2esbZbbSgeF7pu
         Wcqq5HoGbK/4fhOpOCd/cNVXL7DEnQcLnxBfjXBgLfA+cGWOWxK0IRsSMCpCnczMPDuL
         Qc9Q7hpa94AXWJohXzOwXY7Z/BzVzZtynv5UcDQCEhtD7H+DKuRtp9Xo8WVev+cbpWJx
         tM1nOXfH6utCgTE0+KpNutRMs1ufApP/zVvKYDJStjCGMAm+7L1gG9VbxkwzmKWvMOTC
         s09GNCgzZndIZcL8eR9KR9jwpincDgxxFaXu3DCtZ9QR3Hy0fwYJwJKWNAP6cPUZqxWY
         ENNQ==
X-Gm-Message-State: AOAM532KIJDdvzdctlhJzDcxeog7vAddLOtySk+CCfR/Ntd6Rr7L6+U0
        MtMt0cRI3Ya0mRazmnIg2HvkCkIaK5Q=
X-Google-Smtp-Source: ABdhPJx8kD/qYSO6Fz2pcqiica6wMosF4zBm0W2zRo9/vPUF/zygOdQJ0nSGFN9Z6zD59eu+vxnNww==
X-Received: by 2002:a17:90a:a417:: with SMTP id y23mr2357649pjp.97.1605584852512;
        Mon, 16 Nov 2020 19:47:32 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j25sm18935600pfa.199.2020.11.16.19.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 19:47:31 -0800 (PST)
Subject: Re: [PATCH v3 net-next 1/3] net: dsa: tag_dsa: Allow forwarding of
 redirected IGMP traffic
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20201114234558.31203-1-tobias@waldekranz.com>
 <20201114234558.31203-2-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8dadf02b-20a6-8fb4-7004-c5de14cdc4a7@gmail.com>
Date:   Mon, 16 Nov 2020 19:47:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201114234558.31203-2-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/2020 3:45 PM, Tobias Waldekranz wrote:
> When receiving an IGMP/MLD frame with a TO_CPU tag, the switch has not
> performed any forwarding of it. This means that we should not set the
> offload_fwd_mark on the skb, in case a software bridge wants it
> forwarded.
> 
> This is a port of:
> 
> 1ed9ec9b08ad ("dsa: Allow forwarding of redirected IGMP traffic")
> 
> Which corrected the issue for chips using EDSA tags, but not for those
> using regular DSA tags.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

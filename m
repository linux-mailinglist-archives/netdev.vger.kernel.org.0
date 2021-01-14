Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A52F6ADA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbhANTWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729921AbhANTWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:22:32 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615F1C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:21:52 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ga15so9884965ejb.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hJ4PbZRXWGKbnNFaGjb6sbAezL9+pJDA5n1ewEcRakw=;
        b=b9JJTPOrthVfyFbfmueN5xKP6jsW2O1dwykI3ofvYqnA/17z96hcmzg1VwdbLS0LEM
         cLK7067HCIDL3Tz3ewDachamz7UUuJWQFDeVSTcU1pIDrBb9DeQlNMGVPlMH6dPylM6L
         hVXzhPwxtxUYWJYTrwWNZVMzHfwU0Zvlsa5lKWvcvl0VQqM+CDo6yArtH2fe3JPymQxa
         l2YuKlQBM8UJ6oaDgLwgGHlkUUzMoqx5ipnqcZPwSKf7+ZH0aSs7mvbhWO75/R8OMBX7
         yQdsrTg4rHRLbmlE1v0aeehMwMqX+LUWXvCZcAQhcMSvvrvZgPFmgXOThTK638Oq33xq
         KGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hJ4PbZRXWGKbnNFaGjb6sbAezL9+pJDA5n1ewEcRakw=;
        b=DnSCCNg1YcicEyehaTom5S9F2i3T5C3xusQ5dCo+movhyZPufgbcXJOgJiYknDG5TE
         YiyrdA5XlQC5CJk4le/0M1ehyfzVmsSk6LqYSBPyVowgbpf9Q3cpGSfbjW7yF7UIE+iO
         5lbCdUROBL2I0kdkQlFOU7TXsSoFkTrTJjvRYfHU3dH7iAcHkfw/3h8eRYNJ1aXANsq8
         wOGMT9kZZ+K3mhEJMJ3Sdwznu/XBVnCDmvSJEDvezsAWnX2krV+eOGARAzPCg6G7/WB7
         lAMdJzd0xU9m1w1JT397pY5qxiNPDjE+7dubzVzNfloeRTEb0+L6jgdrE5yyCsXBFCh+
         jKuA==
X-Gm-Message-State: AOAM533DpmfiHMNVCq07rjPtiuAGlGzZclW5y7GN7q1zYGIkv7cRYgVY
        eFiNwFxnwbFFkceXk/JKPck=
X-Google-Smtp-Source: ABdhPJymSRUtSVJJhoQUpZwedJopflzkCpJOkUSDAw1HwbYgz6q2T//Gpwkn6qPjSq8EsINMfJs2Ow==
X-Received: by 2002:a17:906:1b41:: with SMTP id p1mr3250203ejg.162.1610652111079;
        Thu, 14 Jan 2021 11:21:51 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id v25sm2349174ejw.21.2021.01.14.11.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 11:21:50 -0800 (PST)
Subject: Re: [PATCH v1 net-next 00/15] nvme-tcp receive offloads
To:     David Ahern <dsahern@gmail.com>, Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     yorayz@nvidia.com, boris.pismenny@gmail.com, benishay@nvidia.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        ogerlitz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
 <967ae867-42c9-731d-9cb1-2c81fcc1ef77@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <a14d5ab8-e62c-65ac-3b8b-0e657226625f@gmail.com>
Date:   Thu, 14 Jan 2021 21:21:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <967ae867-42c9-731d-9cb1-2c81fcc1ef77@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/01/2021 6:47, David Ahern wrote:
> On 1/13/21 6:27 PM, Sagi Grimberg wrote:
>>> Changes since RFC v1:
>>> =========================================
>>> * Split mlx5 driver patches to several commits
>>> * Fix nvme-tcp handling of recovery flows. In particular, move queue
>>> offlaod
>>>    init/teardown to the start/stop functions.
>>
>> I'm assuming that you tested controller resets and network hiccups
>> during traffic right?
> 
> I had questions on this part as well -- e.g., what happens on a TCP
> retry? packets arrive, sgl filled for the command id, but packet is
> dropped in the stack (e.g., enqueue backlog is filled, so packet gets
> dropped)
> 

On re-transmission the HW context's expected tcp sequence number doesn't
match. As a result, the received packet is un-offloaded and software
will do the copy/crc for its data.

As a general rule, if HW context expected sequence numbers don't match,
then there's no offload.

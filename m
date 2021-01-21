Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18D32FEFDE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387576AbhAUQMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732884AbhAUQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:11:44 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C226C0613D6;
        Thu, 21 Jan 2021 08:11:02 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c12so2286648wrc.7;
        Thu, 21 Jan 2021 08:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3fk+Ltd/WJun2rMhD/0B1TRdBjEBWKb5kM3nBcZ4ddo=;
        b=lyedh99Ckt5+2Zdw9xnwKh8S2EIazsc1QHLioysl5Nmgf3VlQMG6C2iQvkJNY3dUEl
         HbFNskw5fruTXnGPHku1SiUDsF6z//OJm7Md/VHA0yHH/Ekg1BsW6vht0s9BnVMWoua8
         edBAKsQ6uCWONCPOC4WkD/ErQT+PPieYPxfygLD/ldPTPDl1kZwss7spmq6yqARmcdO+
         pf/i9xli3pq8s77/9PP8cYd4wpS72CnHfexqcQtgXpedr5BhfWBe4J/bOt3HWZTjg6h/
         JFNISt2uaW8vdEjwbC5G5IfmVFs03oMvInAJXC1+kqtBqfFFSMFT4nLp0zcPUhcyt/Od
         IfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3fk+Ltd/WJun2rMhD/0B1TRdBjEBWKb5kM3nBcZ4ddo=;
        b=skCiQl9vDCfCj0TCzuR2XihopG58CXZYqDt2AnDwwQZjm8v8RcXq5DfAuoOG1Abhmu
         hhrittQPSvzul11DtZngfd9W8pPd200fKpOxLKDbv2E2VWFnYaYikAGTQBiuOS4v7tlk
         fzJIwsv7T/4pv3qOfgU3IVhxPOG08yRC8oarghnCPGbYDHTozma3ManeIBhaozZfTyLF
         egpOkdtgrHROv829lXtHd3srhYIIDoZofsgMmxAlxEL0D39vHaYb10RJTap+v/prk1TX
         OKneXY1ZBj3Z0O11XQq5WxQ1WAxjm7jC0maClQqlX8U8+WAkafi2Y9EqE2AJsaipacsO
         u5UQ==
X-Gm-Message-State: AOAM532lbvRg6abG3BFBzm7UGoxTMNd0JmcGO5asKZ3UrMaKf9C0Tl+r
        R2qzhvhdfPfu4A2CeJq29aU=
X-Google-Smtp-Source: ABdhPJxWQdlgzYligRW+q9HCSyXSEChFX5mO2uWlk6p7GRWbht/G/Er4S6YAzwNQrk633Q3qHi8ckw==
X-Received: by 2002:a5d:4d4f:: with SMTP id a15mr148527wru.315.1611245461008;
        Thu, 21 Jan 2021 08:11:01 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id g194sm8582133wme.39.2021.01.21.08.10.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 08:11:00 -0800 (PST)
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
To:     Ivan Babrou <ivan@cloudflare.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20210120212759.81548-1-ivan@cloudflare.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <201b4e33-eec5-efcd-808b-1f15a979d998@gmail.com>
Date:   Thu, 21 Jan 2021 16:10:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210120212759.81548-1-ivan@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2021 21:27, Ivan Babrou wrote:
> Without this change the driver tries to allocate too many queues,
> breaching the number of available msi-x interrupts on machines
> with many logical cpus and default adapter settings:
> 
> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
> 
> Which in turn triggers EINVAL on XDP processing:
> 
> sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> 
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03A2149409
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 09:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAYItK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 03:49:10 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42935 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgAYItJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 03:49:09 -0500
Received: by mail-lj1-f195.google.com with SMTP id y4so5245680ljj.9
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 00:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JGAjdva52XclcmBAYiWTp7Sd6GB5NNj9om2nEpGZk4U=;
        b=aLDSmnknhi9UiBMok0kuHJCnAZeY4uhtKYH/X+BORsVDr5YF+JcIFAAry3K+SLxJW9
         slQTT3g2gR43PUn5n6+7pN2bDRtM4PQ8g7bQUbMK1erMENPyIZi36xwsGPEoMdIu25Cw
         YxyoARbdk24rAXOrf8OY6A8FsQ9grxqvMTe2e3q5R55FmenLHXj8UnblpkoOSPC/3ZzI
         JYSERj5m8SieDB3gs2qxHpS9IQdqqTZ3dL7us3qn8p9PIiBmmpJ7uwPVaigJPvkT3CJY
         5z9ApOEs8SBEVmxdjcdmko0TPJ7nrt9VnQVHmyfVMinGmi5Hvbnfsjq8Z8wuayQGQUCR
         slrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JGAjdva52XclcmBAYiWTp7Sd6GB5NNj9om2nEpGZk4U=;
        b=UC7rQGoDutDFGkyRGLh3mmS6xzA91tZxshif2CM8o4AhU3QGoA0w1m8qufn5kEBfJB
         8EnCcXsMk0OCWdieOBwxTbUiBgwQ6O0hBcNEUQ75Fgn5pvf6WfvrOXhjLlaWBDXIKmr1
         2GcpQbuiLV4xkiP3tqQssShCv0/jvyIhNB15bOC1cjnuJ+4wDmteEFuMvJSvMdHGbS/6
         jSfbJUhY8DgHx+WGFaB/d9OvZQCropws0hHgsaviVnOWu/oFCWrIWJ3VhwprLhoTYi2+
         NYIiRxdIBqywH5OjWWfPjW4HuLsYF2ZB9cFExtiKDkRXEU5a3mqKY6cNXu24KIcKx2an
         ZeDg==
X-Gm-Message-State: APjAAAXQicJCdjA0BvOuXyfjL87KPhcBjNVQgOgPz0m/xk2NMonz5GQ5
        zG48lHuLLqKiPQq423joTpAIOg==
X-Google-Smtp-Source: APXvYqxB5+w6lkhCPG17xoLx9bc1dwUJrL5ZeRIdjTz9PZTEzoSIgRCEd7LlLdpXT5XwmkCrh4735A==
X-Received: by 2002:a2e:9c85:: with SMTP id x5mr4772403lji.50.1579942147515;
        Sat, 25 Jan 2020 00:49:07 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4d4:a77b:25e8:958f:2b17:6e20? ([2a00:1fa0:4d4:a77b:25e8:958f:2b17:6e20])
        by smtp.gmail.com with ESMTPSA id w71sm5005098lff.0.2020.01.25.00.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 00:49:06 -0800 (PST)
Subject: Re: [PATCH] net: cxgb3_main: Add CAP_NET_ADMIN check to
 CHELSIO_GET_MEM
To:     Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com, vishal@chelsio.com
References: <20200124094144.15831-1-mpe@ellerman.id.au>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <7a7d18d3-8c8d-af05-9aa0-fa54fa0dc0b7@cogentembedded.com>
Date:   Sat, 25 Jan 2020 11:48:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124094144.15831-1-mpe@ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 24.01.2020 12:41, Michael Ellerman wrote:

> The cxgb3 driver for "Chelsio T3-based gigabit and 10Gb Ethernet
> adapters" implements a custom ioctl as SIOCCHIOCTL/SIOCDEVPRIVATE in
> cxgb_extension_ioctl().
> 
> One of the subcommands of the ioctl is CHELSIO_GET_MEM, which appears
> to read memory directly out of the adapter and return it to userspace.
> It's not entirely clear what the contents of the adapter memory
> contains, but the assumption is that it shouldn't be accessible to all

    s/contains/is/? Else it sounds tautological. :-)

> users.
> 
> So add a CAP_NET_ADMIN check to the CHELSIO_GET_MEM case. Put it after
> the is_offload() check, which matches two of the other subcommands in
> the same function which also check for is_offload() and CAP_NET_ADMIN.
> 
> Found by Ilja by code inspection, not tested as I don't have the
> required hardware.
> 
> Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[...]

MBR, Sergei

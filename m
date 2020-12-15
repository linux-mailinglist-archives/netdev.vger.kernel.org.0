Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6CE2DB406
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgLOSuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731552AbgLOSui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 13:50:38 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F3BC0617A7;
        Tue, 15 Dec 2020 10:49:58 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 91so20888353wrj.7;
        Tue, 15 Dec 2020 10:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GA6LCfSHuIJlH1V+JXdquXEk9vLc0JUPo0y9OtUKPpw=;
        b=dSNwF/UL69pOmDJwGyqGBHerkfct5Lgh5L4A+3j92H6LeTMaW2eyKChSPCMOeO07Rt
         LtX7Omk/7aF+CdkddzZZzalNK7wEZLXSX/IlIPZ4sOGe1gJzj71cVhmS7vJ0PIwbJhv1
         aq/ROTcmXyBkm96Iv2jP+BwfOBDOskixnQaTvUqsjrGmo9wzQbiqvcK7+jwJoKj0NfCg
         BY1jkOFHMkm9ZMVi9iEwcIosdSQlATjfFddmdb5m2XP7r6CLS9A2W1Cu8fn9OE2ITzbo
         scOImJasUDjSalykgZr5/TOIQXU0XoN5ispPcACl1ocquCQYx4oyy2IhMjLgC4npcru0
         VPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GA6LCfSHuIJlH1V+JXdquXEk9vLc0JUPo0y9OtUKPpw=;
        b=oloUyfHUQs5I15R0fDVS3rQVeQbVy3cKsqmaZT0ym6DgvlTkca8x1giRXX7flp4UAX
         GkzytHE8kEJzsue63MTWfAOwA/zX/DOZDT6qKf0WryNqGJcEEoehZK+EGqtirBZw8ZdQ
         mVP31Ln/zaN4h+K+FRmxYaEhEJhOEVAaGTm+uXd5FQp8toZ7shLjqUxagEUymveqZrkN
         UFIlHkEIPTEptDJls47bI+8Ra42+mMLGt41Nfe7vFb6QticBxcYcpGiF0nAaKDyufHQ+
         JaA9031kuru9Yv/VCh1gZLdD7vNMyIigacd/AFy5w2WAeC9RqY69fDMnB8YeXV24wfw9
         mrwg==
X-Gm-Message-State: AOAM532AjTfAjl5WJyrCCUuJ4QtAkQrmaCqiHmZCZfPOVF9kC+IbH90Q
        MGFrSnnJOC4lSvcYrwG0kY8=
X-Google-Smtp-Source: ABdhPJyWcIDAFNBmNcVwRC3GQCgUlZrJHcVZFIZz0D4LnRFyQ4diXSicYHCRgjAom/EP1tQeEwVpxA==
X-Received: by 2002:adf:b74d:: with SMTP id n13mr35720174wre.101.1608058197188;
        Tue, 15 Dec 2020 10:49:57 -0800 (PST)
Received: from [80.5.128.40] (cpc108961-cmbg20-2-0-cust39.5-4.cable.virginm.net. [80.5.128.40])
        by smtp.gmail.com with ESMTPSA id j7sm37985447wmb.40.2020.12.15.10.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 10:49:56 -0800 (PST)
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Ivan Babrou <ivan@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20201215012907.3062-1-ivan@cloudflare.com>
 <20201215104327.2be76156@carbon>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <205ba636-f180-3003-a41c-828e1fe1a13b@gmail.com>
Date:   Tue, 15 Dec 2020 18:49:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201215104327.2be76156@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2020 09:43, Jesper Dangaard Brouer wrote:
> On Mon, 14 Dec 2020 17:29:06 -0800
> Ivan Babrou <ivan@cloudflare.com> wrote:
> 
>> Without this change the driver tries to allocate too many queues,
>> breaching the number of available msi-x interrupts on machines
>> with many logical cpus and default adapter settings:
>>
>> Insufficient resources for 12 XDP event queues (24 other channels, max 32)
>>
>> Which in turn triggers EINVAL on XDP processing:
>>
>> sfc 0000:86:00.0 ext0: XDP TX failed (-22)
> 
> I have a similar QA report with XDP_REDIRECT:
>   sfc 0000:05:00.0 ens1f0np0: XDP redirect failed (-22)
> 
> Here we are back to the issue we discussed with ixgbe, that NIC / msi-x
> interrupts hardware resources are not enough on machines with many
> logical cpus.
> 
> After this fix, what will happen if (cpu >= efx->xdp_tx_queue_count) ?
Same as happened before: the "failed -22".  But this fix will make that
 less likely to happen, because it ties more TXQs to each EVQ, and it's
 the EVQs that are in short supply.
(Strictly speaking, I believe the limitation is a software one, that
 comes from the driver's channel structures having been designed a
 decade ago when 32 cpus ought to be enough for anybody... AFAIR the
 hardware is capable of giving us something like 1024 evqs if we ask
 for them, it just might not have that many msi-x vectors for us.)
Anyway, the patch looks correct, so
Acked-by: Edward Cree <ecree.xilinx@gmail.com>

-ed

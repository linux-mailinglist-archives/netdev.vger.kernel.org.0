Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65C8229345
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgGVISq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVISp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:18:45 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68901C0619DC;
        Wed, 22 Jul 2020 01:18:45 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b25so1541617ljp.6;
        Wed, 22 Jul 2020 01:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Agqk++F1xoIQwoewhOj/u4TlCp4VInNiEtBRjZLSP/g=;
        b=Qa8hzfqM7xckbkB0ihS2bBaj8DkJlFJP+b7TsSZ93svL27uL8PxtqwXbZdrYv8i2OE
         zKfA/SgkbIQvrqHu4Kpuxv4zHmMJgdSfcqVnO8lX8oPBI9Yp61VCoV/xZVkBIgj2U/Da
         RrGNmhSCuZc5RmSSGs2fuvkWumPBH9LNXrJUo9CqI0OJYtO15uRSG3KldtOIsccAP6dF
         4fS8mvKwNXeumomBjfQ0hl5Ix3jd4mFl/3hy+oVmA2CoJVH2ujUJyQeTrS+5h2yTLUxH
         Xid8SBbM+FZeIbJWu4IIyOIWeQdVhyulBYOdV9M/lPvtEWe2zlcNhEimDtyzmdtLxUdm
         UwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Agqk++F1xoIQwoewhOj/u4TlCp4VInNiEtBRjZLSP/g=;
        b=rZf71WNWoj/ZBLjkPB5igjDmKzuVU5P4sM0jAoY8xp5hX+k6BcypiCcBqeXT4qaND9
         BQFgsBVPLlmf1inx09aztRWT7lCDT2hfcpNuwaNk2ZV+3lAXFRdwYilJwGRzTFTtD3w5
         YrOyd80Cvs/RmUACRL1aat+h9Veef7pgRsR2PIYClQrMQXfFYLOrJMVIyLSynrWeVlyI
         QGb30c5s8KyD3X7XCdo64OYB9MhM1EAbdo8sF4JYX8ruveeApMaSwXNlj+i9lA2h28rx
         ToQBCA8O/jd0p5eO0piJn8pvvG+J6xYWz1OYzVPclMtxGK4F6i9kRqdLymGxaBMguCHv
         KGOA==
X-Gm-Message-State: AOAM533/tPEJEF7BUb3pLOpn74tL3WlqqbiailNDcKIvgrP3eAjAxb9u
        +os0Jp57ipq087mygoRNBeNHwC6dZIk=
X-Google-Smtp-Source: ABdhPJyY4Tbwtt85H3YVaFW5echnoMflZZxA0fmVCgYjB5+HyNUpbH2sXAi8QbiYTcJ+0tUZ38vzgw==
X-Received: by 2002:a2e:99cf:: with SMTP id l15mr14904100ljj.294.1595405923527;
        Wed, 22 Jul 2020 01:18:43 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:44d2:25a2:d4ec:7c9e:620b:fb8? ([2a00:1fa0:44d2:25a2:d4ec:7c9e:620b:fb8])
        by smtp.gmail.com with ESMTPSA id u19sm6903258ljk.0.2020.07.22.01.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 01:18:42 -0700 (PDT)
Subject: Re: [PATCH v3] net: ethernet: ravb: exit if re-initialization fails
 in tx timeout
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     dirk.behme@de.bosch.com, Shashikant.Suguni@in.bosch.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1595312592-28666-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <cc59c0d2-c7c1-9707-79c6-359d822f2b27@gmail.com>
Date:   Wed, 22 Jul 2020 11:18:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595312592-28666-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.07.2020 9:23, Yoshihiro Shimoda wrote:

> According to the report of [1], this driver is possible to cause
> the following error in ravb_tx_timeout_work().
> 
> ravb e6800000.ethernet ethernet: failed to switch device to config mode
> 
> This error means that the hardware could not change the state
> from "Operation" to "Configuration" while some tx and/or rx queue
> are operating. After that, ravb_config() in ravb_dmac_init() will fail,
> and then any descriptors will be not allocaled anymore so that NULL
> pointer dereference happens after that on ravb_start_xmit().
> 
> To fix the issue, the ravb_tx_timeout_work() should check
> the return values of ravb_stop_dma() and ravb_dmac_init().
> If ravb_stop_dma() fails, ravb_tx_timeout_work() re-enables TX and RX
> and just exits. If ravb_dmac_init() fails, just exits.
> 
> [1]
> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
> 
> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

    ACK, this tag is still good for v3.

> ---
>   Changes from RFC v2:
>   - Check the return value of ravb_init_dmac() too.
>   - Update the subject and description.
>   - Fix the comment in the code.
>   - Add Reviewed-by Sergei.
>   https://patchwork.kernel.org/patch/11673621/
> 
>   Changes from RFC v1:
>   - Check the return value of ravb_stop_dma() and exit if the hardware
>     condition can not be initialized in the tx timeout.
>   - Update the commit subject and description.
>   - Fix some typo.
>   https://patchwork.kernel.org/patch/11570217/
> 
>   Unfortunately, I still didn't reproduce the issue yet. But,
>   I got review from Sergei in v2. So, I removed RFC on this patch.

    Sorry for the sloppy code. :-|

MBR, Sergei

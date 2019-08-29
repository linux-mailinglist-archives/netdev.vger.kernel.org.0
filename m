Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F28A13D7
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 10:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfH2Ich (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 04:32:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44990 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfH2Icg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 04:32:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id j11so2443902wrp.11;
        Thu, 29 Aug 2019 01:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TLcjEAYdtAfZ2IRKdNGNYpywlsNLbG2mqtC2Fue66Yc=;
        b=QJxXPKf/Cg9KTx27UkHrkQS6ltF9PXHtxV3So9AJZ3YdbRVZ7QhBAft6mEVczkhzYF
         n3FHou9injbx8mXgBd6MwmQ1s9z5IrRQW9ymkowZ+1YaSfWjr2VOd5XBjNmfT5XVY63Y
         /F2ezWgMx+8Pm7T7I83lhTUhjgZFGlBBP/VgY8Pp9hVkkE+LDqbZrGZBUiopAWynhbUM
         aW0M+QsTkjiep24QWsIY4HJZsIvLdfz9oVvYwkaXovkv/BJuDAbIMfP7MD88Q+WMJ4nk
         848vROF+kVBToD962VFAZJ9c3+IvvHy/wdECBasAP1fBcPQG7BuRVXbXYTJMhmCiPbNX
         +HBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TLcjEAYdtAfZ2IRKdNGNYpywlsNLbG2mqtC2Fue66Yc=;
        b=BAQ1yC0YcmyS3QJzf2sbNaND98XSkUk57IbiM9YOTpP5VclbXyo1ttjzJ0QguyyZtS
         aMAqVlZ1JkBaPwbFWCQdiO+nGSsyCU+DXtBZsmPQhSgcRBTzJoNvbwK46PbiDu6Vuzjj
         JN8ySmz5mavVjzeBz5GkCOdn+UeQBoKIFWWQFkKu+koIrqawwjt6x788yAF0qZWKI6ph
         BiFHo+S/gcLxjrGHFozj0B2giqcpqRP7YcL3xprurj5dgRQ0gyUiWqGswD8r5ipvkDGm
         UcMiZSTyn8+P7Pcmy8a0uBdAwn2p8jEMp2iBynUMjcNyX9mf15Mizy9F3qHrfdrPnnZi
         xaug==
X-Gm-Message-State: APjAAAVs0CE88axcvUf4EPY1L8tP6AE7X1VtJavxHOv7JYmviobRISKp
        qu7p8F9UI+bne3ifHDF4dv+Yien2
X-Google-Smtp-Source: APXvYqxvedUZQokkdwPwIOVPjaDcbedfAWkWLITg5V4Mob8IXBhl45k79LQCPRLYcJ/MhjRlvzp1Qg==
X-Received: by 2002:adf:82d4:: with SMTP id 78mr9182142wrc.85.1567067554017;
        Thu, 29 Aug 2019 01:32:34 -0700 (PDT)
Received: from [192.168.8.147] (33.169.185.81.rev.sfr.net. [81.185.169.33])
        by smtp.gmail.com with ESMTPSA id n14sm4882149wra.75.2019.08.29.01.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2019 01:32:33 -0700 (PDT)
Subject: Re: [v1] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
To:     David Dai <zdai@linux.vnet.ibm.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com
References: <1567032687-973-1-git-send-email-zdai@linux.vnet.ibm.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7a8a5024-bbff-7443-71b3-9e3976af269f@gmail.com>
Date:   Thu, 29 Aug 2019 10:32:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567032687-973-1-git-send-email-zdai@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/19 12:51 AM, David Dai wrote:
> For high speed adapter like Mellanox CX-5 card, it can reach upto
> 100 Gbits per second bandwidth. Currently htb already supports 64bit rate
> in tc utility. However police action rate and peakrate are still limited
> to 32bit value (upto 32 Gbits per second). Add 2 new attributes
> TCA_POLICE_RATE64 and TCA_POLICE_RATE64 in kernel for 64bit support
> so that tc utility can use them for 64bit rate and peakrate value to
> break the 32bit limit, and still keep the backward binary compatibility.
> 
> Tested-by: David Dai <zdai@linux.vnet.ibm.com>
> Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
> ---
>  include/uapi/linux/pkt_cls.h |    2 ++
>  net/sched/act_police.c       |   27 +++++++++++++++++++++++----
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index b057aee..eb4ea4d 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -159,6 +159,8 @@ enum {
>  	TCA_POLICE_AVRATE,
>  	TCA_POLICE_RESULT,
>  	TCA_POLICE_TM,
> +	TCA_POLICE_RATE64,
> +	TCA_POLICE_PEAKRATE64,
>  	TCA_POLICE_PAD,
>  	__TCA_POLICE_MAX
>  #define TCA_POLICE_RESULT TCA_POLICE_RESULT

Never insert new attributes, as this breaks compatibility with old binaries (including
old kernels)

Keep TCA_POLICE_PAD value the same, thanks.

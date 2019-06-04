Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA68350F6
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfFDUcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:32:03 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41607 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfFDUcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:32:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id 83so4191270pgg.8;
        Tue, 04 Jun 2019 13:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zbEJVcqozWzcoFlbBXS+TBjzcZ1OHQOrJK+1Yv2WO0M=;
        b=HRlw7T5HrC1sd0EEVOlmxMYcEUW9P5KTISto8J7IBxGP2yzW843P+jIUL6NelNXstQ
         D8XvyAu7QYkVM2IoDDAyXp0sXS8xF/4nek3GpocF8G24lBfn+qkMCPRMzavEVNOXYxUS
         caDzOhvPXLTgk6tZ5FH5SExn8kXr6oRHichMbXB+1pXtfQAeOzS6hzAFhuj9GxP+9+u7
         1MxY+6w7didSa+HdOpJgnxJyixl31HmTrorgBWGTOJn7mqweLkxAtOiQGsSWN27LxrQ6
         /nep/j/MTr041ex5XXhL5vuRtS5auX0MrPKYLZLgV9nKexEMj1k4O+JnxZY9SKOhOJ10
         lmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zbEJVcqozWzcoFlbBXS+TBjzcZ1OHQOrJK+1Yv2WO0M=;
        b=Q9HToEZbMPE+z6IK7xHp3ROZL6kFAXebrllzx25/lcQe/grjEtEBCpRH/UUOzhT2Hl
         8thYKZmENmspg9YgqkGygQ+D6gD59E75yWBgIRpuEi3tMz3FN1z0zsEls3YO/in3K/eh
         l3eu3gRxYujvKsv4lHMdGdAFF+MZ4caPzTwGab8oGYouv9jQsJiVdceysOqW6geJDsnP
         R4ai5S+y3S57jHXM4ELs/CE74jIt3HlNEivQHDUXE7Q2khcNx5xSdbR3tBetn5zY98ui
         lT6ucpCyOaMCa01JCoW3Su4OixTJ6y9WawbuYuJEUqF6EbLPX4nI05KzAVE4fuUjtbJI
         8gyA==
X-Gm-Message-State: APjAAAXM3Nnb04i+hNJRdxImGrFoxPZEn+seBrSUC0DGeauxezLRwd5n
        bvOvYTwAYZgstcM9yU6nUVhbD8Tz
X-Google-Smtp-Source: APXvYqxbc/5j0N2mBryM3d+Q+6XQAi6sKwhl0NsA7+dyfcwjUGgCtsj58EypLAOnavta0iGS1MPgqA==
X-Received: by 2002:a63:e616:: with SMTP id g22mr562455pgh.61.1559680321272;
        Tue, 04 Jun 2019 13:32:01 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id c16sm1004134pfp.91.2019.06.04.13.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:32:00 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 01/17] net: dsa: Keep a pointer to the skb
 clone for TX timestamping
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604170756.14338-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <fed60662-e66d-5d5b-fec8-52e4373630b2@gmail.com>
Date:   Tue, 4 Jun 2019 13:31:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604170756.14338-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 10:07 AM, Vladimir Oltean wrote:
> For drivers that use deferred_xmit for PTP frames (such as sja1105),
> there is no need to perform matching between PTP frames and their egress
> timestamps, since the sending process can be serialized.
> 
> In that case, it makes sense to have the pointer to the skb clone that
> DSA made directly in the skb->cb. It will be used for pushing the egress
> timestamp back in the application socket's error queue.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

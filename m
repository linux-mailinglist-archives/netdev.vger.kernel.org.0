Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30D414146
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfEERD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:03:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44486 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfEERD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:03:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id y13so5439017pfm.11
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hC712R57b4ANozWLBOYTG/WKw9R59dDG1GtwnRq/t7c=;
        b=sieVejKi1FkyndmOAUY9e4IjwzVvuVzDxmzrH3t4BgBYZSX+JcFXqa0cNFxMa8iCPR
         aFKojpAGmcfzxhtM3CHBkGk/ChlzU6QE4jCgaC3tS50M1KMbyKhAhSonVsfAzSn6FdT3
         6hEUpgkaCPQh1xZxdb6JD67N/3jAB5wWSagp6AAC/1/XmG0DbAisK2vMIXgFu1u3HU5N
         v0uSD9EGgBEAjXn0/1IOdhUS4o6scnzgSNIZT1oMmw0UKFR+Fa324+yg2HDQIXiv9ICN
         pkdD3FIRi7aw+WqxF8V/gp5OeGY3SEH83tyWqSZfQ8FyIw2zTUfaGS/YALLxVOk/9/b3
         MPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hC712R57b4ANozWLBOYTG/WKw9R59dDG1GtwnRq/t7c=;
        b=MlUXQrjmTkpF8W4dWf8GNxaVJtb7wFtxwvjTrJPe3AATByX7u7E6w7aiI0ASnlJses
         lm7zkxmdHhxye9nOVGRNo9lDA1iEgDI1K+6BFJJ+FlPVjsCMJj+ZwZ/Qcck0NwKQoz2y
         0x/q8AvRz8qpw+kubLv2+1yNagchRrGdoAMWKm06jGqfwO8uNNmnXuGcjCIbswnUe/d/
         7oY/qYGeATjBkT5RLYgBu1VSZvwL82GgWGnABU7+WzlUFfZlwclMqqBi8Pk6VZk1PvPt
         XoY/SUveiMWkxeXgtnR6RzrWVJklxYyU+xE/URIFheuu8wXV9pfjXUOT40u2pCvK8Qmq
         ShfQ==
X-Gm-Message-State: APjAAAXEEvNVIWYrnbYl0T/q7vv1OAQqYZbxyMfb2/vh6jy9pbzgmo/r
        dmLvnvV/8fvbO2SNjk8lwWJralhN
X-Google-Smtp-Source: APXvYqxw7XoEQ1Ji8HAhbkcItfwH62MOmbFKpXSpxUQC//Gi2ZKZX5WGy+q2bOUmQc9mihW4ctTKng==
X-Received: by 2002:a62:e10f:: with SMTP id q15mr27336037pfh.56.1557075807481;
        Sun, 05 May 2019 10:03:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id i15sm11469836pfr.8.2019.05.05.10.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:03:26 -0700 (PDT)
Subject: Re: [PATCH net-next v3 06/10] net: dsa: Add support for deferred xmit
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190505101929.17056-1-olteanv@gmail.com>
 <20190505101929.17056-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f921e950-cd69-501e-0278-7afb8a34cca7@gmail.com>
Date:   Sun, 5 May 2019 10:03:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505101929.17056-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 3:19 AM, Vladimir Oltean wrote:
> Some hardware needs to take work to get convinced to receive frames on
> the CPU port (such as the sja1105 which takes temporary L2 forwarding
> rules over SPI that last for a single frame). Such work needs a
> sleepable context, and because the regular .ndo_start_xmit is atomic,
> this cannot be done in the tagger. So introduce a generic DSA mechanism
> that sets up a transmit skb queue and a workqueue for deferred
> transmission.
> 
> The new driver callback (.port_deferred_xmit) is in dsa_switch and not
> in the tagger because the operations that require sleeping typically
> also involve interacting with the hardware, and not simply skb
> manipulations. Therefore having it there simplifies the structure a bit
> and makes it unnecessary to export functions from the driver to the
> tagger.
> 
> The driver is responsible of calling dsa_enqueue_skb which transfers it
> to the master netdevice. This is so that it has a chance of performing
> some more work afterwards, such as cleanup or TX timestamping.
> 
> To tell DSA that skb xmit deferral is required, I have thought about
> changing the return type of the tagger .xmit from struct sk_buff * into
> a enum dsa_tx_t that could potentially encode a DSA_XMIT_DEFER value.
> 
> But the trailer tagger is reallocating every skb on xmit and therefore
> making a valid use of the pointer return value. So instead of reworking
> the API in complicated ways, right now a boolean property in the newly
> introduced DSA_SKB_CB is set.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

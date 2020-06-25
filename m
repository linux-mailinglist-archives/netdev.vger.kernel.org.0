Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F34209850
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbgFYBsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYBsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:48:42 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3EBC061573;
        Wed, 24 Jun 2020 18:48:41 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id mb16so4345588ejb.4;
        Wed, 24 Jun 2020 18:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MR14NdfeLIxUT3B/T4z/s/5QbH4B6QkcDb1HR4J62RI=;
        b=I2IfyWJHipbxLtKpT5odAqjmModuoA6Qs6FfdV8b5yG1T5jWIa9Vd/CXzaBjISJAPZ
         SOLwh0/iQrRT8t+2bBHTa8J7gUKAdV74pNo6S/CoRd2e1oMwv4xOEPTLJ8zVyTKhljxy
         n0acw24Wze8Ji5BcSSl22n798ZoId+U/yLIrhZsdi+xkJqPU4+oPsbdf9EtAbvAcK/6X
         MQgM8TdDJeIXvgUCz8aZq9pyM8BA89mxYqv0v9nV1Ub4qUw095p+M+l9IJ2ysy7zJDn0
         ye1/tGptfjrRqmIFvE4vAwpgKbpV+FFysc+SHbmaka9JRuXld5CD2EH7ue4Nd8/W0TJf
         TAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MR14NdfeLIxUT3B/T4z/s/5QbH4B6QkcDb1HR4J62RI=;
        b=MNaxbZ227hvuOYw9CQCtGHNMbA8R9s6vbioedgkTdgkqzUhxNaksB+ntr/bpmuLzgN
         TsZg3mM26Tz0+6tM4rfFTD+lXzu6IR9zCOndi82dZYuOoFLFmqJlOFBeXrS6rA+5x2P3
         0Vq/avXnH9X17c5k/iscIBl4AFsPpAv5PD30+ZmRDPLwXKEVCys8aoLZeM1JOu8jImwp
         vkiZXGU2zVexQ5CHb1rwTexkvntOtueU+BHBit4DXmanRBrBYZmjlojJCr/jE9PcWC1+
         NqZHrPztLrKOHY/7AuDtQXHlHNrqm06/8iMwU7duw8DIa2GH6PG86qnghIFwPGPTrstV
         5W2g==
X-Gm-Message-State: AOAM531GeTcQAq7IUGOoZg3nLBPQn6HV37D5PBQfHjTYAIczJqZxT0wX
        tvKd/jieSQlsV3e6VBERQ0KjIDX3
X-Google-Smtp-Source: ABdhPJy+uZuqeAzrsPvDdOeP+8dAWpgQ/aHTJMInQQv8Um/QtAzcmchVBQe9wjDOe+AysMqGgkM79g==
X-Received: by 2002:a17:907:1051:: with SMTP id oy17mr7204607ejb.394.1593049720121;
        Wed, 24 Jun 2020 18:48:40 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p13sm18017712edi.74.2020.06.24.18.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:48:39 -0700 (PDT)
Subject: Re: [PATCH net 3/3] net: bcmgenet: use hardware padding of runt
 frames
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
 <1593047695-45803-4-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5fdf1da6-8c69-1434-e5ee-0c90568f6aba@gmail.com>
Date:   Wed, 24 Jun 2020 18:48:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593047695-45803-4-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 6:14 PM, Doug Berger wrote:
> When commit 474ea9cafc45 ("net: bcmgenet: correctly pad short
> packets") added the call to skb_padto() it should have been
> located before the nr_frags parameter was read since that value
> could be changed when padding packets with lengths between 55
> and 59 bytes (inclusive).
> 
> The use of a stale nr_frags value can cause corruption of the
> pad data when tx-scatter-gather is enabled. This corruption of
> the pad can cause invalid checksum computation when hardware
> offload of tx-checksum is also enabled.
> 
> Since the original reason for the padding was corrected by
> commit 7dd399130efb ("net: bcmgenet: fix skb_len in
> bcmgenet_xmit_single()") we can remove the software padding all
> together and make use of hardware padding of short frames as
> long as the hardware also always appends the FCS value to the
> frame.
> 
> Fixes: 474ea9cafc45 ("net: bcmgenet: correctly pad short packets")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

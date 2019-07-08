Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2361B9B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfGHISu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:18:50 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:37581 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfGHISu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:18:50 -0400
Received: by mail-wm1-f45.google.com with SMTP id f17so15356873wme.2;
        Mon, 08 Jul 2019 01:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+dxzi0LW4RlPK/kr+U7GGFfgJIv2CJ7BbeIglATqCiM=;
        b=Xx1gnwaWiyxSlgtlzf3yAzKGunNNKWCamksFgNqACmRfMnB3qTEzonbb6HpNBjskO3
         VBuamkf1unnUZNEg+YBFTnFV+JYYrYUOKvukPLsooxkCEOPPM3YH4O6VwCdearhpstOs
         2qTRX2X59LSJAl7UZP39U5CMCnYXilBC+O8vhf5Fs/CLCr4qMBdSY/CSCb0sfNyuIyfI
         yhzRjiK+8XoiOKtj7+lu1HRVwlnRFbAZ7+28o4D8uQ4SKsa9TrJ8z9kkNO7KNFn7ebWw
         Lb31XL3B0edWdisbq8vxl4tsEpeiLcQ3yj02g2ZguS5nczVyO4EVvnvkn7qpYFgf0Dk6
         qh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dxzi0LW4RlPK/kr+U7GGFfgJIv2CJ7BbeIglATqCiM=;
        b=jGvKb9xmB7tb1AZlHpOsvhtRZGlLEX4EZhVDIjgEkd1o2LASpFglOAbbOBAhur86wa
         FelRRS9HOuZy/8z3HU6zLwFNvKoql70rbIlbPcpmohTb8hb9HtpQ+Ki/7wWt2jKs40D1
         QR/yT04uzrL54u8RsBPAWwC4k9eeDqT//ytgjyB0qV8udWMPOrKdaGMx/4Iq6jeyptJU
         Kjsnc+MHMTRxHiYYjKkW4m+0B9aTdthu0z5t9jJC/YmWWXv0NoDGiE4pqs3RWkfbxXNk
         LlfvzaLAm5z0prYWeUPfGfWIBkDTFEzeh10gzJ+cedJpubS4nEKCK0014pqAcSazhPfV
         d72w==
X-Gm-Message-State: APjAAAVwa2RIUG07xDDB/JmCQGJuEzYXEAtWGc9W3a6yEt8yL8RzXoak
        ddHCo+4+Yc4GMGXJ3Ycj9jsVe0RC
X-Google-Smtp-Source: APXvYqyCQbOKo2RqOsqLd/VCvYjgup3UpiELMSIF4/nqiPfRBkPLqMgPoxWK4lGjvFxqlHSLgghiYg==
X-Received: by 2002:a1c:7d4e:: with SMTP id y75mr15658420wmc.169.1562573928266;
        Mon, 08 Jul 2019 01:18:48 -0700 (PDT)
Received: from [192.168.8.147] (130.165.185.81.rev.sfr.net. [81.185.165.130])
        by smtp.gmail.com with ESMTPSA id b15sm14964597wrt.77.2019.07.08.01.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 01:18:47 -0700 (PDT)
Subject: Re: [PATCH] tipc: ensure skb->lock is initialised
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
Date:   Mon, 8 Jul 2019 10:18:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/19 12:53 AM, Chris Packham wrote:
> tipc_named_node_up() creates a skb list. It passes the list to
> tipc_node_xmit() which has some code paths that can call
> skb_queue_purge() which relies on the list->lock being initialised.
> Ensure tipc_named_node_up() uses skb_queue_head_init() so that the lock
> is explicitly initialised.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

I would rather change the faulty skb_queue_purge() to __skb_queue_purge()




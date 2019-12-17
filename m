Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A1123AF3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLQXgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:36:35 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38070 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfLQXgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:36:35 -0500
Received: by mail-pl1-f193.google.com with SMTP id f20so98655plj.5;
        Tue, 17 Dec 2019 15:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xkuE0Re50X58qMcOOTpNENDS+WqmBfa58nlwdeEP/sg=;
        b=RhJaSLhDCOZDRdViIhV0f6JTBvsiMe1QEkv8QulUVRvfHBvOOhC7vqSo8iwqr7odEC
         w1jHw8URrrbi0yQFiIaTYcMUXoewUx3jHYzSonGIGbqN6SYTdACAM483cvZkjgga0HhB
         t3h9nuAtFQ/7aZMgSQvVWs2huX5EYb3uEEtZsydxxGofeme9Hxn5tELy5ER+7Sh0mEDJ
         kjnYMy9VZRd8uHcrTxbPnqrj4nO1rfcWK9UOMdFCR+mA5PObNwicJS3XmCrxvb2aCutZ
         r69PTtYe5RKcsTQgsVjPK+Tbm7kAWoZQMCliZCjvMZHv7k6TrNuPlAh3RCcuhQoP7avJ
         PZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xkuE0Re50X58qMcOOTpNENDS+WqmBfa58nlwdeEP/sg=;
        b=lyAvJAVZjzDBQ1MjCv2qPrWCYQd1sn5oXtY5pg8vyzRY0WB+wx44s+31Y4wazNukbS
         1fpvFthX3MV/FotVPBsHEWnv/Jptt88SmUfPPmGPZk05pKEH6UAvfHOCsGqXvK6v0Kp1
         mDHFAqmW9sIA/OHedGpmZpxdeFrQKzoF2B7UK5NIpxSV2iJx3OMpriFHlFvMD7f0RI5W
         jWjDzs6mJTO6NRy5VXVBBFEOSEYpJGLaD6m69lHQTA/Z9QfFF1XvydChAaHv02nS9j2P
         JBax6pH3gz+DX3DaZMSF548tubboaF1SKv6k8NlEif7TEr/IUjR4iOoyR8G8JKPy08j7
         Geew==
X-Gm-Message-State: APjAAAWLQpajkInXh4/5V643ZGEpSj30yMrA9n+mgF+//04bMf9pF0sh
        ZMhKHpyPDzDeZP6O/WsO/EhM2xb0
X-Google-Smtp-Source: APXvYqwsmxSvCnlCnOWQZbZDEub7d8RLvy0B/w08aUO3aBV43AnXtZ1a8L2bQfNc9LzYPnRvBvkc8A==
X-Received: by 2002:a17:90b:3115:: with SMTP id gc21mr79930pjb.54.1576625794394;
        Tue, 17 Dec 2019 15:36:34 -0800 (PST)
Received: from [10.67.49.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g19sm125791pfh.134.2019.12.17.15.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 15:36:33 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for
 NETIF_F_RXCSUM
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
 <1576616549-39097-4-git-send-email-opendmb@gmail.com>
 <43c460b7-9091-6306-3d39-a4ff1fdc0d5d@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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
 rQQYjNSD8+NSdOsIpGNCZ9xhWw==
Message-ID: <60fdef3f-3926-d960-f0ce-7effd9578495@gmail.com>
Date:   Tue, 17 Dec 2019 15:36:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <43c460b7-9091-6306-3d39-a4ff1fdc0d5d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 2:52 PM, Florian Fainelli wrote:
> On 12/17/19 1:02 PM, Doug Berger wrote:
>> This commit updates the Rx checksum offload behavior of the driver
>> to use the more generic CHECKSUM_COMPLETE method that supports all
>> protocols over the CHECKSUM_UNNECESSARY method that only applies
>> to some protocols known by the hardware.
>>
>> This behavior is perceived to be superior.
>>
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> You could also remove priv->dma_rx_chk_bit which is now write only after
> this patch and not used anymore.
> 
Good idea. I'll resubmit shortly.

-Doug

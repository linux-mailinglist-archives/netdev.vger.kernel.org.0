Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AE5D6C9F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 02:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfJOAtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 20:49:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35104 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfJOAtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 20:49:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so11335967pfw.2;
        Mon, 14 Oct 2019 17:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JXMngsyZurHd5XVLb+wxD7GSYr5w0E7EB4PGGw+FTU4=;
        b=pqn2J+vsqlRUrE6M6v4sNot0wugbfaj42I9stgWuzkYKqtjVwhF5GwzkQepJhUober
         lnivh3HBb4rky9B+SJ2C5m1kO8IL0jXDfpi103ZNXekUkrkyGPL4yrRpkWkacDEV0tLB
         zSMIdVzuyKgzUJ1dkJexHTAfvMIkZUTIvxSk/bKfMIIIGh/v1vvO8SXSy+zABlUNj7dr
         KkWGeV92ibqFQTWK4L1SSPzUMa2cQuIPVJWlLgVqWK1x1+/ZHA3+gysgurJp1lZJC7CU
         lGTgL2NwWUsOK6leUl6/IoAaOfJPMMFgGkTJAnWi8T1nrtlp7bSueU8mc5c740m7z73d
         9DuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JXMngsyZurHd5XVLb+wxD7GSYr5w0E7EB4PGGw+FTU4=;
        b=U1Zz0yUUlTCPcDivy0qXHu3CXWyyZ6GcbYs95GeUqdfbkrb9XF2oIfECXbnGSvHmec
         YZXiHf9a9Kzl4enIEwnpN8xBFVNhmjjN8rt1P5efiePxN8kcRBnAtzoXvcqSgiKf/BFN
         SHOBGPEzwFvBkpEl9jPJgIgf+vUHliGqTKpYseq1kdhUD7fP4C6R9Rt9gFYXprmvXx/r
         Swfe5rsZDIe92tfrKXTNkfho8qPm6jWkhntEYeEdRzxP+C7q8o+0XIUAox5qAF1hJ4Ek
         gQRUybsFdbQyG5+pSvxoe8mIBMk2lMAYsebm3Z1OH5rJ8SdopZB4oHOGPh0NOnOTO6d4
         klqg==
X-Gm-Message-State: APjAAAVw2aUWC/UmPWYwHg1bQ9lBRm7805uGQKepDvv6WMIBfEBYA+pV
        caLGRDPkzkSBGNzCB3qyqpBWSJdD
X-Google-Smtp-Source: APXvYqx+oVyXcfjA5j+HRs2N1Js3UY8BFXlubnGaHmD0RnBXxNJJt8KcaVNZllT0FTjjby4g7r05Xw==
X-Received: by 2002:a17:90a:eac4:: with SMTP id ev4mr39502736pjb.97.1571100580455;
        Mon, 14 Oct 2019 17:49:40 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v9sm17960956pfe.1.2019.10.14.17.49.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 17:49:39 -0700 (PDT)
Subject: Re: [PATCH net] net: bcmgenet: Set phydev->dev_flags only for
 internal PHYs
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20191011195349.9661-1-f.fainelli@gmail.com>
 <c3e47479-1f13-f35c-5153-a9974723ac5a@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <6c8757a1-4618-36ef-7967-5251e98da5ea@gmail.com>
Date:   Mon, 14 Oct 2019 17:49:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c3e47479-1f13-f35c-5153-a9974723ac5a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 12:57 PM, Florian Fainelli wrote:
> On 10/11/19 12:53 PM, Florian Fainelli wrote:
>> phydev->dev_flags is entirely dependent on the PHY device driver which
>> is going to be used, setting the internal GENET PHY revision in those
>> bits only makes sense when drivers/net/phy/bcm7xxx.c is the PHY driver
>> being used.
>>
>> Fixes: 487320c54143 ("net: bcmgenet: communicate integrated PHY revision to PHY driver")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> FWIW, I am preparing net-next material which allows the phy_flags to be
> scoped towards a specific PHY driver, and not broadly applied, but until
> this happens, we should probably go with this change.
> 
>> ---
>>  drivers/net/ethernet/broadcom/genet/bcmmii.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> index 970e478a9017..94d1dd5d56bf 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> @@ -273,11 +273,12 @@ int bcmgenet_mii_probe(struct net_device *dev)
>>  	struct bcmgenet_priv *priv = netdev_priv(dev);
>>  	struct device_node *dn = priv->pdev->dev.of_node;
>>  	struct phy_device *phydev;
>> -	u32 phy_flags;
>> +	u32 phy_flags = 0;
>>  	int ret;
>>  
>>  	/* Communicate the integrated PHY revision */
>> -	phy_flags = priv->gphy_rev;
>> +	if (priv->internal_phy)
>> +		phy_flags = priv->gphy_rev;
>>  
>>  	/* Initialize link state variables that bcmgenet_mii_setup() uses */
>>  	priv->old_link = -1;
>>
> 
> 
Acked-by: Doug Berger <opendmb@gmail.com>

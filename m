Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86EC7B545
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbfG3Vva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:51:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33648 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfG3Vva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:51:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so30531157pfq.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 14:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZG/uK8vgPFyIG/YhGs55iyjYcyzy9pCqx6GnznS+7nc=;
        b=Y3QaN8IiWf8AWy0+lPKrNmQRVrboD7iqD1BzZbX/LrFmHMAlBlzUjP92RKLqfW8OQX
         YITmmhWGVZRUj8H0JuD8hQlmGl7SWrUtVSzm03vstro8fDO1xkL0QbjCIrse2eeKisfv
         J3RiXWWp9mD0nPQRxJU3Zl52ZmM74DgSiXLUMvA7BQjv5NqRH1ANPuINExC6LkVyTkhz
         oMQZ2//oLKSBThu3/bFpydF94huFFfLUlY9Nexvi+s+p0ZRExWIRwizw/ccdAVxxpfPF
         H1EUQPp2nw7whSVEagWFwGjDfrBjwM+jJs6cUJ3oZQuZzL2XZyp9BYEisLGvTuX/4RuD
         sKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZG/uK8vgPFyIG/YhGs55iyjYcyzy9pCqx6GnznS+7nc=;
        b=NNxPPjyU+9TNGaGv1Ggukq89j/hTVXGNjocY4y7hVrNV5v4iMm1ZEnqQ0NqoKnnzV2
         XmVk5jdpEsLeQXx+r18wMCgYwh5tVE81hjZcRWYjYoA0B1ncACKjWb7UrE5vSJuEAYN8
         beUOhqc7sJ9ADQqIEGsU4ePZUkxNjnGJ3TmSTBwdiF94j2EHkeM9FijOvoNqLwV4/YGc
         W96zLjchsY09111HHQ2au/Tyf+Vqbuz9Ld7G6vtrS1w6XBCT+UXehMR7hTgMzx3VW6sY
         F7vIwPfH1VHnuOBhwXQd+dr2Jo6XChFwuN7p9d38BpfWGfDBjbIWWbdBFd2WT6BU4wsZ
         F4Mg==
X-Gm-Message-State: APjAAAW5jf9GPJBoXzQt/KwRXWIswF61BAiATQMwRG8RXqe1bngk8Wi8
        QZO7YijyofiXv5dPSeri7gzKxMYcceQx3Q==
X-Google-Smtp-Source: APXvYqzIeIqCyMQublX/GF4lEX4UySNJ9dFL0zARUuTjIkUqbXoUxENFuLgxHk3n2aUKZix/GbWlmA==
X-Received: by 2002:a63:10a:: with SMTP id 10mr26972583pgb.281.1564523489327;
        Tue, 30 Jul 2019 14:51:29 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j15sm65756204pfr.146.2019.07.30.14.51.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 14:51:28 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-14-snelson@pensando.io> <20190725133506.GD21952@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3e0e946b-dbe3-2a64-2a2b-7654038a5fb4@pensando.io>
Date:   Tue, 30 Jul 2019 14:51:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725133506.GD21952@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/19 6:35 AM, Andrew Lunn wrote:
>> +static int ionic_get_module_eeprom(struct net_device *netdev,
>> +				   struct ethtool_eeprom *ee,
>> +				   u8 *data)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	struct xcvr_status *xcvr;
>> +	u32 len;
>> +
>> +	/* The NIC keeps the module prom up-to-date in the DMA space
>> +	 * so we can simply copy the module bytes into the data buffer.
>> +	 */
>> +	xcvr = &idev->port_info->status.xcvr;
>> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
>> +	memcpy(data, xcvr->sprom, len);
>> +
>> +	return 0;
>> +}
> Is the firmware doing this DMA update atomically? The diagnostic
> values are u16s. Is there any chance we do this memcpy at the same
> time the DMA is active and we get a mix of old and new data?
>
> Often in cases like this you do the copy twice and ensure you get the
> same values each time. If not, keep repeating the copy until you do
> get the same values twice.

Regardless of how the structs are all aligned and our PCI block does 
large writes, I can see how an unoptimized memcpy() that is doing 
byte-by-byte copy rather than by words might result in a mangled value.  
I think this is the only buffer that may be susceptible to this.  Sure, 
doing a double copy should work here.

sln


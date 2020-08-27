Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37655253AD3
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgH0AEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgH0AEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:04:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACDEC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:04:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ls14so1664921pjb.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=P0DFWP7+PG35oLq3ctNE6kNv0Fm2bxtl+x1O6/Pv1kA=;
        b=b1d0gsauhK4+4SBEjSWruh+lz9V4rWp2p49nm7h7Nv8z6glQZ+yMMwsiW6KwHGZGek
         L3sZq7CsVSkraiCOGWtTKL7v9inFOk+DAfib61CkTqd2oyWwU2GQVlTbPG2jkqvcqwtl
         rcGmPThKqFiiSAHony3YMQrwJ9gVZo2M+2OzflgUfdayho9qi2QdzwW4QMXaw3i0HMjL
         WhPbFcGrgIDf2904JvjTNBddVQcYLsz77fm+otbwjxhhflxc5VnakP0NOPejqgV41ntU
         jgTFQ7jqhZV+QLV7jFzOkjqAFTqIaFutOP1wN4QWX9ewzHTSqYrkw+CH4YVwRsyv/iKj
         SmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=P0DFWP7+PG35oLq3ctNE6kNv0Fm2bxtl+x1O6/Pv1kA=;
        b=W4llPZEttob+5U5a7/6ZE/v+ZaUEhhGenG+3eKOmj+NECVw8T4qtLG0CN02XR740Xs
         JP90T1Tn7AI2cXTQAFaQg71QN+B+eKrHJ0QL3KxG+jjHV+pbHkUf+ak00yf3x5YejOXg
         qFmwd5z6xCPcBtHtYYj+z1zoeW2b1MRpt0kr4EE4sh84FWl3mscFZOa19VHiTGmzeKe1
         YcVTSpOqhoBZBF99FtceWHHMVHZYUH9bFGGYL9mRLz8y/I1EXyPfLDae2W/JQQn5+Vz/
         RioXWj5AEGz0mQnXxMWH8YDOxqyINB/wVpp84AEg6fmrk8Dqrlms3+gNqk4PlTBUOzVx
         Bd7w==
X-Gm-Message-State: AOAM531TLRdhs8dXnzDfgmBAS32VdOW4lBXjS7Qog+7GewqvL4X7TTuZ
        QMNjUm4F8ymNoUluGbKwpzwsTQ==
X-Google-Smtp-Source: ABdhPJw00uiOMhLY6r8uduLL6nI96twqYHZAeOqiGlxaOvahb4nrtt40npPlzyKndx3Sm5pas0REQg==
X-Received: by 2002:a17:90b:1b43:: with SMTP id nv3mr8266671pjb.22.1598486693624;
        Wed, 26 Aug 2020 17:04:53 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id s68sm320055pfb.91.2020.08.26.17.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 17:04:51 -0700 (PDT)
Subject: Re: [PATCH net-next 09/12] ionic: change mtu without full queue
 rebuild
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200826164214.31792-1-snelson@pensando.io>
 <20200826164214.31792-10-snelson@pensando.io>
 <20200826140922.0f1fb9fd@kicinski-fedora-PC1C0HJN>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <cbcedcf2-f199-1d10-4169-7605cb55794f@pensando.io>
Date:   Wed, 26 Aug 2020 17:04:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826140922.0f1fb9fd@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 2:09 PM, Jakub Kicinski wrote:
> On Wed, 26 Aug 2020 09:42:11 -0700 Shannon Nelson wrote:
>> +	mutex_lock(&lif->queue_lock);
>> +	netif_device_detach(lif->netdev);
>> +	ionic_stop_queues(lif);
>> +	ionic_txrx_deinit(lif);
>>   
>> +	err = ionic_txrx_init(lif);
>> +	if (err)
>> +		goto err_out;
>> +
>> +	/* don't start the queues until we have link */
>> +	if (netif_carrier_ok(netdev)) {
>> +		err = ionic_start_queues(lif);
>> +		if (err)
>> +			goto err_out;
>> +	}
>> +
>> +err_out:
>> +	netif_device_attach(lif->netdev);
>> +	mutex_unlock(&lif->queue_lock);
> Looks a little racy, since the link state is changed before queue_lock
> is taken:
>
>                  if (!netif_carrier_ok(netdev)) { u32 link_speed;
>                          ionic_port_identify(lif->ionic);
>                          link_speed = le32_to_cpu(lif->info->status.link_speed);
>                          netdev_info(netdev, "Link up - %d Gbps\n",
>                                      link_speed / 1000);
>                          netif_carrier_on(netdev);
>                  }
>                                                                                  
>                  if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) \
> {
>                          mutex_lock(&lif->queue_lock);
>                          ionic_start_queues(lif);
>                          mutex_unlock(&lif->queue_lock);
>                  }

Yeah, that would probably be better served to just call 
ionic_link_status_check_request() here and let it do the job.
sln



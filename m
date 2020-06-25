Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A0620A893
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407665AbgFYXIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404729AbgFYXId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:08:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ED3C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:08:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so4063897pgc.5
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gycxXNrVCi1sxQvR83SGvloY2xkwpbwl4Qq8sQkDdMc=;
        b=XWMlRp65tDqELbS6hAaHqq8ZYc7shyIDaA9Q5XbTrjPbH1tHGnBroj5kn2KQ8dv3Mu
         rVbmohH1ZOuEyMe1tQZRuzhyFvaMlrFagxUUFBRTw8nOabymL5Gy8W+Eih11ALiMqsUv
         IuDCGxNDfEKmmTmOP5GnXdhdeWC13iNwN1c5JYoWjLxA9ctopXCDRwmAARYw7sEfG3uM
         r5bpiOzBOXkeWBF73+Kty561kJAg1BYt0AYO94ubnJj+Ugx4ltsKsz104ixzBw5eBhAT
         aCSoIUvpbdbH1sNzllvtSV+sOlfxZCerdbIMcm8cKs5VCVJ+flVpsYBEw2UetWu5xTdk
         aYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gycxXNrVCi1sxQvR83SGvloY2xkwpbwl4Qq8sQkDdMc=;
        b=TfgPbeuCUle0WZtrWZRuPYHeieRhgz+p+HqPEENzCq1d+m9tLdUFbL9ZwYTkpqeKRT
         OiQqICFdukYBy8gQIlxTSv+j2xuIFXai+SDkILHO3tTp8NYLcLYslfuBoxeguneIBpjC
         au4azMudvecMbCa1Ktkij6jlu2Z79VWC/vLi6lRTy99Fi6PCN2WjN9hWY865+mLuA/6T
         2Ri+diSGjVIfAYniTkScoiaUknMq6REZascgxZkpjE/UtoLdM4V0NQg164v7mMBUCmXp
         YCFpULHv54jVZdxLIkSSV4IQxdmM0+QRJ5GrYxoA43q8nx8/aGUkDdRJa426ttenfR6z
         bvCA==
X-Gm-Message-State: AOAM533ZMz9et4Whi15W7lYTMUloBIFSrQL33Ei7fDIQ/FnwDCmkFEi8
        PrqW4Y4WldqcnPaBRydl19mlzg==
X-Google-Smtp-Source: ABdhPJz6ZrXNwnT0XCwy7NUtdJKUWC5vYk4PZ920N/1/ULBrDAv7iCLGGtjtc9a49gkbeO+ht0lnpw==
X-Received: by 2002:a63:1408:: with SMTP id u8mr194001pgl.282.1593126512722;
        Thu, 25 Jun 2020 16:08:32 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m1sm9291818pjr.56.2020.06.25.16.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 16:08:32 -0700 (PDT)
Subject: Re: [PATCH net] ionic: update the queue count on open
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200625201215.57833-1-snelson@pensando.io>
 <20200625155754.0f9abd7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <84163d8c-7e84-e9c9-27c9-f498416764ad@pensando.io>
Date:   Thu, 25 Jun 2020 16:08:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625155754.0f9abd7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/20 3:57 PM, Jakub Kicinski wrote:
> On Thu, 25 Jun 2020 13:12:15 -0700 Shannon Nelson wrote:
>> Let the network stack know the real number of queues that
>> we are using.
>>
>> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index aaa00edd9d5b..62858c7afae0 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1673,6 +1673,9 @@ int ionic_open(struct net_device *netdev)
>>   	if (err)
>>   		goto err_out;
>>   
>> +	netif_set_real_num_tx_queues(netdev, lif->nxqs);
>> +	netif_set_real_num_rx_queues(netdev, lif->nxqs);
> These calls can fail.

Ah, yes they can.  I'll update this.

sln


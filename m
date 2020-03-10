Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D07917EDB6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCJBJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:09:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35052 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:09:22 -0400
Received: by mail-pl1-f195.google.com with SMTP id g6so4735786plt.2
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UjYHIwz6Li64uSXmirMlk5+8qBQUYFW70oHAHMGXYRU=;
        b=J19QAjG/Pv7rz6REIeWOSE80EismZmGkStEhWcY7aVMeDlVMKXXboUOOCCJj2rZR+F
         RaW2UInEUA1htk2Uc503Td1AprbL089/K9aZXSXpuLlCxFp1YLviWtKsSSvT5l2mWrth
         QF54m+MRXyKGQKr9Cd5v3xlfaFdnUFS1p+DwqrHCuM8ievsGESvjKJmx32RhwJpGZhdU
         x9ve6pDlp8m8q7ELDaFYr0ztOlUucXnwg0zp72LUXE4UdRpnn1Gq53e+ovCWJeYDUBx1
         vh+CoiJOAjVV5sdPLRk8nAbYmKXhHJraom8Ku2tr8Q2wiQylXTJtQ9kP2WYcJrNFHANQ
         4VhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UjYHIwz6Li64uSXmirMlk5+8qBQUYFW70oHAHMGXYRU=;
        b=EA0+dIt7CBI7DWl2BIpSD0ISaJwFHbxF10e2EhyA6WmGrtWRS2dT8wCzUonUC4fo1J
         2cRmrAvnJfbb+sygXF1P1F8NNkFIRwckMSedid/hHvz63j/w8tcXJnos97msx5fotwVN
         ukgdUpBAD7CdvmgqP9p6nfGzlvV4mTQ+KpmvEC1HzndMwz3uaLEU7fJvEUk+v9Mku9/H
         wjIiuUB9/u5BCyhCNbVOcLTR8nzXgDh+uCrKc7eW7D4HC0Htq9Upje7U6jpHiWfiomcs
         sag1zSiHRiZiZnxjyU+EIs99Lg1AOkCINnFgxamifFzwdoLXsmKoqWnU4XvDcJQvikwn
         /P+A==
X-Gm-Message-State: ANhLgQ1t6bR4ELGKJGdoKbSBDUy8zXGNYY21VLzQaW6AzwR2zgquyYL1
        0cpHP0z44zQ2pxfyMZ8kEyQ=
X-Google-Smtp-Source: ADFU+vs4AIUFfbEvScFhnXsuy/yMmGg6fCgL5brbLI4Pw728YJv3C75nIvXsriDI25bCovRPaA6sbw==
X-Received: by 2002:a17:90a:fb52:: with SMTP id iq18mr1219846pjb.32.1583802560003;
        Mon, 09 Mar 2020 18:09:20 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q13sm45373364pgh.30.2020.03.09.18.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 18:09:19 -0700 (PDT)
Subject: Re: [PATCH net] macvlan: add cond_resched() during multicast
 processing
To:     Mahesh Bandewar <maheshb@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>
References: <20200309225707.65351-1-maheshb@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7bf02268-f324-2cde-da35-44649afad2ac@gmail.com>
Date:   Mon, 9 Mar 2020 18:09:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309225707.65351-1-maheshb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 3:57 PM, Mahesh Bandewar wrote:
> The Rx bound multicast packets are deferred to a workqueue and
> macvlan can also suffer from the same attack that was discovered
> by Syzbot for IPvlan. This solution is not as effective as in
> IPvlan. IPvlan defers all (Tx and Rx) multicast packet processing
> to a workqueue while macvlan does this way only for the Rx. This
> fix should address the Rx codition to certain extent.

condition

> 
> Tx is still suseptible.

susceptible ? Not sure what you want to say here.

 Tx multicast processing happens when
> .ndo_start_xmit is called, hence we cannot add cond_resched().
> However, it's not that severe since the user which is generating
>  / flooding will be affected the most.
> 
> Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> 



Reviewed-by: Eric Dumazet <edumazet@google.com>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7067647B4D7
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 22:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhLTVLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 16:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhLTVLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 16:11:46 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A7CC06173F
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 13:11:45 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id g5so142179ilj.12
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 13:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V2JPrxTFm1Ac8AEfiOM1A2yxvZGoV8JL5X2KYXtDaVk=;
        b=q4GRtI+EVzO99+VvV8lz+ypDcQ5nEuD/9K8QFuzmm50n1iRFQSgKGOMSrJaM05N0yB
         ccWBLtwHhmp0DLdG7bhS3H2ItXnvCxBQ6IkiH1dgwCIJP4H0e+1TnFZ99y1SPOdWgebM
         NKhUntBnUNKBquZr/tWnZ8+yblP0E7/u78c5sQGqG3N1rcb9YslBk1cHcbgmUvBiQx9x
         Pfuu31iBEhl+YgpKluR+1vjBvH/fXUGxO2GhcZaNN/PPA9JFgw4Yo2bIDG40R429/8SB
         v7VY3p1FNZMdLUXkNHI/qgorlH+f4AXdJnEeciRkvHeXrEn75tcb/2VTFLHKf8WUHbjB
         rQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V2JPrxTFm1Ac8AEfiOM1A2yxvZGoV8JL5X2KYXtDaVk=;
        b=awty8Sfnva+1Ac3M2RHQMhCQBL5SUAoJat4GyZjKoOZVWOx3TMpow7Zyvqbkxdg2dA
         SWeV378L14G0uO7hhtsqHmYrFf0rj6zcjoT/bM8lG26J4X2C6J85pSRqsATZs0HvK7HN
         bOc41BaUAlneW8YzgIY1EynrdeXk1HgF+racPDp1Z9wReBuJDDxn2BRcdLAJljC3cqNO
         ccF8RtKWEP9Tpp817W0WI3KHNst+zUE01cBkvQ7JOtBPL3pJthlTY2Z6P+0LbbIrCeG5
         +l7qRyRU0PvjWtaF8wyghAW+XZe+i6EWGujkzAPXGBj97cS20f6Rw2fQYy+4PxiM0l/a
         haSQ==
X-Gm-Message-State: AOAM530Cvsu67dNoi0OUxbhyPxn6Ee8robuynOIwdLEnMkNOrD5zk4k0
        eTa7Xg9/opx+61g/fMjb5zcfXNULDR0=
X-Google-Smtp-Source: ABdhPJyP5mJDEPlaGMx9eUREs+0Ne/15Maq69bzKchrZ8Ms2ADQyGpcLYpeMqbGFlJ1yHNmyKCc7pQ==
X-Received: by 2002:a05:6e02:1988:: with SMTP id g8mr9573466ilf.184.1640034705231;
        Mon, 20 Dec 2021 13:11:45 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id c22sm9273811ioz.15.2021.12.20.13.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 13:11:44 -0800 (PST)
Message-ID: <8df990f1-7067-b336-f97a-85fe98882fb9@gmail.com>
Date:   Mon, 20 Dec 2021 14:11:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
 <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
 <20211218170602-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548189EBA8346A960A0A409FDC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20211220070136-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1BA270A1992AC0E52A8DC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <PH0PR12MB5481E1BA270A1992AC0E52A8DC7B9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/21 12:11 PM, Parav Pandit wrote:
>> After consideration, this future proofing seems like a good thing to have.
> Ok. I will first get kernel change merged, after which will send v3 for iproute2.

this set has been committed; not sure what happened to the notification
from patchworks bot.

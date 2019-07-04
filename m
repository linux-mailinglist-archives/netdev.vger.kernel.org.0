Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958F55F7EB
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfGDMXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:23:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37273 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfGDMXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:23:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so6435327wrr.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 05:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6X6wN5tRbgbI+cebnIMXuypRB8LJ3Vmym53J1IUNz58=;
        b=MiFlXmZVdrv/36a9gviETGW8LxuuJvPgNy5kNdY3s3MPs6FS1WkNwmcMWMgFOiz9dM
         0DKlVlFaMx7eTbQrDClIFtx1/BfE348wZKGHSrYRZ19RyUrdQlc7p3W46D/i46JCbmb1
         Ky05RcuIKozM7KDM5wo6YALtE22yVXiQPLryZ2TJHuCnqG0UINeCPtuOOUqt27gUFkyb
         WLmmRGRLxKxqkUOds8CvM311iqLGgWjipj2Ghymk1LzQDCxY6pHnLBJba6JtlPWzDe+c
         ilIWm9muYD0E+0elOLe3gYpJWolO3rqwgZovkry2BOt5FTlozevvza6aUz6CZgINbmiN
         Tkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6X6wN5tRbgbI+cebnIMXuypRB8LJ3Vmym53J1IUNz58=;
        b=S3b1pvBaA6A3a8chK4+UoHKfUHjxstQUEJZXk3ynseFtjRXO5EQ6a3yn17uEj41z5P
         4izQp+fs2ZsRbHBPH2WW4jdaEJzpx4Iqkxodqo9BS2mJTtDdEexMY8qJ5KIarlWSsZp2
         AMp+mRvfu0P/1VDMfxDWAMQNLhzwK1wX538LTOQVblSGBJyZ6AaW9H2fqhQOmPjx867f
         8FzbZOFaWVuoGo4FIfMrO+zqGTIOKjooi+2jcJrhIfJlt+DU7Yc679YQ4q7p7xCU5gZc
         r15dhUm1U0G779KxbfipCd46CxdKfwyQekMj3uUmxlfiGmUn2u2EYHXncEwDMySKHhdk
         pfeQ==
X-Gm-Message-State: APjAAAVVIxdzN/+SgjO4aQGn+/GeOxi1bUXVhDGM56Xa9KygpmsiDXIH
        8BpHzgAVDMhrX8f3UVm6osWOEw==
X-Google-Smtp-Source: APXvYqwqbs7v6jz/CbD39KWaMatM9j2BNJ92miRdmn8zRSM17yx/HvPBaxTBXMkYKSd/vYWutkt+xw==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr33882629wre.205.1562242983966;
        Thu, 04 Jul 2019 05:23:03 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:444b:acce:b846:df6b? ([2a01:e35:8b63:dc30:444b:acce:b846:df6b])
        by smtp.gmail.com with ESMTPSA id n2sm4261859wmi.38.2019.07.04.05.23.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:23:03 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec v2] xfrm interface: fix memory leak on creation
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>,
        Benedict Wong <benedictwong@google.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Antony Antony <antony@phenome.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        Julien Floret <julien.floret@6wind.com>
References: <20190702155139.11399-1-nicolas.dichtel@6wind.com>
 <20190704102210.GK17989@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <5c1126df-c6db-4f6c-4627-a4d37bfb609d@6wind.com>
Date:   Thu, 4 Jul 2019 14:23:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704102210.GK17989@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 04/07/2019 à 12:22, Steffen Klassert a écrit :
[snip]
> 
> Applied, thanks a lot!
> 
I suppose that this patch will be queued for stable trees?


Regards,
Nicolas

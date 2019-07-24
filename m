Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A072344
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 02:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGXAHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 20:07:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36523 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbfGXAHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 20:07:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so20213778pgm.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 17:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=ZE/aWvVDvaXmlN8PzPf1298EWErSQ9u4MrfGdZ7NiCY=;
        b=Yv3+jyOJwFxvqPPbyH+urcYYPIRwrgoOL6jQ4s31X3PAkmmN8i00GfkexTcAtcUhmR
         GMlakJJnpqd025AlIkBaXYmf5zn955C2GLw970xs/GXlLAplP0RI+w8jL5XtpRhCFZQf
         LWLsBH5vMzpoRwE6C9MuxrSTFbDk9hxc/vjkO3qIh3UaMljXbzbA4vFf4VfeL4XSEJo0
         0i/iZldEbyxy2WWIA5w3V1Wv5BqXuoj08oibfd3fUM+aroCOjlnWNVhYHohzMKoXXr49
         LAZkaCeB++08GqROqPVWW3sDn+i1DXNYmHOczdg6w2oq34TkmCU27cOy8Ort9RG7zNQ+
         zOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZE/aWvVDvaXmlN8PzPf1298EWErSQ9u4MrfGdZ7NiCY=;
        b=QRcbPvo7fMT894iUM/TOoAmxZOxDtaOXMKXJ6WG/31UF4TroSpB3Sq0H+pSwLkVr+D
         79oPiC0JdrIRctOkaqNFf/4oaHSRAlqn1nS21OW1aUHiYjOTJkrzRM8z6jmXJSL71cGp
         7eVCMxTpvuruHFHLQLgX9dn0dQdaJq3mldCjbdBKFjx35Tvd0yL6acIWQoBPCxMDuvhs
         b5GpzAb6rm4hpvY0blX+KAHG0D4qgwtE+K08tqLJK4vQWRGZxh/7gr6q65erGTWx3DBD
         skyB871z2XJc10//FAS2trtLesQkMVxbOhhlrYOwEuUcIdsExqvXBdvBOC9iHxVptIUx
         oDuw==
X-Gm-Message-State: APjAAAUjowyIPai/lJZWiHwqAIY5SdxssHSKdlFaFJ4CCflEZbNYLavL
        WrKw14jHPOKXpdDwHCfyzEslgg==
X-Google-Smtp-Source: APXvYqwYqHqnGb3Sbw7GlL+7tixw3gT6OYKGZ4hV4Tt/yLDElyoK9W3PRUrhDfi17wROM6geUjSxOQ==
X-Received: by 2002:aa7:8804:: with SMTP id c4mr8252593pfo.65.1563926864223;
        Tue, 23 Jul 2019 17:07:44 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id r188sm69568353pfr.16.2019.07.23.17.07.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 17:07:43 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-12-snelson@pensando.io>
 <1ce8b25ccb5632a33be6d18714aadfdabd4105ce.camel@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <dbc85d6d-b0cd-43d4-aded-88b482ecc477@pensando.io>
Date:   Tue, 23 Jul 2019 17:07:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1ce8b25ccb5632a33be6d18714aadfdabd4105ce.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 4:20 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>>

>> @@ -607,6 +947,8 @@ static void ionic_lif_free(struct lif *lif)
>>   	ionic_qcqs_free(lif);
>>   	ionic_lif_reset(lif);
>>   
> I don't think you want deferred.work running while reset is executing..
> cancel_work_sync should happen as early as you close the netdevice.

Given the current implementation, it doesn't actually hurt anything, but 
yes it makes sense to move it up in the sequence.

> I assume ionic_lif_reset will flush all configurations and you don't
> need to cleanup anything manually?  or any data structure stored in
> driver ?

Most of the driver data structure cleaning has happened in 
ionic_lif_deinit() before getting here.

sln


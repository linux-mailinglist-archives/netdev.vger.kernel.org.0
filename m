Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166DF3DA2AD
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhG2L6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:58:40 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39386
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234912AbhG2L6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:58:39 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 5120C3F0A5
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 11:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627559915;
        bh=mJegt6nAKectUckt+rbFcl6x63P1a1GPjk8ahj5YQQU=;
        h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=bQGamwfephWaMoWpVCkkn6eCMN3KZaBoWqWicZ/qbKALsfgq4hHLFVuaMtxQWYAe6
         /SoeM+AKnrhtCw2Izm17aHvKnl1DeKyE39GgEIdY1DKgxYWcAe2hBKDjPE0Lgz4BWp
         w28yBjEQOLTe14gTT4MVxOGq2cahZs3scRYruWtIWCiHxQq4zZPtQCp/gf5xed38ru
         0Pi4Y6uqp779oBX/W+n7BelGsVbD6+ubLDIRvE+E9ArgKmalQ0vbqLSULXFFmfj3gi
         eCG7jKJpRw0Hn05NSmjREt6ODJPb1YsR8ETYYs3Eirrk8fssajqcvSVPS2XEyXIPpq
         ANnjJ6G20RQwg==
Received: by mail-ed1-f70.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso2854080edb.8
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mJegt6nAKectUckt+rbFcl6x63P1a1GPjk8ahj5YQQU=;
        b=prtF6dlBHC8UZlT2zXympbQVr9epOgOoPfXCo7Ghqv7vXbcB+KfZRQBAI+33FSMtp2
         Tgo6aVTAK7/tl/+iFjs3dEiY1IPH8vdd6EM/zSU0EIzxIMraJ/EX0ztcnr+IbJ/crFWm
         yt6esyXAcMm+OBhqVEeOMzLoLmXJFYnRt21od0xKukPEkffdm6BsylqgqG13vZLJUzOa
         3WHznaGaHgtormFNcNOA0Yl1XZGnNMH/zUdoXTAcoGM9uRd+GZdSiCg7YxKfCZw9VIRJ
         +msSAp+d2kZUPegoF9XbNW/ZIS9MhCJLG6lbLy5MoIFl4b8yCGxyNfJqNsSiGxv1Os4A
         VMUA==
X-Gm-Message-State: AOAM531IRKIm7zW2dnBNQcS9ja1f8CeLnRzsI/nWaI2d+oKGER0obWB5
        V0Bjycp2uxs0c6HCaMCuFYzQJ49YK4ERRlGRY8Bef5zHnejGuMBRR+cJ6js0Py+nVTlGrHADfsS
        Nspa8C3Js+I4cOJx742hEtbAi5+jwXxkQwQ==
X-Received: by 2002:a17:906:c085:: with SMTP id f5mr4338568ejz.250.1627559914474;
        Thu, 29 Jul 2021 04:58:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzv4BAiKXa3/y/e8C9RanIKpgbXJfSN4+8ZZEBon9lao+WKG0BTNjyji29VQ1OsQPbAi6/DMw==
X-Received: by 2002:a17:906:c085:: with SMTP id f5mr4338563ejz.250.1627559914327;
        Thu, 29 Jul 2021 04:58:34 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id n11sm908803ejg.111.2021.07.29.04.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 04:58:33 -0700 (PDT)
Subject: Re: [PATCH 00/12] nfc: constify, continued (part 2)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net
Cc:     mgreer@animalcreek.com, bongsu.jeon@samsung.com, kuba@kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
 <162755820704.26856.6157999905884570707.git-patchwork-notify@kernel.org>
 <7b0ae615-dcdc-251e-4067-959b31c28159@canonical.com>
Message-ID: <f3521001-58f3-8c6c-5b07-9dd8dae0cba8@canonical.com>
Date:   Thu, 29 Jul 2021 13:58:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7b0ae615-dcdc-251e-4067-959b31c28159@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2021 13:35, Krzysztof Kozlowski wrote:
> On 29/07/2021 13:30, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This series was applied to netdev/net-next.git (refs/heads/master):
>>
>> On Thu, 29 Jul 2021 12:40:10 +0200 you wrote:
>>> Hi,
>>>
>>> On top of:
>>> nfc: constify pointed data
>>> https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
>>>
>>> Best regards,
>>> Krzysztof
>>>
>>> [...]
>>
>> Here is the summary with links:
>>   - [01/12] nfc: constify passed nfc_dev
>>     https://git.kernel.org/netdev/net-next/c/dd8987a394c0
>>   - [02/12] nfc: mei_phy: constify buffer passed to mei_nfc_send()
>>     https://git.kernel.org/netdev/net-next/c/894a6e158633
>>   - [03/12] nfc: port100: constify several pointers
>>     https://git.kernel.org/netdev/net-next/c/9a4af01c35a5
>>   - [04/12] nfc: trf7970a: constify several pointers
>>     https://git.kernel.org/netdev/net-next/c/ea050c5ee74a
>>   - [05/12] nfc: virtual_ncidev: constify pointer to nfc_dev
>>     https://git.kernel.org/netdev/net-next/c/83428dbbac51
>>   - [06/12] nfc: nfcsim: constify drvdata (struct nfcsim)
>>     https://git.kernel.org/netdev/net-next/c/582fdc98adc8
>>   - [07/12] nfc: fdp: drop unneeded cast for printing firmware size in dev_dbg()
>>     https://git.kernel.org/netdev/net-next/c/6c755b1d2511
>>   - [08/12] nfc: fdp: use unsigned int as loop iterator
>>     https://git.kernel.org/netdev/net-next/c/c3e26b6dc1b4
>>   - [09/12] nfc: fdp: constify several pointers
>>     https://git.kernel.org/netdev/net-next/c/3d463dd5023b
>>   - [10/12] nfc: microread: constify several pointers
>>     https://git.kernel.org/netdev/net-next/c/a751449f8b47
>>   - [11/12] nfc: mrvl: constify several pointers
>>     https://git.kernel.org/netdev/net-next/c/fe53159fe3e0
> 
> Oh, folks, too fast :)
> 
> Sorry for the mess, but the patch 11/12 has one const which is wrong
> (I sent an email for it) and this should be on top of my
> previous set:
> https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
> which I think you did not take in.
> 
> I am not sure if it compiles cleanly without the one above.

Hi David,

This fails because of missing patchset above:
../drivers/nfc/fdp/fdp.c: In function ‘fdp_nci_set_production_data’:
../drivers/nfc/fdp/fdp.c:116:60: warning: passing argument 4 of
‘nci_prop_cmd’ discards ‘const’ qualifier from pointer target type
[-Wdiscarded-qualifiers]
  116 |  return nci_prop_cmd(ndev, NCI_OP_PROP_SET_PDATA_OID, len, data);

It also has one issue in patch 11/12. Can you drop this from
net-dev/master? I can send a v2 of both patchsets combined.

Best regards,
Krzysztof

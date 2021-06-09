Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4236A3A1B60
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhFIRAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhFIRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:00:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30974C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 09:58:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o3so7898539wri.8
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 09:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GfWEsUAani6bJBHKwb6jb6ETVwG0Lc/7D2zrjHlZFP0=;
        b=Pn0hJvh/qVcqU4HVY7W9QR2N49gbnx9RCBYeNSzBJziMUtF9UI+YqugOvJfgBoqlxO
         oYtu8x/FLWoA7jzjursJuZAMy2G4OrndFz35Pcl5G0FIVi5UyOiSjXtEdB37hKWUaZU0
         JyDW9OsnYmAnge6bq6ZNhc8f9DChSez3+0HHtMvvWmkwRE/oNMBBBiV3fYehm4qRumy2
         6QxfZHDbR+l1GluQwEhcPNaNmfU0nYPFJ3MwxYnDxlLCkP1iZlyvXX2CfJ5Go2zbAir9
         DC1557vxK9L8LhpnQ8CmkIeT7RymxRJjrhhymll8MdMbuBtikcSzQeyHfFSSOInrFUBW
         uHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GfWEsUAani6bJBHKwb6jb6ETVwG0Lc/7D2zrjHlZFP0=;
        b=WOF5N/fEjQ3lAgTidg20/0q1MWsP5mgqcQURsRA9+cXGOIcVIbPauAxZcR7Zo3C3wn
         HWwMYgQO1h9y11MsZVOkrVGkW9HBlZloSnisqsriq777Ol06bx+pAuEUedZXCBVpU3t/
         ioCjiCWiee/5T+b5aFvHZIniQgFgqH8Bs13p4uoCXHfh/25kNg5TLgIXpF/9S/hJnY8D
         79k+M8m7NsBhlEDj+yPJoU+vO9mK0NsaP/Yixf0U8z3JXKkhH7CL7V//IExwLSyeMWEk
         4xGyXGMZGpz+PcgsmHRWQNe2apS034PM4w4fb6xVErNMx2enKU8l6PtM/Ymeb6aIidpF
         iKLQ==
X-Gm-Message-State: AOAM532l64tx+nthABudl8cmpBzzK2WLOTqS0ZehGSSwn/+fA9mugFnQ
        cjZdxYdwXpNeW8dKKNqKJDY=
X-Google-Smtp-Source: ABdhPJxb2AbRJ6cG5lJDxnSWEYbGUDzHQ5u631vX8CGqCrn7Nb3Ak+6J9W0jBxGDOJkwlLF1wNGFyw==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr731869wrv.423.1623257917835;
        Wed, 09 Jun 2021 09:58:37 -0700 (PDT)
Received: from [192.168.181.98] (171.251.23.93.rev.sfr.net. [93.23.251.171])
        by smtp.gmail.com with ESMTPSA id n18sm327350wmq.41.2021.06.09.09.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 09:58:37 -0700 (PDT)
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@linux.microsoft.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
 <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
 <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
 <CAFnufp1vY79fxJEL6eKopTFzJkFz_bZCwaD84CaR_=yqjt6QNw@mail.gmail.com>
 <20210609175527.2f321eca@carbon>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e5538afd-6202-7a5b-7440-229e4f9a6879@gmail.com>
Date:   Wed, 9 Jun 2021 18:58:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210609175527.2f321eca@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 5:55 PM, Jesper Dangaard Brouer wrote:
> On Wed, 9 Jun 2021 17:43:57 +0200
> Matteo Croce <mcroce@linux.microsoft.com> wrote:
> 
>> On Wed, Jun 9, 2021 at 5:03 PM Grygorii Strashko
>> <grygorii.strashko@ti.com> wrote:
>>>
>>> On 09/06/2021 15:20, Matteo Croce wrote:  
>>>> On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
>>>>>
>>>>> As already done for mvneta and mvpp2, enable skb recycling for ti
>>>>> ethernet drivers
>>>>>
>>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
>>>>
>>>> Looks good! If someone with the HW could provide a with and without
>>>> the patch, that would be nice!
>>>>  
>>>
>>> What test would you recommend to run?
>>>
> [...]
>>
>> A test which benefits most from this kind of change is one in which
>> the frames are freed early.
> 
> I would also recommend running an XDP_PASS program, and then running
> something that let the packets travel as deep as possible into netstack.
> Not to test performance, but to make sure we didn't break something!
> 
> I've hacked up bnxt driver (it's not as straight forward as this driver
> to convert) and is running some TCP tests.  Not problems so-far :-0
> 
> I wanted to ask if someone knows howto setup the zero-copy TCP stuff
> that google did? (but is that TX only?)
> 

TX does not need anything fancy really.

For RX part, you can look at https://netdevconf.info/0x14/pub/slides/62/Implementing%20TCP%20RX%20zero%20copy.pdf

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110DD468B55
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhLEODo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 09:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbhLEODd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 09:03:33 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55339C0698C7
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 06:00:06 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id b192so5071264vkf.3
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 06:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3F6gftMNSTShksYMdpWBwHCrl7+S4hoShkinH/h76t0=;
        b=nl/qLTsjUQhcCNE+Z27KFSkmIFD7Qct1nA8qW0Ce3Jy4DKyo1HZuqTi8/82+7BzoMh
         kojAEcCxzSWTKbuIMRpC34u6uFYIFg++AaYSgW/xvJAQkUvT5kPqmIDBkQxW/pTBlGkm
         vE8TjxPu+wX8X7YG6DwRt26/06xSPfWGDwrJvQIXxrolSuwrsSN7o1WNidBKMPNiXrMS
         882UraEZDabWW7KXdAy/QuPXYdZtmbQmM4csCtdhsayDGXZgorqNkjrtLErD4RPOZaEn
         nFnBsPYOxCNojZpb7QFlgBdSL4Efno4+wNSwWFmDbcYIoMR0sCXeLtBQO2Chpsg6qYrQ
         KLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3F6gftMNSTShksYMdpWBwHCrl7+S4hoShkinH/h76t0=;
        b=3KIrbapXVUWiodv/TfVxRG0cZ7i/WL9w68I6ucSTftr0YcV2KoK7PQloecdg4o7cpN
         T8MAloCCaXAvRwRB5bX7Q8L2k6hCceiC4/6CMlTUJnGqBlZrIqJ0FGwUTBofFxNrAQMR
         vuHeI3USwNQLlqWeGvZlgTl+ZuvMsU9Tc+g+y3/hlIzPcGTYy6Hswi9G2Yq/AAUrS9EO
         ksYBMYFItjXrJnOk2EyxFJswQL/w+vinIstKrJFMtVALZUSrmRT7iH2vXFkyIeWjUOAI
         32opoUM/6FqkQtT82uQ1duJsUpoa2HM58BF5RgPdCEU6dD02spwKVtxtEcKS76jsplSR
         Hluw==
X-Gm-Message-State: AOAM533n2jkIkuje1qNVQ9PYFGbnU2kRs6C6tzhLBpiSH2JlGV3Voyz4
        rHOAH+3fw/q7bghaOUm6qNPHKNLBVv+MGOD35aILOZRVVfAzoQ==
X-Google-Smtp-Source: ABdhPJySEsP+Dui4lOdCS/66FeQO0idvW+/+pQnfhpUxMXCsVE3RyRf3EcS0oNXrIEQHeDI7Hlydglyxu1oeCikLROM=
X-Received: by 2002:a1f:52c7:: with SMTP id g190mr33539169vkb.1.1638712805461;
 Sun, 05 Dec 2021 06:00:05 -0800 (PST)
MIME-Version: 1.0
References: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
 <20211205065528.1613881-3-m.chetan.kumar@linux.intel.com> <CAHNKnsQTLENdyrOA7wXWUCMBD2pYY-Vn9DocqcvtNFsmhZZjcw@mail.gmail.com>
 <b45fb5b5-3068-73c1-f609-ffab92a3fa60@linux.intel.com>
In-Reply-To: <b45fb5b5-3068-73c1-f609-ffab92a3fa60@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 5 Dec 2021 16:59:54 +0300
Message-ID: <CAHNKnsR+Eyg+c_pKkH0c_FnT5sUCwbCjUGp+BUbrJ+o7oixrmw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/7] net: wwan: iosm: set tx queue len
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        krishna.c.sudi@intel.com,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 5, 2021 at 4:52 PM Kumar, M Chetan
<m.chetan.kumar@linux.intel.com> wrote:
> On 12/5/2021 4:46 PM, Sergey Ryazanov wrote:
>> On Sun, Dec 5, 2021 at 9:47 AM M Chetan Kumar
>> <m.chetan.kumar@linux.intel.com> wrote:
>>> Set wwan net dev tx queue len to 1000.
>>>
>>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>> ---
>>>   drivers/net/wwan/iosm/iosm_ipc_wwan.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>>> index b571d9cedba4..e3fb926d2248 100644
>>> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>>> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>>> @@ -18,6 +18,7 @@
>>>   #define IOSM_IP_TYPE_IPV6 0x60
>>>
>>>   #define IOSM_IF_ID_PAYLOAD 2
>>> +#define IOSM_QDISC_QUEUE_LEN 1000
>>
>> Is this 1000 something special for the IOSM driver? If you need just
>> an approximate value for the queue length, then consider using the
>> common DEFAULT_TX_QUEUE_LEN macro, please.
>> We had set an approximate value for the queue length.
> Sure, will use the common queue length macro (DEFAULT_TX_QUEUE_LEN)
> instead of defining the new macro.

Thank you! The series looks good to me, so feel free to add my:

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

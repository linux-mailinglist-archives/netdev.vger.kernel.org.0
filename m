Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CDA51BDB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfFXT7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:59:32 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33452 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFXT7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 15:59:32 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so374946iop.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 12:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=xbnY9IdsYfqTY0VS2MetV3/+HSOmxpPp3dTz4iri4A4=;
        b=YKYc/W27eRxL85Qot2rq3b7Z8kfYL4odEMmepauQybxMu4i8Vibc4fL9F8d7miW0DD
         GMlHbysgkAN9ZeR9rIaAIaKhrYQlYyIsYNER09/WlGD3MTo/UtQHN1OdY0JeoKSpiolp
         RR1FNgI3SY1LAyi4ouH8VRRJO7nZtQa3txBsx6PfmbvWB16pMeC3OoNdnHlP8tQO1PPe
         RkNEpWHEGo4Tz/FxIVkHQmd2jmHE/3UfX919F2CEqAbctNrOI1AesEkXxaeTEeWfhUZp
         nm84MrZY4EocyIADsqkMEnhaP/U6heIfkHDmaECmqpjczqyprlXhNhYUdkPypOE+rrEd
         /azg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=xbnY9IdsYfqTY0VS2MetV3/+HSOmxpPp3dTz4iri4A4=;
        b=Uow8NPr1N0ZhD7CuMvtu8qHkToP/Wccewu7sYhfqCnHCfYSXIyuR7iicpNxkct/MeE
         n6wBl8zfayLAV1e62N8ppiW3bTKgcW278Z2UNzSqgKFxwJyUB7R3m8u2x99NGCH2mmk6
         K7ICr94z+mjomttm+TaXaWeIXFXy2zP7reOyzRATXGT/LpmpqDLTE9T15q48Kq9lsqbN
         r0LHVLwwkQDATt5O34DG8Q4V7Ft1Py+5QflCJXAyGPtWE9/i0j4TFODIOfnDYbxr5HDC
         KzvsooMcchh1qfo78wc+2N5XTL1ca9H9KFqHTW1c99UXyE17UEkTgfTTwCcOxbUecyvf
         QJag==
X-Gm-Message-State: APjAAAVBCrPZMMhWtHgWmmnAXvkUo74PcZ+YoYpQ27UrdhxpeUuNBqci
        ijkEb1EHyYHXAUiyY7Rpsv+cmQ==
X-Google-Smtp-Source: APXvYqyjvxnW307d01Na5M7bTS4MumWblDInVQk6aS1REE8VbAM9D4xrAM3XkOo/a2gezgs6/qnCIg==
X-Received: by 2002:a02:9991:: with SMTP id a17mr367849jal.1.1561406371154;
        Mon, 24 Jun 2019 12:59:31 -0700 (PDT)
Received: from [26.66.112.1] ([172.56.13.57])
        by smtp.gmail.com with ESMTPSA id x13sm11283328ioj.18.2019.06.24.12.59.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 12:59:30 -0700 (PDT)
Date:   Mon, 24 Jun 2019 21:59:21 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <56ed92eb-14db-789a-c226-cdf8a5862e61@gmail.com>
References: <20190624132923.16792-1-christian@brauner.io> <56ed92eb-14db-789a-c226-cdf8a5862e61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] ipv4: enable route flushing in network namespaces
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
CC:     linux-kernel@vger.kernel.org
From:   Christian Brauner <christian@brauner.io>
Message-ID: <06CDD3C2-8B7F-4346-9653-44A29E28374A@brauner.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On June 24, 2019 9:49:33 PM GMT+02:00, David Ahern <dsahern@gmail=2Ecom> wr=
ote:
>On 6/24/19 7:29 AM, Christian Brauner wrote:
>> Tools such as vpnc try to flush routes when run inside network
>> namespaces by writing 1 into /proc/sys/net/ipv4/route/flush=2E This
>> currently does not work because flush is not enabled in non-initial
>> network namespaces=2E
>> Since routes are per network namespace it is safe to enable
>> /proc/sys/net/ipv4/route/flush in there=2E
>>=20
>> Link: https://github=2Ecom/lxc/lxd/issues/4257
>> Signed-off-by: Christian Brauner <christian=2Ebrauner@ubuntu=2Ecom>
>> ---
>>  net/ipv4/route=2Ec | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>=20
>
>why not teach vpnc to use rtnetlink and then add a flush option to
>RTM_DELROUTE?

I think that if you can do it unprivileged through netlink
you should also allow it through sysctls=2E
Even the original commit references it
to make it possible to enable the sysctls
1-by-1 as needed=2E

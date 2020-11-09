Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA12AC20A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgKIRUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgKIRUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 12:20:53 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2DC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 09:20:53 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id oq3so13378804ejb.7
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 09:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MAlESSBbDGOmEWSsY5xqMdMjK8ZOw92kWlZ4QsQbtXw=;
        b=UtyB+NHa5JCbB2xZ/4WMm+B88VJX7azmF3mNJ+BnVS7z45Z1Iq8Z2wh5z8XXr9AqvH
         fDmlY0yYiK2YBVSV8vgkekejUCB1yTln4cyOTcmHMt6utD8Q5/6IJfSvyIOgflWU+o0J
         uH84+ktz7SIOx9jiZ+CrsnCzOhX+7PScXc4IhmKXf91e7ORi/+ncPugu1GGf/Y0AIcfS
         fm5BqviqtC5Vb6GgT7Rzw0HyR9tm6+1WtGTmfeEkqn48SS+bsWWfBWh2DmOe2fSfhFal
         tQHwEbUcxtE0aQFYjD/KAVUPtekb9J47/9Db8/cZNIrWnUmyW1faeU6c8Bv02WVS7lgg
         UD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MAlESSBbDGOmEWSsY5xqMdMjK8ZOw92kWlZ4QsQbtXw=;
        b=kqLSwUlKvBSrZNr6bs0axGeUEp/TmsVMqPo3SCvuXV9v4U9jMVKM6F4WzVi5tcII9e
         cW1++oXmpStNZOS/U+6nX5cPhV+7LKmH+/KsJp82aEthI4a7K3i2nMCU9nxYjw8kY/C3
         NQ42jYxZDKtTzPkLzudMC60aoaLOKIkr8yCquxLnglxyj2zJQaRvxgUk+Vw6+Zgdcxni
         zU9r63o+gXyQ+JAG7G9le/RJanJYUWrKJOCNreEkpuqwWy/x+WNWgC3LaSrC/9lStALu
         uEqzMIPsab5YMt5iuN4VPQhSU67iDcH0n8H/GVktdXAYwvzUnPnyFAexhuSKDy70X9fu
         GOoA==
X-Gm-Message-State: AOAM531+CyKFl77Hp0xRQ5ek5ASaDpDJT6uaOaMdndFo2xhp3Xc7aWu3
        Lb2R+dJWx9HLoaTRj+HaqsGZzQ==
X-Google-Smtp-Source: ABdhPJx465bl1BP99ctbjR6OJSC5agqXR0EgF/GDhM019//V9WDHRaGux1Hoj/ZM5B4MJA4m/MjpNQ==
X-Received: by 2002:a17:906:7c4a:: with SMTP id g10mr15713206ejp.545.1604942452082;
        Mon, 09 Nov 2020 09:20:52 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([77.109.98.55])
        by smtp.gmail.com with ESMTPSA id p10sm9281678ejy.68.2020.11.09.09.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 09:20:51 -0800 (PST)
Subject: Re: [MPTCP] [PATCH net] mptcp: provide rmem[0] limit
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <37af798bd46f402fb7c79f57ebbdd00614f5d7fa.1604861097.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <d49c966b-e2fe-e0c9-49ea-a7a2475f45cf@tessares.net>
Date:   Mon, 9 Nov 2020 18:20:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <37af798bd46f402fb7c79f57ebbdd00614f5d7fa.1604861097.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 08/11/2020 19:49, Paolo Abeni wrote:
> The mptcp proto struct currently does not provide the
> required limit for forward memory scheduling. Under
> pressure sk_rmem_schedule() will unconditionally try
> to use such field and will oops.
> 
> Address the issue inheriting the tcp limit, as we already
> do for the wmem one.
> 
> Fixes: ("mptcp: add missing memory scheduling in the rx path")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Good catch, thank you for this patch!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

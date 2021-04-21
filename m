Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314A036670A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhDUIdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbhDUIds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 04:33:48 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85CC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 01:33:14 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c4so1492363wrt.8
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 01:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jKezjaFH3WO+yMlj12RwzM6vUnw04nAb64dSCN5YARA=;
        b=Uiiy8dOgpKIQExBFDA5qSdvY0IvEaQwQvStMdMiZI6XKIbsjfYoVKQBQD/TMZGTjo8
         E0dVio6enHyLzhS9fBVWd2EbULuEACxksOqefKLKW7iZYvfWj5OM/+luFhmwR+iwKrCa
         yWOwgQwDBMDpPf5bMxxI8m8kdH9+g+QyAM8ULKMrV7dsAcFhZeHdy4W1mVBqlbdSCrHE
         +xIrgyA6P7Zl51di7kvWDZRGL6RfzP/6zVvprvNsfnUJbDAKBCQef5QRNICE54yOt6Ul
         yx/ng051RCLdDqsazvN5qiv0yKMPyXJc8vYMnohLFfXgnqv7JzESmsZwzYesfs/CvVFi
         8pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jKezjaFH3WO+yMlj12RwzM6vUnw04nAb64dSCN5YARA=;
        b=RHWSj/K0aeA1DVW3YjLyfCeIleZq6ZVAPaFoj/ZlabIg03O7OMAqD48OYHy76NeEjX
         TVnpuX1nQ/z2QXLL7qcriTCRLwmQk2i7dfWVn6wanQg5xP3S6SNoHz7iuj51BmdF5oUP
         vzWx8RNk06PY2BlY+eul0VrNw/JWPtLg5kNTyiMZ5xI/RfUta9y0FCKo/EPUWttMkQ1J
         G80x36a3AjpHsRFnS3aABil+j1M6LLkM5ZXxRVwkBAcvAy0hChxjBdYMMY0RgIpnGIr4
         /YPDmRU2S0Xx9yV5lizJXELY9XDHOykWX0Wha7aNgsTwUu6prj+dHEzhl3VZC+4z010m
         aB8w==
X-Gm-Message-State: AOAM5308gfCpbjQZUKjc4fUwql2OBBg1Gs6m2i34SMozSNwy75G8/+9K
        eVUYbvBt3S8JIAuCl/vAs9uS1uc7KY3v1dZC
X-Google-Smtp-Source: ABdhPJwr9Vvqk8lKbFWVAT6kVxDO5dairVZdeQkAAFxJfqvnt0HVZrhcxXfsuROx9v6rqTm/45jOYA==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr25807387wrx.241.1618993992927;
        Wed, 21 Apr 2021 01:33:12 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:11bc:4865:533e:2cea? ([2a01:e0a:410:bb00:11bc:4865:533e:2cea])
        by smtp.gmail.com with ESMTPSA id p18sm2050419wrs.68.2021.04.21.01.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 01:33:11 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 1/2] net: sit: Unregister catch-all devices
To:     Hristo Venev <hristo@venev.name>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20210412174117.299570-1-hristo@venev.name>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <cb785bdd-6389-e980-5d72-4720e08834d1@6wind.com>
Date:   Wed, 21 Apr 2021 10:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412174117.299570-1-hristo@venev.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/04/2021 à 19:41, Hristo Venev a écrit :
> A sit interface created without a local or a remote address is linked
> into the `sit_net::tunnels_wc` list of its original namespace. When
> deleting a network namespace, delete the devices that have been moved.
> 
> The following script triggers a null pointer dereference if devices
> linked in a deleted `sit_net` remain:
> 
>     for i in `seq 1 30`; do
>         ip netns add ns-test
>         ip netns exec ns-test ip link add dev veth0 type veth peer veth1
>         ip netns exec ns-test ip link add dev sit$i type sit dev veth0
>         ip netns exec ns-test ip link set dev sit$i netns $$
>         ip netns del ns-test
>     done
>     for i in `seq 1 30`; do
>         ip link del dev sit$i
>     done
> 
> Fixes: 5e6700b3bf98f ("sit: add support of x-netns")
> Signed-off-by: Hristo Venev <hristo@venev.name>


Thank you for your patches.
Please, think of putting original author in CC when you send a fix ;-)


Regards,
Nicolas

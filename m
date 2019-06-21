Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7424DE2E
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfFUAxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:53:02 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36286 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFUAxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:53:01 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so323563ioh.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=24+3sf6LUzmpeKiF+9IECudFQc6k/jsFyik8uJAHvuw=;
        b=cDQAYuM91PwktPqvVPBS6AVNq3tVgidC1QaPbTXkViAypS4yvKFKPxZsdqjpB19UaB
         pAPhW4abi2D9hMOr519jtqQ8J5Q4dchaPnnhKkOJS4Z2Qh33tzXlR96OnzXq2nQKNH9z
         0Nsb1+tJ+M0uHX/eQTTXlkqCzPyL90paJm6YDla4qh5VSd1QXY6gWTS+pU9BJIh7eaIj
         SgbP6pcGiO9E2goffv9uFEcZibTxnlrDniRnahrrum3vohUQgOIVNMFbU5BUxAOS7frt
         b6mT/7250zcpvd7iEFZEyMmKNzYEiWgqBs7ziorYWxjfvQlxZyhimLJiG9aaaEUi20uI
         VWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24+3sf6LUzmpeKiF+9IECudFQc6k/jsFyik8uJAHvuw=;
        b=CtTG30GnPIPFxK8TX/g8rH6bo5nngNHRtbxd9KP8dc2t8zICZCxjrs3QSXgPZ6pckM
         SMlZDkxsjE93VW7wAh9F7EcECwxGe0kQLkzjWOi8pk9GkyAZ4GcfaDfB73vQpmjur1Nt
         k8ACuq+BRmu8Akx/Fvw2IhJH7r99XyJnXxZB4w2U2T78rKshttBsyCZshvSh6PMV6kMW
         +mozEDzn+eeOOVn7bilI4AR/3Jq1wSfhDehvMI3ibtHzSOmaGQcBUyHp/ZVF3GLJyPEP
         E3VywDJmOWXSIwxWwHUVTCIq+j3ONpoBlZ442pEtUDaqofF5zGLgjHWxY2ac+y8xrKXa
         aEzg==
X-Gm-Message-State: APjAAAX8I4LcepHkmCsPjC9nfMNfGlSk6KiBIy+HISd6SnrzLfThXWbc
        A9+KUaOopkFec5ViBgZiISI=
X-Google-Smtp-Source: APXvYqxP6hVxeNyVCExAlxWCimXeuEjHl/bz8WFAcTSPEkOCTZiqlsushOsvKyR5l8TQnXQR0ujE/A==
X-Received: by 2002:a5e:cb06:: with SMTP id p6mr18480809iom.79.1561078381164;
        Thu, 20 Jun 2019 17:53:01 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:4cec:f7ec:4bbc:cb19? ([2601:284:8200:5cfb:4cec:f7ec:4bbc:cb19])
        by smtp.googlemail.com with ESMTPSA id f20sm1711228ioh.17.2019.06.20.17.53.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 17:53:00 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Convert gateway validation to use
 fib6_info
To:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20190620190536.3157-1-dsahern@kernel.org>
 <CAEA6p_BUSFUCJJ_WsAAM2JRhQBBHjUepNZPpFX6DrTSCancD_g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7bc15499-6b44-67c5-e97f-b8d776be0a14@gmail.com>
Date:   Thu, 20 Jun 2019 18:52:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_BUSFUCJJ_WsAAM2JRhQBBHjUepNZPpFX6DrTSCancD_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 5:43 PM, Wei Wang wrote:
> I am not very convinced that fib6_lookup() could be equivalent to
> rt6_lookup(). Specifically, rt6_lookup() calls rt6_device_match()
> while fib6_lookup() calls rt6_select() to match the oif. From a brief
> glance, it does seem to be similar, especially considering that saddr
> is NULL. So it probably is OK?

I believe so, but I'll walk the 2 paths again and do the compare based
on the limited flags and inputs for the gateway validation.


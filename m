Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850717229B
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389650AbfGWWuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:50:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38069 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfGWWuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:50:39 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so19863712pfn.5
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6mbK+z1Hpfq5JjIsSL9B6jn9Vyuzm5s0uIc+IC2ZpZA=;
        b=K6wDHXO5IaOO/qBakklb9qRiZ0PE9H73v2FgR69Il0+Q+WxYQGfMtcoEkD5rgD/RUZ
         J5AWcY3rm6WZBqrnv4SmoDFX6lKTLJy4QD6gvW6PPuPskAFBFI8zSjf4GTBYL9lxRMqS
         1SWHAXbqo3oIcc3GJxL13tsQIAtScupGxp65VuU5rAdmm8J8Gc9QMEMHjoUe4Eby4OoW
         zYuVHnGYpXp1EBTbAt3icv1oj7rBqiJ3vDxSmginzf4qVJGzcn3gcZUt2DjFTqA22lrB
         LlYo4jta6vPsFRnbolGtjEEEQAXV+9utYsh3Ph6XQDBeaJxMPUkxs1JG/9NZKY9bNOoH
         mjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6mbK+z1Hpfq5JjIsSL9B6jn9Vyuzm5s0uIc+IC2ZpZA=;
        b=qooCrENDc2+gi2t+tUD0Mr4RmKB1R2p71cv6v0Iv+9IGQrK13d1AayGHElBq3i8dxa
         /wBe0eQm8d5abNDK6kpUOOZPjDjCejj8SCZO8+5UxhnLSMHkHAVbsbJYP1t+SP/hz2cb
         2p6Np2egcCUiYsiVWyhvFOhkHALUjjZG5j87flHDxljyMegVglS1wX/OULwTiIflmTaA
         BGBNqu8wnMtNhktVZb3XMaN08OknujwAkuDmZv+mqqIm/aEPzTusuGq8j9cRK8mYw9Dx
         Gv7Kf6uotJ6Gcay+/0UP8kjQKyXz85UQfFHASZXvpADPfSVYcekJnGurPiHhpLBuJrmJ
         7OvQ==
X-Gm-Message-State: APjAAAVa/wKUeV9LMWkUQ7aakEQpwueCIq6HGoM955bbCl9iF9MoqgiR
        tj7Ybgc5H6RTnFWEUQGhxZbQiawa/30SaQ==
X-Google-Smtp-Source: APXvYqx0GIOQFsP0Rkj9SYJWcttBrP85Hwl5QqFT7P2XhBtx9zUWnPgFX1CLF5yPrSZ5SrpbS8UUKg==
X-Received: by 2002:aa7:93a8:: with SMTP id x8mr8314748pff.49.1563922238823;
        Tue, 23 Jul 2019 15:50:38 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id l4sm44356576pff.50.2019.07.23.15.50.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:50:38 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 06/19] ionic: Add basic adminq support
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-7-snelson@pensando.io>
 <20190723.142738.638894843366352833.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <788e8ca5-a281-60a2-5260-8f71e24bf99d@pensando.io>
Date:   Tue, 23 Jul 2019 15:50:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.142738.638894843366352833.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 2:27 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 22 Jul 2019 14:40:10 -0700
>
>> +struct queue {
>   ...
>> +struct cq {
>   ...
>> +struct napi_stats {
>   ...
>> +struct q_stats {
>   ...
>> +struct qcq {
> Using names like these and "dev_queue" are just asking for conflicts with the
> global datastructure namespace both now and in the future.
>
> Please put ionic_ or similar as a prefix to these data structure names.
>
> Thank you.

Sure
sln



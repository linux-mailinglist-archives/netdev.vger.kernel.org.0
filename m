Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C67A7B2C4
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbfG3S5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:57:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35855 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388084AbfG3S5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:57:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so30527981pgm.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=vKJ0Yub5lqi5WEb/rLvQyxSLjGw1l9W0YNgWOwo66PM=;
        b=akp6KYUNSpYc3h4H7FBWJ9XBKMpIKFZYo7dT/ZdRdtO8otU91zPpNUGmD7CSJaoPKY
         mcZ4LsY6OOEMjgZzsQmSjrqybeiYFeNXr6GszEjr7vyE4X8j5lLAhqL+wRsfoIrUsxAc
         yg2JZLkzztJX/hCAvi4E5rTINwbKpTerTxcBp6dnAJEf6R6Ry7Zfb0gKXsutq0TT5SZi
         nCFSNzrh3EukCDXnpCATu/haBXqdhkSM1nUcicNbM1+9SQK3DokhxR5pWbtwbU3lA8v2
         1ex5sGLIKMS4jdpgDSBmO+wMrsjD7Gm08TDObqiGBc6zW0Ib+HcxzoJWa8TBihJzx5me
         AsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vKJ0Yub5lqi5WEb/rLvQyxSLjGw1l9W0YNgWOwo66PM=;
        b=tytI/aGOh4pIWgO/ZjNPBcfaFfXa6suGja94/VcOrGC3UlyTGSHLa9IZBWxkBTzloS
         QnwHA8ibV+/Tdr8wjWcjDYF6F0CHv5VjZR9j8tNnlvItVf6K9sIrduVuuleffZpmERmx
         rDPOB2VcmvtvXQcjnu1GYDoUZS2OaYlYiZ86G5KRWj/RkIxNU9BO530BmQUAS1tmCYR+
         z6iI9RrQiS6DTq9Zi7TyuvTeoERaOSibfpK+xh1fID0DDYr8SyzwezNKgAcukLBKT0CM
         4MXrw/T+FgCKY2K29SJ+cHmLgtVMDFqbrXVKtUi/twE+fKysvuqq7vcW8njXdhiUxkdW
         v08w==
X-Gm-Message-State: APjAAAX+MCWni6JPwcxUO5uZeKRTR71NAJQ3F9MiCVFc5UpxfGgRTS+v
        N+rt4renxnMxo2h1NYtI02HXhw==
X-Google-Smtp-Source: APXvYqx2UIp9liPDnwHzg9pq7z+8bfbnZ/49gxThFrrW+5O60JzoisPDpfQdnZiiOoF0I0TxqouXkQ==
X-Received: by 2002:a63:4e60:: with SMTP id o32mr112095018pgl.68.1564513057714;
        Tue, 30 Jul 2019 11:57:37 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id i9sm65305252pgo.46.2019.07.30.11.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 11:57:36 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-14-snelson@pensando.io>
 <2f966a9ced52c01e8017f7ded772fce1ca4fc966.camel@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7a9753cb-9872-2d61-68c4-44e95c4ae818@pensando.io>
Date:   Tue, 30 Jul 2019 11:57:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2f966a9ced52c01e8017f7ded772fce1ca4fc966.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/19 5:17 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> Add in the basic ethtool callbacks for device information
>> and control.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---

>> +
>> +	while (test_and_set_bit(LIF_QUEUE_RESET, lif->state))
>> +		usleep_range(200, 400);
>> +
> I see this is recurring a lot in the driver, i suggest to have a helper
> function (wait_pending_reset_timeout) and make it return with timeout
> errno after a reasonable amount of time, especially on user context
> flows.
>
>

Sure.
sln

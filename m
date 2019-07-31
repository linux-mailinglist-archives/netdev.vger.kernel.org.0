Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1F17D049
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfGaVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 17:50:29 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:36607 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731018AbfGaVu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 17:50:29 -0400
Received: by mail-pf1-f177.google.com with SMTP id r7so32603748pfl.3
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 14:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OBFfBjDvU34xdXTVY/xLpCxY7K4fviIo35LVZq71XQU=;
        b=c1E66hnsZxMjKWHOj8BaJak6ThAWlcEGYhoBrt4Wz9ZwDDTeNahvPqnwqV/QNd8qG+
         3cliGfOwdh1dCg+TEsYPXweDnfUmFZIscsh2gsckbURmfl3tbPMqYWoM/W1JlcWouai2
         3AS8lIVqsSWG9qqXxEmsCZleb8BYxOjFb+PqRIHQPg+hR5rGDzd5SLYVYD3CwAk5b+3W
         NrMiTGlVtrjOJOvbZ+wq2srythbsHEp2QSX7bLU4ERX6yBTWsu5ZKbiS9E0njP4swWaM
         Pp0pwMtWuO30fJrL3D/3a89ij6stz4F/YoCtj+Z+5ELNwJwlTFlAIuW8JjwhPs0LVC30
         a6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OBFfBjDvU34xdXTVY/xLpCxY7K4fviIo35LVZq71XQU=;
        b=WKfdeXSOyeuLPsM+i9ukqi5CNVXd+QTh2YDOLhSU2nFotVpDSgh4eGGAgwLiyDrT2s
         I2HVTTF/tfiUZfFba2fRSeyy62Os5WvSYlRBP7pcZl5DwoInXEJ1TH/rdIPYXK11GbzX
         AOe3XXdeHjEz2CIKgJJgQi5un04IojIVXnnvo4sbQDpcw9XcK5AlUZihYjcICqaybdhW
         TJEvP9hKyVaidYy9DE/hy1frAEphjJlxN2GXKvjF8bpKx3wea11X59VH70ymw4qNkXUm
         1z2PulnWmdHYKRxFMLfjk1kTybW1FGDARjoz6JMjIyukBGgpqQ4zFcOUtnG1oBM/o88r
         0Iww==
X-Gm-Message-State: APjAAAXoIN4Pq42zd+nCHpMY1SCvm8UTqn3tJCgKIKhYKlucgTJsD6eD
        b3baIOL+RaDFmZiq2NhRB0c=
X-Google-Smtp-Source: APXvYqzuJWY2RqSaKSGzp0SSePK9mmPqf1foe3m9/uyS1BTyyMypfZ0Mtr/vRq5+dUY9Y7EKqsm4Bw==
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr5125620pje.12.1564609828644;
        Wed, 31 Jul 2019 14:50:28 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u3sm2616318pjn.5.2019.07.31.14.50.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 14:50:27 -0700 (PDT)
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        mlxsw@mellanox.com
References: <20190727094459.26345-1-jiri@resnulli.us>
 <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
 <20190730060817.GD2312@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8f5afc58-1cbc-9e9a-aa15-94d1bafcda22@gmail.com>
Date:   Wed, 31 Jul 2019 15:50:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190730060817.GD2312@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 12:08 AM, Jiri Pirko wrote:
> Mon, Jul 29, 2019 at 10:17:25PM CEST, dsahern@gmail.com wrote:
>> On 7/27/19 3:44 AM, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>>
>>> Devlink from the beginning counts with network namespaces, but the
>>> instances has been fixed to init_net. The first patch allows user
>>> to move existing devlink instances into namespaces:
>>>
>>
>> so you intend for an asic, for example, to have multiple devlink
>> instances where each instance governs a set of related ports (e.g.,
>> ports that share a set of hardware resources) and those instances can be
>> managed from distinct network namespaces?
> 
> No, no multiple devlink instances for asic intended.

So it should be allowed for an asic to have resources split across
network namespaces. e.g., something like this:

   namespace 1 |  namespace 2  | ... | namespace N
               |               |     |
  { ports 1 }  |   { ports 2 } | ... | { ports N }
               |               |     |
   devlink 1   |    devlink 2  | ... |  devlink N
  =================================================
                   driver


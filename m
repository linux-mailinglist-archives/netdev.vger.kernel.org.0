Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8FA27DF2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfEWNTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:19:53 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46105 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWNTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:19:53 -0400
Received: by mail-qk1-f194.google.com with SMTP id a132so3714997qkb.13
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 06:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nTJXm8aLR1gLxHmDoJxLU5/qhjQ7+gImhkWOx2JqZ2A=;
        b=kps7MmvH29bnifwTHacf3GoXTaC3JGYkk6GCXOu/0ssq4PW3EEMYyC5GUw6QewPBIf
         Umxax754tfcmaa0otRGNBifiRt/bAgxuVMvAa0ZT03rTwQz2X4JzpkWGoB4IQR140Rro
         ZrxPOFMsY5Bu4lWBr1bp4jq0s9S9LF4rEDXsVb6+j9++f1ADtu3W+d735xjSXDbDEEqV
         p/e016zD0ovtdSBbdtYCf1/S26hKlET48xVC0fqLN/CL7cX4BQrJZD/Nf1rgg6hL+irB
         wzOWnWNrXM9yKgrsKQDsOzQm/Rs3r/sWMJZIt0URfvffrWWEcDktPKyjLLWrp8HBdCe8
         a56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nTJXm8aLR1gLxHmDoJxLU5/qhjQ7+gImhkWOx2JqZ2A=;
        b=MYEUdhRfRg0JXNQTJubcs7OuU26WofYbAO4dp2lvi7ZMVXrGmUkRTfWlD8ge+kAD6o
         S7XcZ2LpZVjRzUfjmsJ38UfMnX/KOGhn5KOKJn2wQb4tVVslkjkWPy1PnlWO+HAqFFps
         BxhIgBg0Trk54eGbnvHGo4VQMScIyY1PGfEkhnkybHTsGLkYEA7fsNGTQbcn8jE42NYj
         Y5W7C58fO1c3mKHsXAWVXuQEaxepLKh+pSiCg0vy8+bIt/88/0Mas2xvKi7BC9cQug7m
         funjwOZ9R85w3uFca659LcU5FKrGQHQdzIxKerWZ2XdCMILQQXgbsgM71MnbhJVnJlZt
         dCmA==
X-Gm-Message-State: APjAAAXo2no3eQHQC7BBBJ72koetEI1b3fVRKTRHFJ5Pw4XMZGjDLZhV
        5LSLkvg0xNjb18CbRm5Je2ATRg==
X-Google-Smtp-Source: APXvYqz8IF0JzTwFDoMGqY8gEjFxWaIx0Mn7kabh7bzIBDwXlfL3XZ+sKq72RePEcRtNQboIMEDakQ==
X-Received: by 2002:ae9:e316:: with SMTP id v22mr17329404qkf.256.1558617592080;
        Thu, 23 May 2019 06:19:52 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id u1sm656034qte.60.2019.05.23.06.19.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 06:19:51 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
Date:   Thu, 23 May 2019 09:19:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522152001.436bed61@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-22 6:20 p.m., Jakub Kicinski wrote:
> On Wed, 22 May 2019 22:37:16 +0100, Edward Cree wrote:
>> * removed RFC tags
> 
> Why?  There is still no upstream user for this (my previous
> objections of this being only partially correct aside).


IIRC your point was to get the dumping to work with RTM_GETACTION.

That would still work here, no? There will be some latency
based on the frequency of hardware->kernel stats updates.

cheers,
jamal

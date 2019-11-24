Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2635108155
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKXBKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:10:53 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36290 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXBKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:10:52 -0500
Received: by mail-io1-f68.google.com with SMTP id s3so12265281ioe.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 17:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F0BxsQiGUICUsW//eVBQSB8f5hGsamDDr68LDkmBXHM=;
        b=aCtlL+B3+UTx3gafSnE8ge5yDiLScrHU075x4c7rar74zSTJqjabk9PlrZO5LoxepU
         d9acp5PqMeeg/nZ3HcDygRfJeaKJxRwjbYOiNei92DiTNiM8d1n/Tc06ffcK7oyqJNry
         ohqcAvHS81JOSvoy3tbT/WfsfoktyQz/uMsMKs7rvcX74o8/LvlrrKetRlRzFjO81+N3
         vED/OP5n/C/H5VmwZFZdmK+vMP2FBmaTGNADXMx6iFD4SalSTkr0oJ+81UPB3Jr5Y/Qe
         RjvNojbebHBmm5aCoVRxrMOgyyalIvdJ4nuJraZCMFTJwRfycdn+9xRyg/uswRM+RAkx
         DgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F0BxsQiGUICUsW//eVBQSB8f5hGsamDDr68LDkmBXHM=;
        b=SHHvkYkzZGBD+R1JI8r1dk6FyxRE0eqvcFYNQcStR8AszS3Nm7uFsSZt4cKj4FSFte
         WOn6vhMwOk0Y+o/sTLicUmEmE0/OwqMNV3ujokh9Y9Sr/YD34A7Jz7Yhvof58pfk1O2V
         uhv0zzykAUWEBnKk8dc2Wt7QaYdgkytibPJZ9Dgg9NrX2VmE9Kiyeo75u0luBS1pbzfb
         BNoojrtoyhAkJvVG05zU2QB5Sd9W3eW6WIThCQ8iY4yz9Kqc67V0ULbebdWLvEiyTLLt
         CNV3AqmGOSFy0RZtwDQCPHxqiWj+H3KnLLKaPXMjKl0nUSuzdAEI87JZ3DCKUaUutopW
         P2+g==
X-Gm-Message-State: APjAAAXtfXbZ7e793ssUNdmbYZymleHI1nuJe4gZxmfgZ7iFv+qddEEE
        FijlIY5wstAht+9mMm2cpQ0=
X-Google-Smtp-Source: APXvYqwKxYKU/P/n7+R1cT+/++FhYBCI3mNJ+/a3ZgbOljo1gc7ba59ESHa9sXGT/T13d9oA+8Oytw==
X-Received: by 2002:a6b:f117:: with SMTP id e23mr21531171iog.286.1574557852007;
        Sat, 23 Nov 2019 17:10:52 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c435:ff27:4396:2f9f])
        by smtp.googlemail.com with ESMTPSA id f2sm645397iog.30.2019.11.23.17.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 17:10:51 -0800 (PST)
Subject: Re: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20191122224126.24847-1-saeedm@mellanox.com>
 <20191122224126.24847-2-saeedm@mellanox.com>
 <20191123165655.5a9b8877@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bb598347-bfe3-4e39-2e69-5db3b3188c7b@gmail.com>
Date:   Sat, 23 Nov 2019 18:10:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191123165655.5a9b8877@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 5:56 PM, Jakub Kicinski wrote:
>> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
>> index 205fa7b1f07a..de9004da0288 100644
>> --- a/include/linux/netlink.h
>> +++ b/include/linux/netlink.h
>> @@ -62,6 +62,7 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
>>  
>>  /* this can be increased when necessary - don't expose to userland */
>>  #define NETLINK_MAX_COOKIE_LEN	20
>> +#define NL_EXTACK_MAX_MSG_SZ	128

This makes extack use a lot of stack. There are a number of places that
are already emitting warnings about high stack usage.

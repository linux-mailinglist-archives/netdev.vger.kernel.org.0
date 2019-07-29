Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D707C799D3
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbfG2UWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:22:12 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39952 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729661AbfG2UVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:21:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so28814664pgj.7
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aYjeni8hi9gCIqKfEF7sAzYP+NCIvwRDXRNk1O+7eI8=;
        b=lu8LmvH26Ask+6l46/3kuEjRxOx+2JtkDCvfaTqlYwMrkrs8y8HNe/M9lngZ0qu87n
         C/4XBPHwfebrr9JOauQ4k9K85B912iLOGW8dFuayPx6dkqgWc+GmheO6dZTJMVbAuM91
         URtpgqh71mbPafjrnI16VI3tQyn02GFTipFvToePkrft6jBDgP5Hs0wMPVv1op4avo/N
         4sQOrA6taIszNfl2AMgq6rgK6E5HG7XQ/8aohm8zM0ARr/zlUUAq4WiuWRqhQFRnHDUF
         0lJZ5rB2NMWaWo9XC4yDRkPWBb4dRkkdWsShrr8QmOeFlIVtZGBCsQ3vq4TRhAu4ZNMm
         25Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYjeni8hi9gCIqKfEF7sAzYP+NCIvwRDXRNk1O+7eI8=;
        b=j+iJNt0hZjXwAwm2JZhEMy2ZRHFY/RdAQGxWvn8nX+58j65rEaH7qVyFTIQUT9f7rY
         8hxLmXB5aP8R+DDbnX4N0pa/blYhw3sGDrQn8NHOQVjdoLFtFEKVC5b6RbUG1+ynq2/7
         6lzBl6zmiVcB9e5QOWUP4l34RduXj47w+mSI+S/1gOdyrO8XM5hBj2DNu6OtzaFbhuvb
         a+21PNYkTVAUUGOA3OG35bcILxsTnslV0S7HG42md7QNp7giZrdj0J1n7jQViYC5aokr
         hzVuG27mFVF1zl0CBF9fCBN3fjQZ02kWDsQC3SpiXGkaDF8wcoFw13OMm6p++DPTbm8F
         2F0w==
X-Gm-Message-State: APjAAAVTWaK8bviizBtq//R1O5ZbqCFnWEKcYMNT9mfwS+2u1ZWV8oV4
        8GupSmB9tz5VVEpQC6QfXNo=
X-Google-Smtp-Source: APXvYqzFLkgKRwSWN29j++F9rPPSIffXulHyhX08DVr0wiEiWcBDyVu299L5v3Kzw5JNqN8bVqAfpg==
X-Received: by 2002:a63:6c46:: with SMTP id h67mr97842229pgc.248.1564431673184;
        Mon, 29 Jul 2019 13:21:13 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x24sm59334420pgl.84.2019.07.29.13.21.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:21:12 -0700 (PDT)
Subject: Re: [patch iproute2 1/2] devlink: introduce cmdline option to switch
 to a different namespace
To:     Jiri Pirko <jiri@resnulli.us>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        mlxsw@mellanox.com
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727100544.28649-1-jiri@resnulli.us> <87ef2bwztr.fsf@toke.dk>
 <20190727102116.GC2843@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d590ac7b-9dc7-41e2-e411-79ac4654c709@gmail.com>
Date:   Mon, 29 Jul 2019 14:21:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190727102116.GC2843@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/19 4:21 AM, Jiri Pirko wrote:
>>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>>> index d8197ea3a478..9242cc05ad0c 100644
>>> --- a/devlink/devlink.c
>>> +++ b/devlink/devlink.c
>>> @@ -32,6 +32,7 @@
>>>  #include "mnlg.h"
>>>  #include "json_writer.h"
>>>  #include "utils.h"
>>> +#include "namespace.h"
>>>  
>>>  #define ESWITCH_MODE_LEGACY "legacy"
>>>  #define ESWITCH_MODE_SWITCHDEV "switchdev"
>>> @@ -6332,7 +6333,7 @@ static int cmd_health(struct dl *dl)
>>>  static void help(void)
>>>  {
>>>  	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
>>> -	       "       devlink [ -f[orce] ] -b[atch] filename\n"
>>> +	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns]
>>>  netnsname\n"
>>
>> 'ip' uses lower-case n for this; why not be consistent?
> 
> Because "n" is taken :/

that's really unfortunate. commands within a package should have similar
syntax and -n/N are backwards between ip/tc and devlink. That's the
stuff that drives users crazy.

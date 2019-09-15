Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30198B2F6F
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 11:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfIOJo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 05:44:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46764 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfIOJo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 05:44:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so4717280wrv.13
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 02:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tQFuSFC8WIHg6KGpDeY0S9591U9gKiscMoCwFGQMaNs=;
        b=FLnPhicUpYmzgLbre6pXyDONPfaUHh4G7lB5Axddpxoa5HzUj+9HjnF+jZvgjediC8
         J8KeeH1aIEYeMLnniJgPBQ9uRHwbDuOPPAK501hTKq2vbK8Z8kIk2B7csYAB9HPYrBYL
         yfBBW6Ot2a/sjIEMxdcRPbjrh+u1i9k5IMMb1InSq0ALt59KUW4ryzrXeYhTE9dSdkua
         cmKVmMnlnH8YnQIQOh2qCavUICtGsbdu/5T93ODkiaHO+nnxq5C2AtZAv/ElJaeP64nN
         xDj9uMa984EitPZV6oc/ipWxKB1laohGvJjHtKtERQDpWjFRxkTBFRukPTfOvBSa1m59
         1EsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tQFuSFC8WIHg6KGpDeY0S9591U9gKiscMoCwFGQMaNs=;
        b=MwSbifTpKb5oPEV4RVVV9dHnxqrHtoBedfTHHkaLOM1agrKm+Kin2Jyv+V7D/6xACM
         fkkROXYMRJ84AoLy/CA1BhDGH19wUqL8VfDBDv5BNA5r7qybqSwD5xh3QgjCAEPEZJjl
         drzeC+8jmNIziFMH6KUPbnmEsIEDvWAcnos9rUKKv3gvUpTGC+5jGS5rPBaTPuHxjkhD
         02O55pZVLroNxTcPwnHqnqsT5vYNPrUnoPPsPkjvmpNm/2eAmCTgNdA5HgmDbv1mUEXu
         c3vlULJNgYTR6ZWDROUSVWiWM9ttUkQliz9RFQYSfcl4is4CPj5F4z8hXJejyTYo7i6j
         SYcQ==
X-Gm-Message-State: APjAAAUoBEYInD6I85jysj0DvGoEdgL+LhYQ0K3GJRZDw/gnIQT1bRbH
        R48fiblQ7uu7cWumo6wYIFKxEA==
X-Google-Smtp-Source: APXvYqzONXeWsUEqTpCi8ZBP0/VgaKjnDeymFYj785Mnc3xhm5jT0oTdpfOaMGA7iJEtSflpnL8eNQ==
X-Received: by 2002:a5d:5592:: with SMTP id i18mr12835589wrv.316.1568540664914;
        Sun, 15 Sep 2019 02:44:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e20sm71102589wrc.34.2019.09.15.02.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 02:44:24 -0700 (PDT)
Date:   Sun, 15 Sep 2019 11:44:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2-next 2/2] devlink: extend reload command to add
 support for network namespace change
Message-ID: <20190915094423.GE2286@nanopsycho.orion>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914065757.27295-2-jiri@resnulli.us>
 <20190915071639.GA8776@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915071639.GA8776@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 15, 2019 at 09:16:39AM CEST, idosch@idosch.org wrote:
>On Sat, Sep 14, 2019 at 08:57:57AM +0200, Jiri Pirko wrote:
>> diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
>> index 1804463b2321..0e1a5523fa7b 100644
>> --- a/man/man8/devlink-dev.8
>> +++ b/man/man8/devlink-dev.8
>> @@ -25,6 +25,13 @@ devlink-dev \- devlink device configuration
>>  .ti -8
>>  .B devlink dev help
>>  
>> +.ti -8
>> +.BR "devlink dev set"
>> +.IR DEV
>> +.RI "[ "
>> +.BI "netns { " PID " | " NAME " | " ID " }
>> +.RI "]"
>> +
>>  .ti -8
>>  .BR "devlink dev eswitch set"
>>  .IR DEV
>> @@ -92,6 +99,11 @@ Format is:
>>  .in +2
>>  BUS_NAME/BUS_ADDRESS
>>  
>> +.SS devlink dev set  - sets devlink device attributes
>> +
>> +.TP
>> +.BI "netns { " PID " | " NAME " | " ID " }
>
>This looks like leftover from previous version?

Will fix. Thanks!

>
>> +
>>  .SS devlink dev eswitch show - display devlink device eswitch attributes
>>  .SS devlink dev eswitch set  - sets devlink device eswitch attributes
>>  
>> -- 
>> 2.21.0
>> 

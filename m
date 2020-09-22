Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B0F274D2C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgIVXQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVXQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:16:50 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB533C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 16:16:49 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m13so12747157otl.9
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 16:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZqvQ2BJN+fxtbxTJ+f0dKXvswWsP77F104iJ+8/BjLE=;
        b=BsnFk9Wasu2CYlnHTnoD+5Gu76wCuPmh8RAFdD3s/xNLIOjcd0A+5LsWIqAijhAYb+
         WF4aSEmgUVMeRgVo0+sP8MzYJCnzo+cpT+q/Lk/LIw0Ugp0nNPepk+HWphG3fc1lCyal
         rW2DO7jfMy2wVJgmSYos19mA4gzSBZpARIEU7hrG/yK6bYyqWrQ7396bsuGcxLwRtonM
         b+xZdTsRtW8bg+4J5x9m4LfUJRgZiijQJ+qcYtNHCgHHXY+C0c0BMZLQhpLqRQh8g77H
         MEWRY7tllb72kvtqndvPBsnnM40vfAJKDpNSJGI54+nSjI7ziHHTc5loaiitc/XDnosU
         pPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZqvQ2BJN+fxtbxTJ+f0dKXvswWsP77F104iJ+8/BjLE=;
        b=RlHhaKjyi/He0EHRSSTfzskM+VDkPCFGmwBsrb1ArRPXiTOmbVguEV197G/HRtjm82
         QN1IQjAbbKMY+O5/J4p4e5uZfPd8uLlRVjIxO/OPWVd4fDAMK7dkpwcwXQy7eVYNCELm
         lN7XyShsYoad4z10vXFtSnluxgK6g9ZKv9SM1btJEjZQ00T3Aw8RDs438OyiBunTPr1U
         TSOJ1YmQTQgaPHlLyaHmUR35326+6TMDA/9UA19xPE26tAGoSmLsY/wpi+fOuL5njf0V
         6vtyy0uDszCqT79IGK9PidkDZCg/to8YpPWCmJqEtZdx784dTgViE7yhC516I83EtE0M
         tU6Q==
X-Gm-Message-State: AOAM531udZvSEqFUgdX/L9KfPH+c1k0yNCDziQa9wYTHXdspJqYl5ISj
        E4yIPM5lt9il+XjQm8hmSZ53uAplrJTQgQ==
X-Google-Smtp-Source: ABdhPJyzQ0qTaHuTO4+WbylhVEqRmNkdOgzuMv0Mh8iFz2dswOfTJSP8n73zzinwjWx4NFJEQIhmlg==
X-Received: by 2002:a9d:4c01:: with SMTP id l1mr4426612otf.341.1600816609011;
        Tue, 22 Sep 2020 16:16:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:1cd7:3896:e667:9e25])
        by smtp.googlemail.com with ESMTPSA id x15sm8469014oor.33.2020.09.22.16.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 16:16:48 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip: do not exit if RTM_GETNSID failed
To:     Jan Engelhardt <jengelh@inai.de>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20200921235318.14001-1-jengelh@inai.de>
 <20200921172232.7c51b6b7@hermes.lan>
 <nycvar.YFH.7.78.908.2009220817270.10964@n3.vanv.qr>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7214fc31-42f4-2a47-0f01-426bed14711d@gmail.com>
Date:   Tue, 22 Sep 2020 17:16:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.78.908.2009220817270.10964@n3.vanv.qr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/20 12:28 AM, Jan Engelhardt wrote:
> 
> On Tuesday 2020-09-22 02:22, Stephen Hemminger wrote:
>> Jan Engelhardt <jengelh@inai.de> wrote:
>>
>>> `ip addr` when run under qemu-user-riscv64, fails. This likely is
>>> due to qemu-5.1 not doing translation of RTM_GETNSID calls.
>>>
>>> 2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>>>     link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
>>> request send failed: Operation not supported
>>>
>>> Treat the situation similar to an absence of procfs.
>>>
>>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>>
>> Not a good idea to hide a platform bug in ip command.
>> When you do this, you risk creating all sorts of issues for people that
>> run ip commands in container environments where the send is rejected (perhaps by SELinux)
>> and then things go off into a different failure.
> 
> In the very same function you do
> 
>   fd = open("/proc/self/ns/net", O_RDONLY);
> 
> which equally hides a potential platform bug (namely, forgetting to
> mount /proc in a chroot, or in case SELinux was improperly set-up).
> Why is this measured two different ways?
> 
> 

I think checking for EOPNOTSUPP error is more appropriate than ignoring
all errors.


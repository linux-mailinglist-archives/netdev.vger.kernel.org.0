Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52F6274DB3
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgIWALi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgIWALf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:11:35 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBEDC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:11:34 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id n61so17327730ota.10
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+kACnwoPL9G3aWY3sbCroCgBf/lGDDysOpJ20Nj1Ps=;
        b=phPQNRxrLhatKPkPmJIeGDEezj5pk1tuBg4Xv00uXZaSkbFjI7hznKGCimMVJ3b3Sh
         4ZwlZNgKT7NcxML7KzN7l1jHsVKDpkMXkhqftlswaoYK4Dzl32tieJ+1h1bc8yWFsK1N
         wnWbeLVIHFFF6FOY5cipebFb0hXukC6p/ZN1BlWkcV+OAm6Hc0Gh42Nnj1B7nPqLKDTP
         W3TUtJ5T8fsf9yK8PtExZ7hJXm+B0xusKVhgGByaYuH3TjdXe6r3QEoFzUlkrDGwJ0tj
         11fenrGRUsh1n5GaGuBX2WH+KR+MXbbEnrVKF3IHOzboxXmp0hT0YuDI5ObidT1MF/zW
         O5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+kACnwoPL9G3aWY3sbCroCgBf/lGDDysOpJ20Nj1Ps=;
        b=Q0lay65BZHYQkmAykd2bQXyBBdxgjTi8jHRCmXOOVBMPegE12Clo4/hVz/mYtJRGal
         YcAm+lAhZf9bTIx6Pr/Ss6pdXRo7hHAM9OR1cAfjNIO8sflKkLZ7SG/nWS2BJ1Uz3XnL
         5GF/Np7PpLM8WuFnMHG7KzXVTbjPvFq3wVVfX88GT0/qFXK9QsI9SUNf3kynHrx9Bq51
         snXBjbsWHE/YNIStTd1WdMXZF9BXPH03GAXGqrkfMEZ58cupT+QfcqyNmHnI0onwNESP
         zEGitFIIfR/SsMDXtKGxSlb6P6GfIImDWZ3p6RXgVRPdQW3k6KzPLEch3FQnzlus5cw/
         Ystw==
X-Gm-Message-State: AOAM531xDu7aUpvGGx30eVQhd0y8Xdsx3To1z455HBAzN/GrMs3CT71l
        KZRVRt9n1iw4CwLeRz5CAbsiHViMc+QVBg==
X-Google-Smtp-Source: ABdhPJyMJYWF5UZZYqC+GrYO8S/Ga31EnXI7hhhMV3xsl11E9RLvDuWHuuPpd8pbo1WmMNyPjzmJfw==
X-Received: by 2002:a9d:7448:: with SMTP id p8mr4399343otk.306.1600819893227;
        Tue, 22 Sep 2020 17:11:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9c91:44fa:d629:96cc])
        by smtp.googlemail.com with ESMTPSA id p69sm8300689oic.27.2020.09.22.17.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 17:11:32 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip: do not exit if RTM_GETNSID failed
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, netdev@vger.kernel.org
References: <20200921235318.14001-1-jengelh@inai.de>
 <20200921172232.7c51b6b7@hermes.lan>
 <nycvar.YFH.7.78.908.2009220817270.10964@n3.vanv.qr>
 <7214fc31-42f4-2a47-0f01-426bed14711d@gmail.com>
 <20200922165749.3fb72ad6@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0bfd97ce-11d8-c1b7-e6fe-95bbb9cd488c@gmail.com>
Date:   Tue, 22 Sep 2020 18:11:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200922165749.3fb72ad6@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/20 5:57 PM, Stephen Hemminger wrote:
> On Tue, 22 Sep 2020 17:16:46 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 9/22/20 12:28 AM, Jan Engelhardt wrote:
>>>
>>> On Tuesday 2020-09-22 02:22, Stephen Hemminger wrote:  
>>>> Jan Engelhardt <jengelh@inai.de> wrote:
>>>>  
>>>>> `ip addr` when run under qemu-user-riscv64, fails. This likely is
>>>>> due to qemu-5.1 not doing translation of RTM_GETNSID calls.
>>>>>
>>>>> 2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>>>>>     link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
>>>>> request send failed: Operation not supported
>>>>>
>>>>> Treat the situation similar to an absence of procfs.
>>>>>
>>>>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>  
>>>>
>>>> Not a good idea to hide a platform bug in ip command.
>>>> When you do this, you risk creating all sorts of issues for people that
>>>> run ip commands in container environments where the send is rejected (perhaps by SELinux)
>>>> and then things go off into a different failure.  
>>>
>>> In the very same function you do
>>>
>>>   fd = open("/proc/self/ns/net", O_RDONLY);
>>>
>>> which equally hides a potential platform bug (namely, forgetting to
>>> mount /proc in a chroot, or in case SELinux was improperly set-up).
>>> Why is this measured two different ways?
>>>
>>>   
>>
>> I think checking for EOPNOTSUPP error is more appropriate than ignoring
>> all errors.
>>
> 
> Right, checking for not supported makes sense, but permission denied
> is different.
> 

Sorry, I meant that comment for the original patch about RTM_GETNSID.


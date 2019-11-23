Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA06107BF2
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKWARw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:17:52 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43944 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWARw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:17:52 -0500
Received: by mail-qk1-f195.google.com with SMTP id p14so7861822qkm.10
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Xaj0ldX8WniR2PG0Vl/wsG58e7OE9OBJmmCooCVkEEg=;
        b=j9BESahJkzvSP0C2cdZtLFzgmlNjaEBZ+GIEjvbdjD53bF3AtgCVBnlQfKRMNK6M+h
         zzQq+ng27CJzDXdwXhoWcfp81q2/Dg6Jk81vcWT9LA3jyYkNsbS751qrwYarK2Pc+hPB
         /37J0M15121sRy94RVlKhfngIPJmQLEQSLDC/8y+UwDtmuvUWn30WBf2DPP/8kBQygEq
         dZJk4m54xECK0Zu1oLrWLkeITxf6Jck+fdJHpGo3MRIMvIEGG6n7xoLU8ff2T7vrYoz3
         8FYl8HbbK9vcDn8dDBQQVyyIGHG2vQqaWxKMIjXhkMzs18hgnz38oZkP0VVTtFYesvwg
         BTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xaj0ldX8WniR2PG0Vl/wsG58e7OE9OBJmmCooCVkEEg=;
        b=kH4tmh/ZfdTM4Z/03Qq3SQW9tRKO7GW1xlv6Z7wKzFGKeqLhxCbTAqN0QwwxtZZmyW
         7Oc57opbzgkMOtHVHMHiYD4G9C+bX9H0PoK0R1vYdEt8sRClvKmG/CIirr3BsmF89FB4
         JJrDd88Eejq4pxLR9H/EirnLpyQ53jcdDZujcimtzLdc794K+zfgBejVbD8U8a6TaYIb
         d9Fu/Rxzd08eMeY02D5hostHgKSSXYpVSFXRM4mcMsLERhgIPKdz9bYkYubZUnt9qV+j
         L3JosaLDhFhzfeoJIn3eeP5cPWDHZah0fYcsEaKczorGT5BOeuGqiG3r5jf8YBIC5w2a
         dv/w==
X-Gm-Message-State: APjAAAVBuguRSW/MQcKnH12NT31Z0NkilQG7z+Om0p4OGk+s4U9go6c7
        Wc/T7mDv3a3g3yj2bhL+2xFimHJA
X-Google-Smtp-Source: APXvYqzNz0Iic7ADFh+nougNGwPT7s/X4ldyU9vbwiBQck0iqR9+PyMNczgN39h7thrl5Phbh6R8Vg==
X-Received: by 2002:a05:620a:3cb:: with SMTP id r11mr15608983qkm.320.1574468270469;
        Fri, 22 Nov 2019 16:17:50 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b0cf:5043:5811:efe3])
        by smtp.googlemail.com with ESMTPSA id x21sm3747133qkf.56.2019.11.22.16.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 16:17:49 -0800 (PST)
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
 <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
 <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com>
Date:   Fri, 22 Nov 2019 17:17:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 5:14 PM, Ben Greear wrote:
> On 11/22/19 4:06 PM, David Ahern wrote:
>> On 11/22/19 5:03 PM, Ben Greear wrote:
>>> Hello,
>>>
>>> We see a problem on a particular system when trying to run 'ip vrf exec
>>> _vrf1 ping 1.1.1.1'.
>>> This system reproduces the problem all the time, but other systems with
>>> exact same (as far as
>>> we can tell) software may fail occasionally, but then it will work
>>> again.
>>>
>>> Here is an strace output.  I changed to the
>>> "/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1"
>>>
>>>
>>> directory as root user, and could view the files in that directory, so
>>> I'm not sure why the strace shows error 5.
>>>
>>> Any idea what could be the problem and/or how to fix it or debug
>>> further?
>>>
>>>
>>> This command was run as root user.
>>
>> check 'ulimit -l'. BPF is used to set the VRF and it requires locked
>> memory.
> 
> It is set to '64'.  What is a good value to use?
> 

This is a pain point in using BPF for this. It's really use case
dependent. 128kB, 256kB.

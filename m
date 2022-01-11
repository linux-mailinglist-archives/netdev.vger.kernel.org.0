Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7D48B932
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiAKVMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:12:32 -0500
Received: from linux.microsoft.com ([13.77.154.182]:36940 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiAKVMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:12:32 -0500
Received: from [192.168.4.54] (cpe-70-95-196-11.san.res.rr.com [70.95.196.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id AEF1520B7179;
        Tue, 11 Jan 2022 13:12:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AEF1520B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641935551;
        bh=dYFoxWxF0jLmPhTwwTPOEtFkEpz3E7ZCe7CBhSTeenI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qw3shpIVJY7D2qeZoNyszbNsXUOWBs328M1uL/bdSfEnRro1CQhmCEH+wCYj21O1t
         bJ//XdLGxwotIkx4OTPcdyKJMzfnj+OqxGqQd1lQWRQXasrMDSbsLl8+62c2FdNFrY
         gQ5JPinq/wRybgk2QZhLIaKV7UC5NLHn790uc1lA=
Message-ID: <c45dd329-9606-4103-60bd-904f9f29f01c@linux.microsoft.com>
Date:   Tue, 11 Jan 2022 13:12:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [bnxt] Error: Unable to read VPD
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>
References: <f7bcc68d-289d-4c13-f73d-77e349f4674e@linux.microsoft.com>
 <CACKFLim=ENcZMk+8UUwg87PPdu6zDC1Ld5b54Pp+_WSow9g_Og@mail.gmail.com>
 <6d6ff22c-df69-36c2-4d42-03ed7f539761@gmail.com>
From:   Vijay Balakrishna <vijayb@linux.microsoft.com>
In-Reply-To: <6d6ff22c-df69-36c2-4d42-03ed7f539761@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/2022 11:41 AM, Heiner Kallweit wrote:
> On 10.01.2022 22:15, Michael Chan wrote:
>> On Mon, Jan 10, 2022 at 1:02 PM Vijay Balakrishna
>> <vijayb@linux.microsoft.com> wrote:
>>>
>>>
>>> Since moving to 5.10 from 5.4 we are seeing
>>>
>>>> Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.0 (unnamed net_device) (uninitialized): Unable to read VPD
>>>>
>>>> Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.1 (unnamed net_device) (uninitialized): Unable to read VPD
>>>
>>> these appear to be harmless and introduced by
>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a0d0fd70fed5cc4f1e2dd98b801be63b07b4d6ac
>>> Does "Unable to read VPD" need to be an error or can it be a warning
>>> (netdev_warn)?
>>>
>>
>> We can change these to warnings.  Thanks.
> 
> Since 5.15 it is a pci_warn() already. Supposedly "Unable to read VPD" here simply means
> that the device has no (valid) VPD. Does "lspci -vv" list any VPD info?
> If VPD is an optional feature, then maybe the warning should be changed to info level
> and the text should be less alarming.

See no VPD info.

> /sys/bus/pci/devices# ls
> 0000:00:00.0  0000:01:00.0  0000:01:00.1  0008:00:00.0  0008:01:00.0  0008:01:00.1
> /sys/bus/pci/devices# for i in `ls`; do cd $i;ls -lR | grep vpd;cd ..; done
> /sys/bus/pci/devices# lspci -vv | egrep -i '(vpd|vital)'
> /sys/bus/pci/devices




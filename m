Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF24177162
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 09:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgCCIla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 03:41:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36553 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgCCIla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 03:41:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id j16so3240809wrt.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 00:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3V65oKEL3odvbpv7QRBaftU6Ijme9RUUVLbqDRg7mI4=;
        b=pw1ple4ik8Rigrmkv+7/Ki6p2iYApxmuLELfEPMPaXfz0MGKXcTMfLdRjc+crRcfiP
         wg2OPO9QEboeRRgypmlgcWxiCOimPzn8WZGivC9UbFIp5BdLg2/qCsl/rZlcyyG4jXYB
         UoMm6B4TAVC+/gCtbAUTjwwhx1mYJTxJt1gjlcV5eTlUA7/dmjMcsGkD6kCkrKjcEbTj
         J3cs/Mt/+u8gAReD7sgqfhOPK/rDu6cBUtjaV45YiHz0Elg6gP2yj8s6ihnIMGmn6M4z
         Jw5ZkKeMZeJzxrFUXvu6Zkjv0y92YdupyMV2W5emLz9IQ3y9I4ASBFJPV6haowV1hEiC
         wPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3V65oKEL3odvbpv7QRBaftU6Ijme9RUUVLbqDRg7mI4=;
        b=rwHajeGuX+iDz5gyA/HAYOXPSYuepa0h9Zy8gRsN/bnU8hwdK5x+OqO8B46lfUn0+K
         LLncbq3xtZuFypQ+qmS/a8gimhzB1oNfoVImfXzVKJKbiYfiG7mAzIdUZz352Jd0s/Fa
         5QCy/HkQo0+J+qtdiQfSwYf8YU39eb8tzeUNz7ckWBtUfHay7Z4JAAX2EbzkFva14X26
         ge+BdgNPvXGM6kAcPrzv4p31visnudRlT6owmVgKiqXdPs7+Y5TlNKNQQXOeoA6x4Dnw
         4EUVLam2MiFsPp0xKLNs0d9QVIAmJzNF93tAbwacVRaD0Esp2i42GEawcv3UrtnQaIjk
         Gexw==
X-Gm-Message-State: ANhLgQ3WniZRaqO8fIccQk9tIlWY/4oUNv6EfiNjAMQhKgXtpE3ypVd7
        dfOyDk6cF/g3KSAIvE1MCmnMMtbkGGI=
X-Google-Smtp-Source: ADFU+vuv6oEADCs9VwQWM2jf5ITzVbFMIcmacrLnNdCh3mQmrQxDCfwHHNWo8+xlnYuVzHf1hor2yg==
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr4339320wrp.200.1583224887649;
        Tue, 03 Mar 2020 00:41:27 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id g187sm3141746wma.5.2020.03.03.00.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 00:41:26 -0800 (PST)
Date:   Tue, 3 Mar 2020 09:41:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 11/22] devlink: add functions to take snapshot
 while locked
Message-ID: <20200303084125.GA2178@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-12-jacob.e.keller@intel.com>
 <20200302174355.GG2168@nanopsycho>
 <2261c128-7a8c-a8ae-0bdc-3b856995aabb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2261c128-7a8c-a8ae-0bdc-3b856995aabb@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 11:25:16PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/2/2020 9:43 AM, Jiri Pirko wrote:
>> Sat, Feb 15, 2020 at 12:22:10AM CET, jacob.e.keller@intel.com wrote:
>>> A future change is going to add a new devlink command to request
>>> a snapshot on demand. This function will want to call the
>>> devlink_region_snapshot_id_get and devlink_region_snapshot_create
>>> functions while already holding the devlink instance lock.
>>>
>>> Extract the logic of these two functions into static functions prefixed
>>> by `__` to indicate they are internal helper functions. Modify the
>>> original functions to be implemented in terms of the new locked
>>> functions.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> 
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> 
>> 
>>> ---
>>> net/core/devlink.c | 93 ++++++++++++++++++++++++++++++----------------
>>> 1 file changed, 61 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>> index fef93f48028c..0e94887713f4 100644
>>> --- a/net/core/devlink.c
>>> +++ b/net/core/devlink.c
>>> @@ -3760,6 +3760,65 @@ static void devlink_nl_region_notify(struct devlink_region *region,
>>> 	nlmsg_free(msg);
>>> }
>>>
>>> +/**
>>> + *	__devlink_region_snapshot_id_get - get snapshot ID
>>> + *	@devlink: devlink instance
>>> + *
>>> + *	Returns a new snapshot id. Must be called while holding the
>>> + *	devlink instance lock.
>>> + */
>> 
>> You don't need this docu comment for static functions.
>> 
>> 
>
>I like having these for all functions. I'll remove it if you feel
>strongly, though.

Nope. I just wanted to note you don't have to do it.


>
>Thanks,
>Jake

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9476D33ED52
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCQJqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhCQJqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:46:10 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9121C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:46:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id s13so1264756lfb.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=sFcRKYB/8XQJ0XQMB0CqKFzemot4DGSzRMugJlpgm4Q=;
        b=P3cf1YcxUZ0XmrMaR67ZdarmpBjmeZmvC/sljjFFEZYw4/MsHp2RHv6oxzvkT+eobY
         e066PHuEOZSQS3X01djLq8eO2G0fo33byke9byc6k91wiyug32undkAoEIngGEo9glVv
         /cVh48PGwtz5o/k4JCLBmXotHdYJoamTfiG7FXwBBUmI81eNNufiP8CUv3mkaq5z2xsy
         ImdjdgH2fMXDucO+vBy+j0kQf6ytrJoKcPGfCo2mQdpBzg9esHjmIvb6QTzXbGulpjHA
         3M7JYHjlsbbM+eY0S43EtqXFG+eMt4hASHzSc3xqLQHy8fBtH8Cx73AoGqmlJXu78HNG
         F5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sFcRKYB/8XQJ0XQMB0CqKFzemot4DGSzRMugJlpgm4Q=;
        b=jjIgeNPPDKqoFalnlvt54khpTR3P5jIUwZcxmFPSPP/zsJD1G75oDKzJwqmK0GLLvG
         akL1vlAC9PHnqiGQARQJTgQrvEOxjhssD9XpBLUHWsRvsUCbKyi3xcCwV5iiPbHBudDZ
         Ss81yiwB1TQo4jaD4lQb0xE0lDYJPSg1cpPs+IT5zzBmw4OTcna9p7hmpOfOmV8l817f
         wBD+TRPrhw1LKK69tyY3M58pHK4TDljMiVeTjvcbl3kmr15wQrc8EmABltiEm2TEUvFo
         9cUYP1LlMvt4F0hXzy9kp4hQpAIgcxFcRWR6eb+DE/+fIj4EYf4ODb/mpjxr1kIwRn3K
         eDMw==
X-Gm-Message-State: AOAM532RJwuV1/eiNxeTqOMRGehHtD1EUHa89F3X630yh9QZfzXZusQB
        zbhJtSafnGCmg4O3TmCpZ17JwtjoBcLVnhf1
X-Google-Smtp-Source: ABdhPJyV7f80nNVLbm1NbDNyCCDNHMUmSAFK3e8yt+kiRqFWv99OlQIc8WMvovbem/vHB7ewEBzJYg==
X-Received: by 2002:ac2:5603:: with SMTP id v3mr1960984lfd.67.1615974368115;
        Wed, 17 Mar 2021 02:46:08 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d8sm3330840lfg.96.2021.03.17.02.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:46:07 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
In-Reply-To: <20210316091755.uxzjhcjy4ka3ieix@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com> <20210315211400.2805330-3-tobias@waldekranz.com> <20210316091755.uxzjhcjy4ka3ieix@skbuf>
Date:   Wed, 17 Mar 2021 10:46:07 +0100
Message-ID: <87v99qnme8.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 11:17, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 15, 2021 at 10:13:57PM +0100, Tobias Waldekranz wrote:
>> +static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>> +			     struct mv88e6xxx_vtu_entry *entry)
>>  {
>> +	int err;
>> +
>>  	if (!chip->info->ops->vtu_getnext)
>>  		return -EOPNOTSUPP;
>>  
>> -	return chip->info->ops->vtu_getnext(chip, entry);
>> +	entry->vid = vid - 1;
>
> Should the vtu_get API not work with vid 0 as well? Shouldn't we
> initialize entry->vid to mv88e6xxx_max_vid(chip) in that case?

Good catch. We never load VID 0 to the VTU today, but this function
should be ready for it, if that ever changes. Fixing in v2.

>> +	entry->valid = false;
>> +
>> +	err = chip->info->ops->vtu_getnext(chip, entry);
>> +
>> +	if (entry->vid != vid)
>> +		entry->valid = false;
>> +
>> +	return err;
>>  }

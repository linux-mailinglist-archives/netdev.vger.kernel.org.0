Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE1816B9A1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgBYGX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:23:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33137 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYGX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:23:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id m10so1457785wmc.0;
        Mon, 24 Feb 2020 22:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XpoCQmnnCoX+EypbLxK5wzw5eTUegrwSIJVovT9oIng=;
        b=LtvmPH06lEPFG8OMZr7AWSiUxP2nhinlf0Z31SrJfHdhmPxKNOalF+o47G7XNsP2iU
         /8RdGJlXHGUuoin0ZV8LkVbMAsAQTHmD0g/6h4j0TYQKIDEfhRpIFkC+IZtxrf/MKcrO
         EEG9EMP5ueeVl3sjEgP/zKaW6pYLoa0fclnYExT3ZqLz+fVNY+FZuBzE922FOJo3ElR4
         2TUIxRNthSYs+5S5cwEINKDatmDWQ0Zze6bYxLOKyzRThPBjC6DEPYKQOgctq6l4Cn/W
         f0pJsJfnll2bhyzz5d7C9APxrCuM6otCPgO13gs/qnt2EWqBYIFyLdlJBBKl8uedC9WF
         xSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XpoCQmnnCoX+EypbLxK5wzw5eTUegrwSIJVovT9oIng=;
        b=qKJtJtAuZ5VaTc3EejnodqtB0+3gzHi3xg2Aexea7nWWsYd7cLUSQwHtJxYOJF5tLL
         9J2GAMLB202IdMaWVCwL12uDnzz4STfYdIA0rpt1yc4IQuMo5UcEeSai7/X6VxzxpTR8
         A3j4hMDL0tz4PZqg9Jop8/Ym3B24EAGWmIAvahW67ynjV2tWnBrU53Mt6GgdfIimxVz+
         Y7x+HZjYS/ssWuFvLf4njes+liwA25BAkHJr7gjm8IvG+jBPuXpPmHyLnedRK+5R4LcS
         JSoPXNS0VisLcP3lmPt3D0Gkk5zVpq16rIXu4tSqVnpw6OToFyop/dmGBvsLa9nYe4JG
         82lQ==
X-Gm-Message-State: APjAAAXNfUiF9zhFKe1Jx8XJ3769jMftHwlYR1fTc/fyGGwbp4JweSMx
        kjpjfwFwAJrAJxoDZiXAoEU=
X-Google-Smtp-Source: APXvYqxFarTonU8f+JPpOAAw/pmNuxJbNOWDYR4F86yTdLQ2YTkbLgsv346IwIWXaxzH05PFdi3kZg==
X-Received: by 2002:a05:600c:2107:: with SMTP id u7mr3329593wml.54.1582611835918;
        Mon, 24 Feb 2020 22:23:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:d5d8:c920:d17:5c? (p200300EA8F296000D5D8C9200D17005C.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d5d8:c920:d17:5c])
        by smtp.googlemail.com with ESMTPSA id l6sm23742710wrn.26.2020.02.24.22.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 22:23:55 -0800 (PST)
Subject: Re: [PATCH 0/9] PCI: add and use constant PCI_STATUS_ERROR_BITS and
 helper pci_status_get_and_clear_errors
To:     David Miller <davem@davemloft.net>
Cc:     bhelgaas@google.com, nic_swsd@realtek.com, mlindner@marvell.com,
        stephen@networkplumber.org, clemens@ladisch.de, perex@perex.cz,
        tiwai@suse.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
 <20200224.153352.364779446032996784.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eb522c30-8d9b-0223-c152-9f2bd972c23b@gmail.com>
Date:   Tue, 25 Feb 2020 07:23:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224.153352.364779446032996784.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2020 00:33, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Mon, 24 Feb 2020 22:20:08 +0100
> 
>> Few drivers have own definitions for this constant, so move it to the
>> PCI core. In addition there are several places where the following
>> code sequence is used:
>> 1. Read PCI_STATUS
>> 2. Mask out non-error bits
>> 3. Action based on set error bits
>> 4. Write back set error bits to clear them
>>
>> As this is a repeated pattern, add a helper to the PCI core.
>>
>> Most affected drivers are network drivers. But as it's about core
>> PCI functionality, I suppose the series should go through the PCI
>> tree.
> 
> Heiner, something is up with this submission.
> 
> The subject line here says 0/9, but the patches say N/8 and patch #8 never
> showed up on the list.
> 
> Sort out what this should be and resubmit, thank you.
> 
Oops, sorry. I'll resubmit.

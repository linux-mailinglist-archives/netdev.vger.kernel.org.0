Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4BA120F84
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfLPQcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:32:46 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39277 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfLPQcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:32:46 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so5672791ioh.6
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OTvgXVbBEevcEsXrShXhcmmSBP2ME5j9XypM6JpuGC0=;
        b=fyTUxEu1oSYzaz4TDtVIPPquhB+9cySas7g2Ad9z8zba1ADA8GXGVHs01WVis7lY9B
         5iLdG05ag6sCg2hI1/YCfngAbQawc7ThzeyhBMg0U8gd4nJEV30su7tXdBoqXQA7rGGw
         xE1P9PeBAzMRX1pHClgCg9R2SXimJ20n8BVxg7ebqD2/afYi+H/qNnQCP2MWT7BLCpfs
         xRNvTs5S02ks5qj9eOV+Ii/3+SfbbF7Hizd5ugfzjZI3qDFpm0y1CBI/uD6IWFMlLfqn
         L/cu83cAca6XxLPbDbspYfNjSgfncBB+cu+5q+81nZtqVzRmkSFMvUWUJ711KrXVwqpo
         7+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OTvgXVbBEevcEsXrShXhcmmSBP2ME5j9XypM6JpuGC0=;
        b=Fe0pdM0BAXa4wuWxGnuGdMyXQlJi1dr7f2TBbDzSNC/nI3YBBpV5hfBw5gnjh9DTzF
         8QuoOunS7w9Axnve/9Ah6ihDVy1nXsWeD/OC6SATuGfdz6v6/jSjCaz4fXtxddWoPfR2
         aZHC8Dh3XU9ombblsVw62zIugBmWVeg56CkMyPNlVB5BPOIKfFw8ixja76q8RjjO8TSh
         fLb9lQRDjRzDmZWrSpTCgAcirPkd9D7ugieN33iwF54X2gnvpYJ2NYWakB04T0kRU6d/
         ytWBKZfV1OBH543N2Srl/fZ+WHRKAKRBmrdBxhdBRomdtNQxrHd+bLM19rzjR3nV1GaV
         ojlw==
X-Gm-Message-State: APjAAAUElRkQcqqy7QfHq1xPcN/Al6Am8oKtwWilIKd1GIxTYaieQBks
        XKejjBX0a4lJaDgyH7MrTtk=
X-Google-Smtp-Source: APXvYqyojQ47bbOI4AciX8tn/k3MRNZxprr6iuavZ6evFYDsBHTOt8dmLR9VHtDnxBjtchh/oCqJGg==
X-Received: by 2002:a05:6638:4e:: with SMTP id a14mr12948439jap.84.1576513965769;
        Mon, 16 Dec 2019 08:32:45 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:c48d:b570:ebb:18d9? ([2601:284:8202:10b0:c48d:b570:ebb:18d9])
        by smtp.googlemail.com with ESMTPSA id c73sm5919471ila.9.2019.12.16.08.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:32:44 -0800 (PST)
Subject: Re: [PATCH net-next v2 01/10] net: fib_notifier: Add temporary events
 to the FIB notification chain
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191214155315.613186-1-idosch@idosch.org>
 <20191214155315.613186-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1993884b-10e4-c148-0cb6-4f1c2442708e@gmail.com>
Date:   Mon, 16 Dec 2019 09:32:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214155315.613186-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/19 8:53 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Subsequent patches are going to simplify the IPv4 route offload API,
> which will only use two events - replace and delete.
> 
> Introduce a temporary version of these two events in order to make the
> conversion easier to review.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  include/net/fib_notifier.h | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>



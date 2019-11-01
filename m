Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACD4EC2D7
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfKAMkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:40:09 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45456 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKAMkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:40:08 -0400
Received: by mail-lf1-f65.google.com with SMTP id v8so7094885lfa.12
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o8ofZ8eXn+g9/RF1tzn7A+DDx4j3eT/FW3TtKGM6VyE=;
        b=Ng8wgICpvpl1MfKvPqHa0mPOudn1mBAB5RoXVdSLBNf5UJWAyf9zafHKqhK4WnDrdV
         hNDUzcK7yBFt5L6iZCL9dJ4pVs2OuLBc0f0qeTMguHKgE4HCDmJXuhTbgvwtn3ejnOIL
         HHcnPMCxiafLfuGC4xBvZyDX1HauQpq/kH1Qw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o8ofZ8eXn+g9/RF1tzn7A+DDx4j3eT/FW3TtKGM6VyE=;
        b=RiUzSmeJoljlDD+QRUrf0EFPAci8aTck641ADLdTDs29tjNd1UBfCbuIxE/bbonRs6
         REgerZs9Gm+ykDiCzIF15A3PF9jjE7IRd9RSOPr/6ne0pyMpQdecB/TThAqkI2vX8Kdv
         dB9Q3DiiumZcv4Naq2v2d4F4vEiUeGPHLB87N+WJKSo3vtdG9n1O8iqH+qszxd8X+hNd
         CTkC5JjP7sSXz/Pk0nZmxbtK65meWOMLRig+1Com1eVl2I0g4ZQFPMjkxXTv+jWlSrAa
         dSIaNcxuGgIUn5Fx+kXsW+uJeY+UX/fF5nrhLd6xoZR8k6VpdL8zvHCN+j01d/AkAPyE
         hGuQ==
X-Gm-Message-State: APjAAAW8d3U+ZjEQiR4pKtcwS76mqPClsgQyAbmvZgZIlXoy6LqfwFdj
        42rGohYRDiXgAVK6eI7XcZFGDQ==
X-Google-Smtp-Source: APXvYqznRsj4Tuag+vZIMClNNYXsLqbHaLZ5hXMSJywhknE607w8pkePzAta0Po0xwQfm2uV2zSuTA==
X-Received: by 2002:a19:651b:: with SMTP id z27mr7080070lfb.117.1572612006816;
        Fri, 01 Nov 2019 05:40:06 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c24sm2771269lfm.20.2019.11.01.05.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 05:40:06 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: bridge: minor followup optimizations
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net
References: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <3a71de17-99ab-813f-62f2-691cde514e31@cumulusnetworks.com>
Date:   Fri, 1 Nov 2019 14:40:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2019 14:38, Nikolay Aleksandrov wrote:
> Hi,
> After the converted flags to bitops we can take advantage of the flags
> assignment and remove one test and three atomic bitops from the learning
> paths (patch 01 and patch 02), patch 03 restores the unlikely() when taking
> over HW learned entries.
> 
> Thanks,
>  Nik
> 
> 
> Nikolay Aleksandrov (3):
>   net: bridge: fdb: br_fdb_update can take flags directly
>   net: bridge: fdb: avoid two atomic bitops in
>     br_fdb_external_learn_add()
>   net: bridge: fdb: restore unlikely() when taking over externally added
>     entries
> 
>  include/trace/events/bridge.h | 12 ++++++------
>  net/bridge/br_fdb.c           | 30 +++++++++++++++---------------
>  net/bridge/br_input.c         |  4 ++--
>  net/bridge/br_private.h       |  2 +-
>  4 files changed, 24 insertions(+), 24 deletions(-)
> 


Aaargh.. apologies for the noise, the script caught an older set export.
Will re-post a proper v2 in a minute.



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20F7B3132
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfIORh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:37:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34542 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfIORh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:37:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so18117125pgc.1;
        Sun, 15 Sep 2019 10:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1F7aUJVQgduxhZxHfqJkmmUC8zgMBUZn2pCjL4AgRrE=;
        b=uv4CWWnirInfH+uqYYzAqwEssTBS30r4kB1lG3CQt5qiAyNKeCbqMiGJj2/xPAsapN
         ParDZKOrWA5zXCRB66CLBElxYr727uPqZMyTxbWJD79x2JWOyx/6kMSH6QLdlHuE6F5t
         r+NJg56vmijpyyPIxYnePGYJPr89yHc+xFsgzpNq3B+AKVBua3V/gBnPduo2MT9j9Mah
         iihhe5S3qwOirBswADfXeCW7+3w3/FMOp47KXmHhfi4iWpaPgbTuXg+e+bcM2QWJeCrB
         DI1BHVP55UGVlyCnLL3Vdxs4Ai2nZwP+9rzJWDu4MlLM7yJ0jjo3Kn48uyNRmMzZYOgt
         z/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1F7aUJVQgduxhZxHfqJkmmUC8zgMBUZn2pCjL4AgRrE=;
        b=bMeq735EselU7xP6vleRHm4N5Dm3XNTs86OH12goqbnexE+1pVbgQ0xaZyG9FI9qxQ
         117FMtHKzuaWMgmYLDGNEaKMxMU6p7VjED+8fwnrfyxz6s/hoqBuwGNmwWJ5wSYYAEBS
         QGWhaf2LdYET11VZb/MuCkRAPTpFtXeSPIAT5rPc3PRdMDoaknGPcTek5gqf2MdBAKjA
         sHi80MRDk1H9RtfkPvNjPcLZq2/YhFFAEDuJ2YRBdxyTUaiJfBZ8nsqpWopuEzHOPF9K
         nq8D4tEbvzOGKDCu1rBAyDPSydQtxo48BLDCulYCPtmYc3yZcFl0MXpqRcPP5PIhHcEU
         AcoQ==
X-Gm-Message-State: APjAAAUdeD6CFB80wr19iu0YCZVaqKxob1qzm3RXeMz7p0+w+eSQ/DYn
        V4gUp7iI7jMvuj/Ny4DXMumVq2tGeeM=
X-Google-Smtp-Source: APXvYqwDiZ7BjAhmWHrC10pzG4lkpQGykHTQ1xhzRDLapduQBdCCDD3gRvM1Rtu6BxU6p8Tz+R5Urw==
X-Received: by 2002:a65:4489:: with SMTP id l9mr54273753pgq.207.1568569076754;
        Sun, 15 Sep 2019 10:37:56 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id m12sm5997323pff.66.2019.09.15.10.37.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 10:37:55 -0700 (PDT)
Subject: Re: [v3] iproute2-next: police: support 64bit rate and peakrate in tc
 utility
To:     David Dai <zdai@linux.vnet.ibm.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zdai@us.ibm.com
References: <1567609611-27051-1-git-send-email-zdai@linux.vnet.ibm.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e78ccb9-5983-f5f8-dded-0b193125c43a@gmail.com>
Date:   Sun, 15 Sep 2019 11:37:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1567609611-27051-1-git-send-email-zdai@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 9:06 AM, David Dai wrote:
> For high speed adapter like Mellanox CX-5 card, it can reach upto
> 100 Gbits per second bandwidth. Currently htb already supports 64bit rate
> in tc utility. However police action rate and peakrate are still limited
> to 32bit value (upto 32 Gbits per second). Taking advantage of the 2 new
> attributes TCA_POLICE_RATE64 and TCA_POLICE_PEAKRATE64 from kernel,
> tc can use them to break the 32bit limit, and still keep the backward
> binary compatibility.
> 
> Tested-by: David Dai <zdai@linux.vnet.ibm.com>
> Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
> ---
> Changelog:
> v1->v2:
>  - Change patch submit component from iproute2 to iproute2-next
>  - Move 2 attributes TCA_POLICE_RATE64 TCA_POLICE_PEAKRATE64 after
>    TCA_POLICE_PAD in pkt_cls.h header to be consistent with kernel's
>    pkt_cls.h header.
> v2->v3:
>   - Use common functions of duparg and invarg in police filter.
> ---
>  include/uapi/linux/pkt_cls.h |    2 +
>  tc/m_police.c                |  149 +++++++++++++++++++-----------------------
>  tc/tc_core.c                 |   29 ++++++++
>  tc/tc_core.h                 |    3 +
>  4 files changed, 102 insertions(+), 81 deletions(-)
> 

applied to iproute2-next.



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB34787AA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfG2Imc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:42:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32905 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfG2Imc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:42:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so60947625wru.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 01:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HM9wt+7L8iCxq+XhLcq/mYJLhBqmWxeU0HeP7054uFI=;
        b=M7Ew+e8V8IYqDaBkX9ZqaOWxitWlDsnStPaZJZocWesm17uealDovRVwxHNaw5Ww7x
         s5//Gxpc3fLoi7ksTk3qDFih0C3QUNtPN9Hthj/kWn26w5RatTy8DdJ3n4cyvh4ZPDCI
         Vu2CA7Fa9ymRTgw33vwx5Dmhh1QJMhnpMlFweCaaA+WXKF0o3BzF7NEF6wDLPyaUO4Ym
         5rOoG6gM2QBJUL/kZSGsV/rab+xx5zXg4PLx1HT6UpNTxX7aEZ+iys+alntQl5a8hELQ
         r5eMb8oAyM1hfJ4sjxv2Wo0dXi3ahq1nTZ2Txioql/YsWGF1JsHvPHYo6NscGifbDTUy
         sbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HM9wt+7L8iCxq+XhLcq/mYJLhBqmWxeU0HeP7054uFI=;
        b=GjsEo7weOme37nVuRLj1Ze2WUT1IfArx6IfUaTBtbxrKLz0vSKjPCDP/jgo8INfCPe
         We9OHEzX93uR4IxZztO3Vs0gUBljd6Bv/PILH0CxXQNEo+OCaQeynVGet1KJ96DZqpCV
         6xcMCcbsxcJobs0B1gIFp7MyzfKFh6YsC+poh7xz1Pz8JPY7vQiIDMTvTAwRsp2zdq8s
         hSk9uexjPVrEbPIrWRparja3Zu3rzWHkkvo6k9gLT2td5udgQISf2BnhceoUV0VGpchY
         bCRaB7NMfYaQoW+rtBMV5NNRFQi9EcNaeaO6/dUEJh7vmFE8zHnoUkcMIXSgLGrxeE6I
         BTJA==
X-Gm-Message-State: APjAAAXBleuJWE5+w4Ls9bLYV0KPdAZOE2VtCyQjTKR4e8YxON2wRjGS
        j9+sJKL8FM5/hcNGp5Cbhyo=
X-Google-Smtp-Source: APXvYqyZM49wAAISdKAPa1qeQvCisClNRF0liq1nsGklqMEN5hl9QSImiAElZn2gaM/Fj3NkJvA+RQ==
X-Received: by 2002:a5d:4e50:: with SMTP id r16mr114007668wrt.227.1564389750065;
        Mon, 29 Jul 2019 01:42:30 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id c78sm84201547wmd.16.2019.07.29.01.42.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 01:42:29 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:42:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: sched: Fix a possible null-pointer dereference
 in dequeue_func()
Message-ID: <20190729084228.GD2211@nanopsycho>
References: <20190729082433.28981-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729082433.28981-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 10:24:33AM CEST, baijiaju1990@gmail.com wrote:
>In dequeue_func(), there is an if statement on line 74 to check whether
>skb is NULL:
>    if (skb)
>
>When skb is NULL, it is used on line 77:
>    prefetch(&skb->end);
>
>Thus, a possible null-pointer dereference may occur.
>
>To fix this bug, skb->end is used when skb is not NULL.
>
>This bug is found by a static analysis tool STCheck written by us.
>
>Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
>Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

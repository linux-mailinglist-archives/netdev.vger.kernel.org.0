Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099094C936
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfFTIRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:17:10 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33028 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfFTIRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 04:17:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id y17so1786588lfe.0
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 01:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gg0yMFESYjeQyXwPEmDygv0Cu836J6Ow1bSJiNUhAfA=;
        b=lXQ2XvatpLV2xgDnqIUkwDCGYPWhYsLI0WWTA2FiEIGXMow5y8LEkIyRMes8/dCBey
         OAEASfT/UkV5Bs0DiEEmgyYxR1e55hMqiA65gc3xVyrN97fr0BK1oTAkacru05rQBkoH
         Hm2/7f+OqilVDA8T6a7RD2scg78sG0/dv/ZOd5A6EWmG/XacdcqKikjTvqZvM+mSsSa8
         b+NUpsNmKIgyRZYd+uhAFgBImfr0jtgbBzeY9CpOhxC2kQYkMsB4aMlbdPWd8W0PEpig
         7W0+N1ITFgv1czTPRzBxgsko816o8nB6r7cBzojm69Xjcfons0DZz3gst0yKISwruthg
         WsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gg0yMFESYjeQyXwPEmDygv0Cu836J6Ow1bSJiNUhAfA=;
        b=gLQ3H6xIJ7kYwGisrB29iT/RwMtDOPqIPTcuXJ8EL1CPN9zqIXYLzuBKkgmLukwIQv
         +MMNUhwcGw6R3t0xPwRxWtqnh4jKJiJAr1NHjt/o4dAo7kFZhDKP2mkFUk6pyegjbb2f
         /PJ1K/qYSKWNlXVnBipLHJiGVqmZ2/UH4UuwyR6L/+Lmib4Ggomfuauzc4JNH+6D0//q
         THqnvgoiIJwnVX1P6jvTTDmDxb7sAMyyYEBTYPn4VQExVYEEas+L5Y/1GDI1qvYyi3kH
         +aqgdAFZKcDF1dYo8lh6/bUtUSHxWyJM7duzAvcQ/hbiiqxglI29q1Zl7oFu6rdm7MVO
         sRvw==
X-Gm-Message-State: APjAAAV2kmnt6wwtnX8fMmrPejxap1p2hiFi80AWriWYXEen8jyyHEbD
        zAfuvsl/Z1Y7qt8NtyNXkjXDeg==
X-Google-Smtp-Source: APXvYqzTZakyuNZDE8DK/MgRpMC90V3ffgUu/ysZXi87rs7r9zd7fTy2dAGZ+NUtxNBgw/EMeRrrBQ==
X-Received: by 2002:a19:428b:: with SMTP id p133mr23949059lfa.179.1561018627786;
        Thu, 20 Jun 2019 01:17:07 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.13])
        by smtp.gmail.com with ESMTPSA id l23sm3448650lje.106.2019.06.20.01.17.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 01:17:07 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/7] etf: Add skip_sock_check
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com
References: <1560966016-28254-1-git-send-email-vedang.patel@intel.com>
 <1560966016-28254-3-git-send-email-vedang.patel@intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c304970a-1973-cdce-17b5-682f28856306@cogentembedded.com>
Date:   Thu, 20 Jun 2019 11:16:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <1560966016-28254-3-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.06.2019 20:40, Vedang Patel wrote:

> Currently, etf expects a socket with SO_TXTIME option set for each packet
> it encounters. So, it will drop all other packets. But, in the future
> commits we are planning to add functionality which where tstamp value will

    One of "which" and "where", not both. :-)

> be set by another qdisc. Also, some packets which are generated from within
> the kernel (e.g. ICMP packets) do not have any socket associated with them.
> 
> So, this commit adds support for skip_sock_check. When this option is set,
> etf will skip checking for a socket and other associated options for all
> skbs.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
[...]

MBR, Sergei

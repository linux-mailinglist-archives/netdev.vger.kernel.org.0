Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D017349D26
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbfFRJ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:28:57 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32938 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbfFRJ25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:28:57 -0400
Received: by mail-lf1-f65.google.com with SMTP id y17so8744626lfe.0
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 02:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LaIXT35LNBxZx9kiA+FASn/VWYxf49mAYUDbGkviNOY=;
        b=Y0ZAv1eHbGmWgVthNUBIoU7LLatJnsqhIgmiubpwcD2A6yB0rrDoNNvqcFzGXY8zfq
         Tmz50TmIWHANVcXbz/cuiIu1y8eWst8tTv6s30B4V4DctiTIhMMPOPJY76Clf5G/vp05
         4YMFf8Cyrqlt85mEBWmCTtUM+XGbpcYP9YrJ10+iTPdVUjH2/7PqMamQiGbwUnIjxcJQ
         Mnvus2sgAhBXt8pcaOfeK2pcqJqlaaKWSYI0xS3LEd56rYKuD7T21/RpXwRPkBBVEKs0
         npH7J/+2RGo5OpU6v/Dot5Pb4CLRHwGHWRgUmk+L0cxbKKhB0VOmjGobKVdH/rCMfPbZ
         SwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LaIXT35LNBxZx9kiA+FASn/VWYxf49mAYUDbGkviNOY=;
        b=mXrjUAYb4qRmVtyQL67QHW0dPDZ2IdiPTVSSDvw2dpWtYtdy54jvKB4BKhaA2Ydm/B
         Z9VFgrmmeX1kxa+AZHcJyhpM28pArwCW6okoYBvQNxLb9ODVk32OGsPAeKxC9ImVPxdo
         c+7DgZfRTRKOb+EVSHalv9VwCVr470EGajqG9zBPrh9/fXFGIDyANPIer1sFyLqwuis7
         ZpPL4hpukjib5nvY6la5PIA2Yhzw3M4OVgHDGke2h6JjwCgtaWoSb6Gp6es59SfAqw1q
         S9QWiuHbmZinqDy+46C7lb3oiNJeb++6Gr2i0O2aFG/ILernEDVYfqPBkm7HRZ5zekeG
         MFGg==
X-Gm-Message-State: APjAAAXJQLGjM4BeaLOWW2oSgZH9QUWkGbR3apaoENAwBkeJ6VIlZTxK
        RW5bPWvMdXVOnuHtzhdcFOrW/w==
X-Google-Smtp-Source: APXvYqwn/Y4BA9qgExwuNjbhDZh2ndI2G+wayTKGMzADAfoFwjrTPn5gvKHqIqXRuRcb6JEp3A0bHA==
X-Received: by 2002:a19:4017:: with SMTP id n23mr62885092lfa.112.1560850135425;
        Tue, 18 Jun 2019 02:28:55 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.40])
        by smtp.gmail.com with ESMTPSA id h3sm2511409lja.93.2019.06.18.02.28.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:28:54 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/6] etf: Add skip_sock_check
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
 <1560799870-18956-3-git-send-email-vedang.patel@intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3b9b74f4-526e-143e-21a9-ffd841b26bcb@cogentembedded.com>
Date:   Tue, 18 Jun 2019 12:28:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <1560799870-18956-3-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 17.06.2019 22:31, Vedang Patel wrote:

> Currently, etf expects a socket with SO_TXTIME option set for each packet
> it encounters. So, it will drop all other packets. But, in the future
> commits we are planning to add functionality which where tstamp value will
> be set by another qdisc. Also, some packets which are generated from within
> the kernel (e.g. ICMP packets) do not have any socket associated with them.
> 
> So, this commit adds support for skip_sock_check. When this option is set,
> etf will skip checking for a socket and other associated options for all
> skbs.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>   include/uapi/linux/pkt_sched.h |  1 +
>   net/sched/sch_etf.c            | 10 ++++++++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 8b2f993cbb77..69fc52e4d6bd 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -990,6 +990,7 @@ struct tc_etf_qopt {
>   	__u32 flags;
>   #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
>   #define TC_ETF_OFFLOAD_ON	BIT(1)
> +#define TC_ETF_SKIP_SOCK_CHECK  BIT(2)

   Please indent with a tab like above, not 2 spaces.

[...]

MBR, Sergei

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094F41D6C64
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgEQTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:35:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B7BC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:35:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f15so3293098plr.3
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HnACRB7yBSBzbsusMeI9HzSjWfNFuw80FEc+MmUld4w=;
        b=dKFsMIC3A3qcPEV5RsQteEcqGAMBQKzfQq0HC7rbCVhz1gxq5WntrRCqJUd3W5C7P5
         fcT9rcIhRbSvwNos1og/+WiYkofBB6cCedhRs1TchzxRDcDIqTQKpTD7duECCoimb7n2
         fC6YnfG2ttOwr4uwz0+Gp50R0HRaHCWJ8ah9g7Zoji+6tATSFof2o8J8SLEqoqTXQfmM
         1Ugo+cYo8cQ+kIvUbnZIZxLwo6VinAi91Egz/TdQbFnRvpeHye0/6yc/5KYv+R2aa85K
         CWEigyfKNtnKg7ix8iS/36AEO1Y+kNJ9h1LxMqvyJBPo23FZ7WYNpHJLvCU/sOXmEoZ2
         s1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HnACRB7yBSBzbsusMeI9HzSjWfNFuw80FEc+MmUld4w=;
        b=JuuTgBbG+qn4trhsmA/fRjQY+L9xwMPyW7ma2LI4tnOisS+9Slr8HT6j64GGj56O6Z
         eS4Cd3c5PE7p9HgNVNmvPkWP5NPykirhz4/DokOv5ytD4KK8DefVnaaGLRkgz6fMGHmQ
         zH5kOEyYicFvhtIm2UUxcoO9U9fM1wPty3FeD8vBCFFjvMnX38KHeIm6doGKEV5xTK1b
         7uB5UnczOeDrjdbrgs9Aj0ZhL8NCHF0S1yv6BWKtYtjclIrUqSWAB9HmInYtPojanAv3
         Q3l2ZvtbnLU+hR2Qzyg5RtSuw31vCjvkiB4bSrF7E+dfJr8yuclUJ0zLocse5KaTV7Db
         uQHg==
X-Gm-Message-State: AOAM533WvSiC13pl8GFokKQR0RXmMCIu9egEwRD7S51CTRBzx3kG/fmJ
        TqU5TkZOBpbdhvUzyO8WHJ0=
X-Google-Smtp-Source: ABdhPJwkJUeoekYWwUSucZ8lQBs4JuJJYAb+FuaAXccHMKyHjkWzYaIvz08Nb2sJrmTZ66GASNSeZg==
X-Received: by 2002:a17:902:bd09:: with SMTP id p9mr13496550pls.214.1589744155096;
        Sun, 17 May 2020 12:35:55 -0700 (PDT)
Received: from [192.168.1.2] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v5sm2293392pjy.4.2020.05.17.12.35.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 12:35:54 -0700 (PDT)
Subject: Re: [Patch net-next v2 1/2] net: partially revert dynamic lockdep key
 changes
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Taehee Yoo <ap420073@gmail.com>, Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
 <20200503052220.4536-2-xiyou.wangcong@gmail.com>
 <CAMArcTVQO8U_kU1EHxCDsjdfGn-y_keAQ3ScjJmPAeya+B8hHQ@mail.gmail.com>
 <CA+h21hqu=J5RH3UkYBt7=uxWNYvXWegFsbMnf3PoWyVHTpRPrQ@mail.gmail.com>
 <CAMArcTWW+HNqvkh+YwR-HCLMDTq7ckXxWtTyMWRyDLvgYXc7wg@mail.gmail.com>
 <CA+h21hoWpXN-apJXyDgOLM7eByXdcuzczdmX5jxoPk9wxJzaNA@mail.gmail.com>
 <CAM_iQpV-LGNp=jBvFKhz50FtcYUpU5eCY8L853oWRFVoSqUPjA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <405579c2-24da-d7e6-863f-f8ed58df878f@gmail.com>
Date:   Sun, 17 May 2020 12:35:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV-LGNp=jBvFKhz50FtcYUpU5eCY8L853oWRFVoSqUPjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/2020 11:42 AM, Cong Wang wrote:
> On Sat, May 16, 2020 at 9:53 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>> Thanks a lot for presenting the options. In general, xmit in DSA is
>> relatively simple and most of the time stateless. My stacked DSA setup
>> appears to work just fine with NETIF_F_LLTX, including the updating of
>> percpu counters. I'm not really sure if there's something in
>> particular to test?
>> Anyway, will you send a patch with NETIF_F_LLTX or should I do it? I
>> can do further testing if necessary.
> 
> If DSA is software based, there is a large chance it can be just
> using NETIF_F_LLTX, like you said.
> 
> Please do send a patch for this NETIF_F_LLTX. Note my patch
> simply reverts to the old code, this issue probably exists before it.

It transmits frames by calling dev_queue_xmit() after having assigned 
skb->dev to be pointing to the master network device, very much like 
what VLAN devices do for instance, so I believe setting NETIF_F_LLTX is 
fine here.
--
Florian


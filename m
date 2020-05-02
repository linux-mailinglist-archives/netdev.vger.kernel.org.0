Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C641C242D
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgEBIsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 04:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbgEBIsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 04:48:07 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632F7C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 01:48:07 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s10so6514116iln.11
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 01:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XQdMDcOjN+TpA8VFMRnm/ud788SF0zKch86ezKxC7x0=;
        b=UwbAwiSuBuZcdsXA2h6T1aAx+O+GMjOjSKeUg/uLGdjfKBo06E/N9g+A/HiI7hiIZz
         ESFXUX2gHzSSTtS1MXkj6plTo4fPL2Wjf7kwEvM7eW8vs8Pvz5mdsiHDoT/GEhlVeQLO
         RpiPD6G9r6nvPDHRPA8L/2B1/nMGrCQbTgeWwmZbbvvDANFgpt7AU03ffkM9XReFzZzl
         xzIHKn+/92T20F3dBVpFYlJGOHdP0Q+n9pxQ1gx4eWjD61Zbz+YtBfinun3vImfPqp1j
         GQBxgwEIn85k8GwOBoAkO39Lqy7a+HeckFeCX4cyJ8DmPg3ashwpmpp0M6vQoOw8Ge91
         cknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XQdMDcOjN+TpA8VFMRnm/ud788SF0zKch86ezKxC7x0=;
        b=VvPCb8MiSOgwqMfL/zWPxycwZ2AZyZoknDk6ZpUG2tCNzI7k/tBNw88aelRqRQDxqV
         BMSVxVNuuu6VTmoxZU4gd2rVXVTYy6/ckU4hq3tYGsczhXeix5B9qlZcqZpNo1ZiZR5I
         dK7bBRLw+2BhVRBvwMFlqYEJ3T0bpRHwgBw+wm3jxxnrXToUxnkwwxP2mZ7W5KWX4JYd
         DCiLu99jWt0up9iaQRKn6uy6ta4EJi8p13HW9OKxgvTNuAO87lk8NNyHfRemMKKYGI2H
         7X6U5CpfCEN05KZ8cfpIk0AuqJJFBOXCd3yP+M509bDmU3xSxK5+VhUfsbTHtGwq/XAr
         il/A==
X-Gm-Message-State: AGi0PuZl5143t1dwxXj+m/gKkuYLAFyGGcM3/VaZKXNg2uXzBHjkQQRR
        NZ+fRD1dZYxhhIzuDZWxQhmqNXQFleiUOA==
X-Google-Smtp-Source: APiQypJQDCGbN5rbwgM071xd1cgnZwwlkReVwW9/mWToLZbSQgRlLFEn1m/6W1LEjsjNXucqkhY46Q==
X-Received: by 2002:a92:cc12:: with SMTP id s18mr7615380ilp.113.1588409286588;
        Sat, 02 May 2020 01:48:06 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id b12sm2190097ilo.13.2020.05.02.01.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 01:48:05 -0700 (PDT)
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com>
Date:   Sat, 2 May 2020 04:48:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-30 11:53 p.m., Cong Wang wrote:
> When we tell kernel to dump filters from root (ffff:ffff),
> those filters on ingress (ffff:0000) are matched, but their
> true parents must be dumped as they are. However, kernel
> dumps just whatever we tell it, that is either ffff:ffff
> or ffff:0000:
> 
>   $ nl-cls-list --dev=dummy0 --parent=root
>   cls basic dev dummy0 id none parent root prio 49152 protocol ip match-all
>   cls basic dev dummy0 id :1 parent root prio 49152 protocol ip match-all
>   $ nl-cls-list --dev=dummy0 --parent=ffff:
>   cls basic dev dummy0 id none parent ffff: prio 49152 protocol ip match-all
>   cls basic dev dummy0 id :1 parent ffff: prio 49152 protocol ip match-all
> 
> This is confusing and misleading, more importantly this is
> a regression since 4.15, so the old behavior must be restored.
> 
> And, when tc filters are installed on a tc class, the parent
> should be the classid, rather than the qdisc handle. Commit
> edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
> removed the classid we save for filters, we can just restore
> this classid in tcf_block.
> 
> Steps to reproduce this:
>   ip li set dev dummy0 up
>   tc qd add dev dummy0 ingress
>   tc filter add dev dummy0 parent ffff: protocol arp basic action pass
>   tc filter show dev dummy0 root
> 
> Before this patch:
>   filter protocol arp pref 49152 basic
>   filter protocol arp pref 49152 basic handle 0x1
> 	action order 1: gact action pass
> 	 random type none pass val 0
> 	 index 1 ref 1 bind 1
> 
> After this patch:
>   filter parent ffff: protocol arp pref 49152 basic
>   filter parent ffff: protocol arp pref 49152 basic handle 0x1
>   	action order 1: gact action pass
>   	 random type none pass val 0
> 	 index 1 ref 1 bind 1

Note:
tc filter show dev dummy0 root
should not show that filter. OTOH,
tc filter show dev dummy0 parent ffff:
should.

root and ffff: are distinct/unique installation hooks.

cheers,
jamal

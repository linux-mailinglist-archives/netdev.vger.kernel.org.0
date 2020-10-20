Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1425D293362
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390924AbgJTC4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390881AbgJTC4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 22:56:42 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A81DC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:56:40 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p9so491120ilr.1
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 19:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TQFOv6SJd2Wnbr4qw/V7k/A5kE3c+OCoET50RFOq5ok=;
        b=VXQVJzuh3oedcli9Scl4RGJkn3d+Y9/ep95DZAbGOsuqpXUP8j+f3d2PZpppzx1zOF
         uyAkcNvbeujMryHVzXddpvY2yGUIGfZeYxvUkGmk5HBL0QWctoQji5wajGYNR7mfAWdj
         3Pmfu4M3Zginmc9tJVwifSoo3YhTmTYuG6ZMRH1O6ARL0XAXgXC1QUQM8o2dUCa4XNaS
         d8PEO7HCOOyzNanDqD73zHmm56Qup8Ud/iCI3FgjaAf2PGh+XYcqJpxeNzZgZQmuWSRi
         IUYTc+CmLvCqk4lTdkz554Dsh6oPxML8/x9V5OuyJOBGG2+3HHZTHPs4X6Z+soJBE6/y
         K3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TQFOv6SJd2Wnbr4qw/V7k/A5kE3c+OCoET50RFOq5ok=;
        b=agGbRfPZU5KzsWhOuuml6Na5uAk+H/2uzZd36Nyq6Jd00EBYGcsX9VtbWBTUwROhCU
         X9HyjmwYtB+jfGA98SO2pzuIOEUiZiCMK/WJuR3dfZtbKFPmtWGuGnJ0LHe6CI8ivdxz
         q4IPNtCCN3Gdu5VEVp+/rnZU4jaGx5HGSSsdG+t4jrhIg0PUYDqJNAC3dPtMfZOtEMcL
         E3IiGdgSp53Ni+f6D6OsX6rAxn2oXlhuwgk4nlLXWkdAyfVH+2r5IV0ZCp8JCg5KJgmY
         Jb2AsUkNhwByppB7IwK7FwU0+UbF8lvUE9WjMpyUVZm5S+GdCvUdk3Y10rE4wc96FXfH
         4gqg==
X-Gm-Message-State: AOAM5304xVHMdZ1cBA6+LbJf9bcF7GNbDeCRkHJq8FvA4lDoeDrMTrrN
        vnoschGfaQxLzLfpmY+r69SAyUlsZ5w=
X-Google-Smtp-Source: ABdhPJw2xjWFwkfSznBHOAUSF13WKAxWiHilV2v+Dh0pGTXc4OsGyO//t1G/uMRPcV4QI6tHs0zWkQ==
X-Received: by 2002:a05:6e02:10c3:: with SMTP id s3mr418956ilj.103.1603162599833;
        Mon, 19 Oct 2020 19:56:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id 128sm412702iow.50.2020.10.19.19.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 19:56:38 -0700 (PDT)
Subject: Re: [PATCH net-next v1] net: evaluate
 net.conf.ipvX.all.ignore_routes_with_linkdown
To:     Jakub Kicinski <kuba@kernel.org>,
        Vincent Bernat <vincent@bernat.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <gospo@cumulusnetworks.com>
References: <20201017125011.2655391-1-vincent@bernat.ch>
 <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c23018cd-b382-7b0b-8166-71b5d04969c4@gmail.com>
Date:   Mon, 19 Oct 2020 20:56:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 6:53 PM, Jakub Kicinski wrote:
> On Sat, 17 Oct 2020 14:50:11 +0200 Vincent Bernat wrote:
>> Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
>> ignores a route whose interface is down. It is provided as a
>> per-interface sysctl. However, while a "all" variant is exposed, it
>> was a noop since it was never evaluated. We use the usual "or" logic
>> for this kind of sysctls.
> 
>> Without this patch, the two last lines would fail on H1 (the one using
>> the "all" sysctl). With the patch, everything succeeds as expected.
>>
>> Also document the sysctl in `ip-sysctl.rst`.
>>
>> Fixes: 0eeb075fad73 ("net: ipv4 sysctl option to ignore routes when nexthop link is down")
>> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> 
> I'm not hearing any objections, but I have two questions:
>  - do you intend to merge it for 5.10 or 5.11? Because it has a fixes
>    tag, yet it's marked for net-next. If we put it in 5.10 it may get
>    pulled into stable immediately, knowing how things work lately.
>  - we have other sysctls that use IN_DEV_CONF_GET(), 
>    e.g. "proxy_arp_pvlan" should those also be converted?
> 

The inconsistency with 'all' has been a major pain. In this case, I
think it makes sense. Blindly changing all of them I suspect will lead
to trouble. It is something reviewers should keep an eye on as sysctl
settings get added.

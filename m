Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA33012A169
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 13:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfLXMpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 07:45:11 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:42429 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfLXMpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 07:45:10 -0500
Received: by mail-il1-f194.google.com with SMTP id t2so1154280ilq.9
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 04:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJ26XxNM0ryIUE+/G7NX1ZwCrYsp91qE/7xQGNuZz/I=;
        b=qtQI47EqArrIuVVn2/qE0McukIOhoh7Va14G4+AqNfswcBbPMyVKFpplRe/o2wZqHW
         9wVllrFJSxNR0PyGztSuXeCbhTDQN9rNphEbA1H0fYJO0PaRlRCgnsd4bQ+Jbkf/oHb7
         11ICjzrHQAYsD9VEViNSpTmRclQ8xZwGmgvOqyRuR4NlcuyVSOkBJb/olGxkNM+jCM9u
         DHIHTR43BneE8/m9eJzRvrM9DhMAs8K+FPf3otzRB9HNXqAxJ2MjdW5PHyJmFCqHCeOe
         7hK4hbmq7nBazEKMfbFhbhI8WB1DOOIDDWjqvlUlmfDRSMeweX27zOOJHwlmtGcnEPkD
         VTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eJ26XxNM0ryIUE+/G7NX1ZwCrYsp91qE/7xQGNuZz/I=;
        b=eiZmCmukbYJRF4SFm+hSJqHlYpSeWzmdxiKGHKLaQF/7RILtBcS+Nl5IOQlvcb8MD/
         7lz53lXQzUWSw+voS78s4/Cu0a8NdcC5A4N0KGIYJm+HvtJ1gN10xPPGvrYT5Q+cTzFu
         06NUEilRTlg0pnbENLhXXszBjZMvvIfqHWLoAMc7zpQkTC1I6PN+uzP1zyLbaZaoJacF
         j1JU9pagVe1NJv18ZttHc/vAW3wWeabB2dCb0FqPT8iBJMZgInn9H7Fn15dN4nuGcD9m
         4ik9hoLoFl6WAflKqf4kvvH51zMJALEh6Gq2BaMaKLQPVznum+xrnt7bUCmauCfMvtuO
         rEaQ==
X-Gm-Message-State: APjAAAX8RquHI0KQrIxjDHB6Pt5MhIc6rioUfgK942p8RYfrYptupCWx
        vwU2MVoHMT8DF+r3xXB/cXeB/w==
X-Google-Smtp-Source: APXvYqxo50Oi2Skm2DK8uSSjbCSdWnUOfPOZF45WBtbp/LORgxlZGiOm6B7negRFE2i4bd65snhwLQ==
X-Received: by 2002:a92:cb09:: with SMTP id s9mr31630919ilo.224.1577191510155;
        Tue, 24 Dec 2019 04:45:10 -0800 (PST)
Received: from [192.168.0.101] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id h4sm3916744ioq.40.2019.12.24.04.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 04:45:09 -0800 (PST)
Subject: Re: [PATCH net-next] net/sched: act_mirred: Ensure mac_len is pulled
 prior redirect to a non mac_header_xmit target device
To:     shmulik@metanetworks.com, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        shmulik.ladkani@gmail.com,
        Shmulik Ladkani <sladkani@proofpoint.com>
References: <20191223123336.13066-1-sladkani@proofpoint.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <c412ce79-1a37-963f-3633-2eba92ef05c4@mojatatu.com>
Date:   Tue, 24 Dec 2019 07:45:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223123336.13066-1-sladkani@proofpoint.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-23 7:33 a.m., shmulik@metanetworks.com wrote:
> From: Shmulik Ladkani <sladkani@proofpoint.com>
> 
> There's no skb_pull performed when a mirred action is set at egress of a
> mac device, with a target device/action that expects skb->data to point
> at the network header.
> 
> As a result, either the target device is errornously given an skb with
> data pointing to the mac (egress case), or the net stack receives the
> skb with data pointing to the mac (ingress case).
> 
> E.g:
>   # tc qdisc add dev eth9 root handle 1: prio
>   # tc filter add dev eth9 parent 1: prio 9 protocol ip handle 9 basic \
>     action mirred egress redirect dev tun0
> 
>   (tun0 is a tun device. result: tun0 errornously gets the eth header
>    instead of the iph)
> 

Shmulik - are you able to add a tdc testcase? It will be helpful to
catch future regressions.
I did basic testing i.e have an app reading tun0 from user space
then mirrored(not redirect) packets to tun0 for before and after
patch.

> Revise the push/pull logic of tcf_mirred_act() to not rely on the
> skb_at_tc_ingress() vs tcf_mirred_act_wants_ingress() comparison, as it
> does not cover all "pull" cases.
> 
> Instead, calculate whether the required action on the target device
> requires the data to point at the network header, and compare this to
> whether skb->data points to network header - and make the push/pull
> adjustments as necessary.
> 
> Signed-off-by: Shmulik Ladkani <sladkani@proofpoint.com>

Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

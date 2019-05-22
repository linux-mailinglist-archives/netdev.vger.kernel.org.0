Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66826909
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfEVRYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:24:55 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38514 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfEVRYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:24:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so3334780qtj.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z8tvaj+tYp7zsGVOYBIpry3gCoah7dPInM7J1NRMaYk=;
        b=w8wNrDbBR5X6KKWPVe/A+75iSnw0iCCODjYfpQuMb6ecj9+APciMWBY0H1x40GKeZv
         vyqVCvdi3OX4zeEI69rGhAd7XwVH4qp8CbbPtAJKd4pIbhdQokh3JxvNKoEdZihYBpiN
         PHvy2q8npEevwf0AbuWecw2+yq5PvqjoQlKneU5WLPQh8Izg8aOkYZ3iQyj2du8o/JIi
         xK/XzRvJ3YDgiT/BYKe4QVkIOG/A4S4Kqpsj+2K0nBt1UN+Z5ESZ4ExKeCLoEefLHo43
         gn2+DjG5gGc9GLL17l/Ix9/XW61X1tgtSaWSK0MiQ+dW8IYdtpvWlvhz2Hw00zbshc7d
         +ZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z8tvaj+tYp7zsGVOYBIpry3gCoah7dPInM7J1NRMaYk=;
        b=Rn7drUmxwOUcyGhSEllQcIpDU34O++wsSqztIP1J5cGXgaMLGs8ZAAiRfA//jXywI1
         pkEZbdYLfA1kOy+7/bFQzfCOLgBeJnqUQcKZqlf/AuOw2SpHDJ03mD926Zy0HSVrIWBJ
         y3gjqWB6H4iGS9I9drTB69IUc+JONuodp0Vx3wh6GfA4cqSXTywFGYXY1+vblSB7S/Sl
         wZZ/+3KBKkKgOFSDHfCKKSS8dHUF49r+/ThsK8+eBHy0h1FzEsvptucb2P2YpayAjM5g
         ePWVlVYdvD2GYkHZgfYPAWoHSZKEJFObkZicpPgG9f2u/8UQy99cb/EoKdBRvzx2I4GM
         Jfuw==
X-Gm-Message-State: APjAAAWl5xEkW1/DxYr3ZDEMmPZHEb2ddXM9CZEhmF2LwGNidq/8YNHi
        R/T+GWwKE3XeEOBaNVqirtna5A==
X-Google-Smtp-Source: APXvYqxIHbArUn3+LQMsql5lCvy6NPo1melgC8n2JSsl1qfKBWhdMU/7OLqbiEDT8k6BD+SKGNgY6A==
X-Received: by 2002:a0c:9e58:: with SMTP id z24mr18407274qve.214.1558545894591;
        Wed, 22 May 2019 10:24:54 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id j58sm11537550qtk.33.2019.05.22.10.24.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 10:24:53 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Vlad Buslov <vladbu@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Lucas Bates <lucasb@mojatatu.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
 <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
 <17cf3488-6f17-cb59-42a3-6b73f7a0091e@solarflare.com>
 <b4b5e1e7-ebef-5d20-67b6-a3324e886942@mojatatu.com>
 <d70ed72f-69db-dfd0-3c0d-42728dbf45c7@solarflare.com>
 <e0603687-272d-6d41-1c3a-9ea14aa8cfad@mojatatu.com>
 <b1a0d4b5-7262-a5a0-182d-54778f9d176a@mojatatu.com>
 <vbfef4slz5k.fsf@mellanox.com> <vbfblzuedcq.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b147865f-5224-b66b-2824-8c1c8986900f@mojatatu.com>
Date:   Wed, 22 May 2019 13:24:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <vbfblzuedcq.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-22 11:08 a.m., Vlad Buslov wrote:
> 
> On Tue 21 May 2019 at 16:23, Vlad Buslov <vladbu@mellanox.com> wrote:

> 
> It seems that culprit in this case is tc_action->order field. It is used
> as nla attrtype when dumping actions. Initially it is set according to
> ordering of actions of filter that creates them. However, it is
> overwritten in tca_action_gd() each time action is dumped through action
> API (according to action position in tb array) and when new filter is
> attached to shared action (according to action order on the filter).
> With this we have another way to reproduce the bug:
> 
> sudo tc qdisc add dev lo ingress
> 
> #shared action is the first action (order 1)
> sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
> match ip dst 127.0.0.8/32 flowid 1:10 \
> action drop index 104 \
> action vlan push id 100 protocol 802.1q
> 
> #shared action is the the second action (order 2)
> sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
> match ip dst 127.0.0.10/32 flowid 1:10 \
> action vlan push id 101 protocol 802.1q \
> action drop index 104
> 
> # Now action is only visible on one filter
> sudo tc -s filter ls dev lo parent ffff: protocol ip
> 

Ok, thanks for chasing this. A test case i had in mind is to
maybe have 3 actions. Add the drop in the middle for one
and at the begging for another and see if they are visible
with the patch.
If you dont have time I can test maybe AM tommorow.

> The usage of tc_action->order is inherently incorrect for shared actions
> and I don't really understand the reason for using it in first place.
> I'm sending RFC patch that fixes the issue by just using action position
> in tb array for attrtype instead of order field, and it seems to solve
> both issues for me. Please check it out to verify that I'm not breaking
> something. Also, please advise on "fixes" tag since this problem doesn't
> seem to be directly caused by my act API refactoring.
> 

I dont know when this broke then.
Seems to be working correctly on the machine i am right now
(4.4) but broken on 4.19. So somewhere in between things broke.
I dont have other kernels to compare at the moment.

cheers,
jamal

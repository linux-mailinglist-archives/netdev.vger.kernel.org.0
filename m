Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661AC24F1B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfEUMqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 08:46:14 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39087 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfEUMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 08:46:14 -0400
Received: by mail-qt1-f195.google.com with SMTP id y42so20260285qtk.6
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 05:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=4meJroJoQfpvCvcpmMqgZ0OtGGf/R3Ivp0naS+Yel3Q=;
        b=jc+ZZ8dHAOg5/OKKag/9MJFMxm0FpUxEiw9/l1M2CNCaKnaL8U6RIoqPvXWNQhBhXT
         mSlE1X+R7SKuif1nxChQFD1md0eGIs9H0TAhw/RVMvIQP7EWfyH9lfaMjsnhcUGb8f7g
         EBrrbp11dss8QzySXC2xqqp63gbqh9+SXUlXEYtKK0JVFIYrZsSI+QK71k97593WOI4a
         sRynDeoueA6kdHYoEgFCohySXIO+hefZWxhuTVhvXpnns2OzoOgrzYrdTdibS89XrJ5G
         3WPAGI5QQtcvIKz6ZQKfIksdV1d5+4q5BtPFQZ2XPJBbMjA6kQLl+kUUh25hC1Jk1khT
         tYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=4meJroJoQfpvCvcpmMqgZ0OtGGf/R3Ivp0naS+Yel3Q=;
        b=ZfQGCWEcWaIZ7DT3Dhxt7rJvxtiABKQ2MS9JkFoW+/LpB6g9paCgMb9cM0JiQ1vwPF
         mx4cdzHV6dbhanJHksPiAQfV2xLT96/RbW2mTSvwzaUG38Vazh799ZU/vVCr84iKD3bY
         q6qJcCFktwSSgcJOF82UxNZtxgO1S2vYZz8hBvZQ1ttS/VpRW9ckCEUhD1eIXea2s7YT
         88dVENkw/7AKHNFQ8OIwAVj2KXEgeu5qMXZJ2ZwlSNk6M8OzIov/kwKgtIYrrB5jHJAX
         simK4azpjyXZsI28sKx/1gwQ/H3I687ldXtHHALnoIKzCp5xVm8UY/4olvARTImglXnn
         /sng==
X-Gm-Message-State: APjAAAXldnhxdL96fAbUPndCr2CfoKeWyRdwnAKc6MJwBj69NdHTjXPB
        8mBBOXZpJbaZqD84WAm7eYAUWw==
X-Google-Smtp-Source: APXvYqx4NjBjQ/LgDlUzS7eMJX18QAmHvg32V1bb/wF2/AZUH+KN42qRt8UvSjSXsOETjArqqkVFsQ==
X-Received: by 2002:a0c:d917:: with SMTP id p23mr50975136qvj.162.1558442773383;
        Tue, 21 May 2019 05:46:13 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id x30sm13337698qtx.35.2019.05.21.05.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 05:46:11 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Vlad Buslov <vladbu@mellanox.com>,
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
Message-ID: <b1a0d4b5-7262-a5a0-182d-54778f9d176a@mojatatu.com>
Date:   Tue, 21 May 2019 08:46:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e0603687-272d-6d41-1c3a-9ea14aa8cfad@mojatatu.com>
Content-Type: multipart/mixed;
 boundary="------------CD4011A5DF84DDE204190860"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------CD4011A5DF84DDE204190860
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2019-05-20 5:12 p.m., Jamal Hadi Salim wrote:
> On 2019-05-20 2:36 p.m., Edward Cree wrote:
>> On 20/05/2019 17:29, Jamal Hadi Salim wrote:

> Ok, so the "get" does it. Will try to reproduce when i get some
> cycles. Meantime CCing Cong and Vlad.
> 


I have reproduced it in a simpler setup. See attached. Vlad this is
likely from your changes. Sorry no cycles to dig more.
Lucas, can we add this to the testcases?


cheers,
jamal

--------------CD4011A5DF84DDE204190860
Content-Type: text/plain; charset=UTF-8;
 name="ed-shared-actions"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ed-shared-actions"

CnN1ZG8gdGMgcWRpc2MgZGVsIGRldiBsbyBpbmdyZXNzCnN1ZG8gdGMgcWRpc2MgYWRkIGRl
diBsbyBpbmdyZXNzCgpzdWRvIHRjIGZpbHRlciBhZGQgZGV2IGxvIHBhcmVudCBmZmZmOiBw
cm90b2NvbCBpcCBwcmlvIDggdTMyIFwKbWF0Y2ggaXAgZHN0IDEyNy4wLjAuOC8zMiBmbG93
aWQgMToxMCBcCmFjdGlvbiB2bGFuIHB1c2ggaWQgMTAwIHByb3RvY29sIDgwMi4xcSBcCmFj
dGlvbiBkcm9wIGluZGV4IDEwNAoKc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiBsbyBwYXJlbnQg
ZmZmZjogcHJvdG9jb2wgaXAgcHJpbyA4IHUzMiBcCm1hdGNoIGlwIGRzdCAxMjcuMC4wLjEw
LzMyIGZsb3dpZCAxOjEwIFwKYWN0aW9uIHZsYW4gcHVzaCBpZCAxMDEgcHJvdG9jb2wgODAy
LjFxIFwKYWN0aW9uIGRyb3AgaW5kZXggMTA0CgojCnN1ZG8gdGMgLXMgZmlsdGVyIGxzIGRl
diBsbyBwYXJlbnQgZmZmZjogcHJvdG9jb2wgaXAKCiN0aGlzIHdpbGwgbm93IGRlbGV0ZSBh
Y3Rpb24gZ2FjdCBpbmRleCAxMDQoZHJvcCkgZnJvbSBkaXNwbGF5CnN1ZG8gdGMgLXMgYWN0
aW9ucyBnZXQgYWN0aW9uIGRyb3AgaW5kZXggMTA0CgpzdWRvIHRjIC1zIGZpbHRlciBscyBk
ZXYgbG8gcGFyZW50IGZmZmY6IHByb3RvY29sIGlwCgojQnV0IHlvdSBjYW4gc3RpbGwgc2Vl
IGl0IGlmIHlvdSBkbyB0aGlzOgpzdWRvIHRjIC1zIGFjdGlvbnMgZ2V0IGFjdGlvbiBkcm9w
IGluZGV4IDEwNAoK
--------------CD4011A5DF84DDE204190860--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4862C9C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfGHXWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:22:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34832 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfGHXWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:22:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so9043119plp.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 16:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=mDxId9ZiBuMVLjAv5HztWv16q5h1GghOeYn1JkLmXgQ=;
        b=AG6BcVZn/yo8vkNdlGtGQiYENuAS9kwqKyuKTFi7aO3UwjLTWsd5HJYI4sT2UV9MUS
         FXMp8TwW+ksN3fwK89vhEAP5VoScdvF2Xle1JB75zNcMmQ7PwOcaGuxzSW3b6hcAUc8R
         +vc2R/S8nmn480FqsMsrolxEmIsZM0BZPHF5CeYIpKMM50QkaPP64KOsXeCUc8g8TTxb
         3NeNjmL6ybEzlmnMkClj8hDcy8081ewbCwtr6vMWvUjrUdi0coSf/S+gzhxtRKx4t+Vm
         Atw200CuK3wLvCIFhT66q1vnse/tnm0igZhTJiyDBV969Oa41UwVX1K9I00plngsWvDE
         puAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mDxId9ZiBuMVLjAv5HztWv16q5h1GghOeYn1JkLmXgQ=;
        b=c3UNYe9klZlAi+fzZP4h2t06R1yTVQswz+dsa6XpSGQo5gKolkHF94X/fy++i/ugae
         ENzX8SVTqeK+5GPbs81Z1k5Mr3DWWotRVeu0TkDIi94BCLRR9qv2m2IENGc0nd22e660
         LjaMKYEmvVOlkt+VEtIp/bwlNZV7gN//McJoOm++7D69IB6MrQNqmLkB+R1zHuUmUYIs
         XA6rs3Whkx8Hra/xCpqPMpgRYFPgHSkcFZplUX7KKQBCNvbriZQJXju+ZVmn1KVNgBxs
         Rwa4YQjttEw5/RHFW3iLET/rRZ324k8gniioCWMQ1xnD8c9XpZNmn93oBP8miUeApY8q
         Xjbg==
X-Gm-Message-State: APjAAAWUAD/OClBD2N9+hJHp+GP0yZcEcLo39k/3L9LN4iU213/hg0/2
        nB/KLnfSMFFtzk6wWMFy5Ic=
X-Google-Smtp-Source: APXvYqxe0EQko9x3WmQctISgx93aEa2CKJzUrE48I6nF3/30CfgJLNk2ogq3CYKNlrlRZ1HontOUTQ==
X-Received: by 2002:a17:902:8547:: with SMTP id d7mr28622467plo.171.1562628168068;
        Mon, 08 Jul 2019 16:22:48 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.142.179])
        by smtp.gmail.com with ESMTPSA id j6sm586142pjd.19.2019.07.08.16.22.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 16:22:47 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: do not update
 max_headroom if new headroom is equal to old headroom
From:   Gregory Rose <gvrose8192@gmail.com>
To:     David Miller <davem@davemloft.net>, ap420073@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Pravin Shelar <pshelar@ovn.org>
References: <20190705160809.5202-1-ap420073@gmail.com>
 <20190708.160804.2026506853635876959.davem@davemloft.net>
 <87bfb355-9ddf-c27b-c160-b3028a945a22@gmail.com>
Message-ID: <b40f4a39-8de4-482c-2ee8-66adf5c606be@gmail.com>
Date:   Mon, 8 Jul 2019 16:22:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87bfb355-9ddf-c27b-c160-b3028a945a22@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/2019 4:18 PM, Gregory Rose wrote:
> On 7/8/2019 4:08 PM, David Miller wrote:
>> From: Taehee Yoo <ap420073@gmail.com>
>> Date: Sat,  6 Jul 2019 01:08:09 +0900
>>
>>> When a vport is deleted, the maximum headroom size would be changed.
>>> If the vport which has the largest headroom is deleted,
>>> the new max_headroom would be set.
>>> But, if the new headroom size is equal to the old headroom size,
>>> updating routine is unnecessary.
>>>
>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> I'm not so sure about the logic here and I'd therefore like an OVS 
>> expert
>> to review this.
>
> I'll review and test it and get back.  Pravin may have input as well.
>

Err, adding Pravin.

- Greg

> Thanks,
>
> - Greg
>
>> Thanks.
>> _______________________________________________
>> dev mailing list
>> dev@openvswitch.org
>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>


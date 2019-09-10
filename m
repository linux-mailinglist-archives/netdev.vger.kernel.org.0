Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0EDAE25F
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 04:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392687AbfIJCgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 22:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbfIJCgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 22:36:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF9DA309BF06;
        Tue, 10 Sep 2019 02:36:34 +0000 (UTC)
Received: from [10.72.12.185] (ovpn-12-185.pek2.redhat.com [10.72.12.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A63560BE2;
        Tue, 10 Sep 2019 02:36:32 +0000 (UTC)
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        eric dumazet <eric.dumazet@gmail.com>,
        xiyou wangcong <xiyou.wangcong@gmail.com>,
        weiyongjun1@huawei.com
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
 <5D5FB3B6.5080800@huawei.com>
 <1be732b2-6eda-4ea6-772d-780694557910@redhat.com>
 <5D6DC5BF.5020009@huawei.com>
 <4a5d84b7-f3cb-c4e1-d6fe-28d186a551ee@redhat.com>
 <5D6DFD57.7020905@huawei.com>
 <71e17457-d4bc-15be-dfb3-d0a977fd7556@redhat.com>
 <5D6E17A7.1020102@huawei.com>
 <314835944.12221643.1567507811976.JavaMail.zimbra@redhat.com>
 <5D706CE4.3000103@huawei.com>
 <542aa2c2-fd54-1e6c-f2f4-46fcc2e6f6ee@redhat.com>
 <5D770AF6.1060902@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f42d04fb-ac3e-8429-461c-f9b238d438b5@redhat.com>
Date:   Tue, 10 Sep 2019 10:36:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5D770AF6.1060902@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 10 Sep 2019 02:36:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/10 上午10:31, Yang Yingliang wrote:
>>>
>>>               if (!(tun->flags & IFF_PERSIST) &&
>>> -                tun->dev->reg_state == NETREG_REGISTERED)
>>> +                tun->dev->reg_state == NETREG_REGISTERED) {
>>> +                tun->flags &= ~TUN_DEV_REGISTERED;
>>
>> As I said for previous versions. It's not good that try to invent new
>> internal state like this, and you need carefully to deal with the
>> synchronization, it could be lock or barriers. Consider the
>> synchronization of tun is already complex, let's better try to avoid
>> adding more but using exist mechanism, e.g pointer publishing through 
>> RCU.
> OK, need I post a V4 by using the diff file you sent ? 


Yes, please.

Thanks


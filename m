Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75B221AF22
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgGJGG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:06:59 -0400
Received: from out0-140.mail.aliyun.com ([140.205.0.140]:60120 "EHLO
        out0-140.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJGG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594361216; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=WTPZ8dDMHazs7JzjFaIn5JEdV9OZsGpyoyQ4tedvv/g=;
        b=TmtBcuE26Ewd3dpSeJC1lihDvDnWDb+HL4WXHnWC6OBOxEWSRrR8bqYhM3UzCmTUr6el17N6MRA7SNupcoAHOsE7x/hV6PVYS7n6RUphi1oUkJYKmjOrXjb2Xgff0s32G3BVIlDRgrYwKy6C0s9EtdPjIjVuG071Y+GppDUNQDw=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03308;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I.JPxeH_1594361214;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I.JPxeH_1594361214)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Jul 2020 14:06:55 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com>
 <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com>
 <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com>
 <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
 <CAM_iQpWAHdws4Zu=qD1g5E3tOShefQwK8Mbf9YNCiR2OvHA-Kw@mail.gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <f26ce874-dd33-5283-62ff-334c0c611d09@alibaba-inc.com>
Date:   Fri, 10 Jul 2020 14:06:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWAHdws4Zu=qD1g5E3tOShefQwK8Mbf9YNCiR2OvHA-Kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/9/20 10:20 PM, Cong Wang wrote:
> On Thu, Jul 9, 2020 at 10:04 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> IOW, without these *additional* efforts, it is broken in terms of
>> out-of-order.
>>
> 
> Take a look at fq_codel, it provides a hash function for flow classification,
> fq_codel_hash(), as default, thus its default configuration does not
> have such issues. So, you probably want to provide such a hash
> function too instead of a default class.
> 
If I understand this code correctly, this socket hash value identifies a flow. Essentially it serves the same purpose as socket priority. In this patch, we use a similar classification method like htb, but without filters.

We could provide a hash function, but I'm a bit confused about the problem we are trying to solve.

Thanks,
- Xiangning


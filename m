Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9E4BE6D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfFSQj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:39:56 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56916 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbfFSQj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:39:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TUccqUw_1560962390;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TUccqUw_1560962390)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jun 2019 00:39:52 +0800
Subject: Re: [PATCH] mm: mempolicy: handle vma with unmovable pages mapped
 correctly in mbind
To:     Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc:     akpm@linux-foundation.org, mgorman@techsingularity.net,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <1560797290-42267-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190618130253.GH3318@dhcp22.suse.cz>
 <cf33b724-fdd5-58e3-c06a-1bc563525311@linux.alibaba.com>
 <2c30d86f-43e4-f43c-411d-c916fb1de44e@suse.cz>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <68b67faf-d1c3-bc36-3db4-c86c6dfd8f11@linux.alibaba.com>
Date:   Wed, 19 Jun 2019 09:39:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <2c30d86f-43e4-f43c-411d-c916fb1de44e@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/19 1:18 AM, Vlastimil Babka wrote:
> On 6/18/19 7:06 PM, Yang Shi wrote:
>> The BUG_ON was removed by commit
>> d44d363f65780f2ac2ec672164555af54896d40d ("mm: don't assume anonymous
>> pages have SwapBacked flag") since 4.12.
> Perhaps that commit should be sent to stable@ ? Although with
> VM_BUG_ON() this is less critical than plain BUG_ON().

I don't think we have to. I agree it is less critical,  VM_DEBUG should 
be not enabled for production environment.

And, it doesn't actually break anything since split_huge_page would just 
return error, and those unmovable pages are silently ignored by isolate.



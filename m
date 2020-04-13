Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3E41A62DF
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDMGEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgDMGEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:04:52 -0400
Received: from fgont.go6lab.si (fgont.go6lab.si [91.239.96.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D6CC0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 23:04:51 -0700 (PDT)
Received: from [192.168.0.10] (unknown [181.45.84.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by fgont.go6lab.si (Postfix) with ESMTPSA id 8A743804D5;
        Mon, 13 Apr 2020 08:04:45 +0200 (CEST)
Subject: Re: [PATCH net-next] Implement draft-ietf-6man-rfc4941bis
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20200408104458.GA15473@archlinux-current.localdomain>
 <20200412222205.04cb37cc@hermes.lan>
From:   Fernando Gont <fgont@si6networks.com>
Message-ID: <2999c2d5-77f2-c69f-7fab-d5b01b30a65f@si6networks.com>
Date:   Mon, 13 Apr 2020 03:04:29 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200412222205.04cb37cc@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/4/20 02:22, Stephen Hemminger wrote:
> On Wed, 8 Apr 2020 07:44:58 -0300
> Fernando Gont <fgont@si6networks.com> wrote:
> 
>> Implement the upcoming rev of RFC4941 (IPv6 temporary addresses):
>> https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-09
>>
[...]
>>   
>>   temp_valid_lft - INTEGER
>>   	valid lifetime (in seconds) for temporary addresses.
>> -	Default: 604800 (7 days)
>> +	Default: 172800 (2 days)
> 
> You can't change defaults for existing users without a really good
> argument.

The number of extra addresses you get when the Valid Lifetime is 7 days 
tends to exacerbate the stress caused on network elements/devices. There 
are references in the I-D.

Additionally, the motivation of temporary addresses is indeed privacy 
and reduced exposure. With a default VL of 7 days, and address that 
becomes revealed is reachable for one whole week. That's not very 
"temporary" as the name would imply.

The only use case for a VL of 7 days could be some application that is 
expecting to have long lived connections. But if you want to have a long 
lived connections, you probably shouldn't be using a temporary address.

And even more in the era of mobile devices, I'd argue that general 
applications should be prepared and robust to address changes (nodes 
swaps wifi <-> 4G, etc.)

This is, of the top of my head, the reason why we decided to modify the 
default valid lifetime in the upcoming revision of the standard.

Thoughts?

Thanks,
-- 
Fernando Gont
SI6 Networks
e-mail: fgont@si6networks.com
PGP Fingerprint: 6666 31C6 D484 63B2 8FB1 E3C4 AE25 0D55 1D4E 7492





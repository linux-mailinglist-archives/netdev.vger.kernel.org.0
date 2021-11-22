Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC7845955B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 20:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhKVTOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 14:14:04 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:58227 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbhKVTOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 14:14:02 -0500
Received: from [192.168.1.18] ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id pEiKmh80URLGppEiKmZETn; Mon, 22 Nov 2021 20:10:54 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 22 Nov 2021 20:10:54 +0100
X-ME-IP: 86.243.171.122
Subject: Re: [PATCH] net-sysfs: Slightly optimize 'xps_queue_show()'
To:     Xin Long <lucien.xin@gmail.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        atenart@kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <498b1a0a7a0cba019c9d95693cd489827168b79e.1637517554.git.christophe.jaillet@wanadoo.fr>
 <CADvbK_du8Oya986Ae9YJ+w5kkexE5S5mvAb+DWod-1_F85=sgA@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <27107a39-3073-4995-194d-5caa330d1313@wanadoo.fr>
Date:   Mon, 22 Nov 2021 20:10:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_du8Oya986Ae9YJ+w5kkexE5S5mvAb+DWod-1_F85=sgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 22/11/2021 à 16:23, Xin Long a écrit :
> On Sun, Nov 21, 2021 at 2:38 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> The 'mask' bitmap is local to this function. So the non-atomic
>> '__set_bit()' can be used to save a few cycles.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   net/core/net-sysfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>> index 9c01c642cf9e..3be3f4a6add3 100644
>> --- a/net/core/net-sysfs.c
>> +++ b/net/core/net-sysfs.c
>> @@ -1452,7 +1452,7 @@ static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
>>
>>                  for (i = map->len; i--;) {
>>                          if (map->queues[i] == index) {
>> -                               set_bit(j, mask);
>> +                               __set_bit(j, mask);
>>                                  break;
>>                          }
>>                  }
>> --
>> 2.30.2
>>
> The similar optimization can seem to be done in br_vlan.c and br_if.c as well.
> 

Hi,

br_if.c should be fixed in cc0be1ad686f.

br_vlan.c was not spotted by my heuristic (a set of grep, while looking 
at something else). So, thanks for your feedback.

Feel free to propose a patch for it, it was not part of my todo list :)

If you prefer, I can also send a patch. Let me know.

CJ

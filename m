Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7267F35410C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbhDEKCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:02:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56891 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhDEKCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:02:39 -0400
Received: from fsav405.sakura.ne.jp (fsav405.sakura.ne.jp [133.242.250.104])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 135A248p005838;
        Mon, 5 Apr 2021 19:02:04 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav405.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav405.sakura.ne.jp);
 Mon, 05 Apr 2021 19:02:04 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav405.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 135A2398005804
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 5 Apr 2021 19:02:04 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] batman-adv: initialize "struct
 batadv_tvlv_tt_vlan_data"->reserved field
To:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <6915766.LLSpSeZOKX@sven-l14>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <b98babbe-eb85-2b78-d7a4-d3ac6cda5e5b@i-love.sakura.ne.jp>
Date:   Mon, 5 Apr 2021 19:02:02 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <6915766.LLSpSeZOKX@sven-l14>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/04/05 16:39, Sven Eckelmann wrote:
> On Monday, 5 April 2021 07:33:06 CEST Tetsuo Handa wrote:
> [...]
>> ---
>>  net/batman-adv/translation-table.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
>> index f8761281aab0..eb82576557e6 100644
>> --- a/net/batman-adv/translation-table.c
>> +++ b/net/batman-adv/translation-table.c
>> @@ -973,6 +973,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
>>  
>>  		tt_vlan->vid = htons(vlan->vid);
>>  		tt_vlan->crc = htonl(vlan->tt.crc);
>> +		tt_vlan->reserved = 0;
>>  
>>  		tt_vlan++;
>>  	}
>>
> 
> Thanks but this patch is incomplete. Please also fix 
> batadv_tt_prepare_tvlv_global_data (exactly the same way)

Indeed. Hmm, batadv_send_tt_request() is already using kzalloc().
Which approach ( "->reserved = 0" or "kzalloc()") do you prefer for
batadv_tt_prepare_tvlv_global_data() and batadv_tt_prepare_tvlv_local_data() ?

> 
> Kind regards,
> 	Sven
> 

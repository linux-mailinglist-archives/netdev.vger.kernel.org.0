Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DA691661
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 02:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjBJBwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 20:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBJBwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 20:52:34 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A4E25BB2;
        Thu,  9 Feb 2023 17:52:33 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so4140955pjw.2;
        Thu, 09 Feb 2023 17:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4SlnQn3CdhUOkSGoYYPMyd5KD5RW0eE5v9UtrQlEVJE=;
        b=khDLgrvBr6bJB4RGEFHQLc7GXqFL3YRXp9XWfgE9TTTT41/sZhP/rmQmq7fciIuF1G
         X/WBtpyeLARY1mgBvbfPs6xoHMzc3mhQcPNT6Ai7gQXQNivQoXZ4uFXA0QwPRP2DqnRm
         bIA4RfNOP1eNUC7DEsVcT8uAPZ5jVJfOAi4/HgJLioJH/NzFxtoMMD8j/Wbs7xIImvzl
         u+4+ORuqdMEof9Q07yItKHu+AG5jZ9+LjxsYtVIzICW9Kz01uen3/68GG7bj+bk8eRK/
         09Urk9bdngcHQBimXu59LJfN3jbAqA3/V39R7FczZ8ItgtO5894wOf4erD8urKOqRd/i
         GNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4SlnQn3CdhUOkSGoYYPMyd5KD5RW0eE5v9UtrQlEVJE=;
        b=LVm7rVj5PYuFp6aQDyK+v+6X/Jczs4XypuaciJnBd8AMeK9fA0o+VP/rWdChuU7fHj
         syEA3DC/5FmqiA0PoW2aasSiOa+MZ9etCde29zz6ldbczlVol+v0byDZMyJCBUuiD1lD
         xG7UUtxZJ1W9BhqV4S6RruQerd9qBgApS/uuZPSlpifn+i/Cu0c3aiXZeGvT0NqYo9x9
         pwmxtbOWP89BTj59hicJYORTUWfDZm3uS+1HvPwhoqaCTi0aB9L/W2iW0StvZagdzcoO
         VkjvSUtYrkpBC2pxN85Lei7+RYjd9FIepqlPk+i2AuN+c2dYGeNLZDQs2F3xV4C/O/2a
         HVFA==
X-Gm-Message-State: AO0yUKXUGUARbmTw2g6iS/CbrnSPZloZ234uMg3F1KMelZ0JjslKfSof
        XaB7PwT8F210uo/4JiUxVUk=
X-Google-Smtp-Source: AK7set/0IRLg9Oezi94q8GYKTUGMKYbzqLK82yKAabHHgZI+ga5kaHvlg4pEqTDMNx4/rTdR7VjqvQ==
X-Received: by 2002:a17:902:e5d1:b0:196:3cab:58cf with SMTP id u17-20020a170902e5d100b001963cab58cfmr13959311plf.4.1675993952856;
        Thu, 09 Feb 2023 17:52:32 -0800 (PST)
Received: from [192.168.50.247] ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902d34500b0019655211783sm2139166plk.306.2023.02.09.17.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 17:52:32 -0800 (PST)
Message-ID: <da1eae25-1df0-36f0-3d4f-12ba52f1f62f@gmail.com>
Date:   Fri, 10 Feb 2023 09:52:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [ovs-dev] [PATCH v2] net: openvswitch: fix possible memory leak
 in ovs_meter_cmd_set()
To:     Eelco Chaudron <echaudro@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230209093240.14685-1-hbh25y@gmail.com>
 <Y+TR3sB4X5Yt79Tx@corigine.com>
 <5C180FB7-5EAA-4AEB-BD69-9522F2CD73B5@redhat.com>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <5C180FB7-5EAA-4AEB-BD69-9522F2CD73B5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/2023 21:42, Eelco Chaudron wrote:
> 
> 
> On 9 Feb 2023, at 11:58, Simon Horman wrote:
> 
>> On Thu, Feb 09, 2023 at 05:32:40PM +0800, Hangyu Hua wrote:
>>> old_meter needs to be free after it is detached regardless of whether
>>> the new meter is successfully attached.
>>>
>>> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>> ---
>>>
>>> v2: use goto label and free old_meter outside of ovs lock.
>>>
>>>   net/openvswitch/meter.c | 12 +++++++++---
>>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
>>> index 6e38f68f88c2..9b680f0894f1 100644
>>> --- a/net/openvswitch/meter.c
>>> +++ b/net/openvswitch/meter.c
>>> @@ -417,6 +417,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>>>   	int err;
>>>   	u32 meter_id;
>>>   	bool failed;
>>> +	bool locked = true;
>>>
>>>   	if (!a[OVS_METER_ATTR_ID])
>>>   		return -EINVAL;
>>> @@ -448,11 +449,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>>>   		goto exit_unlock;
>>>
>>>   	err = attach_meter(meter_tbl, meter);
>>> -	if (err)
>>> -		goto exit_unlock;
>>>
>>>   	ovs_unlock();
>>>
>>> +	if (err) {
>>> +		locked = false;
>>> +		goto exit_free_old_meter;
>>> +	}
>>>   	/* Build response with the meter_id and stats from
>>>   	 * the old meter, if any.
>>>   	 */
>>> @@ -472,8 +475,11 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>>>   	genlmsg_end(reply, ovs_reply_header);
>>>   	return genlmsg_reply(reply, info);
>>>
>>> +exit_free_old_meter:
>>> +	ovs_meter_free(old_meter);
>>>   exit_unlock:
>>> -	ovs_unlock();
>>> +	if (locked)
>>> +		ovs_unlock();
>>
>> I see where you are going here, but is the complexity of the
>> locked variable worth the benefit of freeing old_meter outside
>> the lock?
> 
> Looking at the error path, I would agree with Simon, and just add an “exit_free_old_meter” label as suggested in v1 and keep the lock in place to make the error path more straightforward.
> 
> //Eelco

I see. I will send a v3 later.

Thanks,
Hangyu

> 
>>>   	nlmsg_free(reply);
>>>   exit_free_meter:
>>>   	kfree(meter);
>>> -- 
>>> 2.34.1
>>>
>>> _______________________________________________
>>> dev mailing list
>>> dev@openvswitch.org
>>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>>>
> 

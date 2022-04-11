Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58424FC24B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348589AbiDKQaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348584AbiDKQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:30:13 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84F0F2E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:27:56 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m33-20020a05600c3b2100b0038ec0218103so1212005wms.3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=J1PWqq/xTR7b2tQKtqVAcxTw9gPiI1MkXihtgOeP+q0=;
        b=jj2qRBTrtWmJumqC4yHwHVZTWNZuP0m17c580tnITLxBJYzHP6i9L8RLJYeLq7fVy+
         mRmjJ3sw7O9AzLKgs8pjljNni6NsW8EeaVgv96IvcUNhheuVx0A6VLl7+kqbpGhQiUtV
         nerGIl7pMh639hMZN9FnNdSw9YX0zQE4EKPaxI4kzAsiBthJWhhcRQQHWpTt63INsg6K
         6LHzuiUP2/nXM3+SQddGtwPoALo1EsFjYZ9DDNDk6OnReu6XH8eDseInOMiiht3dBu5m
         UkDtQlHKkURS3OjWO88Ry7M19fdS5c5bXR9RLZL138n3EVkgDY5AfnUVjTNb5jTeUYdS
         Vi5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=J1PWqq/xTR7b2tQKtqVAcxTw9gPiI1MkXihtgOeP+q0=;
        b=KP/iQYBlD+arnaquyN1BINytUY0/5Y+9rbeJemZPYFU/KhLNPRPy1TxNwNFSF7c37D
         nygfEqug6/tLRqNGTuYqUusqlwFbkJJjAgJwV8otgGHQL0I40cIIDysgg0IQxu6H00O7
         KWhIOmhpxqt/RQGGixrgMHYv0q3eqNeLmd7BL5tvwOhVOgODGZfXWTf/jKx6OS3CbAva
         A+MoH6WW40eDKj0T1IfcRpTBW6Hz+o4wR1k/CnZBcFTadpAKh96cbdQah+NidWehZeEb
         MhLdt2tcLCOQMGHzTSc2Vq9EDG51jwDeGP87uy9r+B+Ka2ePn83vlmVaCKE7uD/UmnLx
         iQNA==
X-Gm-Message-State: AOAM531iGhCYTiFKiFd3Y4vjAseBY1L7U9EW/Ln358MQ3NpAQxwaIGod
        5KlMvDxJ2NLvHS+vUahk9iuXcA==
X-Google-Smtp-Source: ABdhPJxHXwSh1ptKahCJX6q78ixrUwBTmL84x8gmHmXycLrw8Drkju15Fsl46dlIIGulgf9pxiTevg==
X-Received: by 2002:a1c:7518:0:b0:381:c77:ceec with SMTP id o24-20020a1c7518000000b003810c77ceecmr29980415wmc.57.1649694475232;
        Mon, 11 Apr 2022 09:27:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f? ([2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f])
        by smtp.gmail.com with ESMTPSA id e8-20020a056000178800b00203da3bb4d2sm30687730wrg.41.2022.04.11.09.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 09:27:54 -0700 (PDT)
Message-ID: <686bf021-e6a4-c77a-33c9-5b01481e12f4@6wind.com>
Date:   Mon, 11 Apr 2022 18:27:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: What is the purpose of dev->gflags?
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org> <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
 <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
 <20220411154911.3mjcprftqt6dpqou@skbuf>
 <41a58ead-9a14-c061-ee12-42050605deff@6wind.com>
 <20220411162016.sau3gertosgr6mtu@skbuf>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220411162016.sau3gertosgr6mtu@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 11/04/2022 à 18:20, Vladimir Oltean a écrit :
> On Mon, Apr 11, 2022 at 06:10:49PM +0200, Nicolas Dichtel wrote:
>>
>> Le 11/04/2022 à 17:49, Vladimir Oltean a écrit :
>>> On Mon, Apr 11, 2022 at 05:43:01PM +0200, Nicolas Dichtel wrote:
>>>>
>>>> Le 11/04/2022 à 17:33, Vladimir Oltean a écrit :
>>>> [snip]
>>>>> Would you agree that the __dev_set_allmulti() -> __dev_notify_flags()
>>>>> call path is dead code? If it is, is there any problem it should be
>>>>> addressing which it isn't, or can we just delete it?
>>>> I probably miss your point, why is it dead code?
>>>
>>> Because __dev_set_allmulti() doesn't update dev->gflags, it means
>>> dev->gflags == old_gflags. In turn, it means dev->gflags ^ old_gflags,
>>> passed to "gchanges" of __dev_notify_flags(), is 0.
>> I didn't take any assumptions on dev->gflags because two functions are called
>> with dev as parameter (dev_change_rx_flags() and dev_set_rx_mode()).
> 
> You mean ops->ndo_change_rx_flags() or ops->ndo_set_rx_mode() are
> expected to update dev->gflags?
No, I just say that I didn't take any assumptions on what there are expected to do.

> 
>> Even if __dev_notify_flags() is called with 0 for the last arg, it calls
>> notifiers. Thus, this is not "dead code".
> 
> The relevant "changes" (dev->flags & old_flags) of the net_device which
> may have changed from __dev_set_allmulti() are masked out from
> call_netdevice_notifiers(), are they not?
> 
> 	if (changes & IFF_UP) {
> 		/* doesn't apply */
> 	}
> 
> 	if (dev->flags & IFF_UP &&
> 	    (changes & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI | IFF_VOLATILE))) {
> 	               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 	               these changes are masked out
Same here. Some complex path are called (eg. dev_change_rx_flags =>
ops->ndo_change_rx_flags() => vlan_dev_change_rx_flags => dev_set_allmulti =>
__dev_set_allmulti => etc).
Maybe you made an audit to check that other flags cannot be changed. But, if it
changes in the future, we will miss them here.

Did you see a bug? What is the issue?

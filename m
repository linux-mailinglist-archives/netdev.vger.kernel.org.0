Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6288534296
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 19:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbiEYR4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 13:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiEYR4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 13:56:46 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2B3101CD;
        Wed, 25 May 2022 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=UUCk/CBQM45CoxUp8FG5895NrkGwDgZ0RSyMfo8nfc0=; b=IhemAfN+gDhmT9B7a6lqrZ62lV
        P8EqtVutlaTp/wA15u9ieK7I9LxNWoMvSqViCon+t1c4MXcYB2BLTwCvzr/L4PpjPNJKu2AYcVIMR
        /4u3vqgMWT3H8BPm4Mj7DqQuDU3BLmxycyNfqtJp1YxEx8g3PMoP8oKvKe97kaZM3tOc=;
Received: from p200300daa70ef2005cc39ce6374ff633.dip0.t-ipconnect.de ([2003:da:a70e:f200:5cc3:9ce6:374f:f633] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ntvFO-0002uF-MM; Wed, 25 May 2022 19:56:38 +0200
Message-ID: <146b0749-20aa-3017-2998-98f46acad518@nbd.name>
Date:   Wed, 25 May 2022 19:56:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Baligh GASMI <gasmibal@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220525103512.3666956-1-gasmibal@gmail.com>
 <87r14hoox8.fsf@toke.dk>
 <CALxDnQa8d8CGXz2Mxvsz5csLj3KuTDW=z65DSzHk5x1Vg+y-rw@mail.gmail.com>
 <92ca6224-9232-2648-0123-7096aafa17fb@nbd.name>
 <CAA93jw4FnaCupm4uf4KOHXdLPntKKLq=5ncLLZOiiUvbmrSR-Q@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH 1/1] mac80211: use AQL airtime for expected
 throughput.
In-Reply-To: <CAA93jw4FnaCupm4uf4KOHXdLPntKKLq=5ncLLZOiiUvbmrSR-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.05.22 19:21, Dave Taht wrote:
> Sigh. Ideally we are trying to keep latency low by deeply understanding 
> current conditions. Batching up anything on this large interval feels 
> wrong. Powersave and beacons become "beating" frequencies.
Shorter intervals (or even doing it without batching at all) will likely 
lead to much more fluctuation, which could make the average less useful.
I think batching it up will likely be beneficial for protocols like 
batman-adv.

- Felix

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53CD534288
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 19:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbiEYRyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 13:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiEYRyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 13:54:31 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A862DE91;
        Wed, 25 May 2022 10:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BEtX22N4nmBUvhPs2dpMmIQif4Ym/qoHwx4bgdAzRGE=; b=nuxS1TC0TNX+Ii9C8/PoUC6ICY
        Ojvw8ZoRBI+SVXviS1qtEMR8w/BEntIGqZe8vM9vjSfuIvUqMHO+9UZUkdnwdywPDjbI2Ab1Mg1aX
        zFp5EEHQlZlO8kP2Ozyo84g7wBSzep6nmqc2hcwEi9I6IgS3eO3L4jImBme7RmukxE8U=;
Received: from p200300daa70ef2005cc39ce6374ff633.dip0.t-ipconnect.de ([2003:da:a70e:f200:5cc3:9ce6:374f:f633] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ntvDC-0002o2-DA; Wed, 25 May 2022 19:54:22 +0200
Message-ID: <592e2b28-2463-dece-8315-180089aadfee@nbd.name>
Date:   Wed, 25 May 2022 19:54:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [RFC PATCH 1/1] mac80211: use AQL airtime for expected
 throughput.
Content-Language: en-US
To:     Baligh GASMI <gasmibal@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
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
 <CALxDnQYHoZuv7hxLfagJRGRxw=UOFNmuBVHS8YghDwtfkLPAvg@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <CALxDnQYHoZuv7hxLfagJRGRxw=UOFNmuBVHS8YghDwtfkLPAvg@mail.gmail.com>
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


On 25.05.22 15:37, Baligh GASMI wrote:
> Indeed it's less expensive.
> 
> I'll try to make something in this direction to see what it looks like.
Thanks. Please also make sure that all of this extra work is not 
performed for drivers that don't need it, because they either implement 
.get_expected_throughput, or use minstrel, which also implements it in a 
better way.

- Felix

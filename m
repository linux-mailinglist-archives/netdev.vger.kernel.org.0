Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3504596C9E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbiHQKJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiHQKJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8013F4B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660730975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgPLw0rtRpX874pv/TGXoEN52GWQecwFxnLCwmV/znM=;
        b=cvWglADCE9nG69KOYrHW3p/HHfREfPo7sxIvd40a01RClYMuJYVYrFCPMW6pseDu9s/wTb
        K/tt+rtU993PqDhX8zQXzx6g+0SfMdmqJHnDocVXO3TB8Ptvm23vTRa5k9f+G7lZeUx21C
        WTzMbmnxZgJWpY/ad3gZvMOX+TyxXdk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-157-Y5HcwmYlN2uCwYcbh2iRSw-1; Wed, 17 Aug 2022 06:09:33 -0400
X-MC-Unique: Y5HcwmYlN2uCwYcbh2iRSw-1
Received: by mail-wr1-f69.google.com with SMTP id c6-20020adfa706000000b00222c3caa23eso2280304wrd.15
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=MgPLw0rtRpX874pv/TGXoEN52GWQecwFxnLCwmV/znM=;
        b=5AdpeUG1mVvzSEzcERgGuYVUDN+60wfw1ApQxM5NZUJEEIAqXrLrJnhinQ7LJukN64
         Qq8sPzX5zYL6Xmcr+slhT9NNFLrshZPxcID6XvDlttrQFb3Ku8QMlTe4gluvPlnGuKWx
         cKK+mQgm/SZ8FqQN+PP9+pwxniY4nh4KwYZYzGy4GieVVtNSJ0eji4acXPjs+kBCR8+U
         ApwzuKVTnVsToxl4IvVkt3H2BoRncIfRR34Fa2MoVQgfHaYSBApLGxT7mPetW+cye3oi
         2R8ciAbLhLssfzyMFWFh/9UvkeBEirykcoWS744Cj4tou6Nw9sXhDYxTKvT0xYBCwqd8
         ByRA==
X-Gm-Message-State: ACgBeo1qFqDytfCBNbzN7juXUyEB52N7PwvA2Z7nfdIHFvw0ZZsSI5re
        igpg0auxeTAKpWHOqT1lHpF29S06UOOC+2vlnjAUXFOrYNuozRpkTg4r9e5aPcuB70j450Imh0f
        DBPnnC/QtpqDpTzWt
X-Received: by 2002:adf:d228:0:b0:220:6f68:dd56 with SMTP id k8-20020adfd228000000b002206f68dd56mr13879256wrh.432.1660730972837;
        Wed, 17 Aug 2022 03:09:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7rvn/03ngpxQO5DcUzRWhDUOccD9vxbL72pGig2dUclpchCF0aJqoOCzUgeOoLUo67Am4hiQ==
X-Received: by 2002:adf:d228:0:b0:220:6f68:dd56 with SMTP id k8-20020adfd228000000b002206f68dd56mr13879245wrh.432.1660730972683;
        Wed, 17 Aug 2022 03:09:32 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id h3-20020a05600c2ca300b003a5ea1cc63csm1652237wmc.39.2022.08.17.03.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 03:09:32 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH 1/5] bitops: Introduce find_next_andnot_bit()
In-Reply-To: <YvwWnH/8dD1rYxpq@yury-laptop>
References: <20220816180727.387807-1-vschneid@redhat.com>
 <20220816180727.387807-2-vschneid@redhat.com>
 <YvwWnH/8dD1rYxpq@yury-laptop>
Date:   Wed, 17 Aug 2022 11:09:31 +0100
Message-ID: <xhsmha683b2qs.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/22 15:13, Yury Norov wrote:
> On Tue, Aug 16, 2022 at 07:07:23PM +0100, Valentin Schneider wrote:
>> @@ -59,7 +63,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
>>
>>              tmp = addr1[start / BITS_PER_LONG];
>>              if (addr2)
>> -			tmp &= addr2[start / BITS_PER_LONG];
>> +			tmp &= negate ?
>> +			       ~addr2[start / BITS_PER_LONG] :
>> +				addr2[start / BITS_PER_LONG];
>>              tmp ^= invert;
>>      }
>
> So it flips addr2 bits twice - first with new 'negate', and second
> with the existing 'invert'. There is no such combination in the
> existing code, but the pattern looks ugly, particularly because we use
> different inverting approaches. Because of that, and because XOR trick
> generates better code, I'd suggest something like this:
>
>         tmp = addr1[start / BITS_PER_LONG] ^ invert1;
>         if (addr2)
>                 tmp &= addr2[start / BITS_PER_LONG] ^ invert2;

That does look much better, and also gets rid of the ternary. Thanks!


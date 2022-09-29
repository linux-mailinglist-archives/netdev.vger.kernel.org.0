Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4695EF1B2
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiI2JVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiI2JVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:21:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE17A128A04
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664443263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qa9mZiS9OIIcUSOYy2a+vAqTtun3FeRDEYtpvzheMho=;
        b=RlHbM7Oakr+cwcm2m2sYg/tucfmWptJypNCefIqr2MTmxeOWTIU8jjpL2DIGRngs9rfVoc
        X25+6pefvrmheni5Eto2ejG8F7n/KiSkUr0g0qX3P4fWUOv510cm8VZssaDP7jad81psOS
        gLcm7YcJH9JoNFbC0DMAxbAKT5R8mJ0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-FrZpVTnbO1mBsntj8Ts3Mw-1; Thu, 29 Sep 2022 05:20:59 -0400
X-MC-Unique: FrZpVTnbO1mBsntj8Ts3Mw-1
Received: by mail-wr1-f71.google.com with SMTP id l12-20020adfa38c000000b0022cceed465dso287028wrb.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qa9mZiS9OIIcUSOYy2a+vAqTtun3FeRDEYtpvzheMho=;
        b=ekGXyi8hY3PDNj1xYVi3YhIyljzQDRmusucRUaI5MNIpBBjPbEGCVJn9MxSvdphIb3
         bGJtv9kBChkJwX50cWmTrP5BLyEvm7EH7yMfCr+IUmBJ8pul+Fka7jnrC5iu/7AMolt6
         MqufzdwiPi8VBaLFKX1zTEsvBowtdl+0LOQsFnnY+I614ytFY6sq3+elGlPBzYM889Gc
         hmwbK+TuyQjdjbZCnwN/qExcX2AwTWBvrLs1HdE0VP6GcW58u/fpKU/bjvMGlyjPXAWB
         Ahx+wrl8Z7Pq3OEkMLkwVd+mZG3eXElipoAYwrNiTHD7EDqrMi2Owal75Nu4N72xm5Jv
         V6UQ==
X-Gm-Message-State: ACrzQf1j/DjhSHPsKSDEwaABXU8l5Pfx13puKqW2IobOSROZ4egFGGzX
        Te0RxKXwKZIQxeLpLZA1hRL4ogPrdLzMIMDYtV6pqp4TfmUy4MwoMf7hAbbNJHVf7RqhpfAq5hz
        8RYroOArYmYTTFJ7P
X-Received: by 2002:a5d:6da2:0:b0:228:64cb:5333 with SMTP id u2-20020a5d6da2000000b0022864cb5333mr1397518wrs.428.1664443258884;
        Thu, 29 Sep 2022 02:20:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7n7+49OrBdOF6F/wjNanwKJgQEUip116VzwVCkHP8GFAoLMg1//Kfo3TPjk76R1lSoyf5bzg==
X-Received: by 2002:a5d:6da2:0:b0:228:64cb:5333 with SMTP id u2-20020a5d6da2000000b0022864cb5333mr1397497wrs.428.1664443258686;
        Thu, 29 Sep 2022 02:20:58 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id p25-20020a1c5459000000b003a5c7a942edsm3891479wmi.28.2022.09.29.02.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 02:20:57 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:20:55 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net] genetlink: reject use of nlmsg_flags for new commands
Message-ID: <20220929092055.GA3651@localhost.localdomain>
References: <20220928183515.1063481-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928183515.1063481-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 11:35:15AM -0700, Jakub Kicinski wrote:
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
> 
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.

Reviewed-by: Guillaume Nault <gnault@redhat.com>


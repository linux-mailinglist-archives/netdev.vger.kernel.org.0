Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8065A98F2
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 15:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiIANdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 09:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiIANcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 09:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C385FD0B
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 06:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662038928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHTa+FWm7oeImzoRnoqlC6BBTOOK+4vjj/5kjcEi/vc=;
        b=ZyM1J6rSVCcE9YzqhG6UJDaKz8AYIoIVzBVL2Jij3ruI93DOpQ+534mDKaS56JVBaSrxkB
        e/7uP8FjWhB5DNaLaou+Zx8UUPqKwBH34/mk/6dyjfq+v+BVmn2680dp5NvyfSfc2WRiTt
        W5V7wWeOlAzUZAWrUVIZyKPPzQMcd9M=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-C5qOY2BEO-GhmyTT02setQ-1; Thu, 01 Sep 2022 09:28:45 -0400
X-MC-Unique: C5qOY2BEO-GhmyTT02setQ-1
Received: by mail-qv1-f69.google.com with SMTP id a1-20020a0ccdc1000000b00498f818cc40so8896397qvn.8
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 06:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=KHTa+FWm7oeImzoRnoqlC6BBTOOK+4vjj/5kjcEi/vc=;
        b=kizVwOWO7xt+/ag8CSWc4qGUwbnxLV3bHTU/wAkXNPNxQDKNH7yyHf5KpI/9xtODpW
         SjBTxMrJQqOQKEOROXRAJr7gufxsUOxsp6agyCQAQuRNMGt39NQGL7TdI3Jeu8truWF3
         nlvyGGKc9rHP5079vQv2sAdIb98qCWFNE665A10mBD2sPEKODpH4FSBcisX83SERGzPr
         +lhSA1vnUtjpj38aryvs1yQxk7HDmDH9VLsdPiuwo8pcgvIX5daawzOnaxhUOFVvgibT
         OQ2NPPqnEP+nd2uN5JZm4SXCDD1DZD0pQcBaxDzaCMTbfG4TT/FJU0POqOeA8MN487+A
         JvCg==
X-Gm-Message-State: ACgBeo3zWQSeSshisMnr5S7EX8/KZ4Ra8ubKUXJAKZvt7wcRm4pJbMoV
        mp6bytjJuKNEO9FqkuZziA6Q4BV7+P9bWo1npWuvZ+jaML4X8yd8sqQAR0oVPuabJBFt1UrLRTH
        mtTQqtvpq4aT4vXAa
X-Received: by 2002:ad4:5bc1:0:b0:499:b05:734d with SMTP id t1-20020ad45bc1000000b004990b05734dmr14543343qvt.37.1662038924383;
        Thu, 01 Sep 2022 06:28:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4sa9iHl0nVSYhctkGtjgto7IhCUw1KueymhwCuwA43bg4yzH3mbmtccFPxjgoDpFEB0VoAag==
X-Received: by 2002:ad4:5bc1:0:b0:499:b05:734d with SMTP id t1-20020ad45bc1000000b004990b05734dmr14543328qvt.37.1662038924132;
        Thu, 01 Sep 2022 06:28:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id u6-20020a05620a430600b006b893d135basm11897700qko.86.2022.09.01.06.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:28:43 -0700 (PDT)
Message-ID: <306bd3cb986764e60f7ac21809ab68094b2e3325.camel@redhat.com>
Subject: Re: [PATCH next-next 0/2] net: vlan: two small refactors to make
 code more concise
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, morbo@google.com,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 15:28:40 +0200
In-Reply-To: <cover.1661916732.git.william.xuanziyang@huawei.com>
References: <cover.1661916732.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-08-31 at 12:09 +0800, Ziyang Xuan wrote:
> Give two small refactors to make code more concise.
> 
> Ziyang Xuan (2):
>   net: vlan: remove unnecessary err variable in vlan_init_net()
>   net: vlan: reduce indentation level in __vlan_find_dev_deep_rcu()
> 
>  net/8021q/vlan.c      |  5 +----
>  net/8021q/vlan_core.c | 22 +++++++++-------------
>  2 files changed, 10 insertions(+), 17 deletions(-)

The patches look correct to me, but I think is better to defer this
kind of nun-functional refactors to some work actually doing new stuff,
to avoid unneeded noise.

Note that I merged a few other clean-up recently, but e.g. they at
least formally removed some unneeded branch.

Sorry, I'm not going to apply this series.

Cheers,

Paolo


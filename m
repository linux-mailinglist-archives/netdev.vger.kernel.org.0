Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD3B5A7ACB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 12:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiHaKCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 06:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiHaKCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 06:02:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE8B12D39
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661940141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PV5zOxWi3z8nHUFT/9MG2QSzpeKdCS3Y26UR/yNJn0M=;
        b=DjLGeiBiwOnvAqGJsdrX8s57zP96oKWk564kiyiE1YQ7dLf6Hmexpg7OBdZ0Y4BlkyO8lC
        +wRwcrWMwNgU1hcu1onLRORhEG2LCk9bZ60/gCh89ULF385IRtOwrSl/KTs6VnvDxCUIJM
        UWwujBkCpCvwT1tEfL/KiPKnDsuzJo4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-538-jQPhjrqUMd-4AhdHAcfa1A-1; Wed, 31 Aug 2022 06:02:19 -0400
X-MC-Unique: jQPhjrqUMd-4AhdHAcfa1A-1
Received: by mail-wm1-f69.google.com with SMTP id j36-20020a05600c1c2400b003a540d88677so8077082wms.1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=PV5zOxWi3z8nHUFT/9MG2QSzpeKdCS3Y26UR/yNJn0M=;
        b=Wu0OElHloK6ScLbuvTQCMGZ28k3aNhov3wPiQKNTv8nNHoTbX/rkUnvdLIduKC6t4g
         Iyefzxsk6WxP0GiIe0qAToZRrndef+cJq5T9oMw15uyu3ia78jusNLIoAFMhRj75Of6Z
         IHS2OW4CBlMO1pZzRNJp6GdZorn7zat6s9MBrmXMR9c+gjeaAATZOp7tZ6VhWjUqMyfz
         wEeY6OkjsOyJH3zjDMrBqTJ2WaE3dSAa420eZWxWUutZgwF1y07Y5SK2X3+4TB+Kvg8f
         dQ9dQkE9k8wurQjR1fyTakoqEqXPetsFG2+5e9Gewg5stNqYyZxKoCQApmowSYqgUxR9
         nSdw==
X-Gm-Message-State: ACgBeo22Y2BZlN6XibfiiTYsReFaRIU5DgmnEk6Rpbbed43dena/QgTa
        eMos/qJSgpjZigZV2UkTXbIYCpBYRowB9I6LgbRHy6gxwrCUv2D7l11zE+xafCSfKQM4tfaiEgE
        Qb9FuGF2u2R14up0k
X-Received: by 2002:a05:600c:354a:b0:3a5:b01b:2ab0 with SMTP id i10-20020a05600c354a00b003a5b01b2ab0mr1419096wmq.61.1661940138746;
        Wed, 31 Aug 2022 03:02:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4wcwaqkPRYvsQTGeojMP7FZdCOda2Z6QTi/4Fk5r9eYTpzt5Ag/RYmkkd3Xx1+xmL0Is8lKw==
X-Received: by 2002:a05:600c:354a:b0:3a5:b01b:2ab0 with SMTP id i10-20020a05600c354a00b003a5b01b2ab0mr1419065wmq.61.1661940138509;
        Wed, 31 Aug 2022 03:02:18 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n18-20020a05600c501200b003a32251c3f9sm1979645wmr.5.2022.08.31.03.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 03:02:17 -0700 (PDT)
Date:   Wed, 31 Aug 2022 12:02:15 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcin.szycik@linux.intel.com,
        michal.swiatkowski@linux.intel.com, kurt@linutronix.de,
        boris.sukholitko@broadcom.com, vladbu@nvidia.com,
        komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH net-next v2 1/5] uapi: move IPPROTO_L2TP to in.h
Message-ID: <20220831100215.GA18919@pc-4.home>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
 <20220829094412.554018-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829094412.554018-2-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 11:44:08AM +0200, Wojciech Drewek wrote:
> IPPROTO_L2TP is currently defined in l2tp.h, but most of
> ip protocols is defined in in.h file. Move it there in order
> to keep code clean.

Acked-by: Guillaume Nault <gnault@redhat.com>


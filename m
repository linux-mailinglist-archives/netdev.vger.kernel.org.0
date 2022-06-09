Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8F544AFF
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 13:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244534AbiFILuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 07:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244663AbiFILuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 07:50:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00FA620A722
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654775396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DuwhD3TtwqmPc3FtJmMtruEqS+FysyJ1M2ttopTd4UE=;
        b=QXRwcZKUWlYp26MQSQFUIAlm65ZDBXdmXrWsmaS5F2jHuaUT47L/BKxBoJQUr41ngcOUZM
        Um0Cnof/UJpstY+ynQi+cVLYrOFSHOAf+w0b2k8GEpDCJWbh5SsU0wATWMlh7XatWTcybt
        s+fFlDtEIowMKHBHPuB3p371xf6uoYw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-rmUpZjWePUiwSj9o6svA4w-1; Thu, 09 Jun 2022 07:49:55 -0400
X-MC-Unique: rmUpZjWePUiwSj9o6svA4w-1
Received: by mail-qt1-f198.google.com with SMTP id t35-20020a05622a182300b00305099b873bso2261667qtc.18
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 04:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DuwhD3TtwqmPc3FtJmMtruEqS+FysyJ1M2ttopTd4UE=;
        b=4JT92/gQX//8uuH9v7klm5kRUOXk2KeIlXcGjhhiG+nT1Ux/KxnD/9zRZi/KM4kikl
         O+dchKziq7P71ktRQdhOIT2PzLSfyMSTQ6mHdOQZfat39UUfLjb4eFJ+gqa9SNnmi0uh
         7A1ufwWG5TQ1xNsFdIyQc4de5NsQIczNWWzjru3Nd0/OACBV7txkgV1GpQWOqYvh/t0b
         x/cdYG0FzplOHE2HpF+cNonY++vKaF3al/UlksmrIEyab4mVrFNMNfZzZpxr6ywMmgDS
         GZgAmYLpnrRRGfJbyh9zRu1YIKvZIM9hhusa1MCB1FF/df77GfY4dUx7qUCCouZIPdhV
         2ltg==
X-Gm-Message-State: AOAM532OiyG6LVLy+o/L8MsKKXc3+zcBjiTV0Qml9t31hf6Oajn+OgpX
        gPz7/J4+qQWg3EZpL2cYxj3XwGUH8UUbD/c3qpTel7vDuXlxQJBEpq/JHDmRHH87qSzALETk3vg
        cKIiBr2HYR1hJ4Vv7
X-Received: by 2002:a05:6214:761:b0:441:196:795e with SMTP id f1-20020a056214076100b004410196795emr83996400qvz.67.1654775395351;
        Thu, 09 Jun 2022 04:49:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiM6WZ7qFmx0s6PGdh/jWpyxlZoyVwejHGOyF0aVfaLqcBlYDNDG9DqxVM31JDDGzdiHNvxg==
X-Received: by 2002:a05:6214:761:b0:441:196:795e with SMTP id f1-20020a056214076100b004410196795emr83996374qvz.67.1654775395085;
        Thu, 09 Jun 2022 04:49:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id i21-20020a05620a405500b006a6ac4e7ab4sm12759648qko.112.2022.06.09.04.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 04:49:54 -0700 (PDT)
Message-ID: <b00ab3c4a12fb11ed95b2a4634e50e3cba10ec28.camel@redhat.com>
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        jreuter@yaina.de, razor@blackwall.org,
        Karsten Graul <kgraul@linux.ibm.com>, ivecera@redhat.com,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Xin Long <lucien.xin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Antoine Tenart <atenart@kernel.org>, richardsonnick@google.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Date:   Thu, 09 Jun 2022 13:49:48 +0200
In-Reply-To: <CANn89i+RCCXQDVVTB+hHasGmjdXwdm8CvkPQv3nYSLgr=MYmpA@mail.gmail.com>
References: <20220608043955.919359-1-kuba@kernel.org>
         <YqBdY0NzK9XJG7HC@nanopsycho> <20220608075827.2af7a35f@kernel.org>
         <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
         <CANn89i+RCCXQDVVTB+hHasGmjdXwdm8CvkPQv3nYSLgr=MYmpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-08 at 16:00 -0700, Eric Dumazet wrote:
> On Wed, Jun 8, 2022 at 3:58 PM David Ahern <dsahern@kernel.org> wrote:
> > 
> > On 6/8/22 8:58 AM, Jakub Kicinski wrote:
> > > IMO to encourage use of the track-capable API we could keep their names
> > > short and call the legacy functions __netdev_hold() as I mentioned or
> > > maybe netdev_hold_notrack().
> > 
> > I like that option. Similar to the old nla_parse functions that were
> > renamed with _deprecated - makes it easier to catch new uses.
> 
> I think we need to clearly document the needed conversions for future
> bugfix backports.
> 

To be on the same page: do you think we need something under
Documentation with this patch? or with the later dev_hold rename? or
did I misunderstood completely?

Thanks!

Paolo


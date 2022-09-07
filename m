Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252995B0D57
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiIGTgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiIGTgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C209BBC83B
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662579378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SRUzgyu3ke1r6hM2I/CiksoK/WuG/G+5SB3dVoLb2kg=;
        b=dq9f1/ByM2airxGAXNiLJMB19FXL7OUBJATbyH6+KZA6PY8SeMm1+ptNQXU4oGQAmcHEsG
        C/fJJ4ADqH7Sp7MgvLTGMgrmtsAr99nwaEouzL/Uwqny44Q2iTKxjR1uVuiF8pW762BqeJ
        xGXuRpQaU8c2GHGuI6bDM4er6QrqTo0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-176-kBBR2BKDOwyQMf20hz_Vgw-1; Wed, 07 Sep 2022 15:36:16 -0400
X-MC-Unique: kBBR2BKDOwyQMf20hz_Vgw-1
Received: by mail-qt1-f200.google.com with SMTP id cj19-20020a05622a259300b003446920ea91so12689257qtb.10
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 12:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=SRUzgyu3ke1r6hM2I/CiksoK/WuG/G+5SB3dVoLb2kg=;
        b=FSKEVx3sJqtfr0PAKZWGTvVUDplhWWObzBtq2cSovng+XjMxiDgCdkDyl6kXjltf3K
         Licwp3cNUu5IZlBJ6qaC6CviZG7cjyIxvzPqsWyr+lZTtx51PaZyY/3Ubr06kS1Qd3Ov
         OrtEE02sMoLHQpxKwqvWpg/msnR1Uwyq5c3WEPIwEfP2rmlNWgyNn5ZYk5o4/j4NSXE0
         CLyLbd9tUFotxNhE4keG3Spu4Qq/wwI4Y9uv80BGNtz8FXYpobQjIs2gGgOndJbrUmh9
         Y1lD1rMKBcTw65gljZ2Y0WQvgceVrEgGun7Hhv42Awcqqp/hzcMwgZ18ABUAqxaCEpMj
         fj8g==
X-Gm-Message-State: ACgBeo32ED7WPFJrvWXshYbqsr5i4deegaVXMYISQ/lp1xMf2lExr3cf
        1nQRNyDRqR8QxuqJnJYbIewruiq8Y66WkAuupryb9CXGJTe+ltAT2iu6dxO1zUrBpt+m+U/iiOw
        umiIUBV+YhqsZvsms
X-Received: by 2002:a05:622a:134f:b0:344:df2b:9afe with SMTP id w15-20020a05622a134f00b00344df2b9afemr4952685qtk.279.1662579376521;
        Wed, 07 Sep 2022 12:36:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6nukJaa/Xp+rVNNei888VY7Jy1p9nTUTUXc0lDaKJKAHlJSyYYknx7ao2/KUNUwmeztil1Lw==
X-Received: by 2002:a05:622a:134f:b0:344:df2b:9afe with SMTP id w15-20020a05622a134f00b00344df2b9afemr4952660qtk.279.1662579376283;
        Wed, 07 Sep 2022 12:36:16 -0700 (PDT)
Received: from redhat.com ([45.144.113.241])
        by smtp.gmail.com with ESMTPSA id a5-20020ae9e805000000b006b93ef659c3sm14104168qkg.39.2022.09.07.12.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 12:36:15 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:36:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Message-ID: <20220907153425-mutt-send-email-mst@kernel.org>
References: <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 07:27:16PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 3:24 PM
> > 
> > On Wed, Sep 07, 2022 at 07:18:06PM +0000, Parav Pandit wrote:
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Wednesday, September 7, 2022 3:12 PM
> > >
> > > > > Because of shallow queue of 16 entries deep.
> > > >
> > > > but why is the queue just 16 entries?
> > > I explained the calculation in [1] about 16 entries.
> > >
> > > [1]
> > >
> > https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC
> > 419@
> > > PH0PR12MB5481.namprd12.prod.outlook.com/
> > >
> > > > does the device not support indirect?
> > > >
> > > Yes, indirect feature bit is disabled on the device.
> > 
> > OK that explains it.
> 
> So can we proceed with v6 to contain 
> (a) updated commit message and
> (b) function name change you suggested to drop _fields suffix?

(c) replace mtu = 0 with sensibly not calling the function
when mtu is unknown.


And I'd like commit log to include results of perf testing
- with indirect feature on
- with mtu feature off
just to make sure nothing breaks.

-- 
MST


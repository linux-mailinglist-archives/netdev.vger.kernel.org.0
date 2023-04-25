Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0EA6EE21D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjDYMq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjDYMqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:46:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF17D333
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682426732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=krc+SiJhBUwO2ug/XwTx3KTJqkkR2CFS+eg5Dz5ylJc=;
        b=CgCU3XBoShcQmruR1d+CCdinhapd2mFzXbwbRt1A5MY8MPKF44WNeUxRfe8+bqHwoILl3t
        1bD1g21OURwsQHaq4J94ud9fYTXHijNlSga0ZBgPTdqjnFSDqmG6pzSOfnd0Gnc+vlSdFI
        3JGMO23C+ZQPMuw1lyyaNawXWuTVHMo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-oF28UJl-M6e5rDjJ401otg-1; Tue, 25 Apr 2023 08:45:30 -0400
X-MC-Unique: oF28UJl-M6e5rDjJ401otg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f17afcf99cso21003345e9.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682426728; x=1685018728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krc+SiJhBUwO2ug/XwTx3KTJqkkR2CFS+eg5Dz5ylJc=;
        b=fXP1Wpkw/ioB4ofe5onczrZQvKsnsLQcNmWN1Tn66ceLflLh+cjwFPtEEN9lpEX5xq
         FqvuvIhf7R4AvKdRBbcwH5/matdXJZum4S46NbBsuZSzRTZB2VWPt/00TI3EsvwA6zr+
         iAqoPnZQLVABcQZZFscBNsqsqj8aOEpezS8acTBxqldkW2MUNSMlKmTri2rPmPY2PFhr
         LZTFl8nfkrGHYxsuvOD7FYaZlIvlX3mi68PbiQhCIX9NYh/koDoVWhJ2UFtrSgiAfL08
         g6SkDCoAnutumBTDBkuf80KHXNvaC+mv7kjE3hLkn5CLwOPJG/n51vM2ncJ8/9ctesdH
         O3RQ==
X-Gm-Message-State: AAQBX9eQoRdWHVgz9o6LbNDtE7IO+yYfiOnxjbrqs31aEyk9Pc8RPKZj
        T8ZdiEpiOjwaW/azBAJ06MyD6agcwqLC/Q0xa4WDVe8F85oR2fGK0IuB7S9L9Fs23d+8Nwu2pWj
        XTetO0XF2kxF8ZQ20
X-Received: by 2002:a05:600c:2214:b0:3f1:987b:7a28 with SMTP id z20-20020a05600c221400b003f1987b7a28mr7195376wml.29.1682426728235;
        Tue, 25 Apr 2023 05:45:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350bIPgn166ZA/wJ8PFmg9nFmKKBjNCYwRGQ/sI+aE3t+loxoVTTzjiSf9BdLyfiT4aA9pr1zIA==
X-Received: by 2002:a05:600c:2214:b0:3f1:987b:7a28 with SMTP id z20-20020a05600c221400b003f1987b7a28mr7195359wml.29.1682426727867;
        Tue, 25 Apr 2023 05:45:27 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c4fc200b003f1738e64c0sm18301465wmq.20.2023.04.25.05.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 05:45:27 -0700 (PDT)
Date:   Tue, 25 Apr 2023 08:45:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [PATCH] can: virtio-can: cleanups
Message-ID: <20230425084503-mutt-send-email-mst@kernel.org>
References: <20230424-modular-rebate-e54ac16374c8-mkl@pengutronix.de>
 <20230424170901-mutt-send-email-mst@kernel.org>
 <20230425-oxidizing-blandness-ca9cc2cf114e-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425-oxidizing-blandness-ca9cc2cf114e-mkl@pengutronix.de>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:17:20AM +0200, Marc Kleine-Budde wrote:
> On 24.04.2023 17:09:23, Michael S. Tsirkin wrote:
> > On Mon, Apr 24, 2023 at 09:47:58PM +0200, Marc Kleine-Budde wrote:
> > > Address the topics raised in
> > > 
> > > https://lore.kernel.org/20230424-footwear-daily-9339bd0ec428-mkl@pengutronix.de
> > > 
> > > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > 
> > given base patch is rfc this should be too?
> 
> This is an incremental patch that fixes the topics I raised in the
> review of "[RFC PATCH v2] can: virtio: Initial virtio CAN driver.", see
> linked discussion thread.
> 
> regards,
> Marc

and that's fine, just pls put RFC in the subject.

-- 
MST


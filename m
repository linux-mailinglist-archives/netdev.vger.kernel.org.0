Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C74E620D20
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiKHKVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiKHKVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:21:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BB41788D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667902778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wmHYFTBsKuWScC8Kqjy2PAEKm6csuD4B0MvNZIzB2DQ=;
        b=ixkoDm/gLlUz3hM/vz74WkZ7Amss2reQHmwFiACfrysT9qWrV0KRhUTR1vVROZerZ3+Zmc
        4gO9evkUZQoQM6rOCspyRenHIQY5vpkDxu9HJAOlTXJ4akW4fX04QxA2fLph+3Qfz9LHR5
        sDjHyOQRdvWInztMw99krpMuc3gGT4Y=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-329-OQIYcXGeP4CbBgDeQiphPg-1; Tue, 08 Nov 2022 05:19:36 -0500
X-MC-Unique: OQIYcXGeP4CbBgDeQiphPg-1
Received: by mail-qt1-f199.google.com with SMTP id f4-20020a05622a114400b003a57f828277so4969876qty.22
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 02:19:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wmHYFTBsKuWScC8Kqjy2PAEKm6csuD4B0MvNZIzB2DQ=;
        b=1y04sZRsXYdA8nDHTwUjM21W+EeQDtOJFkcLVT2QTFeZ2BkKrhs2cyToDPlOCh1xbc
         DSQYkytglQkDCU9Hh/0YI9CD1XPCnSebP/XEf4hq3SeX2HSkcEDYP624jT/BUj5dbpVH
         8EFXTItRXNbY9D/Efn5gMQYRX0M8UPaQvt+fpICZHbuZUgjG6PGz6zveB20AlBVfLa+3
         1u5pnc/2Ju14TzjZjqocXehU91U3rkG/2ytgcJCzG8dqdBgiKVmOa7v6UGeswyXsbUl+
         JvuAziNgf1VpwYxkN4K08R/gJ+3YAWYQTJ6OOnauITWLKIoG/8yZ5CQdSk8mMf/u7Ur8
         Fb4w==
X-Gm-Message-State: ACrzQf0nwDLP3yHHc5HgY2X29xtEf2+bePZeJtp8A9spjHzC1RGqlEUl
        UPmlfSTrsXJ3WYmm2M4U03WyJ/Tk/Q54Yb2PutMdXL1xedCdVBNIyws+nxQ+eum8rf/0DPYBWyB
        jsV1w8v3jUCgz6jy6
X-Received: by 2002:ad4:5d6a:0:b0:4bb:d900:ff56 with SMTP id fn10-20020ad45d6a000000b004bbd900ff56mr46396596qvb.74.1667902776091;
        Tue, 08 Nov 2022 02:19:36 -0800 (PST)
X-Google-Smtp-Source: AMsMyM63jkCq34k8wj/H83p+25/KE3CUuZZYhfjOY9rfuM7Lu8YuWV7BOTWqXJCZlgIS3ZSP0olW2g==
X-Received: by 2002:ad4:5d6a:0:b0:4bb:d900:ff56 with SMTP id fn10-20020ad45d6a000000b004bbd900ff56mr46396588qvb.74.1667902775881;
        Tue, 08 Nov 2022 02:19:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-250.dyn.eolo.it. [146.241.112.250])
        by smtp.gmail.com with ESMTPSA id p14-20020ac8460e000000b0039d02911555sm7867956qtn.78.2022.11.08.02.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:19:35 -0800 (PST)
Message-ID: <9515a39b692eeaadbdc0dcf8903ad2ab9b3ca64e.camel@redhat.com>
Subject: Re: [V2 net 05/11] net/mlx5: Fix possible deadlock on
 mlx5e_tx_timeout_work
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Date:   Tue, 08 Nov 2022 11:19:31 +0100
In-Reply-To: <20221107202413.7de06ad1@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
         <20221105071028.578594-6-saeed@kernel.org>
         <20221107202413.7de06ad1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-07 at 20:24 -0800, Jakub Kicinski wrote:
> On Sat,  5 Nov 2022 00:10:22 -0700 Saeed Mahameed wrote:
> > +	/* Once deactivated, new tx_timeout_work won't be initiated. */
> > +	if (current_work() != &priv->tx_timeout_work)
> > +		cancel_work_sync(&priv->tx_timeout_work);
> 
> The work takes rtnl_lock, are there no callers of
> mlx5e_switch_priv_channels() that are under rtnl_lock()?
> 
> This patch is definitely going onto my "expecting Fixes"
> bingo card :S

I think Jakub is right and even mlx5e_close_locked() will deadlock on
cancel_work_sync() if the work is scheduled but it has not yet acquired
the rtnl lock.

IIRC lockdep is not able to catch this kind of situation, so you can
only observe the deadlock when reaching the critical scenario.

I'm wild guessing than a possible solution would be restrict the
state_lock scope in mlx5e_tx_timeout_work() around the state check,
without additional cancel_work operations.

Thanks,

Paolo


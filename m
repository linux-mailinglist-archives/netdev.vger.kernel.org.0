Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E8F653139
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiLUNCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiLUNCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530D5B4A5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 05:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671627720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=852DXzEOwNu2hlEhdNit1/MeucSNEq0R96SaREh4kyg=;
        b=C45FTUuVDpxXQWFJ8aRHcSzNC2HlfH5KbqR23ljbe7Y0CyLCPGoQR69P8jDG4PiJZwfg+o
        7ywYPfAdji6h5IfuT6LKJD8P4YHqB3nCoCcbJSc9etH3DTB5NqQYPX3tATZr7CIF+tJR0m
        /BSCfvvqPmHJr/MDLsOQjdEpgeAkcu4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-ZkYCAZ5cM9aDGDh7ineCnA-1; Wed, 21 Dec 2022 08:01:58 -0500
X-MC-Unique: ZkYCAZ5cM9aDGDh7ineCnA-1
Received: by mail-wr1-f69.google.com with SMTP id i25-20020adfaad9000000b002426945fa63so2876622wrc.6
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 05:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=852DXzEOwNu2hlEhdNit1/MeucSNEq0R96SaREh4kyg=;
        b=ZCup67m7v1anfVBW6Z5/vLfwEhQNac9leeuBzlWyYwbpkI34h6T+OHGXswx6lj9tHP
         jLJD8A6q76a0F6PtjyBjSt0DIYuyluyI7sOP+Tv+x1iuB3A9vUtiQqG8Mxt70WkWs5Ab
         cyf6AXjod0hdDuhuWTxTeOExL76o7UVmLVgBwc6eN5wkFy9j8QPRbNbfaD/JasKiaqsu
         uz6C86xjGDBc+8YyLUZ+t6CjXaXfRZ+ZQncFK/jx7TjQzCSvyw02yfqW+HYUxpUXePOA
         xZzoSlfS7tGPLVi9YVpUYHlP82grq+6+yGg58TLtZLZJxZky0Mlcr6kTAgd0HyrZ0vl1
         Pebg==
X-Gm-Message-State: AFqh2kpv1/ao2ZkDGCbM4tAovOCQvdO253ZYH9dhkHilVRvV54ii6Cjp
        UCmuyJ/6zaU75rFmBu4esqQyH7Ms9MMeqlg3ym3rhg4STUYKb5RRCuewfwznWB3rDD39adhgB4E
        CnxUt27OE13fdnZCe
X-Received: by 2002:a5d:624d:0:b0:242:4d70:7882 with SMTP id m13-20020a5d624d000000b002424d707882mr1176214wrv.15.1671627717204;
        Wed, 21 Dec 2022 05:01:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu3XJelFbQ4KH+zuEovnB6boe7747MwowEHosMNJ0THlvllnIdgYSkeLe4VLs3EJjdf2C7jcQ==
X-Received: by 2002:a5d:624d:0:b0:242:4d70:7882 with SMTP id m13-20020a5d624d000000b002424d707882mr1176194wrv.15.1671627716932;
        Wed, 21 Dec 2022 05:01:56 -0800 (PST)
Received: from redhat.com ([2.52.8.61])
        by smtp.gmail.com with ESMTPSA id d4-20020adfe884000000b00228cbac7a25sm15210244wrm.64.2022.12.21.05.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 05:01:56 -0800 (PST)
Date:   Wed, 21 Dec 2022 08:01:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] virtio_net: send notification coalescing command only if
 value changed
Message-ID: <20221221075855-mutt-send-email-mst@kernel.org>
References: <20221221120618.652074-1-alvaro.karsz@solid-run.com>
 <20221221073256-mutt-send-email-mst@kernel.org>
 <CAJs=3_CVUydOpH=a-RJLWUQ0_1EbkwKtGD2F3Xvw=dR5QFXP5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs=3_CVUydOpH=a-RJLWUQ0_1EbkwKtGD2F3Xvw=dR5QFXP5g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 02:44:21PM +0200, Alvaro Karsz wrote:
> > Why do we bother? Resending needs more code and helps
> > reliability ...
> 
> It just seems unnecessary.
> If a user changes just one parameter:
> $ ethtool -C <iface> tx-usecs 30
> It will trigger 2 commands, including
> VIRTIO_NET_CTRL_NOTF_COAL_RX_SET, even though no rx parameter changed.
> 
> If we'll add more ethtool coalescing parameters, changing one of the
> new parameter will trigger meaningless
> VIRTIO_NET_CTRL_NOTF_COAL_RX_SET and VIRTIO_NET_CTRL_NOTF_COAL_TX_SET
> commands.
> 
> Alvaro

We'll always just do 2 commands, right?
I don't think we should bother at this point.
It might not be completely redundant.
E.g. if a card lost the config resending it might help fix things.


-- 
MST


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D9C532809
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 12:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbiEXKl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 06:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiEXKl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 06:41:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F37A4DF4D
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 03:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653388913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubAk3svHdWm66Dk/uOmCGvh6xK8/Q6YgPvIE0tnQXv4=;
        b=ZtnRQN/pUZMlxGCPi2LyU4mTLRK52yTQsHx2U3sLWFLxdmKprLg3DZP3bYnAq+YVcWLfKr
        Ys7ZNyNxpfOLjrOEXjUieU/U+Lx/b7D+hwRCWxWQc2wvBlzCQKQBXSZQXFSxdr8fZ3k7mF
        rg19f2QjZNzO/zMFw7Oi7PAK82o+4t4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-oe-f9GJ0OuOyt1UQS4giig-1; Tue, 24 May 2022 06:41:52 -0400
X-MC-Unique: oe-f9GJ0OuOyt1UQS4giig-1
Received: by mail-qt1-f199.google.com with SMTP id v1-20020a05622a014100b002f93e6b1e8cso2355430qtw.9
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 03:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ubAk3svHdWm66Dk/uOmCGvh6xK8/Q6YgPvIE0tnQXv4=;
        b=Xy2VlezKxRWlfPXOSti5UCS1ctFsrbKc00j8CN3nhLgfkwxxHSnp5WPsd2Hw8Dzfps
         XZHbrHjHdgghuEK1ru1JwHvnXoqfXirdXmQM5qP67hdb1o9a7uCSEJzoWJ1jtXdNWrvU
         /DW0+oqL7fxyFZfNQ9gX01TCRDLf74zTeqW0eWT3nJ5+orpnV9iLEdu3mwruu3F9WzFn
         DNCF3TbzXfMtJWQNWTFaIoim/C5apMJfnd+djE60GgthLtrEMaNOg3oCHRHUV5jATLFF
         hf9w32kx6/RrJLl85aM/7OWxFbXNtaJ+TO3tpvNAH0MFqPDz6L0q53lLHO5oGBYBGvfU
         RXyA==
X-Gm-Message-State: AOAM532gsO/2z58IK7lHQCHo2PG0g7rPYCeVp8hgOHxTHmg9brql1Mp8
        NbkAtcDHy8qcJ+xQqnJpDC+Rqb8hjNfGbrutAqUzBzef7zgVXtVbpwekDiQKvKbBAWWW565NiMj
        CYE1Q1aR8nlRuYU7a
X-Received: by 2002:a05:620a:1902:b0:5f1:8f5d:b0f2 with SMTP id bj2-20020a05620a190200b005f18f5db0f2mr16743880qkb.60.1653388910373;
        Tue, 24 May 2022 03:41:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/6vdGvVw7+3dG+JbGf/gBNiKOWdL7iLYmHHQZgYj4nfNHG2GNf0Jv2MEuJDszO7sbE+hESw==
X-Received: by 2002:a05:620a:1902:b0:5f1:8f5d:b0f2 with SMTP id bj2-20020a05620a190200b005f18f5db0f2mr16743868qkb.60.1653388910123;
        Tue, 24 May 2022 03:41:50 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id bw14-20020a05622a098e00b002f90f479af6sm6080601qtb.40.2022.05.24.03.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 03:41:49 -0700 (PDT)
Message-ID: <cf3188eba7e529e4f112f6a752158f38e22f4851.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net, neigh: introduce interval_probe_time
 for periodic probe
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yuwei Wang <wangyuweihx@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, daniel@iogearbox.net,
        roopa@nvidia.com, dsahern@kernel.org,
        =?UTF-8?Q?=E7=A7=A6=E8=BF=AA?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org
Date:   Tue, 24 May 2022 12:41:45 +0200
In-Reply-To: <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
References: <20220522031739.87399-1-wangyuweihx@gmail.com>
         <b5cf7fac361752d925f663d9a9b0b8415084f7d3.camel@redhat.com>
         <CANmJ_FP0CxSVksjvNsNjpQO8w+S3_10byQSCpt1ifQ6HeURUmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-24 at 17:38 +0800, Yuwei Wang wrote:
> On Tue, 24 May 2022 at 16:38, Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Sun, 2022-05-22 at 03:17 +0000, Yuwei Wang wrote:
> > 
> > > diff --git a/include/net/netevent.h b/include/net/netevent.h
> > > index 4107016c3bb4..121df77d653e 100644
> > > --- a/include/net/netevent.h
> > > +++ b/include/net/netevent.h
> > > @@ -26,6 +26,7 @@ enum netevent_notif_type {
> > >       NETEVENT_NEIGH_UPDATE = 1, /* arg is struct neighbour ptr */
> > >       NETEVENT_REDIRECT,         /* arg is struct netevent_redirect ptr */
> > >       NETEVENT_DELAY_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
> > > +     NETEVENT_INTERVAL_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
> > 
> > Are you sure we need to notify the drivers about this parameter change?
> > The host will periodically resolve the neighbours, and that should work
> > regardless of the NIC offload. I think we don't need additional
> > notifications.
> > 
> 
> `mlxsw_sp_router_netevent_event` in
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c and
> `mlx5e_rep_netevent_event` in
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c still
> use `NETEVENT_DELAY_PROBE_TIME_UPDATE` to receive the update event of
> `DELAY_PROBE_TIME` as the probe interval.
> 
> I think we are supposed to replace `NETEVENT_DELAY_PROBE_TIME_UPDATE` with
> `NETEVENT_INTERVAL_PROBE_TIME_UPDATE` after this patch is merged.

AFAICS the event notification is to let neigh_timer_handler() cope
properly with NIC offloading the data plane.

In such scenario packets (forwarded by the NIC) don't reach the host,
and neigh->confirmed can be untouched for a long time fooling
neigh_timer_handler() into a timeout.

The event notification allows the NIC to perform the correct actions to
avoid such timeout.

In case of MANAGED neighbour, the host is periodically sending probe
request, and both req/replies should not be offloaded. AFAICS no action
is expected from the NIC to cope with INTERVAL_PROBE_TIME changes.

Cheers,

Paolo


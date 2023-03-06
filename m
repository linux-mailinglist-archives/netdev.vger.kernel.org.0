Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A881E6ABFD2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCFMsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCFMsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:48:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130F12942E
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 04:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678106837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=8txTUjCfQ30DZq8EG3/E5KSXjGhKnOOc6WZNsN31Luc=;
        b=EuvrFS2fqhJy/P8qyE5GZiUfiJBtFL1fQVzHI10+XZ29B5g6SUGKxM8MNOUgllXelePhsV
        0in6MBth09zEX42e3gPGaGxpx/g0JwYJpWn/scNTNoQq1WdnzQOwMc9idBLE+0X3AKRI0E
        axip0uRZASI/30EW2N9KLNngI1osZzM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-xCgpg84XP0e1q72Ku4EVgQ-1; Mon, 06 Mar 2023 07:47:15 -0500
X-MC-Unique: xCgpg84XP0e1q72Ku4EVgQ-1
Received: by mail-ed1-f72.google.com with SMTP id h15-20020a056402280f00b004bf9e193c23so13814628ede.11
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 04:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678106834;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8txTUjCfQ30DZq8EG3/E5KSXjGhKnOOc6WZNsN31Luc=;
        b=JRLC3kEcZ+OOGztrpa3c7U9+MA5G871pAAgy++XLHF4UMyYssOn8Xh2c2K747ucOFo
         cIK6OZIDXawNBx+H3jD5a9zuVQ13wmOWMI69drjRcKaaLR7KaJugz1uOsmIMjY9aDkb0
         rJm/3wH3ZIIwZcorWcmPkobcJ3T0Sj9a3bjMHv1thwCFPLPY5n0Ov0DaRR389rq7lv4m
         2zAYH/7yH+cdb0jQRrE63cvuIPrYwG1oNETDIOD4iL4UaXLS6Ld849VoO3k4b51F19FZ
         NyLpBHtYheMUyvK7Ph4kFEfF45o5DUYXuhbqIcnRIyUgsLnBrgwCffQ3XtWKMEIusJHa
         ct1Q==
X-Gm-Message-State: AO0yUKXCJJpH2VlUCoPmH/nAVc+VnBJUSOZ6WItfnX3dks50ux6zJ85Q
        WLfYlfNZdrK9jkg5pEzBGTZz43V+QbUIdxT80IUOgFqphBp3bVW0rtPOHJGk3ih2Cl9xwRxGyjP
        W7Z7tcOe4nFOR98BPaLdPxI2o5mw+EyPVvJdaDdbzly4VrQ==
X-Received: by 2002:a50:f61b:0:b0:4bc:eec5:37f5 with SMTP id c27-20020a50f61b000000b004bceec537f5mr5830006edn.6.1678106834189;
        Mon, 06 Mar 2023 04:47:14 -0800 (PST)
X-Google-Smtp-Source: AK7set8tGjGVFa9l6Oz7NGjZKpCUJ1HrHE5LNsxo692Eigf3lWq+BjiUq2WqRJCevUtx2QlSu/l2LnnZ90BvOOaVHyw=
X-Received: by 2002:a50:f61b:0:b0:4bc:eec5:37f5 with SMTP id
 c27-20020a50f61b000000b004bceec537f5mr5829990edn.6.1678106833964; Mon, 06 Mar
 2023 04:47:13 -0800 (PST)
MIME-Version: 1.0
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 6 Mar 2023 07:47:02 -0500
Message-ID: <CAK-6q+hVu8xST=zreEdH3ne+kUY-zGriRwHAR9OpCxTwPFwOSw@mail.gmail.com>
Subject: introduce function wrapper for sk_data_ready() call?
To:     peilin.ye@bytedance.com
Cc:     cong.wang@bytedance.com, "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I saw that in 6.3-rc1 the following patch introduced something in dlm
socket application handling 40e0b0908142 ("net/sock: Introduce
trace_sk_data_ready()"). I am asking myself if we could instead
introduce a wrapper in net/ protocol family implementations and they
do such trace event calls there inside the socket implementation
instead of letting the application layer do it. It looks pretty
generic for me and it does not trace any application specific
information.

I did something similar for sk_error_report(), see e3ae2365efc1 ("net:
sock: introduce sk_error_report").

Thanks.

- Alex


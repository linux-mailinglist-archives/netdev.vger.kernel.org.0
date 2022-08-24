Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E303A59FA18
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiHXMih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiHXMig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:38:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11128E9A1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661344714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9jr+amK0uWEEWGvSLDxuMVCNNDt0iE/dvefpOk4UgzQ=;
        b=cTr+YYyzy/Ic98M1akm8TFGRHJungRY0NJyZeLoCDtv4nNdOVAy7iwwjurYG8m/aW7Z9jM
        P3yoR00CThcxDiWzUdWubvsbsqlkmKQtqOj3qjH8w2LdsUAXmyTK0EQc7oDwpabWgKEprY
        T9NPCE3/f3kR8XAHq6FG/L381LlvwBM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-JwfHoqY0NdCuNosSrjDINQ-1; Wed, 24 Aug 2022 08:38:33 -0400
X-MC-Unique: JwfHoqY0NdCuNosSrjDINQ-1
Received: by mail-qv1-f72.google.com with SMTP id ea4-20020ad458a4000000b0049682af0ca8so9577847qvb.21
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9jr+amK0uWEEWGvSLDxuMVCNNDt0iE/dvefpOk4UgzQ=;
        b=3LkN2ES7KSVV8ONXhxXrKScuv3gEfg66cbQLJl4ImBJtg4ONM/IuoDOr63pXtukbq2
         qaU0GYPPvTTadb2c5v4J7DWKabq7ZkSSQjZMOWZeaW10n5rcr2ESL9FFVeEX3ObC8fOh
         8Sb2tRLPBM8kk1Loc551HMTyzIoiUJYt7Yon50xp7ZLUe7x2lBt/Ak16vyZvYQNucQbS
         fBotk5aigQCp+F8w/EdGcGBgSmLz0P1mzOxMzBk238G+KFZ/p1ct9BaGbx2oxM0fgh13
         EGFJ5rbz+GhCzqImLv9XfN7DBIlpF4jNCMGKFzDb1kjV3ch7dbSdFyAL/Vdbsdpn6UmT
         NIkw==
X-Gm-Message-State: ACgBeo3f3hApLE8kjqN3OZIbDaJPIbdpDIoLftXCSkxsptfBXAMaodXD
        R1034mdl69+cOX89NHHjiqYIuQ7UZs6c9mFAGC9XZQzAuMcrUwVIGmyhJnxNW+FLNqYzOoacbuq
        jryiEbEL2Zq8yy9M5xbTzOa6imDcmb93+
X-Received: by 2002:ad4:5d6f:0:b0:496:5ad5:fa40 with SMTP id fn15-20020ad45d6f000000b004965ad5fa40mr24705001qvb.59.1661344713148;
        Wed, 24 Aug 2022 05:38:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5JSXq91N8s0XEtfCISGeusZI4avtWP9oNK+/vGFim1UEwZ9lqifEh6HdmO1keP9tUUF/WsRoUMcvpA/Bit5i4=
X-Received: by 2002:ad4:5d6f:0:b0:496:5ad5:fa40 with SMTP id
 fn15-20020ad45d6f000000b004965ad5fa40mr24704987qvb.59.1661344712950; Wed, 24
 Aug 2022 05:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220822071902.3419042-1-tcs_kernel@tencent.com>
 <f7e87879-1ac6-65e5-5162-c251204f07d4@datenfreihafen.org> <CAK-6q+hf27dY9d-FyAh2GtA_zG5J4kkHEX2Qj38Rac_PH63bQg@mail.gmail.com>
 <CAB2z9exhnzte0rpT9t6=VpFCm9x+zZdmr01UHFxqvYy8y9ifag@mail.gmail.com>
In-Reply-To: <CAB2z9exhnzte0rpT9t6=VpFCm9x+zZdmr01UHFxqvYy8y9ifag@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 24 Aug 2022 08:38:22 -0400
Message-ID: <CAK-6q+g-L-6kKW69DYxgXvLdfChF+oQsmi-Y4cvBK2ji2m4WZA@mail.gmail.com>
Subject: Re: [PATCH] net/ieee802154: fix uninit value bug in dgram_sendmsg
To:     zhang haiming <tcs.kernel@gmail.com>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

cc mailing lists again.

On Wed, Aug 24, 2022 at 7:55 AM zhang haiming <tcs.kernel@gmail.com> wrote:
>
> If msg_namelen is too small like 1, the addr_type field will be
> unexpected. Meanwhile, check msg_namelen < sizeof(*daddr) is

Then check if space for addr_type is available, if not -EINVAL. If
addr_type available, evaluate it, if it's unknown -EINVAL, the minimum
length differs here if it's known.

> necessary and enough as dgram_bind and dgram_connect did.
>

you probably found similar issues.

It is a nitpick and I see that the current behaviour is not correct here.

- Alex


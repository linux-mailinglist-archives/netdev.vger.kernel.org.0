Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5014B63B4AD
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiK1WMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiK1WMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:12:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1813054E
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669673512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XyrmJ1F/utvSUVmfP47rlqRQaLElV4APNWTroTpMjiY=;
        b=C3kGR2Cv93OdyuEWJ3EK+mzYK5aWGGM+9/n9MbKMlcH5mQZKaACesdIT6xayNxaafJMjUH
        5LQxjVxZQvhDML7RcvW61FYMh7A/3AoHOv3s9WU55VS6/Lj/ZwjkgX5Kh3aJZggCkqEVKj
        DT4E6EHwtJct7Hdh7p9A6pRoGN+H0wo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-493-ahqdX2zeNr-jqQdLaemf-Q-1; Mon, 28 Nov 2022 17:11:50 -0500
X-MC-Unique: ahqdX2zeNr-jqQdLaemf-Q-1
Received: by mail-ej1-f69.google.com with SMTP id qf25-20020a1709077f1900b0078c02a23da3so5064921ejc.0
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:11:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XyrmJ1F/utvSUVmfP47rlqRQaLElV4APNWTroTpMjiY=;
        b=vQThA5UfzYJiGtZr91+PddxKdXwtD9Sh9hmUfvGlsHOW2iIa9hdLTAhkJc02Mp1l8X
         rhBVuIkcZpoos65BsVqRVN/G5YekvauyXmT7ITPofD2Z2G9L3wMp4iJVosxjQzgRxt9/
         RbW9DVxcBMDXTN+PrrrcpUg7LXNIEDJbDpN4Q7PP0ITB9SS70YWzv3OnSBM4+KXGEVOb
         9IOzTBXBJ48Gx26iX1Nja1zxf9jNHNJvMZPtJBSblmmrHQu6nUWiE74SBoGray+yH4aa
         lKZ5EB75ZG02OYQ88L5L5JhC5QMsX+e0VwXYpHf0nzjRSZWyELcdOFje1PNXmPnETJMl
         niXA==
X-Gm-Message-State: ANoB5pkjM00+6X5FLFPUUUwm1nve8IRpNH7b8aHPkstDQgRZb7ZmtIiu
        5oJilgc59XP4VPKSiEjdwZGaifTN3q2FxULFKaewd/XbpmD5UfssAbmX5BzeM/wymD3DGjHEs1R
        YPp5LxUqFmVuvn1a6po0SQnmrIKHv0JTs
X-Received: by 2002:a17:906:830d:b0:79e:5ea1:4f83 with SMTP id j13-20020a170906830d00b0079e5ea14f83mr31094823ejx.372.1669673509665;
        Mon, 28 Nov 2022 14:11:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4KBuqch1h+pApUwwcB54bGUKQ/xvxNXIXEeZ9GTRgIyEnlDRQZHZqaXKSwPCvnaU3idF5IfOQQxBtuvOjgde4=
X-Received: by 2002:a17:906:830d:b0:79e:5ea1:4f83 with SMTP id
 j13-20020a170906830d00b0079e5ea14f83mr31094814ejx.372.1669673509500; Mon, 28
 Nov 2022 14:11:49 -0800 (PST)
MIME-Version: 1.0
References: <20221118221041.1402445-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221118221041.1402445-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 28 Nov 2022 17:11:38 -0500
Message-ID: <CAK-6q+iLkYuz5csmbLt=tKcfGmdNGP+Sm42+DQRu5180jafEGw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/2] IEEE 802.15.4 PAN discovery handling
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Nov 18, 2022 at 5:13 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> Last preparation step before the introduction of the scanning feature
> (really): generic helpers to handle PAN discovery upon beacon
> reception. We need to tell user space about the discoveries.
>
> In all the past, current and future submissions, David and Romuald from
> Qorvo are credited in various ways (main author, co-author,
> suggested-by) depending of the amount of rework that was involved on
> each patch, reflecting as much as possible the open-source guidelines we
> follow in the kernel. All this effort is made possible thanks to Qorvo
> Inc which is pushing towards a featureful upstream WPAN support.
>

Acked-by: Alexander Aring <aahringo@redhat.com>

I am sorry, I saw this series today. Somehow I mess up my mails if we
are still writing something on v1 but v2 is already submitted. I will
try to keep up next time.

- Alex


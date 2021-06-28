Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628A13B5D4C
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhF1Lr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:47:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232353AbhF1Lr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624880700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qs0IkwXZ0zITPgwiK7CWieVxiVM2f2F2V5q9oyTXZ2g=;
        b=E27KDPbAfP+u4EE0ZGDD71X7D3OyUgFs5tbnKblIp11fLodG8Hbz3mGNV2rwMfY5DrcWzy
        3cFux2TqsVMyMFYtcontXjti2pRRuVpZQ/HYUaBjpf+ygqVm4PTFAg8kMzkcGSDpHjC09X
        Pj7TYYVc9rutDHj9VseiuHwGt5xnMiA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-R3UY8DlcMTGJP8Zn6dp3xg-1; Mon, 28 Jun 2021 07:44:58 -0400
X-MC-Unique: R3UY8DlcMTGJP8Zn6dp3xg-1
Received: by mail-ed1-f71.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so2123263edu.19
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 04:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qs0IkwXZ0zITPgwiK7CWieVxiVM2f2F2V5q9oyTXZ2g=;
        b=g60hHLXt91/NIFtx4V9SZDPwm97LtXKBbNvnfmk5D52rIrw1yyVoNIInj0+JBJydPH
         PAGfaW2NDXhNEPGUO+SzdolaN9cz48hn+rgCDBOhfb8omDxzQS7UZlCSGw2S+FInI5Dr
         7Hv6h20L4bnIw9Pr1JOG1r1482zBxVE/Bb+CWud3lNOaqec6XT+2ipRlg4kXyOzWjB/t
         1/4hk7S2n2AlwoiD6DvnAg6wxuNdkO9gb270pByxeRSfmu+k2qI/L3uT6EtM0fSimgbY
         39Oo0iGlMC/4OuK7zMZTx6acIPVHckn5389LAc5bB4sL/NUvAwrV+mqbZ7hjHJSPcNAU
         L/9A==
X-Gm-Message-State: AOAM530PdJIdFow1vmRtTvo33A2ENX/k/kT3oV8WQLKzKfULX9wOP/+I
        TWk3vCrHWo2mHWG3EIEvxpzyrM9e+PKuNcEO4O/hFpMr7VoldLUqKH8n6LoNwmG3I21zAJYAId+
        fI/xXqYjK9c9vZBK7
X-Received: by 2002:a05:6402:31a9:: with SMTP id dj9mr32295483edb.164.1624880697118;
        Mon, 28 Jun 2021 04:44:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvT3SWL9l5IHh+liewKskO+Iw/7c9Jb4A03dE1aldBLaoTpggPmFitC/40BMrKxD5qaLYDRg==
X-Received: by 2002:a05:6402:31a9:: with SMTP id dj9mr32295438edb.164.1624880696692;
        Mon, 28 Jun 2021 04:44:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id zp1sm2190962ejb.92.2021.06.28.04.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 04:44:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B531918071E; Mon, 28 Jun 2021 13:44:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Niclas Hedam <nhed@itu.dk>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: sched: Add support for packet bursting.
In-Reply-To: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 28 Jun 2021 13:44:54 +0200
Message-ID: <877diekybt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niclas Hedam <nhed@itu.dk> writes:

> From 71843907bdb9cdc4e24358f0c16a8778f2762dc7 Mon Sep 17 00:00:00 2001
> From: Niclas Hedam <nhed@itu.dk>
> Date: Fri, 25 Jun 2021 13:37:18 +0200
> Subject: [PATCH] net: sched: Add support for packet bursting.

Something went wrong with the formatting here.

> This commit implements packet bursting in the NetEm scheduler.
> This allows system administrators to hold back outgoing
> packets and release them at a multiple of a time quantum.
> This feature can be used to prevent timing attacks caused
> by network latency.

How is this bursting feature different from the existing slot-based
mechanism?

-Toke


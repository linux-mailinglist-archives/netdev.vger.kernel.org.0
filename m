Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEA94A9873
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 12:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358412AbiBDLeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 06:34:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358341AbiBDLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 06:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643974449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7b9K3gDBQNkMgnuV1ibTAuhV5BJoAvC3sZ1UK0nk2J8=;
        b=g1uEwL8QMIO5u18Lo9itjKHarBlto61Ls87IoC9E2vtT/d4ehkiKbz2J946zsXuGrzQwTV
        JdaCmO5zAmL9MUG8es05SF4AaaqwZZGTVa8Ht9gJL76ngqsxl970Gi9DmkuosBAhB/ouoi
        1t6hEHJEWuTHrgM2ijksGBdTtPG2cT4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-uMsn0rxtOw2Yk8gpiUce7Q-1; Fri, 04 Feb 2022 06:34:08 -0500
X-MC-Unique: uMsn0rxtOw2Yk8gpiUce7Q-1
Received: by mail-qt1-f197.google.com with SMTP id a9-20020aed2789000000b002d78436cc47so4412763qtd.12
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 03:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7b9K3gDBQNkMgnuV1ibTAuhV5BJoAvC3sZ1UK0nk2J8=;
        b=07mPZcKoOgw68uNdkKjp7tByF0fo3NV+qbf/GTq+g5J1lvAbmC+l5aqZYdBbi8wdIW
         b7z4iNKaDp9SK15gcGA1sPHNn03NTN858kdhWCmzGhNqVvO433rpX7wY0SgSzmPSXJdW
         /8KQrFcFRBr0JAJoUfX0WkgjkcmqhMqI8f13O0HoEMRKIREsgNYEDWHuBk4MlDDCHn+A
         aj9tr66//d7HEzZGRgqZgGUH2HGos5NQQIWXnI2CT69jEZPjNSDN7on4ftW2Y4zEyqLe
         HliQhJZTheSbP0tyJ8Qvz2qHjHM3hlUe5uj5f6BQjj294Cx/AfGJKEeFUgIUwauRE1x8
         ISiA==
X-Gm-Message-State: AOAM5337a/lnB1wmGtyXQk+X7yZMFunsTssiVHBfZ1IiDV2WMtNlloVK
        qMg4Esuy62eNYkMw/vHJFIdkR4y9pJKkxd2s83qkVpcTgYyzc/0/fa2qzITylJkBZ/xXROtA9Fs
        LUrz9wjovsmD/ucjsqhGdvvYU4pLtQOdbWlP3W7F6lXBUvuvkkhsvmG7xxFwpUJVaLA==
X-Received: by 2002:a05:6214:27cd:: with SMTP id ge13mr1459116qvb.40.1643974447671;
        Fri, 04 Feb 2022 03:34:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy831ezbgShg858gNd1jufzQCxmNLXuAnxtn24OBml3Am1OhM9J8zYyl6aBsPIe/Ue0z+sbxg==
X-Received: by 2002:a05:6214:27cd:: with SMTP id ge13mr1459094qvb.40.1643974447402;
        Fri, 04 Feb 2022 03:34:07 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id v19sm932187qkp.131.2022.02.04.03.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 03:34:06 -0800 (PST)
Message-ID: <be23f15d43f7af165c7d2121071b09be73740899.camel@redhat.com>
Subject: Re: [PATCH net-next 0/2] gro: a couple of minor optimization
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Date:   Fri, 04 Feb 2022 12:34:03 +0100
In-Reply-To: <cover.1643972527.git.pabeni@redhat.com>
References: <cover.1643972527.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-04 at 12:28 +0100, Paolo Abeni wrote:
> This series collects a couple of small optimizations for the GRO engine,
> reducing slightly the number of cycles for dev_gro_receive().
> The delta is within noise range in tput tests, but with big TCP coming
> every cycle saved from the GRO engine will count - I hope ;)
> 
> v1 -> v2:
>  - a few cleanup suggested from Alexander(s)
>  - moved away the more controversial 3rd patch
> 
> Paolo Abeni (2):
>   net: gro: avoid re-computing truesize twice on recycle
>   net: gro: minor optimization for dev_gro_receive()
> 
>  include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
>  net/core/gro.c    | 16 ++++-----------
>  2 files changed, 32 insertions(+), 36 deletions(-)

This is really a v2. Please let me know if you prefer a formal repost.

Thanks!

Paolo


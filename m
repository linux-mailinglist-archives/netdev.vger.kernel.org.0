Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C0A4A9A7B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiBDN6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:58:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359176AbiBDN6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643983121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLbxnTEWzE7sXh+ZGD7jzx+3B/WLBcYA83W/l1QRC4U=;
        b=X3KQHt0CAwwXusATXgehH7XRpepHtsv/GmvYlcj7Tuh395Hgdeb55xQLly2NHS8oPvmqa1
        XgFPexRg3JccfWoCMpt4ftZ9Er3yvTkLesSukfoaIObiShMqzMTsXe2pOveHaADVpv19ji
        V8+FdT+oCcr3g9Kl3xMPhYuTRSEBDtE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-M6xyPiC2NUKzqOaK9vfUzg-1; Fri, 04 Feb 2022 08:58:38 -0500
X-MC-Unique: M6xyPiC2NUKzqOaK9vfUzg-1
Received: by mail-ej1-f70.google.com with SMTP id l18-20020a1709063d3200b006a93f7d4941so2618888ejf.1
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 05:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WLbxnTEWzE7sXh+ZGD7jzx+3B/WLBcYA83W/l1QRC4U=;
        b=hv2KGljT+LxTwuHq/HXTb7QG4rL02fB92jaEisU+A73gRFtrRcIglSzgwz/o7CaFHB
         7DBAEKYr/7G/OC0kx8Swr1KexWCmWOyH7Bx0uMroBzVcXp4m6A4nmAHtE11tCe+d64Kp
         JyGWrqZs+/eoud/x1DrMKzEe+FdBGgYz0CMrqY2dpuCkM4DGHtZDu5ujsKOfyHkSuFsi
         UhdhlGM4P3Y1iJEJlE4V03RWxOWsujFULlLGB+57+GvY3hdWjyDZuEloGjD28WNBpHPP
         BTCw3dkJIKdWorRKI3VFjCfmF4c4PjKD+isfDqeGA1NPPqh99qVbvMN0c3/RaSzFxkD8
         y5ew==
X-Gm-Message-State: AOAM533TjqNwTiB/z6SZ/bLRIpMlOFegFNfA+28pg70S3rb8JJzuc4S/
        N6Ov6VVt8n/vcqwMc8a/djGtYHDVvalC4lJCtsVkoDJY4IK6smIscf8xrh75nIOPoW8+V/Avyye
        2mlkw3NvI+9yYgG8K
X-Received: by 2002:a05:6402:718:: with SMTP id w24mr3174782edx.35.1643983117527;
        Fri, 04 Feb 2022 05:58:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoaPbr41esNuScMlKwNkrKVAaStpUmpKfegJQaMuPcjoR6FXmgChBgBA5Q9UHH+DQUclITNw==
X-Received: by 2002:a05:6402:718:: with SMTP id w24mr3174750edx.35.1643983117083;
        Fri, 04 Feb 2022 05:58:37 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j15sm693326ejb.9.2022.02.04.05.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 05:58:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 86F2D180703; Fri,  4 Feb 2022 14:58:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: Re: [net-next v4 00/11] page_pool: Add page_pool stat counters
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Feb 2022 14:58:35 +0100
Message-ID: <87fsoybuno.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Damato <jdamato@fastly.com> writes:

> Greetings:
>
> Welcome to v4.
>
> This revision changes stats to be per-cpu and per-pool after getting
> feedback from Ilias, Tariq, and Jesper.

FYI, Jesper is on holiday until the 12th, so it may be be a little while
until he gets back to you on this :)

-Toke


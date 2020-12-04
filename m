Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F63F2CEDFC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgLDMVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:21:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728722AbgLDMVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:21:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607084379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R4OGEJo66P6rsNAhT6jP92o68BJnxBUwibF+4bWbC2k=;
        b=R2IMc6Nl37zQf80+xuT2x4HMTBeSmMNRuNeN46eKD8GGfIfJPzunLbnnlPdmzz/yv9z04v
        MqvsdoAkc5JkKswxdLvB/g8kf7xgwqOruLgSsMoF6sV1LDQrZhvHhzSQzTJ6W8gtpBu5H+
        NVzfrGklRHfmdqEOPdjxO1ATlQbuNiw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-bucTNxebNqGN7XiXLJuEGQ-1; Fri, 04 Dec 2020 07:19:38 -0500
X-MC-Unique: bucTNxebNqGN7XiXLJuEGQ-1
Received: by mail-ej1-f71.google.com with SMTP id p18so1990000ejl.14
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 04:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R4OGEJo66P6rsNAhT6jP92o68BJnxBUwibF+4bWbC2k=;
        b=dkQg1IF/KOrzHmbv1KjzxMWTfmyy6g6bjbiWxf4o0rYSaE8U9WZo1JczdXijbQBq/W
         mO7Pvj4vbHMlmIvUz74ADPmCZNRAtAepP+vyVYBCzBr3c2N2i6GvOXDsCv84q8QGwzF0
         VsD3aM3T3iDeFBz6+LlMndJr8itxCW56UQw9OobVwL2nFMCceA6Hl3oev24pb9bX4dZA
         BbdLRtO8DqWePBj4zuUGfmD66JNFzvvZF7JYkYNB+RDawnFa7jKvEwuxyA9AIYrhrDvN
         MpU5uB00HYKjCG0XbX30TnQeOLB7jPEWFtd45uGeX9eLBBJaYMyS5L9EPb1P+vCj7KpI
         D1pQ==
X-Gm-Message-State: AOAM5336n0aasRoaeaUndZUwUKanknijRI/dkwq3xGis5K7xc+6NS0jv
        boEfW3w91/j2AiYxIzMexI1tRPUYVKdTisFI9lto7YgpWmqWwGA6pJ+DYYItpEgDjw/4wIsH+lm
        VqG/PcQz3al74D2sm
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr6819055ejp.190.1607084373992;
        Fri, 04 Dec 2020 04:19:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHftUesGbbLZt8khqeFgqcDmh06X5sj1NJhXevWW4Jj6/igg4fia1bqWrg5ljp1M1eXKTFOw==
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr6819030ejp.190.1607084373603;
        Fri, 04 Dec 2020 04:19:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e27sm3007351ejm.60.2020.12.04.04.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 04:19:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 91941182EEA; Fri,  4 Dec 2020 13:19:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        davem@davemloft.net, john.fastabend@gmail.com, hawk@kernel.org
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 2/5] drivers/net: turn XDP properties on
In-Reply-To: <20201204102901.109709-3-marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-3-marekx.majtyka@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Dec 2020 13:19:32 +0100
Message-ID: <875z5h931n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

alardam@gmail.com writes:

> From: Marek Majtyka <marekx.majtyka@intel.com>
>
> Turn 'hw-offload' property flag on for:
>  - netronome.

Can you add this to netdevsim as well, please? That way we can add a
test for it in test_offload.py once the userspace bits land in
ethtool...

-Toke


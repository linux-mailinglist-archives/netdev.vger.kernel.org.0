Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7DA427A5F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 15:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhJINCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 09:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233007AbhJINCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 09:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633784456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TxE9m5aYXtKfNuO+X2fqVFFDNojWLjMdEQaFvgTCPeI=;
        b=JUZzdgIgrGdDfnCEe8lyQiaGdxdFSNAg10q8e45TJTr1TjwqiRaLgSbO5Ziak0v4TuPzd9
        3LMdTGIzwZK9mEV756I+4rPasbISol6JuCVDnWDKyjKO2ZQmfdYgkMkg5c5vcKpEJRMVbZ
        XM6Ebuq2IZnJ6H9gmpPvQRmQrpdzoz0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-nXKqwwOxOpaoL8iTdCeazA-1; Sat, 09 Oct 2021 09:00:55 -0400
X-MC-Unique: nXKqwwOxOpaoL8iTdCeazA-1
Received: by mail-ed1-f71.google.com with SMTP id z23-20020aa7cf97000000b003db7be405e1so714668edx.13
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 06:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TxE9m5aYXtKfNuO+X2fqVFFDNojWLjMdEQaFvgTCPeI=;
        b=RzXmiM77S6J4vbgRi+9/W9PXO1YpQymGdknAcygy3WZ3xR0GTbgMhdShvzBWARFiDK
         C6PLAtJ+ki59BN0646xg0qCCzDJ76dTBtNGOsGkzVowe+khNVJ+89eYfUURbGXlWngUx
         OC1PSyz36mkRc0soRAPIzLLyheUpDiCK+V+nwYxXhZDfHD9Nu6bqhQLCygytyY5B2rZV
         YuduIYyh9h/7n1ux2vXMO6k9+uRU/cyYFhk6woYndUjVZ0vANQknJGJBBWk2wAp/R2Rv
         GwaMil1VNi/hoKvt1aCVTY7lDWiP/UG98Lnq4aGMpBUnhH5jJsCyd/d0YWYa7eLrqJtD
         mIFA==
X-Gm-Message-State: AOAM533MABTiiP6Bo0wlkX5qf9Jk4SqQuCEIrRqhYfS9pqTgGV+MPu1H
        qIteqdoH2z6CD0p7KS0bGPYktVPZqXQWNJOKoivZR3l+3poal5EtFFX+BZUN9l8MTZxYHJSn6aM
        3NUKoJ5PJh8xUk/YE
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr11174966ejb.376.1633784454008;
        Sat, 09 Oct 2021 06:00:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPq2L+bdkdSy8B7h+GmWF6WWzJZw1V4PU7bCQcYyTEnjTroCBh38Hp4igxXWqrpZsuxUtV5Q==
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr11174913ejb.376.1633784453676;
        Sat, 09 Oct 2021 06:00:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e22sm1215054edu.35.2021.10.09.06.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 06:00:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 05E11180151; Sat,  9 Oct 2021 15:00:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v15 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
In-Reply-To: <20211008181435.742e1e44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1633697183.git.lorenzo@kernel.org>
 <20211008181435.742e1e44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 09 Oct 2021 15:00:51 +0200
Message-ID: <87fstajqt8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri,  8 Oct 2021 14:49:38 +0200 Lorenzo Bianconi wrote:
>> Changes since v14:
>> - intrudce bpf_xdp_pointer utility routine and
>>   bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
>> - drop bpf_xdp_adjust_data helper
>> - drop xdp_frags_truesize in skb_shared_info
>> - explode bpf_xdp_mb_adjust_tail in bpf_xdp_mb_increase_tail and
>>   bpf_xdp_mb_shrink_tail
>
> I thought the conclusion of the discussion regarding backward
> compatibility was that we should require different program type
> or other explicit opt in. Did I misinterpret?

No, you're right. I think we settled on using the 'flags' field instead
of program type, but either way this should be part of the initial patch
set.

-Toke


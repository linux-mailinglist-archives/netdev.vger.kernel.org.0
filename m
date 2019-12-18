Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A981245A1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfLRLUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:20:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbfLRLUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576668048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3as0fMepjXKiH9hYeKlkTzZXSRWa3b2rrvx/TlzOdnc=;
        b=N/2mNdOYgLGSM4M1KKfqpyYASic9rTGK3xW/1wSsBJjimlvK762f48Y3Ogi9694xmO85gi
        P+5sf8gnGdc1daIHpp7sKlpUK0s1Mnk44+PZuxHCsE+UvHuBguI/NzhKjQNs6LRkvU+AsQ
        ysBX7iv7zD5imYOoANo2gL6C5o52KRY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-qnSziQt0NW6kwZoNQe6gkA-1; Wed, 18 Dec 2019 06:20:45 -0500
X-MC-Unique: qnSziQt0NW6kwZoNQe6gkA-1
Received: by mail-lj1-f197.google.com with SMTP id j23so576532lji.23
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3as0fMepjXKiH9hYeKlkTzZXSRWa3b2rrvx/TlzOdnc=;
        b=WcVlLidZ7oZaz0izSFNPn6+7Av7O3zCj5CLQ7fXg4AvQk589F62WFRUJCKnw9Dunnd
         hWnnErGk33oHawihAYMiliDYewxlqW8sdGFtueV4qgV5i/bomkqfYBG/wOXMESgvynYN
         y9SodVHbQSsbPNY2nMKDTz2rIn/VJ60j/j2IVX/fTRpHCBxQSSlwhIyQFWY4UIjfs7jG
         TkeuiDYayvnJUVDVRN1ijmPbqA+NUSFNvmnAmIGm1GjFC2yhHapNU+J3NrfYMKH7jdNz
         vnGmt6ddn4hddQI9DkWKv2x7QyRlCGJ4ADhQW1ELLPGoXvYfxY/RiQIPH7HCir0DYxBY
         +awQ==
X-Gm-Message-State: APjAAAW+azY6Pp0vhNEX8K3zf/dDQWZjRMC22KcR02OlNV+1KzgZ4EyJ
        yKu5U7YQKZwTn5hMlGcFpCDBGEggSGc0gE6mX0P+vCbXNQGaCPVkPvZ3tKE2UYsGV0ZMExWaQsk
        zcd2sYS64Nk5ItBsR
X-Received: by 2002:a2e:8745:: with SMTP id q5mr1365606ljj.208.1576668043912;
        Wed, 18 Dec 2019 03:20:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqwT0sB2A0HN5RirCpDjdI6buBQBKUL1wmyz2cbpK4RtNgJzszK5rudZ2tx2g/YsmVeUorBvew==
X-Received: by 2002:a2e:8745:: with SMTP id q5mr1365592ljj.208.1576668043811;
        Wed, 18 Dec 2019 03:20:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c8sm968308lfm.65.2019.12.18.03.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:20:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 98EAD180969; Wed, 18 Dec 2019 12:20:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 8/8] xdp: simplify __bpf_tx_xdp_map()
In-Reply-To: <20191218105400.2895-9-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-9-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:20:42 +0100
Message-ID: <87immd6fsl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The explicit error checking is not needed. Simply return the error
> instead.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


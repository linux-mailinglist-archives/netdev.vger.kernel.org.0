Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1210E3E8CFA
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhHKJNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:13:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236661AbhHKJNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:13:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628673178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXwE7CHo/JY+uapmOrMsy/SWDFuCzkqxTC2MlTmyXRU=;
        b=S7VKN/QlZqYQzBSehUGicvWPmW18RhhIecaIxR4Kfs5M8AN6eOVLsY+Ic1wcQanKU9A6cz
        0ZEYP1jJQgS2dEQTrgin4wnSalfRewIcmj2VH0tdiNf+6J4a/d4G8ALIsfKnhMbH3wPbCK
        27GjirIe5qqa9Qt57mXiWz2UKMBmO9A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-BJu5yBiLOPWzFQrukevUcw-1; Wed, 11 Aug 2021 05:12:44 -0400
X-MC-Unique: BJu5yBiLOPWzFQrukevUcw-1
Received: by mail-ed1-f70.google.com with SMTP id y39-20020a50bb2a0000b02903bc05daccbaso912957ede.5
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 02:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xXwE7CHo/JY+uapmOrMsy/SWDFuCzkqxTC2MlTmyXRU=;
        b=reE0cQhq5TER3XP4Dd5SwQtxf42eqO5qVVD9LUJtDl+8Gx8MsfZfcCtXPdfFpToqwm
         ReqZ3yU7HVpiNdOvsRfwJsBT8ekRJAkb79AXiK3uCa9MVVZTIarkw86ni+t0QO3Vpzs1
         6ZzASeNbSWTpglgFRs4Ds6IU/Vx70sNBodMj5ojboQ09fWHK/cxm//viVO5/LtDKA//u
         85Bcr7E6RHXuySg1Em1/otr0YD9xhwbQpcNREc1XsU+7LwmH80K4jx/IcyuFSVulc0Do
         DsnLW/YFTk60LBY+G1c9uKVLtJgvjngzVorqTPAabCbGTpUu5x1k1BMrxt9IyQ3k43Rn
         3ADA==
X-Gm-Message-State: AOAM531T9DnG8bWm4AUUiaBy1uesLZKCqnUpnnBdDDBMea3nzFxjcw8Z
        E5VHNjhPwk9NVZO+hDRMFZtQImXxPaT1Lz4ESEs8Ez4wcVwdnHqCICBD/dWBGp8sxC6MyfBesW4
        2HSIkDHEFgZNNUTL7
X-Received: by 2002:a17:906:b1d3:: with SMTP id bv19mr1140413ejb.361.1628673163552;
        Wed, 11 Aug 2021 02:12:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOBdpK/bCd9lXs8Es1fYDQDN9tg88WZ+etc/k124zb/U4oV6dt2a1qRBU8C9IEa088GmY3XQ==
X-Received: by 2002:a17:906:b1d3:: with SMTP id bv19mr1140394ejb.361.1628673163432;
        Wed, 11 Aug 2021 02:12:43 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id ee11sm8306374edb.26.2021.08.11.02.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:12:43 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:12:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 5/5] vsock_test: update message bounds test for
 MSG_EOR
Message-ID: <20210811091240.jbum3572eelgbbpi@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810114119.1215014-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810114119.1215014-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:41:16PM +0300, Arseny Krasnov wrote:
>Set 'MSG_EOR' in one of message sent, check that 'MSG_EOR'
>is visible in corresponding message at receiver.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> tools/testing/vsock/vsock_test.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 67766bfe176f..2a3638c0a008 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -282,6 +282,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> }
>
> #define MESSAGES_CNT 7
>+#define MSG_EOR_IDX (MESSAGES_CNT / 2)
> static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> {
> 	int fd;
>@@ -294,7 +295,7 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>
> 	/* Send several messages, one with MSG_EOR flag */
> 	for (int i = 0; i < MESSAGES_CNT; i++)
>-		send_byte(fd, 1, 0);
>+		send_byte(fd, 1, (i == MSG_EOR_IDX) ? MSG_EOR : 0);
>
> 	control_writeln("SENDDONE");
> 	close(fd);
>@@ -324,6 +325,11 @@ static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
> 			perror("message bound violated");
> 			exit(EXIT_FAILURE);
> 		}
>+
>+		if ((i == MSG_EOR_IDX) ^ !!(msg.msg_flags & MSG_EOR)) {
>+			perror("MSG_EOR");
>+			exit(EXIT_FAILURE);
>+		}
> 	}
>
> 	close(fd);
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


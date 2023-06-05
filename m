Return-Path: <netdev+bounces-8225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C1E72328E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 083B12813FD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7D32770E;
	Mon,  5 Jun 2023 21:55:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09668209BD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:55:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D47BEA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686002125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=QBUMStz/LZgqaDGB+q2rG5JxzOVKITks9HtXigkhBl0=;
	b=WyExicnKZ4zVlJy+VOOW9ocE74aO0a+k8ON0dxY1wsbi9BXn3Q+2RqitU86MUzFcWqrkSh
	zBEA6oozYYcweh1n4fJeP5AVYPRdOrNCVni5i5ab5vQ3s46HVzx6kVz9dorLWkfURqFKb3
	s24FqmrDyHoLqI30TOGMKEYjKXik1AM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-V_L3EOFYNgmflKTUR5crlg-1; Mon, 05 Jun 2023 17:55:23 -0400
X-MC-Unique: V_L3EOFYNgmflKTUR5crlg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5df65f9f4so26272685e9.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 14:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686002122; x=1688594122;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QBUMStz/LZgqaDGB+q2rG5JxzOVKITks9HtXigkhBl0=;
        b=fWZGjSSN22Vl9qr0kGNIMXyGWXQ1wzHePQoLMWAyOZdUnp9CLzxpy/u1UUkdLN2vx0
         q1MWE+JpinqWaddQ3+zjf1NJEi21kGYLbNIR8ODNximXPtsEyR33c19jmn7UDtC0+6BZ
         z4JW+RIM2VK0hKQ+M2kvlXQt/f3JqoY2GsEXp/MNrdO+Sc1BAxHSwPJApSXpK2NEXghs
         njZ0qkmsM9K/xN5OcEeCitQK0muZi8V2K+Y9855j/lMvvklHyPoIATmfHOeaAJQqFYaq
         Q56jFx8az1icKltYw2fZStu7rTQvjc/Hvbkm8l9Nca8ZkACIC0EcZnWHanEsGvPM5m55
         Lu4Q==
X-Gm-Message-State: AC+VfDwH50vaTibVVL76tOg/T+bJLcaXsmX9uFjmA+0iy692pyNiInp9
	ktUksduAyaRr4jteM8+nmxIz6L/srb22FQA1TyXHSwqK/vgsvchkE5y1ChtGTU/NULkPzqnPzzH
	G68DoBsTgq6OeY/8MkvN+rarM
X-Received: by 2002:adf:f011:0:b0:307:a075:2709 with SMTP id j17-20020adff011000000b00307a0752709mr114372wro.68.1686002122189;
        Mon, 05 Jun 2023 14:55:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5q+1RacvUhcy6JAF9iuuGv6phbwO8alzAKNr3/xRXus7zDMAUx80WCqAb+KZzcyNInJ2c3Yg==
X-Received: by 2002:adf:f011:0:b0:307:a075:2709 with SMTP id j17-20020adff011000000b00307a0752709mr114364wro.68.1686002121904;
        Mon, 05 Jun 2023 14:55:21 -0700 (PDT)
Received: from debian (2a01cb058d652b00e108d67e5e2d3758.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:e108:d67e:5e2d:3758])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c248400b003f604793989sm15563344wms.18.2023.06.05.14.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 14:55:21 -0700 (PDT)
Date: Mon, 5 Jun 2023 23:55:19 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 0/2] ipv4: Remove RT_CONN_FLAGS() calls in
 flowi4_init_output().
Message-ID: <cover.1685999117.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove a few RT_CONN_FLAGS() calls used inside flowi4_init_output().
These users can be easily converted to set the scope properly, instead
of overloading the tos parameter with scope information as done by
RT_CONN_FLAGS().

The objective is to eventually remove RT_CONN_FLAGS() entirely, which
will then allow to also remove RTO_ONLINK and to finally convert
->flowi4_tos to dscp_t.

Guillaume Nault (2):
  ipv4: Set correct scope in inet_csk_route_*().
  tcp: Set route scope properly in cookie_v4_check().

 net/ipv4/inet_connection_sock.c | 4 ++--
 net/ipv4/syncookies.c           | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.39.2



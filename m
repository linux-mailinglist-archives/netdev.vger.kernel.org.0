Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BF9CF822
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfJHL2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:28:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40275 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfJHL2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:28:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id d26so10089719pgl.7;
        Tue, 08 Oct 2019 04:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=qqO/jZwlHVXpe/juL/b12QY/whEWEBOd7gF7fO+RrZ4=;
        b=b5BEVxZ6WyBnrUsiGClLcYahexpru7MwnDvqwwiqTLU1kKjQti5d+0DI/FMTqwzJIs
         zYmVmMvh+boKQ4rpo3ZuFqHGxa3WNAElkSwTDqgKfsPvnMFj9j4Cfyz3Te289quhxaQ5
         YlShYN70l0nOTgB2eCsjBJqt8LSdQRxKYjHtkdchWSAaBWtQ7iS9PuTnq6eAogkuMQ56
         YGVvORGWFoMYc29QRLbVfEhITvD8ojOUFVf0LOvX7FZ6CwfHkVEN8OI5AILg+POEdsxi
         DwzhcFSPiw923kg5ykFRCQt8FdGWJVYEq/HB9YDpM55xzvx/SrH44M4TMatYHHuhK81p
         aPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=qqO/jZwlHVXpe/juL/b12QY/whEWEBOd7gF7fO+RrZ4=;
        b=pwno7sY0r5rBIlUf8s1OcEtFj8xilh0g4bOVenw/GcI4WVWCG2xBLuKvKef5y9WAk7
         UsYk3M85p7+hw+bvcrCnuh1Qk9hIw2REaTtG5zlyW0C22ix9L0USGWm4YoFw6A8/nhoY
         /gFLOvj68XbJK0wYtzwpR/6X6o6NNFPaPVSa/BbKz8V+esC+PlNVRUptNm0Y1aKHV9vb
         rSBAm3i2kpLWADKNQPq5o6z4wkIxeYhyAquXa/LoK1xbk3xFX18S8LNosWJ/8aDv7Z+r
         gbuYOutG+ZvmkaHQTwPN/5BWZWwKxt5eW+M+EJ9nXwAsywARnUDgWQ8w8GVcAvvNPCBj
         IMaQ==
X-Gm-Message-State: APjAAAUz2bhPzq976AaJfCxpWyiKSZg6UthGjZGKCAVKvB7LVaKVD4cX
        dl5V+gKaL4Zm1Q8EwaVpU01CQL+q
X-Google-Smtp-Source: APXvYqy0QIswpKiL6h1mCjm0mra77cz2X+k8QpYMX39uHXqTzTKZt3mcmewXS0b6IvT7qOGJavmCsA==
X-Received: by 2002:a17:90a:17cb:: with SMTP id q69mr5150846pja.135.1570534089839;
        Tue, 08 Oct 2019 04:28:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n15sm781753pjt.13.2019.10.08.04.28.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:28:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 3/4] sctp: add SCTP_ADDR_MADE_PRIM event
Date:   Tue,  8 Oct 2019 19:27:35 +0800
Message-Id: <52fca36c494e075b2d40781ada8669252125521b.1570534014.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
 <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_ulpevent_nofity_peer_addr_change() would be called in
sctp_assoc_set_primary() to send SCTP_ADDR_MADE_PRIM event
when this transport is set to the primary path of the asoc.

This event is described in rfc6458#section-6.1.2:

  SCTP_ADDR_MADE_PRIM:  This address has now been made the primary
     destination address.  This notification is provided whenever an
     address is made primary.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 0d3d7ce..1ba893b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -429,6 +429,8 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
 		changeover = 1 ;
 
 	asoc->peer.primary_path = transport;
+	sctp_ulpevent_nofity_peer_addr_change(transport,
+					      SCTP_ADDR_MADE_PRIM, 0);
 
 	/* Set a default msg_name for events. */
 	memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
-- 
2.1.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00813845D
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 02:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgALBA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 20:00:26 -0500
Received: from mail-il1-f180.google.com ([209.85.166.180]:34482 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731826AbgALBAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 20:00:25 -0500
Received: by mail-il1-f180.google.com with SMTP id s15so4964447iln.1;
        Sat, 11 Jan 2020 17:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=h6IeiS9Z/qollPN5983Y17mtG8+1nDOJtfV7xMDK8rs=;
        b=D5w6fUEcwjR6a4lqNgXVMYDeg2d15cGKQvVTrvOT1TSLjeKErg3J1hNQh0wrUsHu8l
         hJJxvW5VyyNbLSr5pRX912L8OQ3pffHHjtMWgEwICrVVbc5tYu/fSPSnvDj18fjQJrm0
         bi8+rveRKWDPZmvg4C6aZBdxW54jj0iyzY901MNLyiAKPjI8gYsPc0mN7VLOIRfDxGVw
         a5P5PMSEkTVGD2928Y4PWBJcA6jvp1x9WR8u5vS0BXB8Zq1F9Yvxl54ygMr/HZIA3nBD
         A6ryUQdYTeo0JRnFuJ6UzUDC3B7o4JSiHouaOJjhuJyPW6+/1yYwrTKefQJBbvqidqBv
         7XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=h6IeiS9Z/qollPN5983Y17mtG8+1nDOJtfV7xMDK8rs=;
        b=kwmTId2lhdh9gXO1aVIQnPHMEG4FRCvzYhSMjabQxVBTGLtSspc1wsHPvsEST/Qy8B
         r0rKr4B4XHg8JYaCkdeOW80z9DxrmWHzRR3Haami80ZE8M42+cwXUGrRRIbxPc48WxJk
         LwCOvjf2lCbX5rEyAqVHgS5jm0WHnLzhTW2gNlWDT+WmZUA7y+qe3VyWI+8OfmQIWBh2
         Tz6wjEc1Mw71PvVElT4C3vMqWc/qT/vOUN7orsE4Ug7xTlNtEFAn6CMp09QK1qF1BpFk
         im7u5OCm2UmynxO8b67XriSwyyf84pQNDk8XMyfvWpTJp/Rq5675Lf9tTLkKk4mtoTkK
         /hPw==
X-Gm-Message-State: APjAAAWp6Vgagw4UJV2ThUWTQKAA/Ghh3MnK6qhsMBMot0uvyA+A9G1x
        fQRZCIFliJhHaPfZztZOwPA=
X-Google-Smtp-Source: APXvYqxDUPCgOydEBHn5QsPY22t0QwoyYRnMnU9nK+5UPoLBFEmY9pKox902ooGfVbQKzv6PeLANAg==
X-Received: by 2002:a92:2804:: with SMTP id l4mr9140728ilf.136.1578790825045;
        Sat, 11 Jan 2020 17:00:25 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j79sm2253689ila.52.2020.01.11.17.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 17:00:24 -0800 (PST)
Date:   Sat, 11 Jan 2020 17:00:16 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a6fa07e312_76782ace374ba5c05b@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-10-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-10-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 09/11] bpf: Allow selecting reuseport socket
 from a SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> SOCKMAP now supports storing references to listening sockets. Nothing keeps
> us from using it as an array of sockets to select from in SK_REUSEPORT
> programs.
> 
> Whitelist the map type with the BPF helper for selecting socket.
> 
> The restriction that the socket has to be a member of a reuseport group
> still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb set
> is not a valid target and we signal it with -EINVAL.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>

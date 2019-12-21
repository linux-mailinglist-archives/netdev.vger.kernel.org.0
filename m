Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A600128AD1
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 19:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfLUSf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 13:35:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfLUSf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 13:35:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576953354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vp2dwb2dp9pO50qNpYvUvVAVgFCrhMpYv4jKcSrPHdA=;
        b=D2ioMYcYKLeH2XvAWrrlk1LrXPFyJU1nT7LpYD8dldC7dmSO4YkJRA6Hs2bnIweTE3TRy9
        kPW4BOW5mqtGrEW7rjmj2N1PEq6UxYIkn83QJnnAsRnB+Op26J2jMk2zAMuQK9ZN/AyVVk
        1ti/G10luZETXXOutnXULyLPlKg8qWs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-koV-A2zNMsGZTGV8PTEBiQ-1; Sat, 21 Dec 2019 13:35:52 -0500
X-MC-Unique: koV-A2zNMsGZTGV8PTEBiQ-1
Received: by mail-wr1-f72.google.com with SMTP id z10so1341980wrt.21
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 10:35:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vp2dwb2dp9pO50qNpYvUvVAVgFCrhMpYv4jKcSrPHdA=;
        b=INP3qkOhVm2idGrd/BXU9knSMZ5Xckym6Tu6h07asArTTAsDW+rMTXFS5cAeA9EYWT
         FxfvjNzz2PrqEr9hErVTTLq/eJN38Ukj1m3f+SJVmzz47NnLel7ZnWx/4KCNR0gxFq1V
         ZjQmrSVVuAe4h6TL4oH9+4EeEibwk5A1gajbkiUYah6ywzZ3R5esLGs78tLk9T01nsIM
         fZyziBiWGiQvQ5kixwPWm1NvBlszUxZlg5mdU+ltG9Xf1/zdPshLT3vkBark4875pOrD
         lxXwJhNn64D6vqL6lRWUTuIOCfORZrgFiSRY8GK9yQMIgeggEUkD1cun1jty2yuC/zAw
         EhYQ==
X-Gm-Message-State: APjAAAXXtC9Um85Iidfp7jGnMm+kY/oaPKLERj/BvTKKA+floAf6vIzP
        lkRKUjTeqKMZsMKkdMzQqgsUQdMqzwGgj0NbXK/KRth0WysPZpwo5uBvL0ZLSg5wuNfp3S37FSq
        aiVfwjj7SdofcjlJT
X-Received: by 2002:adf:b193:: with SMTP id q19mr21839861wra.78.1576953351981;
        Sat, 21 Dec 2019 10:35:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqzEQy+M0v3dqr5JkC2ATI/KNLC2pLt/F2zgfTzGsJVy/BF6Ny5HwkwvsLoOggIVz43WLpAubA==
X-Received: by 2002:adf:b193:: with SMTP id q19mr21839846wra.78.1576953351815;
        Sat, 21 Dec 2019 10:35:51 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id y22sm13775678wma.35.2019.12.21.10.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 10:35:50 -0800 (PST)
Date:   Sat, 21 Dec 2019 19:35:49 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCHv4 net 3/8] gtp: do not confirm neighbor when do pmtu
 update
Message-ID: <20191221183549.GB7352@linux.home>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191220032525.26909-4-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220032525.26909-4-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:25:20AM +0800, Hangbin Liu wrote:
> Although gtp only support ipv4 right now, and __ip_rt_update_pmtu() does not
> call dst_confirm_neigh(), we still set it to false to keep consistency with
> IPv6 code.
> 
I guess this explanation is ok for GTP: it seems that the current
implementation can only transport IPv4 packets.


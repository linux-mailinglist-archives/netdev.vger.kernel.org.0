Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FC9282107
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgJCEHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgJCEHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:07:35 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7109C0613D0;
        Fri,  2 Oct 2020 21:07:33 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id p15so2733614qvk.5;
        Fri, 02 Oct 2020 21:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WuTZDjtW9vPhfRcmR9fh2XfQu/0tEe0nor9jQ7O6gyo=;
        b=vgKz+c1i067T2MvkgPGTweTesleE1GG1S3hMH5OD0mvR0L0ftilGOHD9H8jyCKbTUq
         HoSCbVvas6NO5QV0i0oCCA9vTQxEkLTzFsmnVIRicyJDa8B7BsYfWpuDTtH0nmjJVUI5
         ZtMB4XCsUqbvQb6uNOl7yzR6PXotN4mUQsXtRomdrU4UYYjhR9/B8olky5fzhhR/YQr6
         7E4mujoBRhTeIzbIC5GGjr2r4fc0hpodQS7ia5hEUbAqlXwPGXoghGYtn4Xm+FTxgroY
         aAGKdYcN9IxTzPJbgp3fg50n7YLZ2GKzRfYGvNRYL1jWIYj6OGUF26xpxNOjpQPvol6/
         MRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WuTZDjtW9vPhfRcmR9fh2XfQu/0tEe0nor9jQ7O6gyo=;
        b=ZHmRde6jW6KBfZHnJ+lv4s6fO7cmUU5Y697qSJ8QTErpFHPUp/d2umChfOHVM5KQwY
         vhae78AsP7087NCRMZi1Uqat4tMzQtXLxysL8fcvc5Q42jJkqAmyxWLtXKwQtFuHmVd2
         oChN1YfHo9gBAHoU7rMpPVjP6rNtDteCg4yVJuEXDvUBmU9GXSJK91O372juQqI59Qfm
         clznNNvKSC7bKEOZaKXY+1lmmDwjYlGMSqe7XVq14MtOBGRswh29oCXAw1UVfLa/kTBt
         0sNQCv/0a87W4N/fB+2fbutrt861JXz8L3Hj+EUCt9Fj9BikAMsAJKCWoBioToWJ6F0K
         pb+A==
X-Gm-Message-State: AOAM531Ir3SMjGQ8j38YHX1c1Z8/YZ8cSRSroArCcW8REmi90U2ZNhh8
        ednMFTNB836h3siSb75/qIE=
X-Google-Smtp-Source: ABdhPJyxyDTuHKqrqj3ePR3MjeCIO2nr+4QpFEfGbI66KkW2OYso1kSImrDSOXuRsdBYnGyM8xPTCQ==
X-Received: by 2002:a0c:80c3:: with SMTP id 61mr4875449qvb.23.1601698052909;
        Fri, 02 Oct 2020 21:07:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:4433:ca7a:c22f:8180:c123])
        by smtp.gmail.com with ESMTPSA id x25sm2592784qtp.64.2020.10.02.21.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:07:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D3DAFC6195; Sat,  3 Oct 2020 01:07:29 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:07:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when
 udp_port is set
Message-ID: <20201003040729.GF70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:49:03PM +0800, Xin Long wrote:
> sctp_mtu_payload() is for calculating the frag size before making
> chunks from a msg. So we should only add udphdr size to overhead
> when udp socks are listening, as only then sctp can handling the
                                               "handle"   ^^^^
> incoming sctp over udp packets and outgoing sctp over udp packets
> will be possible.
> 
> Note that we can't do this according to transport->encap_port, as
> different transports may be set to different values, while the
> chunks were made before choosing the transport, we could not be
> able to meet all rfc6951#section-5.6 requires.

I don't follow this last part. I guess you're referring to the fact
that it won't grow back the PMTU if it is not encapsulating anymore.
If that's it, then changelog should be different here.  As is, it
seems it is not abiding by the RFC, but it is, as that's a 'SHOULD'.

Maybe s/requires\.$/recommends./ ?

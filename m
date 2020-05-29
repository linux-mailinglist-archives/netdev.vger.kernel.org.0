Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41F01E86AB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgE2Sbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:31:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24607 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725839AbgE2Sbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590777109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bq/wtvpYAVeNzKGvMSqxNUR+BQj7jca0UzLqrOzrSyc=;
        b=fISMsJADwJr6kC7rAKfisIACTxCy7aUN6j9CufIanXu1hl6vk+DmMELATQWguXvVEr3ebR
        cfvwwOyHAK59o1U4RsN0YccxkzfzsXVLbvSjWWkZt187c1yMv33bQbFrR/WOYz2aKrmo1o
        b086ei+M/tHzIQLS6Z5Hfj0BSESQUw4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-m8gOahlNPuSrCJ8r-RilMw-1; Fri, 29 May 2020 14:31:47 -0400
X-MC-Unique: m8gOahlNPuSrCJ8r-RilMw-1
Received: by mail-ej1-f70.google.com with SMTP id u24so1257741ejg.9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 11:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Bq/wtvpYAVeNzKGvMSqxNUR+BQj7jca0UzLqrOzrSyc=;
        b=RI77VSJYS8YK4TjYr7eoS35z6hbuSe7iqsSbC+eTU/N8RFFekhENdReOk+OBK5nx10
         F358/zODtmQRC+eJLOi/EFYQriv2ZU4v3EKkZhCVuU1fsbmIvKkgzQb18MPatqCAvBN+
         9d/ahlQ4JUWOKo/bfqTJqe5d2XImS5K2yAEmqO/JI9uaRQ0NISXOIFUQ6L0q72trSIF2
         bu/QKKB3WvaRVwc95x5x5kggS+KXYcciVfBaBDDeR5T+Dsi1TTpUyuXSrw+clgepnfFQ
         fhkUbisUMS7UmhssrCVF6A9dXh5BYPtqXmpadiNBBHOPjRL5Nt78jFxvSzmNULCwEtGd
         FubA==
X-Gm-Message-State: AOAM532kUCpgx+vBbThV+5Rp3TH9ciTcJH2rhHBe1dHVAxqBQP66RZdD
        kGgjxWfds3SEdYT3EayGFKlaBxShkv3QLRoEmXwEBVwx50gGtt/2MIbxupSwEOvQOsJUoXDoFrS
        WNA2uwDSpX7s8XA26
X-Received: by 2002:a17:906:9707:: with SMTP id k7mr9242440ejx.18.1590777106412;
        Fri, 29 May 2020 11:31:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxieTKkkPtQ0cNgBBbouELGe2iQaqqnrVA5pnq68h7WQkBidqlkxwfZUwkKDtgUzBWHSEO+IQ==
X-Received: by 2002:a17:906:9707:: with SMTP id k7mr9242432ejx.18.1590777106258;
        Fri, 29 May 2020 11:31:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ce23sm4733790edb.79.2020.05.29.11.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 11:31:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0F9AF182019; Fri, 29 May 2020 20:31:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: Re: [PATCH net] sch_cake: Take advantage of skb->hash where appropriate
In-Reply-To: <20200529105700.73a2b017@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20200529124344.355785-1-toke@redhat.com> <20200529105700.73a2b017@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 May 2020 20:31:45 +0200
Message-ID: <87imgezj72.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 29 May 2020 14:43:44 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> +	 * enabled there's another check below after doing the conntrack looku=
p.
>> +	  */
>
> nit: alignment

Ah, right, seems I forget to hit <TAB> after adding that end marker.

Davem, can I get you to fix that when applying, or should I send a v2?

-Toke


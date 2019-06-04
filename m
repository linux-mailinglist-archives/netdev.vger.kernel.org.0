Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51E34FFD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfFDSug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:50:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44814 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfFDSug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:50:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so14992922qtk.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 11:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gEI6zd9ZyT+zsD6MEVpjTDYJwoLc6DKmZ5P2NBrvBbk=;
        b=cRy0UNWNcCgwG4+XgCACCordwHex9ktnWri4ezw54RlOOVpkr3T2H1UuYV8d1N+ivF
         p4jkzHE1JksgPPe5rBuSbqVink7W9RkT3Wf7QqpVR/ywynRE6Pq1jzzP/Pr4ROEE56z1
         v3gP6H5O3KxbgtjxpZHQkj4pxu+mTzhNpXhCQKODcdJB4ZXEXXsbgOpwewTdtLqGtqZO
         kUcf/7yimJ21EkyiQTBdbDcNyt4s5UJG27rnc4kXQXM26TL8nbCWTvKn/FuqizzxwdGh
         oBGdDLAz84HOz3FRAEFGzpGm3S0WI+Tlln6SXcxqh5xJoHdikGVNgVQFXtFZCOJiHuwE
         MY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gEI6zd9ZyT+zsD6MEVpjTDYJwoLc6DKmZ5P2NBrvBbk=;
        b=BBMACOvh/Dh8ljUlvuwlo2yu+TUvV220XjfMDDmXI2L7aTlr+K/hmzeW3u/wIPtxxy
         TvMvnqF1dTDXqIdqzV37QPzvdwR/Ngs/WBOlPuCxkae9txInouisjbN8S7crCO6bLIpY
         Sre2561Xqgf7AIrMv9BuUriZWUxA3PrKV5yr2Eu2pHKJU5WP+z8y9ilRbf1vbmNfW93f
         6KpUX/MBsjIOvhavHELX0FJnkIus9QL9TmS/Cx8/6nH1TCWu3/8QxnEAbI+h7sVuFqOJ
         AOkEgZC5CGiYXXga2OA3nI1wzTYs1u5+0u2iMdzbG3iUYnLs1EjhOz1A7Eug1XLEOow+
         kDlg==
X-Gm-Message-State: APjAAAWfYZopKLh5qZMKQlGcxyVBxFqMa/gdCOjWPM8C2xotDc7jl/a4
        y/zv3IfAs2LPco3AzWqCoINlVg==
X-Google-Smtp-Source: APXvYqwSpVwKOGUuAGTXcF7da3CXVxnImNzqbagq19KUo66kqokDXpIAtx7BqGvPnXzgwTpH6hLaQQ==
X-Received: by 2002:aed:3b1c:: with SMTP id p28mr28862149qte.312.1559674235153;
        Tue, 04 Jun 2019 11:50:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g124sm9650370qkf.55.2019.06.04.11.50.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 11:50:35 -0700 (PDT)
Date:   Tue, 4 Jun 2019 11:50:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net 0/2] net/tls: redo the RX resync locking
Message-ID: <20190604115031.2df8689a@cakuba.netronome.com>
In-Reply-To: <20190604.112357.1200320783493199233.davem@davemloft.net>
References: <20190601031201.32027-1-jakub.kicinski@netronome.com>
        <20190604.112357.1200320783493199233.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Jun 2019 11:23:57 -0700 (PDT), David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Fri, 31 May 2019 20:11:59 -0700
>=20
> > Take two of making sure we don't use a NULL netdev pointer
> > for RX resync.  This time using a bit and an open coded
> > wait loop.
> >=20
> > Posting as revert + new patch, hopefully this will make it
> > easier to backport to stable (unless third time is the charm,
> > and this one is buggy as well :(). =20
>=20
> Still needs some work :-)
>=20
> net/tls/tls_device.c: In function =E2=80=98handle_device_resync=E2=80=99:
> net/tls/tls_device.c:569:21: warning: unused variable =E2=80=98netdev=E2=
=80=99 [-Wunused-variable]
>   struct net_device *netdev =3D tls_ctx->netdev;
>                      ^~~~~~

=F0=9F=98=B3 sorry

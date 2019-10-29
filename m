Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79558E7F28
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 05:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbfJ2EVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 00:21:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38401 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbfJ2EVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 00:21:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id c13so8585688pfp.5
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 21:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0pNMZdcb7hVw4JvKyqQGkwHY7dkaCsSGzyWz9BVtGQk=;
        b=1wikhcf2LRKaXjQCCzMfjKPCzaSjrvLfAGFPVLqBYwwW8D7XZIg9JYqysxwfVaeuP9
         0uhtCR2XtkEYXHieiYFJxD3A8WzmkxnF8I2tJ4ZR4DUaZYSw4f3T28ZL+86jOLdCqQtk
         ujpEN1OZGppjBKoVj5tuGk9+XOscsNzxg0JwrWDghbWBsoWIpYFgUU4V0fi+qFPdlP9g
         4F6v/X+yDRh4Fiy/m/wIhQzI+4qpxqUaeTIb/45CcDOSr8rX/JtY1gqAt8di541rX60W
         izx6IumZ5kf4vlDBFkenIPT43Xhe1yDIdLInBxz1KN8phwJpM/3U3ygZVi04/XadPY3O
         kd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0pNMZdcb7hVw4JvKyqQGkwHY7dkaCsSGzyWz9BVtGQk=;
        b=WEKnHY1xXSSTVCnQEPfYEiY0wbh478SxD1G/+MVLQBEZ7bHpmvQXNVxQu7XVtY/Qxt
         PTBdjrAbu6Bz11yYtOC57LcLQs6lpyvQLHG2UgfJ7FRi1wrB3E9HW+maO7/NW+fwF6sm
         CrJwNpdKdMzSJRWefMMjMS8L/N/0n2YESRiQNsgzvtkWhZbgnotYOiFeyG1o3MRtX8Ed
         wl3ppbzHfbcraT13/+W0T5CD5Ix7sLgPFpviHsoXeinhvNUVFCE/wVjg6+FyVeIaiAUv
         DXc/feVPzK501i2RUz5HUwzvgfbDMyNZQO2lzQLiqPNiDCeOfo5/dd+LMmAoaYazcX/R
         TnoA==
X-Gm-Message-State: APjAAAUCgFES9wJ04FX/WLwtNUhKlLK+MDThvpuqgPHX9lKeXNyNC8DQ
        VI/tMF6DtW2uNDHFvi1tBY5vniLrhKQqlA==
X-Google-Smtp-Source: APXvYqwSgmBcd+DESWoToa7lDva6YzfefQ6XWGcg4mWr0crZHAfHX+Q7/uJrTc63owA6ECoEdPtHcA==
X-Received: by 2002:a63:4562:: with SMTP id u34mr24201060pgk.399.1572322897610;
        Mon, 28 Oct 2019 21:21:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k24sm12051003pgl.6.2019.10.28.21.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 21:21:37 -0700 (PDT)
Date:   Mon, 28 Oct 2019 21:21:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?TWljaGHFgiDFgXlzemN6ZWs=?= <michal.lyszczek@bofc.pl>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] libnetlink.c, ss.c: properly handle fread()
 error
Message-ID: <20191028212128.1b8c5054@hermes.lan>
In-Reply-To: <20191024212001.7020-1-michal.lyszczek@bofc.pl>
References: <20191024212001.7020-1-michal.lyszczek@bofc.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 23:20:01 +0200
Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl> wrote:

> fread(3) returns size_t data type which is unsigned, thus check
> `if (fread(...) < 0)' is always false. To check if fread(3) has
> failed, user should check if return is 0 and then check error
> indicator with ferror(3).
>=20
> Signed-off-by: Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl>

You did find something that probably has been broken for a long time.

First off, not sure why libnetlink is using fread here anyway.
It adds another copy to all I/O which can matter with 1M routes.

Also the man page for fread() implies that truncated reads (not
just zero) can happen on error. Better to check that full read was
completed or at least a valid netlink header?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BABDEC6EB
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 17:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfKAQiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 12:38:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39759 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbfKAQiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 12:38:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id t12so4604894plo.6
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 09:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SEALwoa0cbjZR0oI/QLqztxlaX1462n1PkXryuYeKGI=;
        b=vtE09raxwX6dhPqCzznS8lvOXFFqUNtSM4jXdeDJScXI32SpgmtLzO/eLE377KKy76
         QqZcKx7Wzuw6Tvi1+lzvgbFDSIT6ns01/uPv8V4nXyKhzePI2zgBOGxeMpWOPKCuEkZZ
         HCyqMjSr6hjq7MVSPFGKfWumyq1YbdEJJ7WHoTMRQ504IevQhWzdUp0Dseq6ntj4QC6y
         /TplTeaKGdsrhJv3tJrnunL4Sqg/dHmgtsD++mZ7R3g43e4xUC3EVZHB4t6O+KXdUUYK
         fFyJ1vLV4jh9ovj3OQv7K9zQzAJDXAbXqIYewBDhPyn2MZvZ7S1jePjyU0DRYvrebNf3
         6uFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SEALwoa0cbjZR0oI/QLqztxlaX1462n1PkXryuYeKGI=;
        b=ZnG+2E/36XqoHGeI/jIB3EXiFT1dFQrtnuOm5yqY+vOgv3OPhQLQ/cJ0yq9u4SwbO7
         iH3mifs+6Byd9wQYpE5oGS6ZkCFsnxp2lLhiW22k81R/KCPrGYrU90dNaoy74oaKQw4B
         Oszo7E8QzrvQrMs/xIiz9yVqGqYZQboYvtw+QpAP7Un6msMrXkO5KFd8wBIbR1kG28pP
         mM9tAfXemZT1YdL0EIjExCDTw8Hk7HVG/GcyiO4VWU/RcAbwIYVzaoMgl4UPULh4IQ+Y
         2347nALXKcdHVi2OqInrcSjDDYCtVz9fKXoVeIMCmyK2cDSlWDfxr+eShdoKMkX3+NUk
         18Yg==
X-Gm-Message-State: APjAAAX+4OkN/XQtq6Z9qaAS0I6WI2e1wkO2jvecyic+Dn7axMPkohaD
        NecfHpXEaqvNNEePkI3CGw4FWQ==
X-Google-Smtp-Source: APXvYqy9wxOd4kT/rXlsgIs8LGm/ughW/kr8TmoAHb1rnX6HWAh5lzmk8F0+m8RNJiFFBi3kQcsohA==
X-Received: by 2002:a17:902:ba8f:: with SMTP id k15mr13314068pls.93.1572626286575;
        Fri, 01 Nov 2019 09:38:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q1sm1955401pgr.92.2019.11.01.09.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 09:38:06 -0700 (PDT)
Date:   Fri, 1 Nov 2019 09:38:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?TWljaGHFgiDFgXlzemN6ZWs=?= <michal.lyszczek@bofc.pl>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 iproute2] libnetlink.c, ss.c: properly handle fread()
 errors
Message-ID: <20191101093803.4c10c04a@hermes.lan>
In-Reply-To: <20191029111311.7000-1-michal.lyszczek@bofc.pl>
References: <20191028212128.1b8c5054@hermes.lan>
        <20191029111311.7000-1-michal.lyszczek@bofc.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 12:13:11 +0100
Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl> wrote:

> fread(3) returns size_t data type which is unsigned, thus check
> `if (fread(...) < 0)' is always false. To check if fread(3) has
> failed, user should check error indicator with ferror(3).
>=20
> This commit also changes read logic a little bit by being less
> forgiving for errors. Previous logic was checking if fread(3)
> read *at least* required ammount of data, now code checks if
> fread(3) read *exactly* expected ammount of data. This makes
> sense because code parses very specific binary file, and reading
> even 1 less/more byte than expected, will later corrupt data anyway.
>=20
> Signed-off-by: Micha=C5=82 =C5=81yszczek <michal.lyszczek@bofc.pl>
>=20
> ---
> v1 -> v2: fread(3) can also return error on truncated reads and
>             not only on 0bytes read (suggested by Stephen Hemminger)
>=20

Thanks, applied.

Isn't error handling messy.

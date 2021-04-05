Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D63353A62
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhDEAh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhDEAhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:37:24 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD0AC061756;
        Sun,  4 Apr 2021 17:37:12 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id z15so10267945oic.8;
        Sun, 04 Apr 2021 17:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1lsInjJ8vrGaLsH6CKaq8WMLDPwzsuEN+yGUjpTexzo=;
        b=XPvoXBl6C34rtFpUT8m+gzTvzaeQyZk3D8EEKgHXPyIrb8bRHSZHH8XUPEdwy1FzJg
         VDmJVhDELixgsqx4GNwmOi0CzN5OL38Oe17z3gATB4o48T8MowhdxxtgY2qIEGP3VWpn
         EPnSrXtN2KqvoBKzHEOzHABkok+30D60Xe48orKZGcKAhDFouZA4042h5vCLG57NiA6s
         Gy0pmtxVDP41/iu5imr5xd3kcGAB3RyQ1D+M37PQ4Zq42yI6bj8EdeWyJl8n/I9usGyR
         4pfAbUKQg4HwJa2MTVKWcWsARuv/BYycqZAexckZ9niMLbXuw5jPhQfwxNg3MC+QzqOc
         +FeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1lsInjJ8vrGaLsH6CKaq8WMLDPwzsuEN+yGUjpTexzo=;
        b=FPwvT9vz8Tbr6+fyGZXF9U5oVQradf1UsAubqazbL/hLpgtBpIvCL+LrbJq3wLUnhH
         WBycvgfV1B18rLJwqc+hsJvoy5105ljK8bSX+HS5owfGunZRXVFh6KRFheqLOT3DBKJQ
         LuSp1+QS9qD8cOdffsLznMoIrX2ERhOAWoIBfFdOPP4M0ETHe1ZM7MVrOjeEKzZAz7j9
         wzeimedfyivFnnCWZtjYZnGpObAimi7xc26F3Ynb0p6INzfRKrTM0+cgXWcfwkJaLB9R
         TS6O0aoFsxgI4s5fW8HFChN83gagUmlzN2P8vtlRvo3qr8xecGrs4BPP1/pC44BK8yyQ
         Q0nw==
X-Gm-Message-State: AOAM531rvw6ZUSVBA/+HjNwKhSl7VWVVjrZM1otsA7o0cc6acv0E+2xf
        zSex6mMnyJNuJ3sEHBOFI7or7FFTA+gKQSeh3oM=
X-Google-Smtp-Source: ABdhPJx6XayvnemkYN3ukZJt9a3SZT+CZ8QNFj/J5uoFGSickoV64amja4skjQy1FhUIDdISTDvHw8cIk5dCruTOIKc=
X-Received: by 2002:a05:6808:f14:: with SMTP id m20mr16953443oiw.13.1617583031630;
 Sun, 04 Apr 2021 17:37:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210403151851.9437-1-paskripkin@gmail.com>
In-Reply-To: <20210403151851.9437-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 4 Apr 2021 20:37:00 -0400
Message-ID: <CAB_54W6qaZZ-wwJ_JEuBwYywu5RSXNuyE9o6XeizRLgEwo=uvw@mail.gmail.com>
Subject: Re: [PATCH] net: fix NULL ptr dereference in nl802154_del_llsec_key
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, 3 Apr 2021 at 11:18, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> syzbot reported NULL ptr dereference in nl802154_del_llsec_key()[1]
> The problem was in case of info->attrs[NL802154_ATTR_SEC_KEY] == NULL.
> nla_parse_nested_deprecated()[2] doesn't check this condition before calling
> nla_len()[3]
>

this is already fixed in the same way just not in net yet.

- Alex

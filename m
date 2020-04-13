Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E453C1A631B
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgDMGgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbgDMGgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:36:07 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136E5C008673
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 23:36:07 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id l84so4784362ybb.1
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 23:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qCWqzY69PquSmq15ntJodV3fJVjuAHlYMyq6luMK6Ks=;
        b=nXbFUasZO4lBuOpPUQxB2KmyUo4NzTGjMQAOB0Ier8Wz3I5DxxmN0oR9cpTZbgZw3K
         jahEDs214ZreCz0myx81BuzuT75FwCBOjyqPad48mdi/NGGXrjmgCRmaZviEAnPfMfwp
         CTfwjD0GcLK7pJuVDoShk06nLKhMPcz35CWghDpYuzNDQAixXPXH41vqE2wBj9iVdt0K
         mXPX//UdJn4fpmZqLhiWFHmX84lQxFw1XDygQWwigTrZT7hKEjblIzETiuBWE7Gd+iEJ
         TJTxCbuTLS3GPdYpJO1tdJHGvFc9tIIfi4jRFAzfm1VU2QssR+Pb0r3Uf+EAzPuJBjW/
         GBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qCWqzY69PquSmq15ntJodV3fJVjuAHlYMyq6luMK6Ks=;
        b=OicAz4FftiTCWz0anbY3L4Z+J/d2FpwaqhPdiLn6u2vdwDJgEkg0wFa15tvn5M72CQ
         M9J2NPSonzpW/8rD7I3HGtp7as8s7yKeIZioJwbRrwkGr9KErKlMX+UO/iHfat8DL7Xe
         DeRuQsAkmMLVA2O+TwfS9dstBV7sqf3FZR4QCWer+VD6L/+vjRgnItkDH+sIkHNALMlN
         o08fup63MHEnwcVx7fqtpmtoKAe+Pt9oPsS8V68Gh7DBf5WSIUnitvtqlT/0smJliYNi
         8BY3XYO1r5Gn3vmGMGPV8dEvo9xltrD+RHJ12CXuXK3wL5OqkbuzVOGREqwSpUiEs4fE
         SlZg==
X-Gm-Message-State: AGi0PuYGy6EBRad/0WparHcvUVwErfddGKbZa4Uo/N33u0u1NGA0nIec
        5+oX2zbQpdGgrjvHoqMxdlsQnh/BwnSbP4FGKSE=
X-Google-Smtp-Source: APiQypLNHWpe0AnjUGP3q0kstotLVp5C8mQkqbo510Hn26qD5xJwsuF1GwKHmeVBixOXqIgDLJToDGFQRbwSTV+ON9U=
X-Received: by 2002:a25:bec2:: with SMTP id k2mr25472663ybm.129.1586759766382;
 Sun, 12 Apr 2020 23:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
 <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
 <20200403024835.GA3547@localhost.localdomain> <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
 <20200408215422.GA137894@localhost.localdomain> <54e70f800bc8f3b4d2dc7ddea02c1baa0036ea54.camel@mellanox.com>
 <20200408224256.GB137894@localhost.localdomain> <6f4e8a85-ede4-0c10-0ef7-0d45f2b7fc73@mellanox.com>
In-Reply-To: <6f4e8a85-ede4-0c10-0ef7-0d45f2b7fc73@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Mon, 13 Apr 2020 09:35:54 +0300
Message-ID: <CAJ3xEMibkDZmLYokvHinjiuv3V_ZA7x3s4SBpXbp2_BDpTUjgA@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing to _once
To:     Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc:     "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 11:15 AM Roi Dayan <roid@mellanox.com> wrote:

[..]

> in some places we already only use extack without netdev_warn.
> so currently in favor in removing the other logs if extack error exists to
> avoid flooding the log

+1 for using the modern messaging way (extack)
+1 for driver diet by avoiding double messaging systems

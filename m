Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83A53B0CEA
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhFVScx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhFVScw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:32:52 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C27C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:30:35 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j10so6657297wms.1
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=un/8VbfGaCSq6e5kZBov4MS2h80sOr5uk3ZcuorNMTg=;
        b=DYzymdIoXqB6cj1WQSi4EsQknb79VnFPMIq+xKOyerxbT5bC1FKqVxQ3O1COV55MJl
         HteRS7uWxP029f2uRmdH9kNV6n3gsLCPoLN09ZmQ9hU7oMZYb1mn4nceck41uL3DbRmP
         0r/+cNTVOcEMI9w8cvlLz4Hxyo5bV3HLDKNMtMVdFjpywCTJJlMGfKbV1l5Wl1vKykJJ
         RQfnPdfLJkakmAs+A81Z3ZTpOs/YhfTjlZQ0D1H4DUkqn4brXX2cQme79QSA+TjFCzYj
         DjUDJwqZMNq/x5pENPK13GPDuJYl3Zm4yIhTRFZAmW5oNxnVDQi7r2xP3DVA1a9s2zyL
         DoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=un/8VbfGaCSq6e5kZBov4MS2h80sOr5uk3ZcuorNMTg=;
        b=P9c769Dl0d5GdMWS/G31nXM3D59LsyBB7+XOvBhq+ujehnrOryrBZwXwuvWxD42pkB
         QEtJiMwnbLN1cOC+4FsBct86K8RHLKgn1Y2QoeSNERyfrSD94ufQ5n6luL5CtM74TnCA
         TyCRHbF/KTNcjVbPhi66391gJS/Myc7FZhPNC9OROxTsZpIB0krUzqM8BXsJZIjU3qlx
         UN0eOLRwLT7L6+jreJ8iMZ8Soj23r+KqFmsZfajidr89G4Qfaag7ruyd6PzfdIzWkidc
         dyMeTOkfjZqm5Hu9kW/eN697LlZ8M8PZhVkCL/QiF0gLj2C195VLmN7+4RQ4BV1WAvTj
         mXAA==
X-Gm-Message-State: AOAM531sYizztxP03RO3zK/hUaXry7lubuoPY0dkoJjD5IN5UQRGdwGN
        1tpEdLE+bP/0NXM8ztpdQIq3MjF4l8Kgmg+9d3A=
X-Google-Smtp-Source: ABdhPJxJOukr8mWMIzPZVTuKwdeAQyrn2GOpGgjPj/6aZvhzXbbhIWoAQrLo4AUNjaa+Ah0BbquIAxqob3qSf0QHiQI=
X-Received: by 2002:a1c:7706:: with SMTP id t6mr6142058wmi.62.1624386633861;
 Tue, 22 Jun 2021 11:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210621180244.882076-1-eric.dumazet@gmail.com>
In-Reply-To: <20210621180244.882076-1-eric.dumazet@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 22 Jun 2021 14:30:22 -0400
Message-ID: <CAB_54W7GL8rX8_bRkgC7NAbEwmkfGOwDbdmqP6R43F_nEM3igA@mail.gmail.com>
Subject: Re: [PATCH net] ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 21 Jun 2021 at 14:02, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
> must be present to avoid a crash.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Stefan Schmidt <stefan@datenfreihafen.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks!

- Alex

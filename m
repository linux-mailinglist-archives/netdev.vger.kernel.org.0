Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA4021524B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgGFGAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728747AbgGFGAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:00:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A5C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 23:00:00 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id c16so38100526ioi.9
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 22:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+FxNF1PEqalq+JMiTNZR5vlolFljitlQJwIIQxol2+Y=;
        b=Hds38zgb4I2pcnzS+NfyEXIEMjZlsrdfX0PdTd7JVb86ba40CUvzsyuQNr3vHE9XFu
         XbzhmvTOc8yxWfVrduifK42W4R3oE65YxRWBcUeUole+M7O/gt8KlLLi88ej8uESX6zX
         h7eWXueNuB0sgjohjzhz4ud6ORwfcqkrlCeTw8mTpG1YaZceutjjvzCsxaOqvVdPpMGV
         I3sqW5e8xwKs8M/vM3+Pj6D1qXKC7b6/WTwS06La8i6WyygTIEBUO/rm+T0YZJEh80gZ
         QfMndluuuXutGn5gyWg1P2PB4uRwqs0E1SjUhqsbRaHavPLRkItLSlAjJfa82Q8aoON1
         OSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+FxNF1PEqalq+JMiTNZR5vlolFljitlQJwIIQxol2+Y=;
        b=SJNCC3g+B6QXJ2MN29kipNpj1tWNm/1dJVB6rGmQ3aLXf9CHjO4ywaKADsh5fLe8SD
         iI85ybtW5owGtx3GDg5zkiSs1F4f0QOK3hdtkNG6Tm+8zLyF/JAC8ozO7qEda/TZjFxx
         I3HWbik6ZbF3krdTkBHXUrPmnDVp+FgC5WGJs0d5swUZ+OAEGvAR36wkKX8WlNmv6x+k
         7UivM90BZe9N2wamI+JTMysUqIXvOLG3mcP8ntvI9osN1PE0cIQybtXuQHwAqa2HQiZ/
         Axqky31CZwGdxheRRVYNMcVZNGuGA2315X7JS3HGDcnK88gB34KKvILi+sdenenBFYxP
         QflQ==
X-Gm-Message-State: AOAM5327k663ScztHJ4dl4jRjHRE1RaCQkEupPUZaAJWUslvbhF5958z
        cUoSjw5mzHiAZBdfzbVVjUa7JszUN77nxAlo+MY28g0Kcsk=
X-Google-Smtp-Source: ABdhPJxMSne3acX2TuV0hWwNrt1CdNI/E39QdGaZGC8ZALZGjeqRSt9yydiULjNUUZIBy98apaZ9r66eC4E3O+q8wzs=
X-Received: by 2002:a5d:858e:: with SMTP id f14mr24005376ioj.12.1594015199413;
 Sun, 05 Jul 2020 22:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
 <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn> <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn> <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn> <20200702173228.GH74252@localhost.localdomain>
 <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com> <20200703004727.GU2491@localhost.localdomain>
In-Reply-To: <20200703004727.GU2491@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 5 Jul 2020 22:59:48 -0700
Message-ID: <CAM_iQpXeok+sbarXczPXY-n-c=HBj_yHuOYwi=GavB924v5Zgw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 5:47 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> in this case a act_output_it_well could do it. ;-)

Yeah, still much better than making "mirred" do "mirror, redirect, frag,
defrag", can't we all agree it is too late to rename mirred? :)

Please do not try to add any arbitrary functionality into act_mirred.
Just stop here and find a better way.

Thanks.

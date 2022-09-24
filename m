Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005E65E906C
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 01:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiIXX1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 19:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiIXX1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 19:27:19 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F32474F4
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 16:27:18 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-12803ac8113so4924270fac.8
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 16:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=mZP7oDBm38gC57HZQIimdKWct3WBq+1FhFikVPx5VT4=;
        b=h/Hs3letZbXMALpqi9fP+jM4kdxnR5bmw6kKAtMnUfiErUqic1qOld7ihM0h0AegBe
         Yzh7vwKXCrDvMW+3rlOOZ4ZZFomkqh+rGUoGf55LxMv36SdMHis6shiClBDk0EhJGwtf
         Z1GzVjKSvWsXkfxWJr2f9WTR2/mejUv4QMmX4EA/XFodBIV6GVZm9jr0Mf0qiuQSPv94
         EkrclIZXP4RMXq1elRec3yW9Pdb+YZM4AOYQbDpMp9/pAIUeZx2EnmAv9yCVq3GFtigZ
         O13aglrmq+Morik6L/lAAvw9YzD3Dzhm5tGEEYxH48gt5lPw7U5rOxaEPVsTBS4O5fAP
         59GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mZP7oDBm38gC57HZQIimdKWct3WBq+1FhFikVPx5VT4=;
        b=jOTKqJSo6ljU/8Z6dYkNlcmcG56TBAbD6cwNUhG1hB+uKDrxx4TeZvBB7qQBt6O/Du
         leeGCAtIg6SoknCa3wtXrtQK516RPIeJQqAnJ1NjSVH0QRk9dsbsjp/xJRb23rULRa0Y
         he+P62cFYjR9h4jK0EevqAR7zKgq6ii161T5Iu0dsSm4A7TcntyQgiXLqsqj12Ildu2y
         Hq+nifkwCLRIKqJm7O5k8/72kXT8LsU2YghX9B1o9zDHMKhn7pvxncHuaehGuncWcR/l
         6KnYkB4cZVDFw7kuNFmSOgVv/o1S1BrON0zPcAc2x1HMs9mrZUvLSyDFXLGGkMsF2L7R
         kimQ==
X-Gm-Message-State: ACrzQf1S1ZVkM70NKGGKKIEHvy95VSHl496gJi+ZD0fqv6Fa/Hl5Ambg
        /WB0McCcQPELc3i1dxmGXkoLvL1afN/j+xLwuITzMA==
X-Google-Smtp-Source: AMsMyM5PT3edILhhj/VXcFKDiQISyVzQX4Y/GGzmDVyQ+u7mE1AmQjMXY9VktcK8c6Sut2KldTYmHLgepriLcVo6/tI=
X-Received: by 2002:a05:6870:9692:b0:12b:3e65:2516 with SMTP id
 o18-20020a056870969200b0012b3e652516mr8816441oaq.66.1664062036580; Sat, 24
 Sep 2022 16:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220921114444.2247083-1-gregkh@linuxfoundation.org>
 <YyyH1oXMubeQ8KVu@shell.armlinux.org.uk> <CAPv3WKch2J4tteo68wOt_ETj_eYEKy8EC5sTwDvW6UZ-Gs_sCw@mail.gmail.com>
In-Reply-To: <CAPv3WKch2J4tteo68wOt_ETj_eYEKy8EC5sTwDvW6UZ-Gs_sCw@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Sun, 25 Sep 2022 01:27:06 +0200
Message-ID: <CAPv3WKcEa69vhrfE9h2XeuckDjvB=Y-HT7Y3fjV1W6gqYRmyjw@mail.gmail.com>
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix problem with previous memory
 leak fix
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

czw., 22 wrz 2022 o 19:08 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(a):
>
> Hi,
>
> Thank you both for the patches.
>
>
> czw., 22 wrz 2022 o 18:05 Russell King (Oracle)
> <linux@armlinux.org.uk> napisa=C5=82(a):
> >
> > On Wed, Sep 21, 2022 at 01:44:44PM +0200, Greg Kroah-Hartman wrote:
> > > In commit fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when us=
ing
> > > debugfs_lookup()"), if the module is unloaded, the directory will sti=
ll
> > > be present if the module is loaded again and creating the directory w=
ill
> > > fail, causing the creation of additional child debugfs entries for th=
e
> > > individual devices to fail.
> > >
> > > As this module never cleaned up the root directory it created, even w=
hen
> > > loaded, and unloading/loading a module is not a normal operation, non=
e
> > > of would normally happen.
> > >
> > > To clean all of this up, use a tiny reference counted structure to ho=
ld
> > > the root debugfs directory for the driver, and then clean it up when =
the
> > > last user of it is removed from the system.  This should resolve the
> > > previously reported problems, and the original memory leak that
> > > fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
> > > debugfs_lookup()") was attempting to fix.
> >
> > For the record... I have a better fix for this, but I haven't been able
> > to get it into a state suitable for submission yet.
> >
> > http://www.home.armlinux.org.uk/~rmk/misc/mvpp2-debugfs.diff
> >
> > Not yet against the net tree. Might have time tomorrow to do that, not
> > sure at the moment. Medical stuff is getting in the way. :(
> >
>
> I'd lean towards this version - it is a bit more compact. I'll try to
> test that tomorrow or during the weekend.
>

I improved the patch compile and work (tested on my CN913x board).
Feel free to submit (if you wish, I can do it too - please let me know
your preference):
https://github.com/semihalf-wojtas-marcin/Linux-Kernel/commit/0abb75115ffb2=
772f595bb3346573e27e650018b

Best regards,
Marcin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2CF12CFDF
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 13:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfL3MEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 07:04:00 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:36405 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfL3MEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 07:04:00 -0500
Date:   Mon, 30 Dec 2019 12:03:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1577707437;
        bh=3MVyi2DNa93hVmgoV6lEbiHkSuhxQ3WH3je/Ig6Y1SY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=GHmdX990fHIhigjup8JCvQvLCXm2Ilb9j24ar5oGaGi0GU+v12HnKf2UeU5wJWXqW
         ZwQOdYwSV8z/JoenFZ+T21U5KnYeveVkhKbVTxvpC1pLppY/WMNUwOmhh3/4WDn7vL
         ZC3B7wD1vcfltLx2OtTnrWvcGNFbV4kzhAkv8JVU=
To:     kbuild test robot <lkp@intel.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Netdev <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <kJ06dlAPYOu17nqqVXSBq-lEd2lJWHS0YkKV5jEfzLY2wiNjazeZL_yJNXKUxIqeCSosIK0wlCQkxqxrcUhYcwP0xTAkQW9Ir63p4ejfefM=@protonmail.com>
In-Reply-To: <201912301855.45LZiSwb%lkp@intel.com>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
 <201912301855.45LZiSwb%lkp@intel.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Ttttabcd,
>
> Thank you for the patch! Perhaps something to improve:
>

> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot lkp@intel.com
>
> All warnings (new ones prefixed by >>):
>
> In file included from include/asm-generic/bug.h:19:0,
> from ./arch/um/include/generated/asm/bug.h:1,
> from include/linux/bug.h:5,
> from include/linux/mmdebug.h:5,
> from include/linux/mm.h:9,
> from net/ipv4/tcp_input.c:67:
> net/ipv4/tcp_input.c: In function 'tcp_conn_request':
> include/linux/kernel.h:844:29: warning: comparison of distinct pointer ty=
pes lacks a cast
> (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
> ^
> include/linux/kernel.h:858:4: note: in expansion of macro '__typecheck'
> (__typecheck(x, y) && __no_side_effects(x, y))
> ^~~~~~~~~~~
> include/linux/kernel.h:868:24: note: in expansion of macro '__safe_cmp'
> __builtin_choose_expr(__safe_cmp(x, y), \
> ^~~~~~~~~~
> include/linux/kernel.h:877:19: note: in expansion of macro '__careful_cmp=
'
> #define min(x, y) __careful_cmp(x, y, <)
> ^~~~~~~~~~~~~
>
> > > net/ipv4/tcp_input.c:6568:20: note: in expansion of macro 'min'
>
>      max_syn_backlog =3D min(net->ipv4.sysctl_max_syn_backlog,
>
>                        ^~~

Uh ... I can not solve this warning, it's none of my business, but the kern=
el is also used elsewhere min (), and there is no problem.


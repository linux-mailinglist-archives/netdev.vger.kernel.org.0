Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9464B03C6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiBJDKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:10:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiBJDKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:10:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B991EADA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 19:10:34 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id w1so660011plb.6
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 19:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e1cRL8qvMlykVE4e4eRvrHUvEnO3rK/I2DWY1TBb8KE=;
        b=Zl8RwxvZBnePZSF/XvrUV+bBaSJTDnrwlOulpTOK32rbNTQj5RUSmbddHdiEcjaKno
         NzLr/dCtzWsYan6tAMGsA7ZX7DDv3IV4baIJ7GhALnEd0hsi6rP/gDHXRoaXfHphgU6i
         hLih9IRjE+HxG42sb6P1x3ShobjZnAlzIwGbVDLAXEtUa4MYnSXDvUo91tzw8k0iGlUX
         9sv9dwTjMVUSAu5S/ICWC6WWXGCDRmtEyw69kRL8xPn8eYiJFjjW+Xw6SUYx8u5stVTp
         2mF+oLoO6GzJs6wiaBOF4zKODpII619s2qRC37M/4upODlvNS/GxWPhXj2IdeK1vDGwo
         d8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e1cRL8qvMlykVE4e4eRvrHUvEnO3rK/I2DWY1TBb8KE=;
        b=f7oGjk9QBUAhC1gvY3bXA0Sqx+F9NVg+OCN9yWHh+Wti9XR9M9B+mexx2dK0JGnx6R
         NO7pUoksePLyI/ToJNqdR/dz/gZRyhl+KceADqgqKE8bMwetgA844wDjFSF48V1ln91v
         WmpkvwqDzuGQDN7z47sZLDPHb5WO3aBgb6BgVw6vnJq4gNeNqGlCOUNqltltrGoihLzy
         10L/9ZSdoOcCY/FLxG9UJIuupEgYokiOf4qhNTq2He65A3WniIuAPnx6vDm9IPHTUSws
         HzfPrTJQrhxC3yKXgFr4f/RrkeTEuiEYMSIV5Dh4FSmgVnaBy1UxDwrBKPaalGwOnj0i
         yMJg==
X-Gm-Message-State: AOAM5321YU+gd7v2WyVatkEnP6eHkYJy1/3mku3hVHSt4JFoZqtN0lX5
        KVHKiBNTBxqaxbCtolyhLj+1wdLtz+p/n16emqH++T6bDIs7OZlS
X-Google-Smtp-Source: ABdhPJzOpxaWP/mHj+lLO/s51k5905twb4x0Cus6XuxCgMl+2k8Ktz74wErJEp4AMmsEJn+XhJZmbpqCx6oQyHryDno=
X-Received: by 2002:a17:902:cec5:: with SMTP id d5mr5447004plg.143.1644462634310;
 Wed, 09 Feb 2022 19:10:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
 <878rukib4f.fsf@bang-olufsen.dk> <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
In-Reply-To: <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 10 Feb 2022 00:10:23 -0300
Message-ID: <CAJq09z6W+yYAaDcNC1BQEYKdQUuHvp4=vmhyW0hqbbQUzo516w@mail.gmail.com>
Subject: Re: net: dsa: realtek: silent indirect reg read failures on SMP
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So I used this command:
> >
> >     while true; do phytool read swp2/2/0x01; sleep 0.1; done
>
> I'll test it and report.

In my single processor device, I got stable readings:

root@OpenWrt:/# while true; do phytool read lan1/2/0x01; done | time awk '!a[$1]
++'
0x79c9
^CCommand terminated by signal 2
real    4m 56.44s
user    0m 1.61s
sys     0m 0.72s

And most of the time I was executing three copies of that loop in parallel.
I tried with and without my patches. All of them resulted in the same behavior.

Sorry but I believe my non-SMP device is not "affected enough" to help
debug this issue. Is your device SMP?

---
Luiz

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4D0544966
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiFIKoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiFIKoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:44:09 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B138AE72;
        Thu,  9 Jun 2022 03:44:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kq6so33593661ejb.11;
        Thu, 09 Jun 2022 03:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9eShScYxSvA8PAxvDYri/9SuufIr5qY33wCvOGJRa3Y=;
        b=V0FugvNVjudjswg0AVF7QMmsTvhyCfhxc4Jrd+jzd+o1dSz9vw4r1FqAxL9SkcITdR
         e7ISLKYVCkcw/lpd72Ve2dui2ptQt87J8fXp32GzdQXNu9tAtW+RdoXWz3aKLOmXjsYR
         veYZQrt2uG33wSmNyXSgvuMPA9QTvHV+ll5uH56DI02UVNT7iGCw5iQdHuOwweE4ni9O
         yObUn8L/StKbqPn6pBXcVWFbNBsbG8L54LWpwuc+jc3KVHlFKwBxuPDKKobWFffIqDGw
         /5kPtcsIqCZmPC13KjHHPlJIaSd7hzl0S4PmlsVnG9IAWFO8rnarG+BNIujwuzzraPH0
         bFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9eShScYxSvA8PAxvDYri/9SuufIr5qY33wCvOGJRa3Y=;
        b=jUVZnn8vRCr1ZUE2O1wtgFNIceazsThYuHzrUfuCrnUelN/TjQ+zRkZVU5icwQk0JW
         TUZkiKXNrVSVQMwdJr1/hui3+5u4rDQvQYSDoaRKqSnOKFuM3mp+frWxhsDY1BQCWUo+
         2LHOGTyvM1/mMll42Yhu/ymyOMrKPL1dG9h5L0OP481GCbuTZleHPFidGC2yuPFxSi95
         663gzmfDea5Wpi2cP6kdK53HA2CUL8Fwr+p+SmM6x7gs/+sZ0vgDbrreacuLWAPJ1qVx
         Ikge9sLECNhsI8EyK06nS7HVTdmarvFrE33/bXNhsRbTF0xOg9z9pOIuVOijknANjU7h
         JxNw==
X-Gm-Message-State: AOAM5313Acr+UG3z+mcmI+EU5YZ1cV9BMkUF8MpXfmMy4XaxOjWCSnTM
        xoY4P/TH5zwn357V79PP6/SA1nE2q3rYETe5Cp6HgvB0MDY=
X-Google-Smtp-Source: ABdhPJyJAn8ArOfnorQyVRUNieJT7QIR1hsqvBuF2/SVDQT9g+QmXcOJDiE4pxDDmVUSNYSdCBJO9aWQMe/r3VYwSNg=
X-Received: by 2002:a17:906:149:b0:711:fca6:bc2f with SMTP id
 9-20020a170906014900b00711fca6bc2fmr5546728ejh.497.1654771446841; Thu, 09 Jun
 2022 03:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-5-andriy.shevchenko@linux.intel.com> <3ec5fd68-a376-847a-2ad7-d352feea758c@novek.ru>
In-Reply-To: <3ec5fd68-a376-847a-2ad7-d352feea758c@novek.ru>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 9 Jun 2022 12:43:30 +0200
Message-ID: <CAHp75Vejsx-mE2Pd3DarbWBABX0ceQAyOhUkUS3U8ns-xKShQQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 4/5] ptp_ocp: do not call pci_set_drvdata(pdev,
 NULL)
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
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

On Thu, Jun 9, 2022 at 12:01 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> On 08.06.2022 13:03, Andy Shevchenko wrote:
> > Cleaning up driver data is actually already handled by driver core,
> > so there is no need to do it manually.
>
> I found a couple of places with exactly the same code in error path.
> For example Marvell's OcteonX drivers in crypto and net subsystems.
> Should we fix them too?

I believe there are even more, but feel free to fix them, they are not my POI.

...

> Overall looks good.
>
> Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>

Thanks!

-- 
With Best Regards,
Andy Shevchenko

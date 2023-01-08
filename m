Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE9661884
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 20:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjAHT0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 14:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjAHT0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 14:26:44 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543ADF4D;
        Sun,  8 Jan 2023 11:26:43 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id fc4so15154683ejc.12;
        Sun, 08 Jan 2023 11:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9zC3yIIoxLZMECoUQl5r9CLDCB0yMaZdjbggJyuByKc=;
        b=gaLjx1bNgbhD+lCeGklUewg6XDqoKJJWXCszjP1bpARcQ0HbVLVAte2wJ6yyerXBZA
         37fppyBJ5LSQj3sMZJDKQODBrCp+pPFzgd0ru2+KO15RbomeTy3YuUSp5oLZ0A4qyJPi
         M+HqCFTjSz+3LzJ9B9o18vDm5glfSCWBQ2xy7jUXIcJBaXfzgz6vbMSAwrobzDPuOIS4
         Riix76sk8MZEOxq0L4BYyIBc/9HiRv2zM6dWNcxOWbJfnVKchW8bkGYRmrWT5Q8/lPI1
         PkMfsSAsLWWfcMgA/DbHi4IADI8JldZIXiyC46yVps26DXqb2TBir5C8zV+bzJq56aoA
         7MMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9zC3yIIoxLZMECoUQl5r9CLDCB0yMaZdjbggJyuByKc=;
        b=QiVUuoJdFVyoQ6vYYRrJUgV6YQv1bTnjGBOR2cF0DBYLJgQiQBmIFK75U+sYr2Nhrd
         WT92pzzWWzfVJLp1wdGT7Mhf8+BH4fSB3VYrxakgs3qVTKVAPXHpvqHu8v8v0qMCrvH9
         qPBAP2jdFeA9pFfsM49NvEWQsSdW+kM+QREZ/rhWj4xHKgpf/XdhvuhdfEqjyLatp+1C
         Wis/1wmUcTJ5eqaeapeo/WfQFOMi6WMsgtME2/xydT9Tj4lXnL0iKFWI277FBiYrAxOi
         e6iskjuPAt/tN2QmGzNcJcsg3b5/OfLkdCanA7d0um1mAMcv6UXdqY7o/xlJ6//dQC/u
         DqNQ==
X-Gm-Message-State: AFqh2krKeDHxjijJvqLBC6k46EOvFXpqfN5xmzYOFobdswe9gHz3AB8y
        qw54R+ORVbG7akKCRn8eYKevBJM2/6LXTAAgjUGKc8Il
X-Google-Smtp-Source: AMrXdXsLHSjVlpfajiSbp2K0Q+0/cfyAJq/7w6NaEvejYHvpcr6M0L9FmfASzljN9NmtvtRNNASwutmFAm9xhV2RRe8=
X-Received: by 2002:a17:906:3989:b0:7c1:1f28:afed with SMTP id
 h9-20020a170906398900b007c11f28afedmr5182020eje.678.1673206001709; Sun, 08
 Jan 2023 11:26:41 -0800 (PST)
MIME-Version: 1.0
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com> <8434a0c6-839c-36cc-2539-a00d1e32bd8d@xs4all.nl>
In-Reply-To: <8434a0c6-839c-36cc-2539-a00d1e32bd8d@xs4all.nl>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 8 Jan 2023 20:26:30 +0100
Message-ID: <CAFBinCBChn9C+S72TSaCxpuuBRSbPscO=HLZcnTROJzAKSw7Zg@mail.gmail.com>
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
To:     gert erkelens <g.erkelens5@xs4all.nl>
Cc:     kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pkshih@realtek.com, s.hauer@pengutronix.de, tony0620emma@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gert,

On Sat, Jan 7, 2023 at 7:23 PM gert erkelens <g.erkelens5@xs4all.nl> wrote:
>
>
> In the course of 3 weeks my Shuttle DS10U bare bone running Ubuntu 22.04 server locked up 3 times.
> I'm using the Realtek RTL8822CE PCIe module in access point mode.
> Below a dump of the first lock up. There is no log from the other two lockups, possibly because of
> 'options rtw88_pci disable_aspm=1' in rtw88_pci.conf
>
> I hope this is of any use to you.
Did you try patches 2-4 from this series? Patch 3 should solve this
specific issue.


Best regards,
Martin

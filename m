Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745DD659167
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 21:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiL2UL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 15:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiL2UL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 15:11:58 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E772B13D74;
        Thu, 29 Dec 2022 12:11:56 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ud5so47306604ejc.4;
        Thu, 29 Dec 2022 12:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lXs+PETp5F1sLmKlUpnJ7KVN9WjqhwaoNYx00yCpTSY=;
        b=f2HwiOKmQSTMlha8bpeMVmXGnoKK5540JbD4UUkSvcj93uWC/JkG9HL41f4TJtyQuW
         WZcgfexiJSTgVV7RFQND06mUatgFWHTL4fpD+/3uhvZkmdDvgURiCpyGs/L+aVDdFdvN
         Y9Xt7e/Q76wKUD8cCAIcKw3id8vZqqpFA+yxinET+h4OReZtxNa7HNoj9hTQoOfWMrLX
         QMum5xjXhaIy4tbZ6zHuS7G3ZaN8mF4VVTxf9RxFG8sESEBrsRZvWM4UnB8/SuV2T8MF
         vLYGuyLK1OELQ5Eu5RZ4pnA5okn2Ltq6g/fU6CMEwTHJqXlvwVRtRYa0rslxfxJc03is
         nsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXs+PETp5F1sLmKlUpnJ7KVN9WjqhwaoNYx00yCpTSY=;
        b=YHJ/B5DRYmxevrR5bVF2PXbQ/MA1jbYqadvmaDCakswh4yTIOyomig2L7Oq3zWvSsn
         3dkSQUyJUqIRsiClXUzy0C6KORP/Cl03MV7+z05NGzVEbskhmgajDms0adkdWE/Ll2WW
         r6ECpYAvUYm98i7cmte7p1tuqh9eZMC/5UoUvWpnR1gqNprVgD2Ody88saq18QSXFz6/
         7J0vRfu6fUXyPxDP4/I7K4CGnmxDHfv+I7QK1dhKw5RqX3ilEvaY9wzXqjvsAwzb/7YL
         UKhp1s3hrr55sC8WOQtVFPA/B25MWeIfOxo92OtpqZFuVEhAVsEUNr/daVBGU5YDCGq3
         n7CQ==
X-Gm-Message-State: AFqh2koUmPr+b5SuR21/8QQM3Aq5zzrizqa4UBCODxmh+yKmlJM0JeT2
        p4CSCLC3RRTzKxNaIFICADmdOWMUQHXZDl+03yg=
X-Google-Smtp-Source: AMrXdXsRFyZO21OsR6MyDEqPE+3QuBmJxj3hiIt8xfTZZTF3BZtZ4kJ3PzB1F5J33iMonRQPeM0Pd2Y/++tDb5LWlgo=
X-Received: by 2002:a17:906:3989:b0:7c1:1f28:afed with SMTP id
 h9-20020a170906398900b007c11f28afedmr2446393eje.678.1672344715221; Thu, 29
 Dec 2022 12:11:55 -0800 (PST)
MIME-Version: 1.0
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com> <d09d2480-a21e-69b3-90e4-5f361947057b@lwfinger.net>
In-Reply-To: <d09d2480-a21e-69b3-90e4-5f361947057b@lwfinger.net>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 29 Dec 2022 21:11:43 +0100
Message-ID: <CAFBinCBYbmrxP7UegAO7n7d1Dd=xo4pG1RE=H5-NVoSRX=Vdvg@mail.gmail.com>
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Larry,

On Thu, Dec 29, 2022 at 6:41 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
[...]
> I do not feel qualified to review these contributions, but I have some suggestions.
>
> The first is that the subject should start with wifi: rtw88: .... That is a
> fairly recent change that you likely did not catch.
Oh, this is something that I missed. I'll wait until tomorrow to see
if I can get Ping-Ke's Reviewed-by on patch 1 and then re-send the
whole series with fixed subjects.

> My second comment is that changed patches should have a version number to
> identify that they are new patches.
This series had four patches from the beginning. So no patches were
added/removed during the lifecycle of this patchset.
I think the cover-letter subject is a bit misleading as it contains
the words "SDIO support". In fact the issues (which are fixed by this
series) were found while working on SDIO support, but they also apply
to existing PCIe/USB support.

> [...] Once you have generated the patches, you
> should then edit them to indicate what change was made to each patch in the
> various versions. Such explanations should go below the --- following the
> Signed-off-by line, and end with another ---. With these additions, the
> community, and more importantly Kalle, can keep track of the various versions,
> and know what reviewer's comments have been addressed.
Noted. I will take care of this in v3 along with the updated subjects.

> I know of several people that have asked about SDIO versions of these drivers.
> They will be pleased to see them become available.
Thanks for the motivating words :-)


Best regards,
Martin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB5C62E1EF
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbiKQQbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiKQQbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:31:23 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EE562051
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:29:17 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13bd19c3b68so2726220fac.7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tD3p08t1ffwdPbmxJziuc8x27/dvuBcFvSizZVZtxro=;
        b=JF2mrxFAK/JIKjmOOMD4PRrVnl82tYxoqV4Rtfd5dfZ/FkFcpdomogsJ9NmrgVN6HY
         V2KMYnrlaM4CPsnOXvLthHMogd8Gx1UDkSXPiioLvW44zU+B4EoQRiA5745zImU8lJtl
         8tvTvhchow0RWnhXNx39Qh2fxwbdX0w2vKhxTQ/AKWu5oIUu62pDPmD82UKQBjnCRNN0
         uc5epBWLORFqUCZs1runmb/fxeBz8q0ttUB8MxyqdNYVGdpTwBmTN900uPmgODiMnedu
         TKZCqq7dT1QMwHQuOF7D2mwerCbFRSnCDqBGg9OPKFCp9r308Aaye91gusbx2zrZXB0H
         6+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tD3p08t1ffwdPbmxJziuc8x27/dvuBcFvSizZVZtxro=;
        b=5jr2d3zUox5zlTDSQP9hzaGTUzlx7bkYfpbagbL0rx8nLslLO2/lsyYabABFy4XWMh
         F4EZVQsAbW1QZV/uy5sIRuzH5B+LmSOqP9ypn9/AC9+pD4HVdqCiJQqNG5/8hsZs5ONB
         prydF/KEqjhev8slnueVZmHEdjp1QSh6zZaPmaqPe9jPraLjUJ0E+IThDpPZAeGycUGN
         QzjvyKBXlnkjLg1ZqQQadeV4iVNAwi+Meu4e6BD8sHp7VkzK+vdwEO1Eu5LERnUHRJDM
         H1s1CNp+YRpoervKWUezk+1eSjtr1XqSUgesJXp6QOlePXZKja2CrBawVTIVFeAjHidh
         KN6g==
X-Gm-Message-State: ANoB5pn59C3xcxP0So+2bZyoSZL7KA2y/3Em1q6KO2i+fanjye33zgY7
        xdCSLNuk4craodTGVV9WoAsdfHQwgIoQlprsG53gwg==
X-Google-Smtp-Source: AA0mqf7HmNBMBucy/LIwEImPZAdAtwLgcbJCRNliLUEr10IDCJeKlA/j3Io+Q+QnOi4YGLuKYsnfT4hhpl8PgGXwW3Y=
X-Received: by 2002:a05:6870:b689:b0:13c:7d1c:5108 with SMTP id
 cy9-20020a056870b68900b0013c7d1c5108mr1687283oab.282.1668702556927; Thu, 17
 Nov 2022 08:29:16 -0800 (PST)
MIME-Version: 1.0
References: <20221115095941.787250-1-dvyukov@google.com> <e5a89aa3bffe442e7bb5e58af5b5b43d7745995b.camel@redhat.com>
 <CACT4Y+aiGFRoBGz6m9SQME98K_awscXpXES3TZPDgR9i7cQL3Q@mail.gmail.com> <040d238e73a155789ff3cf2e6c70bbc27991cb81.camel@redhat.com>
In-Reply-To: <040d238e73a155789ff3cf2e6c70bbc27991cb81.camel@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 17 Nov 2022 17:29:05 +0100
Message-ID: <CACT4Y+agc1=bzeWKQS_Mo_bfZAaj_w4qNgH-1GsUVbr6XbdZzQ@mail.gmail.com>
Subject: Re: [PATCH net-next] NFC: nci: Extend virtual NCI deinit test
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 at 15:58, Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Tue, 2022-11-15 at 10:59 +0100, Dmitry Vyukov wrote:
> > > > Extend the test to check the scenario when NCI core tries to send data
> > > > to already closed device to ensure that nothing bad happens.
> > > >
> > > > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > > > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: netdev@vger.kernel.org
> > > > ---
> > > >  tools/testing/selftests/nci/nci_dev.c | 10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> > > > index 162c41e9bcae8..272958a4ad102 100644
> > > > --- a/tools/testing/selftests/nci/nci_dev.c
> > > > +++ b/tools/testing/selftests/nci/nci_dev.c
> > > > @@ -888,6 +888,16 @@ TEST_F(NCI, deinit)
> > > >                          &msg);
> > > >       ASSERT_EQ(rc, 0);
> > > >       EXPECT_EQ(get_dev_enable_state(&msg), 0);
> > > > +
> > > > +     // Test that operations that normally send packets to the driver
> > > > +     // don't cause issues when the device is already closed.
> > > > +     // Note: the send of NFC_CMD_DEV_UP itself still succeeds it's just
> > > > +     // that the device won't actually be up.
> > > > +     close(self->virtual_nci_fd);
> > > > +     self->virtual_nci_fd = -1;
> > >
> > > I think you need to handle correctly negative value of virtual_nci_fd
> > > in FIXTURE_TEARDOWN(NCI), otherwise it should trigger an assert on
> > > pthread_join() - read() operation will fail in virtual_deinit*()
> >
> > Hi Paolo,
> >
> > In this test we also set self->open_state = 0. This will make
> > FIXTURE_TEARDOWN(NCI) skip all of the deinit code. It will still do
> > close(self->virtual_nci_fd) w/o checking the return value. So it will
> > be close(-1), which will return an error, but we won't check it.
>
> Thanks for the pointer. The code looks indeed correct.
>
> And sorry for the late nit picking, but I guess it's better to avoid
> the '//' comment marker and use instead the multi-line ones.

Right. I am used to a different style and checkpatch did not complain. Sent v2:
https://lore.kernel.org/all/20221117162101.1467069-1-dvyukov@google.com/

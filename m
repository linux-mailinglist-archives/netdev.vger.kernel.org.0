Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4025B62DD26
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbiKQNrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiKQNre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:47:34 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F84748C7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:47:33 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id l42-20020a9d1b2d000000b0066c6366fbc3so1061306otl.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mGx8yZ0qkf2Q0D+uOV9wcGtD/MBDKLdMoK/x9Th4tUY=;
        b=b/O+aqwd9BtGrYA/twn6B8riZVFW5gc883ABDowWs1/dGLjjCna7ZpAia8oLv3AQdt
         FlMjA9J5W50Rwp0HAaKc84SLQ8UNQD/KsZUEUyyvoC1julgGaubl4vNEw+SVxzkD5SxR
         5yYN2qsrAaNurLk0r+MiUJExaNfI6sVaWq6rFg0tajL0IhgZUgBdbja9Kmf11ZuWOrGp
         diOYiZx/LuO3VWe+CRgxG9kGHqv23bWKE/JZzlDRzdtIuv2EG9uByIAbnYn/MraTW29y
         9udyY3rKzCqHGjnkSdpsmF7Y7Xh8VC9GAaHTTcuUv0r6pCTDECF753TtSM0h/gaXKifr
         Ml1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mGx8yZ0qkf2Q0D+uOV9wcGtD/MBDKLdMoK/x9Th4tUY=;
        b=P0NYW32cCxDYyjzFyI8Z0r9IYDCy77z8xTb89uJ89IWzDI2gMRuNxez5m7LjTEB6dC
         GohCEH29n/cLAylIebHc1pBxb9SF55tPSUYcLkE6T2scwYzcAxND45bDjoYQZQ8rKFn1
         wTd7Op0iv/q+0amnYq6P1NstdN2rB2n72b9+JckvtPcNgQX0LRNRwPt9vmT3eyJZpCgv
         tNgyJ+EQIQS1mmjvasAFDsEkTBmktup7VcPwUclbgecvqbzZx9aTxoNrFuH0+OIT0CMc
         nqpTHkKjwIwRRP01+0UwsFSLs72is+Jd1gMggT2Ss4WHlnEi0FdvIPENLKJbS2JEU7q5
         fZ7Q==
X-Gm-Message-State: ANoB5pnBJkcfA1inTUt1lzNS9gEvKGKjCFHHfJRZ7sdq6gvhS5+x14fp
        8bF9P72zTjUBbKiVw9JpzUsFYCxR0WYlWOh6hVuUSg==
X-Google-Smtp-Source: AA0mqf46s3GM09VTEKNVTuSrgM7M5G5GAoXUWecdLA3R0yn1vBvdxXt4gHMG6oLuiznFGW963u7K9kUOGkIn2zEoboE=
X-Received: by 2002:a9d:347:0:b0:66c:9e9a:1f82 with SMTP id
 65-20020a9d0347000000b0066c9e9a1f82mr1307590otv.269.1668692852429; Thu, 17
 Nov 2022 05:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20221115095941.787250-1-dvyukov@google.com> <e5a89aa3bffe442e7bb5e58af5b5b43d7745995b.camel@redhat.com>
In-Reply-To: <e5a89aa3bffe442e7bb5e58af5b5b43d7745995b.camel@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 17 Nov 2022 14:47:21 +0100
Message-ID: <CACT4Y+aiGFRoBGz6m9SQME98K_awscXpXES3TZPDgR9i7cQL3Q@mail.gmail.com>
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

On Thu, 17 Nov 2022 at 13:47, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-11-15 at 10:59 +0100, Dmitry Vyukov wrote:
> > Extend the test to check the scenario when NCI core tries to send data
> > to already closed device to ensure that nothing bad happens.
> >
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  tools/testing/selftests/nci/nci_dev.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> > index 162c41e9bcae8..272958a4ad102 100644
> > --- a/tools/testing/selftests/nci/nci_dev.c
> > +++ b/tools/testing/selftests/nci/nci_dev.c
> > @@ -888,6 +888,16 @@ TEST_F(NCI, deinit)
> >                          &msg);
> >       ASSERT_EQ(rc, 0);
> >       EXPECT_EQ(get_dev_enable_state(&msg), 0);
> > +
> > +     // Test that operations that normally send packets to the driver
> > +     // don't cause issues when the device is already closed.
> > +     // Note: the send of NFC_CMD_DEV_UP itself still succeeds it's just
> > +     // that the device won't actually be up.
> > +     close(self->virtual_nci_fd);
> > +     self->virtual_nci_fd = -1;
>
> I think you need to handle correctly negative value of virtual_nci_fd
> in FIXTURE_TEARDOWN(NCI), otherwise it should trigger an assert on
> pthread_join() - read() operation will fail in virtual_deinit*()

Hi Paolo,

In this test we also set self->open_state = 0. This will make
FIXTURE_TEARDOWN(NCI) skip all of the deinit code. It will still do
close(self->virtual_nci_fd) w/o checking the return value. So it will
be close(-1), which will return an error, but we won't check it.

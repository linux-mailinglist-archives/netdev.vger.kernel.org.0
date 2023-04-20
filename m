Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216296E9B35
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjDTSEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDTSET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:04:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B721FE4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:04:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a80d827179so12304035ad.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682013858; x=1684605858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8SDqO0kcGg6FMTWyVsYL0mmJaOaOLxA91lgupQ1gdY=;
        b=Nyi2njUwpgs4nxYJZ9TGq9Byk4xJGsTLIGigs4WOSIo2UhH6YOmZMIX9OJ7UMQJKP4
         XlXIhyrfGDuSmzWTbMgssVMHYQKyLQWIkdmyZelugAq1VrF3B0kZVQcQ4jWSSeAs49bw
         ObL12q+JYqpYe4V/8eNq1b29mWnBvCzitJe3QvKW2jrKnHa1SDA/a4DjvikurcxcGcDW
         wr2D5HNyAEe1dlcmLTXvt5YqxrKQp9Iq4NMqZad9PVS9N+uiBT9eaXEfdk8svBV+bUqv
         KozuK5M85FO3xw5jNVC9XNWjQUNjIvKCIqAKbpZSmYvHQEgndw3Q9bL5TcEedYt1bPFv
         RIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682013858; x=1684605858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8SDqO0kcGg6FMTWyVsYL0mmJaOaOLxA91lgupQ1gdY=;
        b=MOuON9N4gfhcNnY8foTV3a09SqN3miQX7WRT7d+4V1g4cL++QHUDM9KYDTkQspOw0z
         sDUQKP2U3MN4XGtHCfaJQfoxlv1lKYlishl8KwMHPstH71tf++/RLuh5lmuAl0l7iu24
         GNgFvRUhsZbehWjS1oBNBSx2XGdGqi4FWLql4g7pKCVWfKmiMzKV1k/wEFhk8Io1bbEz
         BDqnACTzyCKCcVQJb8W8g9PnYA3VU9ip1IT9A8IQfKFhKqeSjZhKnfKl+dadgnRq/WNH
         GH+9YHwknuIpOcY+lzKdYrrbgsp1a+X4WAoml8wAAqH/9Zx+OosTkx0/DVt3wivfKyES
         STWw==
X-Gm-Message-State: AAQBX9diSF2ztbnCWDnKZTc0I/kx6lICMXlCRSracFw/K55xl8ZGporx
        kxzfxmH5TMs5DhXHEC3XjC4ydOQSvuzEtvH0Cpk=
X-Google-Smtp-Source: AKy350ZRJ38kvhY577+hYYOGp6CfOzMa/n/5GgqgU8YypUX+RKoENOQQt3zf4lihRgmHeUi+CooND4pxNE5NZGFvSnU=
X-Received: by 2002:a17:902:c793:b0:19f:87b5:1873 with SMTP id
 w19-20020a170902c79300b0019f87b51873mr1961341pla.62.1682013857711; Thu, 20
 Apr 2023 11:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230405063144.36231-1-glipus@gmail.com> <20230405123130.5wjeiienp5m6odhr@skbuf>
 <CAP5jrPH__dJpGepM6Vs45PH+Pppx6KOVnUDS5f44DGeyseghfQ@mail.gmail.com> <20230420161609.2b65a1ed@kmaincent-XPS-13-7390>
In-Reply-To: <20230420161609.2b65a1ed@kmaincent-XPS-13-7390>
From:   Max Georgiev <glipus@gmail.com>
Date:   Thu, 20 Apr 2023 12:04:06 -0600
Message-ID: <CAP5jrPFytnMku6TQNFQGBh4-=mL0z3XVq7ofY1z3LPYMP7_G0Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] Add NDOs for hardware timestamp get/set
To:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, kuba@kernel.org,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 8:16=E2=80=AFAM K=C3=B6ry Maincent <kory.maincent@b=
ootlin.com> wrote:
>
> On Wed, 5 Apr 2023 09:54:27 -0600
> Max Georgiev <glipus@gmail.com> wrote:
>
> > On Wed, Apr 5, 2023 at 6:31=E2=80=AFAM Vladimir Oltean <vladimir.oltean=
@nxp.com>
> > wrote:
> > >
> > > On Wed, Apr 05, 2023 at 12:31:44AM -0600, Maxim Georgiev wrote:
> > > > Current NIC driver API demands drivers supporting hardware timestam=
ping
> > > > to implement handling logic for SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
> > > > Handling these IOCTLs requires dirivers to implement request parame=
ter
> > > > structure translation between user and kernel address spaces, handl=
ing
> > > > possible translation failures, etc. This translation code is pretty=
 much
> > > > identical across most of the NIC drivers that support SIOCGHWTSTAMP=
/
> > > > SIOCSHWTSTAMP.
> > > > This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> > > > functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> > > > to ndo_hwtstamp_get/set function calls including parameter structur=
e
> > > > translation and translation error handling.
> > > >
> > > > This patch is sent out as RFC.
> > > > It still pending on basic testing.
>
>
> Just wondering about the status of this patch series.
> Do you want hardware testing before v4?
> As there were several reviews, I was waiting for the next version before =
doing
> any testing but if you ask for it to move forward I can deal with it.
> Also, I have cadence macb MAC which supports time stamping, I can adapt y=
our
> last patch on e1000e to macb driver but I would appreciate if you do it
> beforehand.

I've updated the patches in the stack based on the feedback you folks
kindly shared
for v3. I'm currently testing the combination of the changes in
dev_ioctl.c and netdevsim
driver changes - almost done with that. Let me finish this testing,
then update the patch
descriptions, and I'll be ready to send it out for review.

Regarding e1000e conversion patch: I don't have access to any NICs
with hw timestamping
support. I was going to drop the e1000e patch from v4 unless someone volunt=
eered
to test it on real hardware. But that will have to wait till the rest
of the stack is reviewed and
at least preliminary accepted, right?

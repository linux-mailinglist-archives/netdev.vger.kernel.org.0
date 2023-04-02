Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449CB6D3AF2
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 01:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDBXdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBXdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 19:33:32 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB9559F9
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 16:33:30 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id mf5so2218925qvb.4
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 16:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680478410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXRZT07PfTkXWSL48Fr7NOKHa8UGZz9XYxY1pim7+Fg=;
        b=J2Fc7INCyPEgMSvpt/EjtwTVdouVAiDm9qii9+ahzzjVdQGFzEGcV7DlMcN0kz7rcf
         VrHZmg5Ey4db8TUBZhy3DlL/LZ09sURdFUqk+DuwpIGOstQ02mQSyKPhin+JBdFtINNp
         KDVZYF9q3hQEma1oBQ6vCqNzrCIooBFWyAQYV7F7VxO2zfWD+2rxJWZq/yJj5jFZa/j7
         5WlCoD/DoTTS5IxhYkdKsu7MJyGKG+HEt2kUEJbxZQmF7i2VcbXnFmqu0vwj+Y2xIIk4
         px8QkpN9D+CKNGIAFAAPJU4k8fHPAPOcQox3lwQW0SQ3gmg1prTLinXStBL69OFvk2n/
         BAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680478410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXRZT07PfTkXWSL48Fr7NOKHa8UGZz9XYxY1pim7+Fg=;
        b=38y67lNJ8aMLJHm9s2KggxfIowndHY0bfjTXZGge6+PoM2/1hRWX9CotuhIDcH9LjA
         kJQIcicn/S9idvJ80ma+3cK5tYho2Cs+jef4DhihB9PGXTX7TGoMIJuuu4hgrsqcK9/A
         Z3Q2+NrSRre3wjf0/gADIZcID9s6+UMz5dWBFwE5z/ztG/Su8/m/e+q371ZjYiSk+abm
         PM/IBpnqcGsdgVmrnBE8cnVK9Yn3Z7JHQMd5TS9FDab9wQNqj4ggoU061HfkFC3QJ7xT
         Y8hmc2QBRsRS1zBwE/6/NEI63ZaGhKJx9xRXRzjK11UWuSk1AVarsxqVknRHnWQEru+l
         Udrw==
X-Gm-Message-State: AAQBX9fsJe1fNP31Z2fKEK8QsUVQxjIAmNS/7pyF2Rifvq0MDRdPM2N7
        aiggK+TVjaPJQ77vwW0O1RUI/6gK+0rmlzOmQuY=
X-Google-Smtp-Source: AKy350Yp4qt734NODeXLcA+Gy2h1+FKXY43twBJd/TXX4a8Vq875niBXBq9Fr7tUOnH3kl8H/qvdk74RZjM9Xi3Vy6I=
X-Received: by 2002:a05:6214:162e:b0:56e:952e:23ec with SMTP id
 e14-20020a056214162e00b0056e952e23ecmr3562543qvw.2.1680478409994; Sun, 02 Apr
 2023 16:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
 <ddab653a-c3f6-9b9f-2cac-ed98594849b5@gmail.com> <baa2f821-ddbc-3ce3-02d2-8d4d9e438fd1@gmail.com>
In-Reply-To: <baa2f821-ddbc-3ce3-02d2-8d4d9e438fd1@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 2 Apr 2023 16:33:18 -0700
Message-ID: <CAFXsbZpdLbcpZzO-4FSdaMo1CNn4yYZ9=Pa-UBu+zOVn7DFpiA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: phy: smsc: add support for edpd tunable
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 2, 2023 at 7:58=E2=80=AFAM Heiner Kallweit <hkallweit1@gmail.co=
m> wrote:
>
> On 02.04.2023 16:00, Florian Fainelli wrote:
> >
> >
> > On 4/2/2023 2:43 AM, Heiner Kallweit wrote:
> >> This adds support for the EDPD PHY tunable.
> >> Per default EDPD is disabled in interrupt mode, the tunable can be use=
d
> >> to override this, e.g. if the link partner doesn't use EDPD.
> >> The interval to check for energy can be chosen between 1000ms and
> >> 2000ms. Note that this value consists of the 1000ms phylib interval
> >> for state machine runs plus the time to wait for energy being detected=
.
> >
> > AFAIR Chris Healy was trying to get something similar done, maybe you c=
an CC him on the next version?
>
> Actually this is based on a conversation between him and me. Chris came u=
p
> with a first version and I reworked it from scratch to meet mainline stan=
dards
> and make it usable on SMSC and Amlogic PHY's.
>

It's great to see this feature coming together.  I wish I would have
had more time to help out.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D881F091A
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 02:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgFGAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 20:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbgFGAZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 20:25:24 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED42C08C5C2
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 17:25:24 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k18so7013250ybm.13
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 17:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zTJbwB3jMitnFiGQ2EnpobZ7MaZTSI7kjFKySDFQZLM=;
        b=FeGaCMfjztWa0oWvkaUMlq5w15mAjMYe6DzFWT/C3btaUCfqn6J1fZjlpwgq6AXX7Y
         Za21LrhcmOhdvKlusHmtkPvOk88ojCXKy1mFCs6VevUfTBH8iaWvpX/HZscUuhtv/7fG
         T1m8a7U+CgBwnYgZgYLnA4lOXPkyVSXiIB/jyaIxtx0ItBwta5PgQWyen9uiCFB3A0DU
         lXizQMQto3tNRocJXtdlEy7V9j291LYo4mKBWFNZZPuywj5TpKRkm62DBC2/XlU90thT
         eyLN2Tyo3KsozXOJr4SgR6X+IJssNs++QDZ6noz2qdJX8Ey0ZJ52vpG+vMeO6wHYaoLM
         Yiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zTJbwB3jMitnFiGQ2EnpobZ7MaZTSI7kjFKySDFQZLM=;
        b=hZCdPZRGt6A0Du3cRnthmpYb4yFUXjK6hPC8OyCLcRrZr37KeZDLZZ+qivMWQ7m7tJ
         NSmU1KD0r7OnL1aDxeOAWDnfJ9wp4KXrvtz8BFMvOli/KWnuxJVdM7dCCZhjp/hd9piH
         DUUV2CDbAiH/RNIY4LSXWPk8/Uvx1peig5SK2FJdoFiw4KQiZn30oM0CAEVs8ygjkoT2
         zi93BD3+GYuYHiB6Rk9wwoMf5bn8podEF+UIMKRNiCrq3O43DyeRr95jBgSPDnboLRdC
         3+XLa4UOykh4b+Afijsixhqqcw7S8bIukHfRWQdDHHAzbWB+WjHtlbhEVR/2xcemq9vd
         D6JQ==
X-Gm-Message-State: AOAM530UloTOdcxCB8982g43M2tQJObAHJLZo3FDY75WpsnKT/xDSGl8
        bXz62PgzDiknW0+pAAwiKLdh4uSpsqO0LFy7pn0abvsK
X-Google-Smtp-Source: ABdhPJxl6p0A6lLYrvtuhQSRADoqqqPEnSuI+DwaHGZVMDm1zh7EiRRFAslRy3hpG2yC/SP8Y+UcF4Ua9NpZ0T/oAUQ=
X-Received: by 2002:a25:3782:: with SMTP id e124mr27998028yba.403.1591489522195;
 Sat, 06 Jun 2020 17:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <3268996.Ej3Lftc7GC@tool> <20200521151916.GC677363@lunn.ch>
 <20200521152656.GU1551@shell.armlinux.org.uk> <CABwr4_vdWWRBMXeK9uGLnuK++9uuM_FBygypv_2PhCRnsOEcEA@mail.gmail.com>
 <20200605094910.GI1551@shell.armlinux.org.uk>
In-Reply-To: <20200605094910.GI1551@shell.armlinux.org.uk>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Sun, 7 Jun 2020 02:25:11 +0200
Message-ID: <CABwr4_u-UiJE5StOOREjAyMKSckisLSQSuFMCaQ7f9Vs8kx54g@mail.gmail.com>
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

El vie., 5 jun. 2020 a las 11:49, Russell King - ARM Linux admin
(<linux@armlinux.org.uk>) escribi=C3=B3:
>
> On Thu, May 21, 2020 at 05:55:19PM +0200, Daniel Gonz=C3=A1lez Cabanelas =
wrote:
> > Thanks for the comments.
> >
> > I'll look for a better approach.
>
>
> Hi Daniel,
>
> I've just pushed out phylink a patch adding this functionality. I'm
> intending to submit it when net-next re-opens. See:
>
> http://git.armlinux.org.uk/cgit/linux-arm.git/patch/?id=3D58c81223e17e394=
33895cfaf3dbf401134334779
>

Thank you.

Regards
Daniel.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbp=
s up

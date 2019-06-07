Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BDC39826
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfFGWCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:02:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41661 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfFGWCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:02:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so1392399pff.8
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MkdX1ByPuyyhMx7KgR9Las+8lYde8+TrNn+WFHUY5oA=;
        b=Np0FvSQCXoUcQB/aECH6jnG668iDsuwcUJMnC7GTrGLlxMFHTjAZGwpXYEkzb7h8HL
         K0ol0H621yvFSEi6beo0XqdAcJlVIALl8avTlb6mbS0V8qdV632P//ABtKK0IOSc1Dr4
         JkTOm60PvI8PrORLgcZqWI/CmpxkOdF5ZDmcEnfsTkhXyYwwkKePmt2KtUQSJfsd8P2h
         BFCZuGH6xvY+xd6ToMyncr3eu1hXJM0BiPwoDHTv0h7JA9X6B7spcsDHLITsI+WM/X+B
         J1TJUGzEIgg3biGmH/DVBB2gX88Ru7j7DyRMDVp2O2OJkib8B6ldtXl4x04OGoz657bR
         UDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MkdX1ByPuyyhMx7KgR9Las+8lYde8+TrNn+WFHUY5oA=;
        b=jAcQ1YPNfjss8xUAm5GLq2dNbsjaYfdOgWnG6Ca4nJENlY+dfRTZPJLyvappfB1cZ0
         B1B7Bodgnol/e6JC2z5GS/bkzuxqe+ZLtwY/OCRyJAB4mNyd3pZu/L8NEXVx01WaWHpW
         SKR7Lv820ppCCTkQa3DGe1p5xTjdmUYeSDykj9qOB4MKjBxr8O2wMb9GVG7nU6LCIP35
         bmkxFGG5bSuj5DFKLhN7pQNToTnvjUi9HR3F+9hGvfCJqU5GunkizkRfQW3NVqZWjraV
         ABCPgRXWqf3bqFqEyRGhn5Upn0PPO8kf1JxbJDtuxpOZqj9132yCnnMUBYPOp3GjojDD
         b/Dw==
X-Gm-Message-State: APjAAAXneAOmSyJpuIunAoPUz41LAR8R15ejQgQGYk6vR1cxPvB2m/9w
        dqdurMJyhFC06nlXDo/HbKV+hQ==
X-Google-Smtp-Source: APXvYqziT/57xaFqWXj1gqNNaW6lk1L1hsuclKTrQv7CVHbfe52j9M0GLbVRXvAZGNzRQEJhsEsz1g==
X-Received: by 2002:a62:b517:: with SMTP id y23mr63478584pfe.182.1559944968778;
        Fri, 07 Jun 2019 15:02:48 -0700 (PDT)
Received: from cakuba.netronome.com (wsip-98-171-133-120.sd.sd.cox.net. [98.171.133.120])
        by smtp.gmail.com with ESMTPSA id s17sm2308866pfm.74.2019.06.07.15.02.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:02:48 -0700 (PDT)
Date:   Fri, 7 Jun 2019 15:02:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next v2 4/6] taprio: Add support for txtime-assist
 mode.
Message-ID: <20190607150243.369f6e2c@cakuba.netronome.com>
In-Reply-To: <FF3C8B8E-421E-4C93-8895-C21A38BB55EE@intel.com>
References: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
        <1559843458-12517-5-git-send-email-vedang.patel@intel.com>
        <20190606162132.0591cc37@cakuba.netronome.com>
        <FF3C8B8E-421E-4C93-8895-C21A38BB55EE@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 20:42:55 +0000, Patel, Vedang wrote:
> > Thanks for the changes, since you now validate no unknown flags are
> > passed, perhaps there is no need to check if flags are =3D=3D ~0?
> >=20
> > IS_ENABLED() could just do: (flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST
> > No?
> >  =20
> This is specifically done so that user does not have to specify the
> offload flags when trying to install the another schedule which will
> be switched to at a later point of time (i.e. the admin schedule
> introduced in Vinicius=E2=80=99 last series). Setting taprio_flags to ~0
> will help us distinguish between the flags parameter not specified
> and flags set to 0.

I'm not super clear on this, because of backward compat you have to
treat attr not present as unset.  Let's see:

new qdisc:
 - flags attr =3D 0 -> txtime not used
 - flags attr =3D 1 -> txtime used
 -> no flags attr -> txtime not used
change qdisc:
 - flags attr =3D old flags attr -> leave unchanged
 - flags attr !=3D old flags attr -> error
 - no flags attr -> leave txtime unchanged

Doesn't that cover the cases?  Were you planning to have no flag attr
on change mean disabled rather than no change?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70623497C4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 05:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFRD0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 23:26:18 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34360 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfFRD0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 23:26:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so19407310edb.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 20:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QB8lwnfAWM5eSh/acU+B5HKYIehkA7mV7O4FwPzcexo=;
        b=ULNdvw8+tq8QeUnFaQePLqg1iryaaYp/aWw9fGLemPYhJkDQ2H5XhjVIbUsBgZd64F
         61o+JYMVnvgUgyC2GM30u6jjijf/A+ftp23F81RdhJ6D/jXzJERTFZQtARcBDdkleqUm
         eSS18Q1TKM1uvznC79K30CCQx89bqEa2ol9lykGFnO2MgthvqOpwwdQlIaF9soPy+4eF
         JjRf8fu6RYvl3V91iXvxVZWnUOBsUx2Y413J/6USyWI3DJBU5uVxOTO3zdofWGkN+zPM
         NZTnFSpl1IBQtE31RIDo+sedqJJ1JRgx6wCpeaKFcOVy9par13mVHGq1nrg8fik0S7v6
         NqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=QB8lwnfAWM5eSh/acU+B5HKYIehkA7mV7O4FwPzcexo=;
        b=sZz9joTf92UahcZELtgrs2HmdjvOFdHaCNeD5PxHeV7EwxulPfefxHjbn8DRk7mdeo
         r2Pyc2dyu4bXgICw29IUnK6KLddm+qB7ZXvid53YNeYApjfYg5emiHwTJn6vQ6qfFOTv
         0RLChM+AXvQBsBrj0HHbDhtDdquGqGP4cSGqzUWn2i7zy6KAAFUr9oSsC6wiWkjYafWh
         USZnO6zqUCSXICveLHY82wPiNO2DsiDYFrFijIw92pF44HW4LxHR5d/07LGxYhlazdPt
         +k8Z4CfD0onttWnS3VBG+yUHLDW/OXPYi2o3A4f3lT87j5rW5yZyGji2NbKFtKYBvMWp
         As8w==
X-Gm-Message-State: APjAAAWwfCEnfU2AWXVnVUnuIMG726x5fSzOgtdrOcmrCqy5fNyMW19u
        2sanvDS1JhC932JJ1GF76bAMFA==
X-Google-Smtp-Source: APXvYqxL2/de9bApOM2UVDgl9BgIS/9w1EYyRUg0PCwWi1lKmzkg9zrpNro5VMkplRIqrlo+htLQGA==
X-Received: by 2002:a50:b962:: with SMTP id m89mr58857595ede.104.1560828376089;
        Mon, 17 Jun 2019 20:26:16 -0700 (PDT)
Received: from localhost ([81.92.102.43])
        by smtp.gmail.com with ESMTPSA id d1sm1800559ejc.72.2019.06.17.20.26.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 20:26:15 -0700 (PDT)
Date:   Mon, 17 Jun 2019 20:26:14 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Alistair Francis <Alistair.Francis@wdc.com>
cc:     "troy.benjegerdes@sifive.com" <troy.benjegerdes@sifive.com>,
        "jamez@wit.com" <jamez@wit.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "schwab@suse.de" <schwab@suse.de>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
In-Reply-To: <d2836a90b92f3522a398d57ab8555d08956a0d1f.camel@wdc.com>
Message-ID: <alpine.DEB.2.21.9999.1906172019040.15057@viisi.sifive.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>  <mvmtvco62k9.fsf@suse.de>  <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>  <mvmpnnc5y49.fsf@suse.de>  <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com> 
 <mvmh88o5xi5.fsf@suse.de>  <alpine.DEB.2.21.9999.1906170419010.19994@viisi.sifive.com>  <F48A4F7F-0B0D-4191-91AD-DC51686D1E78@sifive.com> <d2836a90b92f3522a398d57ab8555d08956a0d1f.camel@wdc.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1540646092-1560828374=:15057"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1540646092-1560828374=:15057
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 17 Jun 2019, Alistair Francis wrote:

> > The legacy M-mode U-boot handles the phy reset already, and I=E2=80=99v=
e been
> > able to load upstream S-mode uboot as a payload via TFTP, and then=20
> > load and boot a 4.19 kernel.=20
> >=20
> > It would be nice to get this all working with 5.x, however there are
> > still
> > several missing pieces to really have it work well.
>=20
> Let me know what is still missing/doesn't work and I can add it. At the
> moment the only known issue I know of is a missing SD card driver in U-
> Boot.

The DT data has changed between the non-upstream data that people=20
developed against previously, vs. the DT data that just went upstream=20
here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D72296bde4f4207566872ee355950a59cbc29f852

and

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dc35f1b87fc595807ff15d2834d241f9771497205

So Upstream U-Boot is going to need several patches to get things working=
=20
again.  Clock identifiers and Ethernet are two known areas.


- Paul
--8323329-1540646092-1560828374=:15057--

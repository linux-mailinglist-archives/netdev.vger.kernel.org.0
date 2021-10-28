Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2321843DCA5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJ1IKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1IKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 04:10:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90091C061570;
        Thu, 28 Oct 2021 01:07:49 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g10so21099142edj.1;
        Thu, 28 Oct 2021 01:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PQMilxdsobKkZotwzejJFonaMjfKjSknBXqsMZvx0wQ=;
        b=AgFvAT9zwTDHSJqVCaMM2YgoGVQzzjcy7QBETqPIPji32DGYNI8PEyDIVqA8cJwvif
         dmN3LV517QGqQqfx+HOix1xqkSSPk4Srl70wIICbhOLQcw/BWxWrsrGrODN1AZq83omx
         J8w6NnMINGhee0OwIzXhNJQlcGyNoO8BbluvfQojTHRRATW6haxblgkLAHTZK0heCNTL
         asMRvE7sTKQt+LOdF7mkxNCQZjVVYktDjaK/ib9E7zS+7BHkKgrxLrcByJsfWA9J2Dkj
         eRDcfSu63in8CUEU5QJIht7nTNeQnFQDBaicKq8DdGg4uWSnJrAXShOCcjktCOAX4keQ
         V83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PQMilxdsobKkZotwzejJFonaMjfKjSknBXqsMZvx0wQ=;
        b=ddzb1ZB8m8uvv8fSajuAPrMUYxtbeFr9kKpm4PRV4QbqxHqtWCrom7rlH7vYtvGjE+
         fGQgR7NTRdGjKJgi9EPj+GWLUgpVOX2kWIbQMcClYqstC3uQl2OIGw00hGtWAHxzPme5
         7gwwtejQ1S0vr54ije9RA3rPlblq2Qw6HURl2E30Qx4vUQf/oUQLTRW85VSeDrIpJA6O
         TKuoYNQMitwnIF6/oNzbCBdeyxw9g7IRLvxhB2ruPXyFNuwC7YgKGHbV3ky0HJPx76/M
         Xc8C2HLxZOzBAaABmVl6cwCFCjFTByWKOqFEPABJdMq6Ls7mNW8zvDRWC8K4IQFzB2dY
         wKSw==
X-Gm-Message-State: AOAM530mK2ufKisRF4DSIZYArK/VT5JQ4h+dOJI5N5sEl12fd/fD8ATX
        ludGKkSbc8Vc6oaFHx85Cw+JHms5K4I+t4K20hktXGVpvGo=
X-Google-Smtp-Source: ABdhPJxP9iHBd7oEN+ZaEwTrOEY8H/DsYWGvPaQrRs80Sbt+ZjOPfv8zkxMu6fMkP9aMIIkj9DaNcJh2b12XhDuFEBY=
X-Received: by 2002:a17:907:1c9e:: with SMTP id nb30mr3500564ejc.141.1635408468100;
 Thu, 28 Oct 2021 01:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211028073729.24408-1-verdre@v0yd.nl>
In-Reply-To: <20211028073729.24408-1-verdre@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 28 Oct 2021 11:07:11 +0300
Message-ID: <CAHp75Ve3Rp7AziB8k8ESM41xEV8uNWD21Wh_MPcRqfDcJ0QR-w@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:38 AM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
>
> The 88W8897 PCIe+USB card in the hardware revision 20 apparently has a
> hardware issue where the card wakes up from deep sleep randomly and very
> often, somewhat depending on the card activity, maybe the hardware has a
> floating wakeup pin or something.
>
> Those continuous wakeups prevent the card from entering host sleep when
> the computer suspends. And because the host won't answer to events from
> the card anymore while it's suspended, the firmwares internal
> powersaving state machine seems to get confused and the card can't sleep

power saving

> anymore at all after that.
>
> Since we can't work around that hardware bug in the firmware, let's
> get the hardware revision string from the firmware and match it with
> known bad revisions. Then disable auto deep sleep for those revisions,
> which makes sure we no longer get those spurious wakeups.

...

> +static void maybe_quirk_fw_disable_ds(struct mwifiex_adapter *adapter)
> +{
> +       struct mwifiex_private *priv =3D mwifiex_get_priv(adapter, MWIFIE=
X_BSS_ROLE_STA);
> +       struct mwifiex_ver_ext ver_ext;

> +       set_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &adapter->work_flags);

This does not bring atomicity to this function.
You need test_and_set_bit().

Otherwise the bit may very well be cleared already here. And function
may enter here again.

If this state machine is protected by lock or so, then why not use
__set_bit() to show this clearly?

> +       memset(&ver_ext, 0, sizeof(ver_ext));
> +       ver_ext.version_str_sel =3D 1;
> +       mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
> +                        HostCmd_ACT_GEN_GET, 0, &ver_ext, false);
> +}


--=20
With Best Regards,
Andy Shevchenko

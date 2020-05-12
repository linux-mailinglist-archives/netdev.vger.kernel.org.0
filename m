Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D641CE980
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgELALG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgELALF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:11:05 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC093C061A0C;
        Mon, 11 May 2020 17:11:04 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bs4so3312348edb.6;
        Mon, 11 May 2020 17:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hOqV8j9IN2A6jKf5ay59p7rGKbxBmKtpgqCRdoN7oBA=;
        b=srSeBRdjN+wxeP8+BmcndQItu+zIv1Mc7N8BIpDur2MvTgLA2Ka3xn1owm1R8eJ68Z
         AVCAnU3B5gnH9Cl1xQjp3TEMU/fgkuqDq9dfFcHwjxIbzZaUkTmMvinrP0RqvLAN6PuQ
         cUXYA2CSfb6fxiz9uiniEWL36w2CzqzpKQkgxwTLQQ5aLx39/7poIM9Nb7a8Miw32Y/8
         Dq+oNQMCQ1eknZIu63I/B/qfMEGB0+REtnKNFwS7dqIaNu2q9NLzKu5ux8vlvGSRAMUp
         SyXmP+BYnt2VVTT7FvtPE7GxjstjQVz7xKhUC1EiXglSKHgf+pfHFPsBGRcK+SvYTyz6
         Cubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hOqV8j9IN2A6jKf5ay59p7rGKbxBmKtpgqCRdoN7oBA=;
        b=ZTLd05G+zX0Ltie56888SMniYI2heg/TZMCXauDnz3uVPgJHZi6XgsVtNL0gHNYwJ4
         qWOx6flATgk8N+J74RxqORx3JJWrzmqy1JujVNEp+1ha+klkkDM7iyrDtXEHkWCgjssy
         0KxwYhP56OyEhNNWwO3Sy0N/kjsqxmNMjPnN0QLN4TxkXH5UqSxX1kTeA3LoDhEiqUTg
         q3aEHs9gD2Z/20VYFh9/FXE4MFEbWeLc3l5CYl6v+rWtzULW8lkQX1boBw6WbRCWV9tZ
         wzA+KBzaAkshHhqp2oYXmq2pBPatVzpBtTf608h0NuJwZiJnVZ3R74gOSu6mIpGdNy+u
         PDng==
X-Gm-Message-State: AOAM531kmBrzy/fFUOj0TVfPXJbXk1Kz+zXyuQR8QNF9x/5++iGsJx7w
        j0B/h7aK6UXkXzMo/DpTqcVt9zPrpLk5o9kKuPw=
X-Google-Smtp-Source: ABdhPJwquuFuOo8MmTSLHwdLyGKmRZe+FAhOJHPLxJhQmp2kVt7BdWeIxELPK2fqEsxK7HnWvJAG9+SF1JMJnso3xDU=
X-Received: by 2002:a05:6402:417:: with SMTP id q23mr1612226edv.139.1589242263466;
 Mon, 11 May 2020 17:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
 <20200511054332.37690-3-xiaoliang.yang_1@nxp.com> <20200511.165258.1371001598940636146.davem@davemloft.net>
In-Reply-To: <20200511.165258.1371001598940636146.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 May 2020 03:10:52 +0300
Message-ID: <CA+h21ho3NStn5BSBA1FjfRy6H0QTepGPyLT8xgCSB5af6PaHqg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 2/3] net: dsa: felix: Configure Time-Aware
 Scheduler via taprio offload
To:     David Miller <davem@davemloft.net>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        linux-devel@linux.nxdi.nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 02:54, David Miller <davem@davemloft.net> wrote:
>
> From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Date: Mon, 11 May 2020 13:43:31 +0800
>
> > @@ -710,7 +714,7 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
> >       ocelot_port_policer_del(ocelot, port);
> >  }
> >
> > -static const struct dsa_switch_ops felix_switch_ops = {
> > +static struct dsa_switch_ops felix_switch_ops = {
> >       .get_tag_protocol       = felix_get_tag_protocol,
> >       .setup                  = felix_setup,
> >       .teardown               = felix_teardown,
>
> There has to be a better way to do this, removing const for operation
> structs is very undesirable.

Actually I think this was at my suggestion, but now I agree that it is
a bit undesirable.
struct felix_info is on its toes in case vsc7511 or any other switch
revision will be added to the felix driver. It is likely that those
other chips will have hardware support for a different set of qdiscs.
So we thought of populating the .port_setup_tc conditionally,
depending on chip version (while also having DSA return -EOPNOTSUPP
automatically when the function pointer is NULL). Otherwise an extra
function call would be needed. But I think that keeping felix flexible
for more hardware revisions is a concern to be had for another
time/somebody else.

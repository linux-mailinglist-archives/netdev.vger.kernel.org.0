Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB3CBC5B1
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 12:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409485AbfIXKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 06:33:50 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:43719 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405020AbfIXKdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 06:33:50 -0400
Received: by mail-yb1-f194.google.com with SMTP id m143so484352ybf.10
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 03:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b5CfknOx8MYbDZD00YrkFh/nPNyVy6xDCxngUzuwp9o=;
        b=c6nu95IecfGuUVotf2D1e7wWm30yCZoGUs5vzcEbJdDfyxBjAKBXzcr6xxpMK0amF2
         BTl0/YZG4YkcQagWZUGv5c5FPiOr+3Z/JmUU93nQ8DCHzk0ShqKAZMpX98SRm9Fae4Lt
         Ocj2efJVdceqsONaYF56BP8xU+HvCa9BycvwFFeh9e4kJg3tLJ0WbmOBXg14p3S/Eyol
         5X2EcHaaB4eaZda33ee28ICcWZVkZFDKORZf/Lh6w3g9Aw6kIAk0WKrgCky9OwUjPCbg
         bK37ZqNeVyIb0xJAuW04xZd5CXvnvCRzwnYYhdKqEY5uDr484SeVDWpF8bviFfJzIgP9
         VF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b5CfknOx8MYbDZD00YrkFh/nPNyVy6xDCxngUzuwp9o=;
        b=oMUDa93kguF9pWTW7XdbXYI6MT3TDee2MzZcWhKuEb5oZVlNKsxleecgO6D4wR6HH/
         dgMWSDMe4jxr8nr4XK3t3vppUEzeZLS14PXzbYs7j87of9hs3FgfVCcyA02Eb21AbqXD
         HHPtuAqJMakud28mjQB57aSJ1RRRR3fkL8lfULBICYl+lEizr7jJLpR/xevphenIDxnh
         XwFCydEFpUtnLZYQXGHnG2Mq+f6BsVKI8i1Wceb/R2QdwSPIW5fWgAg2uxFwqtZrDhdS
         5tWli5qEWvrJWutWNfDDTaqUK8cw9GWJEwsQx0B0MeCFCnZ/yc8pAj5f4DETOnG3RCdr
         UV6A==
X-Gm-Message-State: APjAAAVYOSOunm6rdEOyX3L1/GB7mZwbOIEXevhO6JvA+7spmD0DOciC
        pXJezRaWIo9JZSjhULQ7eb11jiVKHOr37P3EYJE=
X-Google-Smtp-Source: APXvYqwXBwaGyzlDGQQzjGOGcrxQpT8672nC/VLwLJ/bJpoNXvv1wm83ZFzgDo/eKV/aMyonpGf3GOjaZKwJ3RtEjnw=
X-Received: by 2002:a5b:c47:: with SMTP id d7mr1481024ybr.129.1569321229305;
 Tue, 24 Sep 2019 03:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <1568882232-12847-1-git-send-email-wenxu@ucloud.cn>
 <CAJ3xEMhQTr=HPsMs-j3_V6XRKHa0Jo7iYVY+R4U8etoEu9R7jw@mail.gmail.com>
 <cc63e5ba-661a-72c3-7531-7bd09694549b@ucloud.cn> <CAK+XE=kJXoWBO=4A2g9p0VTp7p-iN4Eb-FB+Y9Bdr0vJ_NwiYQ@mail.gmail.com>
 <9797258f-0377-daad-e827-67713d3fba9c@ucloud.cn>
In-Reply-To: <9797258f-0377-daad-e827-67713d3fba9c@ucloud.cn>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 24 Sep 2019 13:33:37 +0300
Message-ID: <CAJ3xEMgWr9u2W4pjLj5-bkcJ9-wCySyjtzFLSwQGGmPsigEUkg@mail.gmail.com>
Subject: Re: [PATCH net v3] net/sched: cls_api: Fix nooffloaddevcnt counter
 when indr block call success
To:     wenxu <wenxu@ucloud.cn>
Cc:     John Hurley <john.hurley@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 5:21 PM wenxu <wenxu@ucloud.cn> wrote:
> =E5=9C=A8 2019/9/23 17:42, John Hurley =E5=86=99=E9=81=93:
> > On Mon, Sep 23, 2019 at 5:20 AM wenxu <wenxu@ucloud.cn> wrote:
> >> Hi John & Jakub
> >>
> >> There are some limitations for indirect tc callback work with  skip_sw=
 ?
> >>
> > Hi Wenxu,
> > This is not really a limitation.
> > As Or points out, indirect block offload is not supposed to work with s=
kip_sw.
> > Indirect offload allows us to hook onto existing kernel devices (for
> > TC events we may which to offload) that are out of the control of the
> > offload driver and, therefore, should always accept software path
> > rules.
> > For example, the vxlan driver does not implement a setup_tc ndo so it
> > does not expect to run rules in hw - it should always handle
> > associated rules in the software datapath as a minimum.
> > I think accepting skip_sw rules for devices with no in-built concept
> > of hardware offload would be wrong.
> > Do you have a use case that requires skip_sw rules for such devices?

> When we use ovs to control the tc offload. The ovs kernel already provide=
 the software
> path rules so maybe user don't want other soft path.

this (programming the rule to both tc and ovs kernel DPs) is a choice made =
by
the ovs user-space code and could change later. Actually, for complex use
case such as connection tracking, there might be cases when multiple tables
are used, when the 1st packet/s would jump before hw to sw TC tables, so
using skip_sw will likely not to work and we'll get bug reports. The produc=
tion
TC configuration we use/recommend with for overlay networks e-switching
is "both" (=3D=3D "none", i.e none of skip_sw or skip_hw).

> And with skip_sw it can be easily distinguish offloaded and non-offloaded=
 rules.

per tc rule, the kernel reports on offloaded vs not offloaded
packet/bytes, so the
info is there. In the system level, I don't think it's good that on
point A in time
we blocked skip_sw rules for tunnel devices and at point B we enabled it fo=
r no
real/good reason, I vote for blocking it again, since as Pieter
explained disallowing
this is not consistent with the kernel SW model on the receiving side.

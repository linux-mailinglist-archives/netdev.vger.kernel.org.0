Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C47A6DE46F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 21:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjDKTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDKTCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 15:02:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B533AA3;
        Tue, 11 Apr 2023 12:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5CF8625F7;
        Tue, 11 Apr 2023 19:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3D2C433A0;
        Tue, 11 Apr 2023 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681239736;
        bh=QNGFZG+0FP4MiP9ZLTe2C0i6kcwFZTtZnUc+WXNjaSk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YsWsRQhKUjx5BxlD7iVZrSSuZgX5yGMQvuP42NmdhMO92CGcuJfMDJ20qCtRsRJcD
         F94KeXCJBpPKn+OGzbcVZ4hpThDDRFv62ka4idJ0uOxRrOX+YkGMKRGzYPrN9038Wl
         vOq+fy3/4bw0Ntz7fQWs7qBVm9/C3pkleMErfKUnvWvexjNTwoXz/7dAU3VUkf8x96
         VZqy2u/bQ3SJpYsXXz9g8aZp6MpCWqW3jMreA+jsaoWNtWmfGMOfyoM3xuqMHmQuT5
         l1hBDVf0iL3o1GcqZRRITl1TXmWr2ZVCJzsRFIEO2uzWRWmZUKAJKkn4PF8n1HDNWB
         kRU962nVpaZEw==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-54ee0b73e08so178749447b3.0;
        Tue, 11 Apr 2023 12:02:16 -0700 (PDT)
X-Gm-Message-State: AAQBX9dcsZBghpXQPLjXqyA3hjzEMtHEUZlC3BiIHLLyx5w9RYgAJ7Ys
        jOxC4uzo/CgXJJ3/pNDYwKGTv5TsoBvIETQhxw==
X-Google-Smtp-Source: AKy350Ze5hfFXMFMJbWjbNiov/fFkM8IZsuKDtzpLuSJGb+QEwiRJ6fkdrKag9pzHkolT1dcPO8Kc5+KO6orbOrnTZM=
X-Received: by 2002:a81:ae1d:0:b0:54f:84c0:93ff with SMTP id
 m29-20020a81ae1d000000b0054f84c093ffmr717809ywh.5.1681239735149; Tue, 11 Apr
 2023 12:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230410213754.GA4064490@bhelgaas> <m27cuih96y.fsf@gmail.com>
In-Reply-To: <m27cuih96y.fsf@gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 11 Apr 2023 14:02:03 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+nLP6rh3pdK3-5a8-mjR=dF48i-Z8d8u7N=fuYoCk92A@mail.gmail.com>
Message-ID: <CAL_Jsq+nLP6rh3pdK3-5a8-mjR=dF48i-Z8d8u7N=fuYoCk92A@mail.gmail.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
To:     Donald Hunter <donald.hunter@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Rafael, Andy

On Tue, Apr 11, 2023 at 7:53=E2=80=AFAM Donald Hunter <donald.hunter@gmail.=
com> wrote:
>
> Bjorn Helgaas <helgaas@kernel.org> writes:
>
> > On Mon, Apr 10, 2023 at 04:10:54PM +0100, Donald Hunter wrote:
> >> On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
> >> > On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> >> > > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> w=
rote:
> >> > > >
> >> > > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in =
card)
> >> > > > because it apparently has an ACPI firmware node, and there's som=
ething
> >> > > > we don't expect about its status?
> >> > >
> >> > > Yes they are built-in, to my knowledge.
> >> > >
> >> > > > Hopefully Rob will look at this.  If I were looking, I would be
> >> > > > interested in acpidump to see what's in the DSDT.
> >> > >
> >> > > I can get an acpidump. Is there a preferred way to share the files=
, or just
> >> > > an email attachment?
> >> >
> >> > I think by default acpidump produces ASCII that can be directly
> >> > included in email.  http://vger.kernel.org/majordomo-info.html says
> >> > 100K is the limit for vger mailing lists.  Or you could open a repor=
t
> >> > at https://bugzilla.kernel.org and attach it there, maybe along with=
 a
> >> > complete dmesg log and "sudo lspci -vv" output.
> >>
> >> Apologies for the delay, I was unable to access the machine while trav=
elling.
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=3D217317
> >
> > Thanks for that!  Can you boot a kernel with 6fffbc7ae137 reverted
> > with this in the kernel parameters:
> >
> >   dyndbg=3D"file drivers/acpi/* +p"
> >
> > and collect the entire dmesg log?
>
> Added to the bugzilla report.

Rafael, Andy, Any ideas why fwnode_device_is_available() would return
false for a built-in PCI device with a ACPI device entry? The only
thing I see in the log is it looks like the parent PCI bridge/bus
doesn't have ACPI device entry (based on "[    0.913389] pci_bus
0000:07: No ACPI support"). For DT, if the parent doesn't have a node,
then the child can't. Not sure on ACPI.

Rob

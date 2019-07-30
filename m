Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E227A2F5
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfG3IPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:15:54 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43075 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfG3IPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:15:53 -0400
Received: by mail-ot1-f67.google.com with SMTP id j11so8089565otp.10
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=MYVr9bLt51oj6nMDCXM5N/aPeMMseJtFz0L43lFA8lk=;
        b=B8wcEZxBCiFqrKbsIEXrsF6O3aNqF7Ig/NLOI2FIJCmeGQNWMJNFErbhkBCzkIfF50
         wtG9fj23s1xstu00jU1sjxiU3aH4kyDcRcg2n36s7Jfwuf38BCGiH/aG4mwq10imAq9k
         TQ9qteYXCF7TRuD8hAQEuMeKOK4UpCKZinvCzTPVReFnJ7htlGCtFD/UtUEJKHUjGM+w
         upRVrRdJe+2D2XRsRKA4JalqozKCEuj7WZgXX/BmnroGQyH7gl2+E7OGNOqXScmw4CSx
         HkDREoHyHJEZQtW3btHvw0PBPeiv5Ibq5Rpsm9+9aXzSBn0gCnXLjx8m3RC+vunZ/Jqs
         94Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MYVr9bLt51oj6nMDCXM5N/aPeMMseJtFz0L43lFA8lk=;
        b=eEvz70CKihzcQRO1iAvCUuwXQTCIeq3D4BRAGuID9+Y5YTlnE1XIg/ePwbHNvW68M9
         VKIyjyKmBlCrQTD2/3zVH7Ex+GKbTaOrRyhjxP/T93mMWxf8tBJi+MfiGuBQMb6aUhye
         ASOiM1jl+KzThJz4oEZbXjWtJx6ymmsK6YCOBfyuQoXpSYaWx8dtn/D1RJt8A9cys97X
         n2XzjTAX8H2UpIzAGV53zdWounP7/91FcRRl/aYtU5dr0RJkWac8doNsFC7Hjnez/crg
         +DwFZR/o32zVZytDn5oY5hhHRGDIYXdqxsMWi/bXBuMbeidzfuGXuNkc/fNZbacIyiPZ
         KUHA==
X-Gm-Message-State: APjAAAXn8RUrXDPEDE5tsmZufA5021Z1D8eqsJ/7tK1iatcYlYHumR5M
        AkewFI7k0WcbC1y6uDEK3nrxmAFlRfVWsaElvaN4pGWr
X-Google-Smtp-Source: APXvYqxHPwVfyetuWcfpvAvjV+DB9dgadQFNl3y5aksFkTHHX7iG7MkCac2ts6+IMJnYUTqUtD/KzMafyQ6npHReLDY=
X-Received: by 2002:a9d:66c8:: with SMTP id t8mr28862438otm.94.1564474553152;
 Tue, 30 Jul 2019 01:15:53 -0700 (PDT)
MIME-Version: 1.0
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Tue, 30 Jul 2019 18:15:27 +1000
Message-ID: <CAO42Z2yN=FfueKAjb0KjY8-CdiKuvkJDr2iJdJR4XdKM90HJRg@mail.gmail.com>
Subject: net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a global address
To:     suyj.fnst@cn.fujitsu.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm not subscribed to the Linux netdev mailing list, so I can't
directly reply to the patch email.

This patch is not the correct solution to this issue.

Per RFC 4291 "IP Version 6 Addressing Architecture", all IPv6
interfaces are required to have Link-Local addresses, so therefore
there should always be a link-local address available to use as the
source address for an ND NS.

"2.1. Addressing Model"

...

"All interfaces are required to have at least one Link-Local unicast
   address (see Section 2.8 for additional required addresses)."

I have submitted a more specific bug regarding no Link-Local
address/prefix on the Linux kernel loopback interface through RedHat
bugzilla as I use Fedora 30, however it doesn't seem to have been
looked at yet.

"Loopback network interface does not have a Link Local address,
contrary to RFC 4291"
https://bugzilla.redhat.com/show_bug.cgi?id=1706709


Thanks very much,
Mark.

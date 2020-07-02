Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7C2129AD
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGBQgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgGBQgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:36:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463C320720;
        Thu,  2 Jul 2020 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593707806;
        bh=1ydFiyyVngUAcsAU9csrnJizTY4RtX1aoV1iBzBWUlI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSOdujByBkyI0xINU2tkk0vhYTIWtDh73W4gCqhyvEaWlGwnx+IWwIaE24ysdf1Fj
         9q1Qz83OusuUWT8nFFKHu4ErPQ+0Ikb7tT7v86bvJ+PvQY1tHAAOtOh1PdxhsiaXzk
         wF2H/sV/ZVyDVLypv6l9e5SKv/CIGCaoCth0ZtiI=
Date:   Thu, 2 Jul 2020 09:36:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Shahed Shaikh <shshaikh@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v1 2/2] qlcninc: use generic power management
Message-ID: <20200702093645.13e0018a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702063632.289959-3-vaibhavgupta40@gmail.com>
References: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
        <20200702063632.289959-3-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jul 2020 12:06:32 +0530 Vaibhav Gupta wrote:
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states. And they use PCI
> helper functions to do it.
>=20
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
>=20
> .suspend() calls __qlcnic_shutdown, which then calls qlcnic_82xx_shutdown;
> .resume()  calls __qlcnic_resume,   which then calls qlcnic_82xx_resume;
>=20
> Both ...82xx..() are define in
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c and are used only in
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c.
>=20
> Hence upgrade them and remove PCI function calls, like pci_save_state() a=
nd
> pci_enable_wake(), inside them
>=20
> Compile-tested only.
>=20
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c: In function =E2=80=98qlcnic=
_82xx_shutdown=E2=80=99:
drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c:1652:6: warning: unused vari=
able =E2=80=98retval=E2=80=99 [-Wunused-variable]
 1652 |  int retval;
      |      ^~~~~~

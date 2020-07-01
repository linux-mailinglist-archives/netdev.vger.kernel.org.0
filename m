Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB638210FE3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbgGAP6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbgGAP6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:58:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B614207BB;
        Wed,  1 Jul 2020 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593619088;
        bh=V1iDW3HLHhSqBPcQehF0Rgg3mQVIlF7VSD1AxxlZohs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zP1k9VygO6HMuMhSsK3Ri5ecwyhKTBVem6tv7+iZlkO2LfWUPUV8kB5w+xwQCC/yb
         NPWSYrq7lNKdPGH1kSf357yagD/OZvsRD5rkLejuyYhXie53xsFQIUIwXq5sqVL24C
         QWNqJuqt4nKNy53k2fBP6LoHQEIv1WZqAY2xP7+A=
Date:   Wed, 1 Jul 2020 08:58:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v1 04/11] ena_netdev: use generic power management
Message-ID: <20200701085805.4dac84fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200701125938.639447-5-vaibhavgupta40@gmail.com>
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
        <20200701125938.639447-5-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jul 2020 18:29:31 +0530 Vaibhav Gupta wrote:
> With legacy PM, drivers themselves were responsible for managing the
> device's power states and takes care of register states.
>=20
> After upgrading to the generic structure, PCI core will take care of
> required tasks and drivers should do only device-specific operations.
>=20
> Compile-tested only.
>=20
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

This one produces a warning on a W=3D1 build:

drivers/net/ethernet/amazon/ena/ena_netdev.c:4464:26: warning: =E2=80=98ena=
_pm_ops=E2=80=99 defined but not used [-Wunused-const-variable=3D]
  4464 | static SIMPLE_DEV_PM_OPS(ena_pm_ops, ena_suspend, ena_resume);

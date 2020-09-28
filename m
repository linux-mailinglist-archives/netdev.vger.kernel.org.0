Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9546B27B595
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgI1TpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgI1TpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 15:45:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D60972076A;
        Mon, 28 Sep 2020 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601322306;
        bh=MswvOek1LM+HkGpz4nTDDYzvgfCkDvIwe1J+Nrq/Mq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TGcxC8SY6nQsGC+d1XCaaW+LqGCw1qF/RCtbJVib9rPc/HR2YL+9FIc0rHf6EP5px
         sOgtobaGA5VBIZmIiYsRLr+bjO7jioi0xcbEXDcinIweVUe7SCkjIAFCttYwwC2ec9
         1/FQA4AzdDgrWZZpKC6F4zpz7VcX1ZsUcjNp5iZ0=
Date:   Mon, 28 Sep 2020 12:45:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, alainm@chromium.org, mcchou@chromium.org,
        mmandlik@chromium.orgi, "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 4/4] Bluetooth: Add toggle to switch off interleave
 scan
Message-ID: <20200928124504.617d92da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200928154107.v6.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
References: <20200928154107.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
        <20200928154107.v6.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 15:41:21 +0800 Howard Chung wrote:
> This patch add a configurable parameter to switch off the interleave
> scan feature.
>=20
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>

This seems to cause new warnings on W=3D1 C=3D1 builds:

In file included from ../net/bluetooth/mgmt_config.c:7:
net/bluetooth/mgmt_config.c: In function =E2=80=98set_def_system_config=E2=
=80=99:
include/net/bluetooth/bluetooth.h:186:10: warning: format =E2=80=98%zu=E2=
=80=99 expects argument of type =E2=80=98size_t=E2=80=99, but argument 4 ha=
s type =E2=80=98int=E2=80=99 [-Wformat=3D]
  186 |  BT_WARN("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
      |          ^~~~~~
include/net/bluetooth/bluetooth.h:174:35: note: in definition of macro =E2=
=80=98BT_WARN=E2=80=99
  174 | #define BT_WARN(fmt, ...) bt_warn(fmt "\n", ##__VA_ARGS__)
      |                                   ^~~
net/bluetooth/mgmt_config.c:165:4: note: in expansion of macro =E2=80=98bt_=
dev_warn=E2=80=99
  165 |    bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
      |    ^~~~~~~~~~~
net/bluetooth/mgmt_config.c:79:17: warning: incorrect type in initializer (=
different base types)
net/bluetooth/mgmt_config.c:79:17:    expected restricted __le16 [usertype]=
 type
net/bluetooth/mgmt_config.c:79:17:    got int
net/bluetooth/mgmt_config.c:79:17: warning: incorrect type in initializer (=
different base types)
net/bluetooth/mgmt_config.c:79:17:    expected restricted __le16 [usertype]=
 value_le16
net/bluetooth/mgmt_config.c:79:17:    got unsigned char [usertype]=20

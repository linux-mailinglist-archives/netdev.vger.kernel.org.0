Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FAF3EEDF3
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhHQOBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhHQOBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 10:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49F606024A;
        Tue, 17 Aug 2021 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629208842;
        bh=SSez2bpFzogjGNlK+XRrDZ6LOnCV2FB8tx5rYP6rXp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PvdRrIuAIVdEkz7ixm1RihHD80I4ttk6kJ4TeMdjOO1dZYKB2hDwXS8nhsvyPq2Ry
         lajD1AeTEiFX06ilClEULKqDZ9fkHDhmav27wtAG/HnsddcwSYbBJoK545UVzMcsV9
         N0e8qe6oLwnSw1RLdmi7dANTI1nJAUJ4RubHRaQ1Rf/fwpBKi2MPKoNSfkG5U8kq7x
         fLJ6XL2+13r9LAyfxk4W55417yH8ypUu7BWoKgM2Jmel2xWTFzrxyrQMXXz+Yaw+FF
         8yFBXdA1T1Dtla6qg//8fnBEXbNOs+YY6gmK7BG7CNq0qOojgp4UQRrs+PS0sipSWQ
         u4AuOXgcdVCJQ==
Date:   Tue, 17 Aug 2021 07:00:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/2] net: Fix offloading indirect devices
 dependency on qdisc order creation
Message-ID: <20210817070041.1a2dd2b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817132217.100710-3-elic@nvidia.com>
References: <20210817132217.100710-1-elic@nvidia.com>
        <20210817132217.100710-3-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 16:22:17 +0300 Eli Cohen wrote:
> Currently, when creating an ingress qdisc on an indirect device before
> the driver registered for callbacks, the driver will not have a chance
> to register its filter configuration callbacks.
>=20
> To fix that, modify the code such that it keeps track of all the ingress
> qdiscs that call flow_indr_dev_setup_offload(). When a driver calls
> flow_indr_dev_register(),  go through the list of tracked ingress qdiscs
> and call the driver callback entry point so as to give it a chance to
> register its callback.
>=20
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>

net/core/flow_offload.c: In function =E2=80=98existing_qdiscs_register=E2=
=80=99:
net/core/flow_offload.c:365:20: warning: variable =E2=80=98block=E2=80=99 s=
et but not used [-Wunused-but-set-variable]
  365 |  struct tcf_block *block;
      |                    ^~~~~

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A878D513E
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfJLRFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 13:05:51 -0400
Received: from mout.web.de ([212.227.15.3]:42905 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbfJLRDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 13:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570899794;
        bh=bKu9xBv+qGl3khzhaq/Ts8mRANG4hVVTTgO3XdiSrJ8=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=fTEi706HNanK1tphqEfINp64DWLl5ItNjoXukH2IDwM3wLFdF+ER/GjTtJ6MMEPbl
         78dgBz7lmaPZ0uCxNL7bHYb7MR9MSBPEUtw3HnWBLkASuo1STQeIXU/ZoRyIuKM3+8
         olqVE0BJtLymiXsAxZ/pfnLgG4r6qK86eN/Kcd/I=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.155.250]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0ME0v1-1iI0p31sUh-00HO7t; Sat, 12
 Oct 2019 19:03:14 +0200
To:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Yang Wei <yang.wei9@zte.com.cn>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: net: tulip: de2104x: Checking a kmemdup() call in
 de21041_get_srom_info()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
Message-ID: <eb1f904a-a2e4-fe9b-c50e-b8087d7e57c4@web.de>
Date:   Sat, 12 Oct 2019 19:03:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Qq6FxykufyXcsAvMTgIVyf0wdsfAHXA/t/zL+yoRsFUacLvITvX
 qu/2WDQoOEYQQag7m68NdoL2bQ5geqQjpBhazionC03XDQnUTzIZNMA4HdD+nG0KUwYqSkl
 1f74lxFLs4b6QzwlkirBhzuSeEGzzM2N0CBzGbAVk/gSwKKn3ns2EcjKKRf1XRbOO6Lxe80
 dFEcypbQV1LEsKqausOkA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PnpVUt1TrGU=:rZkyNgDRoGFDxP0e4Ltukk
 iPUPR3dQG7RDCE4UMKzaEELagRdltYgzc1GY6q7gAKMQaFzwSh+FJB45iLFVwc39QJqzb+KQg
 SV+6jtmYQg40leSzsZ+5dP3MkLwt9dxPapEAjNwdjexx6VeGiVvxKCfIYu1rXHLJ0hMVY4ru1
 bKMRghAv02jkXTMD02iXjFcUs8qxySRQFfCV+FtFIak0eB90FVXJDvnlXds46AOl/nnKSt+tL
 c86oM11p5Dn90lGM35v4qyCRoOnaJSIvUVDyOd6Qy2ZMeshW5uTD2rfHZw5GyIk4H+xk61oG/
 VSCj9X5MipTF+OexosVnZtbSIFUQ025ujaqhm/+hu0ngShAmLHls2xyAuIqy8XAMyNAW7jCuo
 tRTq7VjOf+6EXzmOiayQryUyqvfpaZA2h1Evt1ktMkvjB3y9y1s/WpX9qapZHRwxYZt8fYkDX
 XU6yJ9cIx5xp4fF1DY8Ntf3Kv6EWsBbic9PVPyJVOfS2LFO1Hja32FTUN7Kg4jsStItTmoVeY
 SYNfzJOOErU6q2ReOWpwlNhBFGOJxCoYshZOYE2MMFEiAbuXxUASYEMrT8HMmnYwiLyhxe2uD
 Kn7c75xaLdXCszVfXewYMQ7MPhgRGEVXLjC9EiKd4j9WXFiBdLuO/O+4UX+5gBIQ3aI2DijR7
 NmvwobSTS+pcfYpJvNHRmNwkYxRzap492jEZrgdIv9UzgkCtNCrDUdmgFBQzlNjOB/Qw0rbeB
 rnLmTT1Wl5uZh/haJ0QvWdmSuaKYjtrYDe4DxIThaMUyY4i9xZkIIQP5zWGqfM6yCUaWB66kr
 8vU6wYqS2QCppUZDI0dlFwextEUpS7vrVtqlkAehw6lTzMcCPtlS6nefrUK8e+6JHFPDZa5u+
 yn4DeZStQpTG9QTju5+UCwfv7NetsxxO1UfbAvWMymfyLQwPwU3P/IcOPhAvGHtWKE5rdeY0T
 Z37pixw67FNUEJtu+BRp2lhqVfkVWXbWi8PG/K5sgE2lV4jop3EaTh1x4aAYOrg862WSdo6lg
 QkpCTmYWceIJNRE+9lLULsqHYwHoh5zlNJXb6so2QBok31nRPYPwbvqAUC7A0jpsNTo0sVYY5
 4bS1Q40g5L1C33cKYhHZCMhuzRhBlqzZ3XW8qJECFnFENmoPZ08WF1QvJFWhATHR0ZwLJuVch
 rd3o7WTdrmvYPMvYswprxY4joRmK5A8n35DuK5hIWNH4DuZwiGbw/ckYueJTg7VjG0n09XHD4
 +7tEWIEUhIKpFc2hmaAsLUN6OYqp0QIjC2lpZEe8uaOQwE85Qp2nvzSBG9KI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I tried another script for the semantic patch language out.
This source code analysis approach points out that the implementation
of the function =E2=80=9Cde21041_get_srom_info=E2=80=9D contains still an =
unchecked call
of the function =E2=80=9Ckmemdup=E2=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/net/ethernet/dec/tulip/de2104x.c?id=3D1c0cc5f1ae5ee5a6913704c0d75a6e=
99604ee30a#n1940
https://elixir.bootlin.com/linux/v5.4-rc2/source/drivers/net/ethernet/dec/=
tulip/de2104x.c#L1940

How do you think about to improve it?

Regards,
Markus

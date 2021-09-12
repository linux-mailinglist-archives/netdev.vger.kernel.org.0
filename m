Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD57407D7B
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhILNMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 09:12:52 -0400
Received: from mout.gmx.net ([212.227.17.22]:35423 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235203AbhILNMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 09:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631452284;
        bh=A/5R/9lReRnqhX6VardHyEyyLao6a251fVotksIzRz4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=FHaHEneD/JHM91TlbiVBwG1FybHQieys3tZ581/oKQypH5ceh3JkG1LwdYEUL6OUw
         6zj1G4LfYdl7CYUgq8mQYxfThp3P/JSkZuEBxw3M8hcg0ZHdfJBeXyg1egHrYH6464
         boDX61NkPwYOm4kq+wa75mjkSLQzXO7r/gqNkrmw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx105 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MbRfl-1mvz7q2KgT-00burL; Sun, 12 Sep 2021 15:11:23 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Len Baker <len.baker@gmx.com>, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfp: Prefer struct_size over open coded arithmetic
Date:   Sun, 12 Sep 2021 15:10:57 +0200
Message-Id: <20210912131057.2285-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xQAYY+Wh3B5HSBfIXdY8+Kf81F3qLDBWMoLrHBOCyshSYw3i/RW
 e+K8wrfSv20BllJvs53spJa4W2SC/Mv0nkaEjszAWE1b1C0stbJ5yuK1Q0cUgoXk5rgjDaY
 aOWPEMQIO+qHqaiWI3sIAyDp+dapwOfvBkjnxxdNny1dTg/en3+bMDOcnLlL26N738cCTal
 1d+67ZAZatc2kGXROTVOA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:u7CVJm1RPxk=:1VBoFGX8IlYt2jE+xxUaIL
 ff2UltfrQLU1mqqJb7jFf35QnbmQO57kMXAJy8gR22BDvBp/yUkhfmJ+8iNAeX194eyzWW2QD
 p8BHFY6AyLeKX425tsTzCJf99HV2pRGqpjzChBAM8aWbZ80YvAPdhkXLyqYjvin+TVNa0RjDE
 ux17lqoxq5O4wxeaXD25fqeNG8JLwCvZQKYyzx4tTOnyZy28q7hf0aZ/sUVL4xfRMiadE6RfK
 kRCqtMq78mOUWRcKl2fNVIPzEkLq1WPxBu9bfivYQThkGpmckjOgIkGt2JiYb1WDqgOca394K
 AL5rKMh+ynSQfq7+bd0lOWIu+TllD2tmDn9Jaz8ndQgyVbjVp1Ciphc9piPDWSqfpNDFB1+RM
 gHgfjNiNgbdd6qspL/UCMrn4t8NZtWUp/RvAk9BYgG0KLNgRuJB7jZkOZCxLFH1zANV+XnQPf
 M8yKSjH3ErFBF4peSaueVxXwil3/IxBLrBdzI+KZ81rxE5pQZukSOlAbWa6MTaOTokKXWyJ10
 sItVP+HqXOXOYXIdP8A5l9srpgHUiGu6Dsi0f3fkv62PSvEyAlcTbOZqO3ZTssut97rUIpspu
 VG3IAxsuX2XfoeT82++CSkWAHIx6cbXK9fhz0VeQj9Q9kSSECoQZgwikkXiJ7T0bk7swReqyi
 AEbFRePf9c1/tN3oc5SC58riSmyIfEAQ1120E/muKiOAGTQ1ZNvtnixQAaO9P1vav/GLkU8/S
 PfWdhJDKK+Z1tv10ZFRT56wwpoc74oB3P4aJk+UKp+Few2Yfivok8fs3ChMiNNWvjE9IDR1Yz
 Z+R6IuayR0RKmkJAdahcBWc72e/V/E2jGj6OpLEqqPquvPeWM6t6JTwdBfv2Pbuju7KVamqP8
 Btj0H2phmuaKntjKaww8TWdu6FsKttQCJCHDbbj4iYc6FRPtSEKOmarRtzB6DAIUBibdYB/NN
 +qQEjOPlqQdo4x/gfyLucU/3vTsoLi8yVPmf9s/bTJ64SoFzT4GG+HsOBd/u48GdPQfyfs3Tk
 N57YioDiW8zSvlaq7bLt5TpT3XxmwicI7pMS5pDFVi2NunBbW0AUSs9k2ve6mpwitKIYgCv8Y
 Rldt21TSBEQMd8=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kzalloc() function.

[1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-cod=
ed-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/n=
et/ethernet/netronome/nfp/nfp_net_repr.c
index 3b8e675087de..369f6ae700c7 100644
=2D-- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -499,8 +499,7 @@ struct nfp_reprs *nfp_reprs_alloc(unsigned int num_rep=
rs)
 {
 	struct nfp_reprs *reprs;

-	reprs =3D kzalloc(sizeof(*reprs) +
-			num_reprs * sizeof(struct net_device *), GFP_KERNEL);
+	reprs =3D kzalloc(struct_size(reprs, reprs, num_reprs), GFP_KERNEL);
 	if (!reprs)
 		return NULL;
 	reprs->num_reprs =3D num_reprs;
=2D-
2.25.1


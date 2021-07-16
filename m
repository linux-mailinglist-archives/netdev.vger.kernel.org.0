Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F033CBAC8
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGPRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:00:02 -0400
Received: from smtp-33.italiaonline.it ([213.209.10.33]:54933 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229751AbhGPQ7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 12:59:55 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it ([79.54.92.92])
        by smtp-33.iol.local with ESMTPA
        id 4R8tmKNNmS6GM4R8xmO7ae; Fri, 16 Jul 2021 18:56:57 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1626454617; bh=ybTEgBqSGSk7CgeQhAXjaoIWf5L8GRxV3Eiz04dFePA=;
        h=From;
        b=L1hdgjdkCzi4AZ4tqpEYU/SIrwWUqcFGNcmrGfyG3i9PdNdRg5yfS107Y9DEV9o2r
         x0PAUxVfKaBAymp74IWa/Odu6YU0scMVdnEIC0TUTJa/X7ehXERTnkJrzMxiz1WbWS
         3qI+sSW6w++i1jMPPdx/Gi0H1U9E+Q8cHqAxF9vl4SGG3tVLCeu4l1GFe9TVUDRu+c
         cA2Avkf3yrfF72+EgFDoE/iYMG4TKXLlcRZogu224vhiy/Wf2CcPLi92WP4KWMHvRT
         lOmst9q5j5yiu+KXF3JGNT1dHWadKIeEtVQyEtJGAM4e3I4/4ezXTVOFrvby/1IOiy
         kzaTXz23rY9tQ==
X-CNFS-Analysis: v=2.4 cv=AcF0o1bG c=1 sm=1 tr=0 ts=60f1ba59 cx=a_exe
 a=eKwsI+FXzXP/Nc4oRbpalQ==:117 a=eKwsI+FXzXP/Nc4oRbpalQ==:17
 a=X8-5zgEFGoXRYfRO6I8A:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] can: c_can: cache frames to operate as a true FIFO
Date:   Fri, 16 Jul 2021 18:56:19 +0200
Message-Id: <20210716165623.19677-1-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfKoMV/+nZGBCPIXBiH3gvl6PDXsLIr3ajj3MP7Mrxti8SWfQlE/FXiPXzaPo3/kHl2XKpq4Gy1ZfkK7F1OP7Wfm9TETNnU1dtw+U56kgbTbcL3g2u1YN
 ItnFnJG5lXNPyTBo5oQjLpt8tnjq6mhufAss2yoNaPmKrVAtfctBfjD9K8bcHaPuIbTno4uZ7yEMG5qM11K8HnS2uZ9Zznj24eiqdFGnrjossx9TLZHD8rXn
 WqwBU0qj0Qgc/pYUEGXcwKC+7X4a7IFeLWFEDTKYsrRfxpu0J2ZXP2OLHUe0uoPzdjaEoEcLYVaK9++zzZ7uITaasq3TLg0Dx9A/+wKGPglXg0wgSTBx93Ip
 TbJwP3CLOglfqqRKZX4SS1F9qv1dgXWRegMU9ushtN8ak25ZxowLyDyL1lw+1IZ7JTxFiKGNwVLltzThps8M4kcbRo/CE709AN47nfGG/uGck6aSvMs8YL5z
 /iSdnjJBGmZfRSwzrpPrjuC6gFzuONJZ/GqaXDpR4bsh5Sq/vFh2cJrGFnV4d3AMISoIQPrXf9SyUEysN7vfuicBdQfxy9qEu189yzoHcFe7Hw5jAnCSTNBn
 2vWuR3PONPUzXxponzlS/cbfE/qLrLoi1GqjXsYXAYmsEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Performance tests of the c_can driver led to the patch that gives the
series its name. I also added two patches not really related to the topic
of the series.


Dario Binacchi (4):
  can: c_can: remove struct c_can_priv::priv field
  can: c_can: exit c_can_do_tx() early if no frames have been sent
  can: c_can: support tx ring algorithm
  can: c_can: cache frames to operate as a true FIFO

 drivers/net/can/c_can/c_can.h          |  26 ++++++-
 drivers/net/can/c_can/c_can_main.c     | 100 +++++++++++++++++++------
 drivers/net/can/c_can/c_can_platform.c |   1 -
 3 files changed, 101 insertions(+), 26 deletions(-)

-- 
2.17.1


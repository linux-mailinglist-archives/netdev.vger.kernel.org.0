Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36718557C78
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiFWNHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiFWNHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:07:40 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A07C41302;
        Thu, 23 Jun 2022 06:07:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id D4F579C020F;
        Thu, 23 Jun 2022 09:07:34 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id g944G4ODPUHY; Thu, 23 Jun 2022 09:07:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 724629C022D;
        Thu, 23 Jun 2022 09:07:34 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 724629C022D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655989654; bh=gpgbbHnx61/VSrtvu1HJxF7I/adoakDNkdIUpMMgnVY=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=CdFqrTfFNpAog6EFdAHd+t2eD8+DdiEC0MnuTiZ+HD2S0NfOQ5JAX1AeNNSYHV8tN
         PquGQbZjFqhfWLaYwqUi+YdaD+u0v8HjhmgjObdTwidYw1KMFeI0U8NIfODWhoh8OT
         eWbBM8y8PDIYopc4vg1nq7PRsCH/v0+uAziknbc3UnXbX75E+s399GGN/tXzQSklxm
         Wu/6bezaJ4yWco/c6rczHUWK6JWusInB9gfDb5y1LSib7R1Th2+XCG+Ck58cVcbJOG
         PYbxJkDLakhZB4s6hLe/jSyONfwRncqCDMvdQIRBHN3VaUWTDSGCoExOY8podhRZPt
         kzXQFC7CVa/MA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yqgNZP8HJ4-R; Thu, 23 Jun 2022 09:07:34 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 7502A9C020F;
        Thu, 23 Jun 2022 09:07:33 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Subject: [PATCH v2 0/2] net: dp83822: fix interrupt floods
Date:   Thu, 23 Jun 2022 15:06:49 +0200
Message-Id: <20220623130651.1805615-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YqzAKguRaxr74oXh@lunn.ch>
References: <YqzAKguRaxr74oXh@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The false carrier and RX error counters, once half full, produce interrup=
t
floods. Since we do not use these counters, these interrupts should be di=
sabled.

In-Reply-To: YqzAKguRaxr74oXh@lunn.ch
Fixes: 87461f7a58ab694e638ac52afa543b427751a9d0



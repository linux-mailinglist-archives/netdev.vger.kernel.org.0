Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC2557CB1
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiFWNP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiFWNPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:15:07 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7813B577;
        Thu, 23 Jun 2022 06:15:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 647DA9C022D;
        Thu, 23 Jun 2022 09:15:04 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nlpuuJNTcEw4; Thu, 23 Jun 2022 09:15:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EB04C9C024D;
        Thu, 23 Jun 2022 09:15:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com EB04C9C024D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655990104; bh=gpgbbHnx61/VSrtvu1HJxF7I/adoakDNkdIUpMMgnVY=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=tKW11FkvEMyfh1ANpcjzkN5caT1S9aDWbZARwLYYxJaXM1uqlVdAJx0tHRViYMGyV
         0XVly0ODQC3A8IhVb+cehLkfD8QQoeiVHU4vddovBav231eKzsmqxushry4eYv4C/n
         HMxSzl3yAydGCAMc317RVEyYBINXdXNzKZF5Sjn26KggvuTAKImTZNokXgz2+PUnSn
         /7sqG4g9n3tlmN74PM4Wl4nAj79JApv1Fcfnq132+IOIigYxtgZtXUJRefPyhK1+nw
         4/j3wWrojL8KD55s8XqERx2pFVjSFQoqISIA63mW3F1gbsQ6rtDsLTCfNm66M4cNQk
         gGxd/NapyTzhA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X5gmuRiM5Lq1; Thu, 23 Jun 2022 09:15:03 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 003689C022D;
        Thu, 23 Jun 2022 09:15:02 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Subject: [PATCH v2 0/2] net: dp83822: fix interrupt floods
Date:   Thu, 23 Jun 2022 15:14:51 +0200
Message-Id: <20220623131453.1853406-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
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



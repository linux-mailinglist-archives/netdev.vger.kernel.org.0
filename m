Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233894DDFF0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 18:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbiCRRaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 13:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiCRR35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 13:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D002DF3CA
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 10:28:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A17BCB824D0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F830C340E8;
        Fri, 18 Mar 2022 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647624502;
        bh=iw0Ynd6lczs3AvpIwsc+U9eGoDxi/vOleHg49rg9JNg=;
        h=Date:From:To:Cc:Subject:From;
        b=nA6pdD57q9ger+086mEyGL/P0gTAvdnHpKysQjNyOUGWNi7UtRzx2ahaL7VYUhR+P
         p9FEisSyMrxTD20upIDp+g2XgiOMEzmdzGpkrkPiINZjMa81x9SePOHsSgF4xZXGn9
         0wOrk8vY4rF8RBXw/0Z0wRJxrCjJsjBTUnwcD0xWr4l7riyNKtnUwv2uQiVMvGcRjc
         viwMErL93XlOZDdI2pAnX5kX9OvTewaLkEtzlKTYl/ZQbK+LI6bpsyiJLyv635X31g
         Nf4hSwwS176JwDErfpSCDS/1n17cvPOCDus5EN4Vf17pAUkurdVYn63d60KyTlhyYo
         q6wrmas7gwxHg==
Date:   Fri, 18 Mar 2022 18:28:17 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
Message-ID: <20220318182817.5ade8ecd@dellmb>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tobias,

mv88e6xxx fails to probe in net-next on Turris Omnia, bisect leads to
commit
  49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")

Trace:
  mv88e6xxx_setup
    mv88e6xxx_setup_port
      mv88e6xxx_port_vlan_join(MV88E6XXX_VID_STANDALONE) OK
      mv88e6xxx_port_vlan_join(MV88E6XXX_VID_BRIDGED) -EOPNOTSUPP

Marek

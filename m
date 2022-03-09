Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377884D38D3
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiCISaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCISaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70E7DB4A5
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F16EB8232A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 18:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C744C340EC;
        Wed,  9 Mar 2022 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646850557;
        bh=lONg2gTmarqc/dYTwWZAFatB+pQboUBjL6sNvkgmu18=;
        h=From:To:Cc:Subject:Date:From;
        b=qOJIwo4H1zdeE3Q7OGV6llCRWdbR/vrpII8T9/3BTk2261VeL7o0/SWIyRfn55ruQ
         7kk6MMUay8Nb89M2o7BJ3zQPRL/qBEIi05CCrfgB7EDpLvz9yb3VDEpEXmVDDV/+Lx
         13u7aviYo2Rgqd+0nkkWT5fT/OUnev970xEeP5NzmCM+UUT+nv1aI50LSnkKa+Yq3+
         ujyqxfjLDXUT44X+G5c9QlqCrZQA+Hqcb2gHYdTF3NXhdjRIC+L91nNPWOK1wI9WRe
         RiNcX5zzXEsK+loDDkJzPbm/R4O+cNYH5oJ9f/WfPok9GaVAf/OzGJoxglJI+Ew0dk
         fDpoO7hF/Tf0Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] net: control the length of the altname list
Date:   Wed,  9 Mar 2022 10:29:12 -0800
Message-Id: <20220309182914.423834-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count the memory used for altnames and don't let user
overflow the property nlattr. This was reported by George:
https://lore.kernel.org/all/3e564baf-a1dd-122e-2882-ff143f7eb578@gmail.com/

Targeting net-next because I think we generally don't consider
tightening "root controlled" memory accounting to be a fix.
There's also some risk of breakage.

Jakub Kicinski (2):
  net: account alternate interface name memory
  net: limit altnames to 64k total

 net/core/rtnetlink.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184B76885BA
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjBBRxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBBRxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:53:35 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F676603F;
        Thu,  2 Feb 2023 09:53:32 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 41BDA5C00BF;
        Thu,  2 Feb 2023 12:53:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 02 Feb 2023 12:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1675360411; x=1675446811; bh=oSkfZNQQwoV+/rKhBg7ZigxrN
        283hdkWNlr1BY9UCL8=; b=SrVRHFysZIvbAlXGNKYX+cXJQY7ItsDGtFzOxvqs7
        c9C7/S4xjU7qmFgWVg8UrlZDJiDSjbnF+rxSmlm08wMioESSDTymNqGj7C7we2xt
        xbpQJMo6MteGIIHWIfvQOR8STHsbUHnIb5UKTX+oxdUpciEgwAFBcVHU89bcjpO8
        PGYQVAOGAOrbYI78k1JppBBKA2/0+8HHH50oRwtUZn7QruaRPLjNRVPWuVZZINvu
        6fD2I/f4++2dh3zKNlpb4ND/XRm5+pOdTpTKOM9G8N4snW5S87MZdxunhtlVxlrC
        hxTrl85w9s/umdrO1wbXdhpj0RO9Y/E/mAa940kO9Napw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1675360411; x=1675446811; bh=oSkfZNQQwoV+/rKhBg7ZigxrN283hdkWNlr
        1BY9UCL8=; b=SuXuiNkFui0iymVtXyrqn3D4WyDP2e0/ChnwtidwhFDCI9xq9c+
        Qc7EqEysj9yJIKfmrwjXDhCFOpVodulzdl1EM2kIyply8AgVq+3ICc/TwLBXw+Yi
        7OJhDkl5TbTEjFqXNM2JjrF3kFUZC3k+gUTWcBm8bdMdk/FpagEwMilzWtko37Ib
        5mywno31WSr5zXQwDak3NzLchjFI9hsfgpvRfSQogtnOaPBN1zJEVqeaG/UyuOB8
        CA3l7/uEQVsRa/64XTjtRemtig1Spwv8axK9l6mJkI9EP8Xh8sDi+Kmr7LAOvci2
        pEPnh1yqmimZosKxsUK10V5ZMBU0YvwFpUQ==
X-ME-Sender: <xms:mvjbY1sq76KetRtHUvq0cBm4S9ZboGYNH1TnD0CVz40Gai2KvSmlWw>
    <xme:mvjbY-fmvH2JJty0_tUew5tatgyQPWZHBrSy21Q2Nk_-ZgBbq8UBCPQYqPfbzKw7W
    vtTPenDUpmT0vyy74o>
X-ME-Received: <xmr:mvjbY4wyNmf2TAnvKO7NlpingUUogctuYvHGRC6De5p8nkw8PfTLhY9vJ0KUJInku_H6eQilWB2A9JxU6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecumhhishhsihhnghcuvffquchfihgvlhguucdlfe
    dtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefrvght
    vghrucffvghlvghvohhrhigrshcuoehpvghtvghrsehpjhgurdguvghvqeenucggtffrrg
    htthgvrhhnpeetleelgfduleefieekjedvtdeiieffkeehkeelkeetheevffeijeffieeg
    veekheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    epudenucfrrghrrghmpehmrghilhhfrhhomhepphgvthgvrhesphhjugdruggvvh
X-ME-Proxy: <xmx:mvjbY8O5cOlHJptwVdwTtrIvZL1S94wlb2Lze17GnOH1lmBqGqZsRA>
    <xmx:mvjbY18O7EHLyL4rLXGyMqjPV0Axe5BDBNNR6pQxqsXu_oXb4qe_wQ>
    <xmx:mvjbY8UU5khzcDJJ9y4_MbdoEyWNe1926KkPeGEBPp4Vd_nfkDOc1A>
    <xmx:m_jbY-P42ZlmE_3085_Aarxb6cFSI6BDoKW_-6I5HrC3sJ7CYXM2kA>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 12:53:29 -0500 (EST)
From:   Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joel@jms.id.au,
        gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH 0/1] net/ncsi: Fix netlink major/minor version numbers
Date:   Thu,  2 Feb 2023 09:53:26 -0800
Message-Id: <20230202175327.23429-1-peter@pjd.dev>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background:

This fixes some nonsensical behavior with the NCSI version numbers that has
existed since the NCSI driver was introduced. Details in the commit message.

Functionally, this is only visible through the netlink interface, so I've
titled this commit as "fixing netlink".

But actually, the real reason I care about this is to provide a proper mechanism
for using the network card's NCSI version in the driver state machine.

With the major and minor versions parsed correctly here, the state machine can
decide to send NCSI 1.1 or 1.2 commands when the card supports it.

I submitted this patch previously[1] with two other changes, but that series
was ignored (wrong time to submit, invalid subject prefix, and the last patch
is controversial until hardware propagates).

I decided to just resubmit this first patch, since I think it's valuable on its
own. I'll follow up with the other ones later.

[1] https://lore.kernel.org/lkml/20221221052246.519674-1-peter@pjd.dev/

Implementation notes:

I found that "include/linux/bcd.h" doesn't actually do what we would want, so I
added a local static function. Perhaps I actually should have added that to
"include/linux/bcd.h" so other people can use it in the future? Let me know
what you guys think.

Thanks,
Peter

Peter Delevoryas (1):
  net/ncsi: Fix netlink major/minor version numbers

 net/ncsi/internal.h     |  7 +++++--
 net/ncsi/ncsi-netlink.c |  4 ++--
 net/ncsi/ncsi-pkt.h     |  7 +++++--
 net/ncsi/ncsi-rsp.c     | 26 ++++++++++++++++++++++++--
 4 files changed, 36 insertions(+), 8 deletions(-)

-- 
2.30.2


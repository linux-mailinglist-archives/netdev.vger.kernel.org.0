Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED59E4E7557
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359393AbiCYOsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359390AbiCYOsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:48:35 -0400
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB2DFD95DF
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:47:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id CFDCE4400A4
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 22:46:59 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648219619; bh=6HPXgfPP8+BOya1F5AkjcNxtjc44ThKa1XwWzyF2Nro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dxfctSC8au/oUaM1rvmMG2AsvB+7G2K5obNmzilVRgZbsYn00zCDbX9v3feulM1GQ
         G6xMVcuH28Y25nbTBCFNRfWPNb1nOIBM3c9M+cSQXjcwv/4ueESL5xKr2mqzlC6o8u
         Sw418z9tIWnxJTIfEfaaEyVdO2BMO82nzMfO7xW4=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -1598067644
          for <netdev@vger.kernel.org>;
          Fri, 25 Mar 2022 22:46:59 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648219619; bh=6HPXgfPP8+BOya1F5AkjcNxtjc44ThKa1XwWzyF2Nro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dxfctSC8au/oUaM1rvmMG2AsvB+7G2K5obNmzilVRgZbsYn00zCDbX9v3feulM1GQ
         G6xMVcuH28Y25nbTBCFNRfWPNb1nOIBM3c9M+cSQXjcwv/4ueESL5xKr2mqzlC6o8u
         Sw418z9tIWnxJTIfEfaaEyVdO2BMO82nzMfO7xW4=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id F135815414FE;
        Fri, 25 Mar 2022 22:46:54 +0800 (CST)
Date:   Fri, 25 Mar 2022 22:46:54 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220325224654.00007cba@tom.com>
In-Reply-To: <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hope the 3 combinations can support the claims in the commit message.

Since for the later 2 combinations, due to packet dropping and
timeout-retransmission, the bandwidth of each TX node could suddenly
drop a few hundred MB/S. 
And on the RX node, the total bandwidth can not reach to the full link
bandwidth (which is about 6 GB/S).
.
In contrast, for the first combination, the bandwidth of each TX node
is stable at ~ 2GB/S.
And on the RX node, the total bandwidth reached to the full link bandwidth.
And no packet dropping occurs on the 2 switches.
This is even competitive to the performance of RDMA.

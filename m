Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725A65068A8
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348727AbiDSK0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiDSK0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:26:14 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF968237FE;
        Tue, 19 Apr 2022 03:23:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VAUn-3l_1650363806;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VAUn-3l_1650363806)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Apr 2022 18:23:27 +0800
Date:   Tue, 19 Apr 2022 18:23:26 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     yacanliu@163.com
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuyacan <liuyacan@corp.netease.com>
Subject: Re: [PATCH] net/smc: sync err info when TCP connection is refused
Message-ID: <Yl6Nnvnrvqv3ofES@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220417123307.1094747-1-yacanliu@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220417123307.1094747-1-yacanliu@163.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 17, 2022 at 08:33:07PM +0800, yacanliu@163.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the current implementation, when TCP initiates a connection
> to an unavailable [ip,port], ECONNREFUSED will be stored in the
> TCP socket, but SMC will not. However, some apps (like curl) use
> getsockopt(,,SO_ERROR,,) to get the error information, which makes
> them miss the error message and behave strangely.
> 
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>

This fix works for me. I have tested it with curl for unavailable
address.

This patch missed net or net-next tag, I think net is preferred.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

Thank you,
Tony Lu

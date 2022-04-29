Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D931F51423D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 08:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354488AbiD2GVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 02:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354487AbiD2GVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 02:21:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C66DB9F0E
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 23:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEF1DB832C8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 06:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F071C385A7
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 06:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651213063;
        bh=ZpfDwdVnK+wEnFvfj3TMTOKh7W3n54KJh4PFkPTjnu0=;
        h=From:To:Subject:Date:From;
        b=uRPX50nzic0fP/4WsnjjCPA+ucapCvcYuDv2FTJwLxN8yB0NTg+WgjjSfrkAW9I18
         UebDtG38yMRW0LecxGO0ZELqdVmuctHdq7bfMAdnKmwYMTczdfbBzy6HAAJZ/fSZuU
         32XbZZb1CSDYxG6AnQgDbP1wJkSWdXUUIKzzPNKrPvez35gxqsaS0drAuQmndznDdL
         M0EUDnv+d2FMMAlYHBmSLlRf9ioIyekOAm4pXAi4mNxLf+gdb2VUNKx4KqGT6VDQwd
         sYbU3uFwlmR4Pu01jHZkGJNxKGWTix0iw/9pZXzCcelw1yqFGfC/DlTQqqIk0jlSB/
         NyF6Vym6OWEqQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     netdev@vger.kernel.org
Subject: __rtnl_newlink(): the frame size of 1104 bytes is larger than 1024 bytes
Date:   Fri, 29 Apr 2022 09:17:39 +0300
Message-ID: <8735hwfm64.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

For few days now I have seen this gcc 11.1 warning:

net/core/rtnetlink.c: In function '__rtnl_newlink':
net/core/rtnetlink.c:3557:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
 3557 | }
      | ^
cc1: all warnings being treated as errors

This morning I tested latest net-next and still seeing it:

f3412b3879b4 net: make sure net_rx_action() calls skb_defer_free_flush()

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

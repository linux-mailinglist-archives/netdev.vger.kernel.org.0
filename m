Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8B1B95B1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 06:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgD0ENT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 00:13:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38675 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgD0ENT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 00:13:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F8865C00A9;
        Mon, 27 Apr 2020 00:13:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 00:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=f9Ekx7PiVmdLUxchMtzJvbe3RKUbNWFL5TW47mNpceo=; b=nlSZ7Ivt
        sCfEHPvvDoOtEhgRpBdkzzsLE0pzxr5WUGqPf9a22px44p1NrULyNlTpTDQEG72G
        eHnTj2ryT4cPFe8h0J15O6Z3jHJ6qhDIGbEeoIGwJfcrhroiiec5fpMy6oSP5ff1
        6ievjlO87uXvOT31uu2CgVrt+VTOId0R2a9KGpgvtuRTasD3L6FBqyqZMTyi3FdE
        IXa2GIacTUmzOLO+KsCRV/XMFCLLtWTYy6WrNksoi4o68GzirymUHV296wnS1wBe
        moqfMVMKSbGit2wMhSbW4Lkz1hlhdSiRkspmEbUJNY5KUMSTsTCqHwYGC1kqf6De
        XPGpYLwtpMlWug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=f9Ekx7PiVmdLUxchMtzJvbe3RKUbN
        WFL5TW47mNpceo=; b=k6PVLkbTjD2z/rDBINYfqNEEaE5ur1JXnsW+6wMgM2eT0
        glntTTNGrLAxP7gosSfsbH7dJwGI4QFmM5mDT2mM4H1Y0SDW3r623XDlmgij/X9J
        FEurSWszfQbw2QTghMgFLKu8OLcI7AD0up+PubS0MP0HBTrwq8U9u5wIqVv+I16P
        sLrx9Kl3x2AXT6aXddsUUVJpabgXF/F+EbWuksRZmflYgCqP6CWeTC0OjuC4CXst
        NtD8O0+rnD/krnXY/NnWdfyRrCKnvsO7jmlZjgumf3Q64BJFghEySiuPy5siuRxn
        VXi4PyeX0iX3EybRTQhpcdzOaS0bP0aSderaXokdg==
X-ME-Sender: <xms:3VumXkoBx44-7OEVa9eh9LjecHMQOMbLIzeMl6BwD0Nb4iCPv6vgAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtjeenucfhrhhomheptfihlhgrnhcuffhm
    vghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecukfhppedutdekrdegle
    drudehkedrkeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:3VumXkXrqM9E1BalWj-w-_xZTFwdlQpklR0jN3BqyFAihp5L6wMfaQ>
    <xmx:3VumXohrSecClwHQsOtL2ThSj1RLWO_xReRFco7IZ0W_VoAtPFOE2g>
    <xmx:3VumXj8XQJLWlA7oGL6lyXTUjcCnRyvLNDQlK00wf1D0ddWK-Wz1gQ>
    <xmx:3lumXu2pAxg31W_zIDqzYN3h7Eeddbcmtbgjej-5IspfGNWQvCwXqQ>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21A9F3065E4F;
        Mon, 27 Apr 2020 00:13:17 -0400 (EDT)
Date:   Mon, 27 Apr 2020 00:13:17 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 0/3] staging: qlge: Fix compilation failures in qlge_dbg.c
 when QL_DEV_DUMP is set
Message-ID: <cover.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlge_dbg.c has a bunch of code that is conditionally compiled only
when the QL_DEV_DUMP macro is set in qlge.h (it is unset by default).

Several fields have been removed from the 'ql_adapter' and 'rx_ring'
structs in qlge.h so that qlge_dbg.c no longer compiles when
QL_DEV_DUMP is set.

This patchset updates qlge_dbg.c so that compiles successfully
when QL_DEV_DUMP is set.

Rylan Dmello (3):
  staging: qlge: Remove unnecessary parentheses around struct field
  staging: qlge: Remove print statement for vlgrp field.
  staging: qlge: Remove print statements for lbq_clean_idx and
    lbq_free_cnt

 drivers/staging/qlge/qlge_dbg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

-- 
2.26.2


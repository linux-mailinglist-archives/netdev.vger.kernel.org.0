Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578EEF9D1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfD3NVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:21:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35367 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfD3NVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 09:21:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44thxC6Lqmz9s47;
        Tue, 30 Apr 2019 23:21:03 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: selftests/bpf/test_tag takes ~30 minutes?
Date:   Tue, 30 Apr 2019 23:21:01 +1000
Message-ID: <87bm0nbpdu.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

I'm running selftests/bpf/test_tag and it's taking roughly half an hour
to complete, is that expected?

I don't really grok what the test is doing TBH, but it does appear to be
doing it 5 times :)

	for (i = 0; i < 5; i++) {
		do_test(&tests, 2, -1,     bpf_gen_imm_prog);
		do_test(&tests, 3, fd_map, bpf_gen_map_prog);
	}

Could we make it just do one iteration by default? That would hopefully
reduce the runtime by quite a bit. It could take a parameter to run the
longer version perhaps?

cheers

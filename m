Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FAB56C784
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 08:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGIGZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 02:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIGZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 02:25:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2809E3F31A;
        Fri,  8 Jul 2022 23:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y60swZ3rGRaeT85rdqxGs+rBj7YnKU4E8sIGSU5cn5g=; b=HyyI+Rz1TZM8KB6ilsUJb4iLuE
        SozGJ9A4WbX6Za91zOtoiJZ7g/zaQfi3PQrrHxUzxHuSP2TfOdlg3K6ghdy5ClsYXfxBm4JK6recB
        zVWLemzKoqg0F7oTslQ0zvOZZTIt6PIna9umhV7gjKBsi2Qoyc/WBV2gn9tEoZW327qwfnlCKH6X5
        JFgrFWOdulSkJbANn7F43klfqGro4wfOammQCX9k9l3IxKsEhkN8RbwvqJh4F8eNc22v/gsUpWRF7
        399RvBfH04oT6gpPfj7qOXmokqiwyhbcwX3UWiTPSiDPF2cJaDf3C0lMfHEV+1CW63a3cY50Qtkjw
        EOSrIpRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oA3tZ-0078qA-S9; Sat, 09 Jul 2022 06:24:49 +0000
Date:   Fri, 8 Jul 2022 23:24:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yixun Lan <dlan@gentoo.org>
Cc:     Christoph Hellwig <hch@infradead.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Message-ID: <YskfMTdnd+IyzCQ0@infradead.org>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
 <712c8fac-6784-2acd-66ca-d1fd393aef23@fb.com>
 <YsUzX2IeNb/u9VmN@infradead.org>
 <YsjTVvyqdVGy1uYZ@ofant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsjTVvyqdVGy1uYZ@ofant>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 09, 2022 at 09:01:10AM +0800, Yixun Lan wrote:
> Please check the ongoing discussion [0] in the bcc tools if you're
> interested in, advice and comments are welcome
> 
> [0] https://github.com/iovisor/bcc/pull/4085#issuecomment-1179446738

I can't find a way to post there, as replying eems to require a login.
Is there a mailing list discussion somewhere that is broadly accessible?


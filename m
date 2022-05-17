Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E31529E51
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244620AbiEQJoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245287AbiEQJnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBBF403CE;
        Tue, 17 May 2022 02:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A181A61525;
        Tue, 17 May 2022 09:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAB7C385B8;
        Tue, 17 May 2022 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652780583;
        bh=Tgs7wjVeAohg0a4a9UvVZ0DjnQPxJiN7q9133B2mpK4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gcJI45JVKHpymUm+2nipGubhimzqiurnLTNBUUNn47UUWoOu0RYfESarTrptQrHDO
         OlF6L/uqYYQ2HOnw34dODO8DziPPMnO2SaUNNTBfQh6dQNPeyWTQDWnBxo5Nm6TDtD
         frI3L7Sa/+iWn4SI2rewYf0n/KjkRNhe+pfwP9B5Yg+gDQnDp0qnmMPlCel408GnMR
         gRgAvTcEn/tNOK3UxP0s4MvMFXGdbrKLqNV5UtW2vA6U6wYE0xds0mRHRQKcNVbJUj
         0fRgMuOqPG+Wm0bEA3D4lJdXKT7c+qZ5V+/CTY6gpGeOgpZ5TSV1kw0i0zaJdETa8o
         wazCp7uHJeJGQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AEF4938E92E; Tue, 17 May 2022 11:42:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Cc:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06?= [PATCH bpf-next] samples/bpf:
 check detach prog exist
 or not in xdp_fwd
In-Reply-To: <942eaafecf074ae8a5bb336c18658453@huawei.com>
References: <20220509005105.271089-1-shaozhengchao@huawei.com>
 <87pmknyr6b.fsf@toke.dk> <f9c85578b94a4a38b3f7b9c796810a30@huawei.com>
 <87h75zynz2.fsf@toke.dk> <942eaafecf074ae8a5bb336c18658453@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 May 2022 11:42:59 +0200
Message-ID: <877d6kcx5o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could I add helper function to implement this function which can check
> the program name and see if it attach to the device.

You just need to call bpf_prog_get_fd_by_id() followed by
bpf_obj_get_info_by_fd(), and the program name will be in info.name.
Here's an example in libxdp where we pull out the prog name:

https://github.com/xdp-project/xdp-tools/blob/master/lib/libxdp/libxdp.c#L1165

-Toke

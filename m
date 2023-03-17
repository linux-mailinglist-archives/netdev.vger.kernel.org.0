Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599C96BE02C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCQEaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQEaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3912C32CEC;
        Thu, 16 Mar 2023 21:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95DC6213E;
        Fri, 17 Mar 2023 04:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A53C433D2;
        Fri, 17 Mar 2023 04:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679027406;
        bh=nonMteQ8r4AFz96wz9F6Zp1jokFm2wRTfb7GKDo5D4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hM31DBTFLe+ucWX+5axVmKvF738eEjWuDIxwf1QFTv8amVpMrAL7w4Bg5rNWTpTfn
         Mnw56AVN45yoG5ZR8isHBndDAwasn2w+/gY823m9pWfyQViL4Vojt2oTkO1dx8CaHA
         bBa/OzA4fMlQg4riPRbxUpJxaO0EE/bqbSZHxzF3ZG5gnpk+M62lvU2yWPuHaoetJp
         gRfW6cZf/km21sGjWNE+US4p3g7JXzqaAdXClr5BnMW1Tq6Am4nVH6T+C6bJUeK0jk
         DcIn8Ieu58LRcp+jmcAVqZX+0OsWLy96wjywvKbQQdIxPvt/ZcUc5BRLe07bd/au7I
         bq3YxE4R4xyUA==
Date:   Thu, 16 Mar 2023 21:30:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230316213004.6a59f452@kernel.org>
In-Reply-To: <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-3-kerneljasonxing@gmail.com>
        <20230316172020.5af40fe8@kernel.org>
        <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
        <20230316202648.1f8c2f80@kernel.org>
        <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 12:11:46 +0800 Jason Xing wrote:
> I understand. One more thing I would like to know is about the state
> of 1/2 patch.

That one seems fine, we already collect the information so we can
expose it.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AEB6031E5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJRSAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiJRSAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:00:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E51B36BC4;
        Tue, 18 Oct 2022 11:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03000B820E1;
        Tue, 18 Oct 2022 18:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD63C433C1;
        Tue, 18 Oct 2022 18:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666116032;
        bh=HqPXxc7jC2CPTiKZXVL1pW2evcWk/KGrG5NaJOvZ8LI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EqNZ9vKLrvArYerF2X27undpmW8xNMTAG4EF+NcYJFUvMBLMikrwubLIoYfeFWWRJ
         E38Q2YhB/tlO8rJuJIKXX/lVyXoki7krBVu/1/TugSOZy3aenjh8lam26RMgmrfHxm
         8dULcPD4sXTTn5tiLzl7YJtXs19dFsOfqvX7GEzhhlJMFUAUCJjWYe5g/mwOYZLHL9
         5PuiWEbY2T7VI2lc4DcDdmZqDYqA3M5oDmqq0h1PKbBIwpn1OA2XPvmkU55idln5X4
         KuhGueocT6jV3rU/9YDRmLjURAY3SPeMfaW60OgWk+YYoOHvbBsEY+/Iy/YXxX+j7N
         BmYZWuloyegtw==
Date:   Tue, 18 Oct 2022 11:00:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyufen <wangyufen@huawei.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Lina Wang <lina.wang@mediatek.com>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <deso@posteo.net>, <netdev@vger.kernel.org>
Subject: Re: [net 1/2] selftests/net: fix opening object file failed
Message-ID: <20221018110031.299ecb23@kernel.org>
In-Reply-To: <793d2d69-cf52-defc-6964-8b7c95bb45c4@huawei.com>
References: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
        <1665482267-30706-2-git-send-email-wangyufen@huawei.com>
        <469d28c0-8156-37ad-d0d9-c11608ca7e07@linux.dev>
        <b38c7c5e-bd88-0257-42f4-773d8791330a@huawei.com>
        <793d2d69-cf52-defc-6964-8b7c95bb45c4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 17:50:19 +0800 wangyufen wrote:
> So, there are two possible approaches:=C2=A0 the first moving nat6to4.c a=
nd=20
> the actual test programs to selftests/bpf;
>=20
> second add make dependency on libbpf for the nat6to4.c.
>=20
> Which one is better?

Can we move the programs and create a dependency from them back=20
to networking? Perhaps shared components like udpgso_* need to live
under tools/net so they can be easily "depended on"?

Either that or they need to switch to a different traffic generator for
the BPF test, cause there's more networking selftests using the UDP
generators :(

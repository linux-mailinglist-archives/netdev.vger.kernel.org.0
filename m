Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89875BDFA9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiITIRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiITIQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81B122534
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E3362585
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1721C433D7;
        Tue, 20 Sep 2022 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663661670;
        bh=f7+O42Hsj6/JDzu5n5GBsN+1V9hFlk93Gk13Xo2ncSs=;
        h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
        b=dJekUMSephvAZQOphKrDGnU31Iqyiu6fDvQVcYb8ECal/V6mXPd+KjWo40juWpkkE
         hO6jniupjM+P0p4wNLjTK1Jq+dlbEsZXSpvsDwIiDExie+a97MFYllM89ssTmbhSA3
         MZAb1uq2+BqYt7dfj6l+uXzlf5eqAv+ZHGCf3H2IEJ9d/eetY874Bgm41HhNakXGuf
         H4HCVTUaH38PrOlqMBVHtngYxFSvThaVpOUAVFoyF7fTr+bwmdd5KEEh1BJQlcj/qj
         RpUNDzTk1SgpLCpCEOuA39YYrP9G8vFuM16HcxPpXcGYId9LdMZkaNteMK4XLje8LD
         OXf/kQW4Fwh7g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <DM4PR12MB53579A35887680D5211AC282C94D9@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220906052129.104507-1-saeed@kernel.org> <20220906052129.104507-8-saeed@kernel.org> <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com> <20220914203849.fn45bvuem2l3ppqq@sx1> <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com> <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com> <166322893264.61080.12133865599607623050@kwain> <CALHRZurLscR15y48fzJXC4pAWe+wen8JZVCwk2fwT4wujqSdRQ@mail.gmail.com> <DM4PR12MB53579A35887680D5211AC282C94D9@DM4PR12MB5357.namprd12.prod.outlook.com>
Subject: RE: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
From:   Antoine Tenart <atenart@kernel.org>
To:     Raed Salem <raeds@nvidia.com>,
        sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "naveenm@marvell.com" <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Message-ID: <166366166577.3327.17682877096646901460@kwain>
Date:   Tue, 20 Sep 2022 10:14:25 +0200
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Raed Salem (2022-09-19 15:26:26)
> >From: sundeep subbaraya <sundeep.lkml@gmail.com>
> >As of now we will send the new driver to do all the init in the
> >prepare phase and commit phase will return 0 always.
> >
> I think it is better to do all the init in commit phase and not in the
> prepare to align with most drivers that already implemented macsec
> offload (both aquantia and mlx5 and most of mscc implementation), this
> will make it easier to deprecate the prepare stage in future refactor
> of the macsec driver in stack.

Yes, please do this.

Thanks,
Antoine

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE2596FCC
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbiHQNTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbiHQNTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7963133A20
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB63C611B9
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 13:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833C2C433D6;
        Wed, 17 Aug 2022 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660742327;
        bh=ddf7x4YQ3yeCg+JN2UFftGz9J3b+a+5Qa+fwq/w63lk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TYDs1F5MzEbqm4K9YNGdyVORSMPzcUv38y9Pwb+m9M+D4kS8S6YBHMW0pYVEJAPDS
         ovWKyatIzgcPs14absumBb3bRL8oVSyGjDWeyV3w3iAicry92OaK7usleUoKmXt/Mq
         q+HNAu72FGpeqUuueCB9v2QiqGswnGM9fSiL+GJDX4lFvbtwIobe18Qoj3qBc9pYOZ
         Ht2l7cjpn4mOcD3sVo89qzl/R2EJv3spYiCYAVJmtnjsFtcQ/g5Y2/aXyedLUo8lj+
         f0h30/vB1sSfTd2VPOq1Hus2mawn9IN2hUDhTrCXxrjl/T5GtIq/QDXuS9Cm5vToCS
         pEkC8oOFOCDlg==
Date:   Wed, 17 Aug 2022 15:18:41 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ptikhomirov@virtuozzo.com,
        alexander.mikhalitsyn@virtuozzo.com, avagin@google.com
Subject: Re: [PATCH net-next 1/1] openvswitch: allow specifying ifindex of
 new interfaces
Message-ID: <20220817131841.frtdyro52bsus2h5@wittgenstein>
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
 <20220817124909.83373-2-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817124909.83373-2-andrey.zhadchenko@virtuozzo.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 03:49:09PM +0300, Andrey Zhadchenko wrote:
> CRIU is preserving ifindexes of net devices after restoration. However,
> current Open vSwitch API does not allow to target ifindex, so we cannot
> correctly restore OVS configuration.
> 
> Use ovs_header->dp_ifindex during OVS_DP_CMD_NEW as desired ifindex.
> Use OVS_VPORT_ATTR_IFINDEX during OVS_VPORT_CMD_NEW to specify new netdev
> ifindex.
> 
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> ---

I think specifying the index at device creation time is a good idea and
iirc then we do allow this for veth devices already. So I'd be happy to
see this go forwad.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF2F4E6C1A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357420AbiCYBka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357649AbiCYBiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:38:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95174C3342
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 18:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B8FB8226E
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C57C340EC;
        Fri, 25 Mar 2022 01:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648172150;
        bh=duaa5iF076uweeIYzIOgDfqRZ8kGTLSBbu5dM+j2mWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=murElngix8aKzRIpFeaHK9qJA08m52F+A+3v3yD4NKLiTymtqet1iYAbyUGZh70iv
         BTKk2AC9IB6yFsQD5+cgf1Ndf3vFwJy30DvAMbty9pixsCKhQfBoOP2ABt+wSzFQ3V
         jADdJw7TUCtWDFj7FK/amCY/AHRsJIfoMfKgxd2P6XTvkch/Bbvs7jtv7sIjbObAU+
         uvGJsdhPJDvfEQD+PaUGpEx7obXXR9cQW0mYyHI4DxcZ8wG5AklprEgl/zWCmfV1pq
         QX1MBU8gziSYsfMuKfxugdwJ1qHjrnKgdKoGmdXFPb/nvLo6kS3wsuiAM2inUPI6Vj
         NQ4vuzrZc4yvQ==
Date:   Thu, 24 Mar 2022 18:35:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
Subject: Re: [RFCv5 PATCH net-next 01/20] net: rename net_device->features
 to net_device->active_features
Message-ID: <20220324183549.10ba1260@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2c493855-4084-8b5d-fed8-6faf8255faae@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-2-shenjian15@huawei.com>
        <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220324180331.77a818c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2c493855-4084-8b5d-fed8-6faf8255faae@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 09:29:51 +0800 shenjian (K) wrote:
> =E5=9C=A8 2022/3/25 9:03, Jakub Kicinski =E5=86=99=E9=81=93:
> > I see you mention that the work is not complete in the cover letter.
> > Either way this patch seems unnecessary, you can call the helpers
> > for "active" features like you do, but don't start by renaming the
> > existing field. The patch will be enormous.
> > . =20
> I agree that this patch will be enormous,=C2=A0 I made this patch from su=
ggestion
> from Andrew Lunn in RFCv3.[1]=C2=A0=C2=A0 Willit make people confused
> for help name inconsistent with feature name ?
>=20
> [1]https://www.spinics.net/lists/netdev/msg777767.html

Thanks, not sure if I see a suggestion there from Andrew or just=20
a question. Maybe you can add a comment instead to avoid surprising
people?

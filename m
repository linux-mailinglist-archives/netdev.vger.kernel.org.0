Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3154BF98
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 04:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbiFOCMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 22:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiFOCMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 22:12:34 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04C3E2192
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 19:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Mime-Version:Subject:From:Date:Message-Id; bh=+KQC1
        LILuSTroDP1tAYm+Qsg49hiURemCd4BNP0dj7k=; b=fWxMrZJwQAXU319xH93qp
        yeWUbsVMEzkJOMA1ijhICipOXDPjuroyozcBcjJDuUpq6aePlykGaaftaR7tLiHu
        Pfi+mEz5/1TG6AZFxUNzT+KdBrlsi5Iv5s3BAM1sY1FSamJfp2Yfz661qQthvQJe
        c5eSGXcZAG6lNFEIlBLGu4=
Received: from smtpclient.apple (unknown [117.136.39.91])
        by smtp2 (Coremail) with SMTP id DMmowABHqva9P6liev4WDQ--.29305S2;
        Wed, 15 Jun 2022 10:11:11 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v6] igb: Assign random MAC address instead of fail in case
 of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixuehao@126.com>
In-Reply-To: <20220614181914.4cd8fe97@kernel.org>
Date:   Wed, 15 Jun 2022 10:11:07 +0800
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        lianglixue@greatwall.com.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <F4C0C492-49D3-4B91-B2B4-D216220D421A@126.com>
References: <20220610023922.74892-1-lianglixuehao@126.com>
 <cbfb5d1a-dadd-efe5-b5d9-de9f483e44b2@intel.com>
 <20220614181914.4cd8fe97@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: DMmowABHqva9P6liev4WDQ--.29305S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JryfZw1fZw4xuF43tFy3CFg_yoWfJrXE9r
        s5ur1UXw1DGr9IkwsxKrWYvr97XFyDAFyvv390qFZrX3s5Za17uw1DJa4xXas3trWvgr4D
        KFnFgr1IgF9IvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUbTmPUUUUU==
X-Originating-IP: [117.136.39.91]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/xtbBGhAhFl-HZTKBuQABsL
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As alexander.duyck@gmail.com said, "allow_unsupported_sfp" in =
ixgbe_main.c,=20
and I also noticed "eeprom_bad_csum_allow" in e100.c, are all in the =
form of module parameters.

If the invalid MAC address is automatically replaced with a random MAC =
address,=20
other problems caused by the random MAC address may be difficult to =
debug.=20
Using module parameters can make it easy for users to correct invalid =
MAC addresses=20
without causing the above problems

> 2022=E5=B9=B46=E6=9C=8815=E6=97=A5 09:19=EF=BC=8CJakub Kicinski =
<kuba@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 14 Jun 2022 12:09:02 -0700 Tony Nguyen wrote:
>>> Add the module parameter "allow_invalid_mac_address" to control the =20=

>>=20
>> netdev maintainers:
>>=20
>> I know the use of module parameters is extremely frowned upon. Is =
this a=20
>> use/exception that would be allowed?
>=20
> I think so, I don't see a different way here.


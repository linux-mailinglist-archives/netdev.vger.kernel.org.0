Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32083EAFFE
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 08:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhHMG0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 02:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238830AbhHMG0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 02:26:02 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E021C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 23:25:35 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:ef0a:7f0c:624e:2eac:9b4])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 17D6PJ5b008235
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 13 Aug 2021 08:25:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1628835919; bh=bp7pZnR9reEk1Vxp5PGpzCMFuYVD2oMgInso1w7A9ec=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=oC6zEaGd/7yWCn+rL+7wUSJ/+E9YfxAXjUE0ElE3Zw6w+2fER/n+z7E9RSCYrGZnP
         qSaQ69FIoSmGibiBQNlFenwB9f5uce9zkH9GTmQWA/NUNCC0WuM8VZ0QJrRrPMatDE
         DsHi1lcOnq1GUiEITm5mkbyTQfH+2CtaF/eJ2bls=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mEQd0-000OMT-AH; Fri, 13 Aug 2021 08:25:14 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     subashab@codeaurora.org
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
Organization: m
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
        <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
        <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
        <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
        <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
        <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
        <87bl6aqrat.fsf@miraculix.mork.no>
        <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
        <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org>
        <87sfzlplr2.fsf@miraculix.mork.no>
        <394353d6f31303c64b0d26bc5268aca7@codeaurora.org>
        <CAGRyCJEekOwNwdtzMoW7LYGzDDcaoDdc-n5L+rJ9LgfbckFzXQ@mail.gmail.com>
        <7aac9ee90376e4757e5f2ebc4948ebed@codeaurora.org>
Date:   Fri, 13 Aug 2021 08:25:14 +0200
In-Reply-To: <7aac9ee90376e4757e5f2ebc4948ebed@codeaurora.org>
        (subashab@codeaurora.org's message of "Fri, 13 Aug 2021 00:21:21
        -0600")
Message-ID: <87tujtamk5.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.2 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subashab@codeaurora.org writes:

>> Just an heads-up that when I proposed that urb size there were doubts
>> about the value (see
>> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1=
-dnlplm@gmail.com/#2523774
>> and
>> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1=
-dnlplm@gmail.com/#2523958):
>> it is true that this time you are setting the size just when qmap is
>> enabled, but I think that Carl's comment about low-cat chipsets could
>> still apply.
>> Thanks,
>> Daniele
>>=20
>
> Thanks for bringing this up.
>
> Looks like a tunable would be needed to satisfy all users.
> Perhaps we can use 32k as default in mux and passthrough mode but
> allow for changes
> there if needed through a sysfs.

Sounds reasonable to me.



Bj=C3=B8rn

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF6638791
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiKYKdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKYKdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:33:12 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C882B605;
        Fri, 25 Nov 2022 02:33:10 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 08DFF5C00F5;
        Fri, 25 Nov 2022 05:33:10 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 25 Nov 2022 05:33:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1669372390; x=1669458790; bh=JROol/irmv
        N5MEhKuBHYiHbWYmYWc16fBXOgVLqfN3w=; b=nc6+evhM3PIDQl6BIqrif/Xc90
        fnSj7VcZ+bdORPHuauNy1fBgw/kKBaDBy2vc39GQNCgHzf2LuWLVwUTZy04QZKlS
        j8lzQVSTLtKHYmGS23rlmJ57G97jCKDfr9zjbVgAscon8MgkqyF7lgo4OTtwHR9/
        Q3mBYW5S9NpoDlPcqoDvQyK5t4IEOGMjR6ABWAxYj7r/ML0UhmYbXIaPa8rWy9Sd
        /tMIYfwHfZkg+uBurm11rFWrCNrhfMjq09kVNyKYfTz4pOCgI+iMrc6DiBid9z/M
        HtJPe9AoWNDCs8PolW70SXGNXsAmnB9g/Uu6MY9bsYhHMnOSkAfKH85BcMmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669372390; x=1669458790; bh=JROol/irmvN5MEhKuBHYiHbWYmYW
        c16fBXOgVLqfN3w=; b=U1hY0Cudj6B4TKUpU+tp2asHfGqBdJUcRkwh/m9AvweJ
        1skw5vkkHJiupRKLu7OC+A4BhA9V0mURms+o/zGEw2Vz0nWcsB89Jrfz8/ioPOP6
        ccrGqXDEC8Ef7q1ny1WS3dEG84csgp/39vf49Y4gYeVOUwbJIKuFcM/3cZVo1SNp
        g3xnD2Uz4k/s7jLtpyIDOTO7cqeSvN89nbcy5+nxN8gT3J1VMGmTJLrCKbbZjcvl
        Z69J6+e7+Baf7WAiP+dvzqACH33mbbajKakUiyb5kX3zsmcPNwxXARdEtTCiX2vT
        gyZ/FWJ2mRnqnPimFL4yxRy29jqMc9XN7D4q9lZfsw==
X-ME-Sender: <xms:5ZmAY1XYErWsidxtNqOjpk8K83kB3OzuZaMXKKsLk1HoMHlsgyDwiQ>
    <xme:5ZmAY1mWtHOqqWcOTApwtuQhVW8n966vkpmLNoWwDlb8Bx2oXf2sZ-jInp7OD4x27
    o3AIW4bSRLsKsjFw5o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeet
    ffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    hnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:5ZmAYxZSZEJ7_3pgDwmuQWYyWlQi9_s_WlDWUFix7KPc_f3zjgW7Qw>
    <xmx:5ZmAY4UjomsQ9nQ2i3xVelvGVhqVmKyMtYoO5CmqcLixG1BgpjszUw>
    <xmx:5ZmAY_lh0tCnqCaf7YONCkllryXgss1689XvIrjI2E03wRz4fYDssw>
    <xmx:5pmAYxuh2MkrW6VoxPrz_SAR1bJiVKtaxdZxdI4prcsY34JTauL2fg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5B292B60086; Fri, 25 Nov 2022 05:33:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <78fc17ac-bdce-4835-953d-d50d0a467146@app.fastmail.com>
In-Reply-To: <23b0fa9c-d041-8c56-ec4b-04991fa340d4@huawei.com>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
 <Y4BuUU5yMI6PqCbb@kroah.com>
 <CA+G9fYsXomPXcecPDzDydO3=i2qHDM2RTtGxr0p2YOS6=YcWng@mail.gmail.com>
 <a1652617-9da5-4a29-9711-9d3b3cf66597@app.fastmail.com>
 <23b0fa9c-d041-8c56-ec4b-04991fa340d4@huawei.com>
Date:   Fri, 25 Nov 2022 11:32:49 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     YueHaibing <yuehaibing@huawei.com>,
        "Naresh Kamboju" <naresh.kamboju@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        "Pavel Machek" <pavel@denx.de>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022, at 11:25, YueHaibing wrote:
> On 2022/11/25 18:02, Arnd Bergmann wrote:
>> On Fri, Nov 25, 2022, at 09:05, Naresh Kamboju wrote:
>>> On Fri, 25 Nov 2022 at 12:57, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>> On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
>>>>>
>>>>> Daniel bisected this reported problem and found the first bad commit,
>>>>>
>>>>> YueHaibing <yuehaibing@huawei.com>
>>>>>     net: broadcom: Fix BCMGENET Kconfig
>>>>
>>>> But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
>>>> this -rc release.
>>>
>>> It started from 5.10.155 and this is only seen on 5.10 and other
>>> branches 5.15, 6.0 and mainline are looking good.
>> 
>> I think the original patch is wrong and should be fixed upstream.
>> The backported patch in question is a one-line Kconfig change doing
>
> It seems lts 5.10 do not contain commit e5f31552674e ("ethernet: fix 
> PTP_1588_CLOCK dependencies"),
> there is not PTP_1588_CLOCK_OPTIONAL option.

Ok, so there is a second problem then.

Greg, please just revert fbb4e8e6dc7b ("net: broadcom: Fix BCMGENET Kconfig")
in stable/linux-5.10.y: it depends on e5f31552674e ("ethernet: fix
PTP_1588_CLOCK dependencies"), which we probably don't want backported
from 5.15 to 5.10.

YueHaibing, do you agree with my suggestion for improving the
upstream 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
commit? Can you send a follow-up fix, or should I?

      Arnd

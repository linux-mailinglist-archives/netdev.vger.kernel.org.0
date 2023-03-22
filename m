Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD006C44E6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 09:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCVI1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 04:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCVI1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 04:27:00 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB065CC24
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 01:26:58 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A50D5C021A;
        Wed, 22 Mar 2023 04:26:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 22 Mar 2023 04:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679473616; x=1679560016; bh=SzIhX6GvHnizN
        psaYaRgqmqGdVjvBEuASOUEmJvFwKI=; b=oJ1cds8zmncI2b5sz5/+Ff5SGWHo0
        xodjtVd+1yMESZI4xXtiVhkRkBy6IHTQgWdihkSrSlNhc4duYfn/VCSTU/4ZTWMc
        Rs4xvjiGgc+r3A551+KncyrtDG7t9vMYIhuIkU4Ke9N+N5SxnSGl08ohpgH7C2Ty
        KoyKfBO3Wl3CyJjKEtdgiI7VcST7s3bGeVdzwg+/JWl8h5c4r0DYiVlvnRjrceU5
        e6Eu8+Y+HrxPXFBSW9m9KQ0kfY55b5k7wPbtroGVevGp4js6uRfq49FCn7k0xQiP
        QPskt6QRHw7EJEnRjVSZDSbEf9GuzYPKrg+mNjTXeY8AF2w8S6/8fVUIg==
X-ME-Sender: <xms:z7saZAmp66t5Fv4GRpQPALkhWruFMVpVTVyWs2Nw9f_Dp2jCeQDV-Q>
    <xme:z7saZP0qd9fkhE8iQBpvfosbqUvKUNJ6zBS6_xtx2F5fpEvcV62-Y1-ok9RvhvZm7
    -2oJ-nfBXfKVf8>
X-ME-Received: <xmr:z7saZOrz-MxYJ6lt09_x0thQ9Gm8nZfFJOcHVItVDaJI8u4suDEM8rUPZ07OAMhc2junQ3hyhDYrqyhqP4alsFwSXOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeguddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:z7saZMmCv_2N4ql5QFvNCkGR2bZpkiAohUfifcU9h5BEoqXZvl7cjA>
    <xmx:z7saZO0JmzVqpxT3ZCxk8EOgkrtnKOESwRi4pCuBCk4DPdEQmB9QcQ>
    <xmx:z7saZDvEUEvsXURyycEolfdkua08rH2EwDNMyyJWqU_nLt4IpBfXPQ>
    <xmx:0LsaZIpiqSE5w_5tD9E1_BYxzRjBXjdk2pgLDQxGUi1gc68JQ1U7Jg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Mar 2023 04:26:55 -0400 (EDT)
Date:   Wed, 22 Mar 2023 10:26:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org
Subject: Re: [PATCH net-next v4] vxlan: try to send a packet normally if
 local bypass fails
Message-ID: <ZBq7yv0W5MqhqYnm@shredder>
References: <20230322070414.21257-1-vladimir@nikishkin.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322070414.21257-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 03:04:14PM +0800, Vladimir Nikishkin wrote:
> --- a/Documentation/networking/vxlan.rst
> +++ b/Documentation/networking/vxlan.rst
> @@ -86,3 +86,16 @@ offloaded ports can be interrogated with `ethtool`::
>        Types: geneve, vxlan-gpe
>        Entries (1):
>            port 1230, vxlan-gpe
> +
> +=================
> +Sysctls
> +=================
> +
> +One sysctl influences the behaviour of the vxlan driver.
> +
> + - `vxlan.disable_local_bypass`
> +
> +If set to 1, and if there is a packet destined to the local address, for which the
> +driver cannot find a corresponding vni, it is forwarded to the userspace networking
> +stack. This is useful if there is some userspace UDP tunnel waiting for such
> +packets.

Hi,

I don't believe sysctl is the right interface for this. VXLAN options
are usually / always added as netlink attributes. See ip-link man page
under "VXLAN Type Support".

Also, please add a selftest under tools/testing/selftests/net/. We
already have a bunch of VXLAN tests that you can use as a reference.

Thanks

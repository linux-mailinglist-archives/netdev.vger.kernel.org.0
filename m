Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167259FF55
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239175AbiHXQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbiHXQTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:19:24 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74338BF6B;
        Wed, 24 Aug 2022 09:19:23 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A82BA5C0130;
        Wed, 24 Aug 2022 12:19:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 24 Aug 2022 12:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1661357962; x=1661444362; bh=2tt4bKWdVf
        Kwuv/SppicGwVjbD93bxtV9hjzPrLdrOY=; b=ozC9ULWIk/poqxcWJPbDlGvwBJ
        MN9HfJQ6h0mCPthY5f7lFtaBS7yA/iM7uXYjqsDWCRgz3En5+k03H6j/GdqcZfcI
        XwxvXNtszwHVVCgTKOH3gNEim03V1sJoKvC2ZYR94/YN+a5D54hUF1ZWt/x9nkCU
        yMXvDv5OadQb1GZcGIaIWv0wIMJB06akm8FEj4MnLvoOVRUavLVNwLGsDdTkkJt1
        80by51VBFyy3wpJVryRITvu+o/9Wb7iMHAqvlrJCT54nMSKnn9TXWJFsJbjjwBYF
        hisERArzuaxrXvukVH8AcHzoud1PJdzk+i5pZ7ELKCGu3g6+CR05OUNvBFNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661357962; x=1661444362; bh=2tt4bKWdVfKwuv/SppicGwVjbD93
        bxtV9hjzPrLdrOY=; b=PPAlJ6cJu3AX0egZYllBTfdVeA5tovrC4cuwARjmX8ga
        QVLRAPGqSbfuNHkb9zLWfGumyYb9PJW2Itt4JMF6pzyfOjPMUKT5ExXeEOrb8pEw
        E4sge8BCbqhcOPHmaM79GltC74eAHZbvNFm7C9Ib+1p3RCrGbulNhUAcSgqbAzOg
        jaKOYfItYAzE07e6mrmbsVIDbs62XxwnfWPoJKSDmKbB2QjExde5zwJjxjsFstUS
        iis9zcAT8tX2wz7ZKXLiyMgPyb56Lp0N0IPehQFOSv5mHX9Dzc/jxTYZvU2bTNFz
        4RHQ1Bm4XipqrtAIBw3ouP8S5yH+VbH8EIdQI3qm1w==
X-ME-Sender: <xms:ik8GYwsqnbqHySMXRg5s_ysOT3fA0d88-U7o4tCpt_t71zEcq4mEvg>
    <xme:ik8GY9fkyjx12pxuIIF9kD0KdQNG49ATNavUuTO2wVwCbO--TjSc_8SK7fwumR9M0
    WQc_nVy0YckEg>
X-ME-Received: <xmr:ik8GY7zxkIu2PbKgLkbhxmmZ9tQU0AWrQncRq8m-EG-24YpjderRTOkl7cFNfew0qWpEZNBXMYdcRjosdVrqHNSMj5rWv9P6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdejuddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesth
    dtredttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecuggftrfgrthhtvghrnhepheegvdevvdeljeeugfdtudduhfekledtiefhveejke
    ejuefhtdeufefhgfehkeetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ik8GYzNBGcyJ9pXDCexTmOLSBfZpraUY0qKKr47vRnwC0-hG-U0JAQ>
    <xmx:ik8GYw9ZnCh4N40609hug28dUINwGUHu4cGkayXZh1dOy6u2SjO_HQ>
    <xmx:ik8GY7UBUF89w4CAEDzxeJct-Kvkv9302V0EW-iuuzC9EsRRkk9GOA>
    <xmx:ik8GYwOQC_qeIrJMwl_qi-1p5oXwt6ZdnOuxxRNLzEvlDXOv3uim4w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Aug 2022 12:19:21 -0400 (EDT)
Date:   Wed, 24 Aug 2022 18:19:17 +0200
From:   Greg KH <greg@kroah.com>
To:     JFLF <jflf_kernel@gmx.com>
Cc:     oliver@neukum.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8152: add PID for the Lenovo OneLink+ Dock
Message-ID: <YwZPhTG5QMgoLSrr@kroah.com>
References: <20220824161307.10243-1-jflf_kernel@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824161307.10243-1-jflf_kernel@gmx.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 06:13:07PM +0200, JFLF wrote:
> The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
> a broken CDC device by default. Add the custom Lenovo PID to the r8152
> driver to support it properly.
> 
> Also, systems compatible with this dock provide a BIOS option to enable
> MAC address passthrough (as per Lenovo document "ThinkPad Docking
> Solutions 2017"). Add the custom PID to the MAC passthrough list too.
> 
> Tested on a ThinkPad 13 1st gen with the expected results:
> 
> passthrough disabled: Invalid header when reading pass-thru MAC addr
> passthrough enabled:  Using pass-thru MAC addr XX:XX:XX:XX:XX:XX
> 
> Signed-off-by: JFLF <jflf_kernel@gmx.com>

Again, we need a real name, thanks.

greg k-h

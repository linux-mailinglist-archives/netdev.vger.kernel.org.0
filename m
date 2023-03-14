Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412E66B894A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 05:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCNEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 00:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNEIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 00:08:20 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A977A12860;
        Mon, 13 Mar 2023 21:08:15 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 181C55C0158;
        Tue, 14 Mar 2023 00:08:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 14 Mar 2023 00:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=cc:cc:content-transfer-encoding:content-type:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1678766893; x=1678853293; bh=wEn3F9g21ZKG0PT50olnWF7OZ
        L5E/VI358hZAFZ/7fM=; b=qvbCh3qdEJbbCzLY83We0Z5gUbMeJOxDR38OeMFUP
        zHZtTslqV3qrPKpyXVOKuk33qSRy8MxnMxlcwx4m0zRqwG0jPWG3jtPRidF0+ekI
        KncUW6ot/ugPklzcTo6H/FoaTdT3SY+85oj03L8bT8LBLJJ5gZomlBCmWQcUYHEP
        ZwQ3EP+pm4ffV3sZXd+c/HsX72v+dRiuvKlU9DRre0/3T4ILbbZ/lG1rKX2ys4vL
        rFdp0btVvckTgvhXxLt6GZY4o+Ma5Py8qclQOr4BvEJWpsMLuSwFCX06JzyyDG+P
        RCv1q2kWf+AxNMga59SvA/rKLgrKv2a0qzMTRTjEulEAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1678766893; x=1678853293; bh=wEn3F9g21ZKG0PT50olnWF7OZL5E/VI358h
        ZAFZ/7fM=; b=ZQdl0rDJuMCOCG78QzrS8UHdZ4KVbak3xNY40pkjAM3IANnayDU
        LgFsxc9ED6d0PMNrb231ZJ5Lks7ySdMD1Pad0Zj/B7QXafNqmYY/wTfa4ZMqHZoa
        pLujXMy6TDgFkX4Lu2kEpLGLIVLZgSFCOBGI0xh8yMv/kGLVL0eyuZcmXRi4TqpD
        EzYLsFgXzcjPm+qRYZ4xsmn/I7MHe7BTG9YNuVk0Q28XsngL1TrwMfVy4Q/hw7z+
        uN2hOoPQt10+yFHVMApOvw70TGdtqJnovNas6E8lQIQtnLEOQNWQ2dQ08kzV2pQF
        K/EcdpOWAHQYjNm9fXzfPeTBLasH1rPg0Eg==
X-ME-Sender: <xms:LPMPZMQGRaCTWVegDujr5exI48bwFVO3JLwAJCq5IaYHtTwq8t1QEA>
    <xme:LPMPZJwVHr4lD8kb2SVytf76QH7jYyZm0GyhI2jtPbRcleR9nWYyh8PX9jrJSY9OW
    9g3ntg8NitW7uWNnw>
X-ME-Received: <xmr:LPMPZJ2zaSUMNqagcvYkxuaH0rDAfwMczw1ow0PjY0xlSM4YLe-72r-4RhCbcEU07EUEi4LBS5a4h5rk4FaZOMcxndiI1fgKWR5q_ZfREQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdliedmnecujfgurhepfffhvfevuffkfhggtggugfgjohesthekredt
    tddtjeenucfhrhhomhepofgrrhhkucfirhgvvghruceomhhgrhgvvghrsegrnhhimhgrlh
    gtrhgvvghkrdgtohhmqeenucggtffrrghtthgvrhhnpeetveetjeeujeefjefhueekueei
    ffeuleevleelffeghffgleffgfefhfehhfetleenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehmghhrvggvrhesrghnihhmrghltghrvggvkhdr
    tghomh
X-ME-Proxy: <xmx:LPMPZAD0_-T-fDJX_C-Y1NB0_Bzyg7c64AcJdfi_IVobPO3BhpZbQw>
    <xmx:LPMPZFiodqJuPMsQDJ0OY1eAybiIDEv_mUQQttjzDTiahziKaGk2ig>
    <xmx:LPMPZMpZy8mV-93W2GizBX4OHvarRbGKcbjcaSuGHTQjuEKb8hnamw>
    <xmx:LfMPZKtu1aU5yYti0-p_yYzee0W0QCQHGN1UXPvlWPn87eqzdK21Tw>
Feedback-ID: i9cc843c7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Mar 2023 00:08:12 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id E3C02521076; Mon, 13 Mar 2023 21:08:10 -0700 (MST)
Date:   Mon, 13 Mar 2023 21:08:10 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: trf7970a: mark OF related data as maybe unused
Message-ID: <ZA/zKpviZAWPoQfo@animalcreek.com>
References: <20230311111328.251219-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230311111328.251219-1-krzysztof.kozlowski@linaro.org>
Organization: Animal Creek Technologies, Inc.
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 12:13:28PM +0100, Krzysztof Kozlowski wrote:
> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/nfc/trf7970a.c:2232:34: error: ‘trf7970a_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/nfc/trf7970a.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 21d68664fe08..7eb17f46a815 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2229,7 +2229,7 @@ static const struct dev_pm_ops trf7970a_pm_ops = {
>  			   trf7970a_pm_runtime_resume, NULL)
>  };
>  
> -static const struct of_device_id trf7970a_of_match[] = {
> +static const struct of_device_id trf7970a_of_match[] __maybe_unused = {
>  	{.compatible = "ti,trf7970a",},
>  	{},
>  };
> -- 
> 2.34.1

Reviewed-by: Mark Greer <mgreer@animalcreek.com>

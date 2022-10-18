Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9EB6022BC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiJRDhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiJRDhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:37:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208B89C7CE
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 20:29:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so16115813pjg.1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 20:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrnnumGld0VJ5ypgmFoVxezcFRUmDFhG2PPyzju622s=;
        b=hYPLrYMdsf1GhruRdVolMbMdmqHmxeO3vcwbZS4thfgaPrSoDI9MlmNbFfjdX6uX7w
         Z6f9jf81UBs88QRtj5a53wV8W9nDPsilsiTST3mN0cJ89dbVPkW0ur1l843epmFY6SRn
         ai3lBGfxaEzl1FIBk+g9lei8sZ+FRvJsF55sLECsMsJ/NZ/rIkLbotm4bfxBo3PWfQJ8
         PKQY7DaGka5F5f4uvShmBrcXydNw+PrPUUNxAohlLIf9KjTU9VEegJWtNx60m9jyVoFZ
         SSx1nfd5KMSOHHj9g8Uh2mGjwpkdlvbOa5rQBUBomW/Gg0hfcrorZrZcMnOFCz5WrUBO
         CEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrnnumGld0VJ5ypgmFoVxezcFRUmDFhG2PPyzju622s=;
        b=o0QuOBdsROJN4NySUuvwBUUlYBLONIErJ/xpFNGy4gzQRBh5/byma6E6eBhiY57w08
         m7FUNWpXA8T8ILGIND4MB+ocHDyaPbXp8DkjLoOVpcQOfxUh5zaqmzhezKIGb21C9trR
         kLKQ0XCp35enB0rxmekUu9x7EI5ShKA1SZF7P51g0wnxip2FrqYLPOkGJf2e0585UizP
         uL9nhUlwoAF+j8jWrI/+3JdN/njY8pGEPGP8Bm1sqjQPT6ZY7Dn2PELPvUI2eTeYTLaz
         mORWFUYDM00zI692CMT+MwvW5KczFHFgJQ2VStEQsEqjgPitVpxxwPt9tHr85DOMmYLd
         q6ig==
X-Gm-Message-State: ACrzQf0S0fOs1qgymwa7nhb+9Pjmk5X/6E52sfPrkrwc5h7TvcXmubGP
        KfW3WG/WkzcLiNv7QfsT5seW6A==
X-Google-Smtp-Source: AMsMyM7bNCCEHru0U4EwwqqqQgEyeRbC1s4SukAYDel6DLH4Y2dDndCF6wVTAUpzDxGnw8Rt8yxtmA==
X-Received: by 2002:a17:902:d48d:b0:185:115c:b165 with SMTP id c13-20020a170902d48d00b00185115cb165mr1131316plg.86.1666063756541;
        Mon, 17 Oct 2022 20:29:16 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090311c800b001754fa42065sm7426591plh.143.2022.10.17.20.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 20:29:16 -0700 (PDT)
Date:   Mon, 17 Oct 2022 20:29:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     gaoxingwang <gaoxingwang1@huawei.com>
Cc:     <netdev@vger.kernel.org>, <dsahern@gmail.com>, <gnault@redhat.com>,
        <liaichun@huawei.com>, <yanan@huawei.com>
Subject: Re: [PATCH] maketable: clean up resources
Message-ID: <20221017202914.64cdd5f3@hermes.local>
In-Reply-To: <20221012093534.15433-1-gaoxingwang1@huawei.com>
References: <20221012093534.15433-1-gaoxingwang1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 17:35:34 +0800
gaoxingwang <gaoxingwang1@huawei.com> wrote:

> Signed-off-by: gaoxingwang <gaoxingwang1@huawei.com>
> ---
>  netem/maketable.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/netem/maketable.c b/netem/maketable.c
> index ccb8f0c6..f91ce221 100644
> --- a/netem/maketable.c
> +++ b/netem/maketable.c
> @@ -230,5 +230,8 @@ main(int argc, char **argv)
>  	inverse = inverttable(table, TABLESIZE, DISTTABLESIZE, total);
>  	interpolatetable(inverse, TABLESIZE);
>  	printtable(inverse, TABLESIZE);
> +	free(table);
> +	free(inverse)
> +	close(fp);
>  	return 0;
>  }

Why bother. This is a tool only used during builds and this the end
of the main program so all resources will disappear after return.

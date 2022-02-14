Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D934B4511
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242416AbiBNI6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:58:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiBNI6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:58:46 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B175FF01
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 00:58:39 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id f37so2878804lfv.8
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 00:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=frEgWKPgF8KaoGE1eikmsnZ/0pA7cqKYwLVpgb9hgi8=;
        b=fWGSxG9mZHsVIpMLNecBje5YEBhZzCGANoZBh0jeEFfq8NsAyR2EGi0dlMc+JlXQFw
         CRYkOTOuGUZwSnp9frim1fpDSN/JkOMAQvWmaCWKk3UZGXqHEyyhKU39bm+LeNTarodB
         XM61M/tseOK5y7XGGwawZvKWdcntbO3szucWtr7poi5yaCzbuwG55NG+/y2gGRK+3rVg
         C08xDYAeuR7nbBfzq5qMLk3NEnLiD5arsF6h22csItYRal3i7tL5Rpz0lyWLt/OPOuB1
         wHFMtX3Bco3FvhtM8crDCnPFu4WLPsb9g7tbvLPg9iak9GTodrsLntbr+sdKgLlk58Ew
         xSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=frEgWKPgF8KaoGE1eikmsnZ/0pA7cqKYwLVpgb9hgi8=;
        b=F0tS6nYeFJhXErNkA99s4qUGuSuOhKGOmaS+IOJQ0Y9+hkqSmrUGta3TQXNjz/mL5m
         8N1ELExs346WmFPAo8zRmiEgffETujRoM70EtMFXoWhr2tjn9WY2GBfSj9y/Mlbq70nO
         WRxJEEpVhj+305Q6Yuk+URUXngOJ73N/D42bB9T2K5Z1tptlmUHgmyDlgXc3lYPJFq65
         3H6BWrWv8zre79zH37lKisyrWPgZ4T6iLc6nsECEqe1yYRAlffKlL8NKfxhVJiwoaR5D
         OvxDDIQO4T0I9OviQ/jmNYdmRurOiIhljjVn94kKDRkGkcE8JN/AzZPwe3jDyiB93VIM
         l3Ug==
X-Gm-Message-State: AOAM532IxjTTsYlou8TIlaSXzt76wiiTAnpCB+OPktGk78xrJHRzIAqx
        dnlOHoOVhE5aE2Dh2Ak6Hbo/Y8QsqlYeC1E8
X-Google-Smtp-Source: ABdhPJzmjk2Ak1uecTmmTu9PNouzy9yMtJrd+vKOdMb3Mg1aipue/yticklhD/xU4oALj+Qf5JMaeQ==
X-Received: by 2002:a05:6512:22c4:: with SMTP id g4mr9872887lfu.131.1644829117772;
        Mon, 14 Feb 2022 00:58:37 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id c19sm204103lfs.198.2022.02.14.00.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 00:58:37 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports
 (for 802.1X)
In-Reply-To: <20220211145957.5680d99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <20220211145957.5680d99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 14 Feb 2022 09:58:12 +0100
Message-ID: <86h791hljv.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On fre, feb 11, 2022 at 14:59, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed,  9 Feb 2022 14:05:32 +0100 Hans Schultz wrote:
>> The most common approach is to use the IEEE 802.1X protocol to take
>> care of the authorization of allowed users to gain access by opening
>> for the source address of the authorized host.
>
> noob question - this is 802.1x without crypto? I'm trying to understand
> the system you're describing.

No, user space will take care of authentication, f.ex. hostapd, so in a
typical setup the supplicant and the authentication daemon will take
care of all crypto related stuff in their communication.
So the authentication daemon will open the port for the authenticated
supplicant. See the cover letter.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4F4C6752
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiB1KsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiB1KsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:48:23 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBD7117D;
        Mon, 28 Feb 2022 02:47:44 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z16so10806067pfh.3;
        Mon, 28 Feb 2022 02:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dmv2wxlTh57NFmjOyo6WM3d2dcwIoJ6zIPvnRBUGp4M=;
        b=U5BsIH37v6iIZb68WkEqkFN38nlgyEfhAuwS3ds3q8JucqnUczKGRqVfo6pCP8ij8Y
         OAsHlGBb9GCd8bzEkjfGhHrAScexB02Rp/b3aivFudpFOBNxaur5L16KpKGJsOssAggE
         /W7EW/rWQBFTpn7bgaU0mcfvSn2yjbSlIIUSx3AdCmgWgKZ7t4267ZRoR+9D6Bf+uUWc
         6nHK1rdhSROMYqOUee7ImFVjlvhFkGyZPYVsnLHZPn3F4YEcncYWQiMDrHZ1+FCu1+6R
         85ckuIiCa4mcQrTJnx5V9cIWPy5XXkOdFd0UVhk7T6o0uiOTt9lXKHvn55+EUbafVZvE
         0ZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dmv2wxlTh57NFmjOyo6WM3d2dcwIoJ6zIPvnRBUGp4M=;
        b=l6Z4IIgoejPcQ3mu8Nt5afwakXlQfNjjV5q+3TY9ADgvbyw/mtxR/bjPtqyggxIYqJ
         NPo3mzCF/NCOlPCOdFohEtitSQepxAz67iOTPnuIDwmk1Ug3t/v4Lt+rsxvjzYsMQv48
         LkIouGxoQgpBWAevfTjrJwgPYcT+g233eiGc5ELNt2orx7FntigHWnZ5wciBWFw44wiQ
         MeRdPCpjOjzqyM5qDISzFbtq2q50ByGV7/cfblP0lgL3zRSwYffnhOWQC2rlUUqKkHza
         ZHToHxzReuP57oJBbaLe9V8kNiKa7y9BtpjZ0soqvhp775G3ZzkGCVr/txFKyp9NFJAV
         ZcoQ==
X-Gm-Message-State: AOAM532gmv9HNWcrCzJcJ711WQ3eZ3U6kjwiimlVQ6QYiazQsJkeO0GL
        dESePnAzJmW1O8TOJ65zrwI=
X-Google-Smtp-Source: ABdhPJzcudyeDv250wamHY6BmPBvsgMjr2JcoJJTkLbIxAkyl45iOpALVBROybJ3VGkMT7U1y2BAGw==
X-Received: by 2002:aa7:8d54:0:b0:4e0:bd6:cfb9 with SMTP id s20-20020aa78d54000000b004e00bd6cfb9mr21014314pfe.60.1646045264545;
        Mon, 28 Feb 2022 02:47:44 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id s4-20020a056a00194400b004f0fbeb6006sm13028078pfk.88.2022.02.28.02.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 02:47:44 -0800 (PST)
Message-ID: <f0e068ce-49bf-a13d-53ff-d81b4f5a8a65@gmail.com>
Date:   Mon, 28 Feb 2022 18:47:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: usb: delete a redundant dev_kfree_skb() in
 ems_usb_start_xmit()
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220228083639.38183-1-hbh25y@gmail.com>
 <20220228085536.pa5wdq3w4ul5wqn5@pengutronix.de>
 <75c14302-b928-1e09-7cd1-78b8c2695f06@gmail.com>
 <20220228104514.der655r4jkl42e7o@pengutronix.de>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220228104514.der655r4jkl42e7o@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All right. :)

On 2022/2/28 18:45, Marc Kleine-Budde wrote:
> On 28.02.2022 18:44:06, Hangyu Hua wrote:
>> I get it. I'll remake a patch that matches your suggestions.
> 
> Not needed, it's already applied:
>>> Added patch to can/testing.
> 
> Marc
> 

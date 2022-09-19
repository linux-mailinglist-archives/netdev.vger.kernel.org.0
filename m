Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219B05BCCEA
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiISNVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiISNVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205372B191
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663593657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJzkF9UKJ0JT/guvrtnnYyhgP8leVpTS5h5H8IUyZjs=;
        b=gj1H4nqkDcxH1Hyfkxo2LOMjrmTbm7k8Vd67pteVttXR0i1KXORXlABMqK5SgI6b2qg+nq
        NIy7Ag3m5Gjyelk35paKG6mNu7mF0Xuvtn9Zxiw6LJXqum50eS++L/EVFtuCuQsPMNEnvj
        tyon3OrXkXA+HQOjj5x6/0ENEiBO68k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330-3uaM08jpP6edonpiAi1Q1w-1; Mon, 19 Sep 2022 09:20:56 -0400
X-MC-Unique: 3uaM08jpP6edonpiAi1Q1w-1
Received: by mail-ed1-f72.google.com with SMTP id t13-20020a056402524d00b00452c6289448so10834995edd.17
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=pJzkF9UKJ0JT/guvrtnnYyhgP8leVpTS5h5H8IUyZjs=;
        b=uJgvV6vlzNxheLPxADMNbQtGjpmQjRyebtEXWUY9qtgdou/iyeZf45TXQ2PjqBc5XY
         iq5jc3yQCb8cvn2kna5CHmtR2AVST0XxhXEn5BTCtMFYLX6hWkbqO8JSf8m3lAU5PZzQ
         /+WQLVtCf4nHG8mqWdT71fS9/4jiSosd22P3faGcUgyTcpFUzIhPwBRJaqvcDgO5W3B+
         DHyLTqAZ5iuV7xAWSkDeb/cUbMo/v5t2ysM01hKFbmRIP+nX/xkWBDALKk8y6LKcXQ3X
         NimksRR60ZyBAGorUvLqwJdjek4MLNHEHgZLrY+QfpTdKFMcDlCp0HnkleyjEGWRsSl4
         lIcQ==
X-Gm-Message-State: ACrzQf0ADy1F+pHcmycNwWlAghu4EnM6t5G2genrbNyylDCwjgCZN/gx
        9qgnW/eVIKFr56Z9MlLiWaF1LHaSWEs0EEcx6Bag9PK5+y6BrbmckLWSb4+LPW9v5iZM/+3x1a1
        y/6VGuj1E31sxQUjI
X-Received: by 2002:a05:6402:379:b0:450:dc5c:f536 with SMTP id s25-20020a056402037900b00450dc5cf536mr15713189edw.298.1663593655495;
        Mon, 19 Sep 2022 06:20:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM769VhH9Ku3KP+FHMxt8AEvuX3TK5FYd3+2H7UhJ2/p7rIGwNNqM0Ah27nVjjauTwJTTEotvQ==
X-Received: by 2002:a05:6402:379:b0:450:dc5c:f536 with SMTP id s25-20020a056402037900b00450dc5cf536mr15713162edw.298.1663593655264;
        Mon, 19 Sep 2022 06:20:55 -0700 (PDT)
Received: from [10.39.192.161] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id s25-20020aa7cb19000000b004531b137e4bsm9551948edt.67.2022.09.19.06.20.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Sep 2022 06:20:54 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Change the return type for vport_ops.send
 function hook to int
Date:   Mon, 19 Sep 2022 15:20:53 +0200
X-Mailer: MailMate (1.14r5915)
Message-ID: <1A1ECEC1-5CCE-4D86-A116-D291C88743C0@redhat.com>
In-Reply-To: <20220913230739.228313-1-nhuck@google.com>
References: <20220913230739.228313-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Sep 2022, at 1:07, Nathan Huckleberry wrote:

> All usages of the vport_ops struct have the .send field set to
> dev_queue_xmit or internal_dev_recv.  Since most usages are set to
> dev_queue_xmit, the function hook should match the signature of
> dev_queue_xmit.
>
> The only call to vport_ops->send() is in net/openvswitch/vport.c and it
> throws away the return value.
>
> This mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

The changes look good to me.

Acked-by: Eelco Chaudron <echaudro@redhat.com>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6693868F411
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBHRNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBHRNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:13:23 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A585213D52
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:13:22 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s89-20020a17090a2f6200b0023125ebb4b1so654666pjd.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 09:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fbz9cqHAk3AiIWbryyz4GjnUIaUU7IV2ubUnLHstkIM=;
        b=TMw7PZfwa1Uq9Bjj/qE2KsLBBRTYGc68fLWSCPhx9d87Mqxx3Ral/hLViyTOFLusMd
         WvFHiJvcxWAUT6WyZvs7pWS/ujk/zxkWDLp8u5iQ0AmFC/tRF/Rzy6ERsGmP2xrHT1eh
         Rjr0b5AGqn6KT4RqLpJ9i8EhMzFTaXLHs3JAl7ZssD/2F96p1XKkCFvRxX87rE1VKJEi
         xTkgyGaZkoOUJYLwiuVKlJzqAAlrPm9GJRwE6PoOSeoarVLEAZHYV++F8Q9POXuoqChP
         zu6gXyO7uxzge8cFa1AP5NNZp263OR3PsmQ+RH3QBk2jelRBVx/EjiEal06BqJbctfMj
         Vmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fbz9cqHAk3AiIWbryyz4GjnUIaUU7IV2ubUnLHstkIM=;
        b=YYv3YtffCGd5S/7eupCjtKfs6TiuANdMPAR/iY7S32Qp69GRx+KNvk9NXh2ZbE2hk+
         avABjQhvrTVWPNOyEBx977GnL2cCovxfiN2GXCQjP7c0q66d+nHvyaC3mpiTbLy75ICu
         +zJ19KYBD4S3e60U/oFf7VcGJXKiG/HSHr+yumWvKkuXy/5u/smWj9KOOZRK1aiYjN1f
         kKvsHRr0DXgO29JkUyHxKu+x8jOhZIO2D9uQUUael8jbUiovxw4DeESQpkuqhPrSCwtZ
         EBh6iqyBwJbEVoYqWwDeJ18qlEL4fViTqZ7yXa7+u0SVUNMtON65Dpc9JVblKgGrE7tn
         V2tQ==
X-Gm-Message-State: AO0yUKWq6kwXjvTbRspCB7CzETQv9hnLAxVJi5Aw9ZUip9m38fcLPICe
        mfD2l7BZ0IjV97ghGMkKcEo=
X-Google-Smtp-Source: AK7set8p9fWyepT32CoyTzgI45mAc7Xa/qusSXE/wWXVqcIPXibh+S9Gq4mke7JKqpoonZNRIVHIAg==
X-Received: by 2002:a17:90a:9311:b0:22c:afd6:e597 with SMTP id p17-20020a17090a931100b0022cafd6e597mr9192313pjo.17.1675876402020;
        Wed, 08 Feb 2023 09:13:22 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id p22-20020a17090a0e5600b001fde655225fsm4783461pja.2.2023.02.08.09.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:13:21 -0800 (PST)
Message-ID: <93f2dd4aa0455d2ff30da8bbaa08c779dbc0b242.camel@gmail.com>
Subject: Re: [PATCH net] selftests: Fix failing VXLAN VNI filtering test
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com
Date:   Wed, 08 Feb 2023 09:13:20 -0800
In-Reply-To: <20230207141819.256689-1-idosch@nvidia.com>
References: <20230207141819.256689-1-idosch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-07 at 16:18 +0200, Ido Schimmel wrote:
> iproute2 does not recognize the "group6" and "remote6" keywords. Fix by
> using "group" and "remote" instead.
>=20
> Before:
>=20
>  # ./test_vxlan_vnifiltering.sh
>  [...]
>  Tests passed:  25
>  Tests failed:   2
>=20
> After:
>=20
>  # ./test_vxlan_vnifiltering.sh
>  [...]
>  Tests passed:  27
>  Tests failed:   0
>=20
> Fixes: 3edf5f66c12a ("selftests: add new tests for vxlan vnifiltering")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Looks good to me. From what I can tell the group6/remote6 stuff does
apply to the ip link VXLAN stuff but doesn't apply the VNI stuff for
the bridge. I'm suspecting that may be where they picked it up from.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

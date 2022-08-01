Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724AC58664A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiHAIXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 04:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiHAIXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:23:12 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0BB3AB30
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:23:11 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id l3so7861924qkl.3
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 01:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ScZfeL6ZG8VbjZfNJGy4rWVYVwaH1/TMagtzhI88vfg=;
        b=fWudnKELwmE9x4lpiHccJNXGbZ8XQMxaKviKW43zc31xBdhMbegF8ZRYkosQBusTj1
         IjP2Fkz4ajZ3k6W6eYTjF79yta0v24VgyBpyMq26USZwOr5UXE5TgL1UaEK9D2t3Rtu1
         z1tYzmYy6AoZ4ReA+Jas3Qvwi+oJhqRlR1K5u1DgHAJEaaUcZ8hKDFI8FJWE59YqRAb1
         7DW7vgg1aKqmrva831rGuXDPdRe/4/NN5EXsyqKNzuk+S0+nGAohbSwFyW8yeEHJUUOO
         OpM//F+hFaB2AzCjFJv9eQcmF1qBRLZyYvX+oS9mSJcjSUdlihja5myHgm8KhW8ENfMR
         HB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ScZfeL6ZG8VbjZfNJGy4rWVYVwaH1/TMagtzhI88vfg=;
        b=t7X7H8mDGw/5EnwPsoicl71340bmBII02yvIRshpkp9ZFAWtuXtceEKt/XWjYO84kM
         iihEgFW2A/OuHxrBEW90v4fIli2GuEOfhZngIq1G8XDVJ91v9urdXkIKOUx6CZtcRNu8
         ILKWvv9nlIC74Tn1ZmiqCW1zet4XhsszERoc+qRP3s6c0h9YEI9dz88yz1ZY7RD4NqoI
         b7qxnLLpw/rAjDOWT5x0EW8LHkaA7TgOl1jQSGXGlk6M+vG2Go6YUWjSOFqU2MgFQdn7
         W0Jwd05LmewdbsqRxYOEPOXjzEaJqfX7qWHG1G7yT4Dp9LtX5xYyu+aD6d/GvSEo2AHo
         qLJA==
X-Gm-Message-State: AJIora8mLAu9c24V+uFySwVi6ep70+nESwfvZ/pf5UXW+dH/WatFwYKk
        z/RKurx+zw7W538vVPPmEdqIaPWQgvMLSg==
X-Google-Smtp-Source: AGRyM1uup0bZ4WIvPY1iktwvxLsb7zDHelLYvX/X+0IelJz5/ecaj+RL7Jedj4kkjcuEpfNynN2VgQ==
X-Received: by 2002:a05:620a:13e2:b0:6b6:1d4f:fcce with SMTP id h2-20020a05620a13e200b006b61d4ffccemr10586889qkl.219.1659342190860;
        Mon, 01 Aug 2022 01:23:10 -0700 (PDT)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id u17-20020a05620a455100b006b5cb5d2fa0sm8458686qkp.1.2022.08.01.01.23.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 01:23:10 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-31f56c42ab5so101390537b3.10
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 01:23:10 -0700 (PDT)
X-Received: by 2002:a81:5486:0:b0:31c:b029:1d24 with SMTP id
 i128-20020a815486000000b0031cb0291d24mr12152869ywb.56.1659342190207; Mon, 01
 Aug 2022 01:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220729190307.667b4be0@kernel.org> <20220801045736.20674-1-cbulinaru@gmail.com>
 <20220801045736.20674-2-cbulinaru@gmail.com>
In-Reply-To: <20220801045736.20674-2-cbulinaru@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Aug 2022 10:22:33 +0200
X-Gmail-Original-Message-ID: <CA+FuTScdwmfpzoJw_YGcPZ0kYogktKy=BK+axjybxkE43wWnjA@mail.gmail.com>
Message-ID: <CA+FuTScdwmfpzoJw_YGcPZ0kYogktKy=BK+axjybxkE43wWnjA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: add few test cases for tap driver
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 6:57 AM Cezar Bulinaru <cbulinaru@gmail.com> wrote:
>
> Few test cases related to the fix for 924a9bc362a5:
> "net: check if protocol extracted by virtio_net_hdr_set_proto is correct"
>
> Need test for the case when a non-standard packet (GSO without NEEDS_CSUM)
> sent to the tap device causes a BUG check in the tap driver.
>
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

Thanks a lot for adding initial tap tests.

It is still missing .gitignore.

> +FIXTURE_TEARDOWN(tap)
> +{
> +       int ret;
> +
> +       if (self->fd != -1)
> +               close(self->fd);
> +
> +       ret = dev_delete(param_dev_dummy_name);
> +       EXPECT_EQ(ret, 0);
> +
> +       ret = dev_delete(param_dev_tap_name);
> +       EXPECT_EQ(ret, 0);

Should this remove the tap device before removing the dummy device?

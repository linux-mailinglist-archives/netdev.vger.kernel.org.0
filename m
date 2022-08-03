Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD90588AF8
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiHCLPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbiHCLPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:15:48 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C7F65E8
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 04:15:47 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id n2so12502660qkk.8
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 04:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Mb2vtLmJQhO8GOzhddEmRFn/NPsOovzRbLu12kK7xpM=;
        b=C+rJY2G29keBCmTQfkB0qwEcqnnkAqvBL8+dt1yNZXVyX16GbjFFZN4E2Vg5hMVj1d
         mIcZR3vw6yVtM8lg+2FYZn0n5aka5dBOLa4C4EYYTDMAZ70ubag4vOych/GDkt5gdHMK
         wi3+efoTtu8liFR1pfxmOHyDQieWugL6kEyd53LUsalitj0fvKZ+V0BTnG5wE/ttcxO4
         ugiT2YSuUSz4EHDFXBS90I0POS80yN3r/fwhKQRhy+rD80Nm1BjiLeOg0fbr8BHV1gGU
         lFhEVDzrAZOBnAIz5pWytG9c3nnAij+NzMJKmefw0+VNsjc8oF8r8uG+QYkIzSF+MlQm
         1Qtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Mb2vtLmJQhO8GOzhddEmRFn/NPsOovzRbLu12kK7xpM=;
        b=7VJ0di1hl46qGiHAsyXHKhjWvnuMKlKVFy58aylHJU69DQqd6MlAHePtYhh1xZ4ta0
         4CSQIY7i6ITmWTP89UEGbi7UiYx7NsoN3CIUSrXV5xqyVu0hnzrvkVxEV3Go5SbOKYID
         R0sXx/MVa8W2+nF02p6W36/7LdS0wZ2Wby/J3sq9DskjID1mK2sq/prn5gWufbcHIdhc
         rbIUmo27/x0sRCHa8lCynwE1Hgi60rhQIdZoE2mcny3gf4wGb5lt+j6PXjiTA/+SA7fl
         HVnesJ8ntzAZGXl195WtyMip1nFrQfOnvE1ImRsqFHz2wIv4oO0C4A6Oh78CFMgqicwk
         1T8A==
X-Gm-Message-State: AJIora+xEvz+gG0q6NXgQArsWOtE7QOmn8REZHXx2qK4zfkIATCxZY/v
        lEMGN+sHPErCQNblvpJcv+Kc01cAvyWp9w==
X-Google-Smtp-Source: AGRyM1vgR+xB9D+mu/LR4x8gRVsveMQY8SDQiBlacr4RUnSo7z8FKPrIev+7XNBU4j4Rz8/dIsb3Ew==
X-Received: by 2002:a05:620a:15eb:b0:6b6:2f9:577f with SMTP id p11-20020a05620a15eb00b006b602f9577fmr17811134qkm.704.1659525346642;
        Wed, 03 Aug 2022 04:15:46 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id j10-20020a05620a410a00b006a65c58db99sm12006421qko.64.2022.08.03.04.15.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 04:15:46 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 123so27837460ybv.7
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 04:15:46 -0700 (PDT)
X-Received: by 2002:a05:6902:11c9:b0:67a:7633:644e with SMTP id
 n9-20020a05690211c900b0067a7633644emr883183ybu.363.1659525345997; Wed, 03 Aug
 2022 04:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220803062816.3989-1-cbulinaru@gmail.com>
In-Reply-To: <20220803062816.3989-1-cbulinaru@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Aug 2022 07:15:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdfddwkEmW+sECsYzXCGE03bYTdSFfrqJ6kR6WZcP+E4g@mail.gmail.com>
Message-ID: <CA+FuTSdfddwkEmW+sECsYzXCGE03bYTdSFfrqJ6kR6WZcP+E4g@mail.gmail.com>
Subject: Re: [PATCH v5 net] selftests: add few test cases for tap driver
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
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

On Wed, Aug 3, 2022 at 2:28 AM Cezar Bulinaru <cbulinaru@gmail.com> wrote:
>
> Few test cases related to the fix for 924a9bc362a5:
> "net: check if protocol extracted by virtio_net_hdr_set_proto is correct"
>
> Need test for the case when a non-standard packet (GSO without NEEDS_CSUM)
> sent to the tap device causes a BUG check in the tap driver.
>
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

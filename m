Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21B4FF350
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiDMJYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiDMJYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:24:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332E52B3B;
        Wed, 13 Apr 2022 02:21:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o5so1425348pjr.0;
        Wed, 13 Apr 2022 02:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=osjVn3E8DRn3oHJX3CAwc2lHvkhFptRQBgTwOF0g+QA=;
        b=h2Yr5xJi/yEOFUtdeDyINNIBePJBMjzc8xmXWBGdmWwYOil6tgwY5B5Q1yiVSH8Qiu
         E5Q1BzlBQV/vHlMq+gJnYyU3/2Wzos66knmEtkkB9O/8wJqd5AxB2ChCrvRcRPa9dI7L
         xe/yEna/b4Rb6+T6CVUohdRbCIZcedcQ81ujSgK+uQae9vJLfOfm8OCwyvg4L1Q4oLR7
         wqouUnpU33NrKQEUZXtQT1ay1QDM3chbTBZKAOIn+0AHGU6kee5O6R8ujTWaNP5Pfyzw
         PgAExTPZCtc4ERgYlHhnhBkjgfeaM8wkTsbMqNyf3JqUvQBb1SeeKannipGWGkCOBZuL
         XDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=osjVn3E8DRn3oHJX3CAwc2lHvkhFptRQBgTwOF0g+QA=;
        b=3bgikvVsmJULEEY442oKQiJKa74CmIz1QFPa69waDgHzRgxM6VMxepBoYj0OVUM+Nl
         drW20BkZbnADp5MBTxGZjHTvix9B0BnEbFwsGaQy6tv7JPqjyhDZYsl3k/BxUpm9HdzM
         aAkZmO0anwgcTtf+rXYAVvKhZIag99d68MeW/tkAspxDYezZoTQuK0wkyua+8kuqvSfF
         TFn6RM9kibl6ZScR03eq/Y6J5T2ef2CYVLYxzNzpU0Eh/sKhwBvxwQbN7X3BazIku0Sx
         M9p/k2FHPA+VVphOaoqtpSKrGgL2xBEvMePye9N7QepqvXv8l1iQLmnz+sjX5M3xfGiQ
         F8NA==
X-Gm-Message-State: AOAM5308mcNCaM0pZ/9Bs6DM1WbyO+inazG4Q+yYv2lCy+JEPK8si7pU
        WjOdHV290eVfMuilqoZcHdo=
X-Google-Smtp-Source: ABdhPJx3RBpXE8wpQEfkw2UWYDnL9OR7DxToag6FSVvxWxGr60TG15XzZPnG6Wnv2R6FyC+JAI8EGw==
X-Received: by 2002:a17:90b:3507:b0:1cd:34ec:c726 with SMTP id ls7-20020a17090b350700b001cd34ecc726mr6854607pjb.168.1649841704808;
        Wed, 13 Apr 2022 02:21:44 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id 25-20020a631259000000b0039d353e6d75sm5585046pgs.57.2022.04.13.02.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:21:44 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linville@tuxdriver.com,
        netdev@vger.kernel.org, pabeni@redhat.com, pizza@shaftnet.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH v2] cw1200: fix incorrect check to determine if no element is found in list
Date:   Wed, 13 Apr 2022 17:21:39 +0800
Message-Id: <20220413092139.17906-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <164977147986.6629.2901483762629864309.kvalo@kernel.org>
References: <164977147986.6629.2901483762629864309.kvalo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 13:51:21 +0000, Kalle Valo wrote:
> Failed to apply, please rebase on top of latest wireless-next.

I have sent a PATCH v3 rebased on latest wireless-next as you suggested, please check it.
Thank you very much.

--
Xiaomeng Tong

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4ED593473
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 20:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiHOSDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiHOSDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:03:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE3B29804;
        Mon, 15 Aug 2022 11:03:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o3so7004181ple.5;
        Mon, 15 Aug 2022 11:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc;
        bh=7c11secDca8hYRncZr7mvoiP7YoTNElY7uwyGtCilUA=;
        b=Xyd52RwL5moHRgbvzambbDrIaXF6jFM/nZoYd7QyvEPLPhmFkpKxw1G+wPsIHQhFJy
         /q4UYfUytBLF3VER8dVq1lUF5zRuEcGulAilbHYttldWK/wRg2OUUNcmkB+tORv5+DFZ
         XACSLu0W3ojHwt8NCKCRAYIXEPfiToJZlSHNyZR/BmfdSSOGwp55SP5qK1uz5sVex0d1
         a1i9OZm5FYSJ8GtX39PHWdF4zjPCsoPKIs2o1TSpIiSJF3Zgrwn4yXcG9bHn80x/hunE
         y+iAE4hcZYz6JUX7mbHeA8Lj6OrhgoRJwdZgAZTMAd/2Jzk5Bj8Z0+YysSaVpKmn7WAR
         kybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc;
        bh=7c11secDca8hYRncZr7mvoiP7YoTNElY7uwyGtCilUA=;
        b=Kex1jvNLJgS4CPQlIBEv+stT/GrgnV3ru225Q6UgmPnUqbbQotKup2tsyARjV7i2rP
         S7jyoWRE44najrfkUcg8Ad4v1/KTZq5ZzouI1y25SrZ+Nix81Ef2q6NfMuKhuukgTSQW
         FZKqMeJbNWU0eAD+EhFy+EqzQ+Ma9Fz+atPvI/GEt46Ge991LNx5Kt7TOJ5ySAjPGwre
         Tj37SlcOy9rLWQD7Ezb6o5YE9gCiNWLRayRcs8penw0NeJx2gRfe8fnkmf2oSoQLXc6E
         w8iSZNrA/mxx9/Nve4a0wB5bQ7KkOqui0XSKkJGAAmw/DPrmN2aKkRtYFiVBXV4fxgyK
         2LSw==
X-Gm-Message-State: ACgBeo0MnqyY6Uebi09vPn3KfPPSrjMBf/AatSkdna4B++cbB1U2ZCjq
        uPW5lhJITEc/VrJ+guWZ9/w=
X-Google-Smtp-Source: AA6agR52QKi7glztSs9tcqptyUKsggWZ7o2/yP8VLzLNBLFuH/eZqmIqb+I5gpEATOpLi/webZPmhg==
X-Received: by 2002:a17:90b:380f:b0:1f5:55ef:a53a with SMTP id mq15-20020a17090b380f00b001f555efa53amr19240236pjb.14.1660586616202;
        Mon, 15 Aug 2022 11:03:36 -0700 (PDT)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090a0e4800b001f216a9d021sm4755718pja.40.2022.08.15.11.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 11:03:35 -0700 (PDT)
From:   Praveen Chaudhary <pclicoder@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        Zhenggen Xu <zxu@linkedin.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] net: fix potential refcount leak in ndisc_router_discovery()
Date:   Mon, 15 Aug 2022 11:03:24 -0700
Message-Id: <20220815180324.3048-1-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220813124907.3396-1-xiongx18@fudan.edu.cn>
References: <20220813124907.3396-1-xiongx18@fudan.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin

Any reason why you are not adding this code under the
if (rt && (lifetime == 0 || rt->fib6_metric != defrtr_usr_metric))  block ?

i.e. while route deletion.

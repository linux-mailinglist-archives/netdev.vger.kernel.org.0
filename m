Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DCC4B1B44
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346873AbiBKBaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:30:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243303AbiBKBaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:30:02 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBCC270E;
        Thu, 10 Feb 2022 17:30:01 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id b5so7478836qtq.11;
        Thu, 10 Feb 2022 17:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Agn9nWvOVKSlYopW6GlbBUhQXIsnfExAgumi8G4eFTI=;
        b=Oh7sp26UOvTWr/KLgtKlclcfG0wVdc5O8pe/M15xAnnxL6POaBe6FsHyQMsxM0Dk0o
         L/IN4NTDy4HuUOhsjHF822y69aVfYTkts9Yihz7wsLgfNlJS0iauSwkIuwwptqcP6jhv
         36BmzRcofOR+mroskXXiIyrfi1HCXDShmknELWCLmZbYPgOIaLxmum9q/Af4S9O315vP
         CbdGItpX6O/Z9pIEVz2jIC+5h885yVzst4UIoN1nLBz6upFG/GZzEGS5mRIepx0/wv9X
         WzhiCDZDVEe3Bl0CTOlONwRI6nF9hQGxZ16Ee/4L1mk2qJzZVbnPSqNa5QConazyeD/W
         nZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Agn9nWvOVKSlYopW6GlbBUhQXIsnfExAgumi8G4eFTI=;
        b=KrpwmBgGC14XUrTLwj9giCovp+vJKVuk5B1JWL+q1van3jXOrLM0m+BwhW6lTPwuw0
         eDXuUEeGMaEypAOmdEaLt6khLHOioMIAxBboy4onv8SKUfLaP1LyICvp++U5vHCrXrYD
         oGA7JO/hGCduPfizUQd7kZGbPu9Y3UhK9Y8MyrzelTC4sebxjyofYN7V3gdz5b+EwKUf
         EU8u5rE9fLD+2F2fO0DQCs3BBqmj8M4W53kw9AgOK8Ci/G8w97KRny1AXqe3a8VbctNI
         HierJAa84JMiQa/PEaOGeMm3dKX3EU59i3WemcsDLKxpnNdeU9AsAPxOMAcp00Hiul4Y
         t1YQ==
X-Gm-Message-State: AOAM532SuQ9r+BZITrfK3LP2TRwJ4OhwJc4IG9fewzBU0o8iUfM5Y8Cz
        QZIj1PhHXLKMi/jtV3Zy9IE=
X-Google-Smtp-Source: ABdhPJxuv9EpNP7UGy8548s4WvOHS/6phRk0lxUHHM85fP03AA3hW9YbxAAjwgTQxXtCoP2wOWUv6g==
X-Received: by 2002:a05:622a:1049:: with SMTP id f9mr6919482qte.348.1644543000905;
        Thu, 10 Feb 2022 17:30:00 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h5sm11429608qti.95.2022.02.10.17.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 17:30:00 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wcn36xx@lists.infradead.org, zealci@zte.com.cn
Subject: Re: [PATCH V2] wcn36xx: use struct_size over open coded arithmetic
Date:   Fri, 11 Feb 2022 01:29:54 +0000
Message-Id: <20220211012954.1650997-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164449505175.11894.18378600637942439052.kvalo@kernel.org>
References: <164449505175.11894.18378600637942439052.kvalo@kernel.org>
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

change log:

v1: msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
v2: msg_ind = kmalloc(struct_size(msg_ind, msg, len), GFP_ATOMIC);

thanks
Minghao

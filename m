Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDE219403
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgGHXEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgGHXEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:04:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE4C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 16:04:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 132so547778ybg.8
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DGZPPrMYqbRCPGw2ruf3jlWhBumhoZFbDjrq5vO0KsU=;
        b=e81AHB0M7I/PdrDpXEVdir4Vbd2bU0r/si3mFB3blJtI3pLFKCRIMOWgDXge/ue+Pg
         qYMCtAzEHc/TnYqS3FckXRo4TTLF49ulJwEY9oSO5TF0AfMoEr7V5dcwR1y8wS6lPznS
         NEvSB5AsHTo7YUNns1DjLZ/1vsDFhzSl9bmksVrTUsc0qIg7jzO5RCUIXC1oxR19td+i
         38ZWOu8vlpyysjcXSnH6KzmMYAPXHdVWxRLFjLptT9E+Ub2w8o2Prbr6ihRrfsCMarI9
         r2B7LDw3CtCIWWuwHPXj6kj4yXFmECdBYD9JMQe/ApU1+I5kCFFMmbt+c9OsSGoz0Nsx
         LzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DGZPPrMYqbRCPGw2ruf3jlWhBumhoZFbDjrq5vO0KsU=;
        b=IKSK1NbgL8vymNl9owtWISMkjvNhlT9sLrzTB3AwsVLK+6Tl0/DlkWguAb3yr+cHnL
         Pd+wVRZFLZHnIw7Kn6YA7pXbXHXKp61q3FPrLM9O/WVw2P+dfVIissXSZyv8UswrTglu
         K8XTPdUvjEMqpX8E1nDchp1yJ5qxUlLAQTwby0z2FEjuJfcsHCsymiH/PeHTJjNknRj1
         NwmMWAY1aC07Rec1+mZcinCoK3HQSaW72/oSf8VQ6apmggPgxjJQ//Bwe73Pmi3lQ7H4
         A142YnSSSBBOsyOozsFXnDq9OEU8UvnL72zWQTBt4rK3TCV0OKcV2m7yckto+G8dUZ7P
         kVbw==
X-Gm-Message-State: AOAM53026ONhZzL1HUTmAkaCCDFCXG/e6JDa6/CwoVNf7I7HbVgb0ptD
        H9trdWk8VauHTSXe16U6rBBJmJsewrS0kNAHqsY=
X-Google-Smtp-Source: ABdhPJxeWlmFLpDzIvAFDZA1lYGg5W3qe7GiM9Qo2YujZOQwNNRn0hTf56+Fhu5QUdcxssrXYfAmtZiU8AxSXJ8bTDk=
X-Received: by 2002:a05:6902:102e:: with SMTP id x14mr46384111ybt.461.1594249450038;
 Wed, 08 Jul 2020 16:04:10 -0700 (PDT)
Date:   Wed,  8 Jul 2020 16:04:00 -0700
Message-Id: <20200708230402.1644819-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 0/2 net] bitfield.h cleanups
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two patches, one that removes a BUILD_BUG_ON for a case that is not a
compile time bug (exposed by compiler optimization).

The second is a general cleanup in the area.

I decided to leave the BUILD_BUG_ON case first, as I hope it will
simplify being able to backport it to stable, and because I don't think
there's any type promotion+conversion bugs there.

Though it would be nice to use consistent types widths and signedness,
equality against literal zero is not an issue.

Jakub Kicinski (1):
  bitfield.h: don't compile-time validate _val in FIELD_FIT

Nick Desaulniers (1):
  bitfield.h: split up __BF_FIELD_CHECK macro

 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 11 ++++----
 include/linux/bitfield.h                      | 26 +++++++++++++------
 2 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.27.0.383.g050319c2ae-goog


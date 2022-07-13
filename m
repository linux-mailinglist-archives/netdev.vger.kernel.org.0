Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E83573C65
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiGMSOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiGMSOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:14:41 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062FA13D41;
        Wed, 13 Jul 2022 11:14:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a15so10896490pfv.13;
        Wed, 13 Jul 2022 11:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YqwrX18Qizf5Kz8IndFQThJnr5knU/Ti4jRFBAiLCCM=;
        b=NxJFzBNIAy/xMVwD+VGFpQvpYQECXNMgxpHFuKp1I0FTTotLjfQOwZ+kciCHXpJJpU
         v25uyN5o0Upp8QE9LkcbN0zOIsDtrYs1XdLsnvgj1rKu5lVL9BqWhjDuEAhDksTEcyGO
         YBOb4lp5iSU/xr3iSgmt7Jm09fqXq8hv0fhc53JG4H66HbQJ4XiFic8jvuT/xkR23gAi
         M0HM48ZMFK/ApLSMOU335GVKXDAaIOtjxzqOhuJjP2qoGSHy1kyhRvpLUqKnkAzT2uLy
         asBhXC/lfb1NszMu6T5kvuHGW9elMatQBW2Ty+yze0K6T3TwBzOq0SoXHrDo9BnaQY/c
         /ybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YqwrX18Qizf5Kz8IndFQThJnr5knU/Ti4jRFBAiLCCM=;
        b=YFXlfB55nuTm1LaIqZIbINvcc8HJ3nF7jW7ZnWNdo+l4564GRTofyUfdSjFI1aEIRO
         /ltv1NOKkIvrHttwV8DYlWuuaMbAXk058k2WG3HyX3gAm7pC9BIE2IH44cSz7wTsDqwU
         f4gj+b96+pj2CluB5l63iyLj2eUrVL3CBXgUII9v0bkK5/N8rMNC9QmZ/t+RQ5CiLDPO
         UK8xS+A4JgC6dokeRwk8W864JPgvaQjUJ9un9zpmsajc0MJsiMa/v5Y5Uq9sKGwAObpL
         kP9NL4EhfiJOrCfDPr1yyV5RioVohvsh0MD3I7atRNv0KXdEy04r3vtk9+SbTR7xnRi4
         qZqA==
X-Gm-Message-State: AJIora88v6FXULjfda2yaO+o5lrEgbZxyvXRHmlEmvdSzKsByhmDdLqz
        7vBLp2P7oUBZNTl97ciOocw+k8ca7crJvz+O
X-Google-Smtp-Source: AGRyM1v6KQaeH3RMpu+dwySXA//vW78CQWPegk0nSFqeoL3Sv/bb/CRqHI9facbHe4oG/4xOIsiCRA==
X-Received: by 2002:a62:3346:0:b0:52a:c0cb:ae8 with SMTP id z67-20020a623346000000b0052ac0cb0ae8mr4310775pfz.37.1657736079466;
        Wed, 13 Jul 2022 11:14:39 -0700 (PDT)
Received: from fedora.. ([103.159.189.141])
        by smtp.gmail.com with ESMTPSA id p6-20020a625b06000000b0052abc2438f1sm8874960pfb.55.2022.07.13.11.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 11:14:38 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        khalid.masum.92@gmail.com, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Subject: [RFC PATCH 0/1][RESEND] Fix KASAN: slab-out-of-bounds Read in sk_psock_get
Date:   Thu, 14 Jul 2022 00:13:23 +0600
Message-Id: <20220713181324.14228-1-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using size of sk_psock as the size for kcm_psock_cache size no longer
reproduces the issue. There might be a better way to solve this issue
though so I would like to ask for feedback.

The patch was sent to the wrong mailing list so resending it. Please
ignore the previous one.

Reported-and-tested-by: syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1fa91bcd05206ff8cbb5

Khalid Masum (1):
  net: kcm: Use sk_psock size for kcm_psock_cache

 net/kcm/kcmsock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.36.1


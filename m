Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7624E547E36
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiFMDob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiFMDo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5196213D41
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655091865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=weXT1rak57v1x/fmYaFf0QEuHeZHnRVcN5IqDOdhHmg=;
        b=S1Bye4NXV4essalV/ElxoMGpwSSGmJU3JiMV5NIyaMzSLizemYeTONhi7Yo5Tp1kGd5Zm+
        1NdiQMaTFTQVcVnctQG029HOgq4afFf4ysoI6Flx4qYgF3eQKlOgsoBltSIPASeVIqI7Zj
        MUYyFICn7TXGkhVoi61iyre9UZ8x41U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-m1lA6LkMNYamfmJ9It1hZA-1; Sun, 12 Jun 2022 23:44:24 -0400
X-MC-Unique: m1lA6LkMNYamfmJ9It1hZA-1
Received: by mail-qv1-f71.google.com with SMTP id gw7-20020a0562140f0700b0046c1b8431d5so3158008qvb.0
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=weXT1rak57v1x/fmYaFf0QEuHeZHnRVcN5IqDOdhHmg=;
        b=F7fxTnkOySk1zMizUZFr6ZWbHP2jCcd6kU/KM+JBwMrKGsRtu7jJ3c+eA/attO1z7F
         BLwj7ZhKbq+gGexvIWJiET9ajZNNppKI9eBAn9clmU4XwUhYtI50bt0n/GJluq7PK0z2
         86umlXf88LEcZGG1wxTWQN+CccPBRcN7E2X1O67vZGDL6/Pz2WqGmwKeqgVmhI7v8NIQ
         KQfwpSE/Zqt5Q9MMWHEBjeiV7yDRLGbv+lnoXqbfSMJ0Lf97ySQsU+Os2eSecUpKfqAW
         YZYjCMRfvQRZO4E2qCm4x8AyatV41Jr7fREk5shGo9XKxVJrDbLcZiD8/dOxPKYNCcve
         Pe+Q==
X-Gm-Message-State: AOAM531hN2BqGxjXEgVdFQkCaiAwvKoMMibwEXeqP9rd1o8sNMVbz/i1
        YnKB16JPGp6A+KXhPVRCn11epYBkJg7YLXFLwmp8rBXBsy4SohSeAj8cOVJRCWm1dqizGt3PtRu
        g2L0+EA8RkHI8VFYcxoVL2auWeyP+szLl
X-Received: by 2002:ad4:596b:0:b0:46b:cc90:5a87 with SMTP id eq11-20020ad4596b000000b0046bcc905a87mr19496161qvb.59.1655091863479;
        Sun, 12 Jun 2022 20:44:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIi5pOuNEZ8Veo/mZ6QmYCxHGYpHW1nGkcu13a17EX7kUGNU/tdFjsSbkbBEdepNyGjhb0WwcHU2NrKQVvcnY=
X-Received: by 2002:ad4:596b:0:b0:46b:cc90:5a87 with SMTP id
 eq11-20020ad4596b000000b0046bcc905a87mr19496155qvb.59.1655091863284; Sun, 12
 Jun 2022 20:44:23 -0700 (PDT)
MIME-Version: 1.0
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 12 Jun 2022 23:44:12 -0400
Message-ID: <CAK-6q+g1jy-Q911SWTGVV1nw8GAbEAVYSAKqss54+8ehPw9RDA@mail.gmail.com>
Subject: 6lowpan netlink
To:     linux-wpan - ML <linux-wpan@vger.kernel.org>
Cc:     linux-bluetooth@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I want to spread around that I started to work on some overdue
implementation, a netlink 6lowpan configuration interface, because
rtnetlink is not enough... it's for configuring very specific 6lowpan
device settings.

Thanks.

- Alex


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBEA5B12FF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 05:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIHDkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 23:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIHDkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 23:40:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F27375CF9
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 20:40:30 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 78so15436563pgb.13
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 20:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=ZWTPgpJNdpUodl2t6ic8KYj+U3IPfdMy4cQyup+UfGQ=;
        b=B29zrSNi9OIO6pQ2sjXGxknUi2VSgdVs8wTkBhRUpeOmrCYTfrra/a4mVR/rv9/OM3
         YVzMOFsmv1ZViaw/r90xWd+bxXhqQEwqf5XSK+OZegn1akFfaV4SrvOyUbPVHnmd+e37
         zX/dWH9Coo4TCxvIjnWR7dMw1iqzlDv3x5ObeSsxPs/W+Hj0eFOVxSVtzWCp+cRxKWb8
         v8OX7QX8yEycQZuZBiScAp2vUpG0NkqcqahtRFPJi6OgidMKGlOrjfZEI0fvSwYDJXBK
         K09NqKf27xkr5Wr6ffCs9Tzxz5BuYBmOoenN2u6VWrBZkWjC1Zu84emi+pFc/47Jij+3
         xysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZWTPgpJNdpUodl2t6ic8KYj+U3IPfdMy4cQyup+UfGQ=;
        b=taDlfiQEha1bWLWSAMa2wzo3FyZEv/VzrTwG8lV2BBLkzGWHqUcewqNQC2j32zOKJT
         1avkQpt7baE1+jPegIouiCsu0/0ZLhWVRwISwjpyRNbgBO2/CasO4nxdhvjAjWNmob18
         Vdmrm2aTqIczddOKWdyv/V4m96gvjSzb9jxKvy+bbvzhfaO1guTM9+CAXRAj4WdwxmMd
         XaLR16/fDlv45xFdbNatls6FA+yHaHmHTPOQAH7Mvw1uGYv/RGf05oRQpyxwFLGu+JdO
         HmAvWT69SlKudNXIFzrgqes/Xn4ZwWNC96bT3D4aWwJmM96mgZM/EEIwtwMaGLtab4xG
         fXNA==
X-Gm-Message-State: ACgBeo3Fc86nvsgiPHjp4mPWfXXrpu2MwKRl85MTkc65OsxORpOu+H9s
        3vfe7oBsLcSefznHZp+F1SOUB8fw+ms=
X-Google-Smtp-Source: AA6agR5LN3WKgbalYnMyKQVKO7XPk4Cb4KtH0PNCrQNrmljDsbL88fGlOeXY4wBRPzV932rPuH47EA==
X-Received: by 2002:a05:6a00:170c:b0:537:27b4:ebfe with SMTP id h12-20020a056a00170c00b0053727b4ebfemr6938184pfc.19.1662608429447;
        Wed, 07 Sep 2022 20:40:29 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b0017555cef23asm13099603plh.232.2022.09.07.20.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 20:40:29 -0700 (PDT)
Date:   Thu, 8 Sep 2022 11:40:21 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Liu Jian <liujian56@huawei.com>,
        Taehee Yoo <ap420073@gmail.com>, Jiri Benc <jbenc@redhat.com>
Subject: [IGMP Discuss] Should we use one lock for struct ip_mc_list ?
Message-ID: <YxlkJc+QHfDAc95s@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When reviewing commit 23d2b94043ca ("igmp: Add ip_mc_list lock in
ip_check_mc_rcu"). Jiri pointed that struct ip_mc_list is protected by
different lock.

In function ip_check_mc_rcu() and ip_mc_del_src(), the struct ip_mc_list
in in_dev->mc_list is protected by the lock of struct ip_mc_list itself.

But in function igmpv3_send_cr, the ip_mc_list in in_dev->mc_tomb is
protected by in_dev->mc_tomb_lock.

This is no clear doc about what is protected by ip_mc_list->lock.

Is it OK for a single field that be protected by different locks?

Taehee did an update for MLD by using one mc_lock in commit 63ed8de4be81
("mld: add mc_lock for protecting per-interface mld data"). Should we also
do this on IGMP?

Thanks
Hangbin

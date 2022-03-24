Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8C4E67A4
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 18:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352210AbiCXRVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 13:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241772AbiCXRVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 13:21:10 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B98822BD4
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 10:19:38 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id hu11so4222779qvb.7
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=0sQCoAPBYaQ9f/qJth2SRzq4+WMYC/6KuVAJaQVXlys=;
        b=Xia5sK/OtJutPb9lQ4yNI+tTLdavWpqOev7Yq5v+6uK1Uqmm2Km9kltNvoI0qoxJnn
         ZpcbHyILn80roE7hUS3og7NRmlMjAXtSoG7Eth+2He1P2ZhMLICSCYYzxLg8YDrbTKeU
         +/AFyJlY2zGF7XslRASe3pcnbeIEZ3HYP8y5RGIZdn7NM1kuAw4mxPE+SVNf6NVN7C0J
         PRwkFQ245ptDDF2fFpZBi2cqI4HzEJO0vfTQKED17jVzU+wFw8FZcNPNmQFDd8SzlSiU
         yw55Po36nUNkTLVYyl5N5c/D0Mweai85Aw2dl9ej1VLdnR5yJ9GeHC0XAT9oV9PDh3HK
         /SAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=0sQCoAPBYaQ9f/qJth2SRzq4+WMYC/6KuVAJaQVXlys=;
        b=iroZ7qCxvhqwpBXi+H+pNUl8/Eysr6SKEtrOoRh+IZvN+vLL6IBQSoDBz1xolpL4dx
         COqkFz+dPyTXapNbzgWbQiGF/F40SeD8ZpV0vJaJVDns7V5Kg8ozaIwME1aTm2d5H9//
         Czmc0LT2zaxbaj4aWJMbLunEzVZAZsTUo9RnySjlWIJhjysh8blwc2y5U/nNPDmMJlXU
         w275WxDWklIDrDmwlHvQPogxY1rAjQVWxZOFLSNavjmu/WU4jTGmDEmma/4kqg9ezEvr
         cR9foZqUcQEVO75snae4vJzmg8KY8Fd6/v3KWZ7LYmTiGrzUW3yg3bn5NBM09C1mUjhg
         J2hQ==
X-Gm-Message-State: AOAM531Knmb6xTbDjlC7Dz6cSC5IctGyx3ZGYAudzkGzdk6OjZqOwZ8D
        +dZYuVF++E8IJ3Hyavkuanlrau+7pg==
X-Google-Smtp-Source: ABdhPJxWOxh4NAOppoMAdx8rPkOyQtoyuhkPAo37yBtILL2SJdnKEymlAU+zvZcGFVkFCo6UVDsl+A==
X-Received: by 2002:a05:6214:2422:b0:441:6bcd:7726 with SMTP id gy2-20020a056214242200b004416bcd7726mr4276562qvb.76.1648142377050;
        Thu, 24 Mar 2022 10:19:37 -0700 (PDT)
Received: from EXT-6P2T573.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id l18-20020a05622a051200b002e1e5e57e0csm2934135qtx.11.2022.03.24.10.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 10:19:36 -0700 (PDT)
Date:   Thu, 24 Mar 2022 13:19:30 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org, rshearma@vyatta.att-mail.com,
        mmanning@vyatta.att-mail.com, dsahern@gmail.com
Subject: Matching unbound sockets for VRF
Message-ID: <20220324171930.GA21272@EXT-6P2T573.localdomain>
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

Hello,

After upgrading to a kernel version that has commit 3c82a21f4320c ("net:
allow binding socket in a VRF when there's an unbound socket") several
of our applications don't work anymore. We are relying on the previous
behavior, i.e. when packets arrive on an l3mdev enslaved device, the
unbound sockets are matched.

I understand the use case for the commit but given that the previous
behavior has been there for quite some time since the VRF introduction,
should there be a configurable option to get the previous behavior? The
option could be having the default be the behavior achieved by the
commit.

Thanks,

Stephen.

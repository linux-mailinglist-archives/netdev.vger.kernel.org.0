Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E356E8D27
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbjDTIvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbjDTIub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:50:31 -0400
Received: from mail-wm1-x361.google.com (mail-wm1-x361.google.com [IPv6:2a00:1450:4864:20::361])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A65649DD
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:48:59 -0700 (PDT)
Received: by mail-wm1-x361.google.com with SMTP id l31-20020a05600c1d1f00b003f1718d89b2so2721771wms.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1681980535; x=1684572535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yWwc5/4wEw04RjRfJy0rYlUbC4msY88ebG9thDKZdDs=;
        b=PpOTF4A9+c4Ukr2bhbyPtQFdqoYGdOM45P/yJkDNj/9IjDLRF5AsGJiy3mCKvFwSQ6
         fkRoJbQFJVtvp+WQ/Oyzp5C1WjM4WTBmwLjBNWePxfW143Y8TXykkbh+Vk59uMMY/XbJ
         6PYpKoeR8EF4QZxxeGRKMYqbpkmiWnrch/HgiLrAmV7fbQu190BCpmEXoMbPijC38DuS
         hetk567YzurAVC1kQ8Gi3OzByiKi/4GM2dZyhbnMMfqCnMFeKh5qgS427gxpIL/6Mem1
         IFxdivnUbPyTyVm6bSjYOVTBaoXscHLe/zEh2IRTT27AQznukvqjBJaaOn4+8Km5nSBp
         bT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980535; x=1684572535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWwc5/4wEw04RjRfJy0rYlUbC4msY88ebG9thDKZdDs=;
        b=e659BtxaDdasUQo33RcHx+brchc3yK7QKN8sEfc5vs/CLyMU9gSnEYK26c23JZeS9K
         AZn/uUoKQd0Uucp4f0/dzXhHuLEiNkSMykvplpN97tKx97xpurTrpvz+adrQgExPm/Pw
         wIgrQ+PzdMJeHRbSVAjPeOcXeb9AuRdl/z2ewAMtxGQWBp4eETUqj69ORBVGplGOsbTd
         sfvV8uQZcuQlIAW/OT7s9u71HgJ3jsxI6bF4oCG2Ffd7qIFms94ZdonSC1Q0tAsjRKWK
         5zQCn7ncXUuwkoVksxGVwsNiEkypfQPXEyXR1J+zrSRE19vL72TR5mippkgg+rnIwIiO
         Agqw==
X-Gm-Message-State: AAQBX9flppNRRJ976sn4Ow7AmJL+2weFPNDANT6HIAm5z9OlD81KJp93
        NQ/+WC8nl34x+MgkNRcxqUu+sRnPNa9d+HAGqStn2qd4hQ9y+Q==
X-Google-Smtp-Source: AKy350YN651bdWQt0RIV4PrsRFKw9/ZmbnpM3H9kdRI+pUbDTuhOcZ6gzfMAkVfvDM4m3vuTZ/JQcHAH7qxk
X-Received: by 2002:a7b:c3d2:0:b0:3f0:7ddf:d8d8 with SMTP id t18-20020a7bc3d2000000b003f07ddfd8d8mr650087wmj.18.1681980535244;
        Thu, 20 Apr 2023 01:48:55 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id k2-20020a7bc402000000b003f17bbed4dcsm325717wmi.9.2023.04.20.01.48.55;
        Thu, 20 Apr 2023 01:48:55 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 09686601C5;
        Thu, 20 Apr 2023 10:48:55 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1ppPyI-0005bi-UU; Thu, 20 Apr 2023 10:48:54 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH iproute2 v2 0/2] iplink: update doc related to the 'netns' arg
Date:   Thu, 20 Apr 2023 10:48:47 +0200
Message-Id: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:
 - add patch 1/2
 - s/NETNS_FILE/NETNSFILE
 - describe NETNSNAME in the DESCRIPTION section of man pages

 ip/iplink.c           |  4 ++--
 man/man8/ip-link.8.in | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

Regards,
Nicolas


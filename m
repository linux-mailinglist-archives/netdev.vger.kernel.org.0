Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB105A5F61
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiH3J1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiH3J0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:26:51 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB312DAB9B;
        Tue, 30 Aug 2022 02:26:49 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k17so5474777wmr.2;
        Tue, 30 Aug 2022 02:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=axxTKJ7DNo641E2twsxzvKctjEb3pjQ9d136e4ccTvM=;
        b=DHONYFv1wc5Tw4S3juE3P2HD9IDrjg0lt0flsqynuIqGbI6bge+1ruqe36WiSCEDr2
         0H3ptNVwHqD6uKBwm8FPyhT7MkXLPwIOwJ0Hz0jEn/FjzI0/TEypVKuL5LlAub9yNZoy
         SBVYJtK7+/b45IVoHxz25pnFhUFEijNUmTRd7a5qlHlTjRi4IpbQKOdBsNyY9eIWo3VW
         xsHPeqGQ/uFx+C4jBal9XrxWFrEJTUo47WZNpX6S0ujyyrhKKpV6ckFK4fLDpKOGbvW8
         ZGoL/7yEODMBQNajjZzy6SmZOI7g7LC5bEb5A9/jdpiunK6JpXM/LmwZPTYT1vlqS2wI
         sGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=axxTKJ7DNo641E2twsxzvKctjEb3pjQ9d136e4ccTvM=;
        b=Tnkmqnj71TFxXL1Um1+P/9VlPNVz1ZO7w52eUHnOlXnfoIYHHw9LFx9220O4GmAObk
         tlsaIuLojkY6UwBQ+DHl9KqmBAorZZsjCCK0Ay2Z1HKAwLykT2KBpdWG4TPSmil4ip79
         n5r2L9twHGrl78NMOYbXMuKSV9ak0ToHu4aax2u4TAEnEiPXHZPJNUDSm3IELiB5fwCx
         4FD/wscURMJzeGycChocbl4SSxWH5HlTntLzD4mUa6ZXsWgoLBdDMPn9R5QMeTkp96Dh
         RcorK4bNQNlyfUosz1eidXSzpQhgA3WZd559MhSnANMzuof/pwETOyHhjPBqbMaO7HWL
         PJqg==
X-Gm-Message-State: ACgBeo10J3pven6ZGiAFM7iK8Le9QeAIQGFTWJRIDlQoInfMpvR/zsqE
        s6wcHFrplK+X6nM1CJj1qq0=
X-Google-Smtp-Source: AA6agR5IAuFYfHhAO6qh8YCCB9V90SvltG7bBAxDuted7ULWu4ttx+OK4nWASSKVxqVVVU+LLuIjFA==
X-Received: by 2002:a05:600c:1906:b0:3a5:fe9c:4dcf with SMTP id j6-20020a05600c190600b003a5fe9c4dcfmr9227557wmq.118.1661851608031;
        Tue, 30 Aug 2022 02:26:48 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id s10-20020a05600c384a00b003a5f54e3bbbsm11181949wmr.38.2022.08.30.02.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:26:47 -0700 (PDT)
Date:   Tue, 30 Aug 2022 10:26:45 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: build failure of next-20220830 due to 9c5d03d36251 ("genetlink:
 start to validate reserved header bytes")
Message-ID: <Yw3X1cB1j+r8uj7W@debian>
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

Hi All,

The builds of arm pxa_defconfig have failed to build next-20220830 with
the error:

net/ieee802154/nl802154.c:2503:26: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
 2503 |         .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                          NL802154_CMD_SET_CCA_ED_LEVEL

git bisect pointed to 9c5d03d36251 ("genetlink: start to validate reserved header bytes")

I will be happy to test any patch or provide any extra log if needed.


-- 
Regards
Sudip

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED24656657
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 02:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiL0BH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 20:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiL0BHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 20:07:25 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17D6103B
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 17:07:24 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bq39so9968752lfb.0
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 17:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZyK1SrxLkRYrGDbkqRphjRsLT99jzDt8vZ/VHdhqng=;
        b=Y44fawvMSIo5EOzFeOKls8tRAuZlVqmwMwiURxxIipbuBNzHj1OshSyOOTqo2UO7dg
         5rwfQ4GF7EJib4zrmaNyNF5qzKQmXcRsisJskMTPlXoqnV23piyBKLYWSlYfPm14YFib
         HbGmwFtz07WyBnqzv89KAchNIcysMA5uL8LkWipOodD0NrAsKGShVkIAJHrS9QWQg/om
         zfAeiONjS9nXPgae1RVJ+h7GOh7rTN+e2k3Oi8FheBppnYpmnZYtYiWXnTZJvxVoBlJr
         hPjIgQ78Qvr3LGkc8vMtQArqTqYptqMR7B/B6jUhmwd95KkE6+OJbUTEI4h35O7G86Gz
         Cuow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ZyK1SrxLkRYrGDbkqRphjRsLT99jzDt8vZ/VHdhqng=;
        b=CNop5NrsyD+NN2hnlOfUyyMkwro7wE5OwQ50AOK3/L2SKthHgf2Bijelrad9y+4D3f
         FUqRvH4f+mPg+n/7yrgqmDclH3X6DAB9unfhLPTTTkEg6U4Hx1hzwbFXC+saa29Q2J4S
         EyvgBwuYL4GsP8UgerBHEEAD6c+U5jsh6exjrRhFrIKbUxVu5+aWutz7JxNAVjzldqXB
         sLnXCrmiJW+FfOc84wBPlaMtq3wgEHJfeQUfR1m2cFd7taaQwZkqETa7FwcxxiRPkE3f
         sITZ0y931chX9cv7IG/A1qNT9D5TakPmdtRDXgW50Rjd8X3VfktX+BoTIzghvbSBnSZT
         2e2Q==
X-Gm-Message-State: AFqh2kptNPweEsuqDbAmLIgnZ8e0lkxc6cFerkNprzNQkgEoonCecepJ
        rYATuoZ/87K+9FXwqA8IQqVYHA==
X-Google-Smtp-Source: AMrXdXtq07u/6RrGQ4E77zu43ahxGGROIqSrH3W6bTENtmGbL8D5lUGCkL5H5+Au3qsUVYLyoTegkg==
X-Received: by 2002:a05:6512:1383:b0:4b6:ed8b:4f11 with SMTP id p3-20020a056512138300b004b6ed8b4f11mr6621581lfa.53.1672103243039;
        Mon, 26 Dec 2022 17:07:23 -0800 (PST)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id l14-20020a2e99ce000000b00277159d7f2esm1392098ljj.104.2022.12.26.17.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 17:07:22 -0800 (PST)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        chris.packham@alliedtelesis.co.nz, netdev@vger.kernel.org,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [net PATCH 0/2] Orion MDIO DT binding fixes
Date:   Tue, 27 Dec 2022 02:05:21 +0100
Message-Id: <20221227010523.59328-1-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patchset fixes two small bugs in orion-mdio 
binding. I would be thankful for your review.

Best regards,
Michał Grzelak

Michał Grzelak (2):
  dt-bindings: net: marvell,orion-mdio: Fix error
  dt-bindings: net: marvell,orion-mdio: Fix examples

 .../bindings/net/marvell,orion-mdio.yaml         | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

-- 
2.34.1


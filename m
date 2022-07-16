Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A081577035
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiGPRAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiGPRAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:00:14 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71B91F62E
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 10:00:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id z23so14046484eju.8
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 10:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlL1rfSKI0VufnuFia5XzM700DvI42sQqODIGzcOV3g=;
        b=Ke9bp0sUSuPEIDm0LtBj8Yoo6Pr1BExYCtWeEgwK15DD2jj1LrH8Ex65+G+6Mc7TWo
         9LI2TAdrTxAHt6cw4cHGHEZo0BUT5YLhxN49rWZMQ2UpbNHeT60Bio4egn4me/uGRZwg
         L1hH3WDXE3SDr0lknjXKyu835PNThnwnt4y5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlL1rfSKI0VufnuFia5XzM700DvI42sQqODIGzcOV3g=;
        b=MwxVTheZmLXUxeh+QZecVdw/wydlc4phT6f+DVexWsubls+uG0jbB4cW23XSx3Gx+Z
         9JOEHHGFnjFCGYuR6MrpehDnkGhcxv/eoAGMirt/ogF8eVIKSJryCQacO3UmuAQHVAsa
         xs7P8SN3uO4cHR4vCygMLvFt6bvi5KLqmh7j4/vTsM7eUJfNHedEe6wDxkVWmaj3d8H8
         Aj6eX4UD8zwF3MClncgj/6UWkqhYDRlGcr7nQzDgd0MwOannijAmNcP7sHPRswcli48t
         u5Wy5c45RbhnZlrfXJUY+o3yM0w/b8yJYooxZ8NSmUQRiYPKGi2VAb7dx8M8aKdI8UFU
         qneg==
X-Gm-Message-State: AJIora8uhEwu8e//C9KaE9RrO3+oaR4aRRTdtq4yH2nvWMQBfmq1FlDV
        2agmZapLQKT/0IRW4x6wo9/J6A==
X-Google-Smtp-Source: AGRyM1tWWYfkDfPVknIhjjXLp2cJ4Nj+CO7JP3LppjfbZbI5+vIgQieND7kAKWcWrYM3jHPRAWEUbQ==
X-Received: by 2002:a17:907:c27:b0:72b:8118:b899 with SMTP id ga39-20020a1709070c2700b0072b8118b899mr19143718ejc.739.1657990812172;
        Sat, 16 Jul 2022 10:00:12 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-182-13-224.pool80182.interbusiness.it. [80.182.13.224])
        by smtp.gmail.com with ESMTPSA id g3-20020a170906538300b0072b14836087sm3363135ejo.103.2022.07.16.10.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:00:11 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 0/5] can: slcan: extend supported features (step 2)
Date:   Sat, 16 Jul 2022 19:00:02 +0200
Message-Id: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this series I try to finish the task, started with the series [1],
of completely removing the dependency of the slcan driver from the
userspace slcand/slcan_attach applications.

The series, however, still lacks a patch for sending the bitrate setting
command to the adapter:

slcan_attach -b <btr> <dev>

Without at least this patch the task cannot be considered truly completed.

The idea I got is that this can only happen through the ethtool API.
Among the various operations made available by this interface I would
have used the set_regs (but only the get_regs has been developed), or,
the set_eeprom, even if the setting would not be stored in an eeprom.
IMHO it would take a set_regs operation with a `struct ethtool_wregs'
parameter similar to `struct ethtool_eeprom' without the magic field:

struct ethtool_wregs {
	__u32	cmd;
	__u32	offset;
	__u32	len;
	__u8	data[0];
};

But I am not the expert and if there was an alternative solution already
usable, it would be welcome.

The series also contains patches that remove the legacy stuff (slcan_devs,
SLCAN_MAGIC, ...) and do some module cleanup.

The series has been created on top of the patches:

can: slcan: convert comments to network style comments
can: slcan: slcan_init() convert printk(LEVEL ...) to pr_level()
can: slcan: fix whitespace issues
can: slcan: convert comparison to NULL into !val
can: slcan: clean up if/else
can: slcan: use scnprintf() as a hardening measure
can: slcan: do not report txerr and rxerr during bus-off
can: slcan: do not sleep with a spin lock held

applied to linux-next.

[1] https://lore.kernel.org/all/20220628163137.413025-1-dario.binacchi@amarulasolutions.com/


Dario Binacchi (5):
  can: slcan: remove useless header inclusions
  can: slcan: remove legacy infrastructure
  can: slcan: change every `slc' occurrence in `slcan'
  can: slcan: use the generic can_change_mtu()
  can: slcan: send the listen-only command to the adapter

 drivers/net/can/slcan/slcan-core.c | 465 +++++++++--------------------
 1 file changed, 134 insertions(+), 331 deletions(-)

-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D872A629154
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiKOFDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiKOFDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:03:05 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171E72666;
        Mon, 14 Nov 2022 21:03:04 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z3so9875512iof.3;
        Mon, 14 Nov 2022 21:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njB+FnoSdOLeQ9EyChO1haSbpwpNqat14jd6hJtDJXU=;
        b=RV9Sg2Ncx5BD9igyPfIqhcmGmAYsqL+RnGMH8Y+0zpn4r5xX/pq28t72AUM7pSUk9u
         RhignLonjhR2XEhwWcCy4mvb9PevndzK5H+fWUnCkUPBqQ9mtrqiC6kAelW8uIXI9hRf
         BuHNNgNx34FP7wwapCpuF8MwP4lC0dnK8Xd5Y50zhVye6g7M1Sv2oWBpoJMUQChy/PtE
         l8gpbaBbOztx02QaAsNzmiI50Awtvcy/DRws91Ew2H6q/r2SpQl2RHT9aiODDCz0HmnP
         g6gtuHfKCk3/bbQ7J94ZZt791d/XsPPGYehOxUgxLdF7N/qTU3L6/NB3pYYCtAI979Ky
         x7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njB+FnoSdOLeQ9EyChO1haSbpwpNqat14jd6hJtDJXU=;
        b=feqEPd8AWbsdrPAearOVnhh56yfve+D4MDXxSONoGx5NBVxxBQ2hgKvT3onFo9E2bD
         Fxo9KuHQjS5yVrfCEIiV+xCW89+j5wPLvZwS/l5ob9UGJNFhmltrbCKGi39MbO82eoxq
         s/zmfGzlw5NhZu+j9BY81Zz1HlzgLvA+3WK+fnBhPfKZp1Vv8fqb4gnCfp12JExET17+
         ufR5g3aSywzIsrPO7EKBEHRQHT+9EFe8gYhl3tyN26T2mgPuSTxTuYh8VeRfAmIX+RG2
         k+917WGt9fXQ/Ek3MCZKJf9YK7rAvpIHwjAgGO+R61L5+W+JPd6VTwbMG+pOsWCLZENn
         3FIQ==
X-Gm-Message-State: ANoB5pkcevS21j1VZ3eFXsu7YiOMa/ZKEiV/1FYlpZb3tFwVN8sCnZSd
        cKw4hTZLb56VpJiCjwxSnzo=
X-Google-Smtp-Source: AA0mqf5qzeyb3mnolZkAoyCtET79ngSvZfhWvSwvRRtaU/I9QfDQvZt6rY+cDYn2Cb27bPm64VwB4w==
X-Received: by 2002:a5e:9815:0:b0:6a0:f3aa:fab9 with SMTP id s21-20020a5e9815000000b006a0f3aafab9mr6784624ioj.122.1668488583341;
        Mon, 14 Nov 2022 21:03:03 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id k18-20020a92c9d2000000b00302632f0d20sm1752096ilq.67.2022.11.14.21.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 21:03:02 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
To:     luiz.dentz@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, iam@sung-woo.kim,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: L2CAP: Spec violation
Date:   Tue, 15 Nov 2022 00:02:57 -0500
Message-Id: <20221115050257.3818178-1-git@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CABBYNZJ-BjuUcriLpNzs95SDqXP+_6-LJZ-t_00Q6ppy8qYg2Q@mail.gmail.com>
References: <CABBYNZJ-BjuUcriLpNzs95SDqXP+_6-LJZ-t_00Q6ppy8qYg2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure,

btmon trace:
(...)

> ACL Data RX: Handle 200 flags 0x00 dlen 1033                                                                                                                                                                          #32 [hci0] 17.083174
        invalid packet size (12 != 1033)
        08 00 01 00 02 01 04 00 01 10 ff ff              ............
@ MGMT Event: Device Connected (0x000b) plen 13                                                                                                                                                                    {0x0002} [hci0] 17.104462
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
@ MGMT Event: Device Connected (0x000b) plen 13                                                                                                                                                                    {0x0001} [hci0] 17.104462
        BR/EDR Address: 10:AA:AA:AA:AA:AA (OUI 10-AA-AA)
        Flags: 0x00000000
        Data length: 0
< ACL Data TX: Handle 200 flags 0x02 dlen 16                                                                                                                                                                            #33 [hci0] 17.149691
      L2CAP: Connection Response (0x03) ident 1 len 8
        Destination CID: 64
        Source CID: 65535
        Result: Connection pending (0x0001)
        Status: No further information available (0x0000)
< ACL Data TX: Handle 200 flags 0x02 dlen 10                                                                                                                                                                            #34 [hci0] 17.154828
      L2CAP: Information Request (0x0a) ident 2 len 2
        Type: Extended features supported (0x0002)
> ACL Data RX: Handle 200 flags 0x00 dlen 2061                                                                                                                                                                          #35 [hci0] 17.145762
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 01 02 00 00  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 2061                                                                                                                                                                          #36 [hci0] 17.146654
        invalid packet size (16 != 2061)
        0c 00 01 00 03 01 08 00 00 00 00 00 00 00 00 00  ................
> ACL Data RX: Handle 200 flags 0x00 dlen 2061                                                                                                                                                                          #37 [hci0] 17.147190
        invalid packet size (16 != 2061)
        0c 00 01 00 04 01 08 00 40 00 00 00 05 00 00 00  ........@.......
> ACL Data RX: Handle 200 flags 0x00 dlen 1804                                                                                                                                                                          #38 [hci0] 17.148090
        invalid packet size (15 != 1804)
        0b 00 01 00 04 01 07 00 40 00 00 00 05 00 00     ........@......
> ACL Data RX: Handle 200 flags 0x00 dlen 1547                                                                                                                                                                          #39 [hci0] 17.148708
        invalid packet size (14 != 1547)

(...)

The last ACL data packet invokes:
l2cap_bredr_sig_cmd
l2cap_config_rsp
l2cap_send_disconn_req
l2cap_state_change_and_error
Bluetooth: chan 00000000205763be BT_CONFIG -> BT_DISCONN

This is the code and whole log:
https://gist.github.com/swkim101/82bc694f9427f008c14e91307b3355b6

Thanks.

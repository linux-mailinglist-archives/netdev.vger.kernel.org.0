Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AB463AB78
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiK1OoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiK1Onb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:43:31 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1C52316D;
        Mon, 28 Nov 2022 06:43:30 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id h33so5134114pgm.9;
        Mon, 28 Nov 2022 06:43:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTmGeSSogjZ2KUpKVsQh7cCY7PmDcXBzkpDBcjxzQvc=;
        b=fMLkULRoc41E7XJ94u1P3G95qwojJ/rdtE1us8ynT1hglmv+nhsJnqVpFxSdfCt2/Q
         nHUKZS0y5uk05L3DCYEvEuy1M6UrwSF5MW+TzyoqQ8ur4DjM0lEVjvWIf+CYTkuv3Rhr
         r9CruhZrKl+SchqZIp9Eq4etKAn77O53LDXJwwO0+WkO7j1ZgG7DAmFjCQiTf00TbcKn
         naTHUm6tF9CWW9+LYH84hgPG5eKsMcKfgDj/26LFQP860f/E6q5fPNdmRoheE/TpCun6
         mAWG2mhhJVvsrVAGhV87Br1epY4h/bKNZjbn2g3tPuU96iIAxN1NrVSfMeK6iP0Mes6G
         lQ/Q==
X-Gm-Message-State: ANoB5pm4GZCK2GsY9RuFYTAGHg6J7xMc9vQv2Q/O31AFd0a8gcfzjHXP
        8csL7KfsMXCHJf+NHSgkMBFVdUnt5066kXlvfMNWeOtd5vQ=
X-Google-Smtp-Source: AA0mqf5mliUR5UT14w6tcyRTWocKFd6BY4WzfZwqP88NWJJArwrYWJW2ikfdCn+mrQqhkAqYbYU16HRuLw9ucZmUdAI=
X-Received: by 2002:a63:1803:0:b0:477:6e5d:4e25 with SMTP id
 y3-20020a631803000000b004776e5d4e25mr33564167pgl.70.1669646610095; Mon, 28
 Nov 2022 06:43:30 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4S73jX07uFAwVQv@lunn.ch>
In-Reply-To: <Y4S73jX07uFAwVQv@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 28 Nov 2022 23:43:19 +0900
Message-ID: <CAMZ6RqKYyLCCxQKSnOxku2u9604Uxmxw3xG9d031-2=9iC_8tw@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 28 Nov. 2022 at 22:49, Andrew Lunn <andrew@lunn.ch> wrote:
> > devlink does not yet have a name suited for the bootloader and so this
> > last piece of information is exposed to the userland for through a
> > custom name: "bl".
>
> Jiri, what do you think about 'bl'? Is it too short, not well known
> enough? It could easily be 'bootloader'.

For the record, I name it "bl" by analogy with the firmware which is
named "fw". My personal preference would have been to name the fields
without any abbreviations: "firmware", "bootloader" and
"hardware.revision" (for reference ethtool -i uses
"firmware-version"). But I tried to put my personal taste aside and
try to fit with the devlink trends to abbreviate things. Thus the name
"bl".


Yours sincerely,
Vincent Mailhol

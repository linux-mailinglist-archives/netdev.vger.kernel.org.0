Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9070E671FA6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjAROdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjAROdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:33:16 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E21A189
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:21:40 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id b81so16456971vkf.1
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cb7/vy5IKXH5/vGfhVdmD/qbI5yvTfHIoJma5Ilxhqc=;
        b=o3gHdhs4Ff3TPnQzd6fQiYudAFJAFruJM15PipU2SHi2JjUaWQMb5QePfYl8h1KIc1
         Gad63L/2jHleTUGu2D+ot2L5JNKvCOnoMR0Xlf9ap85HwnTwWtZYpSaL4ls8oRUx45lf
         nZ38O6eFQOO+SCqgtaDGk4ctuOBsVHGwlqSuKLdqaRahsDXwFWxmMvRhx6BaihrgMCzo
         wbNVPD5ilaklEpTT+oxbVeOcNWRnQFrErUdbv/xMRbqaH9zDJ1AI6MV3Ehe/KfWTrDF4
         FISBWzpwPZgxOJ7PEU6XmBuCGHbp3Lzg0Ae5MhY4AzTK97bhVtojFowsewKD6q7qnVYC
         MxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cb7/vy5IKXH5/vGfhVdmD/qbI5yvTfHIoJma5Ilxhqc=;
        b=CFLwQOktwDYjnCgsUrv45m92UhRFiZ3Vuw58/782dsTJOO898JUQYltLNJJ1u2/j1/
         D3/xXa2gVQJZEjcNqUryfqTGuXSKKzgO61k5/u7AeF405sYMHVqefJX4r3mqr6SqRzcd
         EGZuSq9nGhTTcuQ/YB3B6pcphpubJXPKjit3cQdGeLSdAT+4jHjIbz0Z4tBRj1tOuizh
         FBjPsMYIm16CSWEuE1pFR9wcWy3t27nUev8Qan5CZycaOm9lezTqZ3EQtRZ7HRE3Lfpb
         DkbO3f92ExPCxgTpt+rk62iiaf2Q/IgYUk1Kpm3v2OyDCVHZjy67r6WQJ7x5+UizIrzP
         4YFw==
X-Gm-Message-State: AFqh2kpIqpiUbuPTxenF9Meeq9pAU8zBJmi4sUIDtJ781qt2TZywyRUo
        lYCEVEUkJbCDoFzN3zur9XfyqMdoPoEnQdZCjFpZwQGS
X-Google-Smtp-Source: AMrXdXuLYjOqyN/0yDLzsVJVRtR5sOrqzG9sONpRJyczPVcl8MyGQP1ht/0e6ZcajjRBKgpw00cbjdimQyhuzjhGv28=
X-Received: by 2002:a1f:91d4:0:b0:3db:104:6d13 with SMTP id
 t203-20020a1f91d4000000b003db01046d13mr966226vkd.25.1674051698660; Wed, 18
 Jan 2023 06:21:38 -0800 (PST)
MIME-Version: 1.0
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 18 Jan 2023 15:21:26 +0100
Message-ID: <CAA85sZtrSWcZkFf=0P2iQptre0j2c=OCXRHU8Tiqm_Lpb-ttNQ@mail.gmail.com>
Subject: Expected performance w/ bonding
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     andy@greyhouse.net, vfalico@gmail.com, j.vosburgh@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was doing some tests with some of the bigger AMD machines, both
using PCIE-4 Mellanox connectx-5 nics

They have 2x100gbit links to the same switches (running in VLT - ie as
"one"), but iperf3 seems to hit a limit at 27gbit max...
(with 10 threads in parallel) but generally somewhere at 25gbit - so
my question is if there is a limit at ~25gbit for bonding
using 802.3ad and layer2+3 hashing.

It's a little bit difficult to do proper measurements since most
systems are in production - but i'm kinda running out of clues =)

If anyone has any ideas, it would be very interesting to see if they would help.

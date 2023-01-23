Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145D6678158
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjAWQ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjAWQ1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:27:37 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A40DEFA7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:27:36 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ss4so31875430ejb.11
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7/Fg9OBLLcUfHIvx8bfRqsMpoNqUVWT55gvxJlrEUWo=;
        b=Nyj3oN95/oMFZIBnvXC054yxw6PJxdsIekG8VBBE2PLPm5i4a62r4VdgsbimvRfTzh
         PfPV3PdQicEPP0EkAHJLBXTy01b7o/BS7RmKnmgvXsela8tx4ahOCiYbkElFmZ4/K0dH
         7OZmPlbTgv0IEZ+5HHIbUeKhxZlkZiBwJMiDX1jTdAigPPriCBl1HaLsXbrBg+mGyaP9
         eVkyWHqaO3ciZc5xQzP6WjWDOuOUJWflGRJ8mYhoWn0T2PxKYtgxs9IXEUAJR1UY/uQt
         AXihX8X1+seryl4ckBW2BLMtc4rxp6Ta1Ux5JkFqE+eAN/r8g8AZwTCadra2gJIkL35F
         xl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/Fg9OBLLcUfHIvx8bfRqsMpoNqUVWT55gvxJlrEUWo=;
        b=w8AmRtyfkc5JjYZNL+Q7nqi9apDl0iGExFtjQ9y5Dl5tJm3VmBTBet7UdMgQW/bfoa
         GTE3i2z37hmcvZgm4buCUA/YJm6xUqStY6Y1cw2IllMzTbI456VJpG01aaU7x8KL9dm9
         6ypbTb7x9Ki5/2gFo3/mk5aDwxC4As/u9AFErFxMIbvzorO69qPnUWtpl78G8hOuXZ9z
         5aIlDax3z95Dx2/QxYvniuyeRZC+deG+go8mXXmWjPpws87pDzbsrFANnZbo75+B2Gul
         HYhja1n7vPVczGPk8RMtCVyjsB7FgHZozX1db5NT7ENKBZ2FU1BxiVifWQYJo9rqOIR5
         /OXQ==
X-Gm-Message-State: AFqh2krGEEhEol8qFXDMhVXQejaTKGML1s6UqLxtlo0xZiuX5BHE1npD
        jJr7QMMGdbkiY37l8bq8DZbo6P5HUGAUxbpYNVKs1q4o
X-Google-Smtp-Source: AMrXdXvFhUzJqJBjahxPw8mn77k82hvR+mZBJjRBSMWDK1uar4FQ72PA8EgRx2GriDUkoxB2eE22+Izo/AIhEFy2cIk=
X-Received: by 2002:a17:906:3283:b0:84d:4b8e:efc with SMTP id
 3-20020a170906328300b0084d4b8e0efcmr2024651ejw.390.1674491255103; Mon, 23 Jan
 2023 08:27:35 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Gergely_Risk=C3=B3?= <gergely.risko@gmail.com>
Date:   Mon, 23 Jan 2023 17:27:22 +0100
Message-ID: <CAMhZOOyb6XkPcnRgd2V9onQiib4CygkLkps=aPwwgQKJh_ptWg@mail.gmail.com>
Subject: Proposed local docker solution for nipa
To:     netdev@vger.kernel.org
Cc:     gergely.risko@gmail.com
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

Hey all,

While working on my first proxy_ndp patch, I noticed that the checks
on patchworks are very useful (as I managed to get a lot of things
wrong), and for my second patch I wanted to run them locally first.

Then I saw the horror, that is the state of nipa's local capabilities,
with notes like this in the README: " `ingest_mdir.py` has not been
tested in a while so it's probably broken."

On the other hand, the wiki says, that you have to run the checks
locally, and you shouldn't waste machine time (and cause mailing list
spam) by running your checks on patchworks, so the situation is a bit
contradictory and not ideal.

I implemented a docker solution to run nipa locally, you can find my
branch at: https://github.com/nilcons-contrib/nipa/

And the main README file here:
https://github.com/nilcons-contrib/nipa/blame/docker/docker/README.rst

I'm sure, I will get a review from Kuba, but in the mean time, I also
wanted to ask the community to test this.  I'm interested in any
feedback, especially if the README was easy to understand, or if more
instructions are necessary.

Thanks,
Gergely

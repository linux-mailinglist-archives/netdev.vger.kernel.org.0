Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5D5586278
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 04:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiHACSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 22:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbiHACSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 22:18:39 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F04BC8D
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:18:38 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id w72so7375130oiw.6
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ispapp-co.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=jp9QOqgJ3q2tTla6Dvha5sDcDctY/+5V7bjD9W9yoh8=;
        b=OKQQEnnav68IQfIkROCHqjeH7mGseBysUdDCwU0PxOb7ltREM69UZQqyqCUbDsaNG3
         BhBLHdZk7l/NigYB9yHdCvuoLv8fN4Jb+AoImOnbtvn/11OsXyvx8zKwnuw/TGWoploe
         i8fAIMaTyQr3Tl3Z558lUIPxHmPYHqE/8BfbJVbeZHnDp9aoiWX4fdKuu0NHiM1GlH0+
         8vKktilnRcRm/BsIygUxyTjfR6mQS02q9sUW7fVVUGJU06cXcPeZM0nrTvlhwXWDs6kL
         m3RWswbi2oPHqjMlrS+bS9yFAHqXxxRD8Tn/NEIks2eB8UwYEzZFrqRsYMLuHgkv6nJX
         8nCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jp9QOqgJ3q2tTla6Dvha5sDcDctY/+5V7bjD9W9yoh8=;
        b=U9zf5SzPhHhcobk+OysW2uryaXB9V9N2fj6Tkkp0K+Tfb4CWgiqTb6IL7ot11+DAN6
         CLhxZQCJi9BzIkpGLiAdo8TuH6p+Iw5ImHG3Wi4RjpvmL+ot45NA489kVCksRJxH+cVV
         /RipUm0BK+zORmEGis0wLplrosjxOHfbcsNoxvT8oRJPkBDBLx7yluhQisWXreWhHERs
         F9/zDvl88PbAyQPc6TVsVHR78/oWHUPschbhAirWtuf8Op/zV+hKrC3yB//6p9aH+423
         Et9JcdNO0YkeuYLCQ8ph76XOdk88tgYKav0wfKaSg3DVv4qEa8S9pXp35zButUl2LzWJ
         8nZQ==
X-Gm-Message-State: ACgBeo2gbkXYQUnNNQ2UJe4lKHwvU10OxcGUUXWgimHPpn/XCRffLkDU
        Hr1t2EUeUbh2o6lu6Ts+Rdn+vH+G7rVGibtW1osujocel08GHg==
X-Google-Smtp-Source: AA6agR59FdttDXaaJsGOHlgMsxT3CPLph605WRgL8M97ES0KRh5tnaelgI5IHageyqJM0gTKvdd/Jfifg5OQEze9uZ4=
X-Received: by 2002:a05:6808:1496:b0:340:32cc:af56 with SMTP id
 e22-20020a056808149600b0034032ccaf56mr949505oiw.0.1659320317431; Sun, 31 Jul
 2022 19:18:37 -0700 (PDT)
MIME-Version: 1.0
From:   Andrew Hodel <andrew@ispapp.co>
Date:   Mon, 1 Aug 2022 12:18:25 +1000
Message-ID: <CAMZ4K5A-UHtoYj=yNOUJDUSH4AgqEK92u_CdqEF=P7YUWU9q2g@mail.gmail.com>
Subject: Support unicode identifiers (handles)
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support unicode identifiers (handles)

The reason is expected prefix strings to allow tools and libraries to
manage their created rules instead of "tc expecting numeric ranking".

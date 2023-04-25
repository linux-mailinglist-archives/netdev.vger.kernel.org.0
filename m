Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473EB6EE861
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 21:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbjDYTmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 15:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjDYTmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 15:42:17 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DA2658E
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 12:42:16 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-42e371846d9so3963388137.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 12:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682451735; x=1685043735;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZferHKUerucCytQgVnNov06/kD1HvUXwj8PtXjF4MJA=;
        b=jBzf+r/aQz21vCW/NZV1+1iQdoXBeu2dc8lrW/KaUt6g5cW+XWtK1TF01jjQMCvOou
         gOkHOLX01Y93d+3pILqi3wXmVvWxhqxs3slWa+iTRKWfeMZi2/z/y/l1aR+wcguhhSKU
         L/OqCdiU+k/L9zkTjsDy2LHDozVlT01gFRUZkqY7nr99UWDJjqa35P8fCsej0ionoabq
         GK73+gFOEFdnKrMvQauamqV3L0tvuK24AOTTo1qvejGnnsleo2VjJ3FXMWp6lKZMB64M
         GN+OIopu0dix7JZZ6Ml2E540pn5GXOjOQtJFM07c3nkN+oJCQcZxQNpXfoCbzD3XdjJ+
         nRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682451735; x=1685043735;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZferHKUerucCytQgVnNov06/kD1HvUXwj8PtXjF4MJA=;
        b=HewCsEG8pCC5DU341pYSjjrwS3kWNLc8MLi39vSppmj0qdtvfHA4wT2LXWFJO9WMxZ
         zcJilaDGjzCKC2YQYp2P0ig9GJkI+JBw0kprBF2QMEMem/J8IOIcVJMkxRh0Nws+NZax
         gKyQCYKR8MftV1jUJKxEVzBsqp6OHK2uBOnAtXUAIch9PfmyupGqnWlkHCDDzRKIyV+g
         O/3sBpHRFETptwVKczDyVpB8lCxWbiE1l9+kjQO4p9EJcYT6eUyrmbncDjaIZ1hnYCw4
         0pUnsrs+lAk8GXe/GEiHaLtuG5tb2Q/jX2M1xVxFG4HhwuQkxwyfpGGd2jDfzVP3dWlb
         BQeg==
X-Gm-Message-State: AAQBX9c3AusYfnINilv5YfIgBaXKd7WdkPtbbh+P9q+Ecopt/sUpPpR6
        F2w2rhbBO3m/fDjdGmRvAJK6l4fSWlvjCCD8pJc=
X-Google-Smtp-Source: AKy350aocuFPolCu9+zr9dosC4ZSCLbD6bBtbUNLSeqdnckXbOSpderN7U8lj2eX77Vn0r+DcN1jRfD1KZtU2pMKKsk=
X-Received: by 2002:a67:f30c:0:b0:42e:58ed:7970 with SMTP id
 p12-20020a67f30c000000b0042e58ed7970mr8565286vsf.19.1682451735147; Tue, 25
 Apr 2023 12:42:15 -0700 (PDT)
MIME-Version: 1.0
Sender: mrssuzaramalingwan2@gmail.com
Received: by 2002:ab0:7342:0:b0:755:a75e:b64a with HTTP; Tue, 25 Apr 2023
 12:42:14 -0700 (PDT)
From:   =?UTF-8?Q?ELIZABETH_=C3=81LVAREZ_GARC=C3=8DA?= 
        <elizabethalvarez7garcia@gmail.com>
Date:   Tue, 25 Apr 2023 20:42:14 +0100
X-Google-Sender-Auth: lCl4aBQhz9ezb0v59DjeEvJ4y-o
Message-ID: <CAGa6i3jUvfd8j2XMEmXSPJCy=hAwJGmJYBNAo=sDzA2jZOT7Sg@mail.gmail.com>
Subject: Congratulations!!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Congratulations!!!
Your email ID was picked among the Coca-Cola 10 lucky Winners, please
contact the agent for more details and to claim your prize.

Contact person NAME: Mr Write John
Whatsapp / Mobile Number: +1 (518) 299-8332
Email Address: Coke-Agent-john@programmer.net

Thank You
ELIZABETH =C3=81LVAREZ GARC=C3=8DA
Public Relation Officer

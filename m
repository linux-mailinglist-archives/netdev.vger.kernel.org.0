Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E4D4D781E
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 21:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiCMUIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 16:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCMUII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 16:08:08 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F772AE32;
        Sun, 13 Mar 2022 13:07:00 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 25so19148254ljv.10;
        Sun, 13 Mar 2022 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5dkyy0nkqUAlW89Y7+liUDjWjAQJ5MhYKATVcex5n4=;
        b=YZy32EXa+K5Ak2zoZwwQOkrY7HxBb6QIoMA6DYz4IVsyBXBBne/0rCf8IVGJV5hg9v
         Qxtlfmm43tjsaG5Iby0NK7IniRUXpLxGISspIOM2N9W/Wg7m/KCC7LlF+ql+Y9exTLFw
         O7JKv3jCdCnAjrPLHyWSoU2oHDEE9h/wU3gI7yNIDHdNzqnB4/WjM39/MDmCqtIaZ3zH
         BkasncAI1TpwS6OOkHZXpK5Gd5+jzeHuio/Ie4IcInraS0B6WFY4K6YlZ8p5LrO8DHqz
         kAXdyxPdA8MvOgorjx8Ri/Fk35nOlJmlEZDYdEc977kTuAx6t7QYNKwWVcZJlGj6wH+W
         gqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5dkyy0nkqUAlW89Y7+liUDjWjAQJ5MhYKATVcex5n4=;
        b=xDmjqrr9M2kxxYi/aV4EZUGNp84ukKfcZsbG3+7ln2yiuC4Mn0rIAqcoWErgL2UqQN
         nLaahi3QfUN397rIbllAWbvjrPdmiQv8I3kTVAUYgN2kOcnpXVjTuEGOrEcrhSulREw3
         ehcjFhu5kT2wrNmbfaHVgaFuwryUgVyUCgCxfUBjn7/eml/2RAYMmFL2VVmTRsOyrpSS
         dMxuYgHCPGkAqWyHQ8a2UqDCa90WVUwIWPY8b/a3ulSedzsfLBIzXtJauRgx+r4QNlw2
         lCJu/yfc2DLlPNwZNI+L2uTTCuYQjuDWgVNhZSyhkHF7PFJDGth7gzAa65yHpFIgWQuc
         83wg==
X-Gm-Message-State: AOAM532fUvpl4lLOxG0Aslgu5kfoOH0lvsSP7td+Kacx3q6YmKh63lMH
        mvHYnAtv+EeYZNd0iTDor1uEmJEnEKO6rBq5BH2y+WtU6PI=
X-Google-Smtp-Source: ABdhPJwcBIJR05XQGluKSFlxI5ViMKoWTLxiKJpVei7xI4smLmIuWW++Rc4kPbQbuL594ueeLIQse1lMGpO4dzABKh4=
X-Received: by 2002:a2e:1618:0:b0:247:eb53:6d5b with SMTP id
 w24-20020a2e1618000000b00247eb536d5bmr12222414ljd.312.1647202018503; Sun, 13
 Mar 2022 13:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220303182508.288136-1-miquel.raynal@bootlin.com> <20220303182508.288136-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220303182508.288136-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 13 Mar 2022 16:06:47 -0400
Message-ID: <CAB_54W7zOY3+Xe=s8ehvcX3mY2bSL1Q5bhsEz50DKXUL1bCw1w@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 05/11] net: ieee802154: at86rf230: Assume
 invalid TRAC if not recognized
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Mar 3, 2022 at 1:25 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The TRAC register gives the MAC error codes if any. If the TRAC register
> reports a value that is unknown, we should probably assume that it is
> invalid.
>

Can we instead revert 493bc90a9683 ("at86rf230: add debugfs support")
it was introduced because of some testing stuff with ack handling but
now we have an error. We might add a stats handling for such errors in
the 802.15.4 core in future to get it on a per neighbor basis.

- Alex

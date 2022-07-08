Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D968B56B2DA
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiGHGiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiGHGio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:38:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62D51836B;
        Thu,  7 Jul 2022 23:38:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a5so14500310wrx.12;
        Thu, 07 Jul 2022 23:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6MNY7diHJ+MnWxKcDHqJkKosV/mr66iz8oydZliBRmQ=;
        b=Y+HfLILvoGNJKQwKFAtwItKF+nCU+J9436rxhfgzKj8LxGXYwEyhG9L5pC/GGnKcdD
         OakYQ5yA1HWawR+S2zFE2a6CJG4WW0xpCZKA5ZEAV9jE47k/LUyRUKiGiG3uKwijbCKU
         NV4KIyrtkEqVcSyMJch5SBJa58tVqjxP7xToKLhCOPnCSfhpg/F4B2xs7hIpHmVkommW
         Zt5rqJZpPIpwTgHyjxaWFhu27gs5QHkOPa6NnNwBF2l0y4vu0P+y0lmOKc7ZRKyjNWMK
         XqtyfkLnqIfI219BNbG+a7HAZwfByoQoCrQ64uSG9r8XWGu9IW0ObRyJKSPD5Zg8lGq9
         iG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6MNY7diHJ+MnWxKcDHqJkKosV/mr66iz8oydZliBRmQ=;
        b=LvAnNhhRwwmE7+KgAmDNl65kp1hvs4McITf6RqhYKf3fN9OfYRLN2sUoZKWSPsStyc
         eb5WVX/nrQ3uxBfsPNexdU9w7RuV10z0gDQ8v5sshRMrnPHxHy1zOd7bVX9bWkDHR4MC
         slHKXpduiXEnKzfGZtNPNszGUHFbXDvloTNQHc77yvGxlErt7KxD642iiIyVqbntvr7p
         ZdLr8vgtJPGXoB/wR6zZA+4n51GdlZ6fuPxzGoPMBDh+4VJASLG8SqkeUT6EXphZRgid
         nr7w3PvWdB1SPO8AUD/txfYT4oqOvsmVh3NiK1B+GZ2H9fO/yTXjThJJZF+dn15lsFoK
         Fs/A==
X-Gm-Message-State: AJIora8imOKBU0rxa4q0UO/gWMlwmO0VJOJHQCQF5Y83sA5yFb68rIIy
        92zxWaWSHaJ1NMKNRdfmBXDTu2+DncIeUJR4aUU=
X-Google-Smtp-Source: AGRyM1v1scyfjp6+EGm8qT5gCJ8TPVBCMuX9yYoD0E0kmstb/lo3xGd1jIUmhQVuWt/vLqRSvbuExBzmMqpCiMTuhMM=
X-Received: by 2002:adf:dc0d:0:b0:21d:ea5:710f with SMTP id
 t13-20020adfdc0d000000b0021d0ea5710fmr1684518wri.48.1657262322403; Thu, 07
 Jul 2022 23:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org> <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org> <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org> <86v8tu7za3.fsf@gmail.com>
 <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org> <20220706181316.r5l5rzjysxow2j7l@skbuf>
 <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org> <20220706202130.ehzxnnqnduaq3rmt@skbuf>
 <fe456fb0-4f68-f93e-d4a9-66e3bc56d547@blackwall.org> <37d59561-6ce8-6c5f-5d31-5c37a0a3d231@blackwall.org>
In-Reply-To: <37d59561-6ce8-6c5f-5d31-5c37a0a3d231@blackwall.org>
From:   Hans S <schultz.hans@gmail.com>
Date:   Fri, 8 Jul 2022 08:38:31 +0200
Message-ID: <CAKUejP4P6-5gYg2owdbcNLKwYvsimg6L-Y_izUxfq=Uz=K_JDg@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
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

On Thu, Jul 7, 2022 at 4:08 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 07/07/2022 00:01, Nikolay Aleksandrov wrote:
> > On 06/07/2022 23:21, Vladimir Oltean wrote:
> >> On Wed, Jul 06, 2022 at 10:38:04PM +0300, Nikolay Aleksandrov wrote:
> [snip]
> > I already said it's ok to add hard configurable limits if they're done properly performance-wise.
> > Any distribution can choose to set some default limits after the option exists.
> >
>
> Just fyi, and to avoid duplicate efforts, I already have patches for global and per-port software
> fdb limits that I'll polish and submit soon (depending on time availability, of course). If I find
> more time I might add per-vlan limits as well to the set. They use embedded netlink attributes
> to config and dump, so we can easily extend them later (e.g. different action on limit hit, limit
> statistics etc).
>

Sounds good, I will just limit the number of locked entries in the
driver as they are not controllable from the bridge. :-)

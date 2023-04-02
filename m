Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3686D384E
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjDBO2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBO2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:28:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245A359D2
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:28:20 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h31so16017444pgl.6
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 07:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680445699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGvVGTgaGPh/9dfGRYfED+0NbJ2ZNhTpJbxJJphQp28=;
        b=FKU6g9yo4OgS5DbVz7kaVaku+Fs4Oww4J9sju0HkcHD8s+i3z8h4mfXPdSgpN1SkY2
         dw6bj4onp6y6yJpeWxZ2QcaaRtAU3rs0TRIilP1r3eIYV+ybbhwz/AYL4pHa2fh0DPSv
         hPcWLjUNqFwV4RiG84lMadjJWdHXRHhrZLrKerIHes7xnapye8lRKOZXYQOAf896ZbOj
         VNjDeZFCn+qtQ1xpV8Wil0Jvg5yjNvu+eZaeHzNnUzr1vh3N3wxqsy5GS7CqWmoj1tSS
         bLk1u9Ug+ODqo6wD+sAeYQpJUMWOqPYEqTFZVHZOgf0oWONk61xq39d8+11U55OVD29a
         HduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680445699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGvVGTgaGPh/9dfGRYfED+0NbJ2ZNhTpJbxJJphQp28=;
        b=WMVRky0uXs2ndhUartzGjSTQd8mZySE33l3mw/pIEb1gyTzt2p75OUKj1RPbApsSl0
         gcueFB9AAXzT0vncpYePA7IXU4IsmJ6FaB1q5WBa7mUY+H4jmx5oeEwHI3I5oxJYPvCy
         qQwv6p53smVyvLQcVoIMqFA2Am1AB9e6enPA0R8syTbp5J/r3AnSE7vwcO+7eF/Y3WDQ
         EoyJoWY3UOPGGYkpkoqHm7is5VO4rss4Uhyzp1mOtx5qsP7mVqBqUz5s1xPgtnyhfqFc
         SrW6LAffQlBcrFzHexL5RhO7+G8Mi8flDlIzdSnDNcPVTyIWwB13CimLkmbS8nRe8bkv
         Y74w==
X-Gm-Message-State: AAQBX9e6nfssOOl1QdI7/UJ/k253XW6wSgvFl7rG8vdmk8VOgKqF2fm9
        RqLmAODD6lv6I9+6YXxrTTO3Z6eqjUXavVwVP3s=
X-Google-Smtp-Source: AKy350YRWm1Y3/JY/6EsvXEq8HKLaCvgOp6uczL+stKurN7rVQqDaz02QmOWfbQGpnhjkyk7reh6NbzTf4ccmEOe3xM=
X-Received: by 2002:a63:4d62:0:b0:513:53d7:aedf with SMTP id
 n34-20020a634d62000000b0051353d7aedfmr4294753pgl.3.1680445699511; Sun, 02 Apr
 2023 07:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230331045619.40256-1-glipus@gmail.com> <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331111041.0dc5327c@kernel.org> <20230401191215.tvveoi3lkawgg6g4@skbuf>
 <20230401122450.0fd88313@kernel.org> <20230401201818.bxitvurfirsl6rpg@skbuf>
In-Reply-To: <20230401201818.bxitvurfirsl6rpg@skbuf>
From:   Max Georgiev <glipus@gmail.com>
Date:   Sun, 2 Apr 2023 08:28:08 -0600
Message-ID: <CAP5jrPGtdTxt4UOg+pst2q0bxqwZgknO9V2sP4umh9G4PcPebg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 1, 2023 at 2:18=E2=80=AFPM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> On Sat, Apr 01, 2023 at 12:24:50PM -0700, Jakub Kicinski wrote:
> > It should be relatively easy to plumb both the ifr and the in-kernel
> > config thru all the DSA APIs and have it call the right helper, too,
> > tho? SMOC?
>
> Sorry, this does not compute.
>
> "Plumbing the in-kernel config thru all the DSA APIs" would be the
> netdev notifier that I proposed one year ago. I just need you to say
> "yes, sounds ok, let's see how that looks with last year's feedback
> addressed".

I sent out a second iteration of the ndo_hwtstamp_get/set patch.
I tried to address all the comments except fixing DSA API - I still
don't have a full understanding of what is the plan there.

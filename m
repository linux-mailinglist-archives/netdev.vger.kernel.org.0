Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA358D13C
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbiHIAJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbiHIAI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:08:59 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A022B483;
        Mon,  8 Aug 2022 17:08:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gk3so19453637ejb.8;
        Mon, 08 Aug 2022 17:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ooPUbC+s3/fZoFqwQQ3XHm5MoWraTII+HFvO9mvXWIs=;
        b=QJOBwz7B/8+kTBHwan7ipOs29vVD3r+slDEtVOEzJgU9loS9CDpMz8yZp9QO6XQoYF
         nWseKz5x/p5k9dLHI74QFaUIpaCNMSmeIYVS9cClyH5WQMM/Hh47RzZiB2RtB2a/JtDn
         Igw68CrnMY37+fs6J9Xkd39tOJLMp5N5//94CzsED76zI0c3Q2hbOSYD1pj1cMJfTSoB
         xnt+iRK7GeSmyzK11XkEJojrdsP3yQJAH2j3ahvaAwrpnDg2IaGalS4buznNw0y3deo2
         kBJqiVD7YEbRsJqd68nHoteVzO4eJ1R6CYfxSYZwdZr+9xmD3/LL3yd/5lycHfBv45Go
         okRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooPUbC+s3/fZoFqwQQ3XHm5MoWraTII+HFvO9mvXWIs=;
        b=1eWJw2OYOw5fzTe+mBBeHsqumTEBkg6uz07u8tJ0dhOen8IgUQetY8s9SKigSZmhVx
         v76Xu1nOvLd8yUeuyIFxUHduDfNmbaOA+2o/Z8d1yoVQUREJ8IaPk/qCZP82Sxmp/8ml
         ElHb26iR2NBYWNX5fDTyqLP9Vve0Xlqrzx1xld8AA6BkXdBYU2wHfPfZCr65oJIx2kDX
         xScBp+HmaNhygX2OYmDQyVzKC716/pCNXKmlg77EyK+F7DIZUMKoq7Cx/46oRkGudfRC
         HG0mh/9SxFuI8sWF61+q1feYgLQ6By8EapTeWgx3ZfWH8Gw8E4hQhpgz9wKAOBazcgvI
         FUhQ==
X-Gm-Message-State: ACgBeo1//K5Q9gYzXC/nLy/TClGgI8Bo/8fuwfcgAJEbwRSQfE/NewyS
        udZljolAZ1TFw7InaP/p5pTV86WjGNVmkql9B4fvgpePEmiqIg==
X-Google-Smtp-Source: AA6agR7GU6ZXlZ7/kPtCCKiYfiFRx7LElyf4lQzxJYnIzlu/7qwhquQQqtAqOHWOf61ZCn1izfx+GQcAvfhcm7l9+vQ=
X-Received: by 2002:a17:906:29d:b0:6f0:18d8:7be0 with SMTP id
 29-20020a170906029d00b006f018d87be0mr15021258ejf.561.1660003736789; Mon, 08
 Aug 2022 17:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220805232834.4024091-1-luiz.dentz@gmail.com>
 <20220805174724.12fcb86a@kernel.org> <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
 <20220808143011.7136f07a@kernel.org> <CABBYNZKmuUpmUChz+tixFCOE_pUeaJq0Sbqkvjy54zd9H=GB4A@mail.gmail.com>
 <CABBYNZJXdt_aL2SOH_Eu9PDaLhHksTRJDBPKSDitXKURPqG-7w@mail.gmail.com> <20220808164614.3b4b5a25@kernel.org>
In-Reply-To: <20220808164614.3b4b5a25@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 8 Aug 2022 17:08:45 -0700
Message-ID: <CABBYNZLe1rrvstMTXQ_YQxE9dgEwnemYmi21n6BnOEFaWW_zGA@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-08-05
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Jakub,

On Mon, Aug 8, 2022 at 4:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 8 Aug 2022 14:51:00 -0700 Luiz Augusto von Dentz wrote:
> > Is there a script or something which can be used to verify the Fix
> > tags? Or you can actually tell me what are the hashes that appear not
> > to be on net.
>
> Yes:
>
> https://raw.githubusercontent.com/gregkh/gregkh-linux/master/work/verify_fixes.sh

Perfect, looks like I missed 2 but the script find them out:

Commit: 4896e034bdd1 ("Bluetooth: ISO: Fix memory corruption")
    Fixes tag: Fixes: f764a6c2c1e4: ("Bluetooth: ISO: Add broadcast support")
    Has these problem(s):
        - missing space between the SHA1 and the subject
        - Subject does not match target commit subject
          Just use
            git log -1 --format='Fixes: %h ("%s")'
Commit: 25d6bec1685d ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
regression")
    Fixes tag: Fixes: d0be8347c623: ("Bluetooth: L2CAP: Fix
use-after-free caused by l2cap_chan_put")
    Has these problem(s):
        - missing space between the SHA1 and the subject
        - Subject does not match target commit subject
          Just use
            git log -1 --format='Fixes: %h ("%s")'

I fixed those and it now comes empty which I guess is what we expect.

-- 
Luiz Augusto von Dentz

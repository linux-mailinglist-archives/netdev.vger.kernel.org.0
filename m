Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76A159690C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbiHQFyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiHQFyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:54:22 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3FD5A3CE;
        Tue, 16 Aug 2022 22:54:20 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id l5so2780442iln.8;
        Tue, 16 Aug 2022 22:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kB93RpgeDxqV6eg4zllJtOVqlHJ3q2cTErlIUWDz/FE=;
        b=N/tmOnShu9POigvwSuLapZiYwbwl6omssqsvR7NFux+AuYYDcYkaozdBCWciBlLZ/U
         tlvowz0FREf6GPq4HnULNC+4BbWWcEcSImeGCujx+FT5CXzgUgJ9kzli2BL87YVEtJlC
         1cjOM3k81jeav/jQ5wv2p1hB8gimRmpaao3qe3HjIcGR4fUk8dqIRLWJ5VLvats++xKK
         msQ9FSpXXTWoE/riVLl6RLGoD9eIcG85zDpR9JeFnbCJlMGBL95XrgOAqqkA+VOtCiIi
         REemFtdIcDAtTyIED40b7WoNZbFrrAydkgAmZH8hHJXdVWnh37CzLxISFUDhPLaslJeR
         o+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kB93RpgeDxqV6eg4zllJtOVqlHJ3q2cTErlIUWDz/FE=;
        b=ZV31TIHpxeuhvS6F/aNc7FrdfHgiMo77Pl4H6tZsqclIrvpZk87lMr9An5Ncenb3H0
         U1f8AWqucOQa5x+vUZ83tOO6FLEIvfSnQRXjhqn6Fu+yNPxs4+iVExsPOeaMGUdQVQ4P
         ZdLAoldp947XGSRqBAPy7+ZqVRAOI7K+3XLjfbzrz2UQy9EE0ZjKKL5nlvf8+rH8PevT
         KIIfmnIv0MbvTU9p9j/rOFTqO5VgfWP9q7/cs9+vtCbwlixlzqJrkobHzMQalDXw6Z47
         wtroqsusens7+J/SbrvGNp4tOOOQfrBq7y763qcIx1d3nJQau9Eks0tcowyCmPfKsPAL
         jqTA==
X-Gm-Message-State: ACgBeo2no86RocHVeGE9uBnEsm9t/ifAOnMOJ9gNxrTcjNdogF/JKqyl
        O4y8vHOpN4ul7Ko/lzV4HgsPe3nV7GPvgRERRts=
X-Google-Smtp-Source: AA6agR5KiikMZxXZOBmMGOGT3r7DwFbYeX1hv0Oz+EsO055PaXurIHmvdl5mbwewfz6JnRw7HLBh2hxXa2SKD960Dbk=
X-Received: by 2002:a05:6e02:1c26:b0:2e0:d8eb:22d6 with SMTP id
 m6-20020a056e021c2600b002e0d8eb22d6mr11161317ilh.151.1660715660084; Tue, 16
 Aug 2022 22:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com>
 <CANiq72mQpZ-z1vVeOwdaOB3b=jjQHtPwz3-jaPRV330-yL_FqQ@mail.gmail.com> <CADxym3Y1ZoWrkGW3v4PbVMvbEYnoFgHmFXCD-QpY4Of9hrAxBg@mail.gmail.com>
In-Reply-To: <CADxym3Y1ZoWrkGW3v4PbVMvbEYnoFgHmFXCD-QpY4Of9hrAxBg@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 17 Aug 2022 07:54:09 +0200
Message-ID: <CANiq72nUeePn44wi_0J8vP-LE92Ysek_-nTEXAOQWJ+aEVb-KQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
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

On Wed, Aug 17, 2022 at 4:20 AM Menglong Dong <menglong8.dong@gmail.com> wrote:
>
> Enn...because you pointed out my code's problem, just like what robot do.
> Shouldn't I?

Yeah, but that is just the usual review on a patch; I didn't report
the original bug (that the commit message talks about).

(I appreciate that you wanted to give credit, though :-)

> Okay, I'll wait longer before the next version.
>
> Thanks!

My pleasure!

Cheers,
Miguel

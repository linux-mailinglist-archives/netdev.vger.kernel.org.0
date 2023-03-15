Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462CC6BA77F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCOGIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCOGIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:08:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6323417CCA;
        Tue, 14 Mar 2023 23:08:00 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i9so7259948wrp.3;
        Tue, 14 Mar 2023 23:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678860479;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g96KcJtf+WzEmwRq9oE05eAZon0y01IutKNbNpf9/U8=;
        b=bEyUAaEtYVC+hUOVX7cjlowqCzc/ObN/zloBXA82ml+thlhWzVm7sNQcHWdgvIlcON
         uIhsuCnCbj+qZZlM4x68U4o27Xg4A3BCNrobayZT3jW7s7ElxpWFlRSrNknN1I/kGLSn
         dwB5wNWt41t79lMVVangWqZBOMXBIgWRX9SxXPRR8Bex9UG/lnHjE0go7QCkqP1nmG8N
         6OmbHZCQTZULGGK8duBbINME4H4Uy0tEjkFaJ6wWkhgaMDRWiQOHPf5XwN3tjUmV12gp
         SD5Mzc1VstPAA4XInYj+gzete27aD9/574p/Zwh47f/HiyJxKf/SbeGYpvs0HJNjh6Xp
         jyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678860479;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g96KcJtf+WzEmwRq9oE05eAZon0y01IutKNbNpf9/U8=;
        b=Mjf3OFISkXXa/TBHv5N6r+Cj5SgQ9yMPymlnsY+lB+EbLIFr/BUK8dQ0oWidr/PIX9
         akUKYhezW3H9JYUb8wyWevdt/ulwwd6OGTDoYkLHzl7DOprEOsPyjsJK38g5JoffBdze
         BIJIlIlFoRUV3Lj1GM2C5LA7NIM0OA8ZR3Dfxo31XGkqHRTQ0SPJAmZBTHYjEnveqJH2
         bd7pQP5pnnNismvDJeJjrxK+N7Sd04Orx/2zEPPFhjknkfBMTfED/DFbmnMOnH8woARz
         Nu0uiQi1vFO1Gorpk+pAkmeqreeW22Udfo3m8FLMVcAOcrEvD+3Q47Yqgam0OjrsXxGv
         x/1g==
X-Gm-Message-State: AO0yUKVurpx92V0q1blqQ89qS1cs4nWthS8wEDuYwJHBJsPwJiCUlf2P
        K+5x7HkWopQiY5/d90YDOK0=
X-Google-Smtp-Source: AK7set+fVE+fCZPNEK2WWET8FEbrGK6PQMM/JQuOESSRVq1jmxjBHb0orFoiBb80MRuCPbexS0bSvw==
X-Received: by 2002:adf:f14e:0:b0:2ce:a8e9:bb3a with SMTP id y14-20020adff14e000000b002cea8e9bb3amr994879wro.4.1678860478757;
        Tue, 14 Mar 2023 23:07:58 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:b19c:a42b:d4d:a166? ([2a02:168:6806:0:b19c:a42b:d4d:a166])
        by smtp.gmail.com with ESMTPSA id e6-20020adffc46000000b002c561805a4csm3746427wrs.45.2023.03.14.23.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 23:07:58 -0700 (PDT)
Message-ID: <e3ae62c36cfe49abc5371009ba6c29cddc2f2ebe.camel@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ
 mappings from mdiobus code
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Wed, 15 Mar 2023 07:07:57 +0100
In-Reply-To: <20230314200100.7r2pmj3pb4aew7gp@skbuf>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
         <20230314182659.63686-2-klaus.kudielka@gmail.com>
         <ed91b3db532bfe7131635990acddd82d0a276640.camel@gmail.com>
         <20230314200100.7r2pmj3pb4aew7gp@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-14 at 22:01 +0200, Vladimir Oltean wrote:
>=20
> I'm a bit puzzled as to how you managed to get just this one patch to
> have a different subject-prefix from the others?

A long story, don't laugh at me.

I imported your patch with "git am", but I imported the "mbox" of the
complete message. That was the start of the disaster.

The whole E-mail was in the commit message (also the notes before the
patch), but that was easy to fix.

After git format-patch, checkpatch complained that your "From" E-mail
!=3D "Signed-off-by" E-mail. Obviously git has taken the "From" from the
first E-mail header.

I looked again at your patch, there it was right,=C2=A0and there was also
a different date (again same root cause).

So I took the shortcut: Just copy/pasted the whole patch header into
the generated patch file, without thinking further -> Boom.

(a) Don't use "git am" blindly
(b) Don't take shortcuts in the process


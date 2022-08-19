Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1E859A9B7
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243949AbiHSXxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243799AbiHSXxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:53:23 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9541E63DB;
        Fri, 19 Aug 2022 16:53:21 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id o2so4426963iof.8;
        Fri, 19 Aug 2022 16:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UX9DFt9pgifkj/QY4mu++ikMopOnydaJKN+iCFeyvjI=;
        b=PusEjCLI++Ed6692tp9RT9MfbJaYlC2Tmx94F1gdSvkzEyjBp1TqpNY49wXhZR5hGX
         51ISmjseJ2/wRKt0cCNT9FwBMzCXp7oU3I2zc8Gamy7yV0rIHzDq2eDzvTrAHCan7jdO
         +1stTYv0OkVLa2zaISqIN//vUuNdPquArflukgNsATTk8ELTR8zBvGFLX1L8FaAvMP9o
         6xRN4zGIMumKA/yUMPmU1d2866sHqgLpX8D17E+TGcndHkZPQdK1miIdSLOnfIGU2qe8
         HpdfOOqVWwY8waLHdNGmR6WItyl/KrsMQMFo/yiGvgQwXSTJ/ldDDQLz9KO4LrOb1ZiZ
         TbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UX9DFt9pgifkj/QY4mu++ikMopOnydaJKN+iCFeyvjI=;
        b=VXJYoJS85qJDQZpwZ9Jrv8MGvcg9WWQGpcxrwRX2EYctkrncviCQdY93dHLFxyVWNh
         +GQ8i+xs6/wKLeysq9wnhOAnqOvX5ZTPqoEuHcnKpdZ7wR2oeF82HKoNk1kdVygR2U0i
         8cqi8WKSOKFdLKXfJSUEjxsSepw5yLXeTsTFPdIhy7lyqwBNnptNdI9MkCan4p69MHFd
         tSIK2ZCvaFmdd+jhazhKXW9NfygSB3JqSfL7vsGAAmGm2m30UviQhk1kJO139+NkapoV
         91TpboyS8Bh6E+ybPx34Yvb3zo7Ed6hd8pPDyrKsX0mBwDCqCE7ZaQP+8u4j+C2G+d9r
         a/SA==
X-Gm-Message-State: ACgBeo21iapGn1W9JHCXtZC1jc4PmBkxtq3LmARRA0ZJSguvETrA6C6m
        1dhMZ/eZivHcLANMAsweks2k7YNJh9d93epamTU=
X-Google-Smtp-Source: AA6agR7jmYMnylg6asONp2GAAfNY5ON6YCWcavS/uvHPv+dbmjW2WszcXZkTVw7T9qXk3bZbqddE9WA58W2wb0oqKUA=
X-Received: by 2002:a05:6638:2381:b0:346:c583:9fa0 with SMTP id
 q1-20020a056638238100b00346c5839fa0mr4410776jat.93.1660953200967; Fri, 19 Aug
 2022 16:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660951028.git.dxu@dxuuu.xyz> <f44b2eebe48f0653949f59c5bcf23af029490692.1660951028.git.dxu@dxuuu.xyz>
 <CAP01T74fSh6Z=54O+ORKJD7i_izb7rUe3-mHKLgRdrckcisvkw@mail.gmail.com>
In-Reply-To: <CAP01T74fSh6Z=54O+ORKJD7i_izb7rUe3-mHKLgRdrckcisvkw@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sat, 20 Aug 2022 01:52:44 +0200
Message-ID: <CAP01T76zWax4YSQO5nP2Kt_85JvUPvxTwpOn5Dho6co32r+FBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/5] bpf: Add support for writing to nf_conn:mark
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sat, 20 Aug 2022 at 01:46, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> CPU 0                                              CPU 1
> sa = READ_ONCE(nf_ct_bsa);
>
> delete_module("nf_conntrack", ..);
>
> WRITE_ONCE(nf_ct_bsa, NULL);
>                                                          // finishes
> successfully
> if (sa)
>     return sa(...); // oops
>

Ew, I completely screwed it up. Not trying again.

CPU 0 does:
sa = READ_ONCE(nf_ct_bsa);
then CPU 1 does:
delete_module("nf_conntrack", ...);
   WRITE_ONCE(nf_ct_bsa, NULL);
then CPU 0 does:
if (sa) sa(...); // bad

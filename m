Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404336ACBDB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCFSDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjCFSDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:03:19 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44996F612
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:02:50 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id cy23so42131500edb.12
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678125766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHiIbvE8ZF8yskiSHfLDDBQes7IipQHv7U2Dux2wiEU=;
        b=aS+ztAEvl5rXUV+bl4aUHKg/JjsEs5Q5O8O5esPopXwbfxpYA6cmA8oaxYHNUlU/xv
         pUDQ2Ag73sCMAC9SLcPIQilnahRnTUpOOhtVRnm6z8j74E8n2sdDsydvWCPi/1J2K4/F
         Y77RZfSte/kHcjeeE//5gW1NADu31WanG7wgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678125766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nHiIbvE8ZF8yskiSHfLDDBQes7IipQHv7U2Dux2wiEU=;
        b=qOT9t7RfUscxAOgokGub6hs/ayGJB/notH7usM1e4DvNZjOvaCMAYV/rpEzD0Bc7uz
         QtY0eGuf3Os8eVH9TuxnNWOSHlF1KQ802K55aSMCMpJkJ2ayRMgqlBpTVlF8ZJ+bCSvr
         9bowAjviblglZWDFBLcDHXuW3DjTwWOOqBHVq3R2YlILNTMesOdNa0XMWxCdbg6WvnGr
         KUF9CGL+KvZ7k8MafgCiPPh+DrvQjt86Fvn1jbB1LyJLSq55e54M0RmYEAL6hOqkocl0
         UJ+oQSrgOp0hkRPlXALA3beqPfcezxC1NfwEdW4fDoWbcU6n+8VkKTVr2cCjZNAk2h7u
         5pwg==
X-Gm-Message-State: AO0yUKXivJMheeuiFYmsOieo4UjHl76S+YIRJ5Ag+uYHJK67pIXjpUlR
        CA4dOTnk6JLKcYjFfD4mtKkZMnz5i0EjeMJuBnQ/ag==
X-Google-Smtp-Source: AK7set8MHL+eopJ4nnL/naCAnifHVVPssklMbJ3P5xITVWQeyVt3H+dsw5Xk7WjI7qJ8MqbFG8ANKg==
X-Received: by 2002:a17:907:d090:b0:8df:e176:483b with SMTP id vc16-20020a170907d09000b008dfe176483bmr11111013ejc.3.1678125765683;
        Mon, 06 Mar 2023 10:02:45 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id oy10-20020a170907104a00b008f398f25beesm4840146ejb.189.2023.03.06.10.02.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 10:02:45 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id a25so42505486edb.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:02:44 -0800 (PST)
X-Received: by 2002:a50:9fa8:0:b0:4ae:e5f1:7c50 with SMTP id
 c37-20020a509fa8000000b004aee5f17c50mr6466912edf.5.1678125764592; Mon, 06 Mar
 2023 10:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com> <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
In-Reply-To: <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 10:02:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj5hFp39ZM7fEtmctwkWdHHnx0X7c2j5Z8L+b18jUgcMQ@mail.gmail.com>
Message-ID: <CAHk-=wj5hFp39ZM7fEtmctwkWdHHnx0X7c2j5Z8L+b18jUgcMQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     tytso@mit.edu, Jason@zx2c4.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 9:47=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The drivers/char/random.c code is very wrong, and does
>
>              if (cpu =3D=3D nr_cpumask_bits)
>                              cpu =3D cpumask_first(&timer_cpus);
>
> which fails miserably exactly because it doesn't use ">=3D".

Turns out this "cpu =3D=3D nr_cpumask_bits" pattern exists in a couple of
other places too.

It was always wrong, but it always just happened to work. The lpfc
SCSI driver in particular seems to *love* this pattern:

        start_cpu =3D cpumask_next(new_cpu, cpu_present_mask);
        if (start_cpu =3D=3D nr_cpumask_bits)
                start_cpu =3D first_cpu;

and has repeated it multiple times, all incorrect.

We do have "cpumask_next_wrap()", and that *seems* to be what the lpcf
driver actually wants to do.

.. and then we have kernel/sched/fair.c, which is actually not buggy,
just odd. It uses nr_cpumask_bits too, but it uses it purely for its
own internal nefarious reasons - it's not actually related to the
cpumask functions at all, its just used as a "not valid CPU number".

I think that scheduler use is still very *wrong*, but it doesn't look
actively buggy.

The other cases all look very buggy indeed, but yes, they happened to
work, and now they don't. So commit 596ff4a09b89 ("cpumask:
re-introduce constant-sized cpumask optimizations") did break them.

I'd rather fix these bad users than revert, but there does seem to be
an alarming number of these things, which worries me:

     git grep '=3D=3D nr_cpumask_bits'

and that's just checking for this *exact* thing.

                Linus

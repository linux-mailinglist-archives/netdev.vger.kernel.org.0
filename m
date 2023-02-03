Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7EC689278
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjBCIjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjBCIjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:39:01 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F12F7EFEF
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:38:57 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id dr8so13240403ejc.12
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUa0q0FEJm5rsyYQXu7ooTn98XDgVOJRNtuFM2rmBvs=;
        b=R0Za0daPBwPcP5iPspRM8PY7sQIVpISqO6VoHUIGVyyB12snXJeHcuFR5XAN1zElKF
         U6NeAdZg+OBTu9lu8+5BWWdJxNexK+is6JX3T26gm/qrRVGujOLfHoUM8+YsnX9XYb4o
         Jq6p1eGLLX6yG9LFtCBgV5vybfqUGimNvpmQ3A/MvCiuulRyIJDtUXjjHrIazPF4wToc
         LKLjdYMF3mfgruJfv5wGNFA8gur/oGLHeq3jML69mY8IqPlel0cKayXjoPt0+dADi0x+
         7ceLpNnvOiPt/DZQk0IUx2GPEk3DZK88FcRKi2O64zQWBt4b3M/aChQsiL+GzI+3FPin
         iAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUa0q0FEJm5rsyYQXu7ooTn98XDgVOJRNtuFM2rmBvs=;
        b=R8vwJnWVQfch5fYM71Aea9DDpRyTVNAgmazY7QxQGq3shSbrpa2CxWTw3zkuwwleN6
         Oeoxha12jFps1YxhZZxlG/M9keEQ02LHLA0Q1RYMLOvH3Wf5huB2YSDAbaN29yA45t4U
         GiEoemumaH0uhthcPlnNYWwISDx5ermvVbxXb+S6/Uf6CaeATUF+D3jZaHta3JcL13sX
         nt5I411srhC3KUEHOnDRy5yex75fOEtaGyFZhZWrT+I+9SO54rjs5O7CTWnnfSabXTwl
         VI5M7o+Urpq6uV6SlzO9IJueYTXiU0EcMLDvudwGI+8KuJ2N9Y2jCzgg5YzeIP5H/Jbu
         pVwg==
X-Gm-Message-State: AO0yUKUR5TJaqkCMGcFfPJ3+FwmS3Xd2zHPcRrCvGiYqLGiaIRakF8QU
        szTVzNskRfYzCxh7Av/P8DlZ4PJftv1cDpUC5tdceBS1ASg=
X-Google-Smtp-Source: AK7set8pNOjEle4oaCLMVSy3IXC7Lq33tLds03cmbCkEsIn/e8AtYBbq9biX+klKzG9oZdBGmenKcZ9JePVLS1WWin0=
X-Received: by 2002:a17:906:7c88:b0:886:5b8d:7fc5 with SMTP id
 w8-20020a1709067c8800b008865b8d7fc5mr2996860ejo.290.1675413535462; Fri, 03
 Feb 2023 00:38:55 -0800 (PST)
MIME-Version: 1.0
References: <OS3P286MB22950EB574F05C341DEEF554F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <378b2fd8ce742cbb1f1d2e958690490b53f5b6da.camel@perches.com>
 <OS3P286MB22958BF0734E62B7661D06E0F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <db14b18de650f0f9c2a207af1432748d853a75e0.camel@perches.com>
In-Reply-To: <db14b18de650f0f9c2a207af1432748d853a75e0.camel@perches.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 3 Feb 2023 09:38:44 +0100
Message-ID: <CAKXUXMwgqTqjWVsRjSM-RatjjpxMmij+KOHruyhijK0DTzJ_Kw@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogbmV0ZGV2L2NoZWNrcGF0Y2ggaXNzdWU=?=
To:     Joe Perches <joe@perches.com>
Cc:     =?UTF-8?B?6Zm2IOe8mA==?= <taoyuan_eddy@hotmail.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 8:29 AM Joe Perches <joe@perches.com> wrote:
>
> On Thu, 2023-02-02 at 23:42 +0000, =E9=99=B6 =E7=BC=98 wrote:
> > Hi, Joe:
> >       Thanks a lot for your time.
> >       I put it in the attachment, in case you prefer plain text content=
 in email, i also append it at the end
> > by the way, could you let me know if the 'netdev/checkpatch' is calling=
 ./scripts/checkpatch.pl
>
> As I have no idea what netdev/checkpatch is, i have no idea.
>
> The checkpatch script in the kernel does not produce an error
> for this input.

Hi Eddy, Hi Joe,

It seems that the netdev/checkpatch is a checkpatch invocation with
some further configuration setup. Unfortunately, I could not find out
the actual setup, probably hidden somewhere in the patchwork
configuration of that instance. Maybe some netdev patchwork
administrator can share the actual command that is invoked here.

However, I can explain the printed error message. By default,
./scripts/checkpatch.pl uses a max_line_length of 100---see
checkpatch.pl line "my $max_line_length =3D 100;". The netdev checkpatch
invocation is overriding that and setting it to 80 characters. When,
you run ./scripts/checkpatch.pl --max-line-length=3D80
net-next-v3-1-1-net-openvswitch-reduce-cpu_used_mask-memory.patch, you
will see the error message that netdev checkpatch shows:

WARNING: line length of 82 exceeds 80 columns
#129: FILE: net/openvswitch/flow.c:110:
+ cpumask_set_cpu(cpu, flow->cpu_used_mask);

total: 0 errors, 1 warnings, 0 checks, 64 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplac=
e.

net-next-v3-1-1-net-openvswitch-reduce-cpu_used_mask-memory.patch has
style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.


So, it is clear that this line, net/openvswitch/flow.c:110, is 82
characters long. So, you counted the characters differently. You need
to consider that a tab counts as 8 characters wide, which in my editor
then leads to a line with 82 characters.

It is up to you and netdev maintainers how to proceed. Checkpatch is
not buggy here, but if you have a line with 82 characters (due to the
many tabs) and you run ./scripts/checkpatch.pl --max-line-length=3D80,
checkpatch rightfully complains to you.

I hope this helps.

Best regards,

Lukas

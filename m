Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F167681FF5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjA3XuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjA3XuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:50:15 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F155F2B28A;
        Mon, 30 Jan 2023 15:50:11 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m8so3533545edd.10;
        Mon, 30 Jan 2023 15:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sZoyIUtWAtZcpfSsfhXbBY+Vrjoh7RxNKH6U/P1EFK4=;
        b=WMphTIX3bJIP7TvChDBHbHVgj2ydL0oNpEjFumSt4MfAiyZ2tLOZZwXmp8Di+w3JWu
         pgA756dAwMWwQABjRWHWN9mT21Zc5yX5lP/AJp3ZWooXFkhmFJSX1Isxu2D9wo88TJPs
         PPlCAthzoBYPaqeOR3XGuUVXNYa79Hccz+jMdiY+PUAwqr32lCqwx+/BDc5nKHpFSJfH
         E4y/Tldk7zZzfjtQzCgT5JI37zJa/BlBQUwXx5OTzr0z12bPxLoDwcyf3PeOHtrOtBuv
         1Gil780Tm6+aih7MGH5U1/HYRKxcxnrgT3oH6XpfeE9Bkc+Cb6a7ygpwx+sYVC1rGL68
         Shyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZoyIUtWAtZcpfSsfhXbBY+Vrjoh7RxNKH6U/P1EFK4=;
        b=Bu0Df7CJU+GQJsbkH4t9+DW+E1uhjseuGcatQSVgdojt1gBk3kpwksRXRouHliPhWM
         lzP7SYZCDxxBI0mM7v1givMuLY4rBs1fDHcTuu7lYr97CvtuOjOHSsnSVm5F5tS6E034
         zpDigJZycdrGGNmHUbmZicOVTcbi61w+5PjMsf9J0QLUIouSPqsnw5ETr+a0eTm7dhij
         /b6wxRfis/zE4fEDqOvCCknvd/K0VCW4NDxurXmckbwqzaWSq/eVKhAOtolJaAVqe5kx
         fwtnLcJvnpieYb0m2vJ03UwUOCpa+400VRTkdMBhrRUBGPPVhilMlOghLoM/9XR3LL4I
         g4Eg==
X-Gm-Message-State: AO0yUKWFJsIBcg3JQp5seuXbXndJPJVNlCgelfSeV+uRBOtOECuccG/o
        ya5tOWjV+QiH0QHThz/r9SDI8Dtfo1/Al8q6HoY=
X-Google-Smtp-Source: AK7set+vByYtVgnIMWdAK297MVxMqlf0pnneoCvrXx5FXrE/ltnXpfV+tlS2q9tMzTCZEYl+9xyfYdZUnS8+52oxbVo=
X-Received: by 2002:a05:6402:b44:b0:4a2:5487:80 with SMTP id
 bx4-20020a0564020b4400b004a254870080mr1230446edb.72.1675122610256; Mon, 30
 Jan 2023 15:50:10 -0800 (PST)
MIME-Version: 1.0
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <560824bd-da2d-044c-4f71-578fc34a47cd@linuxfoundation.org>
 <CAADnVQLV+BERfHNUeii=sZfU+z4WF-jsWUN8aMtzv0tYxh9Rcw@mail.gmail.com> <ae22eee7-eb91-427b-a90a-a5a5e1dc4166@linuxfoundation.org>
In-Reply-To: <ae22eee7-eb91-427b-a90a-a5a5e1dc4166@linuxfoundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Jan 2023 15:49:58 -0800
Message-ID: <CAADnVQKv40TaFDg6tDta=_WtpBdAxZ5SpZUmKjgGHPRtn3f-2Q@mail.gmail.com>
Subject: Re: [PATCH 00/34] selftests: Fix incorrect kernel headers search path
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 3:48 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> >>
> >> These will be applied by maintainers to their trees.
> >
> > Not in this form. They break the build.
>
> Mathieu is sending you the patches in the format you requested in
> the thread on this patch.

It's not the format, but the patch itself is incorrect.

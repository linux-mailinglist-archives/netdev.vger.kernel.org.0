Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B85E273BA6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgIVHVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729755AbgIVHVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:21:39 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAD7C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:21:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r9so18549959ioa.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=gAGQPSeE7HOwYwavskE5e9li4T5ni5I6TXg1XHHwgN0=;
        b=QK9hi1LBH0OZnb4zkiObshcfytpoJJ4ciaMx5q2+zS2w1afApqTgqhSJ+lvLW1i9EU
         QLiSbGv375oLLy6sfUdqIUnWgaIEZDUhvhC14amRK4516zbwlJYP5GyxwkIIXZxBvIqs
         2DytctrtWFtMB04KZ8e9Yakn9bleWxLRoxLd741IJxbxIv4SnhJ/qMsya0B8xxQ8gvOm
         Y456GSuWnpwXs4FadK9oO5F/283BG2wSh4cNdDstlxKVZgJb5G1Q4k72mwr8CEkGN7q9
         nfcwdwUpMBmjRYoYELQ7UX3g/Az/bEHwcixss+nBIjqBRpEeaGz4ve6JM+/rcR/oCjGs
         Am/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=gAGQPSeE7HOwYwavskE5e9li4T5ni5I6TXg1XHHwgN0=;
        b=tGo1BREFylY3H1+ENtwe7mNioGK9ojT4BbSBFnQ2d/ScbZT1D1iVnM7aFvsI8r1F44
         CiadmySWGkjxRMPfai+qsHOgD6jYmsebDKvmqQy7aDigGah1nj5GEMZhT5xNXKHgY4jO
         1vvhsaICefPtdSTBqVHLv3OM6p4z8kZF6HhkKr0AiAPg2dtYs37UNB8u9QqzLjHCei4o
         kJNUQdX2C1xYo2/AhK94wiCQ5LxsbXlM4aeoaUj5XddTP4+hKxA5zq4RpFVRoQQ5qGz3
         kLWRva3/Kx1OHwrZql0Cltr1GWNuCZCPepT94K9qstOvHI8JHT7PYdq7agROL6L83lEW
         W0ww==
X-Gm-Message-State: AOAM533vNj1m6QfYr1aRPXduM6A9wUgIoXZr2SXv39izeCOgNcW7lNMK
        fZjhb/htOFr8UqZ0AEhW4J9CCjZk8M9IgLJkt3w=
X-Google-Smtp-Source: ABdhPJyNTeRASokKND2XKCbpiAO8Og8NwAww+veJHNjbXWWtorTf5yZlctiMw/ttpnDjlYL4B0+FJtjkf0RHk8CZw6s=
X-Received: by 2002:a5e:d716:: with SMTP id v22mr2409056iom.121.1600759298274;
 Tue, 22 Sep 2020 00:21:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5e:8505:0:0:0:0:0 with HTTP; Tue, 22 Sep 2020 00:21:37
 -0700 (PDT)
Reply-To: sararrobrt@gmail.com
In-Reply-To: <CAMu-wEk_QmHeLxJ=oSUruAO_kzFHwff5UcH5mznCe5S5O0nTPA@mail.gmail.com>
References: <CAMu-wEn2vT949DQakX39BZpeSyB=fNBXjB3zy+2gmRQnMiBpfg@mail.gmail.com>
 <CAMu-wEn2M4_85fC8b1ZgXPj9dVNEjHzUNKhsnYBK1GEUXGTBuw@mail.gmail.com>
 <CAMu-wEmO-M0nD6AfVRYve2W3ykpPrfxNVYgAKVcziFPUTzWtPQ@mail.gmail.com>
 <CAMu-wEnutuPe907-qVV+4oXV9e5u9-imw2e6kjHRuETr22KgZw@mail.gmail.com>
 <CAMu-wE=1P=M3b1NW-+=WfdmeqQsJt+5srqFfyf7-e7vG573kxQ@mail.gmail.com>
 <CAMu-wEnBd_3cT-BneTyv5HMo1PT7A00nCQ5FQnF-TtowHHfR9Q@mail.gmail.com>
 <CAMu-wEmcin4ERjsXGQ+g-AwRQ=5U7USRcCnGGO6vks0FuWDApA@mail.gmail.com>
 <CAMu-wEka7FvTuwG0yAK+GCvFu-nie-6NSZ6VoDzXW3+rHvscVw@mail.gmail.com>
 <CAMu-wEmdNqjiWpDq8rieH4Oi39J2NNw1Lw_xhxYFkkmhhjQ1hg@mail.gmail.com>
 <CAMu-wEkoJV-=90pxu265a_UtDu14oUhidQSQczmKBBpWuWqeKA@mail.gmail.com>
 <CAMu-wE=r8AJwc4yoXPyPSdtq4RRWAGjZpHT1Ltyd5jKxz2Ztjw@mail.gmail.com>
 <CAMu-wEnqBGBczC8odwhFXSU9GyhLe3zLpc3jahQ3_eJezoFKnQ@mail.gmail.com>
 <CAMu-wE=ozSqd0+AGdQ-iLH9Ge9mVteZ+YUyG15sXPrXT_8UC=Q@mail.gmail.com>
 <CAMu-wEnBBhJ-gGbFX+8N8wjHWpwbBhOkps5n073ABXZ1VbGQrg@mail.gmail.com>
 <CAMu-wEnQ5bd8mywpfyLOdcFRPhy53+pxMuK7Fw071bV6NAq0MA@mail.gmail.com>
 <CAMu-wEkiY_8q3Vza24N5eyixbHR2Yi7Xj1i9pHWYvjvvWHqNYw@mail.gmail.com>
 <CAMu-wEkJBCthvL+ZLTJW2WEcVCoeEeX+hi4ggyDZVDNsy=vnBg@mail.gmail.com>
 <CAMu-wEncxeUmZ+oeJ3MfiKL0LZxzW-jpCDkk+E=_iwVzMD-hUA@mail.gmail.com>
 <CAMu-wEnQ3SfQRd0GpqVtSoeUTAKw3Rm+crPswF0yRKCgsKWU5Q@mail.gmail.com>
 <CAMu-wEmEVuKWNN-NbFtSRZPCvrLYbuomd1EAYTC0W4Vhbop1wQ@mail.gmail.com>
 <CAMu-wE=cY+PJ94P1bqjTOafCE861uic3O0pnkp73=sBUFEkeXQ@mail.gmail.com>
 <CAMu-wEk4Ey0RfbDVpLPnaQmotYuf=zZ03gOaerSZ3EmVtu61AQ@mail.gmail.com>
 <CAMu-wEkJrV5zjJkGKuRWgvSrTbhJc=6iQ7vzWpXoWstPsNTUfw@mail.gmail.com>
 <CAMu-wEmV0Fw6P_y_b=8A13kShdZ=jc-1ZRL-1HYDGTXWzOw0Vg@mail.gmail.com>
 <CAMu-wE=tsOyuBBRt43MoyKZW5MnUd+5pvfeykLW_1pszkSMhmg@mail.gmail.com>
 <CAMu-wEnL5CiRztkGBcsB5Ltfx9xFRijjX9Ny+1j42JOnNbPRVw@mail.gmail.com>
 <CAMu-wEni0=kLGEa9zY9+o7c+3hpU_c3N10-iOR6eg4ygu4L4MA@mail.gmail.com>
 <CAMu-wEnKn6oiSeb5iv0E0xm2eQVMr6UMPgH2GGHciH6UJG-Faw@mail.gmail.com>
 <CAMu-wEk8XdqZDxLqkAdHDEsdBAYivMk00y3CE8+4Xqw+MuhLwA@mail.gmail.com>
 <CAMu-wEkmq6CprW8WPw0+zGVivAtR0tFE-yu9HnJ7_L7zzN9pPw@mail.gmail.com>
 <CAMu-wEkuhCXa_2ROpaZYYHPRfgm9syAGt6e=ocCEKiAwrz24ow@mail.gmail.com>
 <CAMu-wEmRqr=g9LQpksnKk-j2sX0OwA-648en_fHL2o6gjuPw-w@mail.gmail.com>
 <CAMu-wEnY7Xn4o_7KP+PH37PyH9y-=E5nZx5NEmbYxQJx8NyKcQ@mail.gmail.com>
 <CAMu-wE=pwGSNkinE7j2aQ6TiLP6knfDh6h2qcgfBCC5fGMfjvQ@mail.gmail.com>
 <CAMu-wEnWB3QvkFSGcnERZdtCuczcTYxGKRBkUQyvTk8Ei2gL-Q@mail.gmail.com>
 <CAMu-wE=49y7roQ=GQd3Oap0nB-GQu30MMCrPnGKR9x8ysbk7Kg@mail.gmail.com>
 <CAMu-wEkyU655i_qvu5Z9v_ikYVpjdWhf_hw-gqQKO=PE-fcspA@mail.gmail.com>
 <CAMu-wEmbykf1371nT23xaTkxn6L9tC8CAAPa6pO=M7az5txwsw@mail.gmail.com>
 <CAMu-wE=obY7MobEKrD1rB7Ra9CcGV+91FU8eUeJL4-42UfR2Jw@mail.gmail.com>
 <CAMu-wEnXMTDv8-ENGqNZZVvWCxUxbcW8GhByRFHKHgcSos__nw@mail.gmail.com>
 <CAMu-wE=i8zp+iaCrj+MH40hjJ9-va8nt5+ON--LvLLaiS2xmgw@mail.gmail.com>
 <CAMu-wE=ge+U68=+V0Se2EzG27MOCHTt_++ZjNsOyQ9GLZEzs2Q@mail.gmail.com>
 <CAMu-wE=je-DFkSw=TfeOMd211Y3048D8hj9eQ0uopkNzPbv+Rw@mail.gmail.com>
 <CAMu-wE=jup76mZVmuzUE_F5gQ=eUh5MOPS=jv9UGXkuhjyYyzw@mail.gmail.com>
 <CAMu-wE=00he4xQH+3rcxYuYhwdcppUzJvsscWP3O_vuHvOtfNg@mail.gmail.com>
 <CAMu-wEnTquNyuCZab3vEiZZ-Ct6phmSKPgn_Wz-ctKdBL=YaBA@mail.gmail.com>
 <CAMu-wEmacP9DtEsomBm3AA4W_2UE5tYymnyn0Lr5vkidJOD=ZQ@mail.gmail.com>
 <CAMu-wE=isJqaQqjmnZ440yGgLhXW_A-zZGcfuJU4fw1KQXEpwA@mail.gmail.com>
 <CAMu-wEm9E9Oe4U57=4dMfHKA757wMo3Xkf4fVvYdCMmgTqEx1Q@mail.gmail.com>
 <CAMu-wEn+2EUyhD9ATWiQjuaWkdEeMhmuShqCrADFGHGAu6cz8Q@mail.gmail.com>
 <CAMu-wEkgqZMpEmpj5Re2c9FatiCx+DBkYFQVnk+9kfw2ifFidA@mail.gmail.com>
 <CAMu-wEkGahJ6aC8GAZS-=-cS3YsjjYTJjktoDJ8eOv-4YHSaxg@mail.gmail.com>
 <CAMu-wEkO6OYKA0BKW=Ve521V2JD7KMHRoKvQtHT8cfdEs_d84Q@mail.gmail.com>
 <CAMu-wEmmf7EwxJ6p+hcxqWqNraj+TYVzt01dHBVYZO7umn9V6Q@mail.gmail.com>
 <CAMu-wE=0_EEORaqUSbwFX54W9xs_gg9FpMgrC4ZLA-puGNUY6g@mail.gmail.com>
 <CAMu-wEmk=u7cH4ocj09UY5NmfpAat+bDabMAhT2UzYY9nJK0JA@mail.gmail.com>
 <CAMu-wEkPCAqODx5c=KrSGpmDGSk9SOFfmggaR8pMm04ts7Yu-Q@mail.gmail.com>
 <CAMu-wEm_rw82Ua_PM12hTuoP+xk-wjX6SPtfVo8gBTJMQv12=g@mail.gmail.com>
 <CAMu-wEnqUEEgjNDN5i1O3Ro84=1HKfVp3xsACNsKbsbRu6BTcA@mail.gmail.com>
 <CAMu-wEmdSV2Cife9Eir42mOyO-XZxpXob8uXN_ux--00h7ffNw@mail.gmail.com>
 <CAMu-wEk2=X-iBQMckjB4T5as94SFyyq7-cSVYShAoxb8_yJFNg@mail.gmail.com>
 <CAMu-wEkYnbS=OrGgB4MoAxT_TAKVejfPiw+bJHdNgbCKPfVqYA@mail.gmail.com>
 <CAMu-wE=D3MS+g7ELr-mN7P=JZ16oWJeQ6P6HfDqcqP6xsOf0wA@mail.gmail.com>
 <CAMu-wE=kXstR5DVQ+K_xvp+QBnmXgNB2-7TrfTVPZtDUNP0G6A@mail.gmail.com>
 <CAMu-wEmuimYDszBJ6xumd=R9MtXHA_T5-Y+K=p7r0HDJnzyA6g@mail.gmail.com>
 <CAMu-wEkaOP6QQYvwcRhHO1n8Vdxdh9mE33F45mH6LMYuAgNLRw@mail.gmail.com>
 <CAMu-wEkYuS5Dc-chLojK_Aqd_AMVMsVrTCwc+dQU_3idkX3pCQ@mail.gmail.com>
 <CAMu-wEmiD8VYiDgo1890_0iMkaj58KcjLa23fB93CETRs1aXhQ@mail.gmail.com>
 <CAMu-wEm5H2DHYoEgd6GYJjY5MRjxU41R=jy_+4EoMNch=jo0xw@mail.gmail.com>
 <CAMu-wEnYVp6eB03wEXfeDJ=pcDzf8bYTRGiYG4FNSwYa+ap7cA@mail.gmail.com>
 <CAMu-wEkfm4UBjuptpBHcn09k+HrYmr8Ys9tpaJ3D-42DDn6gwA@mail.gmail.com>
 <CAMu-wEn6Lnw+kk-e55MkbSVbFb2ceMtcaE5ZzxhGreZCrhBakg@mail.gmail.com>
 <CAMu-wEkCuUnTjBhU9v_j3ghY7=J4hVCSwO=WGmAVwbpk3OutMQ@mail.gmail.com>
 <CAMu-wEkfkNc2N5eYwqCV-8qx9x1m5xXeGUFRLSAcpkHhRuG_Pg@mail.gmail.com>
 <CAMu-wEmffbq_fTPYr+GpmrT=4DkQyC--YxsrVj4rFtUTqk_TUw@mail.gmail.com>
 <CAMu-wEkuCe8A9BjYsdrsURD9-4shhpkETqM7+nfHg2dx+GaQUA@mail.gmail.com>
 <CAMu-wEn+h4mDw6GHAcEdUcXspvGmGNEU87HyYihccsPK6_=sLg@mail.gmail.com>
 <CAMu-wE=hugkr8CMcFd-kuiaPP9hgZuKGYKNAwcx+sgLQENRHaw@mail.gmail.com>
 <CAMu-wEk0kNC+g6vWzk=SaxZRvV=UUoq6txx29FTG4dVnDpYA3Q@mail.gmail.com>
 <CAMu-wE=dFUszMtKjftLXVNPY6Wi260WdDaRrY_GoeMmrTP7PQw@mail.gmail.com>
 <CAMu-wEnkQ2XrYUYe+O9uPXV1pqJxjycKSKE-ZzdoZKaKNuZfQg@mail.gmail.com> <CAMu-wEk_QmHeLxJ=oSUruAO_kzFHwff5UcH5mznCe5S5O0nTPA@mail.gmail.com>
From:   "Mrs. Sarah Robert" <mrscelilias@gmail.com>
Date:   Tue, 22 Sep 2020 08:21:37 +0100
Message-ID: <CAMu-wEmVctq6yjgP=z=g1WfGsKUp1_ZTWQg_3MD_brWfmrxB0A@mail.gmail.com>
Subject: Greeting?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Dear,
I'm Mrs. Sarah H. Robert, 77 years old dying widow from Australia;
that was diagnosed of cancer about 4 years ago. I got your details
after an extensive online search Via (Network Power Charitable Trust)
for a reliable person,  I have decided to donate my late husband WILL
valued of ($5,500,000,00) (Five Million Five Hundred Thousand United
States Dollars) to you for charitable goals. Get back to me if you
will be interesting in carrying out this humanitarian project, so that
i can arrange for the release of the funds to you for the work of
charity before entering the surgery theater. Contact me via
E-mail at :  sararrobrt@gmail.com
Sincerely,
Mrs. Sarah H. Robert.

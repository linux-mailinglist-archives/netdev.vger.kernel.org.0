Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07738528D1B
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344891AbiEPSaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344798AbiEPSaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:30:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2948B3E5DD
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:30:00 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so70433wma.4
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=o3mCj59AmOHTKyi6Y1QmoN5No4nKX6xzBB5oYrf6Jgc=;
        b=Jsjh8mA1d5LyB8NCEkRh157hbFF50zYnbJIv7JMQwqVFRDjaCpi0KElfHLHRTs+VMN
         y15SFlGHkRXkPg1MeiiKELaPJSKoPpJH9zWjqYY+qyjlsBOIS6C9U3VBSrCS3MARJDiP
         Pk+9MhRRgX37+HvWOdKgHVcl2pviJRd49M4HXGcnWTMS2gZc23semzsH+Nhp7jC8YovQ
         0RNvIUVlEhQCjuj/zokD1iE2WXECyCxuU/Yk5GUHRZtrje5IYgcn1WVvdyAsZ5+dQn3j
         L2hLboOfID8LzQLKH0ZKQMfXVWXpR1t7c36eALrjaZLK+AAl4RpQqxvcPunOtZXWT4x3
         viPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=o3mCj59AmOHTKyi6Y1QmoN5No4nKX6xzBB5oYrf6Jgc=;
        b=XUC+CYyu2iSN0Fs5a3kKHmpTMN5rLGEQWfuDSQWR3WbI/wkcTRij/ugHRqhEAEE5j7
         gB6iDIHV7sjl/JhE0uTl1pN6lB9oL7pnFvC5r3N7nwF7bNgbq+a5xTZMMvHGkLtDhg/4
         V6DJLxSxRQmlLr66kg7CuGycKUFOgNS++gRlYA+rJ9QWrL3d6GyfekWQF7T9wVxQB2Cj
         mBd3aiAWE32HMetjwlQDl1fFfUZTsPvmrSKNMkwBjNtwhRdCV0dWdTS/zYX1zTvOWR14
         vQVRGs5rmenV08EuPvLdKrA9hlZqKLulOdTwQZgOKIxH35LMbitIU4ScxfOVC47Pfqgw
         HCiw==
X-Gm-Message-State: AOAM530CCwVSmmAAMc5atGogalHKMAqUyMqM5XVqKGW46qpWixp/AD1e
        8GcuQHHGma4iFPT8bT/BMYT7I1LNcIW/msWl0t8=
X-Google-Smtp-Source: ABdhPJzDXWhlhevoPKtHhauv/QsRx7UIfNyRFWQ1JAByy8HS0Oh2ggjbBdZ3AkkGOcaIIZB69MD3NVf3TDITrr2lbaw=
X-Received: by 2002:a05:600c:4ba1:b0:394:9ae3:ee98 with SMTP id
 e33-20020a05600c4ba100b003949ae3ee98mr28390264wmp.160.1652725798519; Mon, 16
 May 2022 11:29:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6020:5e26:b0:1de:2515:ad6b with HTTP; Mon, 16 May 2022
 11:29:57 -0700 (PDT)
Reply-To: moneygramdelome@gmail.com
In-Reply-To: <CAAXvhypPd78SbfFUDH=qugNmiZ5hPCJvOj4ZRHKBaY2YTux1Cg@mail.gmail.com>
References: <CAAXvhyrwsNnSPxR7yj+_4EscLhDQkvDwL=P3T=6VjykGzaZ9kQ@mail.gmail.com>
 <CAAXvhyow3hj_G_oy787TD7Yh0gea7MgG0DhDo5LuM2R4Hs+MPQ@mail.gmail.com>
 <CAAXvhyrf+Bi_bs=CnySJU5xf5LzfKwPRGde_ZgGqWc224Q=-BA@mail.gmail.com>
 <CAAXvhypYLDnUEArH+=tHSjtg83mvHCABbvmeExGNRwQ-dgYm6w@mail.gmail.com>
 <CAAXvhyoSkBMCJ59Tg4x4-DXfGRNu=66CV76bM33zQk1WHWh3iQ@mail.gmail.com>
 <CAAXvhyrQeFL676zrQLAHZw7NuE908VJk64XgvRLLYY10_WiwNA@mail.gmail.com>
 <CAAXvhyqRMOF_s7+_Z97c0poXZxwTi4AxGc8kgxYBqj+eng0i0g@mail.gmail.com>
 <CAAXvhyoXyFCXMwNjt=7MnxTAAh4pHxTT3R0ovumkruD=03bQ6w@mail.gmail.com>
 <CAAXvhypCDw6XunR6W30oVhsVvgrUS1P79oshBe7JpwF=en0oRQ@mail.gmail.com>
 <CAAXvhyqBgJjjCxKmmoD4TjSvp1vbor26LJbDiV4UvhnWEomd9w@mail.gmail.com>
 <CAAXvhyrZZ+XT5PRRtgWYKaAdMq=K9_A06Zr+9+jFpHrtysRSxg@mail.gmail.com>
 <CAAXvhyofWHitmVQMWoeTo80f8-t58dV5vTVL_7VgdnESxG153w@mail.gmail.com>
 <CAAXvhyofd+izzRcxBz0Ki1zFFZwCEOiKqN+NOX1Adr81oq60=Q@mail.gmail.com>
 <CAAXvhypz5qgwey_Oc4eR=hy8x-foTcvk8woZM+yfDW2pH+2LUg@mail.gmail.com>
 <CAAXvhyoS-VaVzyQkaDFL2KJqLYVdOBLCRaVa5=onNubLRLPWaQ@mail.gmail.com>
 <CAAXvhyoSgqcb0DKt7nuvv9vVYtxg5Q_8mJWAcaBZO8zV2_=6Fg@mail.gmail.com>
 <CAAXvhyoVGE5NA2vNnSvtK9ONvikxbrfE93c7KzM9rBnQ-b_nbg@mail.gmail.com>
 <CAAXvhyo1t5GKQFjWBVX1+rMh7MFvCZAvjiptNfmAaJxkrhj1HQ@mail.gmail.com>
 <CAAXvhyrJXu+P1LJosQ7RfYuS1uXm5xia74G_kkrYVugu-G=xCA@mail.gmail.com>
 <CAAXvhyq4QPLGwDMJPDJQ3kxM0bm_QJJ_8q=Zp+8urfS482aJ-w@mail.gmail.com>
 <CAAXvhyrCxaR=bHNyRrEG8TpXx4hGHh3cLTOmQnaX-NOwQjj_PA@mail.gmail.com>
 <CAAXvhyoCVWyHxHHFsygrdV=5+5m0NJ=zKUx6=uT4p=B62h4ZvQ@mail.gmail.com>
 <CAAXvhyoZiOpawNrf4bjGXU_YVL-4qnVW2FhbDCCCRGmdNUhDmA@mail.gmail.com>
 <CAAXvhyonwgGdJ31ztvjX3yTKM2RQ=t=jCCcHOWDa-dqm8NxQuA@mail.gmail.com>
 <CAAXvhyrjQ5i9_gMOP0cj4EYg=1pPvN3-zMc7tXDwSWqugOWWoA@mail.gmail.com>
 <CAAXvhyp826CUE=8pvGzH9v3LDGrBV8aBVktWeCaY7ohjMqOZtQ@mail.gmail.com>
 <CAAXvhyoGxBo-Ksr2nh6tCV4vMH=azzj7UJu7jK6_uTHjKb_-oA@mail.gmail.com>
 <CAAXvhypuM8TpS_pfMGb2ckwoKAPVZRZeVLeaRR=sPotwesGC-A@mail.gmail.com>
 <CAAXvhyo3-wZ-hE6g7kYe6qwmVaWRUXQXupUjfq-rbEoZC8rptg@mail.gmail.com>
 <CAAXvhypWsJq+SWtaFStr0XH+YcY84x9N90zr84S2BfXzvSyS5g@mail.gmail.com>
 <CAAXvhyqfeieNOhvgrRC4RJynGhCqZD7cTVA8wRkxVP=a58fVwA@mail.gmail.com>
 <CAAXvhyovQKsBOF+o30ysLx+_qzWGDO4i8oCtasWg2fTU1Y=k7g@mail.gmail.com>
 <CAAXvhyqzC+NFaosd_oFBs9f-3Rg+Dk+_9d_FYyipRa_8d-+1xg@mail.gmail.com>
 <CAAXvhyrhfynvXMVU18Xj8AhHPQHQK+ADBUfSUF0bnmfiN_JEvQ@mail.gmail.com>
 <CAAXvhypcF5-zCB76+c6f3mHiaxXbByObZMecMhv7OONSJkNfwg@mail.gmail.com>
 <CAAXvhyoM_hOkOpJ6H38w6yf_Fm7akme-ydNFu0+yjfk+px-FwA@mail.gmail.com>
 <CAAXvhyq+ciKCBWCq1v-c=754cEg-sgOh2PSdJuGcpUWwa5H_rA@mail.gmail.com>
 <CAAXvhyq90E-hcBS_o_45CRrGd-pbNmTe9-k_CODiDD4guyRNdg@mail.gmail.com>
 <CAAXvhyrS2sSHHtchaFgWGnGrjHtJ1jFwJ+3U4zuMTFBd9Le+dg@mail.gmail.com>
 <CAAXvhyrQbtyBeYepEJU+7DLiVff-p=upvmvNoZ2F5O5ZTq0ekg@mail.gmail.com>
 <CAAXvhyrBTuqgTdERrnoDDF9y8W8BwiBgr_qi-SxR9a2mGYow5w@mail.gmail.com>
 <CAAXvhyrQW_mw5Vp+sThKfEDs2DXUXPO=xJhi468Wi1-xCPSo6Q@mail.gmail.com>
 <CAAXvhyrW7SCNJK77W1DTcSMzV2uKWSxkTOSp9z6-Cs_tmabDCQ@mail.gmail.com>
 <CAAXvhyr=vmgOfgxg5NkQKdiFS1XyjpXB=x55iN7+i-JOH+UK3A@mail.gmail.com>
 <CAAXvhyqV85228x99OsVJACMB=WQ9mq_Et0PzrCtx1DuJDPAD8Q@mail.gmail.com>
 <CAAXvhyrHiorMG07PoLUt+q76da7DomU5CbEqPTjAKJB7xQj6mQ@mail.gmail.com>
 <CAAXvhyq57eWPx3dHn6U+gukxU7ExVaSW3Q=5pdktPmDaGAO6DQ@mail.gmail.com> <CAAXvhypPd78SbfFUDH=qugNmiZ5hPCJvOj4ZRHKBaY2YTux1Cg@mail.gmail.com>
From:   NISHAN AVEZOV <ezeomor2@gmail.com>
Date:   Mon, 16 May 2022 18:29:57 +0000
Message-ID: <CAAXvhyoThgfaq3NxNdEPEDL+JXPm+FTXB5QuyU-V1PRYwhn34A@mail.gmail.com>
Subject: GOOD DAY MY DEAR?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_50,BIGNUM_EMAILS_FREEM,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FORM,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:341 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ezeomor2[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ezeomor2[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.2 BIGNUM_EMAILS_FREEM Lots of email addresses/leads, free email
        *      account
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello dear how are you today?

In the wake of the global COVID-19 Pandemic, I wish to bring you the
good news of hope. I write to officially inform you that you have been
selected to receive the UN Covid-19 stimulus package worth
$1,700,000.00 USD. The selection process was carried out through the
United Nations (UN) computerized email selection system, from a
database of over 79,980,000 email addresses obtained from all
continents of the world, which your email address was selected from

The United Nations COVID-19 Response and Recovery Fund is a UN
inter-agency fund mechanism established by the UN Secretary-General to
help support low-and middle-income people(s) to respond to the
pandemic and its impacts, including unprecedented sociology -economic
shock. The Fund=E2=80=99s assistance targets those most vulnerable to econo=
mic
hardship and social disruption around the world. Therefore,
you are kindly advised to contact our MoneyGram you'll be receiving
daily payment of  4,500 Euros agent with the below contact
information, to receive your Covid-19 stimulus package worth
$1,700,000.00 USD.

MoneyGram Office Greece you'll be receiving daily payment 4500 Euros?
Please submit
your details for confirmation.

Your full name =3D=3D=3D=3D=3D=3D
Your country =3D=3D=3D=3D=3D=3D
Your phone number =3D=3D=3D=3D=3D=3D
Your city =3D=3D=3D=3D=3D=3D
Your home address =3D=3D=3D=3D=3D=3D

Information about MONEYGRAM OFFICE GREECE is shown below.
MONEYGRAM OFFICE GREECE
Mr :::: Denis Kodjo
MY phone :::: (+30 698 321 8085)
Email ::::  moneygramdelome@gmail.com

Thank you
Mr. Nishan Avezov

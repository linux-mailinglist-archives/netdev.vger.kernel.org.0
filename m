Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A36483FE1
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiADK0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiADK0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:26:20 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103C3C061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 02:26:20 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so5909244otl.8
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 02:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:cc;
        bh=7f0Bjb4CTA9sDf/RhNU0ViDB8ImucRrQA+jdH+nCegM=;
        b=ECqo+4t9yj/JCw4TsgdDNJ25by+m/i5MlHXNsCC6CdU/cpC7Sr7T2u+USe4oxy0RUK
         DtEXcV0ZZ0ZeoF7TvuU112qQ9BMoz8knYPVWTodagIMiO6LuVwjl1HemzZ4wmAyIVSrQ
         0nYlvrKYK3+C287yu8Ynln8k1LKHSVsLyJPEsEn4IuZlUIrQggrNbrYzpS5+c1ZyyJbX
         lRwYK7xTlA/9N9KNljhPQQKP4fpob0+skt1q7NMpmHrlPTTF9b3MlJQFQnUGTYNbfHeQ
         Nel8L1PhCiInAIslF+QdO4UuojhhJR9wxMtFmDdj6+BGBwSWC5yPH5mxCkeS0shDqGXn
         OyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:cc;
        bh=7f0Bjb4CTA9sDf/RhNU0ViDB8ImucRrQA+jdH+nCegM=;
        b=cBsCB5/Je9+gvv1P7dBJ+st3qGX/rXQCVRB/FX5YSG1kVuk2BYhiEfyKGLZqmDLL6x
         JQyQs+S9SXe2gR8s3QD35+VmPe0nDMJGckm0qYyJ3KfQyfkL1DId8adYtJtx5B8agUtc
         wZxcMp0qL/UU3VsO0KyibboYChOBFZW84KMPTKGnmw13zA69oPaLuwG4In/y8sRGhsvb
         M3eIwzpoHximcLAFQZe5alQeFrVQwopDWOmDBx3OClaklL/SlCJb+rDhXHIQ07NogHbt
         EkS6lRPWSeBOPK9m83c/R32ZCGw3A2lFPsK5j2Z69KZOZqGobKYy2pZmWQpdbk56Nlq9
         Fvig==
X-Gm-Message-State: AOAM533ZWPa9Ets3WKkmsfRt3Yf/bzLGnnqeR5Fo97xVzvaWQpzPSvyp
        10PMGjO+bbJWHie3TlD8qSW5d/rkahzSACiX8Kg=
X-Received: by 2002:a05:6830:445:: with SMTP id d5mt34781179otc.229.1641291979440;
 Tue, 04 Jan 2022 02:26:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:3d81:0:0:0:0:0 with HTTP; Tue, 4 Jan 2022 02:26:18 -0800 (PST)
Reply-To: israelbarney287@gmail.com
In-Reply-To: <CAA4TxLAyKdkYvtnoGicGVw=2v_3MYC+kyQmnb1eqJvKta2mTzQ@mail.gmail.com>
References: <CAA4TxLB_0O48tb7FYPetLTfFRFApuazwe4diPK-LA5r_pSDFSA@mail.gmail.com>
 <CAA4TxLDdNvw+2Hag5M8wJvvLLxA4c=jfJD8LFYd5y2oX355C4w@mail.gmail.com>
 <CAA4TxLAq2q5rOmdz+BNFCwEpKiCb3ToChuXVJjXZQn_paP8QGA@mail.gmail.com>
 <CAA4TxLBwiVcfKffqjQLAsCwfWDJnZuPdzP22x3AoXfYeT_1ZHQ@mail.gmail.com>
 <CAA4TxLB9oirLCkm8WzmHYQ7gqaMeNa8TdH2Zom5rQWvxY=y3Fw@mail.gmail.com>
 <CAA4TxLBSeN4rQkx03Mp0worWp0hwOF5jzBtvj9y3Gjd3qWS-Fw@mail.gmail.com>
 <CAA4TxLCG++nX3grA9U6SRQYHnh_sSLHeQ-jmOZSshkGQdhq_HQ@mail.gmail.com>
 <CAA4TxLDf7m65Qam0-KnEjC8UHMWs+v5qLqgaALadCzQppLEdhQ@mail.gmail.com>
 <CAA4TxLDtnaGs1h8mEns13Ue_VPSEoDxHZuAxvWi=wFtqQ+zU1w@mail.gmail.com>
 <CAA4TxLCbRtHY_bMV5uv8uu+RiHohTB8coYYfoOFg3Zcucgi-vw@mail.gmail.com>
 <CAA4TxLDJ4vS5-AvAh_Whc-KCLgrLVf5-HB=jtXaUDuxCeD1U3w@mail.gmail.com>
 <CAA4TxLDASyPdXcuZX-ePKhpOhY=zLZ1VbxKM4zuyp3vSRAuKJg@mail.gmail.com>
 <CAA4TxLByvDMLP1d_hwS5OABaOMeu-UhHMUqTn1C0i10dpEkD9g@mail.gmail.com>
 <CAA4TxLAtcF4dWwh-qEwe-zEBrK0PEsQj93J85k9kYNgis+dmXg@mail.gmail.com>
 <CAA4TxLBdTziA15mvpfhALDuMA6sDd5sWhh1GFjW=6KyB=eFO=w@mail.gmail.com>
 <CAA4TxLCcVOup66ABbmzxLSkY+-sctEN_3GnBECjs=bKSWa0r1A@mail.gmail.com>
 <CAA4TxLDOBB6UP5rZbqppqVr3OpUT7f1fXCRFy7+jtbXZbEXZkw@mail.gmail.com>
 <CAA4TxLBBApFPg2ddqce57Eqe0jakztkC48dYen8pXLz_Tq4rGw@mail.gmail.com> <CAA4TxLAyKdkYvtnoGicGVw=2v_3MYC+kyQmnb1eqJvKta2mTzQ@mail.gmail.com>
From:   israel barney <kristengriest098@gmail.com>
Date:   Tue, 4 Jan 2022 11:26:18 +0100
Message-ID: <CAA4TxLC6wLt9j0wk0AWXqyQ0iFAkhNGpzhDLhSiSYFEQHOgF2w@mail.gmail.com>
Subject: hi
Cc:     israelbarney287@gmail.com
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Permit I talk with you please, is about Mrs. Anna.

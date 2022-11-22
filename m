Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D6634277
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiKVRbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiKVRa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:30:59 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B140378193
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:30:55 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id g12so24617630lfh.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :references:in-reply-to:reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ce0NP0yhJmYwKDNo+UsVVXfSEFkzNycw3c4cnkVJ6mE=;
        b=CwgJYqbgNfbp7U1FTwKeOgVs76d2Cq+dE3CbhLx8VhA0gjyvEvtqS7fPKAIm8T72CF
         Nii+JeT4NjBkYzrpIx4mezmqDNJnXQkf8ObMRy/JBFcw6DxHFiLYvf2UqBzlo1wRgOpC
         Pz3oHyBc3etQaG/F1cxB2Rf4j+0h4KD/xaovk3KdndW04fPo1ysmmVk/l2HXag0zPlj/
         yhSdFxFjbYVNsZ8kbVJ3zQwPUdAuFTH/MIG44vmjC1Yf9Cw2s2ItGw651jLHIsJ5xrj9
         6R1SJsY8Y467dhInqs6azRPXGp4iZKRxEDPsXowwsJBm4D2ryJKQVmzSYPNYjKQ5puxb
         OXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :references:in-reply-to:reply-to:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ce0NP0yhJmYwKDNo+UsVVXfSEFkzNycw3c4cnkVJ6mE=;
        b=n8K9yL40tbOyJ4jv6RC5IFm05mGl5MyHAPsmSOcRVXADwKQ2LOH9Mz3JGNXwbOnBZ7
         vWYnLM5nUmpkKI/3aY89AYKDwF+wxdeAZqkcgl4egvZdJkI/hMPzdvRXPluWlKZGTXqO
         vx+VOLp4TR2/7JD4GCZpQ+I9/KuK1jj/MkoFT+F3VvzkFcI/h/xgw2yzv2EgFr7LFIMc
         A9f/GV8r50oWPX1ckSpfe81xVtQoZyVyp9doRw1+FABSPRA0aZzPeIw2ImzIRXlFXNh4
         Er9Nprgj+KM4iXR/Bhb/G8Hd2HuiIrJHehhJB2JIjJcP4xiSmNLxPiAKUIm2gJXY4dja
         Mpng==
X-Gm-Message-State: ANoB5pkMeR9R9JcM/su8iq2mIAwYO/plP4qU/tiQ2125DNonH8GJymnn
        +58U95ssMQ3PdFZooXVTN7xmtN0rwW7t1BX16ys=
X-Google-Smtp-Source: AA0mqf4IDPWfJOxYW2gkxR3fp6+AusGDrljrT+xe4EM3cyXPIp3a0TNiCp3/SjQUvmQ629f+QIpFrQLjZvxnUJbMbsM=
X-Received: by 2002:a05:6512:250f:b0:4b4:abb4:c34d with SMTP id
 be15-20020a056512250f00b004b4abb4c34dmr3494622lfb.218.1669138253931; Tue, 22
 Nov 2022 09:30:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6500:b11:b0:170:20bb:155a with HTTP; Tue, 22 Nov 2022
 09:30:53 -0800 (PST)
Reply-To: davidtayo2007@gmail.com
In-Reply-To: <CAP_pLnGTuxUNdhthanEP+gy24omEqbcJrtee2wqqg15VX1oXfA@mail.gmail.com>
References: <CAP_pLnFBkPnkCX47NmhiffpJr6DSj2fjaFKdZVnWW3kSCzHn-A@mail.gmail.com>
 <CAP_pLnGzaaSJumUBFYwuvObqrv95HMzH4GNY1=L5EYWSNJe4Ew@mail.gmail.com>
 <CAP_pLnG9WdM7fNpixoAood2njjtmchVvXw4+nnunpX80PsQ=uQ@mail.gmail.com> <CAP_pLnGTuxUNdhthanEP+gy24omEqbcJrtee2wqqg15VX1oXfA@mail.gmail.com>
From:   david tayo <morganb8080@gmail.com>
Date:   Tue, 22 Nov 2022 18:30:53 +0100
Message-ID: <CAP_pLnF5nFH8U1sCwkSwBKmfru6otvKPLacCmtKWr93Cx0JVxA@mail.gmail.com>
Subject: Lieber Freund
To:     davidtayo2007@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lieber Freund

Ich dachte, wenn Sie die Ihnen zugesandten detaillierten Informationen
=C3=BCber den Gesch=C3=A4ftsvorschlag erhalten haben, wenden Sie sich bitte=
 an
mich, es ist sehr wichtig

Vielen Dank
David Tayo

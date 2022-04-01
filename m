Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9D54EE57A
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243572AbiDAAnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243571AbiDAAnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:43:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806F424F29A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 17:42:01 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id f38so2347503ybi.3
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 17:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T+aH4s3B73YFGX6kkuTZiE+PkC6dF7JP+Qk/lqso9Lk=;
        b=g3oMD6fJzNOJ8cWbQWsZf+1h66em24oMTbli/L0GfBvNcUiUHG8fWvMpS+M5uEpSA7
         L1aUS++6665LSl6f3x9lzhYKAWrjj5jYFUe0jW+RYJWKAnVQkLNdh9EdzK19m4uNM2QE
         MqlRi0YjyWj0r+1tFPNwqBsVFM8GTdPtkt3Kaf7k7XLnQYQytLcZxHGHPLzbwF8G8iia
         tGPLIcnvWdaxfpqUeiwnnC19T3+BuraM4XDGfE3yJEq8TCq78ytnrxQOWrz7NoUOq6U9
         M0TEazP+HdkOJPCV5qODm91cWv2Yu48qCtKP9Ak8IElTiK7lDDIOzdqE55i6wZkfW2wD
         I7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T+aH4s3B73YFGX6kkuTZiE+PkC6dF7JP+Qk/lqso9Lk=;
        b=Jt07I/Ugy0zj0iOxsp4gV04S5T9RTfd4OPEsEtXMDFMfjSrCwwx02Gbnkhs1HXVCGz
         bE1gmFPRPib4nCi75NlQ696TnCnT8X31eKEo5FwWAJpD2kLftXJi1uxaepY9shomRSVF
         p6aMFTsLTHGU48QZN4uBvrmzhnZDcK7FRoHndmBiZgshwSvEaG8CxO+wamWF+H033VhP
         6U3IJ1CQQo+ePdT0ss+niXCe3oQheFCP2NskGdJQfCb7A6jrCGMgmAUXWTz4LsF0lsbb
         gMyYID+pamIBihjlFnoCE+bu61KGDrRCTl5SxtWY7k8daCoXzmLL8MeFvztCbm/nE2c4
         FQeQ==
X-Gm-Message-State: AOAM533UKWfsVcoNWPgcz2EEpTmLp+++ynSXPkt6HFmUDvXiUcr02hJn
        S/gMQQT3HT7rS7VcKPH1ZZuKqvE5kN1Lyx4CzcKmhw==
X-Google-Smtp-Source: ABdhPJzO+hJibgNFwPkxqdKK73AhMACKjcWsY5MC2ECXd+RdrUf6vd8YDiTUSKFKOpXcHt4R2WZkSQIuoHtQcazuqt0=
X-Received: by 2002:a25:4003:0:b0:633:8ab5:b93e with SMTP id
 n3-20020a254003000000b006338ab5b93emr6437060yba.387.1648773720439; Thu, 31
 Mar 2022 17:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
 <4b4ff443-f8a9-26a8-8342-ae78b999335b@uls.co.za>
In-Reply-To: <4b4ff443-f8a9-26a8-8342-ae78b999335b@uls.co.za>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 31 Mar 2022 17:41:49 -0700
Message-ID: <CANn89iL203ZuRdcyxh16yKXqxXJW2u+4559DsDFmW=8S+_n7fg@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 5:33 PM Jaco Kroon <jaco@uls.co.za> wrote:

> I'll deploy same on a dev host we've got in the coming week and start a
> bisect process.

Thanks, this will definitely help.

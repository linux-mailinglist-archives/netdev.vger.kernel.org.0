Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7624557891F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiGRSB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbiGRSB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:01:26 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1C42E699
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:01:25 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 70so11335625pfx.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=EPr93hzqtmEu+IYJ2GHYmVIyCRv80KC3J1ZooZISigc=;
        b=Enf7pYJE7MOIDwmMyEDeJQhGGNOoINnRxBUwsJTGSt44Rhhl0ecf26nJv+N79aFdl6
         Hu7SkjKRFkcQBnM9SKtgSrBIcqLvPX6hggj5Yzo4Ebu/RkGtEBqiV2OyiDibbHFBsin4
         32CkcrIZtMembTG68i1geFl5wvhP575dHakOI7NNRrSay2gPfQl/Xh8Bc/WklPdf7A3y
         0bOY7MSZIO/pMwp+cfd0oGN4mN8ccXcKkechpc3P2qamKMg3ww5jVrpgs4gQwZGrDn9l
         80qoARbbdAIocEKI00DiSW5FFxCrDbUEDQiHq/yWGaRABLcRc7KQuR9iy+f0UUDp5a5g
         zIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=EPr93hzqtmEu+IYJ2GHYmVIyCRv80KC3J1ZooZISigc=;
        b=1kh4IeaXjI7d88RbjfRFPub8fHaosoSFs1UNc5L3X43FHW1hwIMcDRJrBPFtQiUmlr
         JxVDMFUQ/uxFSRHnxelCjnPSJHbJ788w0D0LppyZphhvd17eQ/ONcJyz6G4LEDAVK4s7
         5YGal5bNZNl+TGlxuaEXnRLuHv0xrQR/owvCVWE1+tTNghu7JopcFTzROjkO0INB2jdC
         U7jlEV2xnpMrIOEoccmGT3HQA+qacqboB7QiK1uz4Iv0wREEStvJYJN4rP24GmChThUS
         NNoxAUpoBpr5TDt7pmVY1yXqKXynsgWttK7FMkaNNOSsixGAtkLhYCG3kvumInB+bb06
         j3tQ==
X-Gm-Message-State: AJIora/UtNSinib1EPDtGiOWvao9MAxIPWfmnHtmUZDzKJC4ZzFsiCM1
        nHPBId9/aOUkteBCs+FH4Xl6Wg8qYcedTg==
X-Google-Smtp-Source: AGRyM1vpeglwJ4DUAi/qfuN5ULWTHSY8zDhRICHTSc9dtyx9+vLnBM6UlSa4ACl9/XqFXjQc2imqjQ==
X-Received: by 2002:a63:1c6:0:b0:412:a989:34f4 with SMTP id 189-20020a6301c6000000b00412a98934f4mr26191227pgb.72.1658167284482;
        Mon, 18 Jul 2022 11:01:24 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w128-20020a626286000000b005254535a2cfsm9582413pfb.136.2022.07.18.11.01.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:01:22 -0700 (PDT)
Date:   Mon, 18 Jul 2022 11:01:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216259] New: Setting SO_OOBINLINE after receiving OOB data
 over TCP can cause that data to be received again
Message-ID: <20220718110119.17365d11@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 18 Jul 2022 17:34:38 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216259] New: Setting SO_OOBINLINE after receiving OOB data ov=
er TCP can cause that data to be received again


https://bugzilla.kernel.org/show_bug.cgi?id=3D216259

            Bug ID: 216259
           Summary: Setting SO_OOBINLINE after receiving OOB data over TCP
                    can cause that data to be received again
           Product: Networking
           Version: 2.5
    Kernel Version: 5.17.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: zfigura@codeweavers.com
        Regression: No

Created attachment 301451
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301451&action=3Dedit =
=20
test program demonstrating the bug

I'm not sure if this is a bug=E2=80=94I haven't fully read specs and perhap=
s it's
within spec for OOBINLINE or TCP or something=E2=80=94but it certainly look=
s like one.

The attached test program demonstrates the bug, and probably more clearly t=
han
any verbal description. It sends and receives a byte of OOB data over a
(loopback) socket pair, sets the receiving socket to SO_OOBINLINE, and then
calls recv() again (without MSG_OOB). This results in the same byte being
received again.

If on the other hand a recv() call is made before setting SO_OOBINLINE [gua=
rded
out with if(0)], the offending call does not succeed, which heightens my
suspicion that this is a bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.

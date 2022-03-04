Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCA64CCD5A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiCDFki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiCDFkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:40:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF2114FBF4
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:39:50 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t19so3258206plr.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 21:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nAXDm5r+VMkMo67lInEL9jNx4jlNDkfjmR2ELYuab1k=;
        b=j0bHF546udUxGqYh8Qc1p39MKrP+6kES9emg0CsOeUIuGSmUy+Uo322iyZ2O01gyr5
         sZuT6vHeZmHV7ONYOLjOiVF6azmGROw7NoXaAFMQ+fwzzk0lyCjfXaovVeU44YMlXGPA
         8WDZWlQ+i8BWxSQsS9ORLKvuPpXScK8moRrkHS4VsRjUeHPmL4skKMemDvkdRmmY8pNS
         UGe9mdCAqrW96kUNYC78xAl+rqU10HcRucqIfFdHxekBE91pB69Svh5S9SlJQJvroMyh
         Pzxi9qZNSCYATyY3NnS8JsnFaqM/lUZ7sCrMhtHs8ag+dE6ZTmNUAw0QmmPp+DLbD6Q9
         WgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nAXDm5r+VMkMo67lInEL9jNx4jlNDkfjmR2ELYuab1k=;
        b=zDPmOMlrVMPD6jBwSChQiNFkdTklHlSTxk5TVxLm0i6RYFoJGTf5aGAqltDcyS1yyG
         NkdNAt7J7vseWorIC8yzu7+As1PoaQxwDeyhDdZJsMR0r2ggtFJguCQpWPAipe3Ywra5
         OJNJqsN1bNXvr3JAZt9Cn98ZYb5vM14y3CBa09ORQZ2BCzlP9L27/MXPFUzRBzirKwmC
         kd/MdqzDbAL6yz5r2m9+qrnr6TsqtA95CUtIGEZ71N4bcrnn/mf/wNneIRe7f4g8deCM
         4t4/em+UxNe7cflA9etWW+MPORbUuNfohO+pcAulTDlXuhmZ+CVSHHJRLtoL7mgIqPbK
         OYUQ==
X-Gm-Message-State: AOAM533XqZnpxZl/zQhudM/t8VbRRNeBoG37by0RcRmJMgv478fAyAUt
        Mv/mhQKCUlvwFzSCdZtKrGY=
X-Google-Smtp-Source: ABdhPJzn+HwvVJO+VUPQ7JSYWM48qD5q02Tk2Ty0hzhPP63atnHNtIX8HgAAT6ciUCrUdEh2oHE0dQ==
X-Received: by 2002:a17:902:8b8a:b0:151:7777:221c with SMTP id ay10-20020a1709028b8a00b001517777221cmr19385428plb.56.1646372390447;
        Thu, 03 Mar 2022 21:39:50 -0800 (PST)
Received: from [100.127.84.93] ([2620:10d:c090:400::5:778f])
        by smtp.gmail.com with ESMTPSA id h3-20020a056a00170300b004f104c635e4sm4382811pfc.99.2022.03.03.21.39.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Mar 2022 21:39:49 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for accessing
 eeprom
Date:   Thu, 03 Mar 2022 21:39:48 -0800
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
In-Reply-To: <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
 <20220303233801.242870-4-jonathan.lemon@gmail.com>
 <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3 Mar 2022, at 21:01, Jakub Kicinski wrote:

> On Thu,  3 Mar 2022 15:38:00 -0800 Jonathan Lemon wrote:
>> manufacturer
>
> The generic string is for manufacture, i.e. fab; that's different
> from manufacture*r* i.e. vendor. It's when you multi-source a single
> board design at multiple factories.

The documentation seems unclear:

board.manufacture
-----------------
An identifier of the company or the facility which produced the part.


There isn’t a board.vendor (or manufacturer) in devlink.h.

The board design is open source, there’s several variants of
the design being produced, so I’m looking for a simple way to
identify the design (other than the opaque board id)
—
Jonathan

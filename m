Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398C94B58B2
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357161AbiBNRjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:39:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344265AbiBNRjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:39:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22D865427
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:39:43 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id z16so8558804pfh.3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=tWeBivdFQWK4tciH9zAFPTd1KwaCUjbhdlyIMnERNgk=;
        b=sYUmPzUzjav/Ox1LzvEyKSnXsNYjer7aIdmc5hHXcp3cnpOzK9K4qabjOu5dp1CIt7
         LJ+TrLcxj8+0QrfkPJsSYFZDlUb5Gqdopjm8ZXe0T3OcuIKmrCxr9EYKMgV2wJSGNJvC
         km96oFPoxmZuV4pXCXUbIjUJPKoGN4UOwSr5FrlLEy28J1Y3BMexMtncgwHv32EJVBND
         quxfAbvFavkOUMQ5AKOrSqC+qoC6hjk6Cp0EL2KmJKRqmg47VC94yjssEqhQsjPeG9hc
         Lh1/gIQmDFkhkT81uCD0pg7JoozfpCYFMHpndfoIgcdP9Ja7W+5gAWjvS0+IOaqMmqKL
         LphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=tWeBivdFQWK4tciH9zAFPTd1KwaCUjbhdlyIMnERNgk=;
        b=Ze5ETaz8DzqTFOYmm2D6TE8DT1X5YR+WUiIGqd4DwPrG52Q8u9e9MT97J4OTXWzq6R
         RV8oSHyxe9D3Sm32Lfoa0vIDaKOT4fOD5VG2zsPZqBEylymx2Lfw5dxQqMoBG3sKEKfb
         AK553DjYIjj5s3LIENW9IpQ8MoqadhLt9+2Ak8m03QTceyBCfIOf5s3kQ8kqiLJhpdn/
         FCciDNSmfxR8P5A4/wPedTcPOAr+mqOjqFqhOBDWSe+8PYyX2se6+cTEQShX1E+h2o5e
         PZD//eR4hGFhl5i4WdjTbbUpwL0+ZLyHD3+bP5E9vl6y3uumIy3QXVwxjIhw6jcndH2X
         Jmfg==
X-Gm-Message-State: AOAM532fYObqjuOyQRTxn/WEHhNWr/ruskrPyAoDklZoAa602p9jch0I
        lRA5QY6Jd4XG4Ebh0ZzRvHRoUL9Rj2RFsji1
X-Google-Smtp-Source: ABdhPJwjxidPYMFqEBx0sRho1Dj9lM3XkXL2IVNiWwHC2Gpx1pa1zurlCkXzJODo6S6YzHW3m2zcsw==
X-Received: by 2002:a05:6a00:1a87:: with SMTP id e7mr644518pfv.84.1644860383186;
        Mon, 14 Feb 2022 09:39:43 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id pi9sm1953928pjb.23.2022.02.14.09.39.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 09:39:42 -0800 (PST)
Date:   Mon, 14 Feb 2022 09:39:39 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215599] New: System freeze after add mirror rule from
 traffic control
Message-ID: <20220214093939.3874f25a@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 12 Feb 2022 21:16:42 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215599] New: System freeze after add mirror rule from traffic control


https://bugzilla.kernel.org/show_bug.cgi?id=215599

            Bug ID: 215599
           Summary: System freeze after add mirror rule from traffic
                    control
           Product: Networking
           Version: 2.5
    Kernel Version: 5.16.5-arch1-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

The rule:
tc qdisc add dev eth1 handle ffff: ingress
tc filter add dev eth1 parent 1: flower src_mac 22:22:22:22:22:22 action mirred
ingress mirror dev gretap-test0

System freezes after creating the rule from container.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
